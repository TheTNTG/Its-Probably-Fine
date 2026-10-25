"""Read-only catalog documentation builder; never changes game text or scenes."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]


def main():
    catalog = {}
    for path in sorted((ROOT / "data/text").glob("*.json")):
        for identifier, entry in json.loads(path.read_text(encoding="utf-8")).items():
            catalog[identifier] = (path.relative_to(ROOT).as_posix(), entry)
    uses = {key: [] for key in catalog}
    unresolved = set()
    pattern = re.compile(r'GameText\.(?:get_text|format_text)\("([^"]+)"')
    for path in sorted([*ROOT.glob("scripts/*.gd"), *ROOT.glob("data/*.gd"), *ROOT.glob("scenes/*.tscn")]):
        context = "initial values"
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if re.match(r"(?:static )?func ", line):
                context = line.split("(")[0].replace("static ", "").replace("func ", "")
            if line.startswith("[node "):
                context = line
            identifiers = []
            for match in pattern.finditer(line):
                if not line[match.end():].lstrip().startswith("+"):
                    identifiers.append(match.group(1))
            identifiers += re.findall(r'"@([^"]+)"', line)
            if path.name == "rules_text.gd" and line.startswith("const "):
                identifiers += re.findall(r':= "([^"]+)"', line)
            for identifier in identifiers:
                if identifier in uses:
                    uses[identifier].append(f"{path.relative_to(ROOT).as_posix()}:{number} {context}")
                else:
                    unresolved.add(identifier)
    def cell(value):
        return str(value).replace("&", "&amp;").replace("<", "&lt;").replace("|", "&#124;").replace("\n", "<br>").replace("`", "&#96;")
    output = ["# Complete game text reference\n\nEdit JSON `text` values. Placeholders supply live values; `order` binds arguments and `variables` preserves numeric formatting. Source references are a static snapshot. [How to edit](HOW_TO_EDIT_GAME_TEXT.md) · [Exceptions](REMAINING_HARDCODED_TEXT.md).\n\n"]
    previous = ""
    for identifier, (filename, entry) in sorted(catalog.items()):
        if filename != previous:
            previous = filename
            output.append(f"## {filename}\n\n| Text ID | Current Text | JSON File | Where It Appears | Variables |\n|---|---|---|---|---|\n")
        where = uses[identifier] or entry.get("where", [])
        variables = ", ".join(f"{name}: {spec}" for name, spec in entry.get("variables", {}).items()) or "—"
        output.append(f"| `{identifier}` | {cell(entry['text'])} | `{filename}` | {cell('; '.join(where))} | {cell(variables)} |\n")
    output.append(f"\nTotal: {len(catalog)} entries in {len(set(p for p, _ in catalog.values()))} JSON files. No runtime verification.\n")
    (ROOT / "docs/COMPLETE_TEXT_REFERENCE.md").write_text("".join(output), encoding="utf-8")
    print(f"Reference: {len(catalog)} entries. Static source IDs without catalog records: {sorted(unresolved)}")


if __name__ == "__main__":
    main()
