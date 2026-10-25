# Step 40B.3: implementation, feasibility and manual checks

Modified: scripts/game_state.gd, scripts/hud.gd, scripts/player.gd, scripts/tiptop.gd, and this report. Checkpoint: 04ec620. No Godot launch, automated test or screenshot was performed. The schedules below are arithmetic ledgers, not gameplay simulation or playtest results.

## Changes

- Hunger and Mood return to a compact top card. Their mechanics/status thresholds are unchanged. The lower needs panel is gone; efficiency/session information remains below time usage.
- Camera zoom is 8% larger with the same geometry, collision, navigation and sprite proportions. Sidebar labels increase from 5 to 6 reference pixels and research from 8 to 9. Nearest texture sampling is preserved. Fractional fit is retained where an integer zoom would reduce visibility; actual pixel density and UI fit require manual review.
- E Interact / ESC Pause replaces the I/Tab legend. Those shortcuts only opened placeholder information panels; no inventory item system was removed. ESC pauses the existing tree, clock, needs, AI, insects and lighting. Resume preserves any underlying comic pause. ESC first dismisses an existing choice/repair menu; transition/new-game/day-end screens retain their existing controls.
- Pause provides Resume, Eject, Restart Game, Return to Main Menu and Quit. Restart Game preserves the selected difficulty and begins Day 1; Main Menu returns to fresh Medium-default selection. Restart Day is not offered because no day snapshot/rollback system exists.
- Eject is supported for unfinished seated research, eating and leisure. It commits only previously elapsed fractional time, clears playback flags without completion rewards, and lets the owning coroutine restore Judy. Research sessions already charged remain charged; no research, completion Mood loss or break-streak reward is applied. Eating/leisure cancellation awards no fullness/Mood and does not reset the streak.
- Eject is disabled during walking/pose animations, atomic repairs and cleanup, or when no unfinished task exists. Its explanation identifies these limitations. Repairs preserve their existing synchronous playback and cannot be interrupted safely halfway through.
- Difficulty config now owns base research durations: Easy 90, Medium 120, Hard 180 minutes. Existing tap penalties remain ×4/3 duration and ×0.5 reward. Watch retains the same clock rate (120 game minutes per 180 real seconds), so base sessions last approximately 135/180/270 real seconds; 6x is one sixth of those times. All reward/need modifiers and the 75% target are unchanged.
- Explicit mosquito commands preempt the current chore through its existing serial handoff without completing it or granting its effects. Active pursuits are not reset by repeated commands. Batches contain up to three existing insects; each target requires a real approach and successful nearby removal. Missing/failed targets are bounded by existing retries plus a 30-second batch limit. Autonomous batches retain cooldown/fairness so ordinary chores resume. Success thoughts report actual removals.

## Hard is mathematically impossible at the requested values

1. Eight 180-minute sessions plus four 60-minute repairs require 1680 minutes, more than 1620. Thus at most seven sessions are possible, even with zero walking, meals, breaks or cleanup.
2. Three Hard sessions consume an entire nine-hour day. With no time for a break, Mood before the third session is at most 90 − 50 − 14.4 = 25.6. Therefore such a day can only be Day 3, using the low-Mood exception. Seven sessions must be distributed 2 / 2 / 3.
3. Before Day 3, four research sessions plus all four repairs require 960 minutes. At most 120 minutes remain for other activities, hence at most four meals. Ignoring fullness clamping and using only the minimum overnight depletion of 20 total makes an intentionally generous bound. With n meals and no other time, Day 3 fullness <= 85 + 40n − (960+30n)×8.4/60 − 20 = −69.4 + 35.8n. For n<=4 this is at most 73.8. Early sleep, leisure or fewer meals cannot increase this upper bound.
4. Day 3 therefore has fullness at most 73.8 / 48.6 / 23.4 at its three research starts, so efficiency is at most 1.0 / 0.9 / 0.75. The last session also has the 0.8 Mood penalty: at most 8 + 7.2 + 4.8 = 20 research points.
5. The other four sessions contribute at most 32, repairs 12, and the existing proactive bonus 10: **74% maximum**. Six or fewer sessions have a still lower cap: 6×8 +12+10 =70%. Actual meals, Mood constraints, navigation and cleanup can only worsen these optimistic bounds.
**No difficulty or ending value was silently changed. Hard remains +8 / 180 minutes and the good ending remains 75%.**

