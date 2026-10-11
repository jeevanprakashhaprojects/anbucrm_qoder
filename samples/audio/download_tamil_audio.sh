#!/bin/bash
# Download Tamil conversation audio from YouTube for ASR training
# Output: 16kHz mono WAV in /Volumes/Extreme SSD/Recordings/Audio/

OUT_DIR="/Volumes/Extreme SSD/Recordings/Audio"
mkdir -p "$OUT_DIR"

# Curated list: actual Tamil conversations (customer care, phone calls, talk shows)
# Format: video_id|label
VIDEOS=(
  # Customer care call recordings
  "cpoPJBOfEic|loan_call_with_customer"
  "Ry5U1o9xpHw|tamil_customer_care_funny_calls_aadhaar"
  "Ux5uuk4S3oc|aircel_customer_care_tamil"
  "v09nrWzXbt8|funny_customer_care_call_tamil"
  "flPax5gqHY8|airtel_customer_care_funny_tamil"
  "x_sbd1FUGZM|airtel_customer_care_madurai_tamil"
  "LymEz3BDTVY|customer_care_funny_talk_prank"
  "Y97rSnDTU4A|fake_bank_call_tamil"
  "1oAaUbI17nQ|bank_fraud_atm_tamil"
  "-eq_BI17UwM|tamil_customer_care_comedy"
  "CLQ78ODw6tU|customer_care_prank_gone_high"
  "oGIWHANhzSM|airtel_funny_audio_coimbatore"
  "s6MvH26-RxQ|atm_card_number_fraud_tamil"
  "GDCrvh-Uigo|fake_mobile_sales_fraud_tamil"
  "ZscRnD12iu8|matrimony_customer_care_kanyakumari"
  "EdSpxFR8GX8|loan_recovery_call_comedy_tamil"
  "97euzZvblIk|bajaj_finance_loan_recovery_call"
  "0rvkM1xjWJQ|ola_customer_care_driver_tamil"
  "KNAFwMjB55A|loan_scam_fake_bank_call_tamil"
  "l77TIZ2r_tM|fake_bank_atm_card_tamil"

  # Phone call conversations
  "RN8r185ulw4|rj_balaji_chennai_girl_funny_talk"
  "Uh42ifuEmJM|cute_aunty_phone_call_conversation"
  "b8fIT-2kodk|tamil_phone_call_talk_lovers"
  "MrCoR9DkDEY|housewife_phone_call_audio_tamil"
  "j6U8T5sQ9RI|tamil_girl_live_phone_call"
  "wbJrPHQAFrA|first_time_phone_call_girl_tamil"
  "GVPjjazqha0|tamil_romantic_phone_call_audio"
  "CiwPVhLrmfc|friend_app_unexpected_call_tamil"
  "mVvriIrY-Iw|tamil_sad_phone_call"
  "v6wadWKPTdY|tamil_lovers_talk"
  "KowIVZ2rEYs|irunga_bhai_original_audio"
  "0WymDEr5RTM|real_scammer_call_recording"
  "X1jyB0_RjtM|star_prank_call_tamil"

  # Talk shows / real conversations
  "mfKT-TIUi-Y|solvathellam_unmai_phone_conversation"
  "sjHNQmX0TLA|tamizha_tamizha_s3_webisode"
  "wMmcMFKSbiw|tamizha_tamizha_best_scene"
  "uAs0yo59wnM|tamizha_tamizha_s3_ep106"
  "iLrs5sBdE6M|two_girls_tamil_conversation"
  "wmLsfc1WSxY|solvathellam_unmai_ep492"
  "9Bb00MpTZsk|solvathellam_unmai_heavy_performance"
  "zwdIUdPu6Qg|solvathellam_unmai_dramatic_scene"
  "aGvAx7y1tek|solvathellam_unmai_ep254"
  "bkEP4KHSsUI|talking_another_girl_prank_tamil"

  # Insurance / bank related
  "Pmt7F-yCWEg|sell_health_insurance_phone_call"
  "so-IS1rWIlA|insurance_claim_details_tamil"
  "H9Nb1mQJBro|bpo_jobs_reality_tamil"
  "WSsHZx4xwR0|tamil_actors_call_centre"

  # Sales / service conversations
  "jhCpIhZgC2c|sales_training_tamil_strategies"
  "NeH8uVxBWsg|coimbatore_telemarketing_tamil"
  "SBf9ZjkhBgM|village_loan_comedy_tamil"
  "n31r1af790c|vodafone_customer_service_funny"
  "Gf9tKb7D9J0|raghuvaran_airtel_bad_words"
)

echo "=============================================="
echo "Downloading ${#VIDEOS[@]} Tamil conversation audio files"
echo "Output: $OUT_DIR"
echo "=============================================="

SUCCESS=0
FAIL=0

for entry in "${VIDEOS[@]}"; do
  IFS='|' read -r vid label <<< "$entry"
  outfile="$OUT_DIR/${label}.wav"

  if [ -f "$outfile" ]; then
    echo "[SKIP] $label (already exists)"
    SUCCESS=$((SUCCESS + 1))
    continue
  fi

  echo ""
  echo "[DOWNLOAD] $label ($vid)..."

  # Download audio only, best quality, convert to WAV 16kHz mono
  yt-dlp \
    -x \
    --audio-format wav \
    --audio-quality 0 \
    --postprocessor-args "ffmpeg:-ar 16000 -ac 1" \
    -o "$OUT_DIR/${label}.%(ext)s" \
    --no-playlist \
    --no-overwrites \
    --socket-timeout 30 \
    --retries 3 \
    "https://www.youtube.com/watch?v=$vid" 2>&1 | tail -3

  if [ $? -eq 0 ]; then
    echo "[OK] $label"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "[FAIL] $label"
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "=============================================="
echo "Download complete: $SUCCESS succeeded, $FAIL failed"
echo "Files in: $OUT_DIR"
echo "=============================================="
ls -lh "$OUT_DIR"/*.wav 2>/dev/null | wc -l
echo "WAV files total"
