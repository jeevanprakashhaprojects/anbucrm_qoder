import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Country Code Data ────────────────────────────────────────────────────────

class _Country {
  final String name;
  final String code;
  final String flag;
  const _Country(this.name, this.code, this.flag);
}

const List<_Country> _allCountries = [
  _Country('India', '+91', '🇮🇳'),
  _Country('United States', '+1', '🇺🇸'),
  _Country('United Kingdom', '+44', '🇬🇧'),
  _Country('United Arab Emirates', '+971', '🇦🇪'),
  _Country('Australia', '+61', '🇦🇺'),
  _Country('Canada', '+1', '🇨🇦'),
  _Country('Singapore', '+65', '🇸🇬'),
  _Country('Germany', '+49', '🇩🇪'),
  _Country('France', '+33', '🇫🇷'),
  _Country('Japan', '+81', '🇯🇵'),
  _Country('China', '+86', '🇨🇳'),
  _Country('South Korea', '+82', '🇰🇷'),
  _Country('Brazil', '+55', '🇧🇷'),
  _Country('Mexico', '+52', '🇲🇽'),
  _Country('South Africa', '+27', '🇿🇦'),
  _Country('Nigeria', '+234', '🇳🇬'),
  _Country('Kenya', '+254', '🇰🇪'),
  _Country('Egypt', '+20', '🇪🇬'),
  _Country('Saudi Arabia', '+966', '🇸🇦'),
  _Country('Qatar', '+974', '🇶🇦'),
  _Country('Kuwait', '+965', '🇰🇼'),
  _Country('Bahrain', '+973', '🇧🇭'),
  _Country('Oman', '+968', '🇴🇲'),
  _Country('Pakistan', '+92', '🇵🇰'),
  _Country('Bangladesh', '+880', '🇧🇩'),
  _Country('Sri Lanka', '+94', '🇱🇰'),
  _Country('Nepal', '+977', '🇳🇵'),
  _Country('Myanmar', '+95', '🇲🇲'),
  _Country('Thailand', '+66', '🇹🇭'),
  _Country('Vietnam', '+84', '🇻🇳'),
  _Country('Indonesia', '+62', '🇮🇩'),
  _Country('Malaysia', '+60', '🇲🇾'),
  _Country('Philippines', '+63', '🇵🇭'),
  _Country('New Zealand', '+64', '🇳🇿'),
  _Country('Italy', '+39', '🇮🇹'),
  _Country('Spain', '+34', '🇪🇸'),
  _Country('Portugal', '+351', '🇵🇹'),
  _Country('Netherlands', '+31', '🇳🇱'),
  _Country('Belgium', '+32', '🇧🇪'),
  _Country('Switzerland', '+41', '🇨🇭'),
  _Country('Sweden', '+46', '🇸🇪'),
  _Country('Norway', '+47', '🇳🇴'),
  _Country('Denmark', '+45', '🇩🇰'),
  _Country('Finland', '+358', '🇫🇮'),
  _Country('Poland', '+48', '🇵🇱'),
  _Country('Russia', '+7', '🇷🇺'),
  _Country('Turkey', '+90', '🇹🇷'),
  _Country('Israel', '+972', '🇮🇱'),
  _Country('Iran', '+98', '🇮🇷'),
  _Country('Iraq', '+964', '🇮🇶'),
  _Country('Jordan', '+962', '🇯🇴'),
  _Country('Lebanon', '+961', '🇱🇧'),
  _Country('Argentina', '+54', '🇦🇷'),
  _Country('Chile', '+56', '🇨🇱'),
  _Country('Colombia', '+57', '🇨🇴'),
  _Country('Peru', '+51', '🇵🇪'),
  _Country('Venezuela', '+58', '🇻🇪'),
  _Country('Ghana', '+233', '🇬🇭'),
  _Country('Tanzania', '+255', '🇹🇿'),
  _Country('Uganda', '+256', '🇺🇬'),
  _Country('Ethiopia', '+251', '🇪🇹'),
  _Country('Morocco', '+212', '🇲🇦'),
  _Country('Tunisia', '+216', '🇹🇳'),
  _Country('Algeria', '+213', '🇩🇿'),
  _Country('Zimbabwe', '+263', '🇿🇼'),
  _Country('Zambia', '+260', '🇿🇲'),
  _Country('Mozambique', '+258', '🇲🇿'),
  _Country('Afghanistan', '+93', '🇦🇫'),
  _Country('Kazakhstan', '+7', '🇰🇿'),
  _Country('Uzbekistan', '+998', '🇺🇿'),
  _Country('Ukraine', '+380', '🇺🇦'),
  _Country('Romania', '+40', '🇷🇴'),
  _Country('Czech Republic', '+420', '🇨🇿'),
  _Country('Hungary', '+36', '🇭🇺'),
  _Country('Greece', '+30', '🇬🇷'),
  _Country('Austria', '+43', '🇦🇹'),
  _Country('Ireland', '+353', '🇮🇪'),
  _Country('Hong Kong', '+852', '🇭🇰'),
  _Country('Taiwan', '+886', '🇹🇼'),
  _Country('Maldives', '+960', '🇲🇻'),
  _Country('Bhutan', '+975', '🇧🇹'),
  _Country('Cambodia', '+855', '🇰🇭'),
  _Country('Laos', '+856', '🇱🇦'),
  _Country('Mongolia', '+976', '🇲🇳'),
  _Country('Papua New Guinea', '+675', '🇵🇬'),
  _Country('Fiji', '+679', '🇫🇯'),
  _Country('Jamaica', '+1876', '🇯🇲'),
  _Country('Trinidad and Tobago', '+1868', '🇹🇹'),
  _Country('Cuba', '+53', '🇨🇺'),
  _Country('Dominican Republic', '+1809', '🇩🇴'),
  _Country('Guatemala', '+502', '🇬🇹'),
  _Country('Honduras', '+504', '🇭🇳'),
  _Country('El Salvador', '+503', '🇸🇻'),
  _Country('Costa Rica', '+506', '🇨🇷'),
  _Country('Panama', '+507', '🇵🇦'),
  _Country('Bolivia', '+591', '🇧🇴'),
  _Country('Paraguay', '+595', '🇵🇾'),
  _Country('Uruguay', '+598', '🇺🇾'),
  _Country('Ecuador', '+593', '🇪🇨'),
];

