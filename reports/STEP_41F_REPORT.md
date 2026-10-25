# Step 41F — Tutorial spotlight, HUD details and activity controls

Checkpoint: `677b679`, before these changes.

## Files modified

- `scripts/tutorial.gd`: spotlight cutout, stronger borders, pointer and placement, nearby fixture E input, tutorial exit and activity-control wording.
- `scripts/hud_details.gd`: fixed-position icon captions, crossing corridor and pinned-selection behavior.
- `scripts/hud.gd`: structured detail rows, concise research/needs information, session-menu information and Watch/6x/Skip/Eject controls with confirmation.
- `scripts/player.gd`: authoritative remaining-session count in the desk prompt.
- `scripts/title.gd`: visual How to Play cards and entry to the existing guided game.
- This report.

No game-state, balance, AI, world-layout/camera-fit, character-art or ending files were changed.

## Tutorial spotlight

The existing tutorial draws four nonoverlapping translucent regions around the live target rectangle. The target is a genuine cutout, not a transparent shape painted over a dim layer. Dimming is 60%. The amber outline is approximately four viewport pixels thick after the HUD transform; HUD outlines have rounded corners, while world bounds stay square/pixel-friendly. A restrained pulse and arrow connect the instruction to its target.

World/HUD bounds still use the current camera/canvas transforms. The instruction chooses nearby candidate positions outside the target, preferring positions that also avoid Judy and TipTop. It retains its position while that space remains clear. Drawing does not capture mouse input or stop movement. A nearby highlighted fixture can receive the same E press that acknowledges its explanation; Enter and Got it remain explanation-only controls. Modal dialogue and active tasks retain their existing tutorial deferral rules.

Skip Tutorial remains available. A game explicitly launched through Play Tutorial also has Exit Tutorial in its guide/pause interface, using the existing safe main-menu route. Exit remains available through Pause after skipping the guide.

## HUD labels and detail cards

One category caption appears immediately beneath the hovered/focused icon: Research, TipTop, Time Usage or Needs. A fixed gutter prevents the row from moving when the caption appears. Captions are clamped to the reserved sidebar width. Pinned categories retain their details when other icons are hovered; clicking a different icon changes the pin. The pointer can cross the gutter/count area into the card without closing it. Icon-only buttons now have explicit accessible names instead of duplicate native tooltip popups.

Details reuse the existing panel/page hierarchy with icon headers, dividers and HBox rows:

- Research: readiness/current-work status, efficiency, only applicable modifiers and one next action. No repeated progress/target/difficulty/base reward, session duration or playback paragraph.
- TipTop: four short routine rows, checkmarks/strikethrough and repaired count.
- Time: total elapsed time, the existing stacked distribution and six rows with corresponding monochrome icons and right-aligned durations. Existing accounting sources are unchanged.
- Needs: fullness/Mood value rows, current status and active penalties/recovery advice. No duplicate large bars or long explanation block; fullness color mapping is unchanged.

Scrolling remains as a fallback for unusually tall content, but the normal cards are much shorter. Existing top bars, research/75% target, deadline countdown and compact warnings remain.

Accessible names use Godot's documented [Control accessibility properties](https://docs.godotengine.org/en/4.5/classes/class_control.html#class-control-property-accessibility-name), available before the project's 4.7 version.

## Research sessions and activity controls

Desk prompts show `remaining / DAILY_WORK_SESSIONS` directly from game state, including exhausted and blocked states. The research choice menu shows used/remaining sessions, selected difficulty, actual tap-adjusted game-time cost, approximate Watch duration, current efficiency/reward and availability. Durations/rewards/counters are not changed.

The reserved bottom activity strip now contains four persistent controls for both research and personal activities: Watch 1x, Fast 6x, Skip and Eject. Watch/6x explicitly select playback speed. Skip calls the existing chronological completion methods. Eject pauses for confirmation, with Keep working focused by default. Confirming calls the existing `GameState.eject_current_task()`; the existing player coroutines restore standing poses and locks. Elapsed time remains spent, research sessions stay charged and completion rewards are not granted. The button disables when no unfinished task exists or the task is finishing/paused. Repairs do not receive a fake cancellation control.

