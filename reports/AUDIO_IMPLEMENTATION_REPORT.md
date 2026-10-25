# Sound-effects integration

## Implemented

- Integrated 50 licensed PCM WAV clips. Actual source URLs, creators, licenses, file sizes and decode evidence are listed in [the asset manifest](assets/audio/AUDIO_ASSET_MANIFEST.md) and `assets/audio/SFX_VERIFICATION.json`.
- Connected continuous typing, cube turning and eating; recurring arcade-game and reels audio; book handling, repairs, cleanup, water, footsteps, mosquito zaps, dialogue and menu feedback.
- Separated quiet, filtered TipTop movement from his audible chore sounds. Cached streams and bounded voices limit overlap. One-shots finish on the audio thread rather than being prematurely stopped by render-frame timers.
- Activity sounds use real-time cadence during Watch and fast-forward. Skip discards accumulated feedback; Eject stops activity sounds. Pause, loading and scene changes clear owned activity audio.
- Existing instant repairs retain their gameplay timing and use a brief tool-sound sequence; no timed repair mechanic was added.

## Files

- `scripts/apartment_audio.gd`, `scripts/audio_layer.gd`: registry, playback, activity loops and lifecycle.
- `scripts/game_state.gd`, `scripts/player.gd`, `scripts/hud.gd`: actual cleanup, mosquito and menu event feedback.
- `default_bus_layout.tres`: separate filtered robot movement and SFX headroom.
- `assets/audio/sfx/`, `assets/audio/CREDITS.md`, `assets/audio/AUDIO_ASSET_MANIFEST.md`, `assets/audio/SFX_VERIFICATION.json`: playable files and provenance.
- `tools/prepare_audio_42a2.py`, `tools/write_audio_manifest_42a2.py`: asset preparation and documentation tools, not runtime dependencies.

Checkpoint before these edits: `f2cc10a`. Original music bytes remain unchanged; no further BGM work was undertaken after the request to finish only sound effects.

## Missing dedicated variants

Dedicated spacebar/Enter recordings, standalone book sliding and toolbox rummaging were not acquired. Real key clacks, book handling/contact and ratchet/screwdriver/clank recordings cover those actions without claiming to be those missing variants.

## Verification and manual checks

Audio sources and prepared outputs were decoded offline; registry paths and cue keys were inspected statically. No Godot launch, gameplay simulation, automated tests or screenshots were performed. In-engine audibility and mix remain unverified.

Manually check research, cube, games, reels and eating throughout their durations; TipTop chores versus quiet travel; water shutoff, cleanup and successful mosquito kills; menu hover/click and dialogue pages. Compare Watch and fast-forward audio, then Skip, Eject, pause/resume and return to menu for lingering loops or stacked sounds. Check SFX/Ambience sliders independently of approved music.
