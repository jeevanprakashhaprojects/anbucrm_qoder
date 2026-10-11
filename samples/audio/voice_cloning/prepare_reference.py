"""Analyse recordings and extract the best segments for voice cloning reference."""
import struct, wave, os, math

REC_DIR = os.path.join(os.path.dirname(__file__), "recordings")
OUT_DIR = os.path.dirname(__file__)

def rms_frames(path, frame_size=1600, hop=1600):
    with wave.open(path, "rb") as w:
        sr = w.getframerate()
        n_ch = w.getnchannels()
        sw = w.getsampwidth()
        raw = w.readframes(w.getnframes())
    fmt = {1: "b", 2: "h", 4: "i"}[sw]
    samples = struct.unpack(f"<{len(raw)//sw}{fmt}", raw)
    if n_ch == 2:
        samples = [samples[i] for i in range(0, len(samples), 2)]
    peak = max(abs(s) for s in samples) or 1
    energies = []
    for start in range(0, len(samples) - frame_size, hop):
        chunk = samples[start:start + frame_size]
        e = math.sqrt(sum(s * s for s in chunk) / len(chunk)) / peak
        energies.append(e)
    return energies, sr, hop

for i in range(1, 7):
    path = os.path.join(REC_DIR, f"recording_{i}.wav")
    if not os.path.exists(path):
        continue
    energies, sr, hop = rms_frames(path)
    total_s = len(energies) * hop / sr
    loud = sum(1 for e in energies if e > 0.05) * hop / sr
    print(f"recording_{i}.wav: {total_s:.1f}s total, {loud:.1f}s speech-like (>{0.05:.2f} energy)")
