# Audio asset manifest — Step 42A.2

**IMPLEMENTED WITH VERIFIED ASSET** means the file exists, its source and prepared output decoded successfully, and its gameplay call/loop is connected in source. It does not claim in-engine playback was heard or tested. No Godot launch, gameplay simulation, automated test or screenshot was performed.

All active SFX below are mono 16-bit PCM WAV at 44,100 Hz. Source formats, actual download URLs, excerpt positions, normalization, source/output hashes and decode evidence are in `SFX_VERIFICATION.json`. These files were decoded and converted, not merely renamed.

50 active PCM files, 8,877,912 bytes total. 20 use source members/recordings downloaded in this step; the other 30 use existing licensed recordings. Old originals are retained. Previous homemade expressive WAVs are not used by the active registry.

## Original approved BGM

- Event: global title/menu, New Game, Continue, gameplay and endings.
- File: `res://assets/audio/music/chilllofir-loop.ogg`.
- 2,360,833 bytes; Ogg Vorbis, stereo, 44.1 kHz; offline decode: 97.216 seconds / 4,287,228 frames; non-silent RMS approximately -17.05 dBFS.
- [Chill lofi inspired — loop edit](https://opengameart.org/content/chill-lofi-inspired-loop-edit), omfgdude; loop edit qubodup. CC0 1.0, attribution optional; voluntary credits retained in `music/CREDITS.md`.
- SHA-256: `ccaa02bb60310146f1fa3b1c70be0a5a57f0674b9c4944a22b85b0c03e932cdb`. Original bytes, composition, loop and pitch unchanged.
- Status: **IMPLEMENTED WITH VERIFIED ASSET**; startup/routing recovery implemented. Audible recovery remains unverified pending manual playtest.

## Active SFX

| Event | Local file | Bytes / seconds | Source | Creator | License / attribution | Asset status |
| --- | --- | --- | --- | --- | --- | --- |
| Research mechanical typing loop A | `res://assets/audio/sfx/research/typing.wav` | 211,364 / 2.396 | [Mechanical Keyboard](https://freesound.org/people/D.S.G./sounds/423648/) | D.S.G. | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Research real key accents | `res://assets/audio/sfx/research/key_clack.wav` | 14,156 / 0.160 | [Mechanical Keyboard](https://freesound.org/people/D.S.G./sounds/423648/) | D.S.G. | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Cubing continuous turns | `res://assets/audio/sfx/leisure/cube.wav` | 118,628 / 1.344 | [Freesound - Rubik's solving.wav by Sancuino](https://freesound.org/people/Sancuino/sounds/560867/) | Sancuino | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Cubing plastic click accent | `res://assets/audio/sfx/leisure/cube_click.wav` | 35,324 / 0.400 | [Freesound - Rubik's solving.wav by Sancuino](https://freesound.org/people/Sancuino/sounds/560867/) | Sancuino | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Eating continuous food loop | `res://assets/audio/sfx/eating/eating.wav` | 445,940 / 5.056 | [Eating soup](https://freesound.org/people/MilanKovanda/sounds/377041/) | MilanKovanda | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Eating/dish-washing cutlery | `res://assets/audio/sfx/eating/cutlery.wav` | 95,052 / 1.077 | [Freesound - plate with cutlery.wav by hinzebeat](https://freesound.org/people/hinzebeat/sounds/275585/) | hinzebeat | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Fridge opened for a meal | `res://assets/audio/sfx/eating/fridge_open.wav` | 176,444 / 2.000 | [Freesound - opening_fridge.wav by 13F_Panska_Tlolkova_Matilda](https://freesound.org/people/13F_Panska_Tlolkova_Matilda/sounds/378327/) | 13F_Panska_Tlolkova_Matilda | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Fridge closing | `res://assets/audio/sfx/eating/fridge_close.wav` | 86,598 / 0.981 | [Freesound - closing fridge door.m4a by LinaPeralta](https://freesound.org/people/LinaPeralta/sounds/532350/) | LinaPeralta | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Reels short laughter clip | `res://assets/audio/sfx/leisure/reel_giggle.wav` | 44,078 / 0.499 | [cute giggle.wav](https://freesound.org/people/Reitanna/sounds/252218/) | Reitanna | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Reels short pet clip | `res://assets/audio/sfx/leisure/reel_dog.wav` | 21,766 / 0.246 | [Single Dog Bark](https://freesound.org/people/kwahmah_02/sounds/277058/) | kwahmah_02 | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Judy/TipTop book handling A | `res://assets/audio/sfx/environment/books.wav` | 202,902 / 2.300 | [Book - Handling and flipping through pages.wav](https://freesound.org/people/khenshom/sounds/481077/) | khenshom | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| TipTop book handling B | `res://assets/audio/sfx/environment/books_alt.wav` | 202,902 / 2.300 | [Book - Handling and flipping through pages.wav](https://freesound.org/people/khenshom/sounds/481077/) | khenshom | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| TipTop book handling C | `res://assets/audio/sfx/environment/books_third.wav` | 202,902 / 2.300 | [Book - Handling and flipping through pages.wav](https://freesound.org/people/khenshom/sounds/481077/) | khenshom | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Book scattering/disaster | `res://assets/audio/sfx/environment/book_fall.wav` | 300,058 / 3.402 | [Freesound - BOOK FALLING.WAV by edzie777](https://freesound.org/people/edzie777/sounds/367064/) | edzie777 | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Repair recurring ratchet | `res://assets/audio/sfx/repair/ratchet.wav` | 264,644 / 3.000 | [Freesound - Ratchet (ratchet2.wav) by sgossner](https://freesound.org/people/sgossner/sounds/375709/) | sgossner | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Repair metal contact | `res://assets/audio/sfx/repair/clank.wav` | 24,516 / 0.277 | [Audio/impactMetal_light_000.ogg](https://kenney.nl/assets/impact-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Dialogue advance/research notes | `res://assets/audio/sfx/ui/paper.wav` | 35,324 / 0.400 | [Freesound - rustling paper.wav by keweldog](https://freesound.org/people/keweldog/sounds/181774/) | keweldog | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Research desk contact | `res://assets/audio/sfx/research/desk.wav` | 13,666 / 0.154 | [impactWood_light_000.ogg](https://kenney.nl/assets/impact-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Bed-making/sleep bedding | `res://assets/audio/sfx/environment/cloth.wav` | 151,748 / 1.720 | [Freesound - Clothes Rustling 1 by WasabiWielder](https://freesound.org/people/WasabiWielder/sounds/334219/) | WasabiWielder | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| TipTop watering chore | `res://assets/audio/sfx/environment/water_plant.wav` | 264,644 / 3.000 | [Freesound - Watering Plant by om.satalkar](https://freesound.org/people/om.satalkar/sounds/739415/) | om.satalkar | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Judy/TipTop cleaning | `res://assets/audio/sfx/environment/wipe.wav` | 176,444 / 2.000 | [Freesound - WindowWipe.wav by mitchanary](https://freesound.org/people/mitchanary/sounds/505171/) | mitchanary | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Water overflow/wet plant | `res://assets/audio/sfx/environment/drip.wav` | 105,884 / 1.200 | [Freesound - water dripping 1 by hybu](https://freesound.org/people/hybu/sounds/139748/) | hybu | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Quiet apartment atmosphere | `res://assets/audio/sfx/environment/room.wav` | 1,587,644 / 18.000 | [Freesound - room tone small trailer2b with distant highway traffic and electric hum.flac by kyles](https://freesound.org/people/kyles/sounds/451187/) | kyles | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Quiet fridge hum | `res://assets/audio/sfx/environment/fridge.wav` | 705,644 / 8.000 | [TheShopCollection_convenience_store_drinks_fridge_drone.wav](https://opengameart.org/content/the-shop) | LEGIT Audio | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Faulty tap running water | `res://assets/audio/sfx/environment/tap.wav` | 705,644 / 8.000 | [Freesound - water run from tap faucet into large metal sink roomy.flac by kyles](https://freesound.org/people/kyles/sounds/452314/) | kyles | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Quiet TipTop travel | `res://assets/audio/sfx/tiptop/servo.wav` | 441,044 / 5.000 | [Freesound - Servo motor working by D31V228](https://freesound.org/people/D31V228/sounds/723999/) | D31V228 | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Nearby mosquitoes buzzing | `res://assets/audio/sfx/mosquito/mosquito.wav` | 441,044 / 5.000 | [Freesound - Mosquito 1 Edit.wav by IanFSA](https://freesound.org/people/IanFSA/sounds/662970/) | IanFSA | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Judy wooden footstep A | `res://assets/audio/sfx/environment/step_0.wav` | 22,058 / 0.250 | [footstep_wood_000.ogg](https://kenney.nl/assets/impact-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Judy wooden footstep B | `res://assets/audio/sfx/environment/step_1.wav` | 22,232 / 0.252 | [footstep_wood_001.ogg](https://kenney.nl/assets/impact-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Judy wooden footstep C | `res://assets/audio/sfx/environment/step_2.wav` | 22,216 / 0.251 | [footstep_wood_002.ogg](https://kenney.nl/assets/impact-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Repair recurring power screwdriver | `res://assets/audio/sfx/repair/screwdriver.wav` | 184,874 / 2.096 | [electric-screwdriver-1](https://bigsoundbank.com/electric-screwdriver-1-s1572.html) | Joseph SARDIN | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Eating recurring crunch/chew | `res://assets/audio/sfx/eating/chewing.wav` | 263,788 / 2.990 | [raw-carrot-crunched-1](https://bigsoundbank.com/raw-carrot-crunched-1-s1594.html) | Joseph SARDIN | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Research typing loop B | `res://assets/audio/sfx/research/typing_alt.wav` | 529,244 / 6.000 | [quick-keyboard](https://bigsoundbank.com/quick-keyboard-s1734.html) | Joseph SARDIN | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Eating recurring glass contact | `res://assets/audio/sfx/eating/cup.wav` | 23,522 / 0.266 | [glass-placed-on-table](https://bigsoundbank.com/glass-placed-on-table-s1204.html) | Joseph SARDIN | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Organizing/cleanup hardcover contact | `res://assets/audio/sfx/environment/book_stack.wav` | 34,156 / 0.387 | [closed-book-1](https://bigsoundbank.com/closed-book-1-s1410.html) | Joseph SARDIN | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Phone games laser A | `res://assets/audio/sfx/leisure/laser_0.wav` | 20,808 / 0.235 | [Audio/laserRetro_000.ogg](https://kenney.nl/assets/sci-fi-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Phone games laser B | `res://assets/audio/sfx/leisure/laser_1.wav` | 22,540 / 0.255 | [Audio/laserRetro_002.ogg](https://kenney.nl/assets/sci-fi-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Phone games explosion | `res://assets/audio/sfx/leisure/explosion.wav` | 68,616 / 0.777 | [Audio/explosionCrunch_000.ogg](https://kenney.nl/assets/sci-fi-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Phone games periodic score cue | `res://assets/audio/sfx/leisure/score.wav` | 89,322 / 1.012 | [Audio/powerUp1.ogg](https://kenney.nl/assets/digital-audio) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Reels licensed comic effect | `res://assets/audio/sfx/leisure/reel_boing.wav` | 34,036 / 0.385 | [Audio/phaseJump1.ogg](https://kenney.nl/assets/digital-audio) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Faulty tap start/malfunction | `res://assets/audio/sfx/tiptop/fault.wav` | 132,344 / 1.500 | [Audio/computerNoise_001.ogg](https://kenney.nl/assets/sci-fi-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Button hover/focus | `res://assets/audio/sfx/ui/ui_hover.wav` | 2,092 / 0.023 | [Audio/tick_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Button press/valid E interaction | `res://assets/audio/sfx/ui/ui_click.wav` | 928 / 0.010 | [Audio/click_003.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Confirmation/activity/TipTop task completion | `res://assets/audio/sfx/ui/confirm.wav` | 25,608 / 0.290 | [Audio/confirmation_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Cancel/back/main-menu | `res://assets/audio/sfx/ui/cancel.wav` | 5,678 / 0.064 | [Audio/back_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Pause/menu/modal opened | `res://assets/audio/sfx/ui/menu.wav` | 13,078 / 0.148 | [Audio/open_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Pause resumed/closed | `res://assets/audio/sfx/ui/resume.wav` | 13,078 / 0.148 | [Audio/close_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Reels scrolling transition | `res://assets/audio/sfx/leisure/swipe.wav` | 88,246 / 1.000 | [Audio/scroll_001.ogg](https://kenney.nl/assets/interface-sounds) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Successful Judy/TipTop mosquito zap A | `res://assets/audio/sfx/mosquito/swat.wav` | 80,838 / 0.916 | [Audio/zap1.ogg](https://kenney.nl/assets/digital-audio) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |
| Successful mosquito zap B | `res://assets/audio/sfx/mosquito/swat_alt.wav` | 102,606 / 1.163 | [Audio/zap2.ogg](https://kenney.nl/assets/digital-audio) | Kenney | CC0-1.0; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |

## Required subcategories with limitations

| Sound/event | Current connection | Status |
| --- | --- | --- |
| Dedicated spacebar/Enter recording | Strong real keyboard-clack accent is connected; dedicated spacebar downloads returned HTTP 403. The accent is not mislabeled as a recorded spacebar or Enter key. | MISSING ASSET (dedicated variant); generic accent IMPLEMENTED WITH VERIFIED ASSET |
| Standalone book-sliding recording | Three real book-handling variants, a drop and hardcover contact are connected; standalone slide download returned HTTP 403. | PARTIALLY IMPLEMENTED |
| Toolbox rummage/rattle | Real ratchet, screwdriver and metal impact are connected; toolbox download returned HTTP 403. | MISSING ASSET (dedicated variant) |
| Sustained watched repair | Existing repairs resolve atomically. A 4.2-second audio-only schedule accompanies their result; no long repair activity was introduced. | PARTIALLY IMPLEMENTED (no long repair activity exists) |
| Phone swipe | Licensed Kenney scrolling feedback is connected; not claimed to be a smartphone recording. | IMPLEMENTED WITH VERIFIED ASSET (generic licensed effect) |

## License and tool notes

All active source assets are CC0 1.0: commercial inclusion, adaptation and redistribution are permitted; attribution is optional. Voluntary source/creator credits are above. [CC0 terms](https://creativecommons.org/publicdomain/zero/1.0/).
Kenney Digital Audio, Sci-Fi Sounds and Interface Sounds came from publisher archives recorded in the JSON. Only exact named audio members were read; archives were not blindly extracted into the project. Joseph SARDIN recordings came from BigSoundBank pages explicitly marking the files CC0, using their published MP3 downloads. Existing Freesound HQ previews retain their earlier documented sources/licenses.
No commercial viral clip, voice clone or replacement composition was used. Failed downloads and successfully sourced alternatives are separated in the JSON. No missing asset was silently replaced with a beep.
Offline decoder: miniaudio 1.71 (MIT), publisher PyPI wheel SHA-256 checked against PyPI metadata, unpacked into a temporary tool folder. NumPy was already available. Neither is a game/export dependency; no decoder binary was added to the project.