## Smallest practical one-setting recommendation

The explicit six-session Hard schedule below has total research efficiency 5.65 (two full-efficiency sessions, then 0.90/0.75, then two full-efficiency sessions). Fixed bonuses total 22. Its required base is (75−22)/5.65 = 9.38053097. A base reward of **9.4%** is the smallest one-decimal increase that makes this supplied schedule feasible, yielding **75.11%**. This is not a claim of a globally optimal balance, and it is NOT implemented. A larger margin such as 9.5 would be more forgiving. All other Hard settings can stay unchanged.

## Schedule conventions

Times use the existing 11:00–20:00 day. Every row consumes only its stated in-game minutes. Walking gets explicit Misc allowances; dialogue pauses time. Research repeatedly uses its valid desk standing point, so adjacent sessions need no additional furniture approach. TipTop is repaired before the relevant mess becomes a blocker: sink and bookshelf are first on the Hard example. Beds are cleaned at the end of Day 1 if needed; on subsequent days the repaired bed routine can maintain them during long work/activity windows. Navigation failure or additional optional work is not assumed away as tested behavior: all runtime accessibility still needs playtesting. If the bed was already cleaned, its budget can be free time instead. No plan uses running-tap research penalties.

## Easy

| Day / time | Activity | Gain | End fullness | End Mood |
|---|---|---:|---:|---:|
| D1 11:00–11:01 | Walk / free time | — | 84.92 | 89.98 |
| D1 11:01–11:06 | Make bed | — | 84.51 | 89.86 |
| D1 11:06–11:51 | Repair sink | +15.00% | 80.84 | 88.81 |
| D1 11:51–12:36 | Repair plant | +5.00% | 77.16 | 87.76 |
| D1 12:36–13:21 | Repair bookshelf | +5.00% | 73.49 | 86.71 |
| D1 13:21–14:06 | Repair bed | +5.00% | 69.81 | 85.66 |
| D1 14:06–14:07 | Walk / free time | — | 69.73 | 85.64 |
| D1 14:07–14:37 | Eat | — | 100.00 | 84.94 |
| D1 14:37–14:38 | Walk / free time | — | 99.92 | 84.91 |
| D1 14:38–16:08 | Research (starts H 99.92, M 84.91) | +15.00% | 92.57 | 67.81 |
| D1 16:08–16:09 | Walk / free time | — | 92.49 | 67.79 |
| D1 16:09–17:39 | Research (starts H 92.49, M 67.79) | +15.00% | 85.14 | 50.69 |
| D1 17:39–17:40 | Walk / free time | — | 85.06 | 50.67 |
| D1 17:40–18:00 | Rubik's cube | — | 83.42 | 75.20 |
| D1 18:00–20:00 | Walk / free time | — | 73.62 | 72.40 |
| D1 total | 540 minutes; research 60.00% | | | |
| Overnight | Fullness −10; next Mood 90 | | 63.62 | 90.00 |
| D2 11:00–11:01 | Walk / free time | — | 63.54 | 89.98 |
| D2 11:01–11:31 | Eat | — | 100.00 | 89.28 |
| D2 11:31–11:32 | Walk / free time | — | 99.92 | 89.25 |
| D2 11:32–13:02 | Research (starts H 99.92, M 89.25) | +15.00% | 92.57 | 72.15 |
| D2 13:02–13:03 | Walk / free time | — | 92.49 | 72.13 |
| D2 13:03–13:33 | Eat | — | 100.00 | 71.43 |
| D2 13:33–13:34 | Walk / free time | — | 99.92 | 71.41 |
| D2 13:34–15:04 | Research (starts H 99.92, M 71.41) | +15.00% | 92.57 | 54.31 |
| D2 15:04–15:05 | Walk / free time | — | 92.49 | 54.28 |
| D2 15:05–15:35 | Phone games | — | 90.04 | 83.58 |
| D2 15:35–15:36 | Walk / free time | — | 89.96 | 83.56 |
| D2 15:36–17:06 | Research (starts H 89.96, M 83.56) | +15.00% | 82.61 | 66.46 |
| D2 17:06–17:07 | Walk / free time | — | 82.52 | 66.44 |
| D2 17:07–17:37 | Phone games | — | 80.07 | 95.74 |
| D2 17:37–20:00 | Walk / free time | — | 68.40 | 92.40 |
| D2 total | 540 minutes; research 100.00% | | | |
| Overnight | Fullness −10; next Mood 80 | | 58.40 | 80.00 |
| D3 11:00–11:01 | Walk / free time | — | 58.31 | 79.98 |
| D3 11:01–11:31 | Eat | — | 95.86 | 79.28 |
| D3 11:31–11:32 | Walk / free time | — | 95.78 | 79.25 |
| D3 11:32–13:02 | Research (starts H 95.78, M 79.25) | +15.00% | 88.43 | 62.15 |
| D3 13:02–13:03 | Walk / free time | — | 88.35 | 62.13 |
| D3 13:03–13:33 | Phone games | — | 85.90 | 91.43 |
| D3 13:33–13:34 | Walk / free time | — | 85.82 | 91.41 |
| D3 13:34–14:04 | Eat | — | 100.00 | 90.71 |
| D3 14:04–14:05 | Walk / free time | — | 99.92 | 90.68 |
| D3 14:05–15:35 | Research (starts H 99.92, M 90.68) | +15.00% | 92.57 | 73.58 |
| D3 15:35–15:36 | Walk / free time | — | 92.49 | 73.56 |
| D3 15:36–16:06 | Phone games | — | 90.04 | 100.00 |
| D3 16:06–16:07 | Walk / free time | — | 89.96 | 99.98 |
| D3 16:07–17:37 | Research (starts H 89.96, M 99.98) | +15.00% | 82.61 | 82.88 |
| D3 17:37–20:00 | Walk / free time | — | 70.93 | 79.54 |
| D3 total | 540 minutes; research 100.00% | | | |

