import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  int _step = 0; // 0=email, 1=otp, 2=new password, 3=success
  String _email = '';
  String _resetToken = '';

  late AnimationController _stepController;
  late Animation<double> _stepOpacity;
  late Animation<Offset> _stepSlide;

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
    _stepSlide = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _stepController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _stepController.reset();
    setState(() => _step = step);
    _stepController.forward();
  }

  void _onEmailVerified(String email) {
    _email = email;
    _goToStep(1);
  }

  void _onOtpVerified(String token) {
    _resetToken = token;
    _goToStep(2);
  }

  void _onPasswordReset() {
    _goToStep(3);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withAlpha(25),
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
                    maxWidth: isTablet ? 440 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back button — matches login screen style (36×36)
                      if (_step < 3)
                        GestureDetector(
                          onTap: () {
                            if (_step > 0) {
                              _goToStep(_step - 1);
                            } else {
                              context.go(AppRoutes.signUpLoginScreen);
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
                      if (_step < 3) const SizedBox(height: 28),
                      // Step indicator — only show for steps 0-2
                      if (_step < 3) ...[
                        _StepIndicator(currentStep: _step),
                        const SizedBox(height: 32),
                      ],
                      // Step content
                      FadeTransition(
                        opacity: _stepOpacity,
                        child: SlideTransition(
                          position: _stepSlide,
                          child: _buildStepContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _EmailStep(onNext: _onEmailVerified);
      case 1:
        return _OtpStep(email: _email, onNext: _onOtpVerified);
      case 2:
        return _NewPasswordStep(
          email: _email,
          resetToken: _resetToken,
          onSuccess: _onPasswordReset,
        );
      case 3:
        return _ResetSuccessStep(
          onGoToLogin: () => context.go(AppRoutes.signUpLoginScreen),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Step Indicator (consistent equal gaps) ───────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _labels = ['Verify Email', 'Enter OTP', 'New Password'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++) ...[
          _StepCircle(
            index: i,
            isActive: i == currentStep,
            isDone: i < currentStep,
            label: _labels[i],
          ),
          if (i < 2)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 26),
                color: i < currentStep ? AppTheme.success : AppTheme.surface200,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isDone;
  final String label;

  const _StepCircle({
    required this.index,
    required this.isActive,
    required this.isDone,
    required this.label,
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
                  : Text(
                      '${index + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
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

// ─── Step 1: Email ────────────────────────────────────────────────────────────

class _EmailStep extends StatefulWidget {
  final Function(String) onNext;
  const _EmailStep({required this.onNext});

  @override
  State<_EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<_EmailStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _hasSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _hasSubmitted = true);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isLoading = false);
    widget.onNext(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: AppTheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Forgot Password?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your registered email and we'll send a verification code to reset your password.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          _FieldLabel(label: 'Email Address'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_hasSubmitted) {
                _formKey.currentState?.validate();
              }
            },
            decoration: const InputDecoration(
              hintText: 'you@anbucrm.in',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _ActionButton(
            label: 'Send Verification Code',
            isLoading: _isLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: OTP ──────────────────────────────────────────────────────────────

class _OtpStep extends StatefulWidget {
  final String email;
  final Function(String) onNext;
  const _OtpStep({required this.email, required this.onNext});

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _hasError = false;
  int _resendSeconds = 60;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _startResendTimer();
  }

  void _startResendTimer() async {
    while (_resendSeconds > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _resendSeconds--);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Clear error immediately when typing
    if (_hasError) setState(() => _hasError = false);
    if (_otp.length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length < 6) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (_otp == '000000') {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _shakeController.forward(from: 0);
      return;
    }
    setState(() => _isLoading = false);
    widget.onNext('reset_token_demo_${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.verified_outlined,
            color: Color(0xFFD97706),
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Enter Verification Code',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: widget.email,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _shakeAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(
              _hasError ? ((_shakeAnim.value * 10) % 2 == 0 ? 6 : -6) : 0,
              0,
            ),
            child: child,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 46,
                height: 54,
                child: TextFormField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: _hasError
                        ? AppTheme.errorContainer
                        : AppTheme.surfaceLight,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _hasError ? AppTheme.error : AppTheme.surface200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (v) => _onDigitChanged(i, v),
                  onTap: () {
                    _controllers[i].selection = TextSelection.fromPosition(
                      TextPosition(offset: _controllers[i].text.length),
                    );
                  },
                ),
              );
            }),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: 10),
          Text(
            'Invalid OTP. Please try again.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.error,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        _ActionButton(
          label: 'Verify Code',
          isLoading: _isLoading,
          onTap: _verifyOtp,
          enabled: _otp.length == 6,
        ),
        const SizedBox(height: 20),
        Center(
          child: _resendSeconds > 0
              ? RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Resend code in '),
                      TextSpan(
                        text:
                            '${_resendSeconds ~/ 60}:${(_resendSeconds % 60).toString().padLeft(2, '0')}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() => _resendSeconds = 60);
                    _startResendTimer();
                  },
                  child: Text(
                    'Resend OTP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Hint: Enter any 6 digits (except 000000)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: New Password ─────────────────────────────────────────────────────

class _NewPasswordStep extends StatefulWidget {
  final String email;
  final String resetToken;
  final VoidCallback onSuccess;

  const _NewPasswordStep({
    required this.email,
    required this.resetToken,
    required this.onSuccess,
  });

  @override
  State<_NewPasswordStep> createState() => _NewPasswordStepState();
}

class _NewPasswordStepState extends State<_NewPasswordStep> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _hasSubmitted = false;

  bool get _hasLength => _passwordController.text.length >= 8;
  bool get _hasUpperLower =>
      _passwordController.text.contains(RegExp(r'[A-Z]')) &&
      _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _hasSubmitted = true);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isLoading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppTheme.success,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Create New Password',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your new password must be different from previously used passwords.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          _FieldLabel(label: 'New Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureNew,
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
                  _obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter a new password';
              if (!_hasLength) return 'At least 8 characters required';
              return null;
            },
          ),
          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            _PasswordRulesWidget(
              hasLength: _hasLength,
              hasUpperLower: _hasUpperLower,
              hasNumber: _hasNumber,
              hasSpecial: _hasSpecial,
            ),
          ],
          const SizedBox(height: 16),
          _FieldLabel(label: 'Confirm Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmController,
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
              if (v != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          _ActionButton(
            label: 'Reset Password',
            isLoading: _isLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

// ─── Step 4: Reset Success ────────────────────────────────────────────────────

class _ResetSuccessStep extends StatefulWidget {
  final VoidCallback onGoToLogin;
  const _ResetSuccessStep({required this.onGoToLogin});

  @override
  State<_ResetSuccessStep> createState() => _ResetSuccessStepState();
}

class _ResetSuccessStepState extends State<_ResetSuccessStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: ScaleTransition(
            scale: _scaleAnim,
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
        const SizedBox(height: 32),
        FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Password Reset\nSuccessfully!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your password has been updated successfully. You can now sign in with your new password.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.success.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppTheme.success,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your account is now secured with the new password.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.success,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              _ActionButton(
                label: 'Back to Sign In',
                isLoading: false,
                onTap: widget.onGoToLogin,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Password Rules Widget ────────────────────────────────────────────────────

class _PasswordRulesWidget extends StatelessWidget {
  final bool hasLength;
  final bool hasUpperLower;
  final bool hasNumber;
  final bool hasSpecial;

  const _PasswordRulesWidget({
    required this.hasLength,
    required this.hasUpperLower,
    required this.hasNumber,
    required this.hasSpecial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _RuleRow(label: 'At least 8 characters', met: hasLength),
          const SizedBox(height: 4),
          _RuleRow(label: 'Uppercase & lowercase letters', met: hasUpperLower),
          const SizedBox(height: 4),
          _RuleRow(label: 'At least one number', met: hasNumber),
          const SizedBox(height: 4),
          _RuleRow(label: 'Special character (!@#\$...)', met: hasSpecial),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final String label;
  final bool met;
  const _RuleRow({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: met ? AppTheme.success : AppTheme.textSecondary,
            fontWeight: met ? FontWeight.w500 : FontWeight.w400,
          ),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !isLoading ? onTap : null,
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
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
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
