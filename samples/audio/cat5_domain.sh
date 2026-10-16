#!/bin/bash
# Category 5: Domain Vocabulary — business/tech/finance words spoken
OUT="/Volumes/HDD_2TB/Recordings/Audio/5_Domain_Vocabulary"
mkdir -p "$OUT"

run_with_timeout() {
  local secs=$1; shift; "$@" & local pid=$!
  (sleep "$secs" && kill -9 "$pid" 2>/dev/null) & local tid=$!
  wait "$pid" 2>/dev/null; local rc=$?
  kill "$tid" 2>/dev/null; wait "$tid" 2>/dev/null; return $rc
}
dl_sc() {
  local query="$1" max="${2:-10}"
  echo "[SC] $query"
  run_with_timeout 120 yt-dlp -x --audio-format wav --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads "$max" --min-filesize 30k --max-filesize 50M \
    --no-playlist --no-overwrites --socket-timeout 15 --retries 2 \
    --sleep-interval 1 --max-sleep-interval 3 \
    --output "$OUT/sc_%(autonumber)s_%(title).60s.%(ext)s" \
    "scsearch${max}:${query}" 2>&1 | tail -2
  echo "  Total: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ') files"
}

echo "=== Category 5: Domain Vocabulary ==="

# Insurance vocabulary
dl_sc "tamil insurance policy" 15
dl_sc "tamil insurance premium" 10
dl_sc "tamil insurance claim" 10
dl_sc "tamil LIC policy" 10
dl_sc "tamil insurance maturity" 10
dl_sc "tamil insurance nominee" 8
dl_sc "tamil life insurance" 10
dl_sc "tamil health insurance" 10
dl_sc "tamil insurance agent" 8
dl_sc "tamil policy renewal" 10

# Banking vocabulary
dl_sc "tamil bank loan" 12
dl_sc "tamil bank interest" 10
dl_sc "tamil bank account" 10
dl_sc "tamil fixed deposit" 8
dl_sc "tamil EMI" 10
dl_sc "tamil credit card" 10
dl_sc "tamil debit card" 8
dl_sc "tamil bank manager" 8
dl_sc "tamil ATM" 8
dl_sc "tamil banking" 10

# Finance & investment
dl_sc "tamil stock market" 10
dl_sc "tamil shares" 10
dl_sc "tamil mutual fund" 10
dl_sc "tamil investment" 10
dl_sc "tamil dividend" 8
dl_sc "tamil portfolio" 8
dl_sc "tamil finance" 10
dl_sc "tamil money" 10
dl_sc "tamil savings" 10
dl_sc "tamil income tax" 10

# Tech vocabulary
dl_sc "tamil software" 10
dl_sc "tamil programming" 10
dl_sc "tamil computer" 10
dl_sc "tamil internet" 10
dl_sc "tamil technology" 10
dl_sc "tamil IT" 10
dl_sc "tamil coding" 8
dl_sc "tamil developer" 8
dl_sc "tamil app" 10
dl_sc "tamil digital" 10

# Medical vocabulary
dl_sc "tamil hospital" 10
dl_sc "tamil doctor" 10
dl_sc "tamil medicine" 10
dl_sc "tamil treatment" 10
dl_sc "tamil health" 10
dl_sc "tamil patient" 10
dl_sc "tamil diagnosis" 8
dl_sc "tamil medical" 10

# Legal vocabulary
dl_sc "tamil lawyer" 10
dl_sc "tamil court" 10
dl_sc "tamil case" 10
dl_sc "tamil legal" 10
dl_sc "tamil agreement" 8
dl_sc "tamil contract" 8
dl_sc "tamil law" 10

# Real estate vocabulary
dl_sc "tamil property" 10
dl_sc "tamil house" 10
dl_sc "tamil rent" 10
dl_sc "tamil mortgage" 8
dl_sc "tamil real estate" 10
dl_sc "tamil land" 10

# Corporate jargon
dl_sc "tamil business" 10
dl_sc "tamil company" 10
dl_sc "tamil office" 10
dl_sc "tamil manager" 10
dl_sc "tamil employee" 8
dl_sc "tamil salary" 10
dl_sc "tamil meeting" 10
dl_sc "tamil project" 10

# Education vocabulary
dl_sc "tamil school" 10
dl_sc "tamil college" 10
dl_sc "tamil exam" 10
dl_sc "tamil student" 10
dl_sc "tamil teacher" 10
dl_sc "tamil education" 10

echo "=== Category 5 complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l)"
