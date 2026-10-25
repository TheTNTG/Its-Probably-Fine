"""Acquire licensed SFX and prepare real PCM assets; never starts Godot/playback.

Authoring only: requires NumPy and miniaudio in a supplied temporary tools folder.
The game has no Python/decoder dependency. Original project assets are read-only.
"""
import argparse
import concurrent.futures
import hashlib
import html
import io
import json
from pathlib import Path
import re
import sys
import time
import urllib.request
import wave
import zipfile

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "assets/audio"
RATE = 44100
records = []
failures = []


def fetch(url):
    started = time.monotonic()
    with urllib.request.urlopen(url, timeout=10) as response:
        chunks = []
        while chunk := response.read(16384):
            if time.monotonic() - started > 35:
                raise TimeoutError("Download exceeded 35 seconds: " + url)
            chunks.append(chunk)
        return b"".join(chunks)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def sound_format(data):
    if data[:4] == b"OggS" and b"vorbis" in data[:100]:
        return "ogg"
    if data[:4] == b"RIFF" and data[8:12] == b"WAVE":
        return "wav"
    if data[:3] == b"ID3" or (len(data) > 2 and data[0] == 255 and data[1] & 224 == 224):
        return "mp3"
    raise ValueError("Not a supported WAV/MP3/Vorbis file (HTML/empty/unknown rejected)")


def freesound(author, number):
    url = f"https://freesound.org/people/{author}/sounds/{number}/"
    page = fetch(url).decode("utf-8")
    if not re.search(r"creativecommons.org/publicdomain/zero/1.0", page):
        raise ValueError("CC0 not verified: " + url)
    download = re.search(r'https://cdn.freesound.org/previews/[^\s"<>]+-hq.mp3', page).group(0)
    data = fetch(download)
    sound_format(data)
    title = re.search(r'data-title="([^"]+)"', page)
    return data, {"source": url, "download": download, "author": author,
                  "title": html.unescape(title.group(1)) if title else number,
                  "license": "CC0-1.0", "source_bytes": len(data), "source_sha256": sha(data),
                  "downloaded_this_step": True}


def bigsoundbank(slug, number):
    url = "https://bigsoundbank.com/" + slug + "-s" + number + ".html"
    page = fetch(url).decode("utf-8")
    if "CC0" not in page:
        raise ValueError("CC0 not verified: " + url)
    download = "https://bigsoundbank.com/UPLOAD/mp3/" + number + ".mp3"
    if "UPLOAD/mp3/" + number + ".mp3" not in page:
        raise ValueError("No published MP3 URL: " + url)
    data = fetch(download)
    sound_format(data)
    return data, {"source": url, "download": download, "author": "Joseph SARDIN",
                  "title": slug, "license": "CC0-1.0", "source_bytes": len(data),
                  "source_sha256": sha(data), "downloaded_this_step": True}


