# Step 40B.2 implementation and balance arithmetic

This is an arithmetic feasibility calculation, not a Godot run, gameplay simulation, automated test or playtest. Runtime navigation, event ordering and UI fit still require manual verification.

## Implemented rules

- Modified files: `scripts/game_state.gd`, `scripts/hud.gd`, `scripts/player.gd`, `scripts/tiptop.gd`, and this report. Checkpoint: `0c171b9`.
- Medium is the new-game default. The selector locks when Start is pressed; Restart offers a fresh Medium default.
- Research snapshots fullness and the Day 3 low-Mood exception at session start. Reward = difficulty base × tap modifier (0.5 while running) × fullness efficiency × exhaustion modifier (0.8 when applicable). Fractions are retained; only display text rounds.
- Base sessions stay 120 minutes. The existing running-tap duration remains 160 minutes. Four sessions per day remain the maximum.
- Four unique routine repairs grant 5/4/3 points and cost 45/60/60 minutes on Easy/Medium/Hard. Repair flags prevent repeat rewards. Cleanup and autonomous maintenance grant no repair bonus.
- Existing proactive bonus: +10 once for the FIRST successful routine repair before the FIRST research session. It is not a bonus for every repair or for repairing all four. Restart resets eligibility.
- All ending decisions use internal progress against the centralized 75% threshold. Good also requires all four repairs; bittersweet meets progress with unresolved routines; bad is below 75%.
- Each authoritative elapsed time step is assigned once to research, eating, leisure, repairs, manual cleanup or miscellaneous. Walking to activities is miscellaneous. Pending fractional time is committed before timed categories change. Previous-day totals are retained in daily_time_history.
- Early voluntary rest preserves the existing clock jump to 20:00 without simulating the unused evening. That explicitly nonplayable transition gap is excluded from tracked playable time; it is not fabricated as free time. The schedules below use the entire day, so each daily total is exactly 540 minutes.
- The right sidebar contains research and a 75% marker, repair checklist with checkmarks/strikethrough, actual daily time distribution, then needs and remaining sessions. A fitted 432×288 UI reference reserves the right column; room geometry and project viewport settings are unchanged.

## Schedule assumptions

These schedules repair the sink first and all routines before any research, so research never incurs the existing tap penalties. Repair menus pause play, and walking is allocated explicit miscellaneous time. Each one-minute walking allowance equals six real seconds at the existing normal clock rate; the room is compact and Judy moves at 80 units/second. Optional dialogue pauses time. Manual bed cleanup is budgeted on Day 1; repaired TipTop handles subsequent bed maintenance during the seated activity windows. Unexpected navigation failures or optional delays are not claimed to have been tested. If TipTop already cleaned the bed, its five-minute manual-cleanup reserve can be miscellaneous instead.

No schedule uses the low-Mood Day 3 exception. Research starts at Mood >=45 in every listed session. For comparison, using the exception would multiply that session reward by 0.8. Meals and leisure receive passive depletion during their full durations before restoration. Overnight uses bedtime Mood for the 10/15 fullness loss and pre-sleep fullness for next-day Mood.

## Easy

Base research +15; repair +5 / 45 min; work Mood loss 15; passive depletion ×0.70.

### Day 1

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk / free time | — | 84.92 | 89.98 |
| 11:01–11:06 | Make bed manually | — | 84.51 | 89.86 |
| 11:06–11:51 | Repair sink | +15.00% | 80.84 | 88.81 |
| 11:51–12:36 | Repair plant | +5.00% | 77.16 | 87.76 |
| 12:36–13:21 | Repair bookshelf | +5.00% | 73.49 | 86.71 |
| 13:21–14:06 | Repair bed | +5.00% | 69.81 | 85.66 |
| 14:06–15:06 | Free time | — | 64.91 | 84.26 |
| 15:06–15:07 | Walk to fridge / table | — | 64.83 | 84.24 |
| 15:07–15:37 | Eat | — | 100.00 | 83.54 |
| 15:37–15:38 | Walk to desk | — | 99.92 | 83.51 |
| 15:38–17:38 | Research (starts H 99.92, M 83.51) | +15.00% | 90.12 | 65.71 |
| 17:38–17:39 | Desk approach | — | 90.04 | 65.69 |
| 17:39–19:39 | Research (starts H 90.04, M 65.69) | +15.00% | 80.24 | 47.89 |
| 19:39–19:40 | Walk to table | — | 80.16 | 47.87 |
| 19:40–20:00 | Rubik's cube | — | 78.52 | 72.40 |

