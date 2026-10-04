import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class AnbuLoginScreen extends StatefulWidget {
  const AnbuLoginScreen({super.key});

  @override
  State<AnbuLoginScreen> createState() => _AnbuLoginScreenState();
}

class _AnbuLoginScreenState extends State<AnbuLoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formSlide;

  // 0 = Admin, 1 = Employee, 2 = Client
  int _activeTab = 0;
  int _previousTab = 0;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_activeTab == index) return;
    setState(() {
      _previousTab = _activeTab;
      _activeTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withAlpha(30),
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
                    maxWidth: isTablet ? 460 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back to welcome
                      FadeTransition(
                        opacity: _headerOpacity,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.welcomeScreen),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Header
                      FadeTransition(
                        opacity: _headerOpacity,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.primary,
                                      Color(0xFF7C3AED),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Sign in to AnbuCRM',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Select your role and enter your credentials',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Role Tab Switcher
                      FadeTransition(
                        opacity: _formOpacity,
                        child: SlideTransition(
                          position: _formSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _RoleTabBar(
                                activeTab: _activeTab,
                                onTabChanged: _switchTab,
                              ),
                              const SizedBox(height: 24),
                              // Smooth AnimatedSwitcher for tab content
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, animation) {
                                  final isForward = _activeTab >= _previousTab;
                                  final slideIn = Tween<Offset>(
                                    begin: Offset(isForward ? 0.15 : -0.15, 0),
                                    end: Offset.zero,
                                  ).animate(animation);
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: slideIn,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _activeTab == 0
                                    ? _AdminLoginForm(
                                        key: const ValueKey('admin'),
                                        onSuccess: () => context.go(
                                          AppRoutes.callsPermissionScreen,
                                        ),
                                        onForgotPassword: () => context.go(
                                          AppRoutes.forgotPasswordScreen,
                                        ),
                                        onSignUp: () => context.go(
                                          AppRoutes.buyProductScreen,
                                        ),
                                      )
                                    : _activeTab == 1
                                    ? _EmployeeLoginForm(
                                        key: const ValueKey('employee'),
                                        onSuccess: () => context.go(
                                          AppRoutes.callsPermissionScreen,
                                        ),
                                        onForgotPassword: () => context.go(
                                          AppRoutes.forgotPasswordScreen,
                                        ),
                                        onSignUp: () => context.go(
                                          AppRoutes.buyProductScreen,
                                        ),
                                      )
                                    : _ClientLoginForm(
                                        key: const ValueKey('client'),
                                        onSuccess: () => context.go(
                                          AppRoutes.callsPermissionScreen,
                                        ),
                                        onForgotPassword: () => context.go(
                                          AppRoutes.forgotPasswordScreen,
                                        ),
                                      ),
                              ),
                            ],
                          ),
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
}

// ─── Role Tab Bar ─────────────────────────────────────────────────────────────

class _RoleTabBar extends StatelessWidget {
  final int activeTab;
  final Function(int) onTabChanged;

  const _RoleTabBar({required this.activeTab, required this.onTabChanged});

  static const _tabs = [
    (icon: Icons.admin_panel_settings_rounded, label: 'Admin'),
    (icon: Icons.badge_rounded, label: 'Employee'),
    (icon: Icons.person_outline_rounded, label: 'Client'),
  ];

  static const _colors = [
    AppTheme.primary,
    Color(0xFF059669),
    Color(0xFFD97706),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = i == activeTab;
          final color = _colors[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _tabs[i].icon,
                        key: ValueKey('icon_${i}_$isActive'),
                        size: 18,
                        color: isActive ? color : AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _tabs[i].label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive ? color : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Admin Login Form ─────────────────────────────────────────────────────────

class _AdminLoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  const _AdminLoginForm({
    super.key,
    required this.onSuccess,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  @override
  State<_AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<_AdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@anbucrm.in');
  final _passwordController = TextEditingController(text: 'AnbuCRM@2026');
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _wrongCredentials = false;
  bool _hasSubmitted = false;

  static const _demoEmail = 'admin@anbucrm.in';
  static const _demoPassword = 'AnbuCRM@2026';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _hasSubmitted = true;
      _wrongCredentials = false;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email == _demoEmail && pass == _demoPassword) {
      setState(() => _isLoading = false);
      widget.onSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _wrongCredentials = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primary.withAlpha(40)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Login',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        'Full access to all CRM features',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: const InputDecoration(
              hintText: 'admin@anbucrm.in',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
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
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Password too short';
              return null;
            },
          ),
          if (_wrongCredentials) ...[
            const SizedBox(height: 10),
            _ErrorBanner(
              message:
                  'Invalid credentials. Use: admin@anbucrm.in / AnbuCRM@2026',
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPassword,
              child: Text(
                'Forgot password?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _LoginButton(
            isLoading: _isLoading,
            onTap: _submit,
            label: 'Sign In as Admin',
            gradient: const [AppTheme.primary, Color(0xFF7C3AED)],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: widget.onSignUp,
                child: Text(
                  'Sign Up',
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

// ─── Employee Login Form ──────────────────────────────────────────────────────

class _EmployeeLoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  const _EmployeeLoginForm({
    super.key,
    required this.onSuccess,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  @override
  State<_EmployeeLoginForm> createState() => _EmployeeLoginFormState();
}

class _EmployeeLoginFormState extends State<_EmployeeLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'employee@anbucrm.in');
  final _passwordController = TextEditingController(text: 'AnbuCRM@2026');
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _wrongCredentials = false;
  bool _hasSubmitted = false;

  static const _demoEmail = 'employee@anbucrm.in';
  static const _demoPassword = 'AnbuCRM@2026';
  static const _employeeColor = Color(0xFF059669);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _hasSubmitted = true;
      _wrongCredentials = false;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email == _demoEmail && pass == _demoPassword) {
      setState(() => _isLoading = false);
      widget.onSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _wrongCredentials = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _employeeColor.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _employeeColor.withAlpha(40)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF0EA5E9)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.badge_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Login',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _employeeColor,
                        ),
                      ),
                      Text(
                        'Access your assigned leads & calls',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: const InputDecoration(
              hintText: 'employee@anbucrm.in',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
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
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Password too short';
              return null;
            },
          ),
          if (_wrongCredentials) ...[
            const SizedBox(height: 10),
            _ErrorBanner(
              message:
                  'Invalid credentials. Use: employee@anbucrm.in / AnbuCRM@2026',
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPassword,
              child: Text(
                'Forgot password?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _employeeColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _LoginButton(
            isLoading: _isLoading,
            onTap: _submit,
            label: 'Sign In as Employee',
            gradient: const [Color(0xFF059669), Color(0xFF0EA5E9)],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: widget.onSignUp,
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _employeeColor,
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

// ─── Client Login Form ────────────────────────────────────────────────────────

class _ClientLoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onForgotPassword;

  const _ClientLoginForm({
    super.key,
    required this.onSuccess,
    required this.onForgotPassword,
  });

  @override
  State<_ClientLoginForm> createState() => _ClientLoginFormState();
}

class _ClientLoginFormState extends State<_ClientLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _wrongCredentials = false;
  bool _hasSubmitted = false;

  static const _clientColor = Color(0xFFD97706);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _hasSubmitted = true;
      _wrongCredentials = false;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _isLoading = false;
      _wrongCredentials = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _clientColor.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _clientColor.withAlpha(40)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client Login',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _clientColor,
                        ),
                      ),
                      Text(
                        'View your proposals & documents',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _clientColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Client portal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _clientColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
              if (_hasSubmitted) _formKey.currentState?.validate();
            },
            decoration: const InputDecoration(
              hintText: 'your@email.com',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!_hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            onChanged: (_) {
              if (_wrongCredentials) setState(() => _wrongCredentials = false);
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
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Password too short';
              return null;
            },
          ),
          if (_wrongCredentials) ...[
            const SizedBox(height: 10),
            _ErrorBanner(
              message:
                  'Client portal credentials not found. Please contact your agent.',
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPassword,
              child: Text(
                'Forgot password?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _clientColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _LoginButton(
            isLoading: _isLoading,
            onTap: _submit,
            label: 'Sign In as Client',
            gradient: const [Color(0xFFD97706), Color(0xFFF59E0B)],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Client credentials are provided by your CRM agent when your profile is created.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
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

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: AppTheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String label;
  final List<Color> gradient;

  const _LoginButton({
    required this.isLoading,
    required this.onTap,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isLoading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withAlpha(60),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
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
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