## Medium

| Day / time | Activity | Gain | End fullness | End Mood |
|---|---|---:|---:|---:|
| D1 11:00–11:01 | Walk / free time | — | 84.88 | 89.97 |
| D1 11:01–11:06 | Make bed | — | 84.30 | 89.80 |
| D1 11:06–12:06 | Repair sink | +14.00% | 77.30 | 87.80 |
| D1 12:06–13:06 | Repair plant | +4.00% | 70.30 | 85.80 |
| D1 13:06–14:06 | Repair bookshelf | +4.00% | 63.30 | 83.80 |
| D1 14:06–15:06 | Repair bed | +4.00% | 56.30 | 81.80 |
| D1 15:06–15:07 | Walk / free time | — | 56.18 | 81.77 |
| D1 15:07–15:37 | Eat | — | 92.68 | 80.77 |
| D1 15:37–15:38 | Walk / free time | — | 92.57 | 80.73 |
| D1 15:38–17:38 | Research (starts H 92.57, M 80.73) | +10.00% | 78.57 | 56.73 |
| D1 17:38–17:39 | Walk / free time | — | 78.45 | 56.70 |
| D1 17:39–19:39 | Research (starts H 78.45, M 56.70) | +10.00% | 64.45 | 32.70 |
| D1 19:39–19:40 | Walk / free time | — | 64.33 | 32.67 |
| D1 19:40–20:00 | Rubik's cube | — | 62.00 | 57.00 |
| D1 total | 540 minutes; research 46.00% | | | |
| Overnight | Fullness −10; next Mood 80 | | 52.00 | 80.00 |
| D2 11:00–11:01 | Walk / free time | — | 51.88 | 79.97 |
| D2 11:01–11:31 | Eat | — | 88.38 | 78.97 |
| D2 11:31–11:32 | Walk / free time | — | 88.27 | 78.93 |
| D2 11:32–13:32 | Research (starts H 88.27, M 78.93) | +10.00% | 74.27 | 54.93 |
| D2 13:32–13:33 | Walk / free time | — | 74.15 | 54.90 |
| D2 13:33–14:03 | Eat | — | 100.00 | 53.90 |
| D2 14:03–14:04 | Walk / free time | — | 99.88 | 53.87 |
| D2 14:04–16:04 | Research (starts H 99.88, M 53.87) | +10.00% | 85.88 | 29.87 |
| D2 16:04–16:05 | Walk / free time | — | 85.77 | 29.83 |
| D2 16:05–16:35 | Phone games | — | 82.27 | 58.83 |
| D2 16:35–16:36 | Walk / free time | — | 82.15 | 58.80 |
| D2 16:36–18:36 | Research (starts H 82.15, M 58.80) | +10.00% | 68.15 | 34.80 |
| D2 18:36–18:37 | Walk / free time | — | 68.03 | 34.77 |
| D2 18:37–19:07 | Phone games | — | 64.53 | 63.77 |
| D2 19:07–20:00 | Walk / free time | — | 58.35 | 62.00 |
| D2 total | 540 minutes; research 76.00% | | | |
| Overnight | Fullness −10; next Mood 80 | | 48.35 | 80.00 |
| D3 11:00–11:01 | Walk / free time | — | 48.23 | 79.97 |
| D3 11:01–11:31 | Eat | — | 84.73 | 78.97 |
| D3 11:31–11:32 | Walk / free time | — | 84.62 | 78.93 |
| D3 11:32–13:32 | Research (starts H 84.62, M 78.93) | +10.00% | 70.62 | 54.93 |
| D3 13:32–13:33 | Walk / free time | — | 70.50 | 54.90 |
| D3 13:33–14:03 | Phone games | — | 67.00 | 83.90 |
| D3 14:03–14:04 | Walk / free time | — | 66.88 | 83.87 |
| D3 14:04–14:34 | Eat | — | 100.00 | 82.87 |
| D3 14:34–14:35 | Walk / free time | — | 99.88 | 82.83 |
| D3 14:35–16:35 | Research (starts H 99.88, M 82.83) | +10.00% | 85.88 | 58.83 |
| D3 16:35–16:36 | Walk / free time | — | 85.77 | 58.80 |
| D3 16:36–17:06 | Phone games | — | 82.27 | 87.80 |
| D3 17:06–17:07 | Walk / free time | — | 82.15 | 87.77 |
| D3 17:07–19:07 | Research (starts H 82.15, M 87.77) | +10.00% | 68.15 | 63.77 |
| D3 19:07–20:00 | Walk / free time | — | 61.97 | 62.00 |
| D3 total | 540 minutes; research 100.00% | | | |

