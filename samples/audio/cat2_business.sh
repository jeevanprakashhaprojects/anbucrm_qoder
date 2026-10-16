#!/bin/bash
# Category 2: Business Conversations — sales calls, support calls
OUT="/Volumes/HDD_2TB/Recordings/Audio/2_Business_Conversations"
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

echo "=== Category 2: Business Conversations ==="

# Sales calls
dl_sc "tamil sales call" 15
dl_sc "tamil telemarketing call" 10
dl_sc "tamil cold calling" 10
dl_sc "tamil sales pitch" 10
dl_sc "tamil telecalling" 15
dl_sc "tamil phone sales" 10
dl_sc "tamil direct selling" 10
dl_sc "tamil product sales call" 10
dl_sc "tamil insurance sales" 10
dl_sc "tamil policy selling call" 10

# Customer support
dl_sc "tamil customer support" 15
dl_sc "tamil customer care call" 15
dl_sc "tamil customer service" 15
dl_sc "tamil support call" 10
dl_sc "tamil help desk tamil" 10
dl_sc "tamil complaint call" 15
dl_sc "tamil complaint resolution" 10
dl_sc "tamil service request" 10
dl_sc "tamil call center tamil" 15
dl_sc "tamil BPO call" 10

# Banking business
dl_sc "tamil bank customer call" 10
dl_sc "tamil bank support" 10
dl_sc "tamil sbi customer care" 10
dl_sc "tamil hdfc customer" 10
dl_sc "tamil bank enquiry" 10
dl_sc "tamil loan enquiry call" 10
dl_sc "tamil loan recovery call" 10
dl_sc "tamil finance call tamil" 10
dl_sc "tamil credit card call" 10
dl_sc "tamil atm support tamil" 10

# Telecom business
dl_sc "tamil airtel customer care" 10
dl_sc "tamil jio customer care" 10
dl_sc "tamil bsnl customer care" 10
dl_sc "tamil vodafone customer" 10
dl_sc "tamil telecom support" 10
dl_sc "tamil sim activation call" 10
dl_sc "tamil network complaint" 10
dl_sc "tamil broadband support" 10

# E-commerce & delivery
dl_sc "tamil delivery call" 10
dl_sc "tamil flipkart delivery" 10
dl_sc "tamil amazon delivery tamil" 10
dl_sc "tamil swiggy call" 10
dl_sc "tamil zomato call tamil" 10
dl_sc "tamil ola driver call" 10
dl_sc "tamil uber driver tamil" 10
dl_sc "tamil food delivery call" 10

# Insurance business
dl_sc "tamil insurance call" 15
dl_sc "tamil lic agent call" 10
dl_sc "tamil insurance claim call" 10
dl_sc "tamil policy renewal call" 10
dl_sc "tamil health insurance call" 10
dl_sc "tamil life insurance call" 10
dl_sc "tamil insurance agent tamil" 10
dl_sc "tamil insurance enquiry" 10

# Scam & fraud (business impersonation)
dl_sc "tamil scam call" 15
dl_sc "tamil fraud call" 15
dl_sc "tamil fake bank call" 10
dl_sc "tamil phishing call tamil" 10
dl_sc "tamil atm fraud call" 10
dl_sc "tamil cyber fraud tamil" 10
dl_sc "tamil fake customer care" 10
dl_sc "tamil scammer call" 10

# Professional calls
dl_sc "tamil business meeting" 10
dl_sc "tamil office call" 10
dl_sc "tamil corporate call" 10
dl_sc "tamil client call tamil" 10
dl_sc "tamil vendor call" 10
dl_sc "tamil business enquiry" 10
dl_sc "tamil trade call tamil" 10

echo ""
echo "=== Category 2 Complete ==="
echo "Total files: $(find "$OUT" -name '*.wav' | wc -l | tr -d ' ')"
du -sh "$OUT"
