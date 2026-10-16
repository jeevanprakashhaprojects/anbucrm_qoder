#!/bin/bash
# Category 1: Casual Conversation — friends, family, everyday speech
# Target: 50-100 hours of Tamil/Tanglish casual speech
OUT="/Volumes/HDD_2TB/Recordings/Audio/1_Casual_Conversation"
mkdir -p "$OUT"

run_with_timeout() {
  local secs=$1; shift
  "$@" &
  local pid=$!
  (sleep "$secs" && kill -9 "$pid" 2>/dev/null) &
  local tid=$!
  wait "$pid" 2>/dev/null; local rc=$?
  kill "$tid" 2>/dev/null; wait "$tid" 2>/dev/null
  return $rc
}

dl_sc() {
  local query="$1" max="${2:-10}"
  echo "[SC] $query (max $max)"
  run_with_timeout 120 yt-dlp -x \
    --audio-format wav --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads "$max" --min-filesize 30k --max-filesize 50M \
    --no-playlist --no-overwrites --socket-timeout 15 --retries 2 \
    --sleep-interval 1 --max-sleep-interval 3 \
    --output "$OUT/sc_%(autonumber)s_%(title).60s.%(ext)s" \
    "scsearch${max}:${query}" 2>&1 | tail -2
  echo "  Total: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ') files"
}

echo "=== Category 1: Casual Conversation ==="
echo "Target: Tamil/Tanglish friends, family, everyday speech"

# Friends & family conversations
dl_sc "tamil friends conversation" 15
dl_sc "tamil family talk" 15
dl_sc "tamil friends talking" 15
dl_sc "tamil friend phone call" 10
dl_sc "tamil friends chat" 10
dl_sc "tamil friends funny talk" 10
dl_sc "tamil group friends talk" 10
dl_sc "tamil college friends" 10
dl_sc "tamil school friends talk" 10
dl_sc "tamil friends gossip" 10

# Everyday speech
dl_sc "tamil daily conversation" 15
dl_sc "tamil everyday talk" 10
dl_sc "tamil daily life" 10
dl_sc "tamil routine talk" 10
dl_sc "tamil normal conversation" 10
dl_sc "tamil general talk" 10
dl_sc "tamil simple conversation" 10
dl_sc "tamil casual talk" 10
dl_sc "tamil casual chat" 10
dl_sc "tamil regular talk" 10

# Phone calls & personal
dl_sc "tamil phone call friends" 10
dl_sc "tamil phone conversation family" 10
dl_sc "tamil lover call" 10
dl_sc "tamil lovers talk" 10
dl_sc "tamil couple conversation" 10
dl_sc "tamil girlfriend boyfriend talk" 10
dl_sc "tamil first phone call" 10
dl_sc "tamil girl phone call" 10
dl_sc "tamil boy phone call" 10
dl_sc "tamil random phone call" 10

# Funny casual
dl_sc "tamil funny friends talk" 15
dl_sc "tamil friends comedy" 15
dl_sc "tamil friends prank" 10
dl_sc "tamil funny family talk" 10
dl_sc "tamil comedy conversation" 15
dl_sc "tamil fun talk" 10
dl_sc "tamil joke friends" 10
dl_sc "tamil humor conversation" 10

# Tanglish casual
dl_sc "tanglish conversation" 15
dl_sc "tanglish friends talk" 10
dl_sc "tanglish casual" 10
dl_sc "tamil english mix talk" 10
dl_sc "tanglish phone call" 10
dl_sc "tanglish comedy" 10
dl_sc "tanglish friends" 10

# Podcasts (casual style)
dl_sc "tamil casual podcast" 10
dl_sc "tamil friends podcast" 10
dl_sc "tamil chat podcast" 10
dl_sc "tamil casual talk show" 10
dl_sc "tamil fun podcast" 10
dl_sc "tamil youth talk" 10
dl_sc "tamil student conversation" 10
dl_sc "tamil college talk" 10

# Village & rural casual
dl_sc "tamil village talk" 10
dl_sc "tamil village conversation" 10
dl_sc "tamil rural conversation" 10
dl_sc "tamil village life" 10
dl_sc "tamil village people talk" 10

# General Tamil speech
dl_sc "tamil people talking" 10
dl_sc "tamil speech everyday" 10
dl_sc "tamil spoken tamil" 10
dl_sc "tamil real conversation" 10
dl_sc "tamil natural talk" 10

echo ""
echo "=== Category 1 Complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ')"
du -sh "$OUT"
