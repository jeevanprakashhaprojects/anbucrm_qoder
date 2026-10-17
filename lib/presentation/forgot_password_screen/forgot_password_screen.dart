import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class _S {
  static final _base = GoogleFonts.plusJakartaSans();
  static final title = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppTheme.textPrimary,
    letterSpacing: -0.5,
  );
  static final body = _base.copyWith(
    fontSize: 13,
    color: AppTheme.textSecondary,
    height: 1.6,
  );
  static final label = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  static final field = _base.copyWith(
    fontSize: 14,
    color: AppTheme.textPrimary,
  );
  static final error = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppTheme.error,
    height: 1.5,
  );
  static final button = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static final _emailPattern = RegExp(
    r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+"
    r"(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*"
    r'@(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+'
    r'[A-Za-z](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])$',
  );

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  Timer? _resendTimer;
  DateTime? _resendAvailableAt;
  int _resendSeconds = 0;
  bool _hasSubmitted = false;
  bool _isLoading = false;
  bool _hasRequested = false;
  String _requestedEmail = '';
  String? _requestError;

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Enter your email address.';
    if (email.length > 254 ||
        !_emailPattern.hasMatch(email) ||
        email.split('@').first.length > 64) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    _resendAvailableAt = DateTime.now().add(const Duration(seconds: 60));
    _resendSeconds = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      // Use elapsed time so opening the email app does not pause the cooldown.
      final remaining = _resendAvailableAt!.difference(DateTime.now());
      final seconds = (remaining.inMilliseconds / 1000).ceil().clamp(0, 60);
      if (seconds != _resendSeconds) {
        setState(() => _resendSeconds = seconds);
      }
      if (seconds == 0) timer.cancel();
    });
  }

  Future<void> _submit() async {
    if (_isLoading || _resendSeconds > 0) return;
    if (!_hasRequested) {
      setState(() => _hasSubmitted = true);
      if (!(_formKey.currentState?.validate() ?? false)) return;
    }
    final email = _hasRequested
        ? _requestedEmail
        : _emailController.text.trim();
    setState(() {
      _isLoading = true;
      _requestError = null;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await AuthService.instance.requestPasswordReset(email);
      if (!mounted) return;
      setState(() {
        _requestedEmail = email;
        _hasRequested = true;
        _isLoading = false;
        _startResendCountdown();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _requestError = error is PasswordResetException
            ? error.message
            : const PasswordResetException().message;
      });
    }
  }

  void _editEmail() {
    if (_isLoading) return;
    setState(() {
      _hasRequested = false;
      _hasSubmitted = false;
      _requestError = null;
    });
  }

  void _backToLogin() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.go(AppRoutes.signUpLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToLogin();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton.outlined(
                              tooltip: 'Back to sign in',
                              onPressed: _backToLogin,
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 20,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                _hasRequested
                                    ? Icons.mark_email_unread_outlined
                                    : Icons.lock_reset_rounded,
                                color: AppTheme.primary,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _hasRequested
                                ? 'Check your email'
                                : 'Forgot password?',
                            style: _S.title,
                          ),
                          const SizedBox(height: 8),
                          if (_hasRequested)
                            _buildCheckEmail()
                          else
                            _buildEmailForm(),
                          if (_requestError != null) ...[
                            const SizedBox(height: 16),
                            Semantics(
                              liveRegion: true,
                              child: Text(_requestError!, style: _S.error),
                            ),
                          ],
                          const SizedBox(height: 24),
                          _ActionButton(
                            label: _isLoading
                                ? 'Requesting reset link...'
                                : _hasRequested
                                ? 'Resend reset link'
                                : 'Send reset link',
                            onPressed: _isLoading || _resendSeconds > 0
                                ? null
                                : _submit,
                          ),
                          if (_resendSeconds > 0) ...[
                            const SizedBox(height: 12),
                            Text(
                              'You can request another link in ${_resendSeconds}s.',
                              style: _S.body,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (_hasRequested) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _isLoading ? null : _editEmail,
                              child: Text(
                                'Edit email address',
                                style: _S.label,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _backToLogin,
                            child: Text('Back to sign in', style: _S.label),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your email address to request a secure password reset link.',
            style: _S.body,
          ),
          const SizedBox(height: 28),
          Text('Email address', style: _S.label),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            enableSuggestions: false,
            autofillHints: const [AutofillHints.email],
            scrollPadding: const EdgeInsets.only(bottom: 24),
            style: _S.field,
            decoration: const InputDecoration(
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
              errorMaxLines: 2,
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _submit(),
            // Dismiss on a recognized outside tap, not the start of a scroll.
            onTapOutside: (_) {},
            onChanged: (_) {
              if (_requestError != null) {
                setState(() => _requestError = null);
              }
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text.rich(
            TextSpan(
              style: _S.body,
              children: [
                const TextSpan(text: 'If an account exists for '),
                TextSpan(text: _requestedEmail, style: _S.label),
                const TextSpan(text: ', a password reset link has been sent.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
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
              Text('Reset securely in your browser', style: _S.label),
              const SizedBox(height: 8),
              Text(
                'Open the secure link in your email to set a new password on '
                'the AnbuCRM page in your browser. After resetting, the page '
                'will try to return you to the app in 5 seconds. If it does '
                'not, open AnbuCRM and sign in with your new password.',
                style: _S.body,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Allow a few minutes and check your spam folder. If no email arrives, '
          'check the address or request another link.',
          style: _S.body,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF7C3AED)],
              )
            : null,
        color: enabled ? null : AppTheme.surface200,
        borderRadius: BorderRadius.circular(14),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(50),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppTheme.textSecondary,
          textStyle: _S.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
