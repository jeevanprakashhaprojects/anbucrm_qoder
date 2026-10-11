"""Generates synthetic phone-call audio + matching labels for testing the
AnbuCRM AI call-summary feature. Uses macOS `say` for speech and numpy for the
telephone-band processing.

Run: python3 build_sample_call.py
"""

import json
import subprocess
import wave
from pathlib import Path

import numpy as np

SR = 22050
OUT_SR = 16000
OUT_DIR = Path(__file__).resolve().parent
TMP = OUT_DIR / ".build"

AGENT = "Rishi"
CUSTOMER = "Tara"

CONVERSATION = [
    ("agent", "Good morning sir, this is Anbarasan calling from L I C. Am I speaking with Mr Kumar?"),
    ("customer", "Yes, speaking. Who is this?"),
    ("agent", "Sir, this is a reminder about your L I C policy. Your premium of four thousand five hundred rupees is due on the twentieth of October."),
    ("customer", "Oh, I completely forgot about it. Is there any grace period?"),
    ("agent", "Yes sir, you have thirty days grace period. But if you pay before the due date you will avoid the late fee."),
    ("customer", "Okay, how do I pay? Can I pay it online?"),
    ("agent", "Yes, you can pay through the L I C portal, or I can send you a payment link on WhatsApp."),
    ("customer", "Please send the link on WhatsApp. I will pay it this evening."),
    ("agent", "Sure sir, I will send it within five minutes. Thank you for your time."),
    ("customer", "Thank you. Bye."),
]

RATE = {"agent": 168, "customer": 158}
PAUSE_RANGE = (0.30, 0.65)
RINGBACK_SECONDS = 2.4
LEAD_SILENCE = 0.45


def synthesise(text, voice, rate, wav_path):
    aiff = wav_path.with_suffix(".aiff")
    subprocess.run(
        ["say", "-v", voice, "-r", str(rate), "-o", str(aiff), text], check=True
    )
    subprocess.run(
        ["afconvert", "-f", "WAVE", "-d", f"LEI16@{SR}", "-c", "1", str(aiff), str(wav_path)],
        check=True,
    )
    aiff.unlink()


def read_mono(path):
    with wave.open(str(path), "rb") as w:
        frames = w.readframes(w.getnframes())
    return np.frombuffer(frames, dtype="<i2").astype(np.float32) / 32768.0


def bandpass(x, lo=300.0, hi=3400.0):
    spectrum = np.fft.rfft(x)
    freqs = np.fft.rfftfreq(len(x), 1 / SR)
    spectrum[(freqs < lo) | (freqs > hi)] = 0
    return np.fft.irfft(spectrum, n=len(x)).astype(np.float32)


def ringback(seconds):
    n = int(seconds * SR)
    t = np.arange(n) / SR
    tone = 0.30 * np.sin(2 * np.pi * 400 * t)
    env = (t % 0.6 < 0.4).astype(np.float32)
    # soften the cadence edges so the tone does not click
    env = np.convolve(env, np.ones(160) / 160, mode="same")
    return (tone * env).astype(np.float32)


def silence(seconds):
    return np.zeros(int(seconds * SR), dtype=np.float32)


def resample(x, sr_in, sr_out):
    n_out = int(round(len(x) * sr_out / sr_in))
    return np.interp(np.linspace(0, len(x) - 1, n_out), np.arange(len(x)), x).astype(np.float32)


def write_wav(path, x):
    peak = np.max(np.abs(x)) or 1.0
    x = x / peak * 0.70  # -3 dBFS
    pcm = np.clip(x * 32767, -32768, 32767).astype("<i2")
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(OUT_SR)
        w.writeframes(pcm.tobytes())


def build():
    rng = np.random.default_rng(7)
    TMP.mkdir(exist_ok=True)

    track = np.concatenate([ringback(RINGBACK_SECONDS), silence(0.25), silence(LEAD_SILENCE)])
    turns = []
    cursor = RINGBACK_SECONDS + 0.25

    for i, (speaker, text) in enumerate(CONVERSATION):
        seg_path = TMP / f"seg_{i:02d}.wav"
        synthesise(text, AGENT if speaker == "agent" else CUSTOMER, RATE[speaker], seg_path)
        audio = bandpass(read_mono(seg_path))
        seg_path.unlink()

        start = cursor + LEAD_SILENCE if i == 0 else cursor
        turns.append(
            {
                "index": i,
                "speaker": speaker,
                "text": text.replace("L I C", "LIC"),
                "start_sec": round(float(start), 2),
                "end_sec": round(float(start + len(audio) / SR), 2),
            }
        )

        track = np.concatenate([track, audio])
        cursor = start + len(audio) / SR
        gap = float(rng.uniform(*PAUSE_RANGE))
        track = np.concatenate([track, silence(gap)])
        cursor += gap

    line_hiss = rng.normal(0, 0.004, len(track)).astype(np.float32)
    track = bandpass(track + line_hiss)

    # band-limit to 3.4 kHz before downsampling so the 22050 -> 16000 step cannot alias
    wav_path = OUT_DIR / "call_001_premium_reminder.wav"
    write_wav(wav_path, resample(track, SR, OUT_SR))

    labels = {
        "id": "call_001",
        "scenario": "LIC premium renewal reminder - outbound agent call",
        "agent": "T G Anbarasan",
        "customer": "Mr Kumar",
        "outcome": "promise_to_pay",
        "source": "synthetic (macOS `say`, Indian English voices Rishi + Tara)",
        "sample_rate_hz": OUT_SR,
        "channels": 1,
        "duration_sec": round(len(track) / SR, 2),
        "turns": turns,
        "expected_summary": (
            "Agent Anbarasan called Mr Kumar to remind him that his LIC premium of "
            "Rs 4,500 is due on 20 October. The customer had forgotten and asked about "
            "the grace period; the agent explained it is 30 days but paying before the "
            "due date avoids a late fee. The customer agreed to pay this evening and "
            "asked for a payment link on WhatsApp, which the agent promised within five "
            "minutes. Outcome: promise to pay, follow-up required."
        ),
        "expected_entities": {
            "amount_inr": 4500,
            "due_date": "2026-10-20",
            "grace_period_days": 30,
            "payment_channel": "WhatsApp link",
            "follow_up": "same day evening",
        },
    }
    (OUT_DIR / "call_001_premium_reminder.json").write_text(json.dumps(labels, indent=2))

    TMP.rmdir()
    return wav_path, labels


if __name__ == "__main__":
    path, labels = build()
    print(f"wrote {path}")
    print(f"duration {labels['duration_sec']}s, {len(labels['turns'])} turns, {labels['sample_rate_hz']} Hz mono")