// ─── Country Code Picker Widget ───────────────────────────────────────────────

class _CountryCodePicker extends StatefulWidget {
  final _Country selected;
  final ValueChanged<_Country> onChanged;

  const _CountryCodePicker({required this.selected, required this.onChanged});

  @override
  State<_CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<_CountryCodePicker> {
  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _CountryPickerSheet(
          selected: widget.selected,
          onSelect: (c) {
            widget.onChanged(c);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.selected.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              widget.selected.code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final _Country selected;
  final ValueChanged<_Country> onSelect;

  const _CountryPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  List<_Country> get _filtered {
    if (_query.isEmpty) return _allCountries;
    final q = _query.toLowerCase();
    return _allCountries
        .where((c) => c.name.toLowerCase().contains(q) || c.code.contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Country Code',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search country...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.surface200),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected =
                    c.code == widget.selected.code &&
                    c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    c.name,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  ),
                  trailing: Text(
                    c.code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primaryContainer.withAlpha(60),
                  onTap: () => widget.onSelect(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Phone Field with Country Code ───────────────────────────────────────────

class _PhoneFieldWithCode extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  const _PhoneFieldWithCode({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  State<_PhoneFieldWithCode> createState() => _PhoneFieldWithCodeState();
}

class _PhoneFieldWithCodeState extends State<_PhoneFieldWithCode> {
  _Country _selectedCountry = _allCountries.first; // India default

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CountryCodePicker(
          selected: _selectedCountry,
          onChanged: (c) => setState(() => _selectedCountry = c),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: widget.label,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 18)
                  : null,
            ),
            validator: widget.isRequired
                ? (v) => (v == null || v.isEmpty) ? 'Required' : null
                : null,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─── Masked Text Field ────────────────────────────────────────────────────────

class _MaskedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  const _MaskedTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  State<_MaskedTextField> createState() => _MaskedTextFieldState();
}

class _MaskedTextFieldState extends State<_MaskedTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon, size: 18),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 18,
            color: AppTheme.textMuted,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SectionContactInfoWidget extends StatefulWidget {
  final void Function(int filledCount)? onCompulsoryChanged;
  final void Function(Map<String, dynamic>)? onDataChanged;
  final Map<String, dynamic>? prefillData;
  const SectionContactInfoWidget({
    super.key,
    this.onCompulsoryChanged,
    this.onDataChanged,
    this.prefillData,
  });

  @override
  State<SectionContactInfoWidget> createState() =>
      _SectionContactInfoWidgetState();
}

class _SectionContactInfoWidgetState extends State<SectionContactInfoWidget> {
  String _salutation = 'Mr.';
  bool _whatsappSameAsMobile = false;
  bool _showDemographics = false;
  bool _showIdentityDocs = false;
  bool _showCommPrefs = false;
  bool _showPersonalDetails = false;
  String _selectedGender = '';
  String _selectedMaritalStatus = '';
  String _selectedCustomerType = 'Individual';
  String _selectedLanguage = '';
  String _selectedBestTimeToCall = '';
  String _selectedTimezone = '';

  // Communication opt-ins
  bool _optInSMS = true;
  bool _optInEmail = true;
  bool _optInVoice = true;
  bool _optInWhatsApp = true;

  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _email2Ctrl = TextEditingController();

  // Identity / Tax fields
  final _panCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  final _gstinCtrl = TextEditingController();
  final _passportCtrl = TextEditingController();
  final _tfnCtrl = TextEditingController(); // ATO: Tax File Number
  final _medicareCtrl = TextEditingController(); // ATO: Medicare Card
  final _medicareIrnCtrl = TextEditingController(); // ATO: Medicare IRN

  // Personal details
  final _spouseNameCtrl = TextEditingController();
  final _dependentsCtrl = TextEditingController();
  final _annualIncomeCtrl = TextEditingController();

  // Occupation / Professional details
  final _occupationCtrl = TextEditingController();
  final _degreeCtrl = TextEditingController();
  final _companyWorkingCtrl = TextEditingController();
  final _workingSalaryCtrl = TextEditingController();
  final _yearsOfServiceCtrl = TextEditingController();

  DateTime? _dobDate;
  DateTime? _anniversaryDate;
  DateTime? _medicareExpiry;

  static const _salutations = ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Prof.', 'Others'];
  static const _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
    'Others',
  ];
  static const _maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Others',
  ];
  static const _customerTypes = [
    'Individual',
    'HUF',
    'Partnership',
    'LLP',
    'Company',
    'Trust',
    'Society',
    'Others',
  ];
  static const _languages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Marathi',
    'Bengali',
    'Gujarati',
    'Punjabi',
    'Odia',
    'Urdu',
    'Others',
  ];
  static const _bestTimesToCall = [
    'Morning (8am–12pm)',
    'Afternoon (12pm–4pm)',
    'Evening (4pm–8pm)',
    'Anytime',
  ];
  static const _timezones = [
    'IST (UTC+5:30)',
    'AEST (UTC+10)',
    'GMT (UTC+0)',
    'EST (UTC-5)',
    'PST (UTC-8)',
    'CST (UTC+8)',
    'GST (UTC+4)',
    'Others',
  ];
  static const _taxResidencies = [
    'Resident',
    'Non-Resident',
    'Working Holiday',
    'NRI',
    'Others',
  ];

  String _otherSalutation = '';
  String _otherGender = '';
  String _otherMaritalStatus = '';
  String _otherCustomerType = '';
  String _selectedTaxResidency = '';

  /// 2 compulsory: First Name, Primary Mobile (email is optional)
  void _notifyParent() {
    int filled = 0;
    if (_firstNameCtrl.text.trim().isNotEmpty) filled++;
    if (_mobileCtrl.text.trim().isNotEmpty) filled++;
    int othersExtra = 0;
    if (_salutation == 'Others') othersExtra++;
    if (_selectedGender == 'Others') othersExtra++;
    if (_selectedMaritalStatus == 'Others') othersExtra++;
    if (_selectedCustomerType == 'Others') othersExtra++;
    int othersFilled = 0;
    if (_salutation == 'Others' && _otherSalutation.trim().isNotEmpty) {
      othersFilled++;
    }
    if (_selectedGender == 'Others' && _otherGender.trim().isNotEmpty) {
      othersFilled++;
    }
    if (_selectedMaritalStatus == 'Others' &&
        _otherMaritalStatus.trim().isNotEmpty) {
      othersFilled++;
    }
    if (_selectedCustomerType == 'Others' &&
        _otherCustomerType.trim().isNotEmpty) {
      othersFilled++;
    }
    filled += othersFilled;
    final totalRequired = 2 + othersExtra;
    widget.onCompulsoryChanged?.call(filled);
    widget.onDataChanged?.call({
      'firstName': _firstNameCtrl.text.trim(),
      'middleName': _middleNameCtrl.text.trim(),
      'lastName': _lastNameCtrl.text.trim(),
      'nickname': _nicknameCtrl.text.trim(),
      'primaryMobile': _mobileCtrl.text.trim(),
      'primaryEmail': _emailCtrl.text.trim(),
      'name': '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'
          .trim(),
      'phone': _mobileCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'customerType': _selectedCustomerType == 'Others'
          ? _otherCustomerType
          : _selectedCustomerType,
      'pan': _panCtrl.text.trim(),
      'aadhaar': _aadhaarCtrl.text.trim(),
      'gstin': _gstinCtrl.text.trim(),
      'passport': _passportCtrl.text.trim(),
      'tfn': _tfnCtrl.text.trim(),
      'medicareCard': _medicareCtrl.text.trim(),
      'medicareIrn': _medicareIrnCtrl.text.trim(),
      'preferredLanguage': _selectedLanguage,
      'bestTimeToCall': _selectedBestTimeToCall,
      'timezone': _selectedTimezone,
      'optInSMS': _optInSMS,
      'optInEmail': _optInEmail,
      'optInVoice': _optInVoice,
      'optInWhatsApp': _optInWhatsApp,
      'spouseName': _spouseNameCtrl.text.trim(),
      'dependents': _dependentsCtrl.text.trim(),
      'annualIncome': _annualIncomeCtrl.text.trim(),
      'taxResidency': _selectedTaxResidency,
      'occupation': _occupationCtrl.text.trim(),
      'degree': _degreeCtrl.text.trim(),
      'companyWorking': _companyWorkingCtrl.text.trim(),
      'workingSalary': _workingSalaryCtrl.text.trim(),
      'yearsOfService': _yearsOfServiceCtrl.text.trim(),
      '_contactRequiredTotal': totalRequired,
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefillData != null) {
      final d = widget.prefillData!;
      _firstNameCtrl.text =
          d['firstName'] as String? ??
          (d['name'] as String? ?? '').split(' ').first;
      _lastNameCtrl.text = d['lastName'] as String? ?? '';
      _mobileCtrl.text =
          d['primaryMobile'] as String? ?? d['phone'] as String? ?? '';
      _emailCtrl.text =
          d['primaryEmail'] as String? ?? d['email'] as String? ?? '';
    }
    _firstNameCtrl.addListener(_notifyParent);
    _mobileCtrl.addListener(_notifyParent);
    _emailCtrl.addListener(_notifyParent);
    _lastNameCtrl.addListener(_notifyParent);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _nicknameCtrl.dispose();
    _mobileCtrl.dispose();
    _altPhoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _email2Ctrl.dispose();
    _panCtrl.dispose();
    _aadhaarCtrl.dispose();
    _gstinCtrl.dispose();
    _passportCtrl.dispose();
    _tfnCtrl.dispose();
    _medicareCtrl.dispose();
    _medicareIrnCtrl.dispose();
    _spouseNameCtrl.dispose();
    _dependentsCtrl.dispose();
    _annualIncomeCtrl.dispose();
    _occupationCtrl.dispose();
    _degreeCtrl.dispose();
    _companyWorkingCtrl.dispose();
    _workingSalaryCtrl.dispose();
    _yearsOfServiceCtrl.dispose();
    super.dispose();
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          isExpanded: true,
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          icon: const Icon(Icons.expand_more_rounded, size: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compulsory notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withAlpha(80),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primary.withAlpha(60)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '2 required: First Name, Primary Mobile (Email is optional)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Customer Type ──────────────────────────────────────────────────
        _SectionLabel('Customer Type'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _customerTypes.map((t) {
            final isSelected = _selectedCustomerType == t;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedCustomerType = t;
                if (t != 'Others') _otherCustomerType = '';
                _notifyParent();
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surface200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Visibility(
          visible: _selectedCustomerType == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Customer Type *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedCustomerType == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherCustomerType = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Profile Photo ──────────────────────────────────────────────────
        _SectionLabel('Profile Photo'),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(60),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withAlpha(80),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 28,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: Text(
                    'Camera',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    side: BorderSide(color: AppTheme.primary.withAlpha(120)),
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_library_outlined, size: 16),
                  label: Text(
                    'Gallery',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    side: BorderSide(color: AppTheme.surface200),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Salutation ─────────────────────────────────────────────────────
        _SectionLabel('Salutation'),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _salutation,
              isExpanded: true,
              items: _salutations
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _salutation = v!;
                if (v != 'Others') _otherSalutation = '';
                _notifyParent();
              }),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
              icon: const Icon(Icons.expand_more_rounded, size: 18),
            ),
          ),
        ),
        Visibility(
          visible: _salutation == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Salutation *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _salutation == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherSalutation = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Name Fields ────────────────────────────────────────────────────
        TextFormField(
          controller: _firstNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'First Name *',
            prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _middleNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Middle Name / Maiden Name',
            prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _lastNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nicknameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nickname / Preferred Name',
            prefixIcon: Icon(Icons.badge_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 20),

        // ── Phone Numbers ──────────────────────────────────────────────────
        _SectionLabel('Phone Numbers'),
        const SizedBox(height: 8),
        _PhoneFieldWithCode(
          label: 'Primary Mobile *',
          controller: _mobileCtrl,
          isRequired: true,
          onChanged: (v) {
            if (_whatsappSameAsMobile) setState(() => _whatsappCtrl.text = v);
          },
        ),
        const SizedBox(height: 12),
        _PhoneFieldWithCode(
          label: 'Alternate Phone',
          controller: _altPhoneCtrl,
        ),
        const SizedBox(height: 12),
        _PhoneFieldWithCode(label: 'WhatsApp', controller: _whatsappCtrl),
        const SizedBox(height: 8),
        Row(
          children: [
            Switch(
              value: _whatsappSameAsMobile,
              onChanged: (v) {
                setState(() {
                  _whatsappSameAsMobile = v;
                  if (v) _whatsappCtrl.text = _mobileCtrl.text;
                });
              },
              activeThumbColor: AppTheme.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Text(
              'WhatsApp same as Primary Mobile',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Email Addresses ────────────────────────────────────────────────
        _SectionLabel('Email Addresses'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Primary Email',
            prefixIcon: const Icon(Icons.email_outlined, size: 18),
            suffixIcon: _emailCtrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => setState(() => _emailCtrl.clear()),
                  )
                : null,
          ),
          onChanged: (_) => setState(() {}),
          validator: (v) {
            if (v != null && v.isNotEmpty && !v.contains('@')) {
              return 'Invalid email format';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email2Ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Secondary Email',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 16),

        // ── Professional Details ───────────────────────────────────────────
        _buildAccordion(
          title: 'Professional Details',
          icon: Icons.work_outline_rounded,
          isExpanded: true,
          onTap: () {},
          collapsible: false,
          child: _buildProfessionalDetails(),
        ),
        const SizedBox(height: 8),

        // ── Communication Opt-ins ──────────────────────────────────────────
        _buildAccordion(
          title: 'Communication Opt-ins',
          icon: Icons.notifications_active_outlined,
          isExpanded: _showCommPrefs,
          onTap: () => setState(() => _showCommPrefs = !_showCommPrefs),
          child: _buildCommOptIns(),
        ),
        const SizedBox(height: 8),

        // ── Contact Preferences ────────────────────────────────────────────
        _buildAccordion(
          title: 'Contact Preferences',
          icon: Icons.tune_rounded,
          isExpanded: _showPersonalDetails,
          onTap: () =>
              setState(() => _showPersonalDetails = !_showPersonalDetails),
          child: _buildContactPreferences(),
        ),
        const SizedBox(height: 8),

        // ── Demographics ───────────────────────────────────────────────────
        _buildAccordion(
          title: 'Demographics & Personal',
          icon: Icons.person_pin_outlined,
          isExpanded: _showDemographics,
          onTap: () => setState(() => _showDemographics = !_showDemographics),
          child: _buildDemographics(),
        ),
        const SizedBox(height: 8),

        // ── Identity & Tax Documents ───────────────────────────────────────
        _buildAccordion(
          title: 'Identity & Tax Documents',
          icon: Icons.badge_outlined,
          isExpanded: _showIdentityDocs,
          onTap: () => setState(() => _showIdentityDocs = !_showIdentityDocs),
          child: _buildIdentityDocs(),
        ),
      ],
    );
  }

  Widget _buildAccordion({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
    bool collapsible = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: collapsible ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (collapsible)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: child,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommOptIns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 8),
        Text(
          'Select channels the lead has consented to be contacted via:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        _buildOptInRow(
          Icons.sms_outlined,
          'SMS',
          _optInSMS,
          (v) => setState(() {
            _optInSMS = v;
            _notifyParent();
          }),
        ),
        _buildOptInRow(
          Icons.email_outlined,
          'Email',
          _optInEmail,
          (v) => setState(() {
            _optInEmail = v;
            _notifyParent();
          }),
        ),
        _buildOptInRow(
          Icons.phone_outlined,
          'Voice Call',
          _optInVoice,
          (v) => setState(() {
            _optInVoice = v;
            _notifyParent();
          }),
        ),
        _buildOptInRow(
          Icons.chat_outlined,
          'WhatsApp',
          _optInWhatsApp,
          (v) => setState(() {
            _optInWhatsApp = v;
            _notifyParent();
          }),
        ),
      ],
    );
  }

  Widget _buildOptInRow(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: value ? AppTheme.success : AppTheme.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.success,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildContactPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        _SectionLabel('Preferred Language'),
        const SizedBox(height: 8),
        _buildDropdown(
          label: 'Select Language',
          value: _selectedLanguage,
          items: _languages,
          onChanged: (v) => setState(() {
            _selectedLanguage = v ?? '';
            _notifyParent();
          }),
        ),
        const SizedBox(height: 12),
        _SectionLabel('Best Time to Call'),
        const SizedBox(height: 8),
        _buildDropdown(
          label: 'Select Time',
          value: _selectedBestTimeToCall,
          items: _bestTimesToCall,
          onChanged: (v) => setState(() {
            _selectedBestTimeToCall = v ?? '';
            _notifyParent();
          }),
        ),
        const SizedBox(height: 12),
        _SectionLabel('Time Zone'),
        const SizedBox(height: 8),
        _buildDropdown(
          label: 'Select Timezone',
          value: _selectedTimezone,
          items: _timezones,
          onChanged: (v) => setState(() {
            _selectedTimezone = v ?? '';
            _notifyParent();
          }),
        ),
      ],
    );
  }

  Widget _buildDemographics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        // DOB
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(1990),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _dobDate = picked;
                _notifyParent();
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cake_outlined,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  _dobDate != null
                      ? 'DOB: ${_dobDate!.day}/${_dobDate!.month}/${_dobDate!.year}'
                      : 'Date of Birth',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: _dobDate != null
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Anniversary
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _anniversaryDate = picked;
                _notifyParent();
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  _anniversaryDate != null
                      ? 'Anniversary: ${_anniversaryDate!.day}/${_anniversaryDate!.month}/${_anniversaryDate!.year}'
                      : 'Anniversary Date',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: _anniversaryDate != null
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Gender
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Gender',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender.isEmpty ? null : _selectedGender,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _genders
                  .map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Text(
                        g,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedGender = v ?? '';
                if (v != 'Others') _otherGender = '';
                _notifyParent();
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: _selectedGender == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Gender *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedGender == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherGender = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Marital Status
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Marital Status',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMaritalStatus.isEmpty
                  ? null
                  : _selectedMaritalStatus,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _maritalStatuses
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(
                        m,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedMaritalStatus = v ?? '';
                if (v != 'Others') _otherMaritalStatus = '';
                _notifyParent();
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: _selectedMaritalStatus == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Marital Status *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedMaritalStatus == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherMaritalStatus = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _spouseNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Spouse Name',
            prefixIcon: Icon(Icons.favorite_border_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dependentsCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Dependents',
            prefixIcon: Icon(Icons.family_restroom_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _annualIncomeCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Personal Annual Income (₹)',
            prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityDocs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        // Tax Residency
        _SectionLabel('Tax Residency Status'),
        const SizedBox(height: 8),
        _buildDropdown(
          label: 'Select Status',
          value: _selectedTaxResidency,
          items: _taxResidencies,
          onChanged: (v) => setState(() {
            _selectedTaxResidency = v ?? '';
            _notifyParent();
          }),
        ),
        const SizedBox(height: 12),
        // India fields
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFF9800).withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'India Documents',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _MaskedTextField(
                controller: _panCtrl,
                label: 'PAN Number',
                hint: 'ABCDE1234F',
                icon: Icons.credit_card_outlined,
              ),
              const SizedBox(height: 10),
              _MaskedTextField(
                controller: _aadhaarCtrl,
                label: 'Aadhaar Number',
                hint: 'XXXX XXXX XXXX',
                icon: Icons.fingerprint_rounded,
              ),
              const SizedBox(height: 10),
              _MaskedTextField(
                controller: _gstinCtrl,
                label: 'GSTIN',
                hint: '22AAAAA0000A1Z5',
                icon: Icons.receipt_long_outlined,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passportCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Passport Number',
                  prefixIcon: Icon(Icons.book_outlined, size: 18),
                ),
              ),
            ],
          ),
        ),
        // ATO section removed as requested
        const SizedBox(height: 0),
      ],
    );
  }

  Widget _buildProfessionalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        TextFormField(
          controller: _occupationCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Occupation',
            prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
          ),
          onChanged: (_) => _notifyParent(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _degreeCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Degree / Qualification',
            prefixIcon: Icon(Icons.school_outlined, size: 18),
          ),
          onChanged: (_) => _notifyParent(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _companyWorkingCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Company / Organisation Name',
            prefixIcon: Icon(Icons.business_outlined, size: 18),
          ),
          onChanged: (_) => _notifyParent(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _workingSalaryCtrl,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Working Salary / Annual Income',
            prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
            hintText: 'e.g. ₹12,00,000 per annum',
          ),
          onChanged: (_) => _notifyParent(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _yearsOfServiceCtrl,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Years of Service / Experience',
            prefixIcon: Icon(Icons.timeline_rounded, size: 18),
            hintText: 'e.g. 5 years',
          ),
          onChanged: (_) => _notifyParent(),
        ),
      ],
    );
  }
}