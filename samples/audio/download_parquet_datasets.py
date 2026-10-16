#!/usr/bin/env python3
"""
Download Tamil audio from Parquet-format HuggingFace datasets.
Extracts embedded audio from Parquet files and saves as WAV.
"""
import os, sys, time, traceback
import numpy as np
import soundfile as sf
from huggingface_hub import hf_hub_download

BASE = "/Volumes/HDD_2TB/Recordings/Audio"

def save_audio_from_parquet(audio_data, output_path, target_sr=16000):
    """Save audio from Parquet audio column to WAV."""
    if isinstance(audio_data, dict):
        array = np.array(audio_data.get('array', audio_data.get('bytes', [])))
        sr = audio_data.get('sampling_rate', target_sr)
    elif isinstance(audio_data, bytes):
        # Raw bytes - write to temp file and convert
        import tempfile, subprocess
        with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp:
            tmp.write(audio_data)
            tmp_path = tmp.name
        try:
            subprocess.run(['ffmpeg', '-y', '-i', tmp_path, '-ar', str(target_sr), '-ac', '1', output_path],
                          capture_output=True, timeout=30)
            os.unlink(tmp_path)
            return os.path.exists(output_path) and os.path.getsize(output_path) > 1000
        except:
            os.unlink(tmp_path)
            return False
    else:
        return False

    if len(array) == 0:
        return False

    # Resample if needed
    if sr != target_sr:
        duration = len(array) / sr
        target_len = int(duration * target_sr)
        indices = np.linspace(0, len(array) - 1, target_len)
        array = np.interp(indices, np.arange(len(array)), array.astype(np.float32))

    # Convert to mono
    if len(array.shape) > 1:
        array = array.mean(axis=1)

    # Normalize to int16
    if array.dtype in (np.float32, np.float64):
        array = np.clip(array, -1.0, 1.0)
        array = (array * 32767).astype(np.int16)
    elif array.dtype != np.int16:
        array = array.astype(np.int16)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    sf.write(output_path, array, target_sr)
    return True

def download_parquet_dataset(repo_id, category, parquet_files, max_files=100000):
    """Download Parquet files and extract audio."""
    import pyarrow.parquet as pq

    target_dir = os.path.join(BASE, category, "HF_" + repo_id.replace("/", "_"))
    os.makedirs(target_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"Parquet Dataset: {repo_id} -> {category}")
    print(f"Files: {len(parquet_files)} parquets, target: {target_dir}")
    sys.stdout.flush()

    total_saved = 0

    for pq_file in parquet_files[:max_files]:
        print(f"\n  Downloading: {pq_file}")
        sys.stdout.flush()

        try:
            local_path = hf_hub_download(
                repo_id=repo_id,
                filename=pq_file,
                repo_type="dataset",
                local_dir=target_dir,
            )

            # Read Parquet file
            table = pq.read_table(local_path)
            df = table.to_pandas()

            # Find audio column
            audio_col = None
            for col in df.columns:
                if 'audio' in col.lower() or 'speech' in col.lower() or 'path' in col.lower():
                    audio_col = col
                    break

            if audio_col is None:
                print(f"    No audio column found. Columns: {list(df.columns)}")
                continue

            print(f"    Audio column: {audio_col}, rows: {len(df)}")
            saved = 0

            for idx, row in df.iterrows():
                audio_data = row[audio_col]
                output_path = os.path.join(target_dir, f"{os.path.basename(pq_file).replace('.parquet','')}_{idx:06d}.wav")

                if os.path.exists(output_path):
                    saved += 1
                    continue

                if save_audio_from_parquet(audio_data, output_path):
                    saved += 1

                if saved % 500 == 0 and saved > 0:
                    print(f"    Saved {saved} WAV...")
                    sys.stdout.flush()

            total_saved += saved
            print(f"    -> {saved} WAV from this parquet")
            sys.stdout.flush()

        except Exception as e:
            print(f"    ERROR: {e}")
            if "401" in str(e) or "403" in str(e) or "gated" in str(e).lower():
                print(f"    Access denied, stopping this dataset")
                break

    print(f"\n  TOTAL from {repo_id}: {total_saved} WAV files")
    return total_saved

def download_parambharat_archives():
    """Download parambharat/tamil_asr_corpus archives directly."""
    cat = "1_Casual_Conversation"
    target_dir = os.path.join(BASE, cat, "parambharat_tamil_asr")
    os.makedirs(target_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"parambharat/tamil_asr_corpus -> {cat}")
    print(f"{'='*60}")
    sys.stdout.flush()

    import subprocess, tarfile

    archives = ['data/train.tar.gz', 'data/test.tar.gz']
    total = 0

    for archive_name in archives:
        print(f"  Downloading {archive_name}...")
        sys.stdout.flush()

        try:
            local_path = hf_hub_download(
                repo_id='parambharat/tamil_asr_corpus',
                filename=archive_name,
                repo_type="dataset",
                local_dir=target_dir,
            )

            print(f"  Extracting {archive_name}...")
            with tarfile.open(local_path, 'r:gz') as tar:
                tar.extractall(target_dir)

            # Count WAV files
            wav_count = 0
            for root, dirs, fnames in os.walk(target_dir):
                wav_count += sum(1 for fn in fnames if fn.lower().endswith('.wav'))
            print(f"  Extracted: {wav_count} files")
            total += wav_count

        except Exception as e:
            print(f"  ERROR: {e}")

    print(f"  TOTAL parambharat: {total} files")
    return total

if __name__ == "__main__":
    start = time.time()
    total = 0

    # 1. Shrutilipi Tamil (68 parquets - biggest dataset)
    from huggingface_hub import HfApi
    api = HfApi()
    files = api.list_repo_files('ai4bharat/Shrutilipi', repo_type='dataset')
    tamil_parquets = sorted([f for f in files if 'tamil' in f.lower() and f.endswith('.parquet')])
    print(f"Shrutilipi: {len(tamil_parquets)} Tamil parquet files found")

    try:
        count = download_parquet_dataset('ai4bharat/Shrutilipi', '1_Casual_Conversation', tamil_parquets)
        total += count
    except Exception as e:
        print(f"Shrutilipi FAILED: {e}")
        traceback.print_exc()

    # 2. TamilVoiceCorpus (79 parquets)
    files2 = api.list_repo_files('ragunath-ravi/TamilVoiceCorpus', repo_type='dataset')
    tv_parquets = sorted([f for f in files2 if f.endswith('.parquet')])
    print(f"\nTamilVoiceCorpus: {len(tv_parquets)} parquet files found")

    try:
        count = download_parquet_dataset('ragunath-ravi/TamilVoiceCorpus', '1_Casual_Conversation', tv_parquets)
        total += count
    except Exception as e:
        print(f"TamilVoiceCorpus FAILED: {e}")
        traceback.print_exc()

    # 3. parambharat archives
    try:
        count = download_parambharat_archives()
        total += count
    except Exception as e:
        print(f"parambharat FAILED: {e}")

    elapsed = time.time() - start
    print(f"\n{'='*60}")
    print(f"PARQUET DOWNLOAD COMPLETE: {total} files in {elapsed/60:.1f} min")
    print(f"{'='*60}")
