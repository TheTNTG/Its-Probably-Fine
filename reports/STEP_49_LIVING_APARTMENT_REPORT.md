# Step 49 — living apartment and helpful routines

## Prerequisite and checkpoint

Step 48.1 finished in this chat before Step 49 began. The app's thread listing showed no other active coding chat for this project. Committed the completed text-system changes as **`b5517a3`**, the checkpoint before this implementation. Existing unrelated temporary files were left alone.

Implementation and static inspection only. **No Godot launch, gameplay simulation, automated tests, screenshots or runtime audio audition were performed.** Manual playtesting is required; the checks below are not passed test results.

## Files changed

- `scripts/game_state.gd`: normal-mess flags, completion hooks, cleanup eligibility, repair-gated automatic hunting and cleanup/hunt autosave requests.
- `scripts/tiptop.gd`: dishwashing status and concise contextual cleanup thoughts through GameText.
- `scripts/apartment_visual.gd`: plates/cutlery, minor reference clutter and healthy washing animation using existing pixel-style drawing.
- `scripts/apartment_audio.gd`: dishwashing water/cutlery/cleaning feedback, intermittent mosquito buzzing and completion sound ownership.
- `scripts/save_store.gd`: optional persisted booleans and safe legacy-hunt restoration.
- `scripts/player.gd`, `scripts/hud.gd`: contextual manual-cleanup wording and two status lines in the existing checklist.
- `data/text/activities.json`, `hud.json`, `interactions.json`, `tiptop.json`: 11 centralized strings.
- `docs/COMPLETE_TEXT_REFERENCE.md`, `docs/HOW_TO_EDIT_GAME_TEXT.md`, `docs/REMAINING_HARDCODED_TEXT.md`: current catalog and editing information.
- This report.

No scene hierarchy, collision, navigation geometry, apartment layout, theme/font, main menu, rules screen, deadline, difficulty setting, research calculation, need reward, ending predicate, music file or bus mix was changed.

## World state and completion events

| State | Meaning | Created | Cleared |
|---|---|---|---|
| `sink_dirty_dishes: bool` | Ordinary used dishes, separate from `tap_running`, overflow and `chore_mess.sink` | Once when `advance_personal_activity()` successfully completes `eat`, alongside unchanged meal rewards | Actual sink cleanup, manual or repaired robot routine |
| `bookshelf_minor_clutter: bool` | Consulted references, independent of severe `chore_mess.bookshelf` | Once in guarded `complete_research()` | Actual bookshelf cleanup, manual or repaired robot routine |
| Existing `chore_mess.bed` | Untidy bedding | Existing `continue_day()` already sets it to 1 once on a new playable morning | Existing manual/repaired bed-making routine |

No completion-only mess is added by Eject. Watch, 6x and successful Skip reach the same completion hooks, so each completed activity produces one normal mess state rather than repeated per-frame events. Boolean dirty flags coalesce repeated activities into one pending cleanup; they do not create duplicate jobs or grow a second severity counter.

Normal dishes do not restrict eating or create water exposure. Minor reference clutter is not consulted by `research_available()`; the existing severe bookshelf threshold of 2 still blocks work. Faulty chore repetitions and severe scattering remain unchanged. A severe mess and normal clutter can coexist and are cleared by a real cleanup, not by silently repairing a routine.

## Existing task system reused

`needs_cleanup()` now recognizes normal dishes and reference clutter. The existing scheduler prioritizes eligible repaired cleanup, uses its current fixture approach points and task serial, and retains its cooldowns, arrival checks, short working action, cancellation/recovery and task completion path. No new navigation framework or parallel task queue was added.

