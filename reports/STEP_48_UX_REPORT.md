# Step 48 — onboarding, readability and editable text

## Checkpoint and verification scope

Created Git checkpoint `9705689` before editing. It preserves the prior working audio integration. The unrelated `scenes/room.tscn67011533153.tmp` was left untouched.

Implementation and static source review only: Godot was not launched, no gameplay was simulated, no automated tests were run and no screenshots were captured. Runtime layout, input and save/load behavior require manual playtesting.

## New Game and optional tutorial

- `SaveStore.new_campaign(false)` now disables automatic guided lessons independently of profile completion/skipped flags. No profile completion is falsely awarded. Essential contextual consequence warnings remain enabled.
- The main menu labels its existing help entry **Tutorial / How to Play**. Its **Play Tutorial** button still starts the existing guided apartment lessons.
- Tutorial entry uses disposable GameState runtime values and an empty campaign ID with `tutorial_sandbox = true`. Manual campaign saving, autosave requests and campaign milestone/ending recording cannot write a practice campaign. The real campaign slot remains available for Continue after exiting practice.
- Tutorial practice still updates its separate tutorial-completion/skipped profile flags. It does not modify campaign research, clock, needs, repairs or saves. Its local practice clock is not the saved campaign clock.
- Existing Exit Tutorial and Esc → Exit Tutorial return to the main menu. Practice can be replayed regardless of profile flags.
- Pause-menu **How to Play** now reviews the rules, without starting interactive spotlights or clearing campaign guide flags. Interactive practice is main-menu-only.
- Continue explicitly suppresses old unfinished guided introductions, restores the campaign and does not open rules. Save schema remains version 1; existing tutorial/profile fields remain compatible.

## Pre-game rules

Added `scripts/rules_intro.gd`, a four-page, screen-space modal using existing HUD scaling, containers and the restored theme. Copy is centralized in `data/rules_text.gd`.

Pages cover the goal/deadline, research/time, Fullness/Mood, then TipTop/repairs/planning. Each has Back/Next, a page number and readable wrapped body copy inside a scroll area. The final action is **LET'S GET TO WORK**. E/Enter advances once per non-repeat keypress; focused Back retains normal Enter activation. Tab, arrow/scroll navigation and mouse buttons remain available.

New Game and fresh campaign restarts enter this rules gate. The tree stays paused: no Judy input, robot chores or authoritative clock advancement. Incompatible prompts and HUD interactions are suppressed. After dismissal, the existing opening conversation runs, then normal control resumes. Rules review also pauses safely and restores the previous modal state after dismissal.

### Actual values used, without balancing changes

| Rule | Existing implementation |
|---|---|
| Campaign | Three days, 11 AM–8 PM; showcase Day 3 at 8 PM |
| Research target | 75%; the existing research/repair ending predicates remain unchanged |
| Daily limit | Four research starts; sleeping restores the daily allowance |
| Easy | 90-minute session, +15% base; 45-minute repair, +5% |
| Medium | 120-minute session, +10% base; 60-minute repair, +4% |
| Hard | 180-minute session, +8% base; 60-minute repair, +3% |
| Running tap | Session length multiplied by 160/120; research gain multiplied by 0.5 |
| Books | Scattered books block research; manual cleanup costs 20 minutes |
| Fullness | Research start requires >20; yield multiplier 1.0 at >=60, 0.9 at >=30, 0.75 above zero, 0.6 at zero |
| Mood | Normally >=45; Day 3 from 2 PM permits low-Mood work at an additional 0.8 yield, without bypassing Fullness |
| Meal | 30 minutes, +40 Fullness and +10 Mood; meal/leisure reset streak rather than daily sessions |
| Repair bonus | Existing first repair before research earns the one-time +10% proactive bonus |
| Playback | Watch, 6x and Skip retain existing time/consequences; Eject retains spent time without completion reward |

Difficulty duration/reward values and the target are read from GameState when rules open. Existing threshold descriptions are documented for future synchronization if balancing changes later. The zero-Fullness yield exists in code but does not bypass the start restriction.

## Font restoration and focused readability changes

Inspected pre-42B commit `e1f256f`: `project.godot` had no custom UI font/theme assignment; the title constructed `Theme.new()` without a font override, and HUD text used ordinary Labels with linear filtering. The prior primary font was **Godot's embedded regular default font**, not a deleted custom font file.

- `themes/cozy.tres` no longer selects Nunito or its 550-weight variation; it inherits the built-in default while retaining sizes and palette.
- `scripts/typography.gd:accent()` now uses `ThemeDB.fallback_font` rather than Pixelify Sans. Existing heading hooks continue working across title, tutorial, HUD and endings.
- Kept established per-control sizes, world framing, portrait layout and nearest-filtered art. No downloaded font/source/license files were deleted.
- Added one reference pixel of line spacing in sidebar detail paragraphs. Rules use 10-pixel body copy, separated paragraphs, page headings and scrolling rather than tiny dense text.
- The rules gate suppresses incompatible prompt/dialogue overlays. In-game help no longer launches competing interactive tutorial spotlights. No useful HUD data or functionality was removed.