## Hard — requested

| Day / time | Activity | Gain | End fullness | End Mood |
|---|---|---:|---:|---:|
| D1 11:00–11:01 | Walk / free time | — | 84.86 | 89.96 |
| D1 11:01–12:01 | Repair sink | +13.00% | 76.46 | 87.56 |
| D1 12:01–13:01 | Repair bookshelf | +3.00% | 68.06 | 85.16 |
| D1 13:01–13:02 | Walk / free time | — | 67.92 | 85.12 |
| D1 13:02–13:32 | Eat | — | 100.00 | 83.92 |
| D1 13:32–13:33 | Walk / free time | — | 99.86 | 83.88 |
| D1 13:33–16:33 | Research (starts H 99.86, M 83.88) | +8.00% | 74.66 | 51.68 |
| D1 16:33–19:33 | Research (starts H 74.66, M 51.68) | +8.00% | 49.46 | 19.48 |
| D1 19:33–19:34 | Walk / free time | — | 49.32 | 19.44 |
| D1 19:34–19:54 | Rubik's cube | — | 46.52 | 43.64 |
| D1 19:54–19:55 | Walk / free time | — | 46.38 | 43.60 |
| D1 19:55–20:00 | Make bed | — | 45.68 | 43.40 |
| D1 total | 540 minutes; research 32.00% | | | |
| Overnight | Fullness −15; next Mood 80 | | 30.68 | 80.00 |
| D2 11:00–11:01 | Walk / free time | — | 30.54 | 79.96 |
| D2 11:01–12:01 | Repair plant | +3.00% | 22.14 | 77.56 |
| D2 12:01–13:01 | Repair bed | +3.00% | 13.74 | 75.16 |
| D2 13:01–13:02 | Walk / free time | — | 13.60 | 75.12 |
| D2 13:02–13:32 | Eat | — | 49.40 | 73.92 |
| D2 13:32–13:33 | Walk / free time | — | 49.26 | 73.88 |
| D2 13:33–16:33 | Research (starts H 49.26, M 73.88) | +7.20% | 24.06 | 41.68 |
| D2 16:33–16:34 | Walk / free time | — | 23.92 | 41.64 |
| D2 16:34–16:54 | Rubik's cube | — | 21.12 | 65.84 |
| D2 16:54–16:55 | Walk / free time | — | 20.98 | 65.80 |
| D2 16:55–19:55 | Research (starts H 20.98, M 65.80) | +6.00% | 0.00 | 33.60 |
| D2 19:55–20:00 | Walk / free time | — | 0.00 | 33.40 |
| D2 total | 540 minutes; research 51.20% | | | |
| Overnight | Fullness −15; next Mood 40 | | 0.00 | 40.00 |
| D3 11:00–11:01 | Walk / free time | — | 0.00 | 39.96 |
| D3 11:01–11:31 | Phone games | — | 0.00 | 68.76 |
| D3 11:31–11:32 | Walk / free time | — | 0.00 | 68.72 |
| D3 11:32–12:02 | Eat | — | 40.00 | 67.52 |
| D3 12:02–12:32 | Eat | — | 75.80 | 66.32 |
| D3 12:32–12:33 | Walk / free time | — | 75.66 | 66.28 |
| D3 12:33–15:33 | Research (starts H 75.66, M 66.28) | +8.00% | 50.46 | 34.08 |
| D3 15:33–15:34 | Walk / free time | — | 50.32 | 34.04 |
| D3 15:34–16:04 | Phone games | — | 46.12 | 62.84 |
| D3 16:04–16:05 | Walk / free time | — | 45.98 | 62.80 |
| D3 16:05–16:35 | Eat | — | 81.78 | 61.60 |
| D3 16:35–16:36 | Walk / free time | — | 81.64 | 61.56 |
| D3 16:36–19:36 | Research (starts H 81.64, M 61.56) | +8.00% | 56.44 | 29.36 |
| D3 19:36–19:37 | Walk / free time | — | 56.30 | 29.32 |
| D3 19:37–19:57 | Rubik's cube | — | 53.50 | 53.52 |
| D3 19:57–20:00 | Walk / free time | — | 53.08 | 53.40 |
| D3 total | 540 minutes; research 67.20% | | | |

