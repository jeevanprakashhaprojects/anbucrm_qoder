import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../core/app_export.dart';
import 'package:go_router/go_router.dart';

// Precomputed text styles — resolved once, reused on every rebuild.
// GoogleFonts resolution is expensive; calling it on every keystroke caused
// visible typing lag on pre-login screens.
class _S {
  static final _base = GoogleFonts.plusJakartaSans();

  static final fieldText = _base.copyWith(fontSize: 14);
  static final fieldLabel = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  static final suffixText = _base.copyWith(
    fontSize: 11,
    color: AppTheme.textMuted,
  );
  static final hintText = _base.copyWith(
    fontSize: 14,
    color: AppTheme.textMuted,
  );
  static final sectionTitle = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppTheme.textPrimary,
    letterSpacing: -0.5,
  );
  static final sectionSubtitle = _base.copyWith(
    fontSize: 13,
    color: AppTheme.textSecondary,
    height: 1.5,
  );
  static final pickerTitle = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppTheme.textPrimary,
  );
  static final countryName = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppTheme.textPrimary,
  );
  static final countryNameSelected = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppTheme.primary,
  );
  static final countryCode = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
  );
  static final countryCodeSelected = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  static final stepIndicatorLabel = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  static final stepCircleLabel = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppTheme.textMuted,
  );
  static final stepCircleLabelActive = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  static final dialCodeText = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  static final phonePreview = _base.copyWith(
    fontSize: 11,
    color: AppTheme.primary,
    fontWeight: FontWeight.w500,
  );
  static final strengthLabelWeak = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.error,
  );
  static final strengthLabelFair = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFD97706),
  );
  static final strengthLabelGood = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF0EA5E9),
  );
  static final strengthLabelStrong = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.success,
  );
  static final termsText = _base.copyWith(
    fontSize: 13,
    color: AppTheme.textSecondary,
    height: 1.4,
  );
  static final termsLink = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
    decoration: TextDecoration.underline,
  );
  static final snackBarText = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static final snackBarSimple = _base.copyWith(fontSize: 13);
  static final secondaryText13 = _base.copyWith(
    fontSize: 13,
    color: AppTheme.textSecondary,
  );
  static final primaryLink13 = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppTheme.primary,
  );
  static final reviewCardTitle = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppTheme.textPrimary,
  );
  static final editLink = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  static final reviewLabel = _base.copyWith(
    fontSize: 12,
    color: AppTheme.textSecondary,
  );
  static final reviewValue = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  static final planTitle = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  static final planSubtitle = _base.copyWith(
    fontSize: 12,
    color: const Color(0xC8FFFFFF),
  );
  static final priceText = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
  static final priceSuffix = _base.copyWith(
    fontSize: 11,
    color: const Color(0xC8FFFFFF),
  );
  static final paymentTitle = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppTheme.textPrimary,
  );
  static final paymentSubtitle = _base.copyWith(
    fontSize: 14,
    color: AppTheme.textSecondary,
    height: 1.45,
  );
  static final sslText = _base.copyWith(
    fontSize: 11,
    color: AppTheme.textSecondary,
    fontWeight: FontWeight.w500,
  );
  static final tryAgainLabel = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  static final backToReviewLabel = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
  );
  static final successTitle = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppTheme.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static final successBody = _base.copyWith(
    fontSize: 14,
    color: AppTheme.textSecondary,
    height: 1.6,
  );
  static final successDetailLabel = _base.copyWith(
    fontSize: 13,
    color: AppTheme.textSecondary,
  );
  static final successDetailValue = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  static final successSectionTitle = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppTheme.textPrimary,
  );
  static final successDiscountLabel = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.success,
  );
  static final successDiscountCode = _base.copyWith(
    fontSize: 12,
    color: AppTheme.success,
  );
  static final successStatusBadge = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  static final statCardLabel = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppTheme.textSecondary,
  );
  static final statCardValue = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppTheme.textPrimary,
  );
  static final ruleTextMet = _base.copyWith(
    fontSize: 12,
    color: AppTheme.success,
    fontWeight: FontWeight.w500,
  );
  static final ruleTextUnmet = _base.copyWith(
    fontSize: 12,
    color: AppTheme.textSecondary,
    fontWeight: FontWeight.w400,
  );
  static final buttonLabel = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  static final buttonLabelDisabled = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppTheme.textMuted,
  );
}

// ─── Country Data ─────────────────────────────────────────────────────────────

class _Country {
  final String name;
  final String code;
  final String flag;
  const _Country(this.name, this.code, this.flag);
}