- **Repaired sink:** walk to the sink, show Washing dishes, animate a small rinse/plate motion, play the existing water layer with cutlery/cleaning foley, then clear dishes and any existing sink mess. Healthy rinse presentation never sets `tap_running`, adds water exposure, grows a puddle or applies the research tap penalty.
- **Unrepaired sink:** dishes remain. Judy can use the existing 15-minute sink-cleanup action, with updated wording; a running faulty tap must still be turned off before cleaning. Eating remains available under its existing rules.
- **Repaired bookshelf:** walk to its existing front-edge approach point, organize with existing book animation, shuffled book recordings and stacking contact, then clear minor/severe clutter. A completion sound uses the robot's completed visit rather than the scheduler's potentially advanced next-task name at 6x.
- **Unrepaired bookshelf:** normal clutter remains without blocking research. Judy may tidy it through the existing 20-minute cleanup. Faulty organizing can still produce the original severe, blocking mess later.
- **Bed:** retained the authoritative next-day untidy flag and existing physical making action/fabric sound. Loading a save does not reapply a wake-up mess or sleep rewards. No sleep duration/animation/reward was changed.

Successful robot cleanups request the existing debounced safe autosave only when a mess was actually present. Maintenance visits do not request cleanup saves every frame. Repairs expose the new cleanup eligibility through their existing live flags; they do not instantly erase normal clutter. TipTop finishes/retries through existing task boundaries rather than teleporting or being preempted by an automatic cleanup.

## Mosquito eligibility, priorities and limits

`can_hunt_mosquitoes()` returns **`repairs.sink OR repairs.plant`**. Autonomous hunts require that predicate, live insects, a ready hunt cooldown and a boundary at which no repaired cleanup is pending. Existing `last_robot_swat` alternation requires an ordinary chore between autonomous batches. Existing batches remain capped at three targets, 30 logical action seconds, with cooldown/recovery; the population remains bounded by the existing maximum of six insects.

Existing physical pursuit/proximity checks still own each removal and zap. No remote kills, teleporting, duplicate target queues or new spawn penalties were introduced. Already-removed targets use the existing cancellation path.

**Explicit player requests remain supported even before repair.** “Ask TipTop to swat mosquitoes” is a manual override, not an autonomous hunt; removing it would regress an existing interaction. With neither routine repaired and no player request, TipTop does not select automatic hunts.

## Actual mosquito audio

- Reused file: `res://assets/audio/sfx/mosquito/mosquito.wav`.
- Recording: **Mosquito 1 Edit.wav**, **IanFSA**.
- Recorded source: <https://freesound.org/people/IanFSA/sounds/662970/>.
- License recorded with the existing asset: **CC0 1.0**; redistribution permitted, attribution optional and existing voluntary credits retained.
- Existing prepared format: mono PCM16 WAV, 44,100 Hz, 5 seconds. Read the actual PCM file; it contains nonzero audio, peak 26,027. SHA-256 matches existing provenance: `d6f74a15c3b3b1d0fc083c497db7c21dcd5f8ed51af49af33e44c15bfeaf55d7`.
- No new audio download, generated beep or replacement asset was necessary.

The existing single positional mosquito layer follows the nearest insect, with its normal soft falloff. It now buzzes for 2.2–4.2 seconds in a six-second real-time cycle, depending on population. More insects lengthen the visit instead of stacking additional loud voices or increasing volume indefinitely. The layer's target changes from -28 to -16 dB and is no longer inaudible beyond the old 45-unit gate. At zero mosquitoes it stops immediately and resets its presentation phase. Normal pause/loading/transition suppression and Skip backlog prevention remain in effect.

The layer is limited to its existing two crossfade voices; there is no per-insect audio-player creation. Existing electric zap clips, BGM, bus gains, quiet TipTop travel and unrelated SFX remain unchanged. Only the targeted mosquito presentation level/cadence and new chore feedback paths were adjusted. Perceived loudness still needs the user's playtest.

## Save/load compatibility

Kept campaign/profile architecture and schema version 1. `OPTIONAL_BOOLEANS` validates, writes and restores the two new flags; absent values in older compatible saves default to false. Existing bed state, repairs, severe messes and mosquito records remain in their established fields. Restart clears the new flags; ordinary day transitions retain unfinished dishes/references.

