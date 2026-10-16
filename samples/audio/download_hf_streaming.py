#!/usr/bin/env python3
"""
Download Tamil audio from HuggingFace datasets that use Parquet format.
These are the BIGGEST datasets (Shrutilipi = 6400+ hours, etc.)
Uses the `datasets` library to stream and save audio.
"""
import os, sys, time, traceback
import numpy as np

BASE = "/Volumes/HDD_2TB/Recordings/Audio"

def save_audio(audio_dict, output_path, target_sr=16000):
    """Save audio dict from datasets to WAV file."""
    import soundfile as sf
    array = audio_dict['array']
    sr = audio_dict['sampling_rate']

    # Resample if needed
    if sr != target_sr:
        try:
            import librosa
            array = librosa.resample(array.astype(np.float32), orig_sr=sr, target_sr=target_sr)
        except ImportError:
            # Simple resampling by interpolation
            duration = len(array) / sr
            target_len = int(duration * target_sr)
            indices = np.linspace(0, len(array) - 1, target_len)
            array = np.interp(indices, np.arange(len(array)), array.astype(np.float32))

    # Convert to mono if stereo
    if len(array.shape) > 1:
        array = array.mean(axis=1)

    # Normalize to int16
    if array.dtype == np.float32 or array.dtype == np.float64:
        array = (array * 32767).astype(np.int16)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    sf.write(output_path, array, target_sr)
    return True

def download_dataset_streaming(repo_id, category, split="train", max_samples=100000, audio_col="audio"):
    """Download dataset using streaming mode (no need to download entire thing)."""
    from datasets import load_dataset

    target_dir = os.path.join(BASE, category, "HF_" + repo_id.replace("/", "_"))
    os.makedirs(target_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"Dataset: {repo_id} -> {category}")
    print(f"Target: {target_dir}")
    sys.stdout.flush()

    try:
        # Try loading with specific config for Tamil
        configs_to_try = [
            {"name": "ta", "split": split},
            {"name": "tamil", "split": split},
            {"name": "Tamil", "split": split},
            {"split": split},
            {},
        ]

        ds = None
        for config in configs_to_try:
            try:
                print(f"  Trying config: {config}")
                ds = load_dataset(repo_id, streaming=True, **config)
                if ds is not None:
                    print(f"  Loaded with config: {config}")
                    break
            except Exception as e:
                continue

        if ds is None:
            print(f"  Could not load {repo_id}")
            return 0

        # Get the right split
        if isinstance(ds, dict) and split in ds:
            ds = ds[split]
        elif hasattr(ds, 'take'):
            pass  # Already an iterable dataset
        else:
            print(f"  Dataset structure: {type(ds)}, keys: {ds.keys() if hasattr(ds, 'keys') else 'N/A'}")
            if isinstance(ds, dict):
                # Use first available split
                first_key = list(ds.keys())[0]
                ds = ds[first_key]
                print(f"  Using split: {first_key}")

        saved = 0
        skipped = 0
        for i, example in enumerate(ds):
            if saved >= max_samples:
                break

            if audio_col not in example:
                # Try to find audio column
                audio_cols = [k for k in example.keys() if 'audio' in k.lower() or 'speech' in k.lower()]
                if audio_cols:
                    audio_col = audio_cols[0]
                else:
                    skipped += 1
                    continue

            audio = example[audio_col]
            if audio is None or (isinstance(audio, dict) and len(audio.get('array', [])) == 0):
                skipped += 1
                continue

            output_path = os.path.join(target_dir, f"audio_{i:06d}.wav")
            if os.path.exists(output_path):
                saved += 1
                continue

            try:
                if isinstance(audio, dict) and 'array' in audio:
                    save_audio(audio, output_path)
                    saved += 1
                elif isinstance(audio, str) and os.path.exists(audio):
                    # It's a file path
                    import shutil
                    ext = os.path.splitext(audio)[1].lower()
                    if ext == '.wav':
                        shutil.copy2(audio, output_path)
                    else:
                        import subprocess
                        subprocess.run(['ffmpeg', '-y', '-i', audio, '-ar', '16000', '-ac', '1', output_path],
                                      capture_output=True, timeout=30)
                    saved += 1
            except Exception as e:
                skipped += 1
                if skipped % 100 == 0:
                    print(f"    Skip error: {e}")

            if saved % 100 == 0 and saved > 0:
                print(f"    Saved {saved} WAV files (skipped {skipped})")
                sys.stdout.flush()

        print(f"  DONE: {saved} WAV saved, {skipped} skipped")
        return saved

    except Exception as e:
        print(f"  FAILED: {e}")
        traceback.print_exc()
        return 0

if __name__ == "__main__":
    start = time.time()
    total = 0

    # Big datasets to download
    datasets_to_download = [
        # (repo_id, category, split, max_samples, audio_column)
        ("parambharat/tamil_asr_corpus", "1_Casual_Conversation", "train", 100000, "audio"),
        ("google/fleurs", "5_Domain_Vocabulary", "train", 10000, "audio"),
        ("SPRINGLab/IndicTTS_Tamil", "4_Accent_Diversity", "train", 10000, "audio"),
        ("Thanushs25/tamil-audio-emotion-classification", "6_Edge_Cases", "train", 10000, "audio"),
        ("ai4bharat/Shrutilipi", "1_Casual_Conversation", "train", 100000, "audio"),
        ("ragunath-ravi/TamilVoiceCorpus", "1_Casual_Conversation", "train", 50000, "audio"),
        ("mozilla-foundation/common_voice_17_0", "4_Accent_Diversity", "train", 50000, "audio"),
        ("facebook/voxpopuli", "3_Code_Mixing_Variety", "train", 10000, "audio"),
        ("ai4bharat/IndicVoices-R", "2_Business_Conversations", "train", 50000, "audio"),
        ("openslr/openslr", "1_Casual_Conversation", "train", 100000, "audio"),
    ]

    for repo_id, category, split, max_samples, audio_col in datasets_to_download:
        try:
            count = download_dataset_streaming(repo_id, category, split, max_samples, audio_col)
            total += count
            print(f"  Running total: {total}")
        except Exception as e:
            print(f"  FAILED {repo_id}: {e}")
        sys.stdout.flush()

    elapsed = time.time() - start
    print(f"\n{'='*60}")
    print(f"STREAMING DOWNLOAD COMPLETE: {total} files in {elapsed/60:.1f} min")
    print(f"{'='*60}")
