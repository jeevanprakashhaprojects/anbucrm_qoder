#!/bin/bash
# Download Tamil insurance reel audio from Instagram
# Uses yt-dlp (supports Instagram) with reelsave.app fallback

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/Insurance"
mkdir -p "$OUT_DIR"

# All reel URLs collected from Instagram hashtags: #tamilinsurance, #lictamil, #tamilinsuranceagent
REEL_IDS=(
  # From #tamilinsurance
  "DZm1SzaP667"
  "DdWj-J1hBkz"
  "DcyIWgpJwqA"
  "DdxyGNUyQyL"
  "Ddy_HSCPgcH"
  "Dcqkq5nP8To"
  "DeT8SpnTozG"
  "Dd_yx1VzMY4"
  "DcdmdKNJTz-"
  "DXgZ86hETpq"
  "Dc5qGW_uELL"
  "Dd1mP_wkinK"
  "DbPVB_HKhPx"
  "DceEtYlBF1b"
  "DcQxdkPDoMU"
  "DeLEthMBBhy"
  "Dc5i7jmlabl"
  "DcNgUtoihTq"

  # From #lictamil
  "DbiXxpQj_cu"
  "Dc7Y9Koy9HK"
  "DbxD2iYSc8_"
  "DMKxY6mzXyP"
  "Dd324fWhRpl"
  "DLzklGcTMzj"
  "DLkIT0BRsZw"

  # From search page
  "Ddb7ly-z4Ht"
  "DdMY4kPTnSX"
  "Dd_vT3VJIb_"
  "DdzGOk3EaH9"
  "DcyQBPLsAcM"
  "DdLoyahjsrB"
  "DcxcRiIz7T3"
  "Ddqoii4OG2I"
  "DeL_40ApJGW"
  "Da798rjv4aG"
  "DboB2FJps-V"
  "DdHbcPGzzLN"
  "DcUolK8CZUC"
  "DbDPjKNT8VX"
  "DdqLTfCsvcG"
  "Dd1Y78DTRdd"
  "DddmpiPyI5P"
  "Dd8whMYxPRT"
  "Ddl5BMHvCgo"
  "DeR0uieoU0h"

  # From #healthinsurancetamil
  "Dd6jbtzJvV3"
  "DcinK1espO2"
  "Db8mpGEK23T"
  "DYOMn1GSxQK"
  "DdERSzXuVNq"
  "DdEiaXftRtu"
  "DY2BU68Ozdu"
  "Dde4mJsh_tS"
  "DcLgrgZT4VU"
  "DcTOyb-ILJn"
  "DeRkVGFT0TZ"

  # From @financewithsasi profile
  "DdordjGlHFu"
  "DcjFnSmilMr"
  "DbI35lfkzkM"
  "DbCsFFTEWJY"
  "Da5nlwkkbho"
  "Dap-ZUCDKVo"
  "DaidjVkmSlt"
  "Daf4p1PibEP"
  "DaXeNh7DgBW"
  "DaTGOJ3j1Y7"
  "DaLFkYDkq1H"
  "DaIwxi1FWqX"

  # From @grace_insurance_tamil profile
  "Ddtrq1wvsWq"
  "Dd3eN1kRGtL"
  "DdvNJXvD-zL"
  "Dd_4ux2PA7_"
  "Dd_zo0avizd"
  "Dd_WxaUP3H5"
  "DdzCn2hTWEm"
  "DdyYKSfvYvd"
  "DdxwgNihsq_"
  "DdqxaPXPmsx"
  "DdjELNkv1_S"
  "Ddi-soivQr6"

  # From @vishnukumar.chandrasekaran profile
  "DePJ0zak6pO"
  "DeKAIG1A2Ja"
  "Dd_s_q5kyx7"
  "Dd6jY7gEyrf"
  "Dd1ZzmpEy8Q"
  "DdwQOYzk2Ea"
  "DdrGlj4k9cY"
  "DdlysdaE3pA"
  "DdgzVeUByrI"
  "Dc8wKxGxVx_"
  "Dc3maJexe3U"
  "DcydAbfxeM5"
)

echo "=============================================="
echo "Downloading ${#REEL_IDS[@]} Instagram reel audio files"
echo "Output: $OUT_DIR"
echo "=============================================="

SUCCESS=0
FAIL=0
FAILED_IDS=()

for reel_id in "${REEL_IDS[@]}"; do
  outfile="$OUT_DIR/ig_${reel_id}.wav"

  if [ -f "$outfile" ]; then
    echo "[SKIP] $reel_id (already exists)"
    SUCCESS=$((SUCCESS + 1))
    continue
  fi

  echo ""
  echo "[DOWNLOAD] ig_${reel_id}..."

  # Try yt-dlp first
  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    -o "$OUT_DIR/ig_${reel_id}.%(ext)s" \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    "https://www.instagram.com/reel/${reel_id}/" 2>&1 | tail -5

  if [ $? -eq 0 ] && [ -f "$outfile" ]; then
    echo "[OK] ig_${reel_id}"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "[FAIL] ig_${reel_id} - will try reelsave.app fallback"
    FAILED_IDS+=("$reel_id")
    FAIL=$((FAIL + 1))
  fi

  sleep 2
done

echo ""
echo "=============================================="
echo "yt-dlp complete: $SUCCESS succeeded, $FAIL failed"
echo "=============================================="

# Fallback: try reelsave.app for failed IDs
if [ ${#FAILED_IDS[@]} -gt 0 ]; then
  echo ""
  echo "Trying reelsave.app fallback for ${#FAILED_IDS[@]} failed reels..."

  for reel_id in "${FAILED_IDS[@]}"; do
    outfile="$OUT_DIR/ig_${reel_id}.mp3"

    if [ -f "$outfile" ]; then
      echo "[SKIP] $reel_id (already exists)"
      continue
    fi

    echo "[REELSAVE] ig_${reel_id}..."

    # Use reelsave.app API
    reel_url="https://www.instagram.com/reel/${reel_id}/"

    # First POST the URL to reelsave.app
    response=$(curl -s -X POST "https://reelsave.app/api/audio" \
      -H "Content-Type: application/json" \
      -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
      -d "{\"url\": \"${reel_url}\"}" 2>&1)

    # Extract download URL from response
    download_url=$(echo "$response" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('url', data.get('download_url', data.get('link', ''))))
except:
    print('')
" 2>/dev/null)

    if [ -n "$download_url" ] && [ "$download_url" != "" ]; then
      curl -s -L -o "$outfile" "$download_url"
      if [ -f "$outfile" ] && [ $(stat -f%z "$outfile" 2>/dev/null || echo 0) -gt 10000 ]; then
        # Convert to WAV 16kHz mono
        ffmpeg -y -i "$outfile" -ar 16000 -ac 1 "$OUT_DIR/ig_${reel_id}.wav" 2>/dev/null
        rm -f "$outfile"
        echo "[OK] ig_${reel_id} (via reelsave.app)"
        SUCCESS=$((SUCCESS + 1))
        FAIL=$((FAIL - 1))
      else
        echo "[FAIL] ig_${reel_id} (reelsave.app download failed)"
        rm -f "$outfile"
      fi
    else
      echo "[FAIL] ig_${reel_id} (could not get download URL)"
    fi

    sleep 3
  done
fi

echo ""
echo "=============================================="
echo "Final results: $SUCCESS succeeded, $FAIL failed"
echo "Files in: $OUT_DIR"
echo "=============================================="
ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l
echo "WAV files total"
