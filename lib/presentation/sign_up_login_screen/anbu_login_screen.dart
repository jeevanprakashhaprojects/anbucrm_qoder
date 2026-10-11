import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import 'package:go_router/go_router.dart';

// Precomputed text styles — resolved once, reused on every rebuild.
// This is the single biggest perf win: GoogleFonts resolution is expensive
// and was being called on every keystroke/animation frame.
class _S {
  static final _base = GoogleFonts.plusJakartaSans();

  static final title = _base.copyWith(
    fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary,
    letterSpacing: -0.5,
  );
  static final subtitle = _base.copyWith(
    fontSize: 13, color: AppTheme.textSecondary, height: 1.5,
  );
  static final fieldLabel = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary,
  );
  static final fieldText = _base.copyWith(fontSize: 14);
  static final badgeTitle = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w700,
  );
  static final badgeSub = _base.copyWith(
    fontSize: 11, color: AppTheme.textSecondary,
  );
  static final tabLabel = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w500);
  static final tabLabelActive = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w700);
  static final forgotLink = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w600,
  );
  static final signUpText = _base.copyWith(
    fontSize: 13, color: AppTheme.textSecondary,
  );
  static final signUpLink = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w700,
  );
  static final errorText = _base.copyWith(
    fontSize: 12, color: AppTheme.error, fontWeight: FontWeight.w500,
  );
  static final btnLabel = _base.copyWith(
    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
  );
  static final infoText = _base.copyWith(
    fontSize: 11, color: AppTheme.textSecondary, height: 1.4,
  );
  static final clientBadge = _base.copyWith(
    fontSize: 10, fontWeight: FontWeight.w600,
  );
  static final backIcon = const Icon(
    Icons.arrow_back_rounded, size: 18, color: AppTheme.textPrimary,
  );
}

class AnbuLoginScreen extends StatefulWidget {
  const AnbuLoginScreen({super.key});

  @override
  State<AnbuLoginScreen> createState() => _AnbuLoginScreenState();
}

