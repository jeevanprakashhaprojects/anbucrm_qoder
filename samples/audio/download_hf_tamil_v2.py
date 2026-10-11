#!/usr/bin/env python3
"""Download Tamil call center, podcast, and speech datasets from Hugging Face."""

import os
import glob
import subprocess
from huggingface_hub import HfApi, snapshot_download

OUT_DIR = "/Volumes/Extreme SSD/Recordings/Audio/CustomerService/Datasets"
os.makedirs(OUT_DIR, exist_ok=True)

api = HfApi()

# Best datasets for Tamil conversations
DATASETS = [
    "InfoBayAI/Tamil_Call_Center_Audio_Dataset_Dual_Channel",
    "InfoBayAI/Tamil_Call_Center_Audio_Dataset_Single-Channel",
    "InfoBayAI/Tamil_Podcast_Audio_Dataset",
    "InfoBayAI/Tamil_Podcast_Audio_Dataset_Dual_Channel",
    "shunyalabs/tamil-speech-dataset",
    "parambharat/tamil_asr_corpus",
    "deepdml/iisc-mile-tamil-asr",
    "Patil/tamil-audios",
    "SpeechDataAI/tamil-conversational-speech",
    "eswardivi/Tamil_MSA_Audio_Text",
    "Thanushs25/tamil-audio-emotion-classification",
    "shivareddy-03/tamil-audio-dataset",
    "speech31/commonvoice_tamil_ipa",
    "DataoceanAI/Dolphin_Model_Tamil-Speech-Recognition-Corpus",
    "VishalTheHuman/tamil-dialect-speech",
    "Ajmal7979/tamil-dialect-speech",
    "Speech-data/Tamil-Speech-Dataset",
    "psdn-ai/tamil-speech-samples",
]

total_downloaded = 0

for repo_id in DATASETS:
    safe_name = repo_id.replace("/", "_")
    target_dir = os.path.join(OUT_DIR, safe_name)

    # Check if already downloaded
    existing = glob.glob(os.path.join(target_dir, "**/*.wav"), recursive=True)
    existing += glob.glob(os.path.join(target_dir, "**/*.flac"), recursive=True)
    existing += glob.glob(os.path.join(target_dir, "**/*.mp3"), recursive=True)
    if len(existing) > 10:
        print(f"[SKIP] {repo_id} - already has {len(existing)} audio files")
        total_downloaded += len(existing)
        continue

    print(f"\n{'='*60}")
    print(f"[DOWNLOAD] {repo_id}")
    print(f"{'='*60}")

    try:
        # First, list files to see what's available
        files = api.list_repo_files(repo_id, repo_type="dataset")
        audio_exts = ('.wav', '.flac', '.mp3', '.ogg', '.opus')
        audio_files = [f for f in files if any(f.lower().endswith(ext) for ext in audio_exts)]

        # Also check for archives that might contain audio
        archive_files = [f for f in files if any(f.lower().endswith(ext) for ext in ('.tar.gz', '.zip', '.tar'))]

        print(f"  Audio files: {len(audio_files)}, Archives: {len(archive_files)}")

        if len(audio_files) == 0 and len(archive_files) == 0:
            print(f"  No audio files found. Skipping.")
            continue

        # Download audio files directly
        os.makedirs(target_dir, exist_ok=True)

        downloaded = 0
        files_to_download = audio_files[:1000]  # Limit per dataset

        for i, f in enumerate(files_to_download):
            try:
                local_path = api.hf_hub_download(
                    repo_id=repo_id,
                    filename=f,
                    repo_type="dataset",
                    local_dir=target_dir,
                )
                downloaded += 1
                if downloaded % 50 == 0:
                    print(f"  Progress: {downloaded}/{len(files_to_download)} files...")
            except Exception as e:
                if i < 5:  # Only print first few errors
                    print(f"  Error downloading {f}: {str(e)[:80]}")
                continue

        # Also try downloading archives
        for f in archive_files[:5]:
            try:
                local_path = api.hf_hub_download(
                    repo_id=repo_id,
                    filename=f,
                    repo_type="dataset",
                    local_dir=target_dir,
                )
                print(f"  Downloaded archive: {f}")

                # Extract archive
                if f.endswith('.tar.gz'):
                    subprocess.run(['tar', 'xzf', os.path.join(target_dir, f), '-C', target_dir],
                                 capture_output=True, timeout=120)
                elif f.endswith('.zip'):
                    subprocess.run(['unzip', '-o', os.path.join(target_dir, f), '-d', target_dir],
                                 capture_output=True, timeout=120)
            except Exception as e:
                print(f"  Archive error: {str(e)[:80]}")

        print(f"  Downloaded {downloaded} audio files + {len(archive_files)} archives")
        total_downloaded += downloaded

    except Exception as e:
        print(f"  Failed: {str(e)[:100]}")

# Convert all audio to WAV 16kHz mono
print(f"\n{'='*60}")
print("Converting all audio to WAV 16kHz mono...")
print(f"{'='*60}")

converted = 0
for ext in ['*.flac', '*.mp3', '*.ogg', '*.opus']:
    for f in glob.glob(os.path.join(OUT_DIR, '**', ext), recursive=True):
        wav_path = f.rsplit('.', 1)[0] + '.wav'
        if not os.path.exists(wav_path):
            try:
                subprocess.run(
                    ['ffmpeg', '-y', '-i', f, '-ar', '16000', '-ac', '1', wav_path],
                    capture_output=True, timeout=60
                )
                converted += 1
            except:
                pass

print(f"Converted {converted} files to WAV")

# Final count
wav_count = len(glob.glob(os.path.join(OUT_DIR, '**', '*.wav'), recursive=True))
top_wav = len(glob.glob(os.path.join("/Volumes/Extreme SSD/Recordings/Audio/CustomerService", '*.wav')))
print(f"\n{'='*60}")
print(f"Dataset WAV files: {wav_count}")
print(f"CustomerService WAV files: {top_wav}")
print(f"Combined total: {wav_count + top_wav}")
print(f"{'='*60}")