The existing restore path reconstructs robot tasks from logical flags rather than serializing new timers, nodes or navigation references. A legacy automatic hunt saved with neither qualifying repair is retired safely, keeping all insects and campaign progress. Explicit saved player requests remain valid. Normal cleanup/hunt completions request post-event autosaves through SaveStore's existing safety/debounce mechanism. New task eligibility does not reaward repair/research bonuses or replay activity completion hooks.

The audio manager's existing snapshot/paused load handling prevents accumulating one-shot chore effects during restore. Environmental buzzing resumes for currently saved insects after normal play resumes; no zap backlog is played.

## Editable text

Added:

- `tiptop.dishes_working`, `tiptop.dishes_reaction`, `tiptop.references_working`, `tiptop.references_reaction`, `tiptop.washing_dishes`
- `hud.pending_dishes`, `hud.pending_references`
- `interactions.wash_dishes`, `interactions.tidy_references`
- `activities.clean_dishes`, `activities.tidy_references`

Duration labels use the existing cleanup cost as `{duration}`. Thoughts are short/nonblocking and only selected at actual chore phases. Existing checklist pin/hover/click behavior is untouched. The catalog now has **457 entries in 13 JSON files**; the reference generator found no missing static IDs. Dynamic thought-phase IDs are all present and documented.

## Manual playtest checklist

1. **Meals, faulty sink:** finish a meal in Watch, 6x and Skip; see plates/cutlery but no new water, flooding or research penalty merely from dishes. Confirm eating again is allowed. Eject an unfinished meal and confirm no new completion-only dishes are produced.
2. **Repaired sink:** finish a meal, then allow TipTop access. He must approach the sink, wash visibly with water/cutlery sounds, remove dishes and leave normally. Check healthy washing does not trigger tap penalties/overflow. Manually clean once for the existing 15 minutes.
3. **Research clutter:** complete research and see horizontal reference books. Minor clutter must allow the next research session if other rules permit. Eject must not add it. Repaired TipTop must reach the shelf front, organize, play handling/stacking sounds and clear it. Manual cleanup remains 20 minutes.
4. **Severe books:** let faulty organizing scatter books. Research must still block at the existing threshold, including when minor clutter also exists. Manual/repaired cleanup must clear it; a still-faulty routine can scatter books again later.
5. **Bed:** sleep into Day 2/3. Bed should be untidy after waking; repaired TipTop makes it and moves on. Confirm the original sleep animation, Mood/Fullness results and day/ending transition happen once.
6. **Hunt matrix:** with insects present and no manual request, compare neither routine repaired, sink only, plant only and both. Only the last three enable automatic hunting. Explicit swatter requests must still work. Watch physical arrival and zap/removal, then verify chores resume between automatic batches.
7. **Audio:** check intermittent buzz with one through six insects, nearby and across the room; confirm pauses and immediate stop after the last kill. Check pause, Skip, Eject, transitions and menu return for orphaned sounds. BGM and quiet travel should sound unchanged.
8. **Persistence:** save dirty dishes/minor references, return to menu and Continue. Verify flags, visuals, repairs, insects and reconstructed cleanup; no bonus or completion effect should replay. Load a pre-Step-49 compatible checkpoint and verify safe defaults. Restart must clear new clutter.
9. **UI/regressions:** pinned checklist pending labels disappear after cleanup; other tabs remain usable. Check tutorial practice cannot overwrite campaign saves, rules stay paused, and research/needs/session costs/three endings behave as before.

## Remaining limitations

All behavior above is implemented in project files but unverified at runtime. Existing route recovery/cooldowns and Judy's proximity pause can delay cleanup when she blocks TipTop; he is never teleported to overcome that. The current Watch/6x/Skip simulation and timed-action architecture were retained rather than redesigned; this pass places new messes at its existing guarded completion points. No new standalone book-sliding or dishwashing recording was sourced: appropriate existing book handling, cutlery, wipe and water assets provide those cues. Buzz loudness and new small visual details may need adjustment after manual playtesting.