Day total: 540 min. research: 240, eating: 30, leisure: 20, repairs: 180, cleanup: 5, misc: 65.
Cumulative research: **60.00%**. Bedtime fullness 78.52, Mood 72.40.

Overnight: −10 fullness; next morning fullness **68.52**, Mood **90**.

### Day 2

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 68.44 | 89.98 |
| 11:01–11:31 | Eat | — | 100.00 | 89.28 |
| 11:31–11:32 | Walk | — | 99.92 | 89.25 |
| 11:32–13:32 | Research (starts H 99.92, M 89.25) | +15.00% | 90.12 | 71.45 |
| 13:32–13:33 | Walk | — | 90.04 | 71.43 |
| 13:33–14:03 | Eat | — | 100.00 | 70.73 |
| 14:03–14:04 | Walk | — | 99.92 | 70.71 |
| 14:04–16:04 | Research (starts H 99.92, M 70.71) | +15.00% | 90.12 | 52.91 |
| 16:04–16:05 | Walk | — | 90.04 | 52.88 |
| 16:05–16:35 | Phone games | — | 87.59 | 82.18 |
| 16:35–16:36 | Walk | — | 87.51 | 82.16 |
| 16:36–18:36 | Research (starts H 87.51, M 82.16) | +15.00% | 77.71 | 64.36 |
| 18:36–18:37 | Walk | — | 77.62 | 64.34 |
| 18:37–19:07 | Phone games | — | 75.17 | 93.64 |
| 19:07–20:00 | Free time / bed approach | — | 70.85 | 92.40 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **100.00%**. Bedtime fullness 70.85, Mood 92.40.

Overnight: −10 fullness; next morning fullness **60.85**, Mood **90**.

### Day 3

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 60.76 | 89.98 |
| 11:01–11:31 | Eat | — | 98.31 | 89.28 |
| 11:31–11:32 | Walk | — | 98.23 | 89.25 |
| 11:32–13:32 | Research (starts H 98.23, M 89.25) | +15.00% | 88.43 | 71.45 |
| 13:32–13:33 | Walk | — | 88.35 | 71.43 |
| 13:33–14:03 | Phone games | — | 85.90 | 100.00 |
| 14:03–14:04 | Walk | — | 85.82 | 99.98 |
| 14:04–14:34 | Eat | — | 100.00 | 99.28 |
| 14:34–14:35 | Walk | — | 99.92 | 99.25 |
| 14:35–16:35 | Research (starts H 99.92, M 99.25) | +15.00% | 90.12 | 81.45 |
| 16:35–16:36 | Walk | — | 90.04 | 81.43 |
| 16:36–17:06 | Phone games | — | 87.59 | 100.00 |
| 17:06–17:07 | Walk | — | 87.51 | 99.98 |
| 17:07–19:07 | Research (starts H 87.51, M 99.98) | +15.00% | 77.71 | 82.18 |
| 19:07–20:00 | Free time / bed approach | — | 73.38 | 80.94 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **100.00%**. Bedtime fullness 73.38, Mood 80.94.

## Medium

Base research +10; repair +4 / 60 min; work Mood loss 20; passive depletion ×1.00.

### Day 1

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk / free time | — | 84.88 | 89.97 |
| 11:01–11:06 | Make bed manually | — | 84.30 | 89.80 |
| 11:06–12:06 | Repair sink | +14.00% | 77.30 | 87.80 |
| 12:06–13:06 | Repair plant | +4.00% | 70.30 | 85.80 |
| 13:06–14:06 | Repair bookshelf | +4.00% | 63.30 | 83.80 |
| 14:06–15:06 | Repair bed | +4.00% | 56.30 | 81.80 |
| 15:06–15:07 | Walk to fridge / table | — | 56.18 | 81.77 |
| 15:07–15:37 | Eat | — | 92.68 | 80.77 |
| 15:37–15:38 | Walk to desk | — | 92.57 | 80.73 |
| 15:38–17:38 | Research (starts H 92.57, M 80.73) | +10.00% | 78.57 | 56.73 |
| 17:38–17:39 | Desk approach | — | 78.45 | 56.70 |
| 17:39–19:39 | Research (starts H 78.45, M 56.70) | +10.00% | 64.45 | 32.70 |
| 19:39–19:40 | Walk to table | — | 64.33 | 32.67 |
| 19:40–20:00 | Rubik's cube | — | 62.00 | 57.00 |

Day total: 540 min. research: 240, eating: 30, leisure: 20, repairs: 240, cleanup: 5, misc: 5.
Cumulative research: **46.00%**. Bedtime fullness 62.00, Mood 57.00.

