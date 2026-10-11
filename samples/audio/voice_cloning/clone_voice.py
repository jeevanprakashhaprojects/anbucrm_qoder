"""
Voice cloning with XTTS v2 - Generate natural Tanglish speech
Uses reference audio from user's recordings to clone their voice
"""
import os
import sys
import json
import wave
import struct
import math
from pathlib import Path

# Enable MPS fallback to CPU for unsupported operations
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

# Add venv site-packages
VENV = Path(__file__).parent / ".venv311"
sys.path.insert(0, str(VENV / "lib" / "python3.11" / "site-packages"))

from TTS.api import TTS
import torch
import torchaudio

BASE_DIR = Path(__file__).parent
RECORDINGS_DIR = BASE_DIR / "recordings"
OUTPUT_DIR = BASE_DIR / "output"
OUTPUT_DIR.mkdir(exist_ok=True)

# Load the Tanglish scenarios from the batch file
SCENARIOS_FILE = Path(__file__).parent.parent / "build_tanglish_batch.py"

def get_device():
    # Force CPU - MPS doesn't support XTTS's large conv1d operations
    return "cpu"

def load_reference_audio(recording_ids=[2, 4, 6], max_duration=30.0):
    """Combine segments from multiple recordings for reference."""
    all_audio = []
    sample_rate = 22050  # XTTS expects 22050 Hz
    
    for rec_id in recording_ids:
        path = RECORDINGS_DIR / f"recording_{rec_id}.wav"
        if not path.exists():
            continue
        
        waveform, sr = torchaudio.load(str(path))
        
        # Resample to 22050 Hz if needed
        if sr != sample_rate:
            resampler = torchaudio.transforms.Resample(sr, sample_rate)
            waveform = resampler(waveform)
        
        # Convert to mono
        if waveform.shape[0] > 1:
            waveform = waveform.mean(dim=0, keepdim=True)
        
        all_audio.append(waveform)
    
    # Concatenate all audio
    combined = torch.cat(all_audio, dim=1)
    
    # Trim to max_duration
    max_samples = int(max_duration * sample_rate)
    if combined.shape[1] > max_samples:
        combined = combined[:, :max_samples]
    
    return combined, sample_rate

def apply_telephone_filter(waveform, sample_rate):
    """Apply telephone band-pass filter (300-3400 Hz)."""
    # High-pass at 300 Hz
    highpass = torchaudio.functional.highpass_biquad(waveform, sample_rate, cutoff_freq=300, Q=0.707)
    # Low-pass at 3400 Hz
    lowpass = torchaudio.functional.lowpass_biquad(highpass, sample_rate, cutoff_freq=3400, Q=0.707)
    return lowpass

def normalize_audio(waveform, target_peak=0.7):
    """Normalize to target peak amplitude."""
    peak = waveform.abs().max()
    if peak > 0:
        waveform = waveform * (target_peak / peak)
    return waveform

def save_wav(waveform, sample_rate, path):
    """Save waveform as 16-bit PCM WAV."""
    waveform = waveform.squeeze()
    audio_int16 = (waveform * 32767).to(torch.int16)
    torchaudio.save(str(path), audio_int16.unsqueeze(0).cpu(), sample_rate, encoding="PCM_S", bits_per_sample=16)

def generate_call_audio(tts, speaker_wav, speaker_lang, segments, agent_name, customer_name, output_path):
    """Generate a full call with multiple turns."""
    all_audio = []
    sample_rate = 24000  # XTTS outputs at 24000 Hz
    
    for i, (speaker, lang_text_pairs) in enumerate(segments):
        # Combine all text for this turn
        text = " ".join([text for lang, text in lang_text_pairs])
        
        # Replace names for natural speech
        text = text.replace("{agent}", agent_name)
        text = text.replace("{customer}", customer_name)
        
        print(f"  Generating turn {i+1}/{len(segments)}: {speaker} - {text[:50]}...")
        
        # Generate speech
        audio = tts.tts(
            text=text,
            speaker_wav=str(speaker_wav),
            language=speaker_lang
        )
        
        # Convert to tensor
        audio_tensor = torch.tensor(audio).unsqueeze(0)
        all_audio.append(audio_tensor)
        
        # Add small gap between turns
        gap = torch.zeros(1, int(0.3 * sample_rate))
        all_audio.append(gap)
    
    # Concatenate all audio
    full_audio = torch.cat(all_audio, dim=1)
    
    # Apply telephone filter
    full_audio = apply_telephone_filter(full_audio, sample_rate)
    
    # Normalize
    full_audio = normalize_audio(full_audio, target_peak=0.7)
    
    # Save
    save_wav(full_audio, sample_rate, output_path)
    
    duration = full_audio.shape[1] / sample_rate
    print(f"  Saved: {output_path.name} ({duration:.1f}s)")
    return duration

def accept_license(*args, **kwargs):
    """Auto-accept CPML license."""
    return True

def main():
    print("=" * 60)
    print("XTTS v2 Voice Cloning for Tanglish Speech")
    print("=" * 60)
    
    # Get device
    device = get_device()
    print(f"\nUsing device: {device}")
    
    # Initialize XTTS v2
    print("\nLoading XTTS v2 model (first time will download ~2GB)...")
    
    # Monkey-patch the license check
    from TTS.utils.manage import ModelManager
    ModelManager.ask_tos = accept_license
    
    tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2").to(device)
    print("Model loaded!")
    
    # Prepare reference audio
    print("\nPreparing reference audio from recordings...")
    ref_audio_path = RECORDINGS_DIR / "reference_combined.wav"
    
    if not ref_audio_path.exists():
        # Combine recordings 2, 4, 6 (good speech content)
        ref_audio, sr = load_reference_audio(recording_ids=[2, 4, 6], max_duration=30.0)
        save_wav(ref_audio, sr, ref_audio_path)
        print(f"Created reference audio: {ref_audio_path.name} ({ref_audio.shape[1]/sr:.1f}s)")
    else:
        print(f"Using existing reference: {ref_audio_path.name}")
    
    # Load scenarios from the batch file
    print("\nLoading Tanglish scenarios...")
    # Import scenarios from build_tanglish_batch.py
    sys.path.insert(0, str(Path(__file__).parent.parent))
    from build_tanglish_batch import SCENARIOS
    
    print(f"Found {len(SCENARIOS)} scenarios")
    
    # Generate audio for each scenario
    print("\n" + "=" * 60)
    print("Generating Tanglish call audio with cloned voice")
    print("=" * 60)
    
    total_duration = 0
    for scenario in SCENARIOS:
        call_id = scenario["id"]
        scenario_name = scenario["scenario"]
        agent_name = scenario["agent_name"]
        customer_name = scenario["customer_name"]
        segments = scenario["segments"]
        
        print(f"\n[{call_id}] {scenario_name}")
        print(f"  Agent: {agent_name}, Customer: {customer_name}")
        
        output_path = OUTPUT_DIR / f"{call_id}_natural.wav"
        
        # Use English as the base language (XTTS will handle code-switching)
        duration = generate_call_audio(
            tts, 
            ref_audio_path, 
            "en",  # Base language
            segments, 
            agent_name, 
            customer_name, 
            output_path
        )
        
        total_duration += duration
    
    print("\n" + "=" * 60)
    print(f"Generation complete! Total duration: {total_duration:.1f}s ({total_duration/60:.1f} min)")
    print(f"Output directory: {OUTPUT_DIR}")
    print("=" * 60)

if __name__ == "__main__":
    main()