const List<_Country> _kCountries = [
  _Country('Afghanistan', '+93', '🇦🇫'),
  _Country('Albania', '+355', '🇦🇱'),
  _Country('Algeria', '+213', '🇩🇿'),
  _Country('Andorra', '+376', '🇦🇩'),
  _Country('Angola', '+244', '🇦🇴'),
  _Country('Antigua & Barbuda', '+1', '🇦🇬'),
  _Country('Argentina', '+54', '🇦🇷'),
  _Country('Armenia', '+374', '🇦🇲'),
  _Country('Australia', '+61', '🇦🇺'),
  _Country('Austria', '+43', '🇦🇹'),
  _Country('Azerbaijan', '+994', '🇦🇿'),
  _Country('Bahamas', '+1', '🇧🇸'),
  _Country('Bahrain', '+973', '🇧🇭'),
  _Country('Bangladesh', '+880', '🇧🇩'),
  _Country('Barbados', '+1', '🇧🇧'),
  _Country('Belarus', '+375', '🇧🇾'),
  _Country('Belgium', '+32', '🇧🇪'),
  _Country('Belize', '+501', '🇧🇿'),
  _Country('Benin', '+229', '🇧🇯'),
  _Country('Bhutan', '+975', '🇧🇹'),
  _Country('Bolivia', '+591', '🇧🇴'),
  _Country('Bosnia & Herzegovina', '+387', '🇧🇦'),
  _Country('Botswana', '+267', '🇧🇼'),
  _Country('Brazil', '+55', '🇧🇷'),
  _Country('Brunei', '+673', '🇧🇳'),
  _Country('Bulgaria', '+359', '🇧🇬'),
  _Country('Burkina Faso', '+226', '🇧🇫'),
  _Country('Burundi', '+257', '🇧🇮'),
  _Country('Cabo Verde', '+238', '🇨🇻'),
  _Country('Cambodia', '+855', '🇰🇭'),
  _Country('Cameroon', '+237', '🇨🇲'),
  _Country('Canada', '+1', '🇨🇦'),
  _Country('Central African Republic', '+236', '🇨🇫'),
  _Country('Chad', '+235', '🇹🇩'),
  _Country('Chile', '+56', '🇨🇱'),
  _Country('China', '+86', '🇨🇳'),
  _Country('Colombia', '+57', '🇨🇴'),
  _Country('Comoros', '+269', '🇰🇲'),
  _Country('Congo (DRC)', '+243', '🇨🇩'),
  _Country('Congo (Republic)', '+242', '🇨🇬'),
  _Country('Costa Rica', '+506', '🇨🇷'),
  _Country('Ivory Coast', '+225', '🇨🇮'),
  _Country('Croatia', '+385', '🇭🇷'),
  _Country('Cuba', '+53', '🇨🇺'),
  _Country('Cyprus', '+357', '🇨🇾'),
  _Country('Czech Republic', '+420', '🇨🇿'),
  _Country('Denmark', '+45', '🇩🇰'),
  _Country('Djibouti', '+253', '🇩🇯'),
  _Country('Dominica', '+1', '🇩🇲'),
  _Country('Dominican Republic', '+1', '🇩🇴'),
  _Country('Ecuador', '+593', '🇪🇨'),
  _Country('Egypt', '+20', '🇪🇬'),
  _Country('El Salvador', '+503', '🇸🇻'),
  _Country('Equatorial Guinea', '+240', '🇬🇶'),
  _Country('Eritrea', '+291', '🇪🇷'),
  _Country('Estonia', '+372', '🇪🇪'),
  _Country('Eswatini', '+268', '🇸🇿'),
  _Country('Ethiopia', '+251', '🇪🇹'),
  _Country('Fiji', '+679', '🇫🇯'),
  _Country('Finland', '+358', '🇫🇮'),
  _Country('France', '+33', '🇫🇷'),
  _Country('Gabon', '+241', '🇬🇦'),
  _Country('Gambia', '+220', '🇬🇲'),
  _Country('Georgia', '+995', '🇬🇪'),
  _Country('Germany', '+49', '🇩🇪'),
  _Country('Ghana', '+233', '🇬🇭'),
  _Country('Greece', '+30', '🇬🇷'),
  _Country('Grenada', '+1', '🇬🇩'),
  _Country('Guatemala', '+502', '🇬🇹'),
  _Country('Guinea', '+224', '🇬🇳'),
  _Country('Guinea-Bissau', '+245', '🇬🇼'),
  _Country('Guyana', '+592', '🇬🇾'),
  _Country('Haiti', '+509', '🇭🇹'),
  _Country('Honduras', '+504', '🇭🇳'),
  _Country('Hungary', '+36', '🇭🇺'),
  _Country('Iceland', '+354', '🇮🇸'),
  _Country('India', '+91', '🇮🇳'),
  _Country('Indonesia', '+62', '🇮🇩'),
  _Country('Iran', '+98', '🇮🇷'),
  _Country('Iraq', '+964', '🇮🇶'),
  _Country('Ireland', '+353', '🇮🇪'),
  _Country('Israel', '+972', '🇮🇱'),
  _Country('Italy', '+39', '🇮🇹'),
  _Country('Jamaica', '+1', '🇯🇲'),
  _Country('Japan', '+81', '🇯🇵'),
  _Country('Jordan', '+962', '🇯🇴'),
  _Country('Kazakhstan', '+7', '🇰🇿'),
  _Country('Kenya', '+254', '🇰🇪'),
  _Country('Kiribati', '+686', '🇰🇮'),
  _Country('Kosovo', '+383', '🇽🇰'),
  _Country('Kuwait', '+965', '🇰🇼'),
  _Country('Kyrgyzstan', '+996', '🇰🇬'),
  _Country('Laos', '+856', '🇱🇦'),
  _Country('Latvia', '+371', '🇱🇻'),
  _Country('Lebanon', '+961', '🇱🇧'),
  _Country('Lesotho', '+266', '🇱🇸'),
  _Country('Liberia', '+231', '🇱🇷'),
  _Country('Libya', '+218', '🇱🇾'),
  _Country('Liechtenstein', '+423', '🇱🇮'),
  _Country('Lithuania', '+370', '🇱🇹'),
  _Country('Luxembourg', '+352', '🇱🇺'),
  _Country('Madagascar', '+261', '🇲🇬'),
  _Country('Malawi', '+265', '🇲🇼'),
  _Country('Malaysia', '+60', '🇲🇾'),
  _Country('Maldives', '+960', '🇲🇻'),
  _Country('Mali', '+223', '🇲🇱'),
  _Country('Malta', '+356', '🇲🇹'),
  _Country('Marshall Islands', '+692', '🇲🇭'),
  _Country('Mauritania', '+222', '🇲🇷'),
  _Country('Mauritius', '+230', '🇲🇺'),
  _Country('Mexico', '+52', '🇲🇽'),
  _Country('Micronesia', '+691', '🇫🇲'),
  _Country('Moldova', '+373', '🇲🇩'),
  _Country('Monaco', '+377', '🇲🇨'),
  _Country('Mongolia', '+976', '🇲🇳'),
  _Country('Montenegro', '+382', '🇲🇪'),
  _Country('Morocco', '+212', '🇲🇦'),
  _Country('Mozambique', '+258', '🇲🇿'),
  _Country('Myanmar', '+95', '🇲🇲'),
  _Country('Namibia', '+264', '🇳🇦'),
  _Country('Nauru', '+674', '🇳🇷'),
  _Country('Nepal', '+977', '🇳🇵'),
  _Country('Netherlands', '+31', '🇳🇱'),
  _Country('New Zealand', '+64', '🇳🇿'),
  _Country('Nicaragua', '+505', '🇳🇮'),
  _Country('Niger', '+227', '🇳🇪'),
  _Country('Nigeria', '+234', '🇳🇬'),
  _Country('North Korea', '+850', '🇰🇵'),
  _Country('North Macedonia', '+389', '🇲🇰'),
  _Country('Norway', '+47', '🇳🇴'),
  _Country('Oman', '+968', '🇴🇲'),
  _Country('Pakistan', '+92', '🇵🇰'),
  _Country('Palau', '+680', '🇵🇼'),
  _Country('Palestine', '+970', '🇵🇸'),
  _Country('Panama', '+507', '🇵🇦'),
  _Country('Papua New Guinea', '+675', '🇵🇬'),
  _Country('Paraguay', '+595', '🇵🇾'),
  _Country('Peru', '+51', '🇵🇪'),
  _Country('Philippines', '+63', '🇵🇭'),
  _Country('Poland', '+48', '🇵🇱'),
  _Country('Portugal', '+351', '🇵🇹'),
  _Country('Qatar', '+974', '🇶🇦'),
  _Country('Romania', '+40', '🇷🇴'),
  _Country('Russia', '+7', '🇷🇺'),
  _Country('Rwanda', '+250', '🇷🇼'),
  _Country('Saint Kitts & Nevis', '+1', '🇰🇳'),
  _Country('Saint Lucia', '+1', '🇱🇨'),
  _Country('Saint Vincent & Grenadines', '+1', '🇻🇨'),
  _Country('Samoa', '+685', '🇼🇸'),
  _Country('San Marino', '+378', '🇸🇲'),
  _Country('São Tomé & Príncipe', '+239', '🇸🇹'),
  _Country('Saudi Arabia', '+966', '🇸🇦'),
  _Country('Senegal', '+221', '🇸🇳'),
  _Country('Serbia', '+381', '🇷🇸'),
  _Country('Seychelles', '+248', '🇸🇨'),
  _Country('Sierra Leone', '+232', '🇸🇱'),
  _Country('Singapore', '+65', '🇸🇬'),
  _Country('Slovakia', '+421', '🇸🇰'),
  _Country('Slovenia', '+386', '🇸🇮'),
  _Country('Solomon Islands', '+677', '🇸🇧'),
  _Country('Somalia', '+252', '🇸🇴'),
  _Country('South Africa', '+27', '🇿🇦'),
  _Country('South Korea', '+82', '🇰🇷'),
  _Country('South Sudan', '+211', '🇸🇸'),
  _Country('Spain', '+34', '🇪🇸'),
  _Country('Sri Lanka', '+94', '🇱🇰'),
  _Country('Sudan', '+249', '🇸🇩'),
  _Country('Suriname', '+597', '🇸🇷'),
  _Country('Sweden', '+46', '🇸🇪'),
  _Country('Switzerland', '+41', '🇨🇭'),
  _Country('Syria', '+963', '🇸🇾'),
  _Country('Taiwan', '+886', '🇹🇼'),
  _Country('Tajikistan', '+992', '🇹🇯'),
  _Country('Tanzania', '+255', '🇹🇿'),
  _Country('Thailand', '+66', '🇹🇭'),
  _Country('Timor-Leste', '+670', '🇹🇱'),
  _Country('Togo', '+228', '🇹🇬'),
  _Country('Tonga', '+676', '🇹🇴'),
  _Country('Trinidad & Tobago', '+1', '🇹🇹'),
  _Country('Tunisia', '+216', '🇹🇳'),
  _Country('Turkey', '+90', '🇹🇷'),
  _Country('Turkmenistan', '+993', '🇹🇲'),
  _Country('Tuvalu', '+688', '🇹🇻'),
  _Country('Uganda', '+256', '🇺🇬'),
  _Country('Ukraine', '+380', '🇺🇦'),
  _Country('United Arab Emirates', '+971', '🇦🇪'),
  _Country('United Kingdom', '+44', '🇬🇧'),
  _Country('United States', '+1', '🇺🇸'),
  _Country('Uruguay', '+598', '🇺🇾'),
  _Country('Uzbekistan', '+998', '🇺🇿'),
  _Country('Vanuatu', '+678', '🇻🇺'),
  _Country('Vatican City', '+379', '🇻🇦'),
  _Country('Venezuela', '+58', '🇻🇪'),
  _Country('Vietnam', '+84', '🇻🇳'),
  _Country('Yemen', '+967', '🇾🇪'),
  _Country('Zambia', '+260', '🇿🇲'),
  _Country('Zimbabwe', '+263', '🇿🇼'),
];

