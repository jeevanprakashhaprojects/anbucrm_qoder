#!/bin/bash
# Push conversation downloads past 500 using browser cookies + broader queries
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

# Detect browser for cookies
COOKIES_FLAG=""
if yt-dlp --cookies-from-browser safari --print title "ytsearch1:test" > /dev/null 2>&1; then
  COOKIES_FLAG="--cookies-from-browser safari"
  echo "Using Safari cookies"
elif yt-dlp --cookies-from-browser chrome --print title "ytsearch1:test" > /dev/null 2>&1; then
  COOKIES_FLAG="--cookies-from-browser chrome"
  echo "Using Chrome cookies"
elif yt-dlp --cookies-from-browser firefox --print title "ytsearch1:test" > /dev/null 2>&1; then
  COOKIES_FLAG="--cookies-from-browser firefox"
  echo "Using Firefox cookies"
else
  echo "No browser cookies available, proceeding without"
fi

# Broader queries more likely to have results
QUERIES=(
  "tamil customer care"
  "tamil customer service"
  "tamil complaint call"
  "tamil call center"
  "tamil funny phone call"
  "tamil comedy phone call"
  "tamil RJ call"
  "tamil radio call tamil"
  "tamil phone conversation"
  "tamil talking tamil"
  "tamil speech tamil"
  "tamil dialogue tamil"
  "tamil movie dialogue scene"
  "tamil comedy scene dialogue"
  "tamil dramatic scene"
  "tamil emotional scene tamil"
  "tamil interview tamil"
  "tamil podcast tamil"
  "tamil talk show tamil"
  "tamil vlog tamil"
  "tamil live tamil"
  "tamil FM tamil"
  "tamil radio tamil"
  "tamil comedy tamil audio"
  "tamil funny talk tamil"
  "tamil prank call tamil"
  "tamil hidden camera tamil"
  "tamil social experiment tamil"
  "tamil public interview tamil"
  "tamil street interview tamil"
  "tamil people opinion tamil"
  "tamil vox pop tamil"
  "tamil random questions tamil"
  "tamil quiz tamil"
  "tamil game show tamil"
  "tamil debate tamil"
  "tamil discussion tamil"
  "tamil panel discussion tamil"
  "tamil news debate tamil"
  "tamil political debate tamil"
  "tamil film review tamil"
  "tamil music review tamil"
  "tamil book review tamil"
  "tamil tech review tamil"
  "tamil unboxing tamil"
  "tamil cooking tamil conversation"
  "tamil family conversation tamil"
  "tamil kids talking tamil"
  "tamil students talking tamil"
  "tamil college discussion tamil"
  "tamil office conversation tamil"
  "tamil market conversation tamil"
  "tamil bus conversation tamil"
  "tamil train conversation tamil"
  "tamil auto conversation tamil"
  "tamil shop conversation tamil"
  "tamil hospital conversation tamil"
  "tamil bank conversation tamil"
  "tamil post office tamil"
  "tamil telephone exchange tamil"
  "tamil operator call tamil"
  "tamil helpline call tamil"
  "tamil emergency call tamil"
  "tamil police call tamil"
  "tamil ambulance call tamil"
  "tamil fire service call tamil"
  "tamil complaint resolved tamil"
  "tamil happy customer tamil"
  "tamil service feedback tamil"
  "tamil rating call tamil"
  "tamil survey call tamil"
  "tamil IVR tamil"
  "tamil automated call tamil"
  "tamil voice message tamil"
  "tamil voice note tamil"
  "tamil audio message tamil"
  "tamil recorded call tamil"
  "tamil call recording tamil"
  "tamil phone recording tamil"
  "tamil conversation recorded tamil"
  "tamil real call tamil"
  "tamil original audio tamil"
  "tamil voice tamil audio"
  "tamil spoken words tamil"
  "tamil narration tamil"
  "tamil storytelling tamil"
  "tamil kathaikal tamil"
  "tamil kadhai tamil audio"
  "tamil sirukadhai tamil"
  "tamil moral story tamil audio"
  "tamil children story tamil"
  "tamil lullaby tamil audio"
  "tamil song conversation tamil"
  "tamil duet song tamil"
  "tamil musical dialogue tamil"
  "tamil opera tamil"
  "tamil drama audio tamil"
  "tamil stage drama tamil"
  "tamil theatre tamil audio"
  "tamil play tamil audio"
)

echo "=============================================="
echo "Broad conversation download: ${#QUERIES[@]} queries"
echo "Starting files: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l)"
echo "=============================================="

for query in "${QUERIES[@]}"; do
  count=$(find "$OUT_DIR" -maxdepth 1 -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -ge 550 ]; then
    echo ""
    echo "=== TARGET REACHED: $count files ==="
    break
  fi

  echo ""
  echo "--- [$count files] $query ---"

  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads 15 \
    --min-filesize 30k \
    --max-filesize 500M \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --sleep-interval 1 \
    --max-sleep-interval 3 \
    $COOKIES_FLAG \
    --output "$OUT_DIR/cs_%(autonumber)s_%(title).50s.%(ext)s" \
    "ytsearch15:${query}" 2>&1 | tail -3
done

echo ""
echo "=============================================="
echo "FINAL: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l) conversation WAV files"
du -sh "$OUT_DIR"
echo "=============================================="