def prepare(key, folder, source, seconds=None, start=None, target=-17.0):
    data, metadata = source
    fmt = sound_format(data)
    decoded = miniaudio.decode(data, output_format=miniaudio.SampleFormat.FLOAT32,
                               nchannels=1, sample_rate=RATE)
    samples = np.asarray(decoded.samples, dtype=np.float64)
    if not len(samples) or not np.isfinite(samples).all():
        raise ValueError("Empty/invalid decoded samples: " + key)
    original_duration = len(samples) / RATE
    # Choose real audible material, not an arbitrary first second of a recording.
    if seconds is not None and len(samples) > int(seconds * RATE):
        length = int(seconds * RATE)
        if start is None:
            hop = RATE // 10
            energy = np.r_[0.0, np.cumsum(samples * samples)]
            candidates = np.arange(0, len(samples) - length + 1, hop)
            index = int(candidates[np.argmax(energy[candidates + length] - energy[candidates])])
        else:
            index = min(int(start * RATE), len(samples) - length)
        samples = samples[index:index + length].copy()
    else:
        index = 0
        samples = samples.copy()
    samples -= np.mean(samples)
    peak = float(np.max(np.abs(samples)))
    if peak < 0.00001:
        raise ValueError("Silent asset rejected: " + key)
    active = np.flatnonzero(np.abs(samples) > max(peak * 0.004, 0.0001))
    first = max(0, int(active[0]) - int(0.008 * RATE))
    last = min(len(samples), int(active[-1]) + int(0.045 * RATE))
    samples = samples[first:last]
    rms = float(np.sqrt(np.mean(samples * samples)))
    gain = min(10 ** (target / 20) / max(rms, 1e-8), 10 ** (-2 / 20) / peak)
    samples *= gain
    edge = min(int(RATE * 0.004), len(samples) // 2)
    samples[:edge] *= np.linspace(0, 1, edge)
    samples[-edge:] *= np.linspace(1, 0, edge)
    path = BASE / "sfx" / folder / (key + ".wav")
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(RATE)
        output.writeframes((samples * 32767).astype("<i2").tobytes())
    # Decode the actual written file too, rather than reporting a header check.
    result = miniaudio.decode_file(str(path), output_format=miniaudio.SampleFormat.FLOAT32,
                                   nchannels=1, sample_rate=RATE)
    metadata = dict(metadata)
    metadata.update(key=key, path=str(path.relative_to(ROOT)).replace("\\", "/"),
                    format="WAV PCM16 mono 44100 Hz", source_format=fmt,
                    original_duration_seconds=original_duration, duration_seconds=result.duration,
                    bytes=path.stat().st_size, sha256=sha(path.read_bytes()),
                    excerpt_start_seconds=(index + first) / RATE,
                    gain_applied_db=float(20 * np.log10(gain)),
                    peak_dbfs=float(20 * np.log10(np.max(np.abs(samples)))),
                    rms_dbfs=float(20 * np.log10(np.sqrt(np.mean(samples * samples)))),
                    verification="Decoded complete source and written PCM with miniaudio 1.71; non-silent, finite; no gameplay executed",
                    adaptation="Mono/resampled, active excerpt, silence-trimmed, DC removed, normalized with -2 dBFS ceiling, 4 ms edge fades",
                    attribution="Not required (CC0); voluntary credits retained")
    records.append(metadata)
    print(key, path.stat().st_size, round(result.duration, 3), flush=True)


def local_sources():
    result = {}
    for file in ["SOURCES.json", "SOURCES_42A1.json"]:
        for item in json.loads((BASE / file).read_text(encoding="utf-8"))["assets"]:
            path = ROOT / item["file"]
            meta = dict(item)
            meta["source_sha256"] = sha(path.read_bytes())
            meta["source_bytes"] = path.stat().st_size
            meta["downloaded_this_step"] = False
            result[path.stem] = (path.read_bytes(), meta)
    return result


def pack_source(cache, pack, member):
    meta = json.loads((cache / (pack + ".json")).read_text(encoding="utf-8"))
    with zipfile.ZipFile(cache / (pack + ".zip")) as archive:
        data = archive.read(member)  # exact named member only; no path extraction
    return data, dict(meta, author="Kenney", title=member, license="CC0-1.0",
                      source_bytes=len(data), source_sha256=sha(data), downloaded_this_step=True)


def main(cache):
    old = local_sources()
    requests = {"spacebar": ("NotSpideeyDev", "734200"), "spacebar_alt": ("NotSpideeyDev", "734201"),
                "book_slide": ("Heyy_Jayy_", "515002"), "chewing": ("Morgan169", "362024"),
                "cup": ("bbrocer", "382668"), "toolbox": ("Breviceps", "457041"),
                "swat": ("JoelAudio", "136542"), "swat_alt": ("michael_grinnell", "512471")}
    acquired = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        futures = {pool.submit(freesound, *args): key for key, args in requests.items()}
        for future in concurrent.futures.as_completed(futures):
            key = futures[future]
            try:
                acquired[key] = future.result()
            except Exception as error:
                failures.append({"category": key, "error": str(error)})
    # Public source pages can reject automated downloads. Use other licensed
    # publishers instead of bypassing login/anti-bot protections.
    alternatives = {"screwdriver": ("electric-screwdriver-1", "1572"),
                    "cup": ("glass-placed-on-table", "1204"),
                    "chewing": ("raw-carrot-crunched-1", "1594"),
                    "typing_alt": ("quick-keyboard", "1734"),
                    "book_stack": ("closed-book-1", "1410")}
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        futures = {pool.submit(bigsoundbank, *args): key for key, args in alternatives.items()}
        for future in concurrent.futures.as_completed(futures):
            key = futures[future]
            try:
                acquired[key] = future.result()
            except Exception as error:
                failures.append({"category": key, "error": str(error)})

    # Existing real recordings are retained and converted into short reliable clips.
    choices = [
        ("typing", "research", "keyboard_mechanical", None, None),
        ("key_clack", "research", "keyboard_mechanical", 0.16, None),
        ("cube", "leisure", "cube", None, None),
        ("cube_click", "leisure", "cube", 0.4, None),
        ("eating", "eating", "eating", 6.0, None),
        ("cutlery", "eating", "cutlery", None, None),
        ("fridge_open", "eating", "fridge_open", 2.0, None),
        ("fridge_close", "eating", "fridge_close", 1.2, None),
        ("reel_giggle", "leisure", "reel_giggle", None, None),
        ("reel_dog", "leisure", "reel_dog", None, None),
        ("books", "environment", "book_handling", 2.3, 1.05),
        ("books_alt", "environment", "book_handling", 2.3, 35.46),
        ("books_third", "environment", "book_handling", 2.3, 73.68),
        ("book_fall", "environment", "book_fall", None, None),
        ("book_stack", "environment", "book_fall", 0.8, None),
        ("ratchet", "repair", "tools", 3.0, 3.5),
        ("clank", "repair", "metal_clank", None, None),
        ("paper", "ui", "paper", 0.4, None),
        ("desk", "research", "desk", None, None),
        ("cloth", "environment", "cloth", None, None),
        ("water_plant", "environment", "water_plant", 3.0, None),
        ("wipe", "environment", "wipe", 2.0, None),
        ("drip", "environment", "drip", 1.2, None),
        ("room", "environment", "room_tone", 18.0, 2.0),
        ("fridge", "environment", "fridge_hum", 8.0, None),
        ("tap", "environment", "tap", 8.0, 2.0),
        ("servo", "tiptop", "servo", 5.0, None),
        ("mosquito", "mosquito", "mosquito", 5.0, None),
    ]
    choices += [(f"step_{index}", "environment", f"step_wood_{index}", None, None) for index in range(3)]
    for key, folder, source, seconds, start in choices:
        if key in acquired:
            continue
        prepare(key, folder, old[source], seconds, start)
    for key, source in acquired.items():
        folder = ("research" if key.startswith("spacebar") or key == "typing_alt" else "repair" if key in ["toolbox", "screwdriver"]
                  else "mosquito" if key.startswith("swat") else "environment" if key in ["book_slide", "book_stack"] else "eating")
        lengths = {"cup": 0.65, "chewing": 3.0, "typing_alt": 6.0, "screwdriver": 2.5}
        prepare(key, folder, source, lengths.get(key))

    selections = [
        ("laser_0", "leisure", "sci-fi-sounds", "Audio/laserRetro_000.ogg"),
        ("laser_1", "leisure", "sci-fi-sounds", "Audio/laserRetro_002.ogg"),
        ("explosion", "leisure", "sci-fi-sounds", "Audio/explosionCrunch_000.ogg"),
        ("score", "leisure", "digital-audio", "Audio/powerUp1.ogg"),
        ("reel_boing", "leisure", "digital-audio", "Audio/phaseJump1.ogg"),
        ("fault", "tiptop", "sci-fi-sounds", "Audio/computerNoise_001.ogg"),
        ("ui_hover", "ui", "interface-sounds", "Audio/tick_001.ogg"),
        ("ui_click", "ui", "interface-sounds", "Audio/click_003.ogg"),
        ("confirm", "ui", "interface-sounds", "Audio/confirmation_001.ogg"),
        ("cancel", "ui", "interface-sounds", "Audio/back_001.ogg"),
        ("menu", "ui", "interface-sounds", "Audio/open_001.ogg"),
        ("resume", "ui", "interface-sounds", "Audio/close_001.ogg"),
        ("swipe", "leisure", "interface-sounds", "Audio/scroll_001.ogg"),
    ]
    if "swat" not in acquired:
        selections.append(("swat", "mosquito", "digital-audio", "Audio/zap1.ogg"))
    if "swat_alt" not in acquired:
        selections.append(("swat_alt", "mosquito", "digital-audio", "Audio/zap2.ogg"))
    for key, folder, pack, member in selections:
        prepare(key, folder, pack_source(cache, pack, member), seconds=1.5)
    prepared_keys = {item["key"] for item in records}
    output = {"verified_date": "2026-10-25", "decoder": "miniaudio 1.71, temporary offline authoring tool only",
              "assets": records, "download_failures": failures,
              "missing": [item for item in failures if item["category"] not in prepared_keys]}
    (BASE / "SFX_VERIFICATION.json").write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    print("Prepared", len(records), "assets. Missing:", failures, flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--decoder-dir", required=True)
    args = parser.parse_args()
    sys.path.insert(0, args.decoder_dir)
    import miniaudio
    main(Path(args.decoder_dir))
