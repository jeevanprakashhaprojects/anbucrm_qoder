import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

// ─── Country Data ─────────────────────────────────────────────────────────────

class _Country {
  final String name;
  final String code;
  final String flag;
  const _Country(this.name, this.code, this.flag);
}

const List<_Country> _kCountries = [
  _Country('India', '+91', '🇮🇳'),
  _Country('United States', '+1', '🇺🇸'),
  _Country('United Kingdom', '+44', '🇬🇧'),
  _Country('Australia', '+61', '🇦🇺'),
  _Country('Canada', '+1', '🇨🇦'),
  _Country('Germany', '+49', '🇩🇪'),
  _Country('France', '+33', '🇫🇷'),
  _Country('Japan', '+81', '🇯🇵'),
  _Country('China', '+86', '🇨🇳'),
  _Country('Brazil', '+55', '🇧🇷'),
  _Country('Mexico', '+52', '🇲🇽'),
  _Country('South Africa', '+27', '🇿🇦'),
  _Country('Nigeria', '+234', '🇳🇬'),
  _Country('Kenya', '+254', '🇰🇪'),
  _Country('Egypt', '+20', '🇪🇬'),
  _Country('Saudi Arabia', '+966', '🇸🇦'),
  _Country('UAE', '+971', '🇦🇪'),
  _Country('Singapore', '+65', '🇸🇬'),
  _Country('Malaysia', '+60', '🇲🇾'),
  _Country('Indonesia', '+62', '🇮🇩'),
  _Country('Pakistan', '+92', '🇵🇰'),
  _Country('Bangladesh', '+880', '🇧🇩'),
  _Country('Sri Lanka', '+94', '🇱🇰'),
  _Country('Nepal', '+977', '🇳🇵'),
  _Country('Thailand', '+66', '🇹🇭'),
  _Country('Vietnam', '+84', '🇻🇳'),
  _Country('Philippines', '+63', '🇵🇭'),
  _Country('South Korea', '+82', '🇰🇷'),
  _Country('Russia', '+7', '🇷🇺'),
  _Country('Italy', '+39', '🇮🇹'),
  _Country('Spain', '+34', '🇪🇸'),
  _Country('Netherlands', '+31', '🇳🇱'),
  _Country('Sweden', '+46', '🇸🇪'),
  _Country('Norway', '+47', '🇳🇴'),
  _Country('Denmark', '+45', '🇩🇰'),
  _Country('Switzerland', '+41', '🇨🇭'),
  _Country('Poland', '+48', '🇵🇱'),
  _Country('Turkey', '+90', '🇹🇷'),
  _Country('Argentina', '+54', '🇦🇷'),
  _Country('Chile', '+56', '🇨🇱'),
  _Country('Colombia', '+57', '🇨🇴'),
  _Country('Peru', '+51', '🇵🇪'),
  _Country('Venezuela', '+58', '🇻🇪'),
  _Country('New Zealand', '+64', '🇳🇿'),
  _Country('Ireland', '+353', '🇮🇪'),
  _Country('Portugal', '+351', '🇵🇹'),
  _Country('Greece', '+30', '🇬🇷'),
  _Country('Israel', '+972', '🇮🇱'),
  _Country('Qatar', '+974', '🇶🇦'),
  _Country('Kuwait', '+965', '🇰🇼'),
  _Country('Bahrain', '+973', '🇧🇭'),
  _Country('Oman', '+968', '🇴🇲'),
  _Country('Jordan', '+962', '🇯🇴'),
  _Country('Lebanon', '+961', '🇱🇧'),
  _Country('Iraq', '+964', '🇮🇶'),
  _Country('Iran', '+98', '🇮🇷'),
  _Country('Afghanistan', '+93', '🇦🇫'),
  _Country('Myanmar', '+95', '🇲🇲'),
  _Country('Cambodia', '+855', '🇰🇭'),
  _Country('Laos', '+856', '🇱🇦'),
  _Country('Mongolia', '+976', '🇲🇳'),
  _Country('Kazakhstan', '+7', '🇰🇿'),
  _Country('Ukraine', '+380', '🇺🇦'),
  _Country('Romania', '+40', '🇷🇴'),
  _Country('Hungary', '+36', '🇭🇺'),
  _Country('Czech Republic', '+420', '🇨🇿'),
  _Country('Austria', '+43', '🇦🇹'),
  _Country('Belgium', '+32', '🇧🇪'),
  _Country('Finland', '+358', '🇫🇮'),
  _Country('Morocco', '+212', '🇲🇦'),
  _Country('Algeria', '+213', '🇩🇿'),
  _Country('Tunisia', '+216', '🇹🇳'),
  _Country('Ethiopia', '+251', '🇪🇹'),
  _Country('Ghana', '+233', '🇬🇭'),
  _Country('Tanzania', '+255', '🇹🇿'),
  _Country('Uganda', '+256', '🇺🇬'),
  _Country('Zimbabwe', '+263', '🇿🇼'),
  _Country('Zambia', '+260', '🇿🇲'),
  _Country('Mozambique', '+258', '🇲🇿'),
  _Country('Cameroon', '+237', '🇨🇲'),
  _Country('Ivory Coast', '+225', '🇨🇮'),
  _Country('Senegal', '+221', '🇸🇳'),
  _Country('Jamaica', '+1', '🇯🇲'),
  _Country('Trinidad & Tobago', '+1', '🇹🇹'),
  _Country('Barbados', '+1', '🇧🇧'),
  _Country('Cuba', '+53', '🇨🇺'),
  _Country('Dominican Republic', '+1', '🇩🇴'),
  _Country('Guatemala', '+502', '🇬🇹'),
  _Country('Honduras', '+504', '🇭🇳'),
  _Country('El Salvador', '+503', '🇸🇻'),
  _Country('Costa Rica', '+506', '🇨🇷'),
  _Country('Panama', '+507', '🇵🇦'),
  _Country('Ecuador', '+593', '🇪🇨'),
  _Country('Bolivia', '+591', '🇧🇴'),
  _Country('Paraguay', '+595', '🇵🇾'),
  _Country('Uruguay', '+598', '🇺🇾'),
];

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
  List<_Country> _filtered = _kCountries;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = _kCountries
          .where(
            (c) => c.name.toLowerCase().contains(lower) || c.code.contains(q),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
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
                Text(
                  'Select Country Code',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
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
          // List
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  trailing: Text(
                    country.code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
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
  _Country _selectedCountry = _kCountries.first; // India default

  // Security
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _termsAccepted = false;

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
    super.dispose();
  }

  void _goToStep(int step) {
    _stepController.reset();
    setState(() => _step = step);
    _stepController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
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
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 0 : 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 480 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back button
                      if (_step < 4)
                        GestureDetector(
                          onTap: () {
                            if (_step > 0) {
                              _goToStep(_step - 1);
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
                              border: Border.all(color: AppTheme.surface200),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      if (_step < 4) const SizedBox(height: 24),
                      // Step indicator (steps 0-2) — consistent equal gaps
                      if (_step < 3) ...[
                        _CreateAccountStepIndicator(currentStep: _step),
                        const SizedBox(height: 28),
                      ],
                      // Content
                      FadeTransition(
                        opacity: _stepOpacity,
                        child: SlideTransition(
                          position: _stepSlide,
                          child: _buildContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Payment overlay
          if (_step == 3)
            _PaymentOverlay(
              name: _nameController.text,
              email: _emailController.text,
              onSuccess: () => _goToStep(4),
            ),
        ],
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
          onNext: () => _goToStep(1),
        );
      case 1:
        return _SecurityStep(
          passwordController: _passwordController,
          confirmController: _confirmController,
          termsAccepted: _termsAccepted,
          onTermsChanged: (v) => setState(() => _termsAccepted = v),
          onNext: () => _goToStep(2),
        );
      case 2:
        return _ReviewStep(
          name: _nameController.text,
          email: _emailController.text,
          phone: _formattedPhone,
          countryCode: _selectedCountry.code,
          onEdit: (step) => _goToStep(step),
          onProceedToPayment: () => _goToStep(3),
        );
      case 4:
        return _SuccessStep(
          name: _nameController.text,
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
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${currentStep + 1} of 3',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              _StepCircle(
                index: i,
                isActive: i == currentStep,
                isDone: i < currentStep,
                label: _steps[i].label,
                icon: _steps[i].icon,
              ),
              if (i < 2)
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
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
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

  const _PersonalInfoStep({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.formattedPhone,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.onNext,
  });

  @override
  State<_PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<_PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  bool _hasSubmitted = false;

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
          onSelect: widget.onCountryChanged,
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
          Text(
            'Personal Information',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tell us a bit about yourself to get started.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          // Name
          _FieldLabel(label: 'Full Name'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.nameController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            onChanged: (_) {
              setState(() {});
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: InputDecoration(
              hintText: 'John Doe',
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
              suffixText: '${widget.nameController.text.length}/50',
              suffixStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textMuted,
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
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: const InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@') || !v.contains('.')) {
                return 'Enter a valid email';
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
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
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
                    controller: widget.phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                    onChanged: (_) {
                      if (_hasSubmitted) _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
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
                      if (!_hasSubmitted) return null;
                      if (v == null || v.isEmpty) {
                        return 'Enter your phone number';
                      }
                      if (v.length < 7) return 'Enter a valid phone number';
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          _PrimaryButton(
            label: 'Continue to Security',
            onTap: () {
              setState(() => _hasSubmitted = true);
              if (_formKey.currentState!.validate()) widget.onNext();
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
  final bool termsAccepted;
  final Function(bool) onTermsChanged;
  final VoidCallback onNext;

  const _SecurityStep({
    required this.passwordController,
    required this.confirmController,
    required this.termsAccepted,
    required this.onTermsChanged,
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

  bool get _hasLength => widget.passwordController.text.length >= 8;
  bool get _hasUpperLower =>
      widget.passwordController.text.contains(RegExp(r'[A-Z]')) &&
      widget.passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber =>
      widget.passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => widget.passwordController.text.contains(
    RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
  );

  double get _strengthScore {
    int score = 0;
    if (_hasLength) score++;
    if (_hasUpperLower) score++;
    if (_hasNumber) score++;
    if (_hasSpecial) score++;
    return score / 4;
  }

  String get _strengthLabel {
    final s = _strengthScore;
    if (s <= 0.25) return 'Weak';
    if (s <= 0.5) return 'Fair';
    if (s <= 0.75) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    final s = _strengthScore;
    if (s <= 0.25) return AppTheme.error;
    if (s <= 0.5) return const Color(0xFFD97706);
    if (s <= 0.75) return const Color(0xFF0EA5E9);
    return AppTheme.success;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Security Setup',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create a strong password to protect your account.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              setState(() {});
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
              if (!_hasLength) return 'At least 8 characters required';
              return null;
            },
          ),
          if (widget.passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            // Strength bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _strengthScore,
                      backgroundColor: AppTheme.surface200,
                      valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _strengthLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _strengthColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Rules
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
                    met: _hasLength,
                  ),
                  const SizedBox(height: 4),
                  _AnimatedRuleRow(
                    label: 'Uppercase & lowercase',
                    met: _hasUpperLower,
                  ),
                  const SizedBox(height: 4),
                  _AnimatedRuleRow(
                    label: 'At least one number',
                    met: _hasNumber,
                  ),
                  const SizedBox(height: 4),
                  _AnimatedRuleRow(
                    label: 'Special character (!@#\$...)',
                    met: _hasSpecial,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _FieldLabel(label: 'Confirm Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.confirmController,
            obscureText: _obscureConfirm,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
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
          // Terms checkbox
          GestureDetector(
            onTap: () => widget.onTermsChanged(!widget.termsAccepted),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: widget.termsAccepted
                        ? AppTheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: widget.termsAccepted
                          ? AppTheme.primary
                          : AppTheme.surface200,
                      width: 2,
                    ),
                  ),
                  child: widget.termsAccepted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 13,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'Review & Continue',
            enabled: widget.termsAccepted,
            onTap: () {
              setState(() => _hasSubmitted = true);
              if (!widget.termsAccepted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please accept the Terms and Conditions',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    backgroundColor: AppTheme.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                return;
              }
              if (_formKey.currentState!.validate()) widget.onNext();
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.signUpLoginScreen),
                child: Text(
                  'Login',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
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
  final VoidCallback onProceedToPayment;

  const _ReviewStep({
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.onEdit,
    required this.onProceedToPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Review Your Details',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Please confirm your information before proceeding to payment.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
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
          items: [
            _ReviewItem(label: 'Password', value: '••••••••'),
            _ReviewItem(label: 'Terms', value: '✓ Accepted'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Plan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'All CRM features included',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹500',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '/month',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _PrimaryButton(
          label: 'Proceed to Payment  →',
          onTap: onProceedToPayment,
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
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
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
                    child: Text(
                      item.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.value,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
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

// ─── Payment Overlay ──────────────────────────────────────────────────────────

class _PaymentOverlay extends StatefulWidget {
  final String name;
  final String email;
  final VoidCallback onSuccess;

  const _PaymentOverlay({
    required this.name,
    required this.email,
    required this.onSuccess,
  });

  @override
  State<_PaymentOverlay> createState() => _PaymentOverlayState();
}

class _PaymentOverlayState extends State<_PaymentOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  int _stage = 0;
  final List<String> _stages = [
    'Processing payment...',
    'Verifying transaction...',
    'Creating your account...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _runPaymentFlow();
  }

  Future<void> _runPaymentFlow() async {
    for (int i = 0; i < _stages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) setState(() => _stage = i);
    }
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) widget.onSuccess();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        color: Colors.black.withAlpha(180),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Secure Payment',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _stages[_stage],
                    key: ValueKey(_stage),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_stages.length, (i) {
                    final isDone = i < _stage;
                    final isActive = i == _stage;
                    return Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? AppTheme.success
                                : isActive
                                ? AppTheme.primary
                                : AppTheme.surface200,
                          ),
                        ),
                        if (i < _stages.length - 1)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 24,
                            height: 2,
                            color: isDone
                                ? AppTheme.success
                                : AppTheme.surface200,
                          ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 12,
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '256-bit SSL encrypted',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step 5: Success ──────────────────────────────────────────────────────────

class _SuccessStep extends StatefulWidget {
  final String name;
  final VoidCallback onGoToLogin;

  const _SuccessStep({required this.name, required this.onGoToLogin});

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
            const SizedBox(height: 40),
            Center(
              child: ScaleTransition(
                scale: _checkScale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.success, Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withAlpha(80),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _contentFade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Account Created\nSuccessfully! 🎉',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name.isNotEmpty
                        ? 'Welcome to AnbuCRM, ${widget.name.split(' ').first}! Your account is ready and your Basic Plan is now active.'
                        : 'Welcome to AnbuCRM! Your account is ready and your Basic Plan is now active.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withAlpha(15),
                          const Color(0xFF7C3AED).withAlpha(15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.primary.withAlpha(40)),
                    ),
                    child: Column(
                      children: [
                        _SuccessDetailRow(
                          icon: Icons.workspace_premium_rounded,
                          label: 'Plan',
                          value: 'Basic Plan — ₹500/month',
                        ),
                        const SizedBox(height: 8),
                        _SuccessDetailRow(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Status',
                          value: 'Active',
                          valueColor: AppTheme.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
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
        Text(
          '$label: ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimary,
            ),
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: met ? AppTheme.success : AppTheme.textSecondary,
            fontWeight: met ? FontWeight.w500 : FontWeight.w400,
          ),
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
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
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
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.white : AppTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
