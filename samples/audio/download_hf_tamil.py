#!/usr/bin/env python3
"""Download Tamil speech datasets from Hugging Face for ASR training."""

import os
import subprocess
import glob
from pathlib import Path
from huggingface_hub import HfApi, hf_hub_download, snapshot_download

OUT_DIR = "/Volumes/Extreme SSD/Recordings/Audio/CustomerService/Datasets"
os.makedirs(OUT_DIR, exist_ok=True)

api = HfApi()

# Known Tamil speech datasets on Hugging Face
DATASETS = [
    # AI4Bharat IndicVoices - Tamil
    ("ai4bharat/indicvoices", "ta"),
    # Bryono7 Tamil TTS
    ("bryano7/tamil-tts-dataset", None),
    # Tamil speech datasets
    ("legolasTheElf/tamil_speech_dataset", None),
    ("Harveenchadha/vakyansh-tamil-tts-2250", None),
    # AI4Bharat Shrivox
    ("ai4bharat/shrivox", None),
    # Tamil conversation
    ("yash-sr/tamil-conversation", None),
    # OpenSLR Tamil
    ("openslr/librispeech_asr", None),  # fallback
]

def try_snapshot(repo_id, target_dir, allow_patterns=None):
    """Try to download a snapshot of the dataset."""
    print(f"\n  Trying snapshot_download({repo_id})...")
    try:
        path = snapshot_download(
            repo_id=repo_id,
            repo_type="dataset",
            local_dir=target_dir,
            allow_patterns=allow_patterns or ["**/*.wav", "**/*.flac", "**/*.mp3", "**/*.ogg"],
            max_workers=4,
            # Don't download the full repo if it's huge
            ignore_patterns=["*.parquet", "*.arrow", "*.json", "*.txt", "*.csv", "README*", ".git*"],
        )
        print(f"  Downloaded to: {path}")
        return True
    except Exception as e:
        print(f"  Snapshot failed: {e}")
        return False

def try_list_and_download(repo_id, target_dir):
    """List files in repo and download audio files."""
    print(f"\n  Listing files in {repo_id}...")
    try:
        files = api.list_repo_files(repo_id, repo_type="dataset")
        audio_files = [f for f in files if f.endswith(('.wav', '.flac', '.mp3', '.ogg'))]
        print(f"  Found {len(audio_files)} audio files")

        os.makedirs(target_dir, exist_ok=True)

        downloaded = 0
        for f in audio_files[:500]:  # Limit to 500 files
            try:
                local_path = hf_hub_download(
                    repo_id=repo_id,
                    filename=f,
                    repo_type="dataset",
                    local_dir=target_dir,
                )
                downloaded += 1
                if downloaded % 50 == 0:
                    print(f"  Downloaded {downloaded} files...")
            except Exception as e:
                pass

        print(f"  Downloaded {downloaded} audio files")
        return downloaded
    except Exception as e:
        print(f"  List/download failed: {e}")
        return 0

# Try each dataset
for repo_id, lang_filter in DATASETS:
    print(f"\n{'='*60}")
    print(f"Dataset: {repo_id}")
    print(f"{'='*60}")

    safe_name = repo_id.replace("/", "_")
    target_dir = os.path.join(OUT_DIR, safe_name)

    if os.path.exists(target_dir) and glob.glob(os.path.join(target_dir, "**/*.wav"), recursive=True):
        count = len(glob.glob(os.path.join(target_dir, "**/*.wav"), recursive=True))
        if count > 0:
            print(f"  Already exists with {count} WAV files. Skipping.")
            continue

    # Try snapshot first
    success = try_snapshot(repo_id, target_dir)

    if not success:
        # Try listing and downloading individual files
        try_list_and_download(repo_id, target_dir)

# Convert non-WAV to WAV 16kHz mono
print(f"\n{'='*60}")
print("Converting audio to WAV 16kHz mono...")
print(f"{'='*60}")

for ext in ['*.flac', '*.mp3', '*.ogg']:
    for f in glob.glob(os.path.join(OUT_DIR, '**', ext), recursive=True):
        wav_path = f.rsplit('.', 1)[0] + '.wav'
        if not os.path.exists(wav_path):
            subprocess.run([
                'ffmpeg', '-y', '-i', f, '-ar', '16000', '-ac', '1', wav_path
            ], capture_output=True)

# Count results
wav_count = len(glob.glob(os.path.join(OUT_DIR, '**', '*.wav'), recursive=True))
print(f"\n{'='*60}")
print(f"Total WAV files in Datasets: {wav_count}")
print(f"{'='*60}")
