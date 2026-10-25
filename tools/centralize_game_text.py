"""One-time text migration; source editing only, never executes Godot."""
from pathlib import Path
import ast
import json
import re
import sys
from build_text_inventory import TOKEN

ROOT = Path(__file__).resolve().parents[1]
FILES = ["title", "hud", "hud_details", "game_state", "save_store", "player", "tiptop", "tutorial", "desk", "showcase", "rules_text"]
INTERNAL = {"Judy", "TipTop", "System", "Judy: ", "TipTop: ", "Player", "Visual", "Desk", "Sink", "Bed", "Bookshelf", "PlantPot", "Fridge", "CoffeeTable", "Floor", "Walls", "HUD", "CollisionShape2D", "InteractionZone", "PromptLabel", "ResearchLabel", "DayLabel", "TimeLabel", "NotificationPanel", "FramingCamera", "AudioStreamWAV", "Master", "SFX", "Ambience", "Music", "RobotMovement", "Label", "Button", "BaseButton", "Control"}
LABELS = {"AM", "PM", "Easy", "Medium", "Hard", "Well-fed", "Normal", "Hungry", "Monday", "Tuesday", "Wednesday", "Repaired", "Faulty", "Research", "Efficiency", "Fullness", "Mood", "Eating", "Leisure", "Repairs", "Cleanup", "Misc", "Sleep", "Settings", "Continue", "Showcase", "Start", "Skip", "Resume", "Fullscreen", "Paused", "Cancel", "Back", "Next", "Reels"}
FORMAT = re.compile(r"%(?:[-+0 #]*\d*(?:\.\d+)?[sdif])|%%")


def extract(source):
    function = "defaults"
    offsets = []
    for line in source.splitlines():
        if re.match(r"(?:static )?func ", line):
            function = line.split("(", 1)[0].replace("static ", "").replace("func ", "")
        offsets.append((function, line))
    for match in TOKEN.finditer(source):
        if match.group("string"):
            number = source.count("\n", 0, match.start()) + 1
            yield match, ast.literal_eval(match.group()), number, *offsets[number - 1]


def visible(value, line, match, source):
    if not value.strip() or value in INTERNAL or re.fullmatch(r"[0-9a-fA-F]{6,8}", value):
        return False
    if value.startswith(("res://", "user://", "../")) or source[match.end():].lstrip().startswith(":"):
        return False
    if any(x in line for x in ["push_error(", "push_warning(", "sentences.compile("]):
        return False
    before = source[source.rfind("\n", 0, match.start()) + 1:match.start()]
    if re.search(r"(?:\.get\(|\.get_meta\(|\.set_meta\(|\.get_theme_font\(|get_node\(|has_node\()\s*$", before):
        return False
    return value in LABELS or (bool(re.search(r"[A-Za-z]", value)) and (bool(re.search(r"\s", value)) or value.endswith("...")))


def category(stem, function):
    if stem == "title":
        return "settings" if function == "_show_settings" else "main_menu"
    if stem == "hud":
        if function in {"_on_story_event", "talk_to_tiptop"}:
            return "dialogue"
        if "research" in function or "activity_controls" in function:
            return "research"
        if "repair" in function or "malfunction" in function:
            return "tiptop"
        return "activities" if "household" in function or "eject" in function else "hud"
    return {"game_state": "notifications", "hud_details": "hud", "player": "interactions", "showcase": "endings", "save_store": "save_load", "tiptop": "tiptop", "tutorial": "tutorial", "rules_text": "rules"}.get(stem, "interactions")


def expression_end(source, start):
    depth, cursor = [], start
    tokens = {m.start(): m for m in TOKEN.finditer(source, start)}
    while cursor < len(source):
        if cursor in tokens:
            token = tokens[cursor]
            if token.group("comment"):
                return cursor
            cursor = token.end()
            continue
        char = source[cursor]
        if not depth and (char in ",)]}\r\n" or source.startswith(" if ", cursor) or source.startswith(" else ", cursor)):
            return cursor
        if char in "([{":
            depth.append(char)
        elif char in ")]}":
            depth.pop()
        cursor += 1
    return cursor


def main():
    apply = "--apply" in sys.argv
    texts, by_value, changes = {}, {}, []
    for stem in FILES:
        path = ROOT / ("data" if stem == "rules_text" else "scripts") / (stem + ".gd")
        source = path.read_text(encoding="utf-8-sig")
        patches = []
        for match, value, number, function, line in extract(source):
            if not visible(value, line, match, source):
                continue
            group = category(stem, function)
            slug = re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_")[:62].rstrip("_")
            identifier = by_value.get(value, group + "." + slug)
            if identifier in texts and texts[identifier]["original"] != value:
                identifier += "_2"
            by_value[value] = identifier
            entry = texts.setdefault(identifier, {"original": value, "text": value, "variables": {}, "order": [], "where": []})
            entry["where"].append(f"{path.relative_to(ROOT).as_posix()}:{number} {function}")
            percent = re.match(r"\s*%\s*", source[match.end():])
            end = match.end()
            if percent:
                rhs_start = end + percent.end()
                end = expression_end(source, rhs_start)
                rhs = source[rhs_start:end].rstrip()
                end = rhs_start + len(rhs)
                formats = [m.group() for m in FORMAT.finditer(value) if m.group() != "%%"]
                names = [f"value_{i + 1}" for i in range(len(formats))]
                index = iter(names)
                entry["text"] = FORMAT.sub(lambda m: "%" if m.group() == "%%" else "{" + next(index) + "}", value)
                entry["variables"] = dict(zip(names, formats))
                entry["order"] = names
                replacement = f'GameText.format_text("{identifier}", {rhs})'
            else:
                replacement = f'GameText.get_text("{identifier}")'
            patches.append((match.start(), end, replacement))
            changes.append(f"{stem}:{number} {value!r}")
        for start, end, replacement in sorted(patches, reverse=True):
            if not any(a < start < b for a, b, _ in patches):
                source = source[:start] + replacement + source[end:]
        if apply:
            path.write_text(source, encoding="utf-8")
    if apply:
        destination = ROOT / "data/text"
        destination.mkdir(parents=True, exist_ok=True)
        groups = {}
        for identifier, entry in texts.items():
            del entry["original"]
            groups.setdefault(identifier.split(".")[0], {})[identifier] = entry
        for group, entries in groups.items():
            (destination / (group + ".json")).write_text(json.dumps(entries, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("\n".join(changes))
    print(f"{len(texts)} entries / {len(changes)} occurrences")


if __name__ == "__main__":
    main()
