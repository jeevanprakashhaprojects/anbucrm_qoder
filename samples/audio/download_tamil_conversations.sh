#!/bin/bash
# Download Tamil customer-service conversation audio from all sources
# Target: 500+ conversation files

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/CustomerService"
mkdir -p "$OUT_DIR"

echo "=============================================="
echo "Tamil Customer-Service Conversation Downloader"
echo "Output: $OUT_DIR"
echo "=============================================="

# ============================================================
# PART 1: YouTube search queries for Tamil customer conversations
# ============================================================
QUERIES=(
  # Customer care calls
  "tamil customer care call recording"
  "tamil customer service conversation"
  "tamil customer support call"
  "tamil call center conversation"
  "tamil complaint call recording"
  "tamil customer care funny"
  "tamil customer care angry call"
  "tamil customer care rude"
  "tamil customer care scam call"
  "tamil spam call"
  "tamil telecaller call"
  "tamil cold call"
  "tamil fraud call"
  "tamil fake call customer care"

  # Telecom customer care
  "airtel customer care tamil call"
  "jio customer care tamil"
  "vi customer care tamil"
  "bsnl customer care tamil"
  "tamil mobile customer service"
  "tamil broadband complaint call"
  "tamil internet service complaint"
  "tamil wifi complaint call"

  # Banking customer service
  "tamil bank customer care call"
  "tamil sbi customer care tamil"
  "tamil hdfc customer care tamil"
  "tamil icici customer care tamil"
  "tamil axis bank customer care tamil"
  "tamil atm complaint call"
  "tamil credit card complaint tamil"
  "tamil loan recovery call tamil"
  "tamil bank fraud call tamil"
  "tamil cheque bounce call tamil"
  "tamil netbanking problem tamil"

  # E-commerce / delivery
  "tamil amazon customer care call"
  "tamil flipkart customer care tamil"
  "tamil swiggy complaint call tamil"
  "tamil zomato complaint tamil"
  "tamil delivery complaint tamil"
  "tamil product return call tamil"
  "tamil refund call tamil"
  "tamil order complaint tamil"

  # Utility services
  "tamil electricity board complaint"
  "tamil TNEB complaint call"
  "tamil water board complaint"
  "tamil gas agency complaint tamil"
  "tamil LPG complaint tamil"
  "tamil DTH complaint tamil"
  "tamil cable TV complaint tamil"

  # Government services
  "tamil railway complaint PNR"
  "tamil passport office complaint tamil"
  "tamil RTO complaint tamil"
  "tamil municipal complaint tamil"
  "tamil government office complaint tamil"
  "tamil police complaint tamil"
  "tamil hospital complaint tamil"

  # Service scenarios
  "tamil warranty claim call"
  "tamil service center complaint tamil"
  "tamil vehicle service complaint tamil"
  "tamil car service complaint tamil"
  "tamil bike service complaint tamil"
  "tamil appliance repair complaint tamil"
  "tamil AC service complaint tamil"

  # Consumer rights
  "tamil consumer forum complaint"
  "tamil consumer court case tamil"
  "tamil ombudsman complaint tamil"
  "tamil grievance call tamil"
  "tamil helpline call tamil"
  "tamil 1800 number complaint tamil"
  "tamil toll free complaint tamil"

  # Conversational Tamil (general dialogue)
  "tamil conversation recording"
  "tamil dialogue scene"
  "tamil movie conversation scene"
  "tamil comedy conversation scene"
  "tamil dramatic conversation"
  "tamil real life conversation tamil"
  "tamil interview tamil"
  "tamil podcast tamil conversation"
  "tamil talk show tamil"
  "tamil phone conversation tamil"
  "tamil daily life conversation tamil"
  "tamil street conversation tamil"
  "tamil vlog conversation tamil"

  # Call center training / BPO
  "tamil BPO call recording"
  "tamil call center training"
  "tamil voice process tamil"
  "tamil international call tamil"
  "tamil domestic call center tamil"
  "tamil customer service training tamil"

  # Specific scenarios
  "tamil SIM card complaint"
  "tamil porting complaint tamil"
  "tamil recharge problem tamil"
  "tamil data balance complaint tamil"
  "tamil network issue complaint tamil"
  "tamil billing complaint tamil"
  "tamil payment issue tamil"
  "tamil UPI complaint tamil"
  "tamil GPay problem tamil"
  "tamil PhonePe complaint tamil"
  "tamil Paytm complaint tamil"

  # Health / pharma
  "tamil pharmacy order call tamil"
  "tamil medical appointment tamil"
  "tamil hospital appointment call tamil"
  "tamil health insurance claim call tamil"
  "tamil ambulance call tamil"

  # Travel / hospitality
  "tamil hotel complaint tamil"
  "tamil flight complaint tamil"
  "tamil bus complaint tamil"
  "tamil taxi complaint tamil"
  "tamil ola complaint tamil"
  "tamil uber complaint tamil"
  "tamil irctc complaint tamil"
  "tamil travel complaint tamil"

  # Education
  "tamil college admission enquiry"
  "tamil school parent teacher meeting tamil"
  "tamil online class complaint tamil"
  "tamil coaching centre enquiry tamil"

  # Real estate / rental
  "tamil house rental enquiry tamil"
  "tamil landlord complaint tamil"
  "tamil maintenance complaint tamil"

  # General service
  "tamil service request call"
  "tamil complaint resolved tamil"
  "tamil feedback call tamil"
  "tamil survey call tamil"
  "tamil IVR menu tamil"
  "tamil customer satisfaction call tamil"
)

