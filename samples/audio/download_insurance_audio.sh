#!/bin/bash
# Mass download Tamil insurance + customer support audio from ALL sources
# Target: 1000+ WAV files for ASR training
# Output: /Volumes/Extreme SSD/Recordings/Audio/Insurance/

set -e

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio/Insurance"
mkdir -p "$OUT_DIR"

LOG="$OUT_DIR/download.log"
echo "=== Tamil Insurance Audio Download ===" > "$LOG"
echo "Started: $(date)" >> "$LOG"

TOTAL=0
SUCCESS=0
FAIL=0
SKIP=0

download_yt_search() {
  local query="$1"
  local max_results="${2:-50}"
  local prefix="$3"

  echo "" >> "$LOG"
  echo "--- Search: $query (max $max_results) ---" >> "$LOG"

  # Use yt-dlp search to find videos, download audio
  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    --max-downloads "$max_results" \
    --min-filesize 100k \
    --max-filesize 500M \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    --sleep-interval 2 \
    --max-sleep-interval 5 \
    --output "$OUT_DIR/${prefix}_%(autonumber)s_%(title).50s.%(ext)s" \
    "ytsearch${max_results}:${query}" 2>&1 | while IFS= read -r line; do
      echo "$line" >> "$LOG"
      if echo "$line" | grep -q "Already downloaded"; then
        SKIP=$((SKIP + 1))
      elif echo "$line" | grep -q "Destination:"; then
        SUCCESS=$((SUCCESS + 1))
      elif echo "$line" | grep -q "ERROR"; then
        FAIL=$((FAIL + 1))
      fi
    done
}

echo "=============================================="
echo "Phase 1: YouTube Search - Insurance Specific"
echo "=============================================="

# LIC specific
download_yt_search "LIC agent call tamil" 50 "lic"
download_yt_search "LIC policy renewal call tamil" 50 "lic_renewal"
download_yt_search "LIC premium payment tamil" 50 "lic_premium"
download_yt_search "LIC claim settlement tamil" 50 "lic_claim"
download_yt_search "LIC maturity amount tamil" 50 "lic_maturity"
download_yt_search "LIC survival benefit tamil" 50 "lic_sb"
download_yt_search "LIC policy surrender tamil" 50 "lic_surrender"
download_yt_search "LIC agent commission tamil" 30 "lic_commission"
download_yt_search "LIC new policy tamil explanation" 50 "lic_new"
download_yt_search "LIC bond policy tamil" 30 "lic_bond"

# General insurance Tamil
download_yt_search "insurance call tamil customer service" 50 "ins_call"
download_yt_search "insurance claim process tamil" 50 "ins_claim"
download_yt_search "health insurance tamil explained" 50 "health_ins"
download_yt_search "life insurance tamil" 50 "life_ins"
download_yt_search "insurance premium tamil" 50 "ins_premium"
download_yt_search "insurance policy tamil customer" 50 "ins_policy"
download_yt_search "insurance agent tamil sales" 50 "ins_agent"
download_yt_search "insurance fraud call tamil" 30 "ins_fraud"
download_yt_search "motor insurance claim tamil" 30 "motor_ins"
download_yt_search "term insurance tamil" 30 "term_ins"
download_yt_search "insurance misselling tamil" 20 "ins_missell"
download_yt_search "ULIP policy tamil" 20 "ulip"
download_yt_search "endowment policy tamil" 20 "endowment"
download_yt_search "pension plan tamil LIC" 20 "pension"

# Customer service / call center Tamil
download_yt_search "tamil customer service call recording" 50 "cust_svc"
download_yt_search "tamil call center conversation" 50 "call_center"
download_yt_search "bank customer care call tamil" 50 "bank_call"
download_yt_search "tamil telemarketing call" 30 "tele_call"
download_yt_search "customer complaint call tamil" 30 "complaint"
download_yt_search "tamil BPO call recording" 30 "bpo"
download_yt_search "tamil customer care prank call" 30 "prank_call"
download_yt_search "tamil phone banking call" 20 "phone_bank"
download_yt_search "tamil insurance helpline" 20 "helpline"
download_yt_search "tamil policy customer call" 20 "policy_call"

# Sales / service conversations
download_yt_search "insurance sales pitch tamil" 30 "sales_pitch"
download_yt_search "tamil insurance marketing" 30 "marketing"
download_yt_search "policy selling call tamil" 20 "policy_sell"
download_yt_search "tamil insurance awareness" 30 "awareness"
download_yt_search "insurance benefit explanation tamil" 30 "benefit_exp"
download_yt_search "tamil insurance review" 20 "ins_review"
download_yt_search "LIC review tamil" 20 "lic_review"
download_yt_search "insurance comparison tamil" 20 "ins_compare"

# Banking + insurance (bancassurance)
download_yt_search "bancassurance tamil" 20 "banca"
download_yt_search "bank insurance tamil" 30 "bank_ins"
download_yt_search "SBI life insurance tamil" 20 "sbi_life"
download_yt_search "HDFC life insurance tamil" 20 "hdfc_life"
download_yt_search "tamil nadu insurance" 20 "tn_insurance"

