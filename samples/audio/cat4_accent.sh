#!/bin/bash
# Category 4: Accent Diversity — different regions, ages, genders
OUT="/Volumes/HDD_2TB/Recordings/Audio/4_Accent_Diversity"
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

echo "=== Category 4: Accent Diversity ==="

# Chennai accent
dl_sc "chennai tamil" 15
dl_sc "chennai tamil talk" 10
dl_sc "chennai tamil conversation" 10
dl_sc "chennai tamil comedy" 10
dl_sc "north chennai tamil" 10
dl_sc "chennai slang" 10
dl_sc "chennai local tamil" 10
dl_sc "chennai city tamil" 10

# Madurai accent
dl_sc "madurai tamil" 15
dl_sc "madurai tamil talk" 10
dl_sc "madurai tamil comedy" 10
dl_sc "madurai dialect" 10
dl_sc "madurai slang" 10
dl_sc "madurai local tamil" 10
dl_sc "madurai conversation" 10

# Coimbatore accent
dl_sc "coimbatore tamil" 15
dl_sc "kongu tamil" 10
dl_sc "kongu dialect" 10
dl_sc "coimbatore talk" 10
dl_sc "western tamil dialect" 10
dl_sc "coimbatore conversation" 10

# Tirunelveli accent
dl_sc "tirunelveli tamil" 10
dl_sc "nelveli tamil" 10
dl_sc "southern tamil dialect" 10
dl_sc "tirunelveli talk" 10
dl_sc "tirunelveli conversation" 10

# Thanjavur accent
dl_sc "thanjavur tamil" 10
dl_sc "tanjore tamil" 10
dl_sc "delta tamil dialect" 10
dl_sc "thanjavur conversation" 10

# Trichy accent
dl_sc "trichy tamil" 10
dl_sc "tiruchirappalli tamil" 10
dl_sc "trichy talk" 10
dl_sc "central tamil dialect" 10

# Salem accent
dl_sc "salem tamil" 10
dl_sc "salem tamil talk" 10
dl_sc "salem dialect" 10

# Kanyakumari accent
dl_sc "kanyakumari tamil" 10
dl_sc "kanyakumari talk" 10
dl_sc "southernmost tamil" 10

# Dindigul accent
dl_sc "dindigul tamil" 10
dl_sc "dindigul talk" 10

# Erode accent
dl_sc "erode tamil" 10

# Vellore accent
dl_sc "vellore tamil" 10
dl_sc "vellore talk" 10

# Age diversity - children
dl_sc "tamil children talking" 10
dl_sc "tamil kids speech" 10
dl_sc "tamil child conversation" 10
dl_sc "tamil school children" 10
dl_sc "tamil kids story" 10

# Age diversity - youth
dl_sc "tamil youth speech" 10
dl_sc "tamil teenager talk" 10
dl_sc "tamil young adult" 10

# Age diversity - elderly
dl_sc "tamil old man talk" 10
dl_sc "tamil elderly speech" 10
dl_sc "tamil grandma talk" 10
dl_sc "tamil grandfather talk" 10
dl_sc "tamil senior citizen" 10
dl_sc "tamil elder speaking" 10

# Gender diversity - female speakers
dl_sc "tamil girl talking" 15
dl_sc "tamil woman speech" 10
dl_sc "tamil female speaker" 10
dl_sc "tamil lady talk" 10
dl_sc "tamil women conversation" 10
dl_sc "tamil girl phone call" 10
dl_sc "tamil aunty talk" 10
dl_sc "tamil girl podcast" 10

# Gender diversity - male speakers
dl_sc "tamil boy talking" 15
dl_sc "tamil man speech" 10
dl_sc "tamil male speaker" 10
dl_sc "tamil anna talk" 10
dl_sc "tamil guy conversation" 10
dl_sc "tamil boy phone call" 10
dl_sc "tamil uncle talk" 10

# Sri Lankan Tamil
dl_sc "sri lankan tamil" 10
dl_sc "jaffna tamil" 10
dl_sc "lanka tamil talk" 10
dl_sc "sri lanka tamil speech" 10

# Malaysia/Singapore Tamil
dl_sc "malaysian tamil" 10
dl_sc "singapore tamil" 10
dl_sc "malay tamil talk" 10

echo ""
echo "=== Category 4 Complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ')"
du -sh "$OUT"
