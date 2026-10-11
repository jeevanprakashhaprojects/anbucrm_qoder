"""Generates Tanglish (Tamil + English) phone call audio with more natural voices.
Uses Vani (Tamil) for Tamil segments and Tara (Siri voice) for English segments.
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

TAMIL_VOICE = "Vani"
ENGLISH_VOICE = "Tara"  # Siri voice, more natural

# Tanglish conversation: Tamil and English mixed naturally
# Each turn is a list of (language, text) tuples
CONVERSATION = [
    ("agent", [
        ("tamil", "வணக்கம் சார்"),
        ("english", "Good morning"),
        ("tamil", "நான் அன்பரசன் பேசுகிறேன்"),
        ("english", "LIC agent"),
        ("tamil", "உங்கள் பாலிசி ரெனுவல் பத்தி பேசலாம்"),
    ]),
    ("customer", [
        ("tamil", "ஆமா சொல்லுங்க"),
        ("english", "Who is this"),
    ]),
    ("agent", [
        ("tamil", "சார் உங்க"),
        ("english", "LIC policy"),
        ("tamil", "ப்ரீமியம்"),
        ("english", "four thousand five hundred rupees"),
        ("tamil", "இது வரும்"),
        ("english", "twentieth October"),
        ("tamil", " தேதிக்கு கட்டணும்"),
    ]),
    ("customer", [
        ("tamil", "ஓ"),
        ("english", "I completely forgot"),
        ("tamil", "கிரேஸ் பீரியட் எவ்வளவு"),
    ]),
    ("agent", [
        ("tamil", "முப்பது நாள் கிரேஸ் பீரியட் சார்"),
        ("english", "But if you pay before the due date"),
        ("tamil", "லேட் ஃபீ தப்பிக்கலாம்"),
    ]),
    ("customer", [
        ("tamil", "சரி"),
        ("english", "How do I pay"),
        ("tamil", "ஆன்லைன்ல கட்டலாமா"),
    ]),
    ("agent", [
        ("english", "Yes"),
        ("tamil", "எல்ஐசி போர்ட்டல் வழியா கட்டலாம்"),
        ("english", "Or I can send you a payment link on WhatsApp"),
    ]),
    ("customer", [
        ("tamil", "வாட்ஸ்அப்ல லிங்க் அனுப்புங்க"),
        ("english", "I will pay this evening"),
    ]),
    ("agent", [
        ("tamil", "சரி சார்"),
        ("english", "I will send it within five minutes"),
        ("tamil", "நன்றி"),
    ]),
    ("customer", [
        ("tamil", "நன்றி"),
        ("english", "Bye"),
    ]),
]

RATE = {"agent": 165, "customer": 155}
PAUSE_RANGE = (0.35, 0.70)
RINGBACK_SECONDS = 2.4
LEAD_SILENCE = 0.45


def synthesise_segment(text, voice, rate, wav_path):
    """Generate a single segment with the specified voice."""
    aiff = wav_path.with_suffix(".aiff")
    subprocess.run(
        ["say", "-v", voice, "-r", str(rate), "-o", str(aiff), text],
        check=True,
        capture_output=True,
    )
    subprocess.run(
        ["afconvert", "-f", "WAVE", "-d", f"LEI16@{SR}", "-c", "1", str(aiff), str(wav_path)],
        check=True,
        capture_output=True,
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
    env = np.convolve(env, np.ones(160) / 160, mode="same")
    return (tone * env).astype(np.float32)


def silence(seconds):
    return np.zeros(int(seconds * SR), dtype=np.float32)


def resample(x, sr_in, sr_out):
    n_out = int(round(len(x) * sr_out / sr_in))
    return np.interp(np.linspace(0, len(x) - 1, n_out), np.arange(len(x)), x).astype(np.float32)


def write_wav(path, x):
    peak = np.max(np.abs(x)) or 1.0
    x = x / peak * 0.70
    pcm = np.clip(x * 32767, -32768, 32767).astype("<i2")
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(OUT_SR)
        w.writeframes(pcm.tobytes())


def build_turn(segments, speaker, turn_index):
    """Build a single turn by stitching Tamil and English segments."""
    turn_audio = np.array([], dtype=np.float32)
    for seg_idx, (lang, text) in enumerate(segments):
        voice = TAMIL_VOICE if lang == "tamil" else ENGLISH_VOICE
        seg_path = TMP / f"seg_{turn_index:02d}_{seg_idx:02d}.wav"
        synthesise_segment(text, voice, RATE[speaker], seg_path)
        audio = bandpass(read_mono(seg_path))
        seg_path.unlink()

        # Small gap between language switches within a turn (natural pause)
        if seg_idx > 0:
            turn_audio = np.concatenate([turn_audio, silence(0.08)])

        turn_audio = np.concatenate([turn_audio, audio])

    return turn_audio


def build():
    rng = np.random.default_rng(7)
    TMP.mkdir(exist_ok=True)

    track = np.concatenate([ringback(RINGBACK_SECONDS), silence(0.25), silence(LEAD_SILENCE)])
    turns = []
    cursor = RINGBACK_SECONDS + 0.25

    for i, (speaker, segments) in enumerate(CONVERSATION):
        turn_audio = build_turn(segments, speaker, i)

        # Reconstruct the full text for the label
        full_text = " ".join(text for _, text in segments)

        start = cursor + LEAD_SILENCE if i == 0 else cursor
        turns.append(
            {
                "index": i,
                "speaker": speaker,
                "text": full_text,
                "segments": [{"lang": lang, "text": text} for lang, text in segments],
                "start_sec": round(float(start), 2),
                "end_sec": round(float(start + len(turn_audio) / SR), 2),
            }
        )

        track = np.concatenate([track, turn_audio])
        cursor = start + len(turn_audio) / SR
        gap = float(rng.uniform(*PAUSE_RANGE))
        track = np.concatenate([track, silence(gap)])
        cursor += gap

    line_hiss = rng.normal(0, 0.004, len(track)).astype(np.float32)
    track = bandpass(track + line_hiss)

    wav_path = OUT_DIR / "call_002_tanglish_premium_reminder.wav"
    write_wav(wav_path, resample(track, SR, OUT_SR))

    labels = {
        "id": "call_002",
        "scenario": "LIC premium renewal reminder - Tanglish (Tamil + English)",
        "agent": "T G Anbarasan",
        "customer": "Mr Kumar",
        "outcome": "promise_to_pay",
        "source": "synthetic (macOS `say`, Tamil voice Vani + English Siri voice Tara)",
        "sample_rate_hz": OUT_SR,
        "channels": 1,
        "duration_sec": round(len(track) / SR, 2),
        "turns": turns,
        "expected_summary": (
            "Agent Anbarasan called Mr Kumar in Tanglish to remind him that his LIC premium of "
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
    (OUT_DIR / "call_002_tanglish_premium_reminder.json").write_text(json.dumps(labels, indent=2))

    TMP.rmdir()
    return wav_path, labels


if __name__ == "__main__":
    path, labels = build()
    print(f"wrote {path}")
    print(f"duration {labels['duration_sec']}s, {len(labels['turns'])} turns, {labels['sample_rate_hz']} Hz mono")
    print(f"voices: Tamil={TAMIL_VOICE}, English={ENGLISH_VOICE}")