echo ""
echo "PART 1: Downloading from ${#QUERIES[@]} YouTube search queries..."
echo ""

TOTAL=0
for query in "${QUERIES[@]}"; do
  echo ""
  echo "--- Query: $query ---"

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

  count=$(find "$OUT_DIR" -name "*.wav" 2>/dev/null | wc -l)
  echo "  [Progress: $count WAV files so far]"
  TOTAL=$count

  if [ $TOTAL -ge 600 ]; then
    echo ""
    echo "Reached 600+ files, stopping YouTube downloads."
    break
  fi
done

echo ""
echo "=============================================="
echo "YouTube download complete: $TOTAL files"
echo "=============================================="

# ============================================================
# PART 2: Open datasets with Tamil conversations
# ============================================================
echo ""
echo "PART 2: Downloading open Tamil conversation datasets..."
echo ""

DATASET_DIR="$OUT_DIR/Datasets"
mkdir -p "$DATASET_DIR"

# Mozilla Common Voice Tamil (conversational speech)
echo "--- Mozilla Common Voice Tamil ---"
if [ ! -d "$DATASET_DIR/common_voice_ta" ]; then
  mkdir -p "$DATASET_DIR/common_voice_ta"
  # Common Voice requires login, but clips are available
  # Using the direct clips URL if available
  CV_URL="https://mozilla-common-voice-datasets.s3.dualstack.us-west-2.amazonaws.com/cv-corpus-16.1-2023-12-25/ta.tar.gz"
  echo "Downloading Common Voice Tamil (this may take a while)..."
  curl -L --max-time 3600 -o "$DATASET_DIR/cv_ta.tar.gz" "$CV_URL" 2>&1 | tail -3
  if [ -f "$DATASET_DIR/cv_ta.tar.gz" ] && [ $(stat -f%z "$DATASET_DIR/cv_ta.tar.gz" 2>/dev/null || echo 0) -gt 1000000 ]; then
    tar xzf "$DATASET_DIR/cv_ta.tar.gz" -C "$DATASET_DIR/common_voice_ta" --strip-components=1 2>/dev/null
    # Convert clips to WAV 16kHz mono
    if [ -d "$DATASET_DIR/common_voice_ta/clips" ]; then
      find "$DATASET_DIR/common_voice_ta/clips" -name "*.mp3" | while read f; do
        base=$(basename "$f" .mp3)
        ffmpeg -y -i "$f" -ar 16000 -ac 1 "$DATASET_DIR/common_voice_ta/${base}.wav" 2>/dev/null
      done
      echo "Common Voice Tamil converted."
    fi
    rm -f "$DATASET_DIR/cv_ta.tar.gz"
  else
    echo "Common Voice download failed or too small, skipping."
    rm -f "$DATASET_DIR/cv_ta.tar.gz"
  fi
else
  echo "Common Voice Tamil already exists, skipping."
fi

