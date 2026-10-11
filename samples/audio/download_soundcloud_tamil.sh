#!/bin/bash
# Download Tamil conversation audio from SoundCloud (confirmed working)
# SoundCloud is not blocked like YouTube - use it to reach 500+ files

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

echo "=============================================="
echo "SoundCloud Tamil Conversation Audio Download"
echo "Output: $OUT_DIR"
echo "=============================================="

# Count existing files
EXISTING=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo "Starting with $EXISTING WAV files"
echo "Target: 500+"
echo ""

SUCCESS=0
FAIL=0

download_sc() {
  local query="$1"
  local max="${2:-15}"

  echo ""
  echo "[SEARCH] scsearch${max}:${query}"

  yt-dlp -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads "$max" \
    --min-filesize 30k \
    --max-filesize 500M \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --sleep-interval 1 \
    --max-sleep-interval 3 \
    --output "$OUT_DIR/sc_%(autonumber)s_${query}_%(title).40s.%(ext)s" \
    "scsearch${max}:${query}" 2>&1 | tail -3

  local count=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
  echo "[STATUS] Total WAV files now: $count"

  if [ "$count" -ge 550 ]; then
    echo "[DONE] Reached $count files (target 500+). Stopping."
    exit 0
  fi
}

# === CATEGORY 1: Customer care conversations ===
download_sc "tamil customer care" 20
download_sc "tamil customer service call" 15
download_sc "tamil customer complaint" 15
download_sc "airtel customer care tamil" 10
download_sc "bsnl customer care tamil" 10
download_sc "jio customer care tamil" 10
download_sc "vi customer care tamil" 10
download_sc "tamil call center" 15
download_sc "tamil telecalling" 10

# === CATEGORY 2: Banking & finance calls ===
download_sc "tamil bank fraud call" 10
download_sc "tamil scam call" 15
download_sc "tamil banking customer" 10
download_sc "tamil loan call" 10
download_sc "tamil atm fraud" 10
download_sc "tamil sbi customer" 10
download_sc "tamil credit card call" 10

# === CATEGORY 3: Comedy & entertainment calls ===
download_sc "tamil funny phone call" 20
download_sc "tamil comedy customer care" 15
download_sc "tamil funny call" 20
download_sc "tamil prank call" 15
download_sc "tamil comedy dialogue" 15
download_sc "tamil funny conversation" 15
download_sc "rj balaji phone call" 10
download_sc "tamil comedy skit call" 10
download_sc "tamil joke call" 10

# === CATEGORY 4: Podcasts & talk shows ===
download_sc "tamil podcast" 20
download_sc "tamil podcast conversation" 15
download_sc "tamil talk show" 15
download_sc "tamil interview" 15
download_sc "tamil discussion" 15
download_sc "tamil radio show" 15
download_sc "tamil radio jockey" 10
download_sc "rj tamil" 15
download_sc "tamil fm radio" 10
download_sc "tamil podcast episode" 15

# === CATEGORY 5: General Tamil conversations ===
download_sc "tamil conversation" 20
download_sc "tamil speaking" 15
download_sc "tamil voice" 15
download_sc "tamil audio" 15
download_sc "tamil speech" 15
download_sc "tamil dialogue" 15
download_sc "tamil talk" 15
download_sc "tamil communication" 10
download_sc "tamil phone conversation" 10
download_sc "tamil voice message" 10

# === CATEGORY 6: Service interactions ===
download_sc "tamil delivery call" 10
download_sc "tamil food delivery" 10
download_sc "tamil service call" 10
download_sc "tamil complaint call" 10
download_sc "tamil support call" 10
download_sc "tamil help call" 10
download_sc "tamil utility bill" 10
download_sc "tamil electricity board" 10

# === CATEGORY 7: Government & public service ===
download_sc "tamil government service" 10
download_sc "tamil police complaint" 10
download_sc "tamil municipal complaint" 10
download_sc "tamil public service" 10
download_sc "tamil citizen complaint" 10

# === CATEGORY 8: Tech support ===
download_sc "tamil tech support" 10
download_sc "tamil technical support" 10
download_sc "tamil computer help" 10
download_sc "tamil it support" 10

# === CATEGORY 9: Insurance & LIC (cross-over) ===
download_sc "tamil insurance" 15
download_sc "tamil lic agent" 10
download_sc "tamil policy renewal" 10
download_sc "tamil life insurance" 10
download_sc "tamil health insurance" 10
download_sc "tamil claim settlement" 10

# === CATEGORY 10: More general Tamil audio ===
download_sc "tamil audio clip" 15
download_sc "tamil voice recording" 15
download_sc "tamil narration" 10
download_sc "tamil story audio" 10
download_sc "tamil storytelling" 10
download_sc "tamil audiobook" 15
download_sc "tamil audio book" 15
download_sc "tamil reading" 10
download_sc "tamil voice over" 10

# === CATEGORY 11: Educational & informational ===
download_sc "tamil tutorial voice" 10
download_sc "tamil explanation" 10
download_sc "tamil educational audio" 10
download_sc "tamil lesson audio" 10
download_sc "tamil class recording" 10

# === CATEGORY 12: News & current affairs ===
download_sc "tamil news discussion" 10
download_sc "tamil news analysis" 10
download_sc "tamil current affairs" 10
download_sc "tamil debate" 10
download_sc "tamil news talk" 10

# === CATEGORY 13: Cultural & social ===
download_sc "tamil cultural talk" 10
download_sc "tamil social discussion" 10
download_sc "tamil community talk" 10
download_sc "tamil family conversation" 10
download_sc "tamil daily life" 10

# === CATEGORY 14: Business & professional ===
download_sc "tamil business call" 10
download_sc "tamil sales call" 10
download_sc "tamil business meeting" 10
download_sc "tamil professional call" 10
download_sc "tamil office conversation" 10

# === CATEGORY 15: Catch-all broad queries ===
download_sc "tamil" 20
download_sc "tamil talk" 20
download_sc "tamil voice tamil" 20
download_sc "tamil audio tamil" 20
download_sc "tamil podcast tamil" 20
download_sc "tamil conversation tamil" 20
download_sc "tamil radio tamil" 20
download_sc "tamil comedy tamil" 20
download_sc "tamil customer tamil" 20
download_sc "tamil call tamil" 20

echo ""
echo "=============================================="
FINAL=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo "Download complete: $FINAL total WAV files"
echo "Target was 500+"
echo "Files in: $OUT_DIR"
echo "=============================================="
