#!/usr/bin/env python3
"""
Comprehensive Tamil audio downloader - hits ALL known free sources.
Downloads to 6 categories on HDD_2TB.
"""
import os, sys, time, subprocess, shutil, tarfile, zipfile, glob, traceback
from urllib.request import urlretrieve
from huggingface_hub import HfApi, hf_hub_download

BASE = "/Volumes/HDD_2TB/Recordings/Audio"
api = HfApi()
audio_exts = {'.wav', '.flac', '.mp3', '.ogg', '.opus', '.m4a', '.wma', '.aac', '.webm'}

def ensure_dir(path):
    os.makedirs(path, exist_ok=True)
    return path

def count_wavs(directory):
    count = 0
    for root, dirs, files in os.walk(directory):
        count += sum(1 for f in files if f.lower().endswith('.wav'))
    return count

def convert_to_wav(src_path, dst_dir, basename=None):
    """Convert any audio file to 16kHz mono WAV using ffmpeg."""
    if not basename:
        basename = os.path.splitext(os.path.basename(src_path))[0]
    dst = os.path.join(dst_dir, f"{basename}.wav")
    if os.path.exists(dst):
        return dst
    try:
        subprocess.run([
            'ffmpeg', '-y', '-i', src_path,
            '-ar', '16000', '-ac', '1', '-sample_fmt', 's16',
            dst
        ], capture_output=True, timeout=60)
        if os.path.exists(dst) and os.path.getsize(dst) > 1000:
            return dst
    except:
        pass
    return None

def download_url(url, dest):
    """Download a URL to dest file."""
    if os.path.exists(dest):
        return dest
    try:
        print(f"  Downloading: {url[:100]}...")
        sys.stdout.flush()
        urlretrieve(url, dest)
        return dest
    except Exception as e:
        print(f"  FAILED: {e}")
        return None

def extract_archive(path, dest_dir):
    """Extract tar/zip archive."""
    try:
        if path.endswith('.tar.gz') or path.endswith('.tgz'):
            with tarfile.open(path, 'r:gz') as t:
                t.extractall(dest_dir)
        elif path.endswith('.zip'):
            with zipfile.ZipFile(path, 'r') as z:
                z.extractall(dest_dir)
        elif path.endswith('.tar'):
            with tarfile.open(path, 'r') as t:
                t.extractall(dest_dir)
        return True
    except Exception as e:
        print(f"  Extract failed: {e}")
        return False

def collect_wavs(directory, target_dir, prefix=""):
    """Find all audio files in directory and convert to WAV in target."""
    count = 0
    for root, dirs, files in os.walk(directory):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in audio_exts:
                src = os.path.join(root, f)
                if ext == '.wav' and os.path.getsize(src) > 1000:
                    # Already WAV, just copy if not already there
                    name = prefix + os.path.splitext(f)[0]
                    dst = os.path.join(target_dir, f"{name}.wav")
                    if not os.path.exists(dst):
                        try:
                            shutil.copy2(src, dst)
                            count += 1
                        except:
                            pass
                else:
                    name = prefix + os.path.splitext(f)[0]
                    result = convert_to_wav(src, target_dir, name)
                    if result:
                        count += 1
                if count % 500 == 0 and count > 0:
                    print(f"    Converted {count} files so far...")
                    sys.stdout.flush()
    return count

# ============================================================
# SOURCE 1: OpenSLR 65 - Tamil crowdsourced speech
# ============================================================
def download_openslr65():
    cat = "1_Casual_Conversation"
    target = ensure_dir(os.path.join(BASE, cat, "OpenSLR65"))
    print(f"\n{'='*60}\nOpenSLR 65: Tamil crowdsourced speech -> {cat}\n{'='*60}")
    sys.stdout.flush()

    url = "https://www.openslr.org/resources/65/tamil_independent_16khz.tar.gz"
    archive = "/tmp/slr65_tamil.tar.gz"
    if download_url(url, archive):
        extract_archive(archive, target)
        count = collect_wavs(target, target, "slr65_")
        print(f"  OpenSLR65: {count} WAV files")
    return count_wavs(target)

# ============================================================
# SOURCE 2: OpenSLR 127 - IISc-MILE Tamil ASR (150 hours)
# ============================================================
def download_openslr127():
    cat = "1_Casual_Conversation"
    target = ensure_dir(os.path.join(BASE, cat, "OpenSLR127"))
    print(f"\n{'='*60}\nOpenSLR 127: IISc-MILE Tamil ASR (150hrs) -> {cat}\n{'='*60}")
    sys.stdout.flush()

    urls = [
        "https://www.openslr.org/resources/127/train_clean_100.tar.gz",
        "https://www.openslr.org/resources/127/train_clean_300.tar.gz",
        "https://www.openslr.org/resources/127/dev.tar.gz",
        "https://www.openslr.org/resources/127/test.tar.gz",
    ]
    total = 0
    for url in urls:
        fname = url.split('/')[-1]
        archive = f"/tmp/{fname}"
        if download_url(url, archive):
            extract_archive(archive, target)
    total = collect_wavs(target, target, "slr127_")
    print(f"  OpenSLR127: {total} WAV files")
    return total

