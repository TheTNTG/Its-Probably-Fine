"""Step 48.1 source/data adjustments. Does not run the game or tests."""
from pathlib import Path
import json
import re
from centralize_game_text import ROOT, FILES, extract, visible


def main():
    records = {}
    for path in (ROOT / "data/text").glob("*.json"):
        records.update(json.loads(path.read_text(encoding="utf-8")))
    simple = {entry["text"]: identifier for identifier, entry in records.items() if not entry["order"]}

    def add(identifier, text, where, variables=None):
        if text in simple and not variables:
            return simple[text]
        records[identifier] = {"text": text, "variables": variables or {}, "order": list(variables or {}), "where": [where]}
        simple[text] = identifier
        return identifier

    for stem in FILES:
        path = ROOT / ("data" if stem == "rules_text" else "scripts") / (stem + ".gd")
        source = path.read_text(encoding="utf-8")
        patches = []
        for match, value, number, function, line in extract(source):
            if visible(value, line, match, source):
                if value in simple:
                    patches.append((match.start(), match.end(), f'GameText.get_text("{simple[value]}")'))
                else:
                    print(f"REVIEW {stem}:{number} {value!r}")
        for start, end, replacement in sorted(patches, reverse=True):
            source = source[:start] + replacement + source[end:]
        # These structures contain presentation copy, so resolve at construction
        # rather than illegally placing runtime lookups in constant expressions.
        for name in ["DIFFICULTIES", "NAMES", "TITLES", "APPROACH_THOUGHTS", "FAULTY_WORK_THOUGHTS", "REPAIRED_WORK_THOUGHTS", "FAULTY_REACTIONS", "REPAIRED_REACTIONS"]:
            source = source.replace("const " + name + " :=", "var " + name + " :=")
        if stem == "rules_text":
            source = re.sub(r'const (\w+) := GameText.get_text\("([^"]+)"\)', r'const \1 := "\2"', source)
        path.write_text(source, encoding="utf-8")
    path = ROOT / "scripts/rules_intro.gd"
    source = path.read_text(encoding="utf-8")
    source = re.sub(r"COPY\.([A-Z_]+)", r"GameText.get_text(COPY.\1)", source)
    source = source.replace('"%d / %d" % [page_index + 1, pages.size()]', 'GameText.format_text("rules.page_count", [page_index + 1, pages.size()])')
    add("rules.page_count", "{page} / {pages}", "scripts/rules_intro.gd:_show_page", {"page": "%d", "pages": "%d"})
    path.write_text(source, encoding="utf-8")

    extras = {
        "dialogue.speaker_judy": "Judy", "dialogue.speaker_tiptop": "TipTop", "dialogue.speaker_system": "System",
        "hud.needs": "Needs", "hud.checklist_heading": "TipTop",
        "tiptop.routine.sink": "Sink", "tiptop.routine.plant": "Plant", "tiptop.routine.bookshelf": "Bookshelf", "tiptop.routine.bed": "Bed",
        "tiptop.routine_lower.sink": "sink", "tiptop.routine_lower.plant": "plant", "tiptop.routine_lower.bookshelf": "bookshelf", "tiptop.routine_lower.bed": "bed",
        "tiptop.routine_repair.sink": "Water / sink", "endings.restart": "Restart",
        "settings.bus.master": "Master", "settings.bus.sfx": "SFX", "settings.bus.ambience": "Ambience", "settings.bus.music": "Music",
    }
    for identifier, text in extras.items():
        # Intentionally distinct IDs for technical identities versus labels.
        records.setdefault(identifier, {"text": text, "variables": {}, "order": [], "where": ["Display name binding; internal identifier unchanged"]})
    add("hud.percentage", "{value}%", "scripts/hud.gd:needs/efficiency values", {"value": "%d"})
    add("hud.checklist_pending", "□ {routine}", "scripts/hud.gd:_update_sidebar", {"routine": "%s"})

    # Keep cue classification and consequence triggers independent of wording.
    for identifier, entry in records.items():
        text = entry["text"]
        lower = text.lower()
        entry["audio_cue"] = "cancel" if any(word in lower for word in ["cancel", "back", "main menu", "return"]) else ("resume" if "resume" in lower else ("confirm" if any(word in lower for word in ["begin", "continue", "watch research", "new game"]) else "click"))
        tags = []
        if "not enough time" in lower or "full repair needs" in lower:
            tags.append("insufficient_time")
        if "mosquito" in lower:
            tags.append("mosquito")
        if tags:
            entry["tags"] = tags
        for speaker in ["Judy", "TipTop"]:
            if text.startswith(speaker + ": ") and not identifier.startswith("hud.tiptop_d"):
                entry["text"] = text.removeprefix(speaker + ": ")
                entry["speaker"] = speaker
    groups = {}
    for identifier, entry in records.items():
        groups.setdefault(identifier.split(".")[0], {})[identifier] = entry
    for group, entries in groups.items():
        (ROOT / "data/text" / (group + ".json")).write_text(json.dumps(entries, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{len(records)} records prepared")


if __name__ == "__main__":
    main()