## Default checklist, preview and persistence

`scripts/hud_details.gd` defaults its pinned category to `repairs` (TipTop). Existing checklist rows still read the live four repair flags. Hover or intentional keyboard focus can preview another category; leaving returns to the pinned panel after the existing short crossing grace. Clicking changes the pin; clicking the pinned category can still unpin it.

The previous controller always forced `active = pinned` and suppressed other previews. Selection now distinguishes the displayed preview from the saved pin. Buttons retain no focus during ordinary movement; Tab remains the explicit opt-in for HUD navigation, so arrow keys still move Judy normally.

Campaign saves now optionally include `ui.pinned_details`. Continue safely accepts known categories (including intentionally unpinned `""`); old/missing/invalid values fall back to TipTop. A pin click requests a debounced safe autosave. No other campaign field or validation boundary changed.

## Text-editing deliverables

- [docs/TEXT_EDITING_GUIDE.md](docs/TEXT_EDITING_GUIDE.md): category-by-category actual files/functions, hardcoded/data-driven distinctions, dynamic dialogue, BBCode, percent placeholders, UTF-8 and routing-sensitive strings.
- [docs/TEXT_INVENTORY.md](docs/TEXT_INVENTORY.md): exact source literals, source lines/functions and formatting arguments for likely display copy, including scene defaults.
- [docs/TEXT_INVENTORY_INTERNALS.md](docs/TEXT_INVENTORY_INTERNALS.md): remaining literals, including internal IDs and paths, retained rather than silently omitting ambiguous short labels.
- `tools/build_text_inventory.py`: documentation-only regenerator. Together the inventories cover every non-comment string literal in the scanned first-party runtime scripts, rules data, scenes, theme and project config. They do not inventory editor-only third-party addon UI or image-baked lettering.

Only the new rules copy was centralized. Existing dialogues stay at documented locations to avoid an architecture rewrite. Inventory IDs are snapshot locators, not localization keys; some likely-copy candidates are intentionally conservative and include non-display strings. Do not edit internal IDs as prose.

## Files changed

- `scripts/title.gd`
- `scripts/hud.gd`
- `scripts/hud_details.gd`
- `scripts/save_store.gd`
- `scripts/tutorial.gd`
- `scripts/typography.gd`
- `themes/cozy.tres`
- New `data/rules_text.gd`, `scripts/rules_intro.gd`
- New three documentation files above, `tools/build_text_inventory.py`, and this report

No audio code, audio file, bus, apartment geometry, character art, GameState balance value or ending predicate was edited in this pass.

## Manual playtest checklist, ordered by risk

1. **Fresh campaigns on all difficulties:** rules appear every time; verify displayed difficulty values. Wait 30 real seconds on a rules page: time remains 11 AM, Judy/TipTop remain stationary. No tutorial spotlight appears. Read all four pages, use Back, E/Enter, mouse and final button. Confirm existing intro dialogue and control resume exactly once.
2. **Campaign isolation:** save a recognizable campaign state; return to menu and play Tutorial. Move/work/skip lessons, exit through both tutorial exit routes, then Continue. Campaign day/time/research/needs/repairs must match its checkpoint. Tutorial must not award campaign endings or replace the save.
3. **Continue:** load both a prior schema-1 save and a newly saved campaign. No rules or guided tutorial should appear. Check stored HUD pin; old saves fall back to TipTop. Confirm save/research/repair bonuses are not reapplied.
4. **HUD:** TipTop checklist appears after onboarding/conversations; check all four live rows. Hover Research/Time/Needs, leave to restore TipTop, click another pin, unpin, save and Continue. Ordinary arrows move Judy; Tab explicitly enables HUD focus. Dialogues/activities suppress incompatible panels.
5. **Readability:** inspect 16:9, 3:2 and 4:3 windows; rules are fully framed, bodies scroll and footer buttons remain reachable. Check long Judy/TipTop comic pages, small HUD labels, tooltips, menus, save errors and all ending titles with the restored font.
6. **Pause help and campaign restart:** How to Play reviews rules without starting sandbox or spotlights. Closing returns control. Restart shows rules for the new campaign; tutorial restart stays in disposable practice.
7. **Preserved systems:** one research session with each playback mode, Eject, food/leisure, repair/cleanup, mosquitoes, sleep/day progression and endings. Confirm audio remains as before this pass.

## Limitations

The above are manual checks, not passed results. No in-engine font metrics, aspect-ratio rendering, save round-trip or input flow was executed. Existing activity captions and some warning phrases still double as routing/detection keys; the editing guide explicitly identifies this constraint rather than risking a broad refactor. Existing and newly generated documentation may need regeneration after later copy changes.
