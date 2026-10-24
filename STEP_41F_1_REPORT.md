# Step 41F.1 — Post-playtest corrections

Checkpoint before edits: `56721ce`.

## Files changed

- `scripts/game_state.gd`: meal Mood reward, meaningful-break notification and shared research Fullness gate.
- `scripts/hud.gd`: bounded activity help, updated needs/readiness text, input context and stale reminder cleanup.
- `scripts/hud_details.gd`: sidebar focus management and disabled presentation derived from current modal/activity state.
- `scripts/player.gd`: desk gate feedback and deliberate HUD inspection context.
- `scripts/tutorial.gd`, `scripts/title.gd`: affected tutorial/How to Play wording.
- This report.

## Root causes and fixes

Native activity tooltips inherited large default typography outside the compact activity strip. They are replaced with a fixed 236×12 help label inside its existing heading area: size 6 versus size 7 headings/buttons, smart wrapping and clipping. Hover or focus temporarily shows one short description without expanding the strip. Button accessibility descriptions remain available. HUD size and world scale are unchanged.

Eating previously restored only Fullness and bypassed the leisure branch that resets consecutive work. Successful meal completion now adds 40 Fullness and 10 absolute Mood points, both clamped to 0–100, after ordinary passive depletion. Eating, reels, games and cube all reset `work_streak` and `break_reminded`; sleep retains its existing reset. None restores daily work sessions or grants research.

A shared meaningful-break signal removes queued break-reminder events and tagged dialogue lines. An already displayed reminder exchange, including continuation pages, can finish normally. Late stale reminders are also rejected when the work streak is below two. Overnight resets clear queued reminders through the same notification.

The authoritative `research_available()` now requires at least one remaining session and Fullness strictly greater than 20, alongside existing Mood, bookshelf and time rules. Both desk entry paths consult it before starting the pose or playback. The final-day low-Mood exception does not bypass Fullness. The running session is not rechecked against this start gate, so falling to 20 or below does not eject Judy. Desk prompts, research/needs details and guidance show the blocker.

Arrow keys are mapped to movement and Godot GUI navigation. Persistent HUD focus allowed both to respond. Ordinary HUD tabs and their scroll area now have no keyboard focus; movement events are consumed before GUI navigation while Input polling still moves Judy. Mouse hover/click remains supported. Tab explicitly enters HUD inspection, arrows navigate and Enter/Space activate; Tab leaves inspection. Judy stops during this deliberate inspection context, while ordinary world time continues. Real modal menus retain their existing pause/focus handling. Pause clears sidebar focus before focusing Resume.

Sidebar availability now derives from existing pause, dialogue, research, personal activity, repair, household, player animation, transition and ending state. Unavailable buttons disable and dim, transient details/captions hide and sidebar focus clears. Existing pins survive and reappear when safe, with live values. No independent persistent modal-lock flag was introduced.

## Activity audit and preserved behavior

Watch, 6× and Skip still use the existing authoritative time/event simulation and common completion path. Eating rewards are applied once, after the active activity is cleared. Eject clears the unfinished activity without executing completion rewards; elapsed time remains spent, a started research session stays charged and existing player coroutines restore the standing pose. Eject remains in the activity strip, with confirmation, rather than Pause. Repairs retain their existing atomic behavior and do not receive a misleading cancellation control.

Difficulty durations/rewards, other leisure rewards, the four-session daily limit, time categories, needs colors, repair checklist, 75% target, endings, apartment, lighting and TipTop AI are unchanged. Existing tutorial spotlights, visual guide and playable tutorial entry are preserved. Only affected meal, work-gate, break and keyboard explanations were updated; dialogue E/Enter instructions remain present.

## Manual playtest checklist

1. Hover/focus Watch, Fast 6×, Skip and Eject during research and personal activities. Help should stay small and inside the strip without moving controls or expanding the HUD.
2. Complete meals using Watch, 6× and Skip from equivalent starting states. Compare passive depletion plus +40 Fullness/+10 Mood, including values near 100. Eject an unfinished meal: no meal rewards or work-streak reset.
3. Complete two research sessions, then eat. Confirm the work streak resets and no queued stale break reminder appears; spent daily sessions remain spent. Repeat with each leisure activity and sleep. Let an already displayed reminder finish normally.
4. On every difficulty, try research at Fullness 20, below 20 and above 20. Rejected starts should consume no action time/session and start no seated pose. Check Day 3's low-Mood exception still respects Fullness. A legally started session may continue as Fullness drops below the gate.
5. Walk using arrows after mouse-clicking HUD tabs: Judy should move without changing HUD focus. Check mouse pin/unpin, Tab → arrows → Enter/Space inspection, Tab exit and ESC pause/resume. Verify main menu, tutorial, dialogue and ending keyboard controls.
6. Pin each detail category, then enter dialogue, research, meals, leisure, repairs, Eject confirmation, Pause and day transitions. Tabs should dim and reject interaction; pins should return safely afterward. Check completion, Skip, cancellation and repeated activity entry for lingering locks or blank cards.
7. During research and personal activities, switch Watch/6×, Skip and Eject near completion. Confirm once-only rewards, unchanged chronological chores/time, no Eject reward or research-session refund, restored standing pose and controls.
8. Check repair checkmarks, six time categories, needs colors, desk session count, updated How to Play/tutorial text, day resets and all ending branches.

## Verification limits

Source and Git diffs were reviewed only. Godot was not launched; no automated tests, gameplay simulation or screenshots were performed. Runtime focus, typography fit, modal restoration and state equivalence remain for manual playtesting. The existing guided apartment tutorial is reused; no separate tutorial architecture was added.