Eject and its old explanatory text were removed from Pause. Escape closes Eject confirmation without cancellation; ordinary Pause/Resume remains unchanged. Pause now focuses Resume and allows GUI keyboard navigation instead of consuming all keyboard events. Comic input, tutorial input and transient overlays are gated while confirmation is open.

## How to Play and tutorial entry

The main-menu guide uses six separated horizontal cards: Judy, research, TipTop, needs, deadline and activities. It reuses Judy/TipTop sheet frames and the existing procedural desk/fridge, with small matching clock/playback visuals for the remaining sections. Back and Play Tutorial stay outside the scrolling content.

Play Tutorial starts a fresh guided Day 1 through the existing difficulty/new-game/reset route. New Game retains its ordinary entry behavior. No competing tutorial logic, new save system or unrelated art was added.

## Limitations

- The inspected project still has the Step 41B guided apartment flow, not a separate isolated Step 41D practice sandbox. Play Tutorial deliberately reuses that existing playable flow; it starts a fresh game and does not preserve a previous unsaved run. Its subtitle makes the fresh-start behavior explicit.
- Spotlights follow rectangular visual/Control bounds, not per-pixel silhouettes. Placement avoids characters/targets where space allows; dense situations can still require manual visual adjustment.
- The six-card How to Play guide scrolls vertically. Its action buttons remain visible. Sidebar scrolling remains available for exceptional content heights.
- Runtime layout, focus, outline thickness and activity cleanup have not been verified in Godot.

## Manual playtest checklist

1. Launch Play Tutorial, choose a difficulty and finish the opening. Check 60% dimming, an undimmed target, strong amber border and pointer for world objects and HUD cards. Move Judy, resize/toggle fullscreen and verify alignment/placement follows the camera without obstructing the target.
2. Use E near a highlighted fixture, Enter/Got it for explanations and mouse interaction with highlighted HUD tabs. Check Skip, Exit Tutorial, Pause → Exit Tutorial and restarting the guide. TipTop's existing onboarding hold must release after completion/Skip.
3. Hover/focus every HUD icon: its name should appear directly underneath without moving the row. Cross slowly into its detail card. Pin one category, hover/focus another and confirm the pinned details remain until clicking a different category. Click again to unpin.
4. Inspect research details with no problems, hunger penalties, tap running, scattered books, low Mood and the final-day exception. Only applicable modifiers and a clear next action should appear; progress/target/difficulty/durations should remain in their intended primary/menu locations.
5. Check repaired routine rows retain checkmarks and strikethrough. Inspect all six aligned time categories/distribution, fullness colors, Mood status and needs warnings. Confirm cards remain in the sidebar rather than covering the apartment.
6. Approach the desk at 4, 2 and 0 sessions remaining. Open the research menu and compare used/remaining counts, actual duration, tap penalty and Watch estimate across Easy/Medium/Hard. A new day must restore four sessions; Skip/Eject must not add any.
7. During research, meals and every leisure activity, switch Watch ↔ 6x, use Skip, and open Eject confirmation. Keep working/Escape must resume the same task. Confirm Eject must preserve elapsed time, grant no completion reward, leave a started research session charged and restore Judy's control/pose. Repeat near completion; the cancellation control should disable once completion is committed.
8. Verify Eject is absent from Pause. Use mouse and keyboard to navigate Pause and Eject confirmation. Ensure there are no overlapping comics, tutorial masks, confirmations or stale activity strips, and no repeated-E/Enter duplicate actions.
9. Read the six visual How to Play cards, scroll and verify Back/Play Tutorial stay visible. Check sprite sharpness, short wrapping, keyboard focus and fresh tutorial entry.
10. Check ordinary movement/interactions, TipTop chores/repairs/mosquitoes, Watch/6x/Skip time accounting/countdown, day transitions and all three endings. World framing, the 75% threshold and difficulty/reward values must remain unchanged.

No Godot launches, automated tests, gameplay simulation or screenshots were performed. Manual verification remains outstanding.
