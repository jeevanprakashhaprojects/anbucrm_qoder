#!/bin/bash
# Download Tamil speech datasets from Hugging Face and other open sources
# Focus on conversation/speech data for ASR training

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService/Datasets"
mkdir -p "$OUT_DIR"

echo "=== Downloading Tamil Speech Datasets from Open Sources ==="
echo "Started: $(date)"

# 1. AI4Bharat Shrivox Tamil (direct download)
echo ""
echo "[1] AI4Bharat - Shrivox Tamil"
SHRI="$OUT_DIR/ai4bharat_shrivox"
mkdir -p "$SHRI"
if [ ! -f "$SHRI/downloaded" ]; then
  # Try Hugging Face API for AI4Bharat datasets
  for url in \
    "https://datasets.ai4bharat.org/shrivox/ta/shrivox_ta_001.zip" \
    "https://datasets.ai4bharat.org/shrivox/ta/shrivox_ta_002.zip"; do
    fname=$(basename "$url")
    echo "  Trying $fname..."
    curl -L -o "$SHRI/$fname" "$url" --connect-timeout 15 --max-time 120 2>&1 | tail -1
    if [ -f "$SHRI/$fname" ] && file "$SHRI/$fname" | grep -q "Zip"; then
      echo "  Extracting..."
      unzip -o "$SHRI/$fname" -d "$SHRI/" 2>/dev/null | tail -2
    else
      rm -f "$SHRI/$fname"
    fi
  done
fi
echo "  Files: $(find "$SHRI" -type f \( -name "*.wav" -o -name "*.flac" -o -name "*.mp3" \) 2>/dev/null | wc -l)"

# 2. Mozilla Common Voice Tamil (try direct file access)
echo ""
echo "[2] Common Voice Tamil clips"
CV="$OUT_DIR/common_voice_ta"
mkdir -p "$CV"
# Common Voice clips are available via Hugging Face
if [ ! -f "$CV/downloaded" ]; then
  echo "  Trying Hugging Face datasets API..."
  # Try to clone just the clips
  python3 -c "
import urllib.request, json, os, sys

# Try to download Common Voice Tamil via HF API
base = 'https://huggingface.co/datasets/mozilla-foundation/common_voice_11_0/resolve/ta'
# Try the clips archive
urls = [
    'https://huggingface.co/datasets/mozilla-foundation/common_voice_11_0/resolve/main/ta_clips_0000.tar.gz',
    'https://huggingface.co/datasets/mozilla-foundation/common_voice_11_0/resolve/main/clips/ta_clips_0000.tar.gz',
]
for url in urls:
    try:
        print(f'  Trying {url}...')
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        resp = urllib.request.urlopen(req, timeout=10)
        print(f'  Status: {resp.status}')
    except Exception as e:
        print(f'  Failed: {e}')
" 2>&1
fi

# 3. Try downloading from Internet Archive - Tamil speech collections
echo ""
echo "[3] Internet Archive - Tamil audio"
IA="$OUT_DIR/internet_archive"
mkdir -p "$IA"

# Known Internet Archive Tamil audio collections
for ia_id in \
  "tamil-audio-books" \
  "tamil-speech-dataset" \
  "tamil-conversation-corpus"; do
  echo "  Checking $ia_id..."
  # Try to get file list from IA API
  response=$(curl -s "https://archive.org/metadata/${ia_id}" --connect-timeout 10 2>/dev/null)
  if echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('files',[])))" 2>/dev/null | grep -v "^0$" > /dev/null 2>&1; then
    echo "  Found collection: $ia_id"
    # Get audio files
    echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for f in d.get('files', []):
    name = f.get('name', '')
    if name.endswith(('.mp3', '.wav', '.flac', '.ogg')):
        src = f.get('source', 'original')
        print(f'https://archive.org/download/${ia_id}/{name}')
" 2>/dev/null | head -50 > "$IA/${ia_id}_urls.txt"

    count=$(wc -l < "$IA/${ia_id}_urls.txt" 2>/dev/null | tr -d ' ')
    if [ "$count" -gt 0 ]; then
      echo "  Found $count audio files, downloading..."
      while read url; do
        fname=$(basename "$url")
        if [ ! -f "$IA/$fname" ]; then
          curl -L -o "$IA/$fname" "$url" --connect-timeout 10 --max-time 60 2>/dev/null
        fi
      done < "$IA/${ia_id}_urls.txt"
    fi
  fi
done

# 4. Try Kathbath Tamil dataset (OpenSLR)
echo ""
echo "[4] Kathbath Tamil"
KATH="$OUT_DIR/kathbath_ta"
mkdir -p "$KATH"
if [ ! -f "$KATH/downloaded" ]; then
  echo "  Downloading from OpenSLR..."
  curl -L -o "$KATH/kathbath_ta.tar.gz" \
    "https://www.openslr.org/resources/135/kathbath_ta.tar.gz" \
    --connect-timeout 15 --max-time 300 2>&1 | tail -1
  if [ -f "$KATH/kathbath_ta.tar.gz" ] && file "$KATH/kathbath_ta.tar.gz" | grep -q "gzip"; then
    echo "  Extracting..."
    tar xzf "$KATH/kathbath_ta.tar.gz" -C "$KATH/" 2>/dev/null
    touch "$KATH/downloaded"
  fi
fi
echo "  Files: $(find "$KATH" -type f \( -name "*.wav" -o -name "*.flac" -o -name "*.mp3" \) 2>/dev/null | wc -l)"

# 5. Convert all audio to WAV 16kHz mono
echo ""
echo "[5] Converting all audio to WAV 16kHz mono..."
find "$OUT_DIR" -type f \( -name "*.flac" -o -name "*.mp3" -o -name "*.ogg" \) | while read f; do
  base=$(basename "$f" | sed 's/\.[^.]*$/.wav/')
  dir=$(dirname "$f")
  wav="$dir/$base"
  if [ ! -f "$wav" ]; then
    ffmpeg -y -i "$f" -ar 16000 -ac 1 "$wav" 2>/dev/null
  fi
done

# 6. Count everything
echo ""
echo "=== Results ==="
total=$(find "$OUT_DIR" -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')
echo "Total WAV files in Datasets: $total"
echo "Completed: $(date)"
