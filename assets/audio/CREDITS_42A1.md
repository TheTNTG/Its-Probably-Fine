# Step 42A.1 expressive SFX

The original recordings and approved music retain their original credits. No existing source audio or music was overwritten or deleted.

## New real recordings

Publisher pages checked on 2026-10-25. Each recording is CC0 1.0: commercial redistribution and adaptation are permitted, with no mandatory attribution. Credits are retained voluntarily. See `SOURCES_42A1.json` for download URLs, sizes and SHA-256 hashes. Freesound files are actual HQ MP3 previews, not claimed to be the original WAV downloads.

| Added file | Creator | Publisher/source | Usage |
| --- | --- | --- | --- |
| `foley/keyboard_mechanical.mp3` | D.S.G. | [Mechanical Keyboard](https://freesound.org/people/D.S.G./sounds/423648/) | Continuous recorded mechanical typing during research |
| `foley/book_handling.mp3` | khenshom | [Book - Handling and flipping through pages](https://freesound.org/people/khenshom/sounds/481077/) | Varied real hardcover/page-handling excerpts while organizing and for manual cleanup |
| `foley/reel_giggle.mp3` | Reitanna | [cute giggle](https://freesound.org/people/Reitanna/sounds/252218/) | Short phone-video laughter clip, not Judy's voice |
| `foley/reel_dog.mp3` | kwahmah_02 | [Single Dog Bark](https://freesound.org/people/kwahmah_02/sounds/277058/) | Short pet-video clip on Judy's phone |
| `foley/metal_clank.ogg` | Kenney | [Impact Sounds](https://kenney.nl/assets/impact-sounds), `impactMetal_light_000.ogg` | Metal contact layered with the existing recorded ratchet during repair feedback |

License: [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). Existing `KENNEY_LICENSE.txt` also covers the added Kenney impact.

## Original synthesized effects

Nine original PCM WAV files, authored locally using `tools/build_42a1_sfx.py`, NumPy already available in the workspace runtime, and Python's standard `wave` writer. No third-party samples or music were used in these files. Dedicated to CC0 1.0, to the extent copyright applies. No attribution requirement or runtime Python dependency.

| Added WAV under `expressive/` | Identity |
| --- | --- |
| `laser_0.wav`, `laser_1.wav` | Falling, harmonically rich PEW shots for phone gaming |
| `arcade_explosion.wav` | Noisy bass/crackle arcade explosion |
| `mosquito_zap.wav` | Exaggerated electrical ZZZAP on successful mosquito elimination |
| `malfunction.wav` | Short electrical/mechanical sputter on a new faulty tap start |
| `phone_swipe.wav` | Filtered-noise swish between reels |
| `reel_boing.wav` | Short cartoon spring/boing clip |
| `ui_hover.wav` | Dry hover/focus tick |
| `ui_click.wav` | Percussive click/thock for selection, interaction and completion |

`expressive/SOURCES.json` records generation methods and exact output hashes. The generator is offline authoring source; it is not invoked by Godot. Edge fades and -3 dBFS source peak headroom are applied during authoring.

## Existing recordings now mixed more prominently

Rubik's cube, eating, cutlery, ratchet, water, watering, book falls, cleaning, bedding, fridge movement, footsteps and paper/dialogue sounds reuse the credited recordings in `CREDITS.md`. Real book handling replaces the old paper proxy; electrical zap replaces the old soft-impact swat proxy; distinct arcade/video sounds replace the old generic phone click. Old proxy files remain available in the project.

No dedicated screw-turn or toolkit-rattle recording was added: repairs use the real ratchet plus metal impact. Reels use a small set of licensed sound snippets and an original cartoon effect, not copyrighted commercial videos or music. No voiced dialogue or new music was added.
