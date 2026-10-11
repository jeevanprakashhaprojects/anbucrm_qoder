#!/bin/bash
# SoundCloud Tamil download - Batch 2 (different queries)
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

EXISTING=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo "Starting with $EXISTING WAV files. Target: 500+"

WORKER_LOG="/tmp/sc2_worker"

run_with_timeout() {
  local secs=$1; shift
  "$@" &
  local cmd_pid=$!
  (sleep "$secs" && kill -9 "$cmd_pid" 2>/dev/null) &
  local timer_pid=$!
  wait "$cmd_pid" 2>/dev/null
  local exit_code=$?
  kill "$timer_pid" 2>/dev/null
  wait "$timer_pid" 2>/dev/null
  return $exit_code
}

worker() {
  local id=$1; shift
  local queries=("$@")
  for query in "${queries[@]}"; do
    local count=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -ge 550 ]; then
      echo "[W$id] Reached $count. Done." >> "${WORKER_LOG}_${id}.log"
      return 0
    fi
    echo "[W$id] $query (total: $count)" >> "${WORKER_LOG}_${id}.log"
    run_with_timeout 90 yt-dlp -x \
      --audio-format wav --audio-quality 0 \
      --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
      --max-downloads 5 --min-filesize 30k --max-filesize 30M \
      --no-playlist --no-overwrites --socket-timeout 10 --retries 1 \
      --sleep-interval 1 --max-sleep-interval 2 \
      --output "$OUT_DIR/sc2_${id}_%(autonumber)s_%(title).50s.%(ext)s" \
      "scsearch5:${query}" >> "${WORKER_LOG}_${id}.log" 2>&1
    count=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
    echo "[W$id] Done. Total: $count" >> "${WORKER_LOG}_${id}.log"
    sleep 1
  done
}

rm -f ${WORKER}_*.log

# Worker 1: More customer service variations
worker 1 \
  "customer care tamil" \
  "customer service tamil" \
  "complaint tamil" \
  "tamil helpline" \
  "tamil complaint" \
  "tamil service" \
  "tamil call" \
  "tamil phone call" \
  "tamil caller" \
  "tamil receiving call" \
  "tamil phone" \
  "tamil mobile" \
  "tamil sim card" \
  "tamil network" \
  "tamil broadband" &

# Worker 2: More comedy/funny
worker 2 \
  "tamil comedy" \
  "tamil funny" \
  "tamil joke" \
  "tamil humor" \
  "tamil fun" \
  "tamil laugh" \
  "tamil prank" \
  "tamil troll" \
  "tamil meme" \
  "tamil comedy audio" \
  "tamil standup" \
  "tamil stand up" \
  "tamil fun call" \
  "tamil comedy talk" \
  "tamil joke call" &

# Worker 3: More podcast/talk
worker 3 \
  "tamil podcast episode" \
  "tamil podcast show" \
  "tamil radio episode" \
  "tamil fm show" \
  "tamil RJ" \
  "tamil radio jockey" \
  "tamil talk audio" \
  "tamil discussion audio" \
  "tamil interview audio" \
  "tamil chat" \
  "tamil conversation audio" \
  "tamil talk show audio" \
  "tamil news discussion" \
  "tamil political talk" \
  "tamil social talk" &

# Worker 4: Stories, audiobooks, narration
worker 4 \
  "tamil story" \
  "tamil stories" \
  "tamil katha" \
  "tamil kathai" \
  "tamil audiobook" \
  "tamil audio book" \
  "tamil book reading" \
  "tamil novel audio" \
  "tamil fiction" \
  "tamil moral story" \
  "tamil children story" \
  "tamil bedtime story" \
  "tamil short story" \
  "tamil narrative" \
  "tamil storytelling" &

# Worker 5: Broader Tamil audio
worker 5 \
  "tamil speech" \
  "tamil speech audio" \
  "tamil motivational" \
  "tamil motivation" \
  "tamil inspiration" \
  "tamil guru" \
  "tamil spiritual" \
  "tamil temple" \
  "tamil devotional" \
  "tamil song audio" \
  "tamil music talk" \
  "tamil cinema talk" \
  "tamil movie audio" \
  "tamil film talk" \
  "tamil actor interview" &

echo "Launched batch 2: 5 workers, 90s timeout, 75 queries..."

wait

FINAL=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo ""
echo "=============================================="
echo "Batch 2 complete: $FINAL total WAV files"
echo "=============================================="
