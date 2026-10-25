# How to edit all game text

Open `C:\Users\abid\Documents\its-probably-fine\data\text\`. Edit the **JSON files**, save as UTF-8, and stop/restart the running game normally. Godot, the text manager and the scenes read the files on startup; no manual code compilation, scene edit or signal edit is required. An already running game caches the catalog until the next run.

The [complete reference](COMPLETE_TEXT_REFERENCE.md) lists every catalog ID, current wording, file, live source location and variables. Search it for a phrase, then edit that ID's `text` field in the listed JSON file. [Remaining exceptions](REMAINING_HARDCODED_TEXT.md) distinguishes internal identifiers and presentation punctuation from editable copy.

## Files

| JSON file under `data/text/` | Contents |
|---|---|
| `main_menu.json` | Title, subtitle, menu/help pages, difficulty panel and native window caption |
| `hud.json` | Day/time/deadline, Fullness/Mood, checklist heading, research/needs/time details and status templates |
| `research.json` | Research entry button, difficulty names/descriptions, playback controls, progress and help |
| `activities.json` | Eating/leisure/cleanup options, durations/rewards, activity choices and Eject confirmation |
| `tiptop.json` | Thoughts, chore/action labels, routine display names and repair UI |
| `dialogue.json` | Story exchanges, Mood-dependent Judy responses, greetings, endings' spoken exchanges and speaker display names |
| `tutorial.json` | Optional tutorial and contextual consequence warnings |
| `rules.json` | All four pre-game rules pages and navigation labels |
| `notifications.json` | Activity results, warnings, malfunction and repair/cleanup messages |
| `endings.json` | Stage headings, ending titles, summary and exit buttons |
| `settings.json` | Display/audio settings, bus display names and music credit |
| `save_load.json` | Save/Continue/profile errors, recovery messages and displayed save-kind names |
| `interactions.json` | Nearby E prompts, player activity feedback and scene-default text |

Some identical short strings share an ID across multiple components; the reference shows all source uses. Some IDs are descriptive slugs of the original wording. **Do not rename IDs when rewriting wording.** A key's old wording need not match its revised `text` value.

## A safe wording edit

For example, `research.start` currently contains `"text": "Watch Research"`. Change only the value to `"text": "Begin Working"`. The same button still starts Watch research.

Other useful entries:

- `hud.fullness`: change the Fullness label to Hunger. The compact `hud.full_d` and surrounding help/body sentences are separate entries if you want to rename those too.
- `hud.checklist_heading`: change TipTop's sidebar/checklist heading to Robot Tasks.
- `hud.research_1f`: change the live research label while keeping `{progress}`.
- `dialogue.speaker_judy`, `dialogue.speaker_tiptop`: displayed names; internal character identity and portraits stay intact.
- `main_menu.window_title`: window caption. Leave the internal project ID alone; it identifies the existing `user://` save location.

## JSON syntax

- Strings and keys use double quotes. Put commas between fields/records, with no trailing comma after the last one.
- Escape quotes inside prose as `\"`. Use `\n` for an intentional line break and `\n\n` for a paragraph. Do not place a physical newline inside a quoted JSON string.
- Apostrophes, curly quotes, em dashes and accented characters are valid in UTF-8.
- Keep bracket/brace structure intact. JSON does not support comments; put personal notes in a separate document.
- Edit `text`, not `where`, when changing wording. `where` is reference metadata, not the source of live game values.

## Dynamic placeholders

Example record:

```json
"hud.research_1f": {
  "text": "Research: {progress}%",
  "variables": { "progress": "%.1f" },
  "order": ["progress"],
  "where": ["scripts/hud.gd:_update_hud"]
}
```

You can reword it as `"Progress so far: {progress}%"`. The displayed number still comes from the existing research calculation. **A literal percent is `%`, not `%%`.** JSON templates no longer use printf escapes for prose.

