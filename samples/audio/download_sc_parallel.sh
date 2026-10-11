#!/bin/bash
# Parallel SoundCloud Tamil download - 5 workers with per-file timeout
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

EXISTING=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo "Starting with $EXISTING WAV files. Target: 500+"

WORKER_LOG="/tmp/sc_worker"

# Run yt-dlp with a timeout (macOS compatible - no `timeout` command)
run_with_timeout() {
  local secs=$1
  shift

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
  local id=$1
  shift
  local queries=("$@")

  for query in "${queries[@]}"; do
    local count=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -ge 550 ]; then
      echo "[W$id] Reached $count files. Done." >> "${WORKER_LOG}_${id}.log"
      return 0
    fi

    echo "[W$id] Searching: $query (total: $count)" >> "${WORKER_LOG}_${id}.log"

    # 90 second timeout per query batch
    run_with_timeout 90 yt-dlp -x \
      --audio-format wav \
      --audio-quality 0 \
      --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
      --max-downloads 5 \
      --min-filesize 30k \
      --max-filesize 30M \
      --no-playlist \
      --no-overwrites \
      --socket-timeout 10 \
      --retries 1 \
      --sleep-interval 1 \
      --max-sleep-interval 2 \
      --output "$OUT_DIR/sc_${id}_%(autonumber)s_%(title).50s.%(ext)s" \
      "scsearch5:${query}" >> "${WORKER_LOG}_${id}.log" 2>&1

    count=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
    echo "[W$id] Done query. Total: $count" >> "${WORKER_LOG}_${id}.log"
    sleep 1
  done
}

# Clean old worker logs
rm -f ${WORKER}_*.log

# Worker 1: Customer care & service
worker 1 \
  "tamil customer care" \
  "tamil customer service" \
  "tamil complaint" \
  "airtel tamil" \
  "bsnl tamil" \
  "jio tamil" \
  "tamil call center" \
  "tamil telecalling" \
  "tamil support call" \
  "tamil service call" \
  "tamil delivery" \
  "tamil bank call" \
  "tamil insurance" \
  "tamil utility complaint" \
  "tamil help" &

# Worker 2: Comedy & entertainment
worker 2 \
  "tamil funny call" \
  "tamil comedy call" \
  "tamil prank call" \
  "tamil funny conversation" \
  "tamil comedy dialogue" \
  "rj balaji" \
  "tamil funny phone" \
  "tamil comedy skit" \
  "tamil joke" \
  "tamil humor" \
  "tamil comedy scene" \
  "tamil funny audio" \
  "tamil laugh" \
  "tamil entertainment" \
  "tamil fun" &

# Worker 3: Podcasts & radio
worker 3 \
  "tamil podcast" \
  "tamil radio" \
  "tamil talk show" \
  "tamil interview" \
  "tamil discussion" \
  "tamil fm" \
  "rj tamil" \
  "tamil radio show" \
  "tamil podcast episode" \
  "tamil broadcast" \
  "tamil talk" \
  "tamil news talk" \
  "tamil debate" \
  "tamil current affairs" \
  "tamil audio show" &

# Worker 4: General conversations & voice
worker 4 \
  "tamil conversation" \
  "tamil voice" \
  "tamil speech" \
  "tamil dialogue" \
  "tamil speaking" \
  "tamil voice recording" \
  "tamil phone conversation" \
  "tamil narration" \
  "tamil story" \
  "tamil audiobook" \
  "tamil reading" \
  "tamil voice over" \
  "tamil audio clip" \
  "tamil audio" \
  "tamil voice message" &

# Worker 5: Scam, fraud, banking, tech, business
worker 5 \
  "tamil scam call" \
  "tamil fraud call" \
  "tamil bank fraud" \
  "tamil atm fraud" \
  "tamil loan" \
  "tamil credit card" \
  "tamil sbi" \
  "tamil tech support" \
  "tamil business call" \
  "tamil sales call" \
  "tamil office" \
  "tamil government" \
  "tamil police" \
  "tamil lic agent" \
  "tamil policy" &

echo "Launched 5 parallel workers with 90s timeout per query..."
echo "Monitor: tail -f /tmp/sc_worker_*.log"
echo "Count: ls '$OUT_DIR'/*.wav | wc -l"

# Wait for all workers
wait

echo ""
FINAL=$(ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ')
echo "=============================================="
echo "All workers finished: $FINAL total WAV files"
echo "=============================================="
