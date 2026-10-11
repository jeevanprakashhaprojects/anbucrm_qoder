#!/bin/bash
# Extra queries to push past 500 conversation files
OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

EXTRA_QUERIES=(
  # More customer care scenarios
  "customer care call recording tamil comedy"
  "tamil customer care drunk call"
  "tamil customer care romantic call"
  "tamil customer care emotional call"
  "tamil customer care angry customer"
  "tamil customer care rude customer"
  "tamil customer care patience"
  "tamil customer service training role play"
  "tamil BPO training call"
  "tamil voice process sample call"

  # Specific company complaints
  "tamil LIC customer care call"
  "tamil postal complaint tamil"
  "tamil courier complaint tamil"
  "tamil DTDC complaint tamil"
  "tamil BlueDart complaint tamil"

  # More telecom
  "tamil porting complaint"
  "tamil number porting issue tamil"
  "tamil tower location complaint tamil"
  "tamil network coverage complaint tamil"
  "tamil mobile bill dispute tamil"

  # Banking deep dive
  "tamil ATM card block complaint tamil"
  "tamil debit card fraud complaint tamil"
  "tamil online fraud complaint tamil"
  "tamil cyber crime complaint tamil"
  "tamil bank loan complaint tamil"
  "tamil EMI complaint tamil"
  "tamil insurance claim complaint tamil"

  # Government services
  "tamil ration card complaint tamil"
  "tamil Aadhaar complaint tamil"
  "tamil PAN card complaint tamil"
  "tamil voter ID complaint tamil"
  "tamil driving licence complaint tamil"
  "tamil vehicle registration complaint tamil"

  # Healthcare
  "tamil doctor appointment call tamil"
  "tamil pharmacy delivery complaint tamil"
  "tamil medical emergency call tamil"
  "tamil health helpline tamil"

  # Food delivery
  "tamil food delivery complaint tamil"
  "tamil restaurant order wrong tamil"
  "tamil zomato delivery late tamil"
  "tamil swiggy wrong order tamil"

  # E-commerce returns
  "tamil amazon return call tamil"
  "tamil flipkart refund status tamil"
  "tamil Myntra complaint tamil"
  "tamil Meesho complaint tamil"

  # Utility complaints
  "tamil EB complaint call tamil"
  "tamil water supply complaint tamil"
  "tamil street light complaint tamil"
  "tamil garbage collection complaint tamil"

  # Travel complaints
  "tamil bus booking complaint tamil"
  "tamil train delay complaint tamil"
  "tamil flight delay complaint tamil"
  "tamil hotel booking complaint tamil"
  "tamil Airbnb complaint tamil"

  # Tech support
  "tamil laptop service complaint tamil"
  "tamil mobile service center complaint tamil"
  "tamil Samsung service tamil"
  "tamil Apple service tamil"
  "tamil TV repair complaint tamil"
  "tamil washing machine complaint tamil"
  "tamil refrigerator complaint tamil"

  # General conversation/dialogue
  "tamil phone talk tamil"
  "tamil telephone conversation tamil"
  "tamil calling scene tamil movie"
  "tamil phone call scene tamil"
  "tamil talking tamil audio"
  "tamil speech tamil audio"
  "tamil voice recording tamil"
  "tamil spoken tamil audio"
  "tamil speaking tamil"
  "tamil dialogue audio"

  # Podcasts and interviews
  "tamil podcast episode tamil"
  "tamil interview tamil audio"
  "tamil radio show tamil"
  "tamil FM radio tamil"
  "tamil RJ talk tamil"
  "tamil Suryan FM tamil"
  "tamil Radio Mirchi tamil"

  # Real conversations
  "tamil real conversation"
  "tamil people talking tamil"
  "tamil street interview tamil"
  "tamil public opinion tamil"
  "tamil vox pop tamil"
  "tamil man on street tamil"
  "tamil random questions tamil"

  # Service calls
  "tamil plumber call tamil"
  "tamil electrician call tamil"
  "tamil carpenter call tamil"
  "tamil mechanic call tamil"
  "tamil home service call tamil"
  "tamil Urban Company tamil"

  # Complaints general
  "tamil complaint against shop tamil"
  "tamil product defect complaint tamil"
  "tamil wrong bill complaint tamil"
  "tamil overcharge complaint tamil"
  "tamil consumer rights tamil"
  "tamil consumer complaint tamil"
)

echo "=============================================="
echo "Extra conversation download: ${#EXTRA_QUERIES[@]} queries"
echo "Current files: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l)"
echo "=============================================="

for query in "${EXTRA_QUERIES[@]}"; do
  count=$(find "$OUT_DIR" -maxdepth 1 -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -ge 550 ]; then
    echo ""
    echo "=== Reached $count files (target 500+). Stopping. ==="
    break
  fi

  echo ""
  echo "--- [$count files] Query: $query ---"

  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads 10 \
    --min-filesize 50k \
    --max-filesize 500M \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --sleep-interval 2 \
    --max-sleep-interval 5 \
    --output "$OUT_DIR/cs_%(autonumber)s_%(title).50s.%(ext)s" \
    "ytsearch10:${query}" 2>&1 | tail -3
done

echo ""
echo "=============================================="
echo "FINAL: $(find "$OUT_DIR" -maxdepth 1 -name '*.wav' | wc -l) conversation WAV files"
du -sh "$OUT_DIR"
echo "=============================================="
