# Remaining hardcoded text — Step 48.1 static audit

**No known game-authored UI sentences, dialogue lines, thought lines, warning wording or label words remain hardcoded in the active first-party source reviewed in this pass.** After Step 49, the catalog contains 457 entries across 13 JSON files, including six scene-default bindings. This is a source audit, not a claim that every runtime screen or image has been visually verified.

Searched first-party `.gd`, `.tscn`, `.tres`, project configuration and UI data. All authored text fields found in `scenes/hud.tscn` and `scenes/desk.tscn` now use `@ID`; runtime values use GameText. Existing dialogue is in first-party GDScript arrays, now populated from JSON; no active standalone `.dialogue`/CSV story database was found. `themes/cozy.tres` contains styling, not prose. Procedural apartment/lighting drawing scripts contain no language-rendering calls. Text inside reference images or source/credit documentation is not runtime UI copy.

## Intentional non-copy literals and boundaries

These remain for technical or rendering purposes; **do not edit them as wording**. Their player-facing presentation is already separate where applicable.

| Exact literals / location | Why they remain | Player-facing alternative / later work |
|---|---|---|
| `Judy`, `TipTop`, `System` in `scripts/hud.gd` dialogue entries, speaker checks and `scripts/tiptop.gd` greeting entries | Canonical identities select portraits and route dialogue, not visible name labels | Edit `dialogue.speaker_judy`, `dialogue.speaker_tiptop`, `dialogue.speaker_system`. Keep speaker metadata canonical. |
| `TipTop: ` in `scripts/tiptop.gd:show_monologue()` and `:`, `Judy`/`TipTop` checks in `scripts/hud.gd:_show_feedback()` | Internal envelope removed before presenting the text; not independent displayed prose | Body and displayed speaker name are JSON. A future structured signal could replace the envelope, but isn't necessary for copy edits. |
| `sink`, `plant`, `bookshelf`, `bed`, `eat`, `reels`, `games`, `cube`, category/scene/node names throughout scripts/scenes | Gameplay, save, navigation, portrait and event identifiers | Routine display aliases, activity titles, help and prompts are JSON. Aliases are resolved only for presentation. |
| `Master`, `SFX`, `Ambience`, `Music` in `scripts/title.gd:_show_settings()`, `scripts/save_store.gd` and audio scripts | Actual bus and settings/save keys | `settings.bus.*` controls visible names and accessibility labels. |
| `config/name="its-probably-fine"` in `project.godot` | Internal project ID also affects existing user storage; changing it could make saves appear missing | Native window caption is `main_menu.window_title`. Project metadata intentionally remains stable. |
| `" "`, `"\n"`, punctuation and regular-expression syntax in `scripts/hud.gd:_dialogue_pages()`, `_dialogue_line_breaks()`, `_dialogue_fits()` and `scripts/tiptop.gd:_thought_line_breaks()` | Text-layout machinery; word/sentence separators, not instructions/dialogue | Ordinary wording, explicit paragraph breaks and numeric label templates are JSON. Changing parsing syntax is a layout/code task, not copy editing. |
| Empty `""` values throughout UI scripts | Clear/hide state or intentionally deferred dynamic dialogue | Not visible wording; no text record is needed. |
| `"[" + identifier + "]"`, `{name}` placeholder markers and diagnostic sentences in `scripts/game_text.gd` | Recovery/debug markers exposing a missing ID/value; developer diagnostics go to output | Fix the indicated catalog entry/value. These are not normal localized game labels; they could be given a separate diagnostic catalog later. |
| `push_error`/`push_warning` diagnostics in `scripts/apartment_audio.gd`, `scripts/save_store.gd` and `scripts/game_text.gd` | Developer-only diagnostics, not messages shown in gameplay | User-visible save/profile/Continue failures are already in `save_load.json`. Internal log wording was deliberately not centralized. |
| Pixel icon patterns and geometric artwork in `scripts/hud.gd`, `scripts/title.gd`, `scripts/apartment_visual.gd`, `scripts/showcase.gd` | Decorative shapes/icons, not editable natural-language strings | No image OCR or art editing was performed. Any lettering baked into an image requires an art change rather than a JSON edit; no claim is made about uninspected image pixels. |
| Third-party `addons/dialogue_manager/` editor labels, import metadata, source licenses/reports and the unrelated `scenes/room.tscn67011533153.tmp` | Not loaded as authored runtime game UI; third-party/editor/source material and unrelated work | Excluded from game-copy migration. If an addon-provided runtime UI is introduced later, audit its visible strings at integration time. |

## Limits and completeness evidence

- The documentation builder found no unresolved **static** GameText ID references. Dynamic routine, speaker and bus families are explicitly present in the JSON catalog; pre-game button IDs are held as constants in `data/rules_text.gd` and resolve through the same manager.
- Existing `%` calculations were retained as named-variable bindings, including zero-padded time and one-decimal research percentages. Internal filename/event/save-key formatting was not migrated.
- Wording-based activity routing was replaced with stable action keys; warning recognition uses JSON tags. Existing button cue categories are retained as metadata instead of being inferred from revised copy.
- Some catalog records are intentionally startup/editor defaults overwritten by live values, or shared fragments. The complete reference shows these uses; editing the correct live template avoids expecting an unused scene default to change gameplay HUD.
- No Godot/game launch, automated tests, screenshots, exports or runtime save round-trips were performed. Long rewrites may need manual layout adjustments later. This audit does not promise pixel-art embedded lettering or OS/engine-generated UI is JSON-editable.
