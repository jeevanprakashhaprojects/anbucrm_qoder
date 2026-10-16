#!/bin/bash
# Category 3: Code-Mixing Variety — different Tamil:English ratios
# Tanglish, Tamil+English mixing at various levels
OUT="/Volumes/HDD_2TB/Recordings/Audio/3_Code_Mixing_Variety"
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

echo "=== Category 3: Code-Mixing Variety ==="

# Heavy Tanglish (50/50 mix)
dl_sc "tanglish conversation" 15
dl_sc "tanglish talk" 15
dl_sc "tanglish podcast" 15
dl_sc "tanglish comedy" 15
dl_sc "tanglish phone call" 10
dl_sc "tanglish friends" 10
dl_sc "tanglish fun" 10
dl_sc "tanglish chat" 10
dl_sc "tanglish discussion" 10
dl_sc "tanglish show" 10

# Tamil-dominant with English words
dl_sc "tamil english mix" 15
dl_sc "tamil with english words" 10
dl_sc "tamil spoken english mix" 10
dl_sc "modern tamil talk" 10
dl_sc "contemporary tamil speech" 10
dl_sc "tamil urban talk" 10
dl_sc "chennai tamil english" 10
dl_sc "tamil city talk" 10

# English-dominant with Tamil words
dl_sc "english tamil mix" 10
dl_sc "indian english tamil" 10
dl_sc "tamil speaking english" 10

# IT/tech code-mixing
dl_sc "tamil it professional" 10
dl_sc "tamil software engineer talk" 10
dl_sc "tamil tech talk" 10
dl_sc "tamil it company" 10
dl_sc "tamil programmer talk" 10
dl_sc "tamil startup talk" 10
dl_sc "tamil corporate tamil" 10
dl_sc "tamil office english mix" 10

# Education code-mixing
dl_sc "tamil english class" 10
dl_sc "tamil tuition class" 10
dl_sc "tamil college lecture" 10
dl_sc "tamil engineering college" 10
dl_sc "tamil student discussion" 10
dl_sc "tamil school talk" 10
dl_sc "tamil coaching class" 10

# Youth code-mixing
dl_sc "tamil youth talk" 10
dl_sc "tamil genz tamil" 10
dl_sc "tamil college students" 10
dl_sc "tamil young people talk" 10
dl_sc "tamil millennial tamil" 10
dl_sc "tamil modern youth" 10

# Media code-mixing
dl_sc "tamil news english mix" 10
dl_sc "tamil anchor talk" 10
dl_sc "tamil tv show talk" 10
dl_sc "tamil youtube talk" 10
dl_sc "tamil vlog tamil" 10
dl_sc "tamil review tamil" 10
dl_sc "tamil tech review tamil" 10
dl_sc "tamil movie review tamil" 10

# Business code-mixing
dl_sc "tamil business english" 10
dl_sc "tamil meeting english" 10
dl_sc "tamil presentation tamil" 10
dl_sc "tamil interview english mix" 10
dl_sc "tamil job interview tamil" 10

echo ""
echo "=== Category 3 Complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ')"
du -sh "$OUT"