Overnight: −10 fullness; next morning fullness **52.00**, Mood **80**.

### Day 2

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 51.88 | 79.97 |
| 11:01–11:31 | Eat | — | 88.38 | 78.97 |
| 11:31–11:32 | Walk | — | 88.27 | 78.93 |
| 11:32–13:32 | Research (starts H 88.27, M 78.93) | +10.00% | 74.27 | 54.93 |
| 13:32–13:33 | Walk | — | 74.15 | 54.90 |
| 13:33–14:03 | Eat | — | 100.00 | 53.90 |
| 14:03–14:04 | Walk | — | 99.88 | 53.87 |
| 14:04–16:04 | Research (starts H 99.88, M 53.87) | +10.00% | 85.88 | 29.87 |
| 16:04–16:05 | Walk | — | 85.77 | 29.83 |
| 16:05–16:35 | Phone games | — | 82.27 | 58.83 |
| 16:35–16:36 | Walk | — | 82.15 | 58.80 |
| 16:36–18:36 | Research (starts H 82.15, M 58.80) | +10.00% | 68.15 | 34.80 |
| 18:36–18:37 | Walk | — | 68.03 | 34.77 |
| 18:37–19:07 | Phone games | — | 64.53 | 63.77 |
| 19:07–20:00 | Free time / bed approach | — | 58.35 | 62.00 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **76.00%**. Bedtime fullness 58.35, Mood 62.00.

Overnight: −10 fullness; next morning fullness **48.35**, Mood **80**.

### Day 3

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 48.23 | 79.97 |
| 11:01–11:31 | Eat | — | 84.73 | 78.97 |
| 11:31–11:32 | Walk | — | 84.62 | 78.93 |
| 11:32–13:32 | Research (starts H 84.62, M 78.93) | +10.00% | 70.62 | 54.93 |
| 13:32–13:33 | Walk | — | 70.50 | 54.90 |
| 13:33–14:03 | Phone games | — | 67.00 | 83.90 |
| 14:03–14:04 | Walk | — | 66.88 | 83.87 |
| 14:04–14:34 | Eat | — | 100.00 | 82.87 |
| 14:34–14:35 | Walk | — | 99.88 | 82.83 |
| 14:35–16:35 | Research (starts H 99.88, M 82.83) | +10.00% | 85.88 | 58.83 |
| 16:35–16:36 | Walk | — | 85.77 | 58.80 |
| 16:36–17:06 | Phone games | — | 82.27 | 87.80 |
| 17:06–17:07 | Walk | — | 82.15 | 87.77 |
| 17:07–19:07 | Research (starts H 82.15, M 87.77) | +10.00% | 68.15 | 63.77 |
| 19:07–20:00 | Free time / bed approach | — | 61.97 | 62.00 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **100.00%**. Bedtime fullness 61.97, Mood 62.00.

## Hard

Base research +8; repair +3 / 60 min; work Mood loss 25; passive depletion ×1.20.

### Day 1

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk / free time | — | 84.86 | 89.96 |
| 11:01–11:06 | Make bed manually | — | 84.16 | 89.76 |
| 11:06–12:06 | Repair sink | +13.00% | 75.76 | 87.36 |
| 12:06–13:06 | Repair plant | +3.00% | 67.36 | 84.96 |
| 13:06–14:06 | Repair bookshelf | +3.00% | 58.96 | 82.56 |
| 14:06–15:06 | Repair bed | +3.00% | 50.56 | 80.16 |
| 15:06–15:07 | Walk to fridge / table | — | 50.42 | 80.12 |
| 15:07–15:37 | Eat | — | 86.22 | 78.92 |
| 15:37–15:38 | Walk to desk | — | 86.08 | 78.88 |
| 15:38–17:38 | Research (starts H 86.08, M 78.88) | +8.00% | 69.28 | 49.08 |
| 17:38–17:39 | Desk approach | — | 69.14 | 49.04 |
| 17:39–19:39 | Research (starts H 69.14, M 49.04) | +8.00% | 52.34 | 19.24 |
| 19:39–19:40 | Walk to table | — | 52.20 | 19.20 |
| 19:40–20:00 | Rubik's cube | — | 49.40 | 43.40 |

Day total: 540 min. research: 240, eating: 30, leisure: 20, repairs: 240, cleanup: 5, misc: 5.
Cumulative research: **38.00%**. Bedtime fullness 49.40, Mood 43.40.

Overnight: −15 fullness; next morning fullness **34.40**, Mood **80**.

