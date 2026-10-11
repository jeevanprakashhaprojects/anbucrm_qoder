#!/bin/bash
# Download open Tamil speech datasets (verified working URLs)
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/Insurance/Datasets"
mkdir -p "$OUT_DIR"

echo "=== Downloading Open Tamil Speech Datasets ==="
echo "Started: $(date)"

# 1. OpenSLR SLR65 — Tamil Multi-Speaker Speech (~4284 utterances)
echo ""
echo "[1/4] OpenSLR SLR65 - Tamil Multi-Speaker"
SLR65="$OUT_DIR/slr65_tamil"
mkdir -p "$SLR65"

for url in "https://www.openslr.org/resources/65/ta_in_female.zip" "https://www.openslr.org/resources/65/ta_in_male.zip"; do
  fname=$(basename "$url")
  if [ ! -f "$SLR65/$fname" ]; then
    echo "  Downloading $fname..."
    curl -L -o "$SLR65/$fname" "$url" --connect-timeout 30 --max-time 300 2>&1 | tail -1
  fi
  if [ -f "$SLR65/$fname" ] && file "$SLR65/$fname" | grep -q "Zip"; then
    echo "  Extracting $fname..."
    unzip -o "$SLR65/$fname" -d "$SLR65/" 2>/dev/null | tail -3
  fi
done

# Convert to WAV 16kHz mono
find "$SLR65" -type f \( -name "*.flac" -o -name "*.wav" -o -name "*.mp3" \) | while read f; do
  ext="${f##*.}"
  if [ "$ext" != "wav" ] || [ "$(ffprobe -v quiet -show_entries stream=sample_rate -of csv=p=0 "$f" 2>/dev/null)" != "16000" ]; then
    base=$(basename "$f" | sed 's/\.[^.]*$/.wav/')
    wav="$SLR65/wav_16k/$base"
    mkdir -p "$SLR65/wav_16k"
    if [ ! -f "$wav" ]; then
      ffmpeg -i "$f" -ar 16000 -ac 1 -f wav -y "$wav" 2>/dev/null
    fi
  fi
done
echo "  SLR65 WAV count: $(find "$SLR65/wav_16k" -name "*.wav" 2>/dev/null | wc -l)"

# 2. OpenSLR SLR127 — IISc-MILE Tamil ASR (~150 hours)
echo ""
echo "[2/4] OpenSLR SLR127 - IISc-MILE Tamil ASR (~150hrs)"
SLR127="$OUT_DIR/slr127_mile"
mkdir -p "$SLR127"

if [ ! -f "$SLR127/mile_tamil_asr_corpus.tar.gz" ]; then
  echo "  Downloading (~large file)..."
  curl -L -o "$SLR127/mile_tamil_asr_corpus.tar.gz" \
    "https://www.openslr.org/resources/127/mile_tamil_asr_corpus.tar.gz" \
    --connect-timeout 60 --max-time 3600 2>&1 | tail -3
fi

if [ -f "$SLR127/mile_tamil_asr_corpus.tar.gz" ] && file "$SLR127/mile_tamil_asr_corpus.tar.gz" | grep -q "gzip"; then
  echo "  Extracting..."
  tar xzf "$SLR127/mile_tamil_asr_corpus.tar.gz" -C "$SLR127/" 2>/dev/null
  # Convert to WAV 16kHz mono
  find "$SLR127" -type f \( -name "*.flac" -o -name "*.wav" -o -name "*.mp3" -o -name "*.sph" \) ! -path "*/wav_16k/*" | head -5000 | while read f; do
    base=$(basename "$f" | sed 's/\.[^.]*$/.wav/')
    wav="$SLR127/wav_16k/$base"
    mkdir -p "$SLR127/wav_16k"
    if [ ! -f "$wav" ]; then
      ffmpeg -i "$f" -ar 16000 -ac 1 -f wav -y "$wav" 2>/dev/null
    fi
  done