final RegExp _kEmailRegex = RegExp(
  r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,}$',
);

// Expected digit count after the dial code, per country code ([min, max]).
const Map<String, List<int>> _kCodeLengths = {
  '+1': [10, 10],
  '+7': [10, 10],
  '+20': [10, 10],
  '+27': [9, 9],
  '+30': [10, 10],
  '+31': [9, 9],
  '+32': [9, 9],
  '+33': [9, 9],
  '+34': [9, 9],
  '+36': [9, 9],
  '+39': [9, 10],
  '+40': [9, 9],
  '+41': [9, 9],
  '+43': [10, 11],
  '+44': [10, 10],
  '+45': [8, 8],
  '+46': [7, 9],
  '+47': [8, 8],
  '+48': [9, 9],
  '+49': [10, 11],
  '+51': [9, 9],
  '+52': [10, 10],
  '+53': [8, 8],
  '+54': [10, 10],
  '+55': [10, 11],
  '+56': [9, 9],
  '+57': [10, 10],
  '+58': [10, 10],
  '+60': [9, 10],
  '+61': [9, 9],
  '+62': [9, 12],
  '+63': [10, 10],
  '+64': [8, 9],
  '+65': [8, 8],
  '+66': [9, 9],
  '+81': [10, 10],
  '+82': [9, 10],
  '+84': [9, 10],
  '+86': [11, 11],
  '+90': [10, 10],
  '+91': [10, 10],
  '+92': [10, 10],
  '+93': [9, 9],
  '+94': [9, 9],
  '+95': [8, 10],
  '+98': [10, 10],
  '+211': [9, 9],
  '+212': [9, 9],
  '+213': [9, 9],
  '+216': [8, 8],
  '+218': [9, 10],
  '+220': [7, 7],
  '+221': [9, 9],
  '+222': [7, 8],
  '+223': [8, 8],
  '+225': [10, 10],
  '+226': [8, 8],
  '+227': [8, 8],
  '+228': [8, 8],
  '+229': [8, 8],
  '+230': [7, 8],
  '+231': [7, 8],
  '+232': [8, 8],
  '+233': [9, 9],
  '+234': [10, 10],
  '+235': [8, 8],
  '+236': [8, 8],
  '+237': [9, 9],
  '+238': [7, 7],
  '+239': [7, 7],
  '+240': [9, 9],
  '+241': [8, 9],
  '+242': [9, 9],
  '+243': [9, 9],
  '+244': [9, 9],
  '+245': [7, 7],
  '+248': [7, 7],
  '+249': [9, 9],
  '+250': [9, 9],
  '+251': [9, 9],
  '+252': [7, 8],
  '+253': [6, 6],
  '+254': [9, 9],
  '+255': [9, 9],
  '+256': [9, 9],
  '+257': [8, 8],
  '+258': [9, 9],
  '+260': [9, 9],
  '+261': [9, 9],
  '+263': [9, 9],
  '+264': [9, 10],
  '+265': [9, 9],
  '+266': [8, 8],
  '+267': [7, 8],
  '+268': [7, 8],
  '+269': [7, 7],
  '+291': [7, 7],
  '+352': [4, 11],
  '+353': [9, 9],
  '+354': [7, 9],
  '+355': [8, 9],
  '+356': [8, 8],
  '+357': [8, 8],
  '+358': [9, 10],
  '+359': [8, 9],
  '+370': [8, 8],
  '+371': [7, 8],
  '+372': [7, 8],
  '+373': [8, 8],
  '+374': [8, 8],
  '+375': [9, 9],
  '+376': [6, 9],
  '+377': [8, 9],
  '+378': [6, 10],
  '+379': [10, 10],
  '+380': [9, 9],
  '+381': [8, 9],
  '+382': [8, 9],
  '+383': [8, 8],
  '+385': [8, 9],
  '+386': [8, 9],
  '+387': [8, 9],
  '+389': [8, 8],
  '+420': [9, 9],
  '+421': [9, 9],
  '+423': [7, 9],
  '+501': [7, 7],
  '+502': [8, 8],
  '+503': [8, 8],
  '+504': [8, 8],
  '+505': [8, 8],
  '+506': [8, 8],
  '+507': [8, 8],
  '+509': [8, 8],
  '+591': [8, 8],
  '+592': [7, 7],
  '+593': [9, 9],
  '+595': [9, 9],
  '+597': [6, 7],
  '+598': [8, 8],
  '+670': [7, 7],
  '+673': [7, 7],
  '+674': [4, 4],
  '+675': [8, 8],
  '+676': [5, 7],
  '+677': [5, 5],
  '+678': [5, 7],
  '+679': [7, 7],
  '+680': [7, 7],
  '+685': [5, 7],
  '+686': [5, 5],
  '+688': [5, 6],
  '+691': [7, 7],
  '+692': [7, 7],
  '+850': [4, 13],
  '+852': [8, 8],
  '+853': [8, 8],
  '+855': [8, 9],
  '+856': [8, 10],
  '+880': [10, 10],
  '+886': [9, 10],
  '+960': [7, 7],
  '+961': [7, 8],
  '+962': [9, 9],
  '+963': [8, 9],
  '+964': [10, 10],
  '+965': [8, 8],
  '+966': [9, 9],
  '+967': [9, 9],
  '+968': [8, 8],
  '+970': [9, 9],
  '+971': [9, 9],
  '+972': [9, 9],
  '+973': [8, 8],
  '+974': [8, 8],
  '+975': [7, 8],
  '+976': [8, 8],
  '+977': [10, 10],
  '+992': [9, 9],
  '+993': [8, 8],
  '+994': [8, 9],
  '+995': [8, 9],
  '+996': [9, 9],
  '+998': [9, 9],
};

