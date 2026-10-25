# Step 48.1 — complete text centralization

Checkpoint: `335e0ee`, created before implementation. The existing unrelated temporary scene file was left alone.

## Implementation

**446 text records in 13 JSON files under `data/text/`.** `scripts/game_text.gd` is a lightweight GameText autoload before GameState. It loads/caches the catalog during initialization, supports static IDs, named substitution and preserved numeric formats, warns once for missing IDs/values/invalid formatting, and displays an ID/placeholder instead of silently discarding text. JSON parse errors identify the file/line. It does not modify gameplay or save data.

Converted title/main menu/help/settings, window title, HUD labels and dynamic values, hover/accessibility text, research controls/status/results, eating/leisure/cleanup choices, repair UI/results, TipTop thoughts/action labels, all existing comic dialogue and Mood-dependent responses, greetings/goodnight, tutorial/rules, save/load/profile messages and ending presentation. Six scene text defaults now bind via `@ID` at Control ready time. Existing controls and callbacks are retained.

Categories: `main_menu`, `hud`, `research`, `activities`, `tiptop`, `dialogue`, `tutorial`, `rules`, `notifications`, `endings`, `settings`, `save_load`, `interactions`.

Named variables include progress, target, day, hour/minute/period, deadline hours/minutes, Fullness, Mood, sessions/limit, duration/elapsed/speed, gains/rewards, routine/status, repair count, activity/difficulty, volume, save kind/error and tutorial/page counts. `order` maps the same positional calculation results to those names; `variables` retains `%d`, `%02d`, `%.0f`, `%.1f` or `%s` formatting. Plain prose uses a single `%` character.

## Wording-independent behavior

- Playback and Eject buttons now use stable action keys; renaming Watch/6x/Keep working does not change callback assignment, focus targets or help selection.
- Consequence guidance uses stable `insufficient_time`/`mosquito` tags rather than English substring matches.
- Canonical speaker identity remains separate from the editable name label and feedback body. Portrait/expression selection stays unchanged.
- Robot routine names, audio-bus names and save-kind nouns have display aliases; their technical keys remain unchanged.
- The audio controller's button-click handler now reads catalog cue classification rather than interpreting the edited caption. This is a UI binding adaptation only: no audio file, bus gain, music setting, activity sound or BGM playback logic changed.

Text-bearing constant dictionaries became instance dictionaries where a runtime lookup is required. The pre-game rules keep constant IDs and resolve copy through GameText. No balance values or scene geometry were changed.

## Documentation

- [How to edit all game text](docs/HOW_TO_EDIT_GAME_TEXT.md)
- [Complete text reference](docs/COMPLETE_TEXT_REFERENCE.md) — every catalog record, file, source use and variable
- [Remaining hardcoded text / exceptions](docs/REMAINING_HARDCODED_TEXT.md)

The earlier Step 48 guides are historical and now point to these documents. `tools/build_complete_text_reference.py` safely regenerates documentation without editing the catalog. Other migration tools are one-time development records and should not be rerun on rewritten copy.

## Files changed

- `project.godot`: GameText autoload
- New `scripts/game_text.gd`, 13 `data/text/*.json` files
- `scripts/title.gd`, `hud.gd`, `hud_details.gd`, `desk.gd`, `player.gd`, `tiptop.gd`, `game_state.gd`, `save_store.gd`, `tutorial.gd`, `showcase.gd`, `rules_intro.gd`, `data/rules_text.gd`: display bindings only, plus stable routing above
- `scenes/hud.tscn`, `scenes/desk.tscn`: text bindings only
- New minimal `export_presets.cfg`: Windows Desktop all-resources preset with `data/text/*.json` included; export output path remains unset for the user to choose
- New text documentation and source/documentation migration utilities

Fonts, sizes, panel bounds, colors, room art, character art, game calculations, clock rates, ending conditions, save schema/keys and tutorial sandbox isolation remain unchanged. Text edits are visible on the next complete game run; there is no live file watcher.

## Remaining exceptions and compatibility

No known authored natural-language game UI copy remains hardcoded in the reviewed active first-party source. Technical identities, whitespace/sentence parsing, developer logs, fallback ID markers, project identity and art/editor material remain deliberately outside the text catalog. See the exact exception locations in `docs/REMAINING_HARDCODED_TEXT.md`; this is not a claim that uninspected image pixels or OS UI can be edited as JSON.

Existing saves still use the same schema and IDs. Display-only aliases never become save keys. A catalog error leaves saves untouched. There is no imported font/resource replacement and no new dependency or plugin.

The export preset includes JSON explicitly so standalone builds read the edited wording. Future platform presets must retain the include filter. No build/export was performed. Longer rewrites may exceed existing compact UI bounds or TipTop's thought-length routing; the existing wrapping/pagination is preserved and needs manual review with rewritten copy.

## Static review and manual playtest

Catalog files were read as JSON for documentation/source auditing; static ID references resolve to catalog entries. Inspected remaining literals in scripts, scenes, themes and UI data, and checked the patch for whitespace errors. **Godot was not launched; no automated tests, gameplay simulation or screenshots were run. Runtime correctness is unverified.**

Manual checks, ordered by risk:

1. Change only JSON: `research.start` to Begin Working, `hud.fullness` to Hunger, and `hud.checklist_heading` to Robot Tasks. Restart the game and confirm text changes while controls, pin/hover behavior and research remain functional.
2. Rewrite one Judy line, one TipTop line, a thought, tutorial instruction, rules paragraph, tooltip and ending title. Check both comic portraits, sentence pagination, E/Enter, rules Back/Next and compact thought wrapping.
3. Observe day/time/period, deadline, progress, sessions, needs, repair counts and activity elapsed values. Confirm formats/leading zeroes and unchanged rewards/costs.
4. Rename all playback/Eject captions; exercise Watch, 6x, Skip, Keep working and Eject. Confirm callbacks, focus, warning tags and existing UI sounds remain associated with their actions.
5. New Game rules, optional tutorial isolation, campaign Continue/manual save, repairs, cleanup, sleeping and all endings. Check old saves still load and no reward or transition is duplicated.
6. Open Settings and inspect bus names/slider values without altering audio balance. Confirm existing BGM/SFX remain as before.
7. Inspect scene fallback bindings in normal play and, when preparing a release, choose an export output path and confirm the JSON include filter remains present. No export was verified here.