fi
echo "  SLR127 WAV count: $(find "$SLR127/wav_16k" -name "*.wav" 2>/dev/null | wc -l)"

# 3. AI4Bharat IndicVoices — Massive Tamil speech
echo ""
echo "[3/4] AI4Bharat IndicVoices - Tamil"
IV="$OUT_DIR/indicvoices_ta"
mkdir -p "$IV"

# Download v1 (largest version)
if [ ! -f "$IV/v1_Tamil_train.tgz" ]; then
  echo "  Downloading v1_Tamil_train.tgz (large)..."
  curl -L -o "$IV/v1_Tamil_train.tgz" \
    "https://iv-release.objectstore.e2enetworks.net/dmu_release/v1_Tamil_train.tgz" \
    --connect-timeout 60 --max-time 7200 2>&1 | tail -3
fi

if [ -f "$IV/v1_Tamil_train.tgz" ] && file "$IV/v1_Tamil_train.tgz" | grep -q "gzip"; then
  echo "  Extracting v1..."
  tar xzf "$IV/v1_Tamil_train.tgz" -C "$IV/" 2>/dev/null
  # Find and convert audio
  find "$IV" -type f \( -name "*.flac" -o -name "*.wav" -o -name "*.mp3" -o -name "*.ogg" \) ! -path "*/wav_16k/*" | head -10000 | while read f; do
    base=$(basename "$f" | sed 's/\.[^.]*$/.wav/')
    wav="$IV/wav_16k/$base"
    mkdir -p "$IV/wav_16k"
    if [ ! -f "$wav" ]; then
      ffmpeg -i "$f" -ar 16000 -ac 1 -f wav -y "$wav" 2>/dev/null
    fi
  done
fi
echo "  IndicVoices WAV count: $(find "$IV/wav_16k" -name "*.wav" 2>/dev/null | wc -l)"

# 4. Microsoft Indian Languages Speech Corpus
echo ""
echo "[4/4] Microsoft Indian Languages Speech Corpus"
MS="$OUT_DIR/ms_indian"
mkdir -p "$MS"

if [ ! -f "$MS/microsoftspeechcorpusindianlanguages.zip" ]; then
  echo "  Downloading..."
  curl -L -o "$MS/microsoftspeechcorpusindianlanguages.zip" \
    "https://download.microsoft.com/download/c/9/d/c9d113a8-3c34-4805-a4df-2f11c57ac2cd/microsoftspeechcorpusindianlanguages.zip" \
    --connect-timeout 60 --max-time 1800 2>&1 | tail -3
fi

if [ -f "$MS/microsoftspeechcorpusindianlanguages.zip" ] && file "$MS/microsoftspeechcorpusindianlanguages.zip" | grep -q "Zip"; then
  echo "  Extracting..."
  unzip -o "$MS/microsoftspeechcorpusindianlanguages.zip" -d "$MS/" 2>/dev/null | tail -3
  # Find Tamil audio and convert
  find "$MS" -ipath "*tamil*" -type f \( -name "*.wav" -o -name "*.flac" -o -name "*.mp3" \) ! -path "*/wav_16k/*" | while read f; do
    base=$(basename "$f" | sed 's/\.[^.]*$/.wav/')
    wav="$MS/wav_16k/$base"
    mkdir -p "$MS/wav_16k"
    if [ ! -f "$wav" ]; then
      ffmpeg -i "$f" -ar 16000 -ac 1 -f wav -y "$wav" 2>/dev/null
    fi
  done
fi
echo "  Microsoft WAV count: $(find "$MS/wav_16k" -name "*.wav" 2>/dev/null | wc -l)"

# Final summary
echo ""
echo "=============================================="
echo "Open Dataset Downloads Complete"
echo "=============================================="
total=$(find "$OUT_DIR" -name "*.wav" 2>/dev/null | wc -l)
echo "Total WAV files from datasets: $total"
du -sh "$OUT_DIR"
echo "Completed: $(date)"
