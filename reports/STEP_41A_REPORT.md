# Step 41A — Title screen and game entry

Checkpoint: `da54baf` (before this task's changes).

## Files

- `project.godot`: startup now opens `scenes/title.tscn`; display configuration is unchanged.
- `scenes/title.tscn`, `scripts/title.gd`: title, decorative apartment and character preview, main menu, difficulty selection, help and functional settings.
- `scripts/hud.gd`: fresh-game entry skips the legacy Start panel; pause-menu Return to Main Menu and the ending's Main Menu button change scenes safely. Gameplay Restart retains the selected difficulty.

## Flow and presentation

The title reuses the existing apartment drawing script and character textures. TipTop gently hovers, with no gameplay character instances, navigation or simulation running. Charcoal rounded panels, amber outlines, cream text, hover/focus states and a uniformly fitted screen-space CanvasLayer provide mouse and keyboard navigation. Difficulty and settings panels are centered; the help text scrolls inside its panel.

New Game defaults to Medium and reads descriptions and durations from the existing difficulty profiles. Begin Day 1 calls the established complete reset, applies the selected difficulty and loads one apartment scene. The clock stays paused until the fresh HUD starts the opening dialogue. Return to Main Menu unloads the apartment; starting again resets needs, sessions, repairs, research, clock and scene-local dialogue flags. No gameplay balance or apartment art changes.

Help explains movement, interaction, research playback, repairs versus cleanup, fullness, Mood, leisure, sleeping and the 75% showcase target without ending spoilers.

## Settings and limitations

- Master volume controls the actual Master audio bus, including mute at zero. The project currently has no audio playback content, so the slider will not produce audible feedback by itself.
- Fullscreen toggles the native window mode. Project stretch, aspect ratio and filtering settings stay unchanged; verify fullscreen in a standalone game window if the editor embeds its play window.
- Settings last for the current app session; no settings file or save system was added. Continue is omitted because no working save system exists.
- Layout and runtime behavior require manual verification; Godot was not launched and no automated tests or screenshots were run.

## Manual playtest

1. Launch the project normally: title, subtitle, apartment preview and four menu buttons appear. Leave it open briefly; the gameplay clock must remain at Day 1, 11 AM when a game begins.
2. Navigate with mouse, Tab/arrows and Enter. Check visible focus states, Escape/Back, and scrolling the help page. Confirm the full menu fits at windowed and fullscreen sizes.
3. Open New Game: Medium is selected. Switch through Easy/Medium/Hard and verify descriptions/durations against existing values. Begin Day 1 and press Enter repeatedly during the fade: only one apartment/opening conversation should start.
4. Check initial research 0%, four work sessions, fresh needs and repair states. Dismiss the opening and morning dialogue, then verify movement, chores, research Watch/6x/Skip, repairs and HUD behavior.
5. Pause with Escape. Resume must retain the session. Restart Game must reset the playthrough while retaining difficulty. Return to Main Menu, then start again: no old messes, dialogue flags, clock progress or duplicate TipTop should carry over.
6. Test volume at zero and restore it; toggle fullscreen twice. Reopen Settings during the same app run and confirm current values remain reflected.
7. Complete a normal day and verify sleeping, next-day greeting and lighting reset. Check the existing ending flow; Main Menu should return to the title. Test Quit last.
