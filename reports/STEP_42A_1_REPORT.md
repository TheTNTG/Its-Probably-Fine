# Step 42A.1 — expressive sound revision

## Checkpoint and verification status

- Pre-edit Git checkpoint: `78c8128` — typography, persistence and approved music, including the music-load fix.
- Implemented directly in the project; source/static review only. Godot was not launched, gameplay was not simulated, no automated tests were run, and no screenshots were taken. Loudness, perceived quality and runtime behavior still require manual playtesting.
- No gameplay, difficulty, timing, save/profile data, tutorial, furniture, navigation or UI-layout changes. Game-state/player changes only add audio calls.

## Changed project files

- `scripts/apartment_audio.gd`: new assets, separate sound identities, activity loops and real-time event cadence, chore repetition, hover/focus feedback, gain hierarchy, motor routing, stop/suppression handling, source loading and event priority.
- `scripts/audio_layer.gd`: configurable short activity fade-in and safe handling of missing streams; reusable overlapping players retained.
- `default_bus_layout.tres`: SFX-only hard limiter and separate low-pass-filtered RobotMovement sub-bus. Existing Master/SFX/Ambience/Music slider values and sends are preserved. Music is not routed through the SFX limiter.
- `scripts/player.gd`: a quiet click on a valid E interaction, after target selection/input consumption.
- `scripts/game_state.gd`: completion feedback after research and personal activity completion; no state calculations changed.
- `tools/build_42a1_sfx.py`: offline authoring source for nine original effects, using the already available NumPy runtime. No game dependency or installation.
- `assets/audio/CREDITS.md`, new `CREDITS_42A1.md`, `SOURCES_42A1.json`, `expressive/SOURCES.json`: sources, licenses, uses and hashes.
- Fourteen new audio files listed below; existing recordings remain intact.

## Audio assets actually integrated

Five real CC0 recordings:

- `assets/audio/foley/keyboard_mechanical.mp3` — D.S.G., real mechanical keyboard.
- `assets/audio/foley/book_handling.mp3` — khenshom, real book handling/page movement.
- `assets/audio/foley/reel_giggle.mp3` — Reitanna, real short giggle.
- `assets/audio/foley/reel_dog.mp3` — kwahmah_02, real single dog bark.
- `assets/audio/foley/metal_clank.ogg` — Kenney, metal impact.

Nine original synthesized effects under `assets/audio/expressive/`:

- `laser_0.wav`, `laser_1.wav`, `arcade_explosion.wav`.
- `mosquito_zap.wav`, `malfunction.wav`.
- `phone_swipe.wav`, `reel_boing.wav`.
- `ui_hover.wav`, `ui_click.wav`.

Source links, creators and license terms are in [the audio credits](assets/audio/CREDITS_42A1.md). Downloaded recordings remain byte-for-byte unchanged. Source waveform inspection selected active book, tool and eating excerpts to avoid arbitrary silent portions. No source asset was replaced with a generic tone.

## Event connections and playback

| Event/activity | Sound behavior |
| --- | --- |
| Research active | Prominent continuous recorded mechanical typing, short crossfade, occasional research-paper movement |
| Cubing active | Continuous real plastic cube-turning recording |
| Eating active | Continuous recorded eating, recurring plate/cutlery every 2–3.2 real seconds |
| Phone games active | Two distinct PEW shots every 0.24–0.48 real seconds, explosion every seventh event |
| Reels active | Swipe, then changing giggle/dog/cartoon clips; no identical adjacent clip type |
| Repair completion | Recorded ratchet excerpt plus metal clank, up to 3 seconds of physical feedback |
| TipTop working | Repeat appropriate book/cutlery/watering/bedding/cleaning excerpts while the actual task is working; stop on task exit |
| Manual cleanup | Existing cleanup hooks now use louder recordings; bookshelf uses real book handling |
| Book disaster | Existing mess-increase hook now plays prominent recorded falling books |
| Faulty tap starts | Distinct electrical sputter once per tap-off → tap-on change, plus running water |
| Mosquito eliminated | Existing Judy and TipTop success hooks now play the electric zap |
| Button hovered/focused | Moderate dry tick, rate-limited, disabled/hidden buttons ignored |
| Button pressed / valid E target | Prominent percussive click |
| Research/personal activity completed | Short completion thock, no generic reward melody |
| Dialogue/menu advancement | Existing paper feedback, made more audible |
| Walking | Immediate first actual footstep retained, louder than before, spatial cadence unchanged |