# ============================================================
# SOURCE 3: Microsoft Speech Corpus - Tamil conversational
# ============================================================
def download_microsoft_tamil():
    cat = "2_Business_Conversations"
    target = ensure_dir(os.path.join(BASE, cat, "Microsoft_Tamil"))
    print(f"\n{'='*60}\nMicrosoft Speech Corpus: Tamil conversational -> {cat}\n{'='*60}")
    sys.stdout.flush()

    url = "https://msropendata.com/datasets/44030c40-7e58-4f31-81e2-3b8b60b4574e"
    # Direct download link for Microsoft Indian Speech Corpus
    direct = "https://opendata.microsoft.com/datasets/indian-speech-corpus/tamil.zip"
    archive = "/tmp/ms_tamil.zip"
    if download_url(direct, archive):
        extract_archive(archive, target)
    count = collect_wavs(target, target, "ms_")
    print(f"  Microsoft Tamil: {count} WAV files")
    return count_wavs(target)

# ============================================================
# SOURCE 4: HuggingFace datasets (bulk)
# ============================================================
def download_hf_dataset(repo_id, category, max_files=50000):
    target = ensure_dir(os.path.join(BASE, category, "HF_" + repo_id.replace("/", "_")))
    print(f"\n  HF: {repo_id} -> {category} (max {max_files})")
    sys.stdout.flush()

    try:
        files = api.list_repo_files(repo_id, repo_type="dataset")
        audio_files = [f for f in files if any(f.lower().endswith(ext) for ext in audio_exts)]
        if not audio_files:
            # Check for tar/zip archives containing audio
            archives = [f for f in files if any(f.lower().endswith(ext) for ext in ['.tar.gz', '.tgz', '.zip', '.tar'])]
            if archives:
                print(f"    Found {len(archives)} archives, downloading...")
                for af in archives[:20]:
                    try:
                        local = hf_hub_download(repo_id=repo_id, filename=af, repo_type="dataset", local_dir=target)
                        extract_archive(local, target)
                    except Exception as e:
                        print(f"    Archive download failed: {e}")
            else:
                print(f"    No audio files found")
                return 0
        else:
            print(f"    Found {len(audio_files)} audio files")
            downloaded = 0
            for f in audio_files[:max_files]:
                try:
                    hf_hub_download(repo_id=repo_id, filename=f, repo_type="dataset", local_dir=target)
                    downloaded += 1
                    if downloaded % 200 == 0:
                        print(f"    Downloaded {downloaded}/{min(max_files, len(audio_files))}")
                        sys.stdout.flush()
                except Exception as e:
                    if "401" in str(e) or "403" in str(e) or "404" in str(e) or "gated" in str(e).lower():
                        print(f"    Access denied, skipping")
                        break
    except Exception as e:
        print(f"    ERROR: {e}")
        return 0

    # Convert non-WAV to WAV
    count = collect_wavs(target, target)
    print(f"    Total WAV: {count}")
    return count

# ============================================================
# SOURCE 5: Kaggle datasets (via API or direct)
# ============================================================
def download_kaggle_dataset(slug, category):
    """Download from Kaggle using kaggle CLI if available."""
    target = ensure_dir(os.path.join(BASE, category, "Kaggle_" + slug.replace("/", "_")))
    print(f"\n  Kaggle: {slug} -> {category}")
    sys.stdout.flush()

    try:
        result = subprocess.run(
            ['kaggle', 'datasets', 'download', '-d', slug, '-p', target, '--unzip'],
            capture_output=True, text=True, timeout=600
        )
        if result.returncode == 0:
            count = collect_wavs(target, target)
            print(f"    Kaggle {slug}: {count} WAV files")
            return count
        else:
            print(f"    Kaggle download failed: {result.stderr[:200]}")
    except FileNotFoundError:
        print(f"    kaggle CLI not installed, skipping")
    except Exception as e:
        print(f"    ERROR: {e}")
    return 0

# ============================================================
# SOURCE 6: Mozilla Common Voice Tamil (8.58 GB)
# ============================================================
def download_common_voice_tamil():
    cat = "4_Accent_Diversity"
    target = ensure_dir(os.path.join(BASE, cat, "CommonVoice_Tamil"))
    print(f"\n{'='*60}\nMozilla Common Voice Tamil (8.58GB) -> {cat}\n{'='*60}")
    sys.stdout.flush()

    # Try HuggingFace mirror first
    return download_hf_dataset("mozilla-foundation/common_voice_17_0", cat, 50000)

