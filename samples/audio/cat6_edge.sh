#!/bin/bash
# Category 6: Edge Cases — noisy audio, fast speech, overlapping, emotional
OUT="/Volumes/HDD_2TB/Recordings/Audio/6_Edge_Cases"
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

echo "=== Category 6: Edge Cases ==="

# Noisy background
dl_sc "tamil street interview" 12
dl_sc "tamil market conversation" 10
dl_sc "tamil crowd" 10
dl_sc "tamil traffic" 8
dl_sc "tamil noise" 8
dl_sc "tamil background noise" 8
dl_sc "tamil outdoor recording" 8
dl_sc "tamil public place" 10

# Fast speech
dl_sc "tamil fast talk" 10
dl_sc "tamil speed speech" 8
dl_sc "tamil rapid speech" 8
dl_sc "tamil fast talking" 10
dl_sc "tamil quick speech" 8
dl_sc "tamil rap tamil" 10
dl_sc "tamil fast dialogue" 8

# Overlapping / multiple speakers
dl_sc "tamil group discussion" 12
dl_sc "tamil panel discussion" 10
dl_sc "tamil debate tamil" 10
dl_sc "tamil multiple speakers" 8
dl_sc "tamil group conversation" 10
dl_sc "tamil family discussion" 10
dl_sc "tamil friends talking" 10
dl_sc "tamil round table" 8

# Low quality / phone recording
dl_sc "tamil phone call recording" 12
dl_sc "tamil call recording" 10
dl_sc "tamil phone conversation" 10
dl_sc "tamil recorded call" 8
dl_sc "tamil voice message" 10
dl_sc "tamil whatsapp audio" 10

# Emotional speech
dl_sc "tamil angry call" 10
dl_sc "tamil crying" 8
dl_sc "tamil emotional speech" 10
dl_sc "tamil excited talk" 8
dl_sc "tamil shouting" 8
dl_sc "tamil complaint angry" 10
dl_sc "tamil upset call" 8

# Whispered / quiet speech
dl_sc "tamil whisper" 8
dl_sc "tamil quiet talk" 8
dl_sc "tamil soft speech" 8
dl_sc "tamil low voice" 8

# Children speaking
dl_sc "tamil children talking" 10
dl_sc "tamil kids speech" 10
dl_sc "tamil child speaking" 8
dl_sc "tamil school children" 8
dl_sc "tamil student speech" 10

# Elderly speaking
dl_sc "tamil elderly speech" 10
dl_sc "tamil old man talking" 8
dl_sc "tamil old woman talking" 8
dl_sc "tamil senior citizen" 8
dl_sc "tamil grandpa" 8
dl_sc "tamil grandma" 8

# Heavy accent / dialect
dl_sc "tamil village accent" 10
dl_sc "tamil rural dialect" 8
dl_sc "tamil deep tamil" 10
dl_sc "tamil pure tamil" 10
dl_sc "tamil slang" 10

# Mixed language mid-sentence
dl_sc "tamil english mix" 12
dl_sc "tanglish conversation" 12
dl_sc "tamil code switching" 8
dl_sc "tamil bilingual" 10
dl_sc "tamil mixed language" 8

# Stuttering / disfluency
dl_sc "tamil stutter" 6
dl_sc "tamil hesitation" 6
dl_sc "tamil umm ahh" 6

# Monotone / robotic
dl_sc "tamil monotone" 6
dl_sc "tamil robot voice" 6
dl_sc "tamil TTS tamil" 8

# Singing / rhythmic
dl_sc "tamil song" 10
dl_sc "tamil singing" 10
dl_sc "tamil melody" 8
dl_sc "tamil music" 10

echo "=== Category 6 complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l)"
