#!/bin/bash
# Download Tamil conversations from alternative sources (YouTube is rate-limited)
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

echo "=============================================="
echo "Alternative source download for Tamil conversations"
echo "Current: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l) files"
echo "=============================================="

# ============================================================
# SOURCE 1: Internet Archive - Tamil audio collections
# ============================================================
echo ""
echo "=== SOURCE 1: Internet Archive ==="

IA_SEARCHES=(
  "tamil+conversation"
  "tamil+speech"
  "tamil+radio"
  "tamil+podcast"
  "tamil+dialogue"
  "tamil+interview"
  "tamil+call+recording"
  "tamil+customer+service"
  "tamil+comedy+audio"
  "tamil+drama+audio"
  "tamil+story+audio"
  "tamil+folk+tale"
  "tamil+kathaikal"
  "tamil+solvathellam"
  "tamil+news+broadcast"
)

for search in "${IA_SEARCHES[@]}"; do
  count=$(find "$OUT_DIR" -maxdepth 1 -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -ge 550 ]; then
    echo "=== TARGET REACHED: $count files ==="
    break
  fi

  echo ""
  echo "--- IA search: $search ($count files) ---"

  # Use yt-dlp which supports Internet Archive
  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads 20 \
    --min-filesize 30k \
    --max-filesize 500M \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --output "$OUT_DIR/ia_%(autonumber)s_%(title).50s.%(ext)s" \
    "https://archive.org/search?query=${search}&and[]=mediatype%3A%22audio%22" 2>&1 | tail -3
done

# ============================================================
# SOURCE 2: Try specific Internet Archive collections
# ============================================================
echo ""
echo "=== SOURCE 2: Specific IA collections ==="

IA_COLLECTIONS=(
  "https://archive.org/details/tamil_audio_songs"
  "https://archive.org/details/tamil-radio"
  "https://archive.org/details/tamilpodcast"
  "https://archive.org/details/tamil-drama"
  "https://archive.org/details/tamil-kathai"
)

for url in "${IA_COLLECTIONS[@]}"; do
  count=$(find "$OUT_DIR" -maxdepth 1 -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -ge 550 ]; then
    echo "=== TARGET REACHED: $count files ==="
    break
  fi

  echo ""
  echo "--- IA collection: $url ($count files) ---"

  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads 30 \
    --min-filesize 30k \
    --max-filesize 500M \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --output "$OUT_DIR/ia_%(autonumber)s_%(title).50s.%(ext)s" \
    "$url" 2>&1 | tail -3
done

# ============================================================
# SOURCE 3: YouTube via Invidious instances (bypasses bot detection)
# ============================================================
echo ""
echo "=== SOURCE 3: Invidious (YouTube proxy) ==="

INVIDIOUS_INSTANCES=(
  "https://invidious.snopyta.org"
  "https://vid.puffyan.us"
  "https://invidious.kavin.rocks"
  "https://inv.riverside.rocks"
  "https://invidious.weblibre.org"
)

INVIDIOUS_QUERIES=(
  "tamil+customer+care+call"
  "tamil+comedy+phone+call"
  "tamil+conversation"
  "tamil+podcast"
  "tamil+radio+show"
  "tamil+interview"
  "tamil+dialogue+scene"
  "tamil+funny+call"
  "tamil+RJ+talk"
  "tamil+speech"
)

for instance in "${INVIDIOUS_INSTANCES[@]}"; do
  for query in "${INVIDIOUS_QUERIES[@]}"; do
    count=$(find "$OUT_DIR" -maxdepth 1 -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -ge 550 ]; then
      echo "=== TARGET REACHED: $count files ==="
      break 2
    fi

    echo ""
    echo "--- Invidious: $instance / $query ($count files) ---"

    yt-dlp \
      -x \
      --audio-format wav \
      --audio-quality 0 \
      --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
      --max-downloads 10 \
      --min-filesize 30k \
      --max-filesize 500M \
      --no-playlist \
      --no-overwrites \
      --socket-timeout 15 \
      --retries 2 \
      --output "$OUT_DIR/inv_%(autonumber)s_%(title).50s.%(ext)s" \
      "${instance}/search?q=${query}" 2>&1 | tail -3
  done
done

echo ""
echo "=============================================="
echo "FINAL: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l) conversation WAV files"
du -sh "$OUT_DIR"
echo "=============================================="