# IndicTTS - IIT Madras Tamil speech corpus
echo ""
echo "--- IndicTTS Tamil (IIT Madras) ---"
if [ ! -d "$DATASET_DIR/indictts_ta" ]; then
  mkdir -p "$DATASET_DIR/indictts_ta"
  # IndicTTS has Tamil speech data
  IT_URL="https://www.iitm.ac.in/donlab/tts/database/indicTTS_Tamil.tar.gz"
  echo "Downloading IndicTTS Tamil..."
  curl -L --max-time 1800 -o "$DATASET_DIR/indictts_ta.tar.gz" "$IT_URL" 2>&1 | tail -3
  if [ -f "$DATASET_DIR/indictts_ta.tar.gz" ] && [ $(stat -f%z "$DATASET_DIR/indictts_ta.tar.gz" 2>/dev/null || echo 0) -gt 1000000 ]; then
    tar xzf "$DATASET_DIR/indictts_ta.tar.gz" -C "$DATASET_DIR/indictts_ta" --strip-components=1 2>/dev/null
    # Convert any non-wav files
    find "$DATASET_DIR/indictts_ta" -name "*.wav" -exec ffmpeg -y -i {} -ar 16000 -ac 1 "{}.16k.wav" \; 2>/dev/null
    rm -f "$DATASET_DIR/indictts_ta.tar.gz"
    echo "IndicTTS Tamil downloaded."
  else
    echo "IndicTTS download failed, skipping."
    rm -f "$DATASET_DIR/indictts_ta.tar.gz"
  fi
else
  echo "IndicTTS Tamil already exists, skipping."
fi

# AI4Bharat Shruti - Tamil conversational speech
echo ""
echo "--- AI4Bharat Shruti Tamil ---"
if [ ! -d "$DATASET_DIR/shruti_ta" ]; then
  mkdir -p "$DATASET_DIR/shruti_ta"
  # Shruti dataset from AI4Bharat
  SHRUTI_URL="https://storage.googleapis.com/shruti-public-datasets/shruti_ta.tar.gz"
  echo "Downloading Shruti Tamil..."
  curl -L --max-time 1800 -o "$DATASET_DIR/shruti_ta.tar.gz" "$SHRUTI_URL" 2>&1 | tail -3
  if [ -f "$DATASET_DIR/shruti_ta.tar.gz" ] && [ $(stat -f%z "$DATASET_DIR/shruti_ta.tar.gz" 2>/dev/null || echo 0) -gt 1000000 ]; then
    tar xzf "$DATASET_DIR/shruti_ta.tar.gz" -C "$DATASET_DIR/shruti_ta" --strip-components=1 2>/dev/null
    find "$DATASET_DIR/shruti_ta" -name "*.wav" | head -5
    rm -f "$DATASET_DIR/shruti_ta.tar.gz"
    echo "Shruti Tamil downloaded."
  else
    echo "Shruti download failed, skipping."
    rm -f "$DATASET_DIR/shruti_ta.tar.gz"
  fi
else
  echo "Shruti Tamil already exists, skipping."
fi

# Kathbath dataset (AI4Bharat) - Tamil conversational
echo ""
echo "--- AI4Bharat Kathbath Tamil ---"
if [ ! -d "$DATASET_DIR/kathbath_ta" ]; then
  mkdir -p "$DATASET_DIR/kathbath_ta"
  KATHBATH_URL="https://storage.googleapis.com/kathbath/kathbath_ta.tar.gz"
  echo "Downloading Kathbath Tamil..."
  curl -L --max-time 1800 -o "$DATASET_DIR/kathbath_ta.tar.gz" "$KATHBATH_URL" 2>&1 | tail -3
  if [ -f "$DATASET_DIR/kathbath_ta.tar.gz" ] && [ $(stat -f%z "$DATASET_DIR/kathbath_ta.tar.gz" 2>/dev/null || echo 0) -gt 1000000 ]; then
    tar xzf "$DATASET_DIR/kathbath_ta.tar.gz" -C "$DATASET_DIR/kathbath_ta" --strip-components=1 2>/dev/null
    rm -f "$DATASET_DIR/kathbath_ta.tar.gz"
    echo "Kathbath Tamil downloaded."
  else
    echo "Kathbath download failed, skipping."
    rm -f "$DATASET_DIR/kathbath_ta.tar.gz"
  fi
else
  echo "Kathbath Tamil already exists, skipping."
fi

echo ""
echo "=============================================="
echo "FINAL COUNTS"
echo "=============================================="
echo "Customer service WAV (top level):"
find "$OUT_DIR" -maxdepth 1 -name "*.wav" | wc -l
echo "Dataset WAV files:"
find "$DATASET_DIR" -name "*.wav" 2>/dev/null | wc -l
echo "TOTAL WAV files:"
find "$OUT_DIR" -name "*.wav" 2>/dev/null | wc -l
echo "Total size:"
du -sh "$OUT_DIR"
echo "=============================================="