### Day 2

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 34.26 | 79.96 |
| 11:01–11:31 | Eat | — | 70.06 | 78.76 |
| 11:31–11:32 | Walk | — | 69.92 | 78.72 |
| 11:32–13:32 | Research (starts H 69.92, M 78.72) | +8.00% | 53.12 | 48.92 |
| 13:32–13:33 | Walk | — | 52.98 | 48.88 |
| 13:33–14:03 | Eat | — | 88.78 | 47.68 |
| 14:03–14:04 | Walk | — | 88.64 | 47.64 |
| 14:04–16:04 | Research (starts H 88.64, M 47.64) | +8.00% | 71.84 | 17.84 |
| 16:04–16:05 | Walk | — | 71.70 | 17.80 |
| 16:05–16:35 | Phone games | — | 67.50 | 46.60 |
| 16:35–16:36 | Walk | — | 67.36 | 46.56 |
| 16:36–18:36 | Research (starts H 67.36, M 46.56) | +8.00% | 50.56 | 16.76 |
| 18:36–18:37 | Walk | — | 50.42 | 16.72 |
| 18:37–19:07 | Phone games | — | 46.22 | 45.52 |
| 19:07–20:00 | Free time / bed approach | — | 38.80 | 43.40 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **62.00%**. Bedtime fullness 38.80, Mood 43.40.

Overnight: −15 fullness; next morning fullness **23.80**, Mood **65**.

### Day 3

| Time | Activity | Research gained | End fullness | End Mood |
|---|---|---:|---:|---:|
| 11:00–11:01 | Walk | — | 23.66 | 64.96 |
| 11:01–11:31 | Eat | — | 59.46 | 63.76 |
| 11:31–11:32 | Walk | — | 59.32 | 63.72 |
| 11:32–13:32 | Research (starts H 59.32, M 63.72) | +7.20% | 42.52 | 33.92 |
| 13:32–13:33 | Walk | — | 42.38 | 33.88 |
| 13:33–14:03 | Phone games | — | 38.18 | 62.68 |
| 14:03–14:04 | Walk | — | 38.04 | 62.64 |
| 14:04–14:34 | Eat | — | 73.84 | 61.44 |
| 14:34–14:35 | Walk | — | 73.70 | 61.40 |
| 14:35–16:35 | Research (starts H 73.70, M 61.40) | +8.00% | 56.90 | 31.60 |
| 16:35–16:36 | Walk | — | 56.76 | 31.56 |
| 16:36–17:06 | Phone games | — | 52.56 | 60.36 |
| 17:06–17:07 | Walk | — | 52.42 | 60.32 |
| 17:07–19:07 | Research (starts H 52.42, M 60.32) | +7.20% | 35.62 | 30.52 |
| 19:07–20:00 | Free time / bed approach | — | 28.20 | 28.40 |

Day total: 540 min. research: 360, eating: 60, leisure: 60, repairs: 0, cleanup: 0, misc: 60.
Cumulative research: **84.40%**. Bedtime fullness 28.20, Mood 28.40.

## Feasibility results

- Easy: 8 sessions, four repairs, final **100.00%**, all routines fixed; good ending is mathematically reachable.
- Medium: 8 sessions, four repairs, final **100.00%**, all routines fixed; good ending is mathematically reachable.
- Hard: 8 sessions, four repairs, final **84.40%**, all routines fixed; good ending is mathematically reachable.

No requested profile values or ending requirements needed a balancing exception. Hard has the least spare time on Day 1, but a comfortable research margin above 75%.

## Manual checks

- New game defaults to Medium; all three descriptions and values change correctly before Start; selection cannot change afterward; Restart resets selector.
- Compare full and partially played research/activity Watch, 6× and instant Skip: time, needs, chores, mosquitoes, rewards and tracker categories should agree.
- Repair each routine once: correct 45/60 minutes, profile bonus, one proactive bonus only, immediate checkmark/strike and no bonus on cleanup or autonomous maintenance.
- Attempt a repair without enough time: no cost or reward. Check progress near 74.95 and 75.0 against actual internal values, including all three ending outcomes.
- Inspect sidebar and full apartment at 16:9, 3:2 and 4:3, dialogue, contextual prompts, stacked bars and transitions. HUD should remain outside lighting.
- At 14:00 with continuous playable time, internal category totals should sum to 180 minutes (including pending fractional time); verify daily reset/history, early rest exclusion, and overnight needs.
- Confirm coffee-table eating/leisure, automatic sitting, mosquito pursuit, bookshelf navigation, autonomous repaired chores, greetings and goodnight remain usable.
