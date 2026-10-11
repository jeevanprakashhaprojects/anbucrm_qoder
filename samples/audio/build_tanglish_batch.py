"""Generates 10 diverse Tanglish call scenarios for testing AI summarisation.
Each scenario has different outcome, entities, emotional tone, and length.
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
AGENT_ENGLISH_VOICE = "Tara"  # Siri voice
CUSTOMER_VOICES = ["Rishi", "Tara"]  # Alternate male/female

SCENARIOS = [
    {
        "id": "call_003",
        "scenario": "New policy enquiry - Jeevan Anand",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Ramesh",
        "customer_voice_idx": 0,  # Rishi (male)
        "outcome": "new_lead",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "I am Anbarasan from LIC")]),
            ("customer", [("tamil", "ஆமா சொல்லுங்க"), ("english", "I called about a new policy")]),
            ("agent", [("english", "Which plan are you interested in sir")]),
            ("customer", [("english", "Jeevan Anand"), ("tamil", "பத்தி சொல்லுங்க")]),
            ("agent", [("english", "Good choice sir"), ("tamil", "சம் அஷ்யூர்ட் எவ்வளவு")]),
            ("customer", [("english", "ten lakh")]),
            ("agent", [("tamil", "ப்ரீமியம்"), ("english", "around eighty five thousand per year"), ("tamil", "இருபது வருஷத்துக்கு")]),
            ("customer", [("english", "Okay"), ("tamil", "வாட்ஸ்அப்ல டீட்டெயில்ஸ் அனுப்புங்க")]),
            ("agent", [("english", "Sure sir"), ("tamil", "ப்ரோஷர் மற்றும் ப்ரீமியம் சார்ட் அனுப்புகிறேன்")]),
            ("customer", [("tamil", "நன்றி")]),
        ],
        "expected_entities": {"plan": "Jeevan Anand", "sum_assured_lakh": 10, "premium_approx": 85000, "term_years": 20, "follow_up": "send brochure on WhatsApp"},
        "expected_summary": "Mr Ramesh enquired about a new Jeevan Anand policy with sum assured of 10 lakh. Agent Anbarasan quoted approximately Rs 85,000 per year for 20 years. Customer requested details on WhatsApp. Outcome: new lead, brochure to be sent.",
    },
    {
        "id": "call_004",
        "scenario": "Lapsed policy revival",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Kumar",
        "customer_voice_idx": 0,
        "outcome": "appointment_scheduled",
        "segments": [
            ("agent", [("tamil", "வணக்கம்"), ("english", "Is this Mr Kumar")]),
            ("customer", [("tamil", "ஆமா பேசுகிறேன்")]),
            ("agent", [("tamil", "சார் உங்க பாலிசி"), ("english", "lapsed two years ago"), ("tamil", "ரிவைவ் பண்ணலாமா")]),
            ("customer", [("tamil", "ஆமா எப்படி")]),
            ("agent", [("english", "Need medical test and back premiums with interest")]),
            ("customer", [("tamil", "எவ்வளவு ஆகும்")]),
            ("agent", [("english", "Around thirty five thousand"), ("tamil", "வட்டி சேர்த்து")]),
            ("customer", [("tamil", "சரி என்ன டாகுமெண்ட்ஸ்")]),
            ("agent", [("english", "ID proof, address proof, medical certificate")]),
            ("customer", [("tamil", "நாளைக்கு பிரான்ச் வரலாமா")]),
            ("agent", [("english", "Tomorrow ten AM")]),
            ("customer", [("tamil", "ஓகே வர்றேன்")]),
        ],
        "expected_entities": {"lapsed_years": 2, "revival_cost_approx": 35000, "documents": ["ID proof", "address proof", "medical certificate"], "appointment": "tomorrow 10 AM"},
        "expected_summary": "Mr Kumar's policy lapsed 2 years ago. Agent explained revival requires medical test and back premiums with interest, approximately Rs 35,000. Documents needed: ID proof, address proof, medical certificate. Appointment scheduled for tomorrow 10 AM at branch. Outcome: appointment scheduled.",
    },
    {
        "id": "call_005",
        "scenario": "Maturity claim - lost policy bond",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Sharma",
        "customer_voice_idx": 0,
        "outcome": "needs_documents",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "Your policy matured last month")]),
            ("customer", [("tamil", "ஆமா க்ளைம் எப்படி பண்றது")]),
            ("agent", [("english", "Need original policy bond, ID proof, bank details")]),
            ("customer", [("tamil", "பாலிசி பாண்ட் தொலைஞ்சுடுச்சு")]),
            ("agent", [("english", "Need to file FIR and get duplicate")]),
            ("customer", [("tamil", "எவ்வளவு நேரம் ஆகும்")]),
            ("agent", [("english", "Two to three weeks for duplicate"), ("tamil", "அப்புறம் க்ளைம் செட்டில்மெண்ட்")]),
            ("customer", [("tamil", "ஓகே நன்றி")]),
        ],
        "expected_entities": {"maturity_status": "matured last month", "issue": "policy bond lost", "required_action": "file FIR for duplicate", "timeline_weeks": "2-3"},
        "expected_summary": "Mr Sharma's policy matured last month. Customer wants to claim but lost the original policy bond. Agent explained need to file FIR and get duplicate, which takes 2-3 weeks, then claim settlement can proceed. Outcome: needs documents.",
    },
    {
        "id": "call_006",
        "scenario": "Wrong number",
        "agent_name": "Anbarasan",
        "customer_name": "Unknown",
        "customer_voice_idx": 1,  # Tara (female)
        "outcome": "wrong_number",
        "segments": [
            ("agent", [("tamil", "வணக்கம்"), ("english", "Is this Mr Ramesh")]),
            ("customer", [("english", "No wrong number")]),
            ("agent", [("tamil", "சாரி நன்றி")]),
        ],
        "expected_entities": {},
        "expected_summary": "Agent reached wrong number. Call ended immediately. Outcome: wrong number.",
    },
    {
        "id": "call_007",
        "scenario": "Survival benefit reminder",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Patel",
        "customer_voice_idx": 0,
        "outcome": "information_given",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "Your SB is due next month")]),
            ("customer", [("english", "SB means")]),
            ("agent", [("english", "Survival benefit"), ("tamil", "ஐந்து வருஷத்துக்கு ஒரு தடவை ஒரு தொகை கிடைக்கும்")]),
            ("customer", [("tamil", "எவ்வளவு")]),
            ("agent", [("english", "Fifty thousand rupees")]),
            ("customer", [("tamil", "நான் ஏதாவது பண்ணணுமா")]),
            ("agent", [("english", "No sir"), ("tamil", "ஆட்டோமேட்டிகா கிரெடிட் ஆகும்")]),
            ("customer", [("tamil", "ஓகே நன்றி")]),
        ],
        "expected_entities": {"benefit_type": "Survival Benefit", "amount_inr": 50000, "due": "next month", "action_required": "none - auto credited"},
        "expected_summary": "Agent informed Mr Patel that his Survival Benefit of Rs 50,000 is due next month. Customer asked if any action needed; agent confirmed it will be credited automatically. Outcome: information given.",
    },
    {
        "id": "call_008",
        "scenario": "Policy loan enquiry",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Iyer",
        "customer_voice_idx": 0,
        "outcome": "appointment_scheduled",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "You called about a loan")]),
            ("customer", [("tamil", "ஆமா"), ("english", "I need two lakh")]),
            ("agent", [("english", "Your policy value is five lakh"), ("tamil", "எண்பது சதவீதம் வரைக்கும் கடன் கிடைக்கும்")]),
            ("customer", [("english", "So four lakh")]),
            ("agent", [("english", "Yes but two lakh is fine"), ("tamil", "வட்டி ஒன்பது சதவீதம்")]),
            ("customer", [("tamil", "எவ்வளவு நேரம் ஆகும்")]),
            ("agent", [("english", "Three to four days after documents")]),
            ("customer", [("tamil", "என்ன டாகுமெண்ட்ஸ்")]),
            ("agent", [("english", "ID, policy bond, loan application form")]),
            ("customer", [("tamil", "ஓகே நாளைக்கு வர்றேன்")]),
        ],
        "expected_entities": {"loan_amount_requested": 200000, "policy_value": 500000, "max_loan_percent": 80, "interest_rate_percent": 9, "processing_days": "3-4", "documents": ["ID", "policy bond", "loan application form"]},
        "expected_summary": "Mr Iyer requested a policy loan of Rs 2 lakh. Agent explained policy value is Rs 5 lakh, can get up to 80% (Rs 4 lakh), but 2 lakh is fine. Interest rate 9% per year, processing takes 3-4 days after documents. Customer will visit branch tomorrow. Outcome: appointment scheduled.",
    },
    {
        "id": "call_009",
        "scenario": "Nominee change request",
        "agent_name": "Anbarasan",
        "customer_name": "Mrs Lakshmi",
        "customer_voice_idx": 1,  # Tara (female)
        "outcome": "appointment_scheduled",
        "segments": [
            ("agent", [("tamil", "வணக்கம் மேடம்"), ("english", "You want to change nominee")]),
            ("customer", [("tamil", "ஆமா"), ("english", "I want to add my son")]),
            ("agent", [("english", "Current nominee is your husband")]),
            ("customer", [("english", "Yes but I want fifty fifty share")]),
            ("agent", [("english", "Okay need to visit branch with ID and relationship proof")]),
            ("customer", [("english", "When")]),
            ("agent", [("english", "Any weekday ten to five")]),
            ("customer", [("english", "Saturday")]),
            ("agent", [("english", "Saturday ten to one only")]),
            ("customer", [("english", "Okay this Saturday")]),
        ],
        "expected_entities": {"current_nominee": "husband", "requested_change": "add son with 50-50 share", "documents": ["ID", "relationship proof"], "appointment": "this Saturday 10-1"},
        "expected_summary": "Mrs Lakshmi wants to change nominee from husband to 50-50 share between husband and son. Agent explained need to visit branch with ID and relationship proof. Saturday hours are 10 AM to 1 PM. Appointment scheduled for this Saturday. Outcome: appointment scheduled.",
    },
    {
        "id": "call_010",
        "scenario": "Missed call follow-up - payment receipt",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Reddy",
        "customer_voice_idx": 0,
        "outcome": "resolved",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "I am returning your missed call")]),
            ("customer", [("tamil", "ஆமா"), ("english", "I called about premium payment")]),
            ("agent", [("english", "Yes sir how can I help")]),
            ("customer", [("english", "I paid online but did not get receipt")]),
            ("agent", [("english", "What is your policy number")]),
            ("customer", [("english", "eight one two three four five six seven eight")]),
            ("agent", [("english", "Let me check"), ("tamil", "ஆமா நேத்து வந்துடுச்சு"), ("english", "I will WhatsApp the receipt")]),
            ("customer", [("tamil", "ஓகே நன்றி")]),
        ],
        "expected_entities": {"policy_number": "812345678", "issue": "paid online, no receipt received", "resolution": "receipt to be sent on WhatsApp"},
        "expected_summary": "Mr Reddy called about premium payment. Paid online but did not receive receipt. Agent checked policy number 812345678, confirmed payment received yesterday, will send receipt on WhatsApp. Outcome: resolved.",
    },
    {
        "id": "call_011",
        "scenario": "Payment received confirmation",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Nair",
        "customer_voice_idx": 0,
        "outcome": "resolved",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "Confirming we received your premium")]),
            ("customer", [("tamil", "ஆமா நேத்து கட்டினேன்")]),
            ("agent", [("english", "Twenty five thousand rupees for policy nine eight seven six five four three two one")]),
            ("customer", [("english", "Yes that is correct")]),
            ("agent", [("english", "Receipt has been sent to your email and WhatsApp")]),
            ("customer", [("tamil", "ஓகே நன்றி")]),
        ],
        "expected_entities": {"amount_inr": 25000, "policy_number": "987654321", "payment_date": "yesterday", "receipt_sent_to": ["email", "WhatsApp"]},
        "expected_summary": "Agent confirmed receipt of Rs 25,000 premium for policy 987654321 from Mr Nair. Payment made yesterday. Receipt sent to email and WhatsApp. Outcome: resolved.",
    },
    {
        "id": "call_012",
        "scenario": "Frustrated customer - frequent calls",
        "agent_name": "Anbarasan",
        "customer_name": "Mr Menon",
        "customer_voice_idx": 0,
        "outcome": "de_escalated",
        "segments": [
            ("agent", [("tamil", "வணக்கம் சார்"), ("english", "This is LIC calling about")]),
            ("customer", [("english", "Again you called yesterday also")]),
            ("agent", [("english", "Sorry sir"), ("tamil", "உங்க கவலை புரியுது")]),
            ("customer", [("english", "I already paid why are you calling")]),
            ("agent", [("english", "Let me check"), ("tamil", "ஆமா பேமெண்ட் வந்துடுச்சு"), ("english", "I will update the system")]),
            ("customer", [("english", "Please stop calling me")]),
            ("agent", [("english", "Absolutely sir"), ("tamil", "ரிசால்வ் என்று மார்க் பண்றேன்"), ("english", "Sorry for the inconvenience")]),
            ("customer", [("tamil", "ஓகே")]),
        ],
        "expected_entities": {"customer_mood": "frustrated", "issue": "repeated calls after payment", "resolution": "marked as resolved, calls to stop"},
        "expected_summary": "Mr Menon frustrated about repeated calls after already paying. Agent apologized, confirmed payment received, will update system to mark as resolved and stop calls. Outcome: de-escalated.",
    },
]


def synthesise_segment(text, voice, rate, wav_path):
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


def build_turn(segments, speaker, turn_index, scenario):
    turn_audio = np.array([], dtype=np.float32)
    if speaker == "agent":
        eng_voice = AGENT_ENGLISH_VOICE
        rate = 165
    else:
        eng_voice = CUSTOMER_VOICES[scenario["customer_voice_idx"]]
        rate = 155

    for seg_idx, (lang, text) in enumerate(segments):
        voice = TAMIL_VOICE if lang == "tamil" else eng_voice
        seg_path = TMP / f"seg_{scenario['id']}_{turn_index:02d}_{seg_idx:02d}.wav"
        synthesise_segment(text, voice, rate, seg_path)
        audio = bandpass(read_mono(seg_path))
        seg_path.unlink()

        if seg_idx > 0:
            turn_audio = np.concatenate([turn_audio, silence(0.08)])
        turn_audio = np.concatenate([turn_audio, audio])

    return turn_audio


def build_scenario(scenario):
    rng = np.random.default_rng(hash(scenario["id"]) % (2**32))
    TMP.mkdir(exist_ok=True)

    track = np.concatenate([ringback(2.4), silence(0.25), silence(0.45)])
    turns = []
    cursor = 2.4 + 0.25

    for i, (speaker, segments) in enumerate(scenario["segments"]):
        turn_audio = build_turn(segments, speaker, i, scenario)
        full_text = " ".join(text for _, text in segments)

        start = cursor + 0.45 if i == 0 else cursor
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
        gap = float(rng.uniform(0.35, 0.70))
        track = np.concatenate([track, silence(gap)])
        cursor += gap

    line_hiss = rng.normal(0, 0.004, len(track)).astype(np.float32)
    track = bandpass(track + line_hiss)

    wav_name = f"{scenario['id']}_{scenario['scenario'].replace(' ', '_').replace('-', '_')}.wav"
    wav_path = OUT_DIR / wav_name
    write_wav(wav_path, resample(track, SR, OUT_SR))

    labels = {
        "id": scenario["id"],
        "scenario": scenario["scenario"],
        "agent": scenario["agent_name"],
        "customer": scenario["customer_name"],
        "outcome": scenario["outcome"],
        "source": "synthetic (macOS `say`, Tamil Vani + English Tara/Rishi)",
        "sample_rate_hz": OUT_SR,
        "channels": 1,
        "duration_sec": round(len(track) / SR, 2),
        "turns": turns,
        "expected_summary": scenario["expected_summary"],
        "expected_entities": scenario["expected_entities"],
    }
    json_path = OUT_DIR / wav_name.replace(".wav", ".json")
    json_path.write_text(json.dumps(labels, indent=2))

    TMP.rmdir()
    return wav_path, labels


def build_all():
    results = []
    for scenario in SCENARIOS:
        print(f"Building {scenario['id']}: {scenario['scenario']}...")
        wav_path, labels = build_scenario(scenario)
        results.append(
            {
                "id": scenario["id"],
                "scenario": scenario["scenario"],
                "outcome": scenario["outcome"],
                "duration_sec": labels["duration_sec"],
                "wav_file": wav_path.name,
                "json_file": wav_path.name.replace(".wav", ".json"),
            }
        )
        print(f"  → {labels['duration_sec']}s, outcome: {scenario['outcome']}")

    index = {
        "total_calls": len(results),
        "total_duration_sec": sum(r["duration_sec"] for r in results),
        "calls": results,
    }
    (OUT_DIR / "index.json").write_text(json.dumps(index, indent=2))
    print(f"\nGenerated {len(results)} calls, total {index['total_duration_sec']:.1f}s")
    print(f"Index: {OUT_DIR / 'index.json'}")


if __name__ == "__main__":
    build_all()
