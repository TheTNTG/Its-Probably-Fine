# Step 41E — Compact HUD and contextual details

Checkpoint before edits: `0058ffc`.

## Files changed

- `scripts/hud.gd`: compact sidebar, category icons, needs presentation, live showcase countdown and detail-page bindings.
- `scripts/hud_details.gd`: hover/focus/pin presentation controller.
- `scripts/tutorial.gd`: updated HUD targets and concise explanations.
- This report.

No game-state, research, repair, needs, AI, clock-accounting, world/camera-fit, apartment, menu or ending files were changed.

## Layout and input

The existing top clock and needs card stay in place. The right sidebar now keeps research percentage/bar/75% target, showcase countdown/bar, four small monochrome category icons and TipTop's repair count visible. Repair rows, session/efficiency details and time accounting are collapsed by default. Short visible warnings cover scattered books, blocked research, critical fullness and insufficient research time; top needs labels retain percentage and status text.

The four icons are a notebook, robot, clock and heart. They are small monochrome pixel textures created once in memory; no external assets or emoji were added. Existing HUD font sizes are retained, and new explanatory text uses 7–8-point reference sizes rather than compressing more information into smaller text.

Hover or keyboard focus previews a category. Clicking or Enter/Space pins it; clicking the same category again closes it without immediately reopening from its lingering focus. Clicking another category changes the pin. Pressed borders identify the pinned category. Moving into the detail panel keeps it open, with a 0.18-second grace period across the gap. Leaving both focus and pointer closes transient previews; pins persist until toggled or the scene unloads.

The detail panel stays inside the existing right-side reservation. Long pages scroll vertically rather than extending over the apartment. Top fullness/Mood hit areas also expose the needs page. Buttons, panels and scrolling receive mouse input. Escape continues to use the existing pause flow. Details hide during dialogue, blocking choices, pause, day transitions and endings; they can be read during active Watch/6x playback without pausing or changing it.

Research details show progress, target, difficulty, actual tap-adjusted session duration, base/current preview reward, efficiency and remaining sessions. Repair details preserve checkmarks and BBCode strikethrough. Time details keep the existing six categories and stretch-ratio distribution bar, reading `displayed_daily_time()` exactly as before.

## Needs colors and warnings

Fullness remains the existing internal Hunger value; 100 means fed. The bar interpolates through muted brick `#aa625c`, terracotta `#c28764`, amber `#c6a367` and sage `#92aa85`. Anchors are brick at 0–24, terracotta at 45, amber at 60 and sage at 75–100, blending between anchors to avoid abrupt changes. Percentage, food icon and status labels provide alternatives to color. Below 25, a steady critical-fullness label provides emphasis without flashing.

Mood uses muted blue-green and changes to restrained terracotta below 45, with the existing break/push-through status text. Details explain the 45-point requirement, existing Day 3 exception, food efficiency and leisure/eating recovery values. No thresholds, drain rates, rewards or overnight calculations were modified.

## Showcase countdown

`current = clamp(time_minutes + clock_fraction + world_accumulator, DAY_START, DAY_END)`

`remaining = clamp((LAST_DAY - day) * DAY_LENGTH + DAY_END - current, 0, LAST_DAY * DAY_LENGTH)`

The text shows remaining playable hours/minutes, rounded up to the next displayed minute. The bar uses the unrounded fraction and a zero Range step for continuous updates. The same authoritative clock drives it during idle play, Watch, 6x and Skip. The daily clock bar remains separate.

Expected values from the existing three 11 AM–8 PM days:

| Game state | Showcase time left |
| --- | --- |
| Day 1, 11 AM | 27h |
| Day 1, 8 PM | 18h |
| Day 2, 11 AM | 18h |
| Day 3, 11 AM | 9h |
| Day 3, 8 PM | 0h |

Sleep does not introduce calendar-night hours or a second decrement. Choosing to end a day early forfeits that day's remaining playable time through the existing clock logic. The countdown never creates or advances a clock. Its bar blends sage/teal → amber → terracotta → brick as the remaining fraction decreases; the last hour receives steady text emphasis.

## Tutorial integration and limitations

The existing tutorial now highlights the actual countdown card and robot-category button through their live Control transforms. It explains playable-hour accounting, hover/focus/click disclosure and fullness colors within existing short tips. Existing completion flags and the TipTop onboarding hold are unchanged.

No separate Step 41D sandbox implementation was present in the inspected project. This task preserves the current Step 41B guided flow; it does not introduce a replacement tutorial or sandbox. Long detail text intentionally scrolls in the narrow reserved sidebar. Native tooltips provide category names, with the live details as the main explanation. Runtime sizing, focus behavior and visual alignment still require manual verification.

## Manual playtest checklist

1. Start a fresh game: confirm Day/time, full/Mood percentages and bars, research/75% target, 27h countdown and TipTop count remain visible. The full checklist/time rows should be hidden initially; the apartment must retain its previous framing and scale.
2. Hover each category, cross into its panel, scroll, then leave. Verify no flicker or expansion over the world. Click to pin/unpin; switch categories. Repeat using Tab, Enter/Space and arrow/page scrolling. Also focus/click the top needs areas.
3. Observe fullness at 100/75/60/45/24/0 through ordinary play and meals: check muted green-to-red blending, numeric percentage, Well-fed/Hungry labels and critical treatment. Drop Mood below 45 and verify its warning, recovery guidance and existing research restriction.
4. Repair each routine and open the robot details: count, checkmarks and strikethrough must update. Check research sessions, current efficiency, difficulty durations and tap penalties against existing gameplay/menu values.
5. Open time details during Watch, 6x and Skip. Confirm category totals and stacked shares still match the existing tracker; switching detail pages must not pause, eject or complete tasks.
6. Follow countdown values across all five boundary points above. Check smooth bar reduction, urgency colors, no reset on a new day and zero at the Day 3 cutoff. Sleep early once and verify only the remaining portion of that playable day is forfeited.
7. Open pause, dialogue, repair choices and day wipes while a category is pinned. Details should hide and resume safely; Escape behavior, comic progression and existing TipTop/tutorial behavior must remain intact. Reach each ending and return to the menu/new game.
8. Resize, toggle fullscreen and inspect supported aspect ratios. Detail text should scroll rather than clip, all panels must remain inside the HUD reservation, and tutorial outlines should align with the revised controls. Check that clicking HUD items never triggers an apartment action underneath.

Godot was not launched. No automated tests, gameplay simulation or screenshots were run; manual playtesting remains outstanding.