Long activities use real-time audio cadence at both Watch and 6x: pitch and sound density do not accelerate sixfold. Looping sources use reusable players. One-shots have bounded lifetimes; activity and robot categories allow at most two overlapping voices each. Important zaps/faults/book drops can preempt lower-priority one-shots instead of disappearing when all six world voices are occupied.

Skip suppresses accumulated one-shots, stops loops, and synchronizes sound snapshots to the final state; it does not replay a backlog. Eject immediately stops all activity-owned sources. Pause/loading/transition gates stop activity voices, and scene changes free the world audio subtree. Instant repair feedback is tagged and cut on loading, a real Pause menu, transition or scene unload; comic dialogue can still accompany the repair result.

## Quiet robot, recognizable actions

Motor gain is now `MOTOR_DB = -38` versus the previous -24, with an 850 Hz low-pass on RobotMovement. It remains positional and only plays during actual motion. Task/action sources use the ordinary SFX bus and separate gains. This makes motor travel at least 14 dB lower before the additional filter, without suppressing chores.

Keyboard is -4 dB, cube -6, eating -9, key impacts/zaps/faults -4 to -9, UI hover -18 and footsteps -15 before existing bus gains and spatial attenuation. These are mix values, not claims of measured perceived loudness. A SFX-only hard limiter at -3 dB reduces overlapping peaks; the quiet ambient and approved music paths stay independent. Final listening/mix approval remains manual.

## Approved background music

- The approved OGG, composition, tempo, pitch, loop points, Music bus and volume preferences are untouched.
- `play_music()` and `_update_music()` are unchanged. The existing global autoload owns the same single player; the player now explicitly uses `PROCESS_MODE_ALWAYS`, including the paused title screen.
- Menus, New Game, Continue and scene changes reuse that player. Watch/6x/Skip do not seek or restart music. Existing transition fades are preserved.
- Approved file SHA-256 remains `ccaa02bb60310146f1fa3b1c70be0a5a57f0674b9c4944a22b85b0c03e932cdb`.

## Missing assets and scope limits

- No required activity is left mapped to the old generic phone click or paper-book proxy.
- No new dedicated screw-turn or full toolkit-rattle recording; the actual ratchet plus metal clank is the repair identity. Current repairs resolve immediately in code, so there is no long watched repair activity to loop; a bounded physical completion sequence is supplied without changing repair timing.
- Reels have three short content identities, not a library of voiced videos. More licensed clips could reduce repetition later.
- No recorded voice acting, bespoke household-robot motor recording or extra BGM was claimed. The existing motor recording is quieted/filtered.
- Export behavior, listening quality, exact loudness and loop seams have not been verified in-engine.

## Manual checklist, ordered by risk

1. Start on the main menu: approved music plays; hover/focus/click feedback is distinct. Change Master/SFX/Ambience/Music sliders and confirm their separation and persisted values. The motor sub-bus follows SFX.
2. Start/Continue gameplay and return to Main Menu: one music stream, no restart/duplicate or lingering world sources. Confirm no missing-audio/import errors.
3. Watch research, then switch to 6x: continuous crunchy typing; normal audio pitch and bounded density. Skip/Eject/Pause mid-session: no backlog or orphan typing. Resume should restore appropriate activity audio.
4. Cube, eat, play games and watch reels for their full durations: each is recognizable without looking; no long unexplained silences. Check Skip, Eject and Pause for each.
5. Listen to TipTop crossing the room: movement stays in the background. During chores, book/cutlery/water/fabric action sounds remain noticeable, then stop when he leaves.
6. Kill mosquitoes with Judy and TipTop: strong zap only on successful elimination, no rapid stack at 6x/Skip. Trigger book falls and a newly running faulty tap: recognizable disaster cues and water loop.
7. Repair and clean: physical tools/metal/book handling, original rewards/costs preserved. Pause or leave during feedback and ensure it stops safely.
8. Check dialogue, tutorial, sleep, day reveal and endings: no stale activity loops, approved music still follows its existing fades, no gameplay/UI regressions.
