# Step 42A — Natural apartment audio

Git checkpoint before changes: `e962bc5`.

## Files changed

- `project.godot`: registers the single audio autoload and bus layout.
- `default_bus_layout.tres`: Master, SFX, Ambience and Music buses.
- `scripts/apartment_audio.gd`: positional foley, ambience, activity cadence, UI feedback, voice pooling and scene cleanup.
- `scripts/audio_layer.gd`: reusable two-voice crossfade layer for recorded loops.
- `scripts/game_state.gd`: audio-only hooks for cancellation, instant completion, successful cleanup/repair and mosquito removal.
- `scripts/player.gd`: fridge access and bedding cues on existing actions.
- `scripts/hud.gd`: Skip suppression, pause/resume and dialogue-page cues.
- `scripts/title.gd`: four functional volume sliders and menu cues.
- `assets/audio/`: 24 recordings, `CREDITS.md`, `SOURCES.json` and the original Kenney license notice.
- This report. No apartment scene, art, collision or AI script was changed.

## Integrated recordings and licenses

24 files, approximately 9.2 MB, were obtained and their source licenses checked. There were no existing project audio files to reuse.

- Kenney, **Impact Sounds**: three wooden footsteps, light wood contact and a soft physical impact. Original OGG files.
- LEGIT Audio, **The Shop** free samples on OpenGameArt: refrigerator drone, converted from 24-bit 96 kHz stereo to 16-bit 32 kHz mono PCM.
- Freesound creators: recorded typing, paper, running tap, indoor room tone with distant traffic, servo motor, fridge opening/closing, plate/cutlery, eating soup, cube turns, clothes rustling, tool ratchet, wiping, book falling, plant watering, water drips, mosquito and mouse click.

Every integrated sound is **CC0 1.0**, with no mandatory attribution. Voluntary creator credits and links are retained in [assets/audio/CREDITS.md](assets/audio/CREDITS.md). [SOURCES.json](assets/audio/SOURCES.json) records each creator, exact source/download URL, adaptation, size, license URL and SHA-256 hash. Freesound files are the actual public HQ MP3 previews; no original WAVs are claimed. Only the explicitly CC0 free LEGIT Audio samples were used, not its paid library.