# ============================================================
# MAIN: Download everything
# ============================================================
if __name__ == "__main__":
    start = time.time()
    results = {}

    print("=" * 60)
    print("COMPREHENSIVE TAMIL AUDIO DOWNLOADER")
    print("Target: Fill HDD_2TB with 6 categories of Tamil audio")
    print("=" * 60)
    sys.stdout.flush()

    # --- HuggingFace datasets (biggest sources first) ---
    print("\n\n### PHASE 1: HuggingFace Datasets ###")
    sys.stdout.flush()

    hf_datasets = [
        # (repo_id, category, max_files)
        ("ai4bharat/Shrutilipi", "1_Casual_Conversation", 100000),  # 6400+ hours!
        ("ragunath-ravi/TamilVoiceCorpus", "1_Casual_Conversation", 50000),
        ("SPRINGLab/IndicTTS_Tamil", "4_Accent_Diversity", 10000),
        ("openslr/openslr", "1_Casual_Conversation", 100000),  # Contains SLR65, SLR127
        ("google/fleurs", "5_Domain_Vocabulary", 10000),
        ("parambharat/tamil_asr_corpus", "1_Casual_Conversation", 50000),
        ("Thanushs25/tamil-audio-emotion-classification", "6_Edge_Cases", 10000),
        ("ai4bharat/IndicVoices-R", "2_Business_Conversations", 50000),
        ("mozilla-foundation/common_voice_17_0", "4_Accent_Diversity", 50000),
    ]

    for repo_id, category, max_files in hf_datasets:
        try:
            count = download_hf_dataset(repo_id, category, max_files)
            results[repo_id] = count
        except Exception as e:
            print(f"  FAILED {repo_id}: {e}")
            traceback.print_exc()
        sys.stdout.flush()

    # --- OpenSLR direct downloads ---
    print("\n\n### PHASE 2: OpenSLR Direct Downloads ###")
    sys.stdout.flush()

    try:
        results["OpenSLR65"] = download_openslr65()
    except Exception as e:
        print(f"  OpenSLR65 failed: {e}")

    try:
        results["OpenSLR127"] = download_openslr127()
    except Exception as e:
        print(f"  OpenSLR127 failed: {e}")

    # --- Kaggle datasets ---
    print("\n\n### PHASE 3: Kaggle Datasets ###")
    sys.stdout.flush()

    kaggle_datasets = [
        ("infobayai/audio-call-center-tamil", "2_Business_Conversations"),
        ("vishwaramsundar007/indicvoices-r-tamil", "2_Business_Conversations"),
        ("hbchaitanyabharadwaj/audio-dataset-with-10-indian-languages", "1_Casual_Conversation"),
        ("pylasandeep52/common-voice-corpus-21-09-tamil", "4_Accent_Diversity"),
    ]

    for slug, category in kaggle_datasets:
        try:
            count = download_kaggle_dataset(slug, category)
            results[f"kaggle/{slug}"] = count
        except Exception as e:
            print(f"  FAILED {slug}: {e}")

    # --- Microsoft Speech Corpus ---
    print("\n\n### PHASE 4: Microsoft Speech Corpus ###")
    sys.stdout.flush()
    try:
        results["Microsoft_Tamil"] = download_microsoft_tamil()
    except Exception as e:
        print(f"  Microsoft failed: {e}")

    # --- Final Summary ---
    elapsed = time.time() - start
    print(f"\n\n{'='*60}")
    print(f"DOWNLOAD COMPLETE in {elapsed/60:.1f} minutes")
    print(f"{'='*60}")

    for source, count in results.items():
        print(f"  {source}: {count} WAV files")

    print(f"\n--- Per Category ---")
    for cat in ["1_Casual_Conversation", "2_Business_Conversations", "3_Code_Mixing_Variety",
                "4_Accent_Diversity", "5_Domain_Vocabulary", "6_Edge_Cases"]:
        wav = count_wavs(os.path.join(BASE, cat))
        print(f"  {cat}: {wav} WAV files")

    total = sum(count_wavs(os.path.join(BASE, cat)) for cat in
                ["1_Casual_Conversation", "2_Business_Conversations", "3_Code_Mixing_Variety",
                 "4_Accent_Diversity", "5_Domain_Vocabulary", "6_Edge_Cases"])
    print(f"\n  GRAND TOTAL: {total} WAV files")
    print(f"  Disk usage: {subprocess.getoutput('du -sh ' + BASE)}")