class _AnbuLoginScreenState extends State<AnbuLoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _formOpacity;
  late final Animation<Offset> _formSlide;

  int _activeTab = 0;
  int _previousTab = 0;

  // Single set of controllers reused across all role tabs.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _wrongCredentials = false;
  bool _hasSubmitted = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)));
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)));
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_activeTab == index) return;
    setState(() {
      _previousTab = _activeTab;
      _activeTab = index;
      // Clear form state on tab switch.
      _hasSubmitted = false;
      _wrongCredentials = false;
      _errorMessage = '';
      _emailController.clear();
      _passwordController.clear();
    });
  }

  Future<void> _submit() async {
    setState(() { _hasSubmitted = true; _wrongCredentials = false; });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signIn(
        email: _emailController.text, password: _passwordController.text,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go(AppRoutes.callsPermissionScreen);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false; _wrongCredentials = true;
        _errorMessage = AuthService.friendlyError(e);
      });
    }
  }

  static const _tabs = [
    (icon: Icons.admin_panel_settings_rounded, label: 'Admin', sub: 'Full access to all CRM features', color: AppTheme.primary, color2: Color(0xFF7C3AED)),
    (icon: Icons.badge_rounded, label: 'Employee', sub: 'Access your assigned leads & calls', color: Color(0xFF059669), color2: Color(0xFF0EA5E9)),
    (icon: Icons.person_outline_rounded, label: 'Client', sub: 'View your proposals & documents', color: Color(0xFFD97706), color2: Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;
    final tab = _tabs[_activeTab];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80, right: -60,
            child: Container(
              width: 240, height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppTheme.primary.withAlpha(30), AppTheme.primary.withAlpha(0)]),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 460 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeTransition(
                        opacity: _headerOpacity,
                        child: Row(children: [
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.welcomeScreen),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.surface200),
                              ),
                              child: _S.backIcon,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _headerOpacity,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52, height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 26),
                              ),
                              const SizedBox(height: 20),
                              Text('Sign in to AnbuCRM', style: _S.title),
                              const SizedBox(height: 6),
                              Text('Select your role and enter your credentials', style: _S.subtitle),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _formOpacity,
                        child: SlideTransition(
                          position: _formSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _RoleTabBar(activeTab: _activeTab, onTabChanged: _switchTab),
                              const SizedBox(height: 24),
                              _LoginForm(
                                key: ValueKey(_activeTab),
                                tab: tab,
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                obscurePassword: _obscurePassword,
                                isLoading: _isLoading,
                                wrongCredentials: _wrongCredentials,
                                hasSubmitted: _hasSubmitted,
                                errorMessage: _errorMessage,
                                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                                onSubmit: _submit,
                                onForgotPassword: () => context.go(AppRoutes.forgotPasswordScreen),
                                onSignUp: () => context.go(AppRoutes.buyProductScreen),
                                onFieldChanged: () {
                                  if (_wrongCredentials) setState(() => _wrongCredentials = false);
                                },
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

class _RoleTabBar extends StatelessWidget {
  final int activeTab;
  final Function(int) onTabChanged;
  const _RoleTabBar({required this.activeTab, required this.onTabChanged});

  static const _tabs = [
    (icon: Icons.admin_panel_settings_rounded, label: 'Admin'),
    (icon: Icons.badge_rounded, label: 'Employee'),
    (icon: Icons.person_outline_rounded, label: 'Client'),
  ];
  static const _colors = [AppTheme.primary, Color(0xFF059669), Color(0xFFD97706)];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppTheme.surface100, borderRadius: BorderRadius.circular(14)),
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
                  boxShadow: isActive ? [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_tabs[i].icon, size: 18, color: isActive ? color : AppTheme.textMuted),
                    const SizedBox(height: 3),
                    Text(_tabs[i].label, style: isActive ? _S.tabLabelActive.copyWith(color: color) : _S.tabLabel.copyWith(color: AppTheme.textMuted)),
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

class _LoginForm extends StatelessWidget {
  final ({IconData icon, String label, String sub, Color color, Color color2}) tab;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final bool wrongCredentials;
  final bool hasSubmitted;
  final String errorMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onFieldChanged;

  const _LoginForm({
    super.key, required this.tab, required this.formKey,
    required this.emailController, required this.passwordController,
    required this.obscurePassword, required this.isLoading,
    required this.wrongCredentials, required this.hasSubmitted,
    required this.errorMessage, required this.onToggleObscure,
    required this.onSubmit, required this.onForgotPassword,
    required this.onSignUp, required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: tab.color.withAlpha(15), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: tab.color.withAlpha(40)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [tab.color, tab.color2]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tab.icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${tab.label} Login', style: _S.badgeTitle.copyWith(color: tab.color)),
                      Text(tab.sub, style: _S.badgeSub),
                    ],
                  ),
                ),
                if (tab.label == 'Client')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: tab.color.withAlpha(20), borderRadius: BorderRadius.circular(20)),
                    child: Text('Client portal', style: _S.clientBadge.copyWith(color: tab.color)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Email', style: _S.fieldLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: _S.fieldText,
            onChanged: (_) => onFieldChanged(),
            decoration: const InputDecoration(
              hintText: 'admin@company.com',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (!hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Password', style: _S.fieldLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: _S.fieldText,
            onChanged: (_) => onFieldChanged(),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppTheme.textSecondary),
                onPressed: onToggleObscure,
              ),
            ),
            validator: (v) {
              if (!hasSubmitted) return null;
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Password too short';
              return null;
            },
          ),
          if (wrongCredentials) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.errorContainer, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.error_outline_rounded, size: 16, color: AppTheme.error),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMessage, style: _S.errorText)),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: Text('Forgot password?', style: _S.forgotLink.copyWith(color: tab.color)),
            ),
          ),
          const SizedBox(height: 24),
          _LoginButton(isLoading: isLoading, onTap: onSubmit, label: 'Sign In as ${tab.label}', gradient: [tab.color, tab.color2]),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ", style: _S.signUpText),
              GestureDetector(onTap: onSignUp, child: Text('Sign Up', style: _S.signUpLink.copyWith(color: tab.color))),
            ],
          ),
          if (tab.label == 'Client') ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.surface100, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.textMuted),
                const SizedBox(width: 8),
                Expanded(child: Text('Client credentials are provided by your CRM agent when your profile is created.', style: _S.infoText)),
              ]),
            ),
          ],
          const SizedBox(height: 16),
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
  const _LoginButton({required this.isLoading, required this.onTap, required this.label, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isLoading ? onTap : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: gradient[0].withAlpha(60), blurRadius: 14, offset: const Offset(0, 5))],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(label, style: _S.btnLabel),
        ),
      ),
    );
  }
}
