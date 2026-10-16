#!/usr/bin/env python3
"""Download Tamil audio datasets from HuggingFace into 6 categories on HDD."""
import os, sys, time, traceback
from huggingface_hub import HfApi, hf_hub_download

api = HfApi()

BASE = "/Volumes/HDD_2TB/Recordings/Audio"
audio_exts = {'.wav', '.flac', '.mp3', '.ogg', '.opus', '.m4a', '.wma', '.aac'}

# Datasets mapped to categories
# Format: (repo_id, category_folder, max_files)
datasets = [
    # Cat 1: Casual Conversation
    ("parambharat/tamil_asr_corpus", "1_Casual_Conversation", 50000),
    ("Thanushs25/tamil-audio-emotion-classification", "1_Casual_Conversation", 5000),

    # Cat 2: Business Conversations
    ("InfoBay/tamil_call_center_audio", "2_Business_Conversations", 10000),
    ("InfoBay/tamil_podcast_audio", "2_Business_Conversations", 10000),

    # Cat 3: Code-Mixing Variety (Tanglish)
    ("shunyalabs/tanglish-speech-dataset", "3_Code_Mixing_Variety", 10000),
    ("deepdml/tamil-english-code-mixed", "3_Code_Mixing_Variety", 10000),

    # Cat 4: Accent Diversity
    ("Patil/tamil_accent_dataset", "4_Accent_Diversity", 10000),
    ("SpeechDataAI/tamil-dialect", "4_Accent_Diversity", 10000),

    # Cat 5: Domain Vocabulary
    ("google/fleurs", "5_Domain_Vocabulary", 10000),

    # Cat 6: Edge Cases
    ("torchbox/openslr-tamil", "6_Edge_Cases", 50000),
]

def get_audio_files(repo_id):
    """List audio files in a dataset."""
    try:
        files = api.list_repo_files(repo_id, repo_type="dataset")
        audio = [f for f in files if any(f.lower().endswith(ext) for ext in audio_exts)]
        return audio
    except Exception as e:
        print(f"  ERROR listing {repo_id}: {e}")
        return []

def download_files(repo_id, category, max_files):
    """Download audio files from a dataset."""
    target_dir = os.path.join(BASE, category, "Datasets", repo_id.replace("/", "_"))
    os.makedirs(target_dir, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"Dataset: {repo_id} -> {category}")
    print(f"Target: {target_dir}")

    audio_files = get_audio_files(repo_id)
    if not audio_files:
        print(f"  No audio files found, skipping")
        return 0

    print(f"  Found {len(audio_files)} audio files, downloading up to {max_files}")

    downloaded = 0
    for i, f in enumerate(audio_files[:max_files]):
        try:
            local_path = hf_hub_download(
                repo_id=repo_id,
                filename=f,
                repo_type="dataset",
                local_dir=target_dir,
            )
            downloaded += 1
            if downloaded % 100 == 0:
                print(f"  Downloaded {downloaded}/{min(max_files, len(audio_files))} files")
                sys.stdout.flush()
        except Exception as e:
            if "401" in str(e) or "403" in str(e) or "404" in str(e):
                print(f"  Access denied or not found, skipping dataset")
                break
            if downloaded % 500 == 0:
                print(f"  Error on {f}: {e}")
    return downloaded

def search_and_download_tamil():
    """Search for Tamil audio datasets and download them."""
    print("Searching for Tamil audio datasets on HuggingFace...")
    sys.stdout.flush()

    search_terms = [
        "tamil audio", "tamil speech", "tamil asr", "tamil voice",
        "tamil dataset", "tamil transcript", "openslr tamil",
        "tamil tts", "tanglish", "tamil conversation",
        "indian speech tamil", "dravidian speech",
        "tamil language", "fleurs tamil", "common voice tamil",
        "tamil podcast", "tamil radio",
    ]

    found_repos = set()
    for term in search_terms:
        try:
            results = list(api.list_datasets(search=term, limit=20))
            for ds in results:
                name = ds.id.lower()
                if any(kw in name for kw in ['tamil', 'tanglish', 'dravidian', 'openslr']):
                    found_repos.add(ds.id)
        except Exception as e:
            print(f"  Search error for '{term}': {e}")

    print(f"Found {len(found_repos)} potentially relevant datasets")
    for r in sorted(found_repos):
        print(f"  {r}")
    sys.stdout.flush()
    return sorted(found_repos)

def convert_to_wav_if_needed(directory):
    """Count files that need conversion."""
    wav_count = 0
    other_count = 0
    for root, dirs, files in os.walk(directory):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext == '.wav':
                wav_count += 1
            elif ext in audio_exts:
                other_count += 1
    return wav_count, other_count

if __name__ == "__main__":
    start = time.time()
    total_downloaded = 0

    # Phase 1: Download known datasets
    print("=" * 60)
    print("PHASE 1: Downloading known datasets")
    print("=" * 60)
    sys.stdout.flush()

    for repo_id, category, max_files in datasets:
        try:
            count = download_files(repo_id, category, max_files)
            total_downloaded += count
            print(f"  -> {count} files downloaded")
            sys.stdout.flush()
        except Exception as e:
            print(f"  FAILED {repo_id}: {e}")
            traceback.print_exc()

    # Phase 2: Search and download additional Tamil datasets
    print("\n" + "=" * 60)
    print("PHASE 2: Searching for additional Tamil datasets")
    print("=" * 60)
    sys.stdout.flush()

    repos = search_and_download_tamil()
    known = {d[0] for d in datasets}

    for repo_id in repos:
        if repo_id in known:
            continue
        # Try to determine category based on name
        name = repo_id.lower()
        if any(kw in name for kw in ['casual', 'conversation', 'emotion', 'asr']):
            cat = "1_Casual_Conversation"
        elif any(kw in name for kw in ['call', 'business', 'podcast', 'customer']):
            cat = "2_Business_Conversations"
        elif any(kw in name for kw in ['code', 'mix', 'tanglish', 'english']):
            cat = "3_Code_Mixing_Variety"
        elif any(kw in name for kw in ['accent', 'dialect', 'region']):
            cat = "4_Accent_Diversity"
        elif any(kw in name for kw in ['domain', 'vocab', 'fleurs', 'common_voice']):
            cat = "5_Domain_Vocabulary"
        else:
            cat = "1_Casual_Conversation"  # default

        try:
            count = download_files(repo_id, cat, 5000)
            total_downloaded += count
            print(f"  -> {count} files downloaded")
            sys.stdout.flush()
        except Exception as e:
            print(f"  FAILED {repo_id}: {e}")

    elapsed = time.time() - start
    print(f"\n{'='*60}")
    print(f"DONE: {total_downloaded} files downloaded in {elapsed/60:.1f} minutes")
    print(f"{'='*60}")

    # Final counts per category
    for cat in ["1_Casual_Conversation", "2_Business_Conversations", "3_Code_Mixing_Variety",
                "4_Accent_Diversity", "5_Domain_Vocabulary", "6_Edge_Cases"]:
        wav, other = convert_to_wav_if_needed(os.path.join(BASE, cat))
        print(f"  {cat}: {wav} WAV + {other} other audio = {wav+other} total")
