"""Write the requested asset inventory from recorded offline decode metadata."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
data = json.loads((ROOT / "assets/audio/SFX_VERIFICATION.json").read_text(encoding="utf-8"))
uses = {
    "typing": "Research mechanical typing loop A", "typing_alt": "Research typing loop B",
    "key_clack": "Research real key accents", "cube": "Cubing continuous turns",
    "cube_click": "Cubing plastic click accent", "eating": "Eating continuous food loop",
    "chewing": "Eating recurring crunch/chew", "cutlery": "Eating/dish-washing cutlery",
    "cup": "Eating recurring glass contact", "fridge_open": "Fridge opened for a meal",
    "fridge_close": "Fridge closing", "reel_giggle": "Reels short laughter clip",
    "reel_dog": "Reels short pet clip", "reel_boing": "Reels licensed comic effect",
    "swipe": "Reels scrolling transition", "laser_0": "Phone games laser A",
    "laser_1": "Phone games laser B", "explosion": "Phone games explosion",
    "score": "Phone games periodic score cue", "books": "Judy/TipTop book handling A",
    "books_alt": "TipTop book handling B", "books_third": "TipTop book handling C",
    "book_fall": "Book scattering/disaster", "book_stack": "Organizing/cleanup hardcover contact",
    "ratchet": "Repair recurring ratchet", "screwdriver": "Repair recurring power screwdriver",
    "clank": "Repair metal contact", "paper": "Dialogue advance/research notes",
    "desk": "Research desk contact", "cloth": "Bed-making/sleep bedding",
    "water_plant": "TipTop watering chore", "wipe": "Judy/TipTop cleaning",
    "drip": "Water overflow/wet plant", "room": "Quiet apartment atmosphere",
    "fridge": "Quiet fridge hum", "tap": "Faulty tap running water",
    "servo": "Quiet TipTop travel", "mosquito": "Nearby mosquitoes buzzing",
    "swat": "Successful Judy/TipTop mosquito zap A", "swat_alt": "Successful mosquito zap B",
    "step_0": "Judy wooden footstep A", "step_1": "Judy wooden footstep B",
    "step_2": "Judy wooden footstep C", "fault": "Faulty tap start/malfunction",
    "ui_hover": "Button hover/focus", "ui_click": "Button press/valid E interaction",
    "confirm": "Confirmation/activity/TipTop task completion", "cancel": "Cancel/back/main-menu",
    "menu": "Pause/menu/modal opened", "resume": "Pause resumed/closed",
}
records = data["assets"]
lines = [
    "# Audio asset manifest — Step 42A.2", "",
    "**IMPLEMENTED WITH VERIFIED ASSET** means the file exists, its source and prepared output decoded successfully, and its gameplay call/loop is connected in source. It does not claim in-engine playback was heard or tested. No Godot launch, gameplay simulation, automated test or screenshot was performed.", "",
    "All active SFX below are mono 16-bit PCM WAV at 44,100 Hz. Source formats, actual download URLs, excerpt positions, normalization, source/output hashes and decode evidence are in `SFX_VERIFICATION.json`. These files were decoded and converted, not merely renamed.", "",
    f"{len(records)} active PCM files, {sum(r['bytes'] for r in records):,} bytes total. {sum(bool(r['downloaded_this_step']) for r in records)} use source members/recordings downloaded in this step; the other {sum(not bool(r['downloaded_this_step']) for r in records)} use existing licensed recordings. Old originals are retained. Previous homemade expressive WAVs are not used by the active registry.", "",
    "## Original approved BGM", "",
    "- Event: global title/menu, New Game, Continue, gameplay and endings.",
    "- File: `res://assets/audio/music/chilllofir-loop.ogg`.",
    "- 2,360,833 bytes; Ogg Vorbis, stereo, 44.1 kHz; offline decode: 97.216 seconds / 4,287,228 frames; non-silent RMS approximately -17.05 dBFS.",
    "- [Chill lofi inspired — loop edit](https://opengameart.org/content/chill-lofi-inspired-loop-edit), omfgdude; loop edit qubodup. CC0 1.0, attribution optional; voluntary credits retained in `music/CREDITS.md`.",
    "- SHA-256: `ccaa02bb60310146f1fa3b1c70be0a5a57f0674b9c4944a22b85b0c03e932cdb`. Original bytes, composition, loop and pitch unchanged.",
    "- Status: **IMPLEMENTED WITH VERIFIED ASSET**; startup/routing recovery implemented. Audible recovery remains unverified pending manual playtest.", "",
    "## Active SFX", "",
    "| Event | Local file | Bytes / seconds | Source | Creator | License / attribution | Asset status |",
    "| --- | --- | --- | --- | --- | --- | --- |",
]
for record in records:
    title = record.get("title", record["key"]).replace("|", "/").replace("[", "").replace("]", "")
    lines.append(f"| {uses[record['key']]} | `res://{record['path']}` | {record['bytes']:,} / {record['duration_seconds']:.3f} | [{title}]({record['source']}) | {record['author']} | {record['license']}; credit optional, retained | IMPLEMENTED WITH VERIFIED ASSET |")
lines += [
    "", "## Required subcategories with limitations", "",
    "| Sound/event | Current connection | Status |",
    "| --- | --- | --- |",
    "| Dedicated spacebar/Enter recording | Strong real keyboard-clack accent is connected; dedicated spacebar downloads returned HTTP 403. The accent is not mislabeled as a recorded spacebar or Enter key. | MISSING ASSET (dedicated variant); generic accent IMPLEMENTED WITH VERIFIED ASSET |",
    "| Standalone book-sliding recording | Three real book-handling variants, a drop and hardcover contact are connected; standalone slide download returned HTTP 403. | PARTIALLY IMPLEMENTED |",
    "| Toolbox rummage/rattle | Real ratchet, screwdriver and metal impact are connected; toolbox download returned HTTP 403. | MISSING ASSET (dedicated variant) |",
    "| Sustained watched repair | Existing repairs resolve atomically. A 4.2-second audio-only schedule accompanies their result; no long repair activity was introduced. | PARTIALLY IMPLEMENTED (no long repair activity exists) |",
    "| Phone swipe | Licensed Kenney scrolling feedback is connected; not claimed to be a smartphone recording. | IMPLEMENTED WITH VERIFIED ASSET (generic licensed effect) |",
    "", "## License and tool notes", "",
    "All active source assets are CC0 1.0: commercial inclusion, adaptation and redistribution are permitted; attribution is optional. Voluntary source/creator credits are above. [CC0 terms](https://creativecommons.org/publicdomain/zero/1.0/).",
    "Kenney Digital Audio, Sci-Fi Sounds and Interface Sounds came from publisher archives recorded in the JSON. Only exact named audio members were read; archives were not blindly extracted into the project. Joseph SARDIN recordings came from BigSoundBank pages explicitly marking the files CC0, using their published MP3 downloads. Existing Freesound HQ previews retain their earlier documented sources/licenses.",
    "No commercial viral clip, voice clone or replacement composition was used. Failed downloads and successfully sourced alternatives are separated in the JSON. No missing asset was silently replaced with a beep.",
    "Offline decoder: miniaudio 1.71 (MIT), publisher PyPI wheel SHA-256 checked against PyPI metadata, unpacked into a temporary tool folder. NumPy was already available. Neither is a game/export dependency; no decoder binary was added to the project.", "",
]
(ROOT / "assets/audio/AUDIO_ASSET_MANIFEST.md").write_text("\n".join(lines), encoding="utf-8")
print("Manifest written:", len(records), "assets")
