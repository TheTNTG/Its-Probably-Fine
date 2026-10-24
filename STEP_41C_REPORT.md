# Step 41C — Three showcase endings

Checkpoint: `205428b`, before ending changes. Existing editor/project and tutorial changes are preserved in that checkpoint.

## Files changed

- `scenes/showcase_good.tscn`
- `scenes/showcase_bittersweet.tscn`
- `scenes/showcase_bad.tscn`
- `scripts/showcase.gd`
- `scripts/hud.gd`
- This report.

No apartment scene, gameplay state, difficulty values, research/repair calculations or character assets were changed in this step.

## Presentation

Three stage scenes share a lightweight drawing/presentation script. Each has a small university stage, curtains, projector screen, warm spotlights, audience silhouettes and both existing character sprites. Good uses golden colors, completed charts and enthusiastic applause; Bittersweet uses muted warmth, unfinished charts and restrained applause; Bad uses cooler shadows, a failed projection, scattered papers and awkward audience reactions. TipTop retains his hover frames. Judy's stage pose has a slight tired/embarrassed tilt in the less successful outcomes.

Each scene uses the existing comic portraits, expression changes, sentence-aware pagination and E/Enter advancement for its final exchange. Existing TipTop ending statements remain present verbatim, including “Bow routine confirmed. No water required.” The ending title and final stats appear only after the conversation, followed by mouse/keyboard Restart and Main Menu buttons.

## Branching and transition

The original predicates are retained exactly:

| Outcome | Existing condition | New title |
| --- | --- | --- |
| Good | Research >= 75% and `tiptop_fixed` | AGAINST ALL ODDS |
| Bittersweet | Research >= 75%, TipTop not fully fixed | GOOD ENOUGH |
| Bad | Research < 75% | IT'S PROBABLY NOT FINE |

At Day 3's existing end-day wipe, `continue_day()` is called once. The selected stage is created under full black and snapshots research percentage and repaired-routine count before any restart. The sleep-pose lock is released so the existing comic system can proceed. The apartment remains paused behind an opaque screen-space stage; its layout, camera and mechanics remain intact.

The stage instance guard and existing story-event flag prevent duplicate creation/conversations. Old apartment feedback queues are cleared when entering the showcase so they cannot interrupt the final exchange. Escape does not open the apartment pause menu over the stage; the result buttons provide the exit routes. Enter auto-repeat is consumed during the showcase. Result buttons disable both routes before requesting a scene change.

Restart uses the existing fresh-room reset and retains difficulty. Main Menu uses the existing title-scene route. The paused old room/stage unload together when leaving. New-game state is reset only after choosing an exit, never before outcome selection.

## Limitations

No dedicated showcase art, seated audience animations or applause audio were available/added. Stage details are procedural pixel-style shapes matching the game's existing approach, characters reuse their current sprites, and expressions come from existing comic portraits. Audience reactions are simple silhouette arm movements. The failed projection uses slow positional glitches rather than flashing. Visual quality and runtime behavior await manual playtesting.

## Manual playtest

1. Reach the Day 3 showcase with >=75% research and all routines repaired. Verify the Good stage, appreciative dialogue, golden atmosphere, completed projection and applause.
2. Reach it with >=75% and at least one faulty routine. Verify the Bittersweet stage, incomplete projection, modest applause and awkward/supportive exchange.
3. Reach it below 75%, including with all routines fixed. Verify the Bad stage, failed demonstration, paper scatter and final schedule punchline. Check exactly 75% follows the >=75% branches.
4. Verify goodnight/sleep precedes the existing black wipe, only one showcase appears, and ending dialogue starts after the reveal. Read every page using E and Enter; hold Enter briefly to check repeat suppression. No old apartment/tutorial/repair messages should overlap.
5. Confirm both sprites are visible together, portrait expressions match the exchange, and the ending title/stats/buttons appear only after the final page. Check windowed/fullscreen and different aspect ratios for clipping.
6. Use Restart: confirm Day 1, selected difficulty, fresh needs/research/sessions/repairs and opening/tutorial flow. Reach another ending or return to title, then use Main Menu and New Game; verify no duplicated TipTop, clocks or old ending dialogue. Test mouse and keyboard focus on both result buttons.
7. Check Day 1→2 and Day 2→3 transitions, research Watch/6x/Skip, repairs and apartment interactions remain unchanged.

Godot was not launched; no automated tests, gameplay simulation or screenshots were run.