Named placeholders cover progress, day, hour/minute/period, deadline hours/minutes, Fullness, Mood, durations, gains, sessions, repair counts, activity names, difficulty, save errors and other live values. Reorder placeholders in the sentence freely; keep their names. You may repeat or omit an existing placeholder in the displayed wording without changing the underlying calculation.

`order` maps the existing code's argument positions to names, while `variables` controls presentation: `%s` text, `%d` whole numbers, `%02d` zero-padded minutes, `%.0f` whole-number formatting and `%.1f` one decimal. Normally leave both fields alone. They change formatting/binding, never rewards or activity timing. A new placeholder without a supplied value is left visibly intact and produces a GameText warning; it is never silently discarded.

## Metadata that is not prose

- `speaker`: canonical `Judy`/`TipTop` identity for feedback routing. Keep it unchanged; use `dialogue.speaker_*` for visible names. Prefixed notifications store their body without a technical speaker prefix.
- `tags`: stable consequence categories such as `insufficient_time` and `mosquito`. Keep these unchanged so warning guidance and expressions survive rewording.
- `audio_cue`: existing button sound classification (`cancel`, `confirm`, `resume`). Keep it unchanged; ordinary clicks need no override. Sound files, mix and playback are unchanged.
- `where`: documentation metadata. Changing it does not change the UI.

Activity buttons use stable action IDs and callbacks. Their behavior no longer depends on displayed captions such as Watch 1x or Keep working. Repairs and save fields still use canonical internal IDs, separate from display names in JSON.

## Wrapping, dialogue and visual limits

Existing fonts, panel bounds, button dimensions, colors and sentence-aware pagination remain in use. Longer text still needs manual visual review; centralization is not an automatic UI redesign. Keep short prompts/checklist labels compact. Comic lines can use punctuation and `\n`; the existing pager wraps with actual font metrics. Keep TipTop's overhead thoughts short enough for his existing compact thought limit.

Checklist templates use BBCode (`[color]`, `[s]` and closing tags). Keep tags balanced unless intentionally removing that styling. Plain Labels do not interpret BBCode.

Scene labels store `@text.id` markers and resolve automatically through GameText. Several are editor/startup defaults later overwritten by a live template; edit the live template identified in the reference for ordinary gameplay. In the editor's unplayed scene preview, an `@...` marker may be visible; that is a binding, not broken player copy.

## Adding entries and troubleshooting

Add a unique namespaced record to an **existing** category JSON file. A static entry needs `text`, `variables: {}`, `order: []` and optionally `where: []`. GameText loads it on the next run. Existing wording edits require no coding; a genuinely new UI element must still be bound to its new ID by its implementation. Additional category files require adding their category to GameText's file list and including them in exports.

Missing IDs display `[the.missing.id]` and emit a warning once. Missing variables stay visible as `{name}`. Invalid JSON reports its file and parse line in Godot's output. Restore the JSON syntax or ID; don't rename save keys, actor names or nodes to repair a text error. A broken catalog file is skipped without changing campaign/profile data.

Do not empty a text value to hide a warning or label. Empty/whitespace-only records are rejected and display their ID. This also protects existing safety checks that use a genuinely empty result to mean an activity/save is allowed; rewriting copy must not bypass them.

The Windows Desktop export preset includes `data/text/*.json`, so edited text is packaged with the game. For future platform presets, retain that include filter. No export was run in this pass.

To regenerate the reference safely after edits, run `python tools/build_complete_text_reference.py`. It reads catalogs/source and writes documentation only. The other Step 48.1 migration tools are one-time development utilities; **do not rerun them on a rewritten catalog**. The earlier Step 48 text guides/inventories are historical snapshots, superseded by these documents.

Manual verification: restart the game, inspect the changed label/message, use its original controls, inspect long dialogue for both portraits, hover HUD tabs and test Watch/6x/Skip/Eject after renaming captions. Confirm Continue still loads the existing campaign. No Godot launch, automated tests or runtime verification was performed during implementation.
