"""Offline original arcade/UI SFX authoring; never invoked by the game.

Uses the already available NumPy runtime and Python's wave writer. No samples,
music, voices or third-party sound generators are used. Outputs are 44.1 kHz,
mono PCM16 with short edge fades, DC removal and -3 dBFS peak headroom.
"""
from pathlib import Path
import hashlib
import json
import wave
import numpy as np

RATE = 44100
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets/audio/expressive"
RNG = np.random.default_rng(4201)
records = []


def timeline(seconds):
    return np.arange(round(seconds * RATE)) / RATE


def noise(t, smooth=1):
    samples = RNG.uniform(-1, 1, len(t))
    if smooth > 1:
        samples = np.convolve(samples, np.ones(smooth) / smooth, mode="same")
    return samples


def sweep(t, start, end, decay):
    freq = end + (start - end) * np.exp(-decay * t)
    phase = np.cumsum(freq) * (2 * np.pi / RATE)
    return phase


def write(name, signal, description):
    signal = signal - np.mean(signal)
    edge = min(round(RATE * 0.004), len(signal) // 2)
    signal[:edge] *= np.linspace(0, 1, edge)
    signal[-edge:] *= np.linspace(1, 0, edge)
    signal *= (10 ** (-3 / 20)) / max(float(np.max(np.abs(signal))), 1e-8)
    raw = (signal * 32767).astype("<i2").tobytes()
    path = OUT / (name + ".wav")
    with wave.open(str(path), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(RATE)
        output.writeframes(raw)
    records.append({"file": str(path.relative_to(ROOT)).replace("\\", "/"),
                    "title": name, "author": "Original project SFX authored with Codex",
                    "source": "tools/build_42a1_sfx.py", "license": "CC0-1.0",
                    "license_url": "https://creativecommons.org/publicdomain/zero/1.0/",
                    "method": description, "duration_seconds": len(signal) / RATE,
                    "sha256": hashlib.sha256(path.read_bytes()).hexdigest()})


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for index, (start, end) in enumerate([(1600, 160), (1100, 240)]):
        t = timeline(0.34)
        p = sweep(t, start, end, 11)
        # Swept harmonics, pulse modulation and a noisy attack: a PEW, not a beep.
        x = (np.sin(p + 0.6 * np.sin(p * 1.5)) + 0.28 * np.sin(2 * p))
        x *= np.exp(-t * 14) * (0.8 + 0.2 * np.cos(55 * t))
        x += noise(t, 5) * np.exp(-t * 65) * 0.3
        write(f"laser_{index}", x, "Descending FM/harmonic arcade laser with noisy attack.")
    t = timeline(0.85)
    x = noise(t, 13) * np.exp(-t * 6) * 2.5
    p = sweep(t, 115, 26, 9)
    x += np.sin(p) * np.exp(-t * 7)
    x += noise(t, 2) * np.exp(-t * 30) * 0.35
    write("arcade_explosion", np.tanh(x), "Filtered noise, falling bass and crackly attack; no music sample.")
    t = timeline(0.68)
    p = sweep(t, 960, 110, 5)
    buzz = np.sin(p) + 0.4 * np.sin(3 * p) + 0.18 * np.sin(7 * p)
    pulse = (0.5 + 0.5 * np.sin(2 * np.pi * (35 * t + 20 * t * t))) ** 0.35
    x = (buzz * pulse + 0.45 * noise(t, 3)) * np.exp(-4.5 * t)
    x += noise(t) * np.exp(-t * 80) * 0.45
    write("mosquito_zap", x, "Irregular electric buzz/crackle with punchy transient and falling tail.")
    t = timeline(0.78)
    pulse = (0.5 + 0.5 * np.sin(2 * np.pi * 13 * t)) ** 4
    p = sweep(t, 420, 65, 4)
    x = (np.sin(p) + 0.35 * noise(t, 6)) * pulse * np.exp(-t * 4)
    write("malfunction", x, "Short sputtering electrical/mechanical fault, deliberately distinct from the zap.")
    t = timeline(0.08)
    x = (noise(t, 4) * 0.4 + np.sin(2 * np.pi * 1300 * t) * 0.15) * np.exp(-t * 75)
    write("ui_hover", x, "Short dry tick, with filtered noise and damped resonance.")
    t = timeline(0.16)
    x = (np.sin(2 * np.pi * 170 * t) + 0.4 * np.sin(2 * np.pi * 620 * t)) * np.exp(-t * 50)
    x += noise(t, 3) * np.exp(-t * 100) * 0.5
    write("ui_click", x, "Percussive click/thock; no pitched reward melody.")
    t = timeline(0.26)
    x = noise(t, 5) * np.sin(np.pi * t / t[-1]) ** 2
    x *= 0.5 + 0.5 * np.sin(sweep(t, 180, 70, 9))
    write("phone_swipe", x, "Short filtered-noise swipe/swish between video snippets.")
    t = timeline(0.82)
    p = sweep(t, 390, 80, 5)
    x = np.sin(p + 4 * np.sin(2 * np.pi * 13 * t) * np.exp(-t * 3)) * np.exp(-t * 5)
    x += 0.2 * np.sin(p * 2) * np.exp(-t * 9)
    write("reel_boing", x, "Goofy spring/boing cartoon clip; original synthesized sound, no sampled video.")
    (OUT / "SOURCES.json").write_text(json.dumps({"assets": records}, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
