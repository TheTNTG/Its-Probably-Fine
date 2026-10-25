"""Documentation only: inventory source literals without running Godot or gameplay."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TOKEN = re.compile(r'(?P<string>"""[\s\S]*?"""|\'\'\'[\s\S]*?\'\'\'|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\')|(?P<comment>\#[^\n]*)')


def cell(value):
    return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("|", "&#124;").replace("\r", "\\r").replace("\n", "\\n").replace("`", "&#96;")


def classify(raw, line):
    text = raw[1:-1]
    if not text or re.fullmatch(r"[0-9a-fA-F]{6,8}", text):
        return False
    if text.startswith(("res://", "user://", "../", "sfx/")):
        return False
    if any(marker in line for marker in ["text =", "_label(", "_button(", "_hud_text(", "_paragraph(", "_offer(", "tooltip", "accessibility_", "action_feedback.emit(", "show_monologue("]):
        return True
    return bool(re.search(r"[A-Za-z]", text)) and (" " in text or "\\n" in text or "%" in text or text[:1].isupper())


def build():
    files = sorted([*ROOT.glob("scripts/*.gd"), *ROOT.glob("data/*.gd"), *ROOT.glob("scenes/*.tscn"), *ROOT.glob("themes/*.tres"), ROOT / "project.godot"])
    primary, technical = [], []
    total = 0
    for path in files:
        source = path.read_text(encoding="utf-8-sig")
        lines = source.splitlines()
        contexts = {}
        context = "file constants / initial values"
        for number, line in enumerate(lines, 1):
            if re.match(r"(?:static )?func ", line):
                context = line.split("(", 1)[0].replace("static ", "")
            elif line.startswith("[node "):
                context = line
            elif line.startswith("[resource") or line.startswith("[sub_resource"):
                context = line
            contexts[number] = context
        main_rows, extra_rows = [], []
        relative = path.relative_to(ROOT).as_posix()
        for ordinal, match in enumerate((m for m in TOKEN.finditer(source) if m.group("string") is not None), 1):
            total += 1
            number = source.count("\n", 0, match.start()) + 1
            raw = match.group("string")
            identifier = f"{path.stem.upper()}-{ordinal:04d}"
            suffix = source[match.end():source.find("\n", match.end()) if "\n" in source[match.end():] else len(source)].strip()
            variables = " Formatting arguments: " + suffix if suffix.startswith("%") else ""
            context = contexts[number] + variables
            location = f"[L{number}](../{relative}#L{number})"
            row = f"| {identifier} | <code>{cell(raw)}</code> | `{relative}` | {location} | {cell(context)} |"
            (main_rows if classify(raw, lines[number - 1]) else extra_rows).append(row)
        heading = f"\n## {relative}\n\n| ID | Current text / source literal | File path | Location | Context / template variables |\n|---|---|---|---|---|\n"
        if main_rows:
            primary.append(heading + "\n".join(main_rows) + "\n")
        if extra_rows:
            technical.append(heading + "\n".join(extra_rows) + "\n")
    intro = """# Text inventory — Step 48

Source snapshot, not a runtime/UI verification. This inventory covers every string literal outside comments in first-party game scripts, rules data, scenes, the UI theme and project configuration. Repeated occurrences have separate IDs and locations. No dialogue, thought array or scene literal is intentionally omitted. Editor-only third-party addons, import metadata, audio manifests, documentation and art assets are excluded.

The tables prioritize likely display copy, then retain all other literals in [the technical appendix](TEXT_INVENTORY_INTERNALS.md). Classification is conservative: short labels, speaker names and some code strings also appear below. This is a source inventory, not a claim that every candidate is currently displayed. Do not rename keys, node paths, enum identifiers, asset paths or event IDs to change copy. Use the [editing guide](TEXT_EDITING_GUIDE.md).

Text is quoted exactly as in source, including escaped `\n`, placeholders and BBCode. `\n` means a visible line break. For generated messages, the context includes immediate `%` formatting arguments; otherwise follow the function and source link to its expression. Values passed from gameplay state remain authoritative. IDs are documentation locators, not localization keys, and can change on regeneration.

Dynamic sources: `%` templates supply game-state numbers/names; `capitalize()` turns routine keys into names; `PERSONAL_ACTIVITIES`, `DIFFICULTIES`, `CLEAN_COSTS` and time-format arithmetic supply values. Dynamic portraits and font resources contain no editable story copy. The new rules derive difficulty values in `data/rules_text.gd:pages()`. Regenerate this snapshot with `python tools/build_text_inventory.py` after editing copy (documentation generation only; does not launch Godot).

"""
    destination = ROOT / "docs"
    destination.mkdir(exist_ok=True)
    (destination / "TEXT_INVENTORY.md").write_text(intro + "".join(primary), encoding="utf-8")
    (destination / "TEXT_INVENTORY_INTERNALS.md").write_text("# Text inventory — technical appendix\n\nAll remaining source literals are retained for completeness. Most are NOT player copy. They include empty strings, property/event identifiers, resource paths, node names, shader strings, colors and drawing glyphs. Some are data keys later formatted into visible labels; inspect the referenced use before editing. Never bulk-replace these as prose. Return to [display-copy inventory](TEXT_INVENTORY.md).\n" + "".join(technical), encoding="utf-8")
    print(f"Documented {total} source literals across {len(files)} files; no game execution.")


if __name__ == "__main__":
    build()
