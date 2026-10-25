# Step 41B — Contextual tutorial and consequence guidance

Checkpoint before changes: `da10c87`.

## Changed files

- `scripts/tutorial.gd`: compact tooltip, amber outlines, contextual queue and instruction review.
- `scripts/hud.gd`: creates the guide within the existing screen-space HUD, handles tutorial advancement before gameplay E input, adds pause-menu Review Tutorial and routes requests to rest.
- `scripts/game_state.gd`: separate tutorial completion/skip flags, cleared by the established New Game/Restart reset.
- `scripts/player.gd`: bed interaction asks the HUD for the hungry-sleep warning before invoking the existing end-day logic.

## Architecture and safety

The guide uses the existing HUD canvas and never changes tree pause state, clock speed, research, repairs, AI or ending calculations. It hides during research, eating, leisure, repairs, pose animations, transitions, endings, comic dialogue, queued dialogue, morning greetings, menus and system notices. The current explanation resumes when play is safe. E/Enter acknowledges one explanation; the event is consumed before reaching gameplay interactions. Mouse buttons provide Got it and Skip Tutorial.

World outlines use the live furniture/character transforms and camera canvas transform converted into HUD-local coordinates. Procedural furniture uses its drawing extents; animated characters use their frame bounds, offset and visual scale. HUD outlines use actual Control bounds, except the unchanged controls card's existing reference rectangle. These are bounding outlines rather than pixel-silhouette shaders. The tooltip uses the lower HUD region and moves above it when that region would cover the highlighted target.

## Trigger and completion rules

Acknowledging a tip records its ID for the current playthrough. Pending IDs are deduplicated. Skipping removes optional guided tips while retaining essential warnings. Pause-menu Review Tutorial re-enables all eight instructional topics without clearing consequence-warning history or changing gameplay progress. Review requested during a task waits until that task finishes.

| Topic | First eligible trigger |
| --- | --- |
| Movement / interaction; clock / deadline | After opening dialogue and morning greeting have finished |
| Research controls and difficulty duration / 75% target | Near the desk |
| Faulty chores / independent repairs | Near TipTop |
| Needs, eating and leisure | Near fridge/table, or fullness below 75 |
| Sleeping / overnight effects | Near bed |
| Escape / Eject Task | After acknowledging the research target tip, or instruction review |
| Sink consequence | Tap running |
| Bookshelf consequence | Scattered-book state, mess level 2 or higher |
| Plant consequence | First wet/messy plant state |
| Bed consequence | Bed mess reaches level 2 |
| Mood recovery | Below 45 Mood near desk; explains the existing Day 3 exception |
| Hunger efficiency | Fullness below 60 |
| Repair reward / corrected routine | Any routine successfully repaired |
| Research target met | Research reaches the existing 75% threshold |
| Not enough time | Existing rejected activity/research/repair feedback |
| Hungry bedtime warning | Bed rest requested below 70 fullness, once per day |

The bedtime warning leaves Judy free to eat or dismiss it and interact with the bed again. It does not automatically sleep or advance a day. Other tips are once per playthrough, not once per frame or incident.

TipTop's autonomous movement and chore effects wait until all eight guided tips are acknowledged or Skip Tutorial is chosen. This includes Watch/6x/Skip simulation, preventing the first tap incident from interrupting onboarding. The tip heading shows progress out of eight. Reviewing instructions later does not lock TipTop again. New Game/Restart restores the initial hold. Check both completion and Skip: TipTop should remain stationary beforehand, then resume chores and normal malfunction behavior afterward.

## Manual playtest checklist

1. New Game on each difficulty: complete opening/greeting, check movement/clock tips, E/Enter single-step advancement, Got it and Skip Tutorial. Movement should remain responsive while tips are visible.
2. Approach desk, TipTop, fridge/table and bed. Verify relevant instructions, difficulty-specific duration and the eight topics via Pause → Review Tutorial.
3. Resize/window/fullscreen: outlines should remain aligned with furniture, Judy/TipTop and HUD cards. Check that the tooltip avoids its highlighted object and fits on screen.
4. Let faulty chores create water, wet soil, scattered books and a messy bed. Check accurate one-time consequence tips; repeated incidents must not spam them. Clean books and verify research blocking still clears normally.
5. Research using Watch, 6x and Skip; eat, take leisure and repair routines. No tip should interrupt an active task or overlap comic dialogue, repair choices, menus or day wipes. Deferred explanations should appear afterward.
6. Reach low Mood/fullness, repair a routine, reject an activity for insufficient time and reach 75% research. Check each explanation once, including after Skip Tutorial.
7. Request sleep below 70 fullness. Dismiss the warning, optionally eat, then interact with the bed again. Verify goodnight, sleep, next-day greeting and endings still use their existing flow.
8. Pause/resume, eject research, review instructions, return to title and start again, then Restart Game. Tutorial flags must survive day changes but reset for a new playthrough; gameplay state and difficulty must retain their established behavior.

Godot was not launched; no automated tests, gameplay simulation or screenshots were run. Visual alignment and input behavior await manual playtesting.
