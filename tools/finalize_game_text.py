"""Finish source bindings and generate reference documentation, without Godot."""
import json
import re
from centralize_game_text import ROOT, FILES, TOKEN


def main():
    records = {}
    for path in (ROOT / "data/text").glob("*.json"):
        records.update(json.loads(path.read_text(encoding="utf-8")))

    def add(identifier, text, variables=None):
        records[identifier] = {"text": text, "variables": variables or {}, "order": list(variables or {}), "where": []}

    add("dialogue.occasionally", "Occasionally?")
    add("main_menu.window_title", "its-probably-fine")
    replacements = {
        "scripts/hud.gd": {'"Occasionally?"': 'GameText.get_text("dialogue.occasionally")'},
        "scripts/title.gd": {'["tiptop", "TipTop",': '["tiptop", GameText.get_text("dialogue.speaker_tiptop"),'},
    }
    for relative, mapping in replacements.items():
        path = ROOT / relative
        source = path.read_text(encoding="utf-8")
        for old, new in mapping.items():
            source = source.replace(old, new)
        path.write_text(source, encoding="utf-8")

    # Scene defaults resolve during each Control's ready signal. Keep node paths,
    # dimensions, script references and connection declarations unchanged.
    for path in (ROOT / "scenes").glob("*.tscn"):
        source = path.read_text(encoding="utf-8")
        node_name = "root"
        output = []
        for line in source.splitlines(True):
            match = re.match(r'\[node name="([^"]+)"', line)
            if match:
                node_name = match.group(1)
            match = re.match(r'(text|tooltip_text|accessibility_name|accessibility_description) = (".*")\s*$', line)
            if match:
                value = json.loads(match.group(2))
                if value and not value.startswith("@"):
                    identifier = "interactions.scene_" + path.stem + "_" + re.sub(r"[^a-z0-9]", "_", node_name.lower()) + "_" + match.group(1)
                    add(identifier, value)
                    line = match.group(1) + " = " + json.dumps("@" + identifier) + "\n"
            output.append(line)
        rendered = "".join(output)
        if rendered != source:
            path.write_text(rendered, encoding="utf-8")

    # Give common dynamic fields meaningful names; array order preserves the
    # existing calculation expressions while names can be reordered in prose.
    semantic = {
        "hud.research_1f": ["progress"], "hud.day_d": ["day"],
        "hud.d_02d_s": ["hour", "minute", "period"],
        "hud.dh_02dm_left": ["hours", "minutes"], "hud.dh_02dm": ["hours", "minutes"],
        "hud.showcase_in_dh_02dm_playable": ["hours", "minutes"],
        "hud.work_sessions_d_4": ["sessions"], "hud.tiptop_d_4_fixed": ["repaired"], "hud.d_4_repaired": ["repaired"],
        "hud.full_d": ["fullness"], "hud.mood_d": ["mood"],
        "activities.sessions_d_used_d_d_left": ["used", "remaining", "limit"],
        "activities.efficiency_d_reward_1f_research_s": ["efficiency", "reward", "modifier"],
        "activities.s_d_game_min_watch_1f_real_min": ["difficulty", "duration", "watch_minutes"],
        "tiptop.s_s_d_min_0f": ["routine", "status", "duration", "reward"],
        "endings.research_1f_routines_repaired_d_4": ["progress", "repaired"],
        "notifications.research_complete_1f_d_min_d_session_s_left": ["gain", "duration", "sessions"],
        "settings.s_d": ["bus", "volume"],
    }
    for identifier, names in semantic.items():
        if identifier not in records:
            continue
        entry = records[identifier]
        previous = entry["order"]
        if len(previous) != len(names):
            continue
        formats = entry["variables"]
        for old, name in zip(previous, names):
            entry["text"] = entry["text"].replace("{" + old + "}", "{" + name + "}")
        entry["variables"] = {name: formats[old] for old, name in zip(previous, names)}
        entry["order"] = names

    # Recompute current use sites from actual source, rather than stale offsets.
    call = re.compile(r'GameText\.(?:get_text|format_text)\("([^"]+)"')
    for entry in records.values():
        entry["where"] = []
        if entry.get("audio_cue") == "click":
            entry.pop("audio_cue")
    for path in sorted([*ROOT.glob("scripts/*.gd"), *ROOT.glob("data/*.gd"), *ROOT.glob("scenes/*.tscn")]):
        source = path.read_text(encoding="utf-8")
        context = "initial values"
        for number, line in enumerate(source.splitlines(), 1):
            if re.match(r"(?:static )?func ", line):
                context = line.split("(")[0].replace("static ", "").replace("func ", "")
            if line.startswith("[node "):
                context = line
            identifiers = [m.group(1) for m in call.finditer(line)]
            identifiers += re.findall(r'"@([^"]+)"', line)
            if path.name == "rules_text.gd" and line.startswith("const "):
                identifiers += re.findall(r':= "([^"]+)"', line)
            for identifier in identifiers:
                if identifier in records:
                    records[identifier]["where"].append(f"{path.relative_to(ROOT).as_posix()}:{number} {context}")
    families = {"tiptop.routine.": "Runtime chore name; hud.gd and game_state.gd", "tiptop.routine_lower.": "Runtime chore name in conversations and cleanup", "settings.bus.": "title.gd:_show_settings", "dialogue.speaker_": "hud.gd:_advance_dialogue and speaker display"}
    for identifier, entry in records.items():
        for prefix, use in families.items():
            if identifier.startswith(prefix):
                entry["where"].append(use)
        if identifier == "main_menu.window_title":
            entry["where"].append("game_text.gd:_ready / native window caption")
    # Drop only unused generated RECORDS, never project files or assets.
    records = {key: entry for key, entry in records.items() if entry["where"]}
    groups = {}
    for identifier, entry in sorted(records.items()):
        groups.setdefault(identifier.split(".")[0], {})[identifier] = entry
    for group, entries in groups.items():
        (ROOT / "data/text" / (group + ".json")).write_text(json.dumps(entries, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    def cell(value):
        return str(value).replace("&", "&amp;").replace("<", "&lt;").replace("|", "&#124;").replace("\n", "<br>").replace("`", "&#96;")
    doc = ["# Complete game text reference\n\nEdit the JSON `text` fields, not the source bindings. Names in braces are live values. `order` preserves the existing positional binding; `variables` preserves numeric formatting. Canonical speaker/tag/audio metadata is not prose. Some entries are fragments concatenated into complete labels. [Editing instructions](HOW_TO_EDIT_GAME_TEXT.md).\n\n"]
    for group, entries in groups.items():
        doc.append(f"## {group}\n\n| Text ID | Current text | JSON file | Where it appears | Variables |\n|---|---|---|---|---|\n")
        for identifier, entry in entries.items():
            variables = ", ".join(f"{key}: {value}" for key, value in entry["variables"].items()) or "—"
            speaker = f" (speaker: {entry['speaker']})" if entry.get("speaker") else ""
            doc.append(f"| `{identifier}` | {cell(entry['text'])}{speaker} | `data/text/{group}.json` | {cell('; '.join(entry['where']))} | {cell(variables)} |\n")
        doc.append("\n")
    doc.append(f"Total: {len(records)} active text records in {len(groups)} JSON files. Source references are a static snapshot; runtime behavior has not been tested.\n")
    (ROOT / "docs/COMPLETE_TEXT_REFERENCE.md").write_text("".join(doc), encoding="utf-8")
    print(f"{len(records)} active strings in {len(groups)} JSON files")


if __name__ == "__main__":
    main()