## Hard — proposed 9.4 base, NOT implemented

| Day / time | Activity | Gain | End fullness | End Mood |
|---|---|---:|---:|---:|
| D1 11:00–11:01 | Walk / free time | — | 84.86 | 89.96 |
| D1 11:01–12:01 | Repair sink | +13.00% | 76.46 | 87.56 |
| D1 12:01–13:01 | Repair bookshelf | +3.00% | 68.06 | 85.16 |
| D1 13:01–13:02 | Walk / free time | — | 67.92 | 85.12 |
| D1 13:02–13:32 | Eat | — | 100.00 | 83.92 |
| D1 13:32–13:33 | Walk / free time | — | 99.86 | 83.88 |
| D1 13:33–16:33 | Research (starts H 99.86, M 83.88) | +9.40% | 74.66 | 51.68 |
| D1 16:33–19:33 | Research (starts H 74.66, M 51.68) | +9.40% | 49.46 | 19.48 |
| D1 19:33–19:34 | Walk / free time | — | 49.32 | 19.44 |
| D1 19:34–19:54 | Rubik's cube | — | 46.52 | 43.64 |
| D1 19:54–19:55 | Walk / free time | — | 46.38 | 43.60 |
| D1 19:55–20:00 | Make bed | — | 45.68 | 43.40 |
| D1 total | 540 minutes; research 34.80% | | | |
| Overnight | Fullness −15; next Mood 80 | | 30.68 | 80.00 |
| D2 11:00–11:01 | Walk / free time | — | 30.54 | 79.96 |
| D2 11:01–12:01 | Repair plant | +3.00% | 22.14 | 77.56 |
| D2 12:01–13:01 | Repair bed | +3.00% | 13.74 | 75.16 |
| D2 13:01–13:02 | Walk / free time | — | 13.60 | 75.12 |
| D2 13:02–13:32 | Eat | — | 49.40 | 73.92 |
| D2 13:32–13:33 | Walk / free time | — | 49.26 | 73.88 |
| D2 13:33–16:33 | Research (starts H 49.26, M 73.88) | +8.46% | 24.06 | 41.68 |
| D2 16:33–16:34 | Walk / free time | — | 23.92 | 41.64 |
| D2 16:34–16:54 | Rubik's cube | — | 21.12 | 65.84 |
| D2 16:54–16:55 | Walk / free time | — | 20.98 | 65.80 |
| D2 16:55–19:55 | Research (starts H 20.98, M 65.80) | +7.05% | 0.00 | 33.60 |
| D2 19:55–20:00 | Walk / free time | — | 0.00 | 33.40 |
| D2 total | 540 minutes; research 56.31% | | | |
| Overnight | Fullness −15; next Mood 40 | | 0.00 | 40.00 |
| D3 11:00–11:01 | Walk / free time | — | 0.00 | 39.96 |
| D3 11:01–11:31 | Phone games | — | 0.00 | 68.76 |
| D3 11:31–11:32 | Walk / free time | — | 0.00 | 68.72 |
| D3 11:32–12:02 | Eat | — | 40.00 | 67.52 |
| D3 12:02–12:32 | Eat | — | 75.80 | 66.32 |
| D3 12:32–12:33 | Walk / free time | — | 75.66 | 66.28 |
| D3 12:33–15:33 | Research (starts H 75.66, M 66.28) | +9.40% | 50.46 | 34.08 |
| D3 15:33–15:34 | Walk / free time | — | 50.32 | 34.04 |
| D3 15:34–16:04 | Phone games | — | 46.12 | 62.84 |
| D3 16:04–16:05 | Walk / free time | — | 45.98 | 62.80 |
| D3 16:05–16:35 | Eat | — | 81.78 | 61.60 |
| D3 16:35–16:36 | Walk / free time | — | 81.64 | 61.56 |
| D3 16:36–19:36 | Research (starts H 81.64, M 61.56) | +9.40% | 56.44 | 29.36 |
| D3 19:36–19:37 | Walk / free time | — | 56.30 | 29.32 |
| D3 19:37–19:57 | Rubik's cube | — | 53.50 | 53.52 |
| D3 19:57–20:00 | Walk / free time | — | 53.08 | 53.40 |
| D3 total | 540 minutes; research 75.11% | | | |