// ─── Country Picker Bottom Sheet ──────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final _Country selected;
  final Function(_Country) onSelect;

  const _CountryPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  List<_Country> _filtered = [];

  static const _india = _Country('India', '+91', '🇮🇳');

  @override
  void initState() {
    super.initState();
    _filtered = [_india, ..._kCountries.where((c) => c.name != 'India')];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String q) {
    final lower = q.toLowerCase();
    setState(() {
      final results = _kCountries
          .where(
            (c) => c.name.toLowerCase().contains(lower) || c.code.contains(q),
          )
          .toList();
      // India always on top when searching
      _filtered = [
        _india,
        ...results.where((c) => c.name != 'India'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sheet takes up to 70% of screen, keyboard doesn't shrink it further.
    // The ListView inside scrolls to show content above the keyboard.
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.70;
    return Container(
      height: sheetHeight.clamp(300.0, 600.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Text('Select Country Code', style: _S.pickerTitle),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              style: _S.fieldText,
              decoration: InputDecoration(
                hintText: 'Search country or code...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppTheme.surface100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final country = _filtered[i];
                final isSelected = country.name == widget.selected.name;
                return ListTile(
                  onTap: () {
                    widget.onSelect(country);
                    Navigator.pop(context);
                  },
                  leading: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    country.name,
                    style: isSelected ? _S.countryNameSelected : _S.countryName,
                  ),
                  trailing: Text(
                    country.code,
                    style: isSelected ? _S.countryCodeSelected : _S.countryCode,
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primary.withAlpha(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with TickerProviderStateMixin {
  int _step = 0; // 0=Personal Info, 1=Security, 2=Review, 3=Payment, 4=Success

  late AnimationController _stepController;
  late Animation<double> _stepOpacity;
  late Animation<Offset> _stepSlide;

  // Personal Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _formattedPhone = '';
  _Country _selectedCountry = _Country('India', '+91', '🇮🇳');

  // Security
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _termsAccepted = false;
  bool _isCreating = false;

  /// Set once the Firebase Auth account exists, so a cancelled or failed
  /// payment can be retried without trying to create the account twice.
  bool _accountCreated = false;
  String? _profileSaveError;

  // Email existence check (step 1)
  bool _isCheckingEmail = false;
  String? _emailExistsError;

  // Subscription
  int _selectedTerm = 0; // 0=Monthly, 1=Yearly, 2=TwoYears
  final _couponController = TextEditingController();
  String? _appliedCoupon;
  double _discountPercent = 0;
  bool _subscriptionTermsAccepted = false;

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _stepOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _stepController, curve: Curves.easeOut));
    _stepSlide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _stepController, curve: Curves.easeOutCubic),
        );
    _phoneController.addListener(_formatPhone);
  }

  void _formatPhone() {
    final raw = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = '';
    if (raw.length <= 5) {
      formatted = raw;
    } else if (raw.length <= 10) {
      formatted = '${raw.substring(0, 5)} ${raw.substring(5)}';
    } else {
      formatted = '${raw.substring(0, 5)} ${raw.substring(5, 10)}';
    }
    // PERF: setState was missing here, so the preview row and the value handed
    // to the API stayed stale until some other widget happened to rebuild.
    if (_formattedPhone != formatted) {
      setState(() => _formattedPhone = formatted);
    }
  }

  @override
  void dispose() {
    _stepController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    // PERF: forward() before setState so the new content is already animating
    // in when it mounts. The old order reset the controller to 0, painted one
    // frame of the *new* step fully transparent, then animated up from 0,
    // which read as a flicker on every step change.
    _stepController.forward(from: 0);
    setState(() => _step = step);
  }

  Future<void> _checkEmailAndProceed() async {
    debugPrint('_checkEmailAndProceed called');
    setState(() {
      _isCheckingEmail = true;
      _emailExistsError = null;
    });
    try {
      final exists = await AuthService.instance.checkEmailExists(
        _emailController.text,
      );
      debugPrint('Email check result: $exists');
      if (!mounted) return;
      if (exists) {
        setState(() {
          _emailExistsError = 'This email is already registered';
          _isCheckingEmail = false;
        });
      } else {
        setState(() => _isCheckingEmail = false);
        _goToStep(1);
      }
    } catch (e) {
      debugPrint('Email check failed: $e');
      if (!mounted) return;
      setState(() {
        _isCheckingEmail = false;
        _emailExistsError =
            "Couldn't verify this email. Check your internet and try again.";
      });
    }
  }

  void _onEmailChanged() {
    if (_emailExistsError != null) {
      setState(() => _emailExistsError = null);
    }
  }

  void _onProceedToPayment() {
    _goToStep(3);
  }

  Future<void> _onCreateAccount() async {
    if (_isCreating) return;
    setState(() => _isCreating = true);
    try {
      if (!_accountCreated) {
        final credential = await AuthService.instance.createAccount(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
        _accountCreated = true;
        final uid = credential.user?.uid;
        if (uid != null) {
          await _saveProfileToDatabase(uid);
          await _saveSubscriptionToDatabase(uid);
          // Send invoice email with PDF attachment
          await _sendInvoiceEmail();
        }
      } else {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await _saveProfileToDatabase(uid);
          await _saveSubscriptionToDatabase(uid);
          await _sendInvoiceEmail();
        }
      }
      if (!mounted) return;
      setState(() => _isCreating = false);
      _goToStep(4);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCreating = false);
      _showSnackBar(AuthService.friendlyError(e), AppTheme.error);
      if (_accountCreated) return;
      final code = e is FirebaseAuthException ? e.code : '';
      if (code == 'email-already-in-use' || code == 'invalid-email') {
        _goToStep(0);
      } else if (code == 'weak-password') {
        _goToStep(1);
      }
    }
  }

  Future<void> _saveProfileToDatabase(String uid) async {
    try {
      await DatabaseService.instance.savePersonalInformation(
        uid: uid,
        name: _nameController.text,
        email: _emailController.text,
        phoneDigits: _phoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        phoneFormatted: _formattedPhone,
        dialCode: _selectedCountry.code,
        country: _selectedCountry.name,
        termsAccepted: _termsAccepted,
      );
      _profileSaveError = null;
    } catch (e) {
      // The Firebase Auth account already exists here, so a database failure
      // must not strand the user. Record it and let them continue to payment.
      _profileSaveError = e.toString();
      debugPrint('Realtime Database save failed: $e');
    }
  }

  ({double basePrice, double totalAmount, String planTerm})
  _currentPlanDetails() {
    const basePrice = 500.0;
    final subtotal = basePrice * (1 - _discountPercent / 100);
    const planTerms = ['Monthly', 'Yearly', '2 Years'];
    return (
      basePrice: basePrice,
      totalAmount: subtotal * 1.18,
      planTerm: planTerms[_selectedTerm.clamp(0, 2)],
    );
  }

  Future<void> _saveSubscriptionToDatabase(String uid) async {
    try {
      final plan = _currentPlanDetails();

      await DatabaseService.instance.saveSubscription(
        uid: uid,
        planTerm: plan.planTerm,
        basePrice: plan.basePrice,
        discountPercent: _discountPercent,
        totalAmount: plan.totalAmount,
        couponCode: _appliedCoupon ?? '',
      );
    } catch (e) {
      debugPrint('Subscription save failed: $e');
    }
  }

  Future<void> _sendInvoiceEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final plan = _currentPlanDetails();
    final phoneWithCode = _formattedPhone.isNotEmpty
        ? '${_selectedCountry.code} ${_formattedPhone}'
        : '';
    final body = jsonEncode({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': phoneWithCode,
      'country': _selectedCountry.name,
      'planTerm': plan.planTerm,
      'discountPercent': _discountPercent,
      'couponCode': _appliedCoupon ?? '',
    });

    // Runs in the background so retries never block navigation.
    unawaited(_postInvoiceWithRetry(user, body));
  }

  static Future<void> _postInvoiceWithRetry(User user, String body) async {
    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final token = await user.getIdToken();
        final response = await http
            .post(
              Uri.parse('https://api.anbucrm.com/email/invoice'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          debugPrint('Invoice email sent successfully');
          return;
        }
        debugPrint('Invoice email failed (attempt $attempt): ${response.body}');
        if (response.statusCode >= 400 && response.statusCode < 500) return;
      } catch (e) {
        debugPrint('Invoice email error (attempt $attempt): $e');
      }
      if (attempt < maxAttempts) {
        await Future.delayed(Duration(seconds: 3 * attempt));
      }
    }
  }

  Map<String, double> _getPlanPrices() {
    return {'base': 500.0, 'monthly': 500.0};
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    if (code.toUpperCase() == 'JEEVAN100') {
      setState(() {
        _appliedCoupon = code.toUpperCase();
        _discountPercent = 100;
      });
    } else {
      _showSnackBar('Invalid coupon code', AppTheme.error);
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountPercent = 0;
      _couponController.clear();
    });
  }

  void _showSnackBar(String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: _S.snackBarText),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Email existence check is performed at step 1 via Firebase Identity Toolkit API.

  @override
  Widget build(BuildContext context) {
    // PERF: deliberately no MediaQuery.of(context) here. Subscribing to the
    // whole MediaQueryData (which includes viewInsets) re-ran this build on
    // every frame of the keyboard animation. `isTablet` is derived from the
    // LayoutBuilder constraints below instead, which depend on width only.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_step >= 4) {
          context.go(AppRoutes.signUpLoginScreen);
        } else if (_step > 0) {
          _goToStep(_step - 1);
        } else if (context.canPop()) {
          context.pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Stack(
          children: [
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primary.withAlpha(20),
                      AppTheme.primary.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 600;
                  // PERF: keyboard inset is added here, once, rather than being
                  // double-counted by scrollPadding on each field. Combined with
                  // resizeToAvoidBottomInset the viewport has already shrunk by
                  // the keyboard height, so the fields only need a small buffer.
                  final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                  return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 0 : 24,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxWidth: isTablet ? 480 : double.infinity,
                      ),
                      child: Padding(
                        // Keeps the last field clear of the keyboard without the
                        // overshoot-then-settle that scrollPadding: 140 caused.
                        padding: EdgeInsets.only(
                          bottom: bottomInset > 0 ? 16 : 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Back button
                            if (_step < 4 && !_isCreating)
                              GestureDetector(
                                onTap: () {
                                  if (_step > 0) {
                                    _goToStep(_step - 1);
                                  } else if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go(AppRoutes.buyProductScreen);
                                  }
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.surface200,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 18,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            if (_step < 4) const SizedBox(height: 24),
                            // Step indicator (steps 0-3) — consistent equal gaps
                            if (_step < 4) ...[
                              _CreateAccountStepIndicator(currentStep: _step),
                              const SizedBox(height: 28),
                            ],
                            // Content
                            // PERF: AnimatedSize animates the container height in
                            // step with the fade/slide. Without it the scroll
                            // content height snapped instantly while the 400ms
                            // transition was still running, which read as a glitch.
                            AnimatedSize(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              alignment: Alignment.topCenter,
                              child: FadeTransition(
                                opacity: _stepOpacity,
                                child: SlideTransition(
                                  position: _stepSlide,
                                  child: _buildContent(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_step) {
      case 0:
        return _PersonalInfoStep(
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          formattedPhone: _formattedPhone,
          selectedCountry: _selectedCountry,
          onCountryChanged: (c) => setState(() => _selectedCountry = c),
          onNext: _checkEmailAndProceed,
          isCheckingEmail: _isCheckingEmail,
          emailExistsError: _emailExistsError,
          onEmailChanged: _onEmailChanged,
        );
      case 1:
        return _SecurityStep(
          passwordController: _passwordController,
          confirmController: _confirmController,
          onNext: () => _goToStep(2),
        );
      case 2:
        return _ReviewStep(
          name: _nameController.text,
          email: _emailController.text,
          phone: _formattedPhone,
          countryCode: _selectedCountry.code,
          onEdit: (step) => _goToStep(step),
          isCreating: _isCreating,
          onProceedToPayment: _onProceedToPayment,
        );
      case 3:
        return _SubscriptionStep(
          selectedTerm: _selectedTerm,
          onTermChanged: (term) => setState(() => _selectedTerm = term),
          couponController: _couponController,
          appliedCoupon: _appliedCoupon,
          discountPercent: _discountPercent,
          onApplyCoupon: _applyCoupon,
          onRemoveCoupon: _removeCoupon,
          subscriptionTermsAccepted: _subscriptionTermsAccepted,
          onSubscriptionTermsChanged: (v) =>
              setState(() => _subscriptionTermsAccepted = v),
          isCreating: _isCreating,
          onCreateAccount: _onCreateAccount,
          onBack: () => _goToStep(2),
        );
      case 4:
        final plan = _currentPlanDetails();
        final phoneWithCode = _formattedPhone.isNotEmpty
            ? '${_selectedCountry.code} ${_formattedPhone}'
            : '';
        return _SuccessStep(
          name: _nameController.text,
          email: _emailController.text,
          phone: phoneWithCode,
          planTerm: plan.planTerm,
          amountPaid: plan.totalAmount,
          discountPercent: _discountPercent,
          couponCode: _appliedCoupon ?? '',
          onGoToLogin: () => context.go(AppRoutes.signUpLoginScreen),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Step Indicator (consistent equal gaps) ───────────────────────────────────

class _CreateAccountStepIndicator extends StatelessWidget {
  final int currentStep;
  const _CreateAccountStepIndicator({required this.currentStep});

  static const _steps = [
    (label: 'Personal Info', icon: Icons.person_outline_rounded),
    (label: 'Security', icon: Icons.lock_outline_rounded),
    (label: 'Review', icon: Icons.checklist_rounded),
    (label: 'Subscription', icon: Icons.card_membership_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step ${currentStep + 1} of 4', style: _S.stepIndicatorLabel),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 4; i++) ...[
              _StepCircle(
                index: i,
                isActive: i == currentStep,
                isDone: i < currentStep,
                label: _steps[i].label,
                icon: _steps[i].icon,
              ),
              if (i < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 26),
                    color: i < currentStep
                        ? AppTheme.success
                        : AppTheme.surface200,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isDone;
  final String label;
  final IconData icon;

  const _StepCircle({
    required this.index,
    required this.isActive,
    required this.isDone,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? AppTheme.success
                  : isActive
                  ? AppTheme.primary
                  : AppTheme.surface200,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : Icon(
                      icon,
                      size: 18,
                      color: isActive ? Colors.white : AppTheme.textMuted,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: isActive ? _S.stepCircleLabelActive : _S.stepCircleLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Personal Info ────────────────────────────────────────────────────

class _PersonalInfoStep extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String formattedPhone;
  final _Country selectedCountry;
  final Function(_Country) onCountryChanged;
  final VoidCallback onNext;
  final bool isCheckingEmail;
  final String? emailExistsError;
  final VoidCallback onEmailChanged;

  const _PersonalInfoStep({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.formattedPhone,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.onNext,
    required this.onEmailChanged,
    this.isCheckingEmail = false,
    this.emailExistsError,
  });

  @override
  State<_PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<_PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
  bool _hasSubmitted = false;

  @override
  void didUpdateWidget(covariant _PersonalInfoStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.emailExistsError != oldWidget.emailExistsError &&
        _hasSubmitted) {
      _formKey.currentState?.validate();
    }
  }

  void _openCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _CountryPickerSheet(
          selected: widget.selectedCountry,
          onSelect: (c) {
            widget.onCountryChanged(c);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && widget.phoneController.text.isNotEmpty) {
                _phoneFieldKey.currentState?.validate();
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Personal Information', style: _S.sectionTitle),
          const SizedBox(height: 6),
          Text(
            'Tell us a bit about yourself to get started.',
            style: _S.sectionSubtitle,
          ),
          const SizedBox(height: 28),
          // Name
          _FieldLabel(label: 'Full Name'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            scrollPadding: const EdgeInsets.only(bottom: 24),
            style: _S.fieldText,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (_) {
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: InputDecoration(
              hintText: 'John Doe',
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
              suffix: ListenableBuilder(
                listenable: widget.nameController,
                builder: (_, __) => Text(
                  '${widget.nameController.text.length}/50',
                  style: _S.suffixText,
                ),
              ),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.trim().isEmpty) return 'Enter your full name';
              if (v.trim().length < 2) return 'Name too short';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            scrollPadding: const EdgeInsets.only(bottom: 24),
            style: _S.fieldText,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: const InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            onChanged: (_) {
              widget.onEmailChanged();
              if (_hasSubmitted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _formKey.currentState?.validate();
                });
              }
            },
            validator: (v) {
              final value = (v ?? '').trim();
              if (value.isEmpty) return 'Enter your email';
              if (!_kEmailRegex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              if (widget.emailExistsError != null) {
                return widget.emailExistsError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Phone with country code
          _FieldLabel(label: 'Phone Number'),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                // Country code selector
                GestureDetector(
                  onTap: _openCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppTheme.surface200),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.selectedCountry.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.selectedCountry.code,
                          style: _S.dialCodeText,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                // Phone number input
                Expanded(
                  child: TextFormField(
                    key: _phoneFieldKey,
                    controller: widget.phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    scrollPadding: const EdgeInsets.only(bottom: 24),
                    style: _S.fieldText,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                    decoration: InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: _S.hintText,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                      if (digits.isEmpty) return 'Enter your phone number';
                      final range = _kCodeLengths[widget.selectedCountry.code];
                      if (range != null) {
                        final min = range[0];
                        final max = range[1];
                        if (digits.length < min || digits.length > max) {
                          return min == max
                              ? 'Must be $min digits'
                              : 'Must be $min-$max digits';
                        }
                      } else if (digits.length < 7 || digits.length > 15) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.formattedPhone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.phone_rounded, size: 12, color: AppTheme.primary),
                const SizedBox(width: 4),
                Text(
                  'Preview: ${widget.selectedCountry.code} ${widget.formattedPhone}',
                  style: _S.phonePreview,
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          _PrimaryButton(
            label: widget.isCheckingEmail
                ? 'Checking...'
                : 'Continue to Security',
            onTap: widget.isCheckingEmail
                ? () {}
                : () {
                    setState(() => _hasSubmitted = true);
                    if (!_formKey.currentState!.validate()) return;
                    widget.onNext();
                  },
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Security ─────────────────────────────────────────────────────────

class _SecurityStep extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final VoidCallback onNext;

  const _SecurityStep({
    required this.passwordController,
    required this.confirmController,
    required this.onNext,
  });

  @override
  State<_SecurityStep> createState() => _SecurityStepState();
}

class _SecurityStepState extends State<_SecurityStep> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _hasSubmitted = false;

  bool _hasLength(String t) => t.length >= 8;
  bool _hasUpperLower(String t) =>
      t.contains(RegExp(r'[A-Z]')) && t.contains(RegExp(r'[a-z]'));
  bool _hasNumber(String t) => t.contains(RegExp(r'[0-9]'));
  bool _hasSpecial(String t) => t.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  double _strengthScore(String t) {
    int score = 0;
    if (_hasLength(t)) score++;
    if (_hasUpperLower(t)) score++;
    if (_hasNumber(t)) score++;
    if (_hasSpecial(t)) score++;
    return score / 4;
  }

  String _strengthLabel(double s) {
    if (s <= 0.25) return 'Weak';
    if (s <= 0.5) return 'Fair';
    if (s <= 0.75) return 'Good';
    return 'Strong';
  }

  Color _strengthColor(double s) {
    if (s <= 0.25) return AppTheme.error;
    if (s <= 0.5) return const Color(0xFFD97706);
    if (s <= 0.75) return const Color(0xFF0EA5E9);
    return AppTheme.success;
  }

  TextStyle _strengthLabelStyle(double s) {
    if (s <= 0.25) return _S.strengthLabelWeak;
    if (s <= 0.5) return _S.strengthLabelFair;
    if (s <= 0.75) return _S.strengthLabelGood;
    return _S.strengthLabelStrong;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Security Setup', style: _S.sectionTitle),
          const SizedBox(height: 6),
          Text(
            'Create a strong password to protect your account.',
            style: _S.sectionSubtitle,
          ),
          const SizedBox(height: 28),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            scrollPadding: const EdgeInsets.only(bottom: 24),
            style: _S.fieldText,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (_) {
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter a password';
              if (!_hasLength(v)) return 'At least 8 characters required';
              return null;
            },
          ),
          ListenableBuilder(
            listenable: widget.passwordController,
            builder: (context, _) {
              final text = widget.passwordController.text;
              if (text.isEmpty) return const SizedBox.shrink();
              final score = _strengthScore(text);
              final color = _strengthColor(score);
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: score,
                            backgroundColor: AppTheme.surface200,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _strengthLabel(score),
                        style: _strengthLabelStyle(score),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _AnimatedRuleRow(
                          label: 'At least 8 characters',
                          met: _hasLength(text),
                        ),
                        const SizedBox(height: 4),
                        _AnimatedRuleRow(
                          label: 'Uppercase & lowercase',
                          met: _hasUpperLower(text),
                        ),
                        const SizedBox(height: 4),
                        _AnimatedRuleRow(
                          label: 'At least one number',
                          met: _hasNumber(text),
                        ),
                        const SizedBox(height: 4),
                        _AnimatedRuleRow(
                          label: 'Special character (!@#\$...)',
                          met: _hasSpecial(text),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Confirm Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.confirmController,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            scrollPadding: const EdgeInsets.only(bottom: 24),
            style: _S.fieldText,
            onFieldSubmitted: (_) {
              setState(() => _hasSubmitted = true);
              if (_formKey.currentState!.validate()) widget.onNext();
            },
            onChanged: (_) {
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Confirm your password';
              if (v != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Review & Continue',
            onTap: () {
              setState(() => _hasSubmitted = true);
              if (_formKey.currentState!.validate()) widget.onNext();
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ', style: _S.secondaryText13),
              GestureDetector(
                onTap: () => context.push(AppRoutes.signUpLoginScreen),
                child: Text('Login', style: _S.primaryLink13),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Step 3: Review ───────────────────────────────────────────────────────────

class _ReviewStep extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String countryCode;
  final Function(int) onEdit;
  final bool isCreating;
  final VoidCallback onProceedToPayment;

  const _ReviewStep({
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.onEdit,
    required this.isCreating,
    required this.onProceedToPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Review Your Details', style: _S.sectionTitle),
        const SizedBox(height: 6),
        Text(
          'Please confirm your information before proceeding to payment.',
          style: _S.sectionSubtitle,
        ),
        const SizedBox(height: 24),
        _ReviewCard(
          title: 'Personal Information',
          icon: Icons.person_outline_rounded,
          onEdit: () => onEdit(0),
          items: [
            _ReviewItem(label: 'Full Name', value: name.isEmpty ? '—' : name),
            _ReviewItem(label: 'Email', value: email.isEmpty ? '—' : email),
            _ReviewItem(
              label: 'Phone',
              value: phone.isEmpty ? '—' : '$countryCode $phone',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ReviewCard(
          title: 'Security',
          icon: Icons.lock_outline_rounded,
          onEdit: () => onEdit(1),
          items: [_ReviewItem(label: 'Password', value: '••••••••')],
        ),
        const SizedBox(height: 28),
        _PrimaryButton(
          label: isCreating
              ? 'Creating your account…'
              : 'Proceed to Payment',
          onTap: onProceedToPayment,
          enabled: !isCreating,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final List<_ReviewItem> items;

  const _ReviewCard({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(title, style: _S.reviewCardTitle),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Text('Edit', style: _S.editLink),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(item.label, style: _S.reviewLabel),
                  ),
                  Expanded(
                    child: Text(
                      item.value,
                      style: _S.reviewValue,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem {
  final String label;
  final String value;
  const _ReviewItem({required this.label, required this.value});
}

// ─── Step 4: Subscription ─────────────────────────────────────────────────────

class _SubscriptionStep extends StatefulWidget {
  final int selectedTerm;
  final ValueChanged<int> onTermChanged;
  final TextEditingController couponController;
  final String? appliedCoupon;
  final double discountPercent;
  final VoidCallback onApplyCoupon;
  final VoidCallback onRemoveCoupon;
  final bool subscriptionTermsAccepted;
  final ValueChanged<bool> onSubscriptionTermsChanged;
  final bool isCreating;
  final VoidCallback onCreateAccount;
  final VoidCallback onBack;

  const _SubscriptionStep({
    required this.selectedTerm,
    required this.onTermChanged,
    required this.couponController,
    required this.appliedCoupon,
    required this.discountPercent,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    required this.subscriptionTermsAccepted,
    required this.onSubscriptionTermsChanged,
    required this.isCreating,
    required this.onCreateAccount,
    required this.onBack,
  });

  @override
  State<_SubscriptionStep> createState() => _SubscriptionStepState();
}

class _SubscriptionStepState extends State<_SubscriptionStep> {
  Map<String, double> _getPlanPrices() {
    switch (widget.selectedTerm) {
      case 0:
        return {'base': 500.0, 'monthly': 500.0};
      case 1:
        return {'base': 4500.0, 'monthly': 375.0};
      case 2:
        return {'base': 8000.0, 'monthly': 333.33};
      default:
        return {'base': 500.0, 'monthly': 500.0};
    }
  }

  String _getTermLabel(int term) {
    switch (term) {
      case 0:
        return 'Monthly';
      case 1:
        return '1 Year';
      case 2:
        return '2 Years';
      default:
        return 'Monthly';
    }
  }

  String _getTermBilling(int term) {
    switch (term) {
      case 0:
        return 'Billed monthly';
      case 1:
        return 'Billed annually';
      case 2:
        return 'Billed every 2 years';
      default:
        return 'Billed monthly';
    }
  }

  double _getSavingsPercent(int term) {
    switch (term) {
      case 0:
        return 0;
      case 1:
        return 25;
      case 2:
        return 33;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const basePrice = 500.0;
    final discountAmount = basePrice * (widget.discountPercent / 100);
    final subtotal = basePrice - discountAmount;
    final tax = subtotal * 0.18;
    final totalAmount = subtotal + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Choose Your Plan', style: _S.sectionTitle),
        const SizedBox(height: 6),
        Text(
          'Select a subscription term that works best for you.',
          style: _S.sectionSubtitle,
        ),
        const SizedBox(height: 24),
        // Monthly plan card only
        _buildTermCard(0, 500.0, 'Billed monthly', 0),
        const SizedBox(height: 24),
        // Pricing breakdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: _S.reviewCardTitle.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 12),
              _buildPriceRow(
                'AnbuCRM Monthly Plan',
                '₹${basePrice.toStringAsFixed(2)}',
              ),
              if (widget.discountPercent > 0) ...[
                const SizedBox(height: 8),
                _buildPriceRow(
                  'Coupon Discount (${widget.discountPercent.toStringAsFixed(0)}%)',
                  '-₹${discountAmount.toStringAsFixed(2)}',
                  valueColor: AppTheme.success,
                ),
              ],
              const SizedBox(height: 12),
              _buildPriceRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildPriceRow('GST (18%)', '₹${tax.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              Container(height: 1, color: AppTheme.surface200),
              const SizedBox(height: 12),
              _buildPriceRow(
                "Today's Total",
                '₹${totalAmount.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Coupon code input
        _buildCouponSection(),
        const SizedBox(height: 20),
        // Terms checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: widget.subscriptionTermsAccepted,
                onChanged: (v) => widget.onSubscriptionTermsChanged(v ?? false),
                activeColor: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: _S.termsText,
                  children: [
                    const TextSpan(text: 'Yes, I agree to the '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Terms of Service',
                          style: _S.termsText.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Privacy Policy',
                          style: _S.termsText.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Create Account button
        _PrimaryButton(
          label: widget.isCreating
              ? 'Creating your account…'
              : 'Create Account',
          onTap: widget.onCreateAccount,
          enabled: !widget.isCreating && widget.subscriptionTermsAccepted,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTermCard(
    int term,
    double monthlyPrice,
    String billing,
    double savingsPercent,
  ) {
    final isSelected = widget.selectedTerm == term;
    return GestureDetector(
      onTap: () => widget.onTermChanged(term),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withAlpha(15)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surface200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getTermLabel(term),
                        style: _S.reviewCardTitle.copyWith(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                      if (savingsPercent > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Save ${savingsPercent.toStringAsFixed(0)}%',
                            style: _S.reviewCardTitle.copyWith(
                              fontSize: 11,
                              color: AppTheme.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(billing, style: _S.reviewLabel),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${monthlyPrice.toStringAsFixed(2)}/mo',
                  style: _S.reviewValue.copyWith(
                    fontSize: 16,
                    color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? _S.reviewCardTitle : _S.reviewLabel),
        Text(
          value,
          style: _S.reviewValue.copyWith(
            fontSize: isTotal ? 18 : 13,
            color:
                valueColor ??
                (isTotal ? AppTheme.primary : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    if (widget.appliedCoupon != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.success.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.success.withAlpha(50)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Coupon "${widget.appliedCoupon}" applied!',
                style: _S.reviewValue.copyWith(color: AppTheme.success),
              ),
            ),
            GestureDetector(
              onTap: widget.onRemoveCoupon,
              child: const Icon(
                Icons.close_rounded,
                color: AppTheme.textMuted,
                size: 20,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo Code', style: _S.fieldLabel),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.couponController,
                style: _S.fieldText,
                decoration: InputDecoration(
                  hintText: 'Enter promo code',
                  hintStyle: _S.hintText,
                  prefixIcon: const Icon(Icons.local_offer_outlined, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: widget.onApplyCoupon,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Apply', style: _S.buttonLabel)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Step 5: Success ──────────────────────────────────────────────────────────

class _SuccessStep extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String planTerm;
  final double amountPaid;
  final double discountPercent;
  final String couponCode;
  final VoidCallback onGoToLogin;

  const _SuccessStep({
    required this.name,
    required this.email,
    required this.phone,
    required this.planTerm,
    required this.amountPaid,
    required this.discountPercent,
    required this.couponCode,
    required this.onGoToLogin,
  });

  @override
  State<_SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends State<_SuccessStep>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late Animation<double> _checkScale;
  late Animation<double> _contentFade;
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    final rng = Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(
        _ConfettiParticle(
          x: rng.nextDouble(),
          y: -rng.nextDouble() * 0.5,
          color: [
            AppTheme.primary,
            AppTheme.success,
            const Color(0xFF7C3AED),
            const Color(0xFFF59E0B),
            const Color(0xFF0EA5E9),
          ][rng.nextInt(5)],
          size: 6 + rng.nextDouble() * 6,
          speed: 0.3 + rng.nextDouble() * 0.7,
          angle: rng.nextDouble() * 2 * pi,
        ),
      );
    }

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _checkController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get _validTillText {
    final now = DateTime.now();
    final DateTime end;
    switch (widget.planTerm) {
      case 'Yearly':
        end = DateTime(now.year + 1, now.month, now.day);
      case '2 Years':
        end = DateTime(now.year + 2, now.month, now.day);
      default:
        end = DateTime(now.year, now.month + 1, now.day);
    }
    return '${end.day} ${_monthNames[end.month - 1]} ${end.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _confettiController,
          builder: (_, __) {
            return CustomPaint(
              painter: _ConfettiPainter(
                particles: _particles,
                progress: _confettiController.value,
              ),
              child: const SizedBox(height: 200),
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Center(
              child: ScaleTransition(
                scale: _checkScale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.success, Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withAlpha(60),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _contentFade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Account Created Successfully',
                    style: _S.successTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.name.isNotEmpty
                        ? 'Welcome aboard, ${widget.name.split(' ').first}!'
                        : 'Welcome aboard!',
                    style: _S.successBody,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildDashboardCard(),
                  const SizedBox(height: 28),
                  _PrimaryButton(
                    label: 'Continue to Login',
                    onTap: widget.onGoToLogin,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.dashboard_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Account Overview',
                  style: _S.successSectionTitle,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _StatCard(
                  icon: Icons.person_outline_rounded,
                  label: 'Name',
                  value: widget.name,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 10),
                _StatCard(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: widget.email,
                  color: AppTheme.secondary,
                ),
                const SizedBox(height: 10),
                _StatCard(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: widget.phone,
                  color: AppTheme.statusEngaged,
                ),
                const SizedBox(height: 10),
                _StatCard(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Plan',
                  value: '${widget.planTerm} Plan',
                  color: AppTheme.statusSessions,
                ),
                const SizedBox(height: 10),
                _StatCard(
                  icon: Icons.currency_rupee_rounded,
                  label: 'Amount Paid',
                  value: '${widget.amountPaid.toStringAsFixed(2)}',
                  color: AppTheme.statusWon,
                ),
                const SizedBox(height: 10),
                _StatCard(
                  icon: Icons.event_available_rounded,
                  label: 'Valid Till',
                  value: _validTillText,
                  color: AppTheme.statusFollowUp,
                ),
                if (widget.discountPercent > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 16,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.discountPercent.toStringAsFixed(0)}% off',
                          style: _S.successDiscountLabel,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '(${widget.couponCode})',
                            style: _S.successDiscountCode,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16,
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status',
                        style: _S.successDetailLabel,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Active',
                          style: _S.successStatusBadge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scaler = MediaQuery.textScalerOf(context);
          final labelPainter = TextPainter(
            text: TextSpan(text: label, style: _S.statCardLabel),
            textDirection: TextDirection.ltr,
            textScaler: scaler,
            maxLines: 1,
          )..layout();
          final valuePainter = TextPainter(
            text: TextSpan(text: value, style: _S.statCardValue),
            textDirection: TextDirection.ltr,
            textScaler: scaler,
            maxLines: 1,
          )..layout();
          // icon 16 + gap 10 + label + min gap 12 before the value
          final inlineSpace =
              constraints.maxWidth - 16 - 10 - labelPainter.width - 12;

          if (valuePainter.width <= inlineSpace) {
            return Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 10),
                Text(label, style: _S.statCardLabel),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: _S.statCardValue,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: _S.statCardLabel),
                    const SizedBox(height: 4),
                    Text(
                      _breakable(value),
                      style: _S.statCardValue,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Zero-width spaces after @ and . let long emails wrap at natural points.
  static String _breakable(String s) =>
      s.replaceAllMapped(RegExp(r'([@._\-])'), (m) => '${m[1]}\u200B');
}

class _SuccessDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SuccessDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text('$label: ', style: _S.successDetailLabel),
        Expanded(
          child: Text(
            value,
            style: valueColor != null
                ? _S.successDetailValue.copyWith(color: valueColor)
                : _S.successDetailValue,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Confetti ─────────────────────────────────────────────────────────────────

class _ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speed;
  final double angle;

  const _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withAlpha((255 * (1 - progress)).toInt());
      final x = p.x * size.width + cos(p.angle) * 40 * progress;
      final y = (p.y + p.speed * progress) * size.height;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─── Animated Rule Row ────────────────────────────────────────────────────────

class _AnimatedRuleRow extends StatelessWidget {
  final String label;
  final bool met;

  const _AnimatedRuleRow({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? AppTheme.success : AppTheme.surface200,
          ),
          child: met
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 10)
              : null,
        ),
        const SizedBox(width: 8),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: met ? _S.ruleTextMet : _S.ruleTextUnmet,
          child: Text(label),
        ),
      ],
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: _S.fieldLabel);
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF7C3AED)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: enabled ? null : AppTheme.surface200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(60),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: enabled ? _S.buttonLabel : _S.buttonLabelDisabled,
          ),
        ),
      ),
    );
  }
}