# Tamil script searches (better results for native content)
download_yt_search "இன்சூரன்ஸ் தமிழ்" 50 "ta_ins"
download_yt_search "LIC ஏஜெண்ட் தமிழ்" 50 "ta_lic_agent"
download_yt_search "இன்சூரன்ஸ் கிளைம் தமிழ்" 30 "ta_claim"
download_yt_search "பாலிசி ரினுவல் தமிழ்" 30 "ta_renewal"
download_yt_search "பிரீமியம் கட்டணம் தமிழ்" 30 "ta_premium"
download_yt_search "இன்சூரன்ஸ் ஏஜெண்ட் விற்பனை" 30 "ta_agent_sale"
download_yt_search "LIC பாலிசி தமிழ்" 50 "ta_lic_policy"
download_yt_search "இன்சூரன்ஸ் விழிப்புணர்வு தமிழ்" 30 "ta_awareness"
download_yt_search "காப்பீடு தமிழ்" 50 "ta_kappeedu"
download_yt_search "லைஃப் இன்சூரன்ஸ் தமிழ்" 30 "ta_life_ins"
download_yt_search "ஹெல்த் இன்சூரன்ஸ் தமிழ்" 30 "ta_health_ins"
download_yt_search "இன்சூரன்ஸ் சேலஸ் தமிழ்" 20 "ta_ins_sales"
download_yt_search "கஸ்டமர் கேர் கால் தமிழ்" 30 "ta_cust_care"
download_yt_search "கால் சென்டர் தமிழ்" 30 "ta_call_center"
download_yt_search "பேங்க் கஸ்டமர் கேர் தமிழ்" 30 "ta_bank_care"
download_yt_search "LIC மேச்சூரிட்டி தமிழ்" 20 "ta_maturity"
download_yt_search "பான்சி சரெண்டர் தமிழ்" 20 "ta_surrender"
download_yt_search "இன்சூரன்ஸ் மோசடி தமிழ்" 20 "ta_fraud"
download_yt_search "டெலிமார்கெட்டிங் கால் தமிழ்" 20 "ta_tele"
download_yt_search "பிஓபிஓ கால் தமிழ்" 20 "ta_bpo"

# More English queries - specific scenarios
download_yt_search "how to sell insurance tamil" 30 "how_sell"
download_yt_search "insurance agent training tamil" 30 "agent_training"
download_yt_search "LIC exam preparation tamil" 20 "lic_exam"
download_yt_search "IRDAI insurance regulation tamil" 20 "irdai"
download_yt_search "insurance document verification tamil" 20 "doc_verify"
download_yt_search "nominee claim tamil" 20 "nominee"
download_yt_search "insurance death claim tamil" 20 "death_claim"
download_yt_search "policy loan tamil LIC" 20 "policy_loan"
download_yt_search "insurance tax benefit tamil" 20 "tax_benefit"
download_yt_search "80C insurance tamil" 20 "80c"
download_yt_search "Jeevan Anand tamil" 20 "jeevan_anand"
download_yt_search "Jeevan Labh tamil" 20 "jeevan_labh"
download_yt_search "New Jeevan Mitra tamil" 20 "njm"
download_yt_search "LIC Kanyadanam tamil" 20 "kanyadanam"
download_yt_search "LIC Children Money Back tamil" 20 "children_mb"
download_yt_search "Atal Pension Yojana tamil" 20 "apm"
download_yt_search "PM Jeevan Jyoti tamil" 20 "pmjjby"
download_yt_search "PM Suraksha Bima tamil" 20 "pmsby"
download_yt_search "Ayushman Bharat insurance tamil" 20 "ayushman"
download_yt_search "tamil insurance webinar" 20 "webinar"
download_yt_search "insurance townhall tamil" 20 "townhall"
download_yt_search "LIC branch meeting tamil" 20 "branch_mt"
download_yt_search "insurance agency development tamil" 20 "agency_dev"
download_yt_search "tamil insurance motivational" 20 "motivation"
download_yt_search "LIC advisor meeting tamil" 20 "advisor_mt"
download_yt_search "insurance prospect call tamil" 20 "prospect"
download_yt_search "cold calling insurance tamil" 20 "cold_call"
download_yt_search "insurance objection handling tamil" 20 "objection"
download_yt_search "insurance closing tamil" 20 "closing"
download_yt_search "tamil insurance customer follow up" 20 "followup"

# Regional + mixed
download_yt_search "insurance agent madurai tamil" 20 "madurai_ins"
download_yt_search "insurance coimbatore tamil" 20 "cbe_ins"
download_yt_search "insurance chennai tamil" 20 "chn_ins"
download_yt_search "insurance tirunelveli tamil" 20 "tiv_ins"
download_yt_search "insurance trichy tamil" 20 "trichy_ins"
download_yt_search "insurance Salem tamil" 20 "salem_ins"

echo ""
echo "=============================================="
echo "Phase 1 Complete"
echo "Files so far:"
ls "$OUT_DIR"/*.wav 2>/dev/null | wc -l
echo "=============================================="