Primary pack sources: [Kenney](https://kenney.nl/assets/impact-sounds), [LEGIT Audio on OpenGameArt](https://opengameart.org/content/the-shop). The complete individual recording links are in the credits/manifest. License: [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Sound feedback

| Existing action/state | Audio |
| --- | --- |
| Judy visibly walking | Distance-paced wooden footsteps with restrained pitch/gain variation |
| Research | Recorded typing in varied bursts, pauses, occasional paper handling and light desk contact |
| Choosing a meal | Fridge opens, then closes after a short audio-only delay while Judy uses the existing coffee-table route |
| Eating | Sparse plate/cutlery and quieter eating excerpts |
| Phone leisure / cube | Very quiet touch-feedback proxy / recorded cube turns |
| Getting into bed | Short fabric rustle during the existing sleeping pose |
| TipTop moving | Low-level recorded servo layer, following actual movement |
| TipTop physically performing chores | Watering, dishes, books, bedding or wiping; once per task serial |
| New household mess | Physical book fall, wet drip/spill or bedding sound, tied to existing mess state changes |
| Tap running | Positional water layer at the sink; fades out when the existing tap state becomes false |
| Water stages | Sparse drip/spill excerpts on existing overflow thresholds |
| Repair / manual cleanup | Quiet hand-tool / matching cleanup foley; no reward jingle |
| Mosquitoes | One restrained nearby buzzing layer, plus a soft swat on actual removals |
| Buttons, menus and comic pages | Quiet click and brief paper-like handling; no per-letter dialogue bleeps |

World effects use `AudioStreamPlayer2D`, with a listener following Judy. General room tone and UI use nonpositional playback. The six room layers use fixed pairs of voices; one-shots reuse a six-voice world pool and three-voice UI pool. No nodes are created for individual footsteps, clicks or simulated events. There are no synthesized arcade tones, piercing alerts or completion melodies.

Loops overlap recorded excerpts with crossfades rather than hard restarts. World layers fade in and fade out when gameplay pauses, dialogue blocks simulation, the day ends or transitions begin. UI remains audible while menus are paused. Bedding and the already-completed repair's brief physical cue are intentional nonblocking tails, rather than ongoing activity loops.

## Watch, 6×, Skip and Eject

- Watch uses ordinary real-time audio cadence.
- 6× changes no audio pitch or loop speed. Sparse activity/robot sounds remain paced in real seconds, not multiplied by simulated event count.
- Skip enters an audio-only suppression scope around the existing simulation call. Sounds from intermediate events are discarded; no accumulated event queue plays afterward. Current environment state still determines the water/ambience layers on the next rendered frame.
- Eject immediately stops typing and activity-owned voices. Existing cancellation, elapsed time, rewards, sessions and pose cleanup are unchanged.
- Pause stops short world sounds and fades world loops; resume restores only audio for currently active states. Leaving/restarting the room frees its world players and listener. The autoload, settings and UI players are shared rather than duplicated.

Audio uses a separate random generator and presentation timers. It does not advance the authoritative clock, choose chores, change events, grant rewards or alter simulation results.

## Volume controls and music preparation

Main Menu → Settings now offers Master, SFX, Ambience and Music sliders. Zero mutes that bus; raising it unmutes it. Child buses route through Master. Changes apply immediately and persist through room/menu/restart scene changes for the current app session, matching the existing Settings policy. No save system was added.

The layout uses Godot's documented [audio/buses/default_bus_layout setting](https://docs.godotengine.org/en/4.6/classes/class_projectsettings.html#class-projectsettings-property-audio-buses-default-bus-layout); positional playback follows the documented [AudioStreamPlayer2D/AudioListener2D model](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer2d.html).

Music has a dedicated bus and an idle `AudioStreamPlayer` with a `play_music(stream)` entry point. No music asset is loaded or started in this phase; the signature BGM remains for Step 42D.

## Missing bespoke assets and limitations

- No dedicated electronic robot acknowledgment, custom robot hover recording, bespoke phone touchscreen recording, voice acting or signature BGM was added. Recorded servo movement, quiet mouse-click feedback and generic fabric/soft-impact foley provide the documented substitutes. The deliberate lack of dialogue beeps keeps TipTop unobtrusive.
- Outdoor presence comes from the verified room-tone recording's distant traffic, not an independent outdoor track.
- The recordings' source/license information and file formats were inspected, but the resulting mix and excerpt timing have **not been auditioned in Godot**. Initial gains, short excerpts, panning and crossfade points need listening playtests on headphones/speakers. They may need tuning against the recordings' original noise floors or onset silence.
- No Godot launches, automated tests, gameplay simulation or screenshots were performed.

## Manual playtest checklist

1. Open Settings: move/mute each volume slider independently; Master should affect all audio. Keep Music silent with no BGM. Return to the game/menu and confirm session volume choices remain.
2. Walk, stop, bump furniture and pause. Listen for soft footfalls only during actual visible motion, with no continued footsteps at rest.
3. Research in Watch, switch to 6×, then Skip/Eject on separate sessions. Typing should pause naturally, retain normal pitch at 6× and stop on cancellation/completion; Skip must not create a sound burst or alter existing results.
4. Eat and try every leisure activity in Watch/6×/Skip/Eject. Check fridge access, sparse eating/cutlery, phone/cube feedback, prompt dismissal and restored standing poses.
5. Let TipTop reach each fixture. Listen for quiet movement and one action cue on arrival, then appropriate physical mess sounds. Repair each routine and manually clean; inspect ordinary consequences and research restrictions as before.
6. Turn the tap off while it runs: flow should stop with a short fade. Let faulty chores restart it and reach overflow stages; there should be no repeated drip barrage. Check nearest mosquito buzz and Judy/TipTop swats without harsh or constant high-volume buzzing.
7. Check comic pages, keyboard/mouse menus, tutorial, Pause/Resume, sleep/day wipes and all endings. There should be no stale activity audio, duplicate room layers or audio-driven gameplay changes.
8. Listen for seams, background hiss, excessive peaks and excerpt onset gaps at default volumes. Report any sound that feels too artificial, loud or repetitive for a follow-up mix pass.