## Arithmetic results

- Easy: 8 sessions; final 100.00%.
- Medium: 8 sessions; final 100.00%.
- Hard — requested: 6 sessions; final 67.20%.
- Hard — proposed 9.4 base, NOT implemented: 6 sessions; final 75.11%.

## Manual playtest checklist

- Inspect top needs bars, sidebar labels/checklist/time usage, controls and complete room at 16:9, 3:2 and 4:3. Check raised kitchen walls, bottom doorway and comic dialogue for overlap after the zoom increase.
- ESC during idle, research and all seated activities: clock, needs, insects, AI and lighting must freeze. ESC/Resume restores the correct underlying state; dialogue E/Enter still works. Verify no keyboard/mouse action leaks.
- Eject each unfinished research/eating/leisure task after partial Watch/6x: elapsed time stays, no completion reward, no session refund, Judy stands and movement returns. Verify disabled Eject explanation during preparations/atomic actions and no duplicate completion from repeated presses.
- Confirm durations 90/120/180 (running tap 120/160/240), full remaining-time checks, 4-session cap, fractional reward modifiers, repair rewards and the 75% target.
- Research and activity Watch/6x/instant Skip retain prior outcomes; inspect daily time totals, overnight needs and all endings. The previous Step 40B.2 schedules assumed 120-minute Hard/Easy sessions and are superseded by this report.
- Command mosquito removal during a normal chore: TipTop should switch priorities, approach up to three live targets, remove each only nearby, skip vanished/unreachable targets safely, and return to chores. Verify autonomous batches, repeated commands, bookshelf escape and no false success or modal dialogue during work.
- Restart Game should retain difficulty and reset gameplay. Return to Main Menu should restore the Medium-default selector. Ending-screen Restart keeps the existing new-game flow. Quit is manual-only.

Known limitations: no engine launch, automated testing or screenshots were performed. UI fit, pursuit behavior and cancellation restoration remain unverified at runtime. Atomic repairs/cleanup and preparation animations intentionally cannot be ejected. Hard good-ending feasibility is blocked by the requested balance, as proved above.
