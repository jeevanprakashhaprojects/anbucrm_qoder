import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({super.key});

  @override
  State<BuyProductScreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends State<BuyProductScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _entryController;
  late Animation<double> _entryOpacity;

  static const int _totalPages = 5;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.trending_up_rounded,
      iconGradient: [AppTheme.primary, Color(0xFF7C3AED)],
      tag: 'AnbuCRM',
      title: 'Grow Your Business\nFaster Than Ever',
      subtitle:
          'The complete CRM platform built for modern sales teams. Track every lead, call, and deal in one place.',
      highlights: [],
    ),
    _OnboardingPage(
      icon: Icons.phone_in_talk_rounded,
      iconGradient: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
      tag: 'Call Tracking',
      title: 'Never Miss a\nSales Call Again',
      subtitle:
          'Automatically log every incoming, outgoing, and missed call. Get instant context before you pick up.',
      highlights: [
        'Auto-log all call types',
        'Call duration & outcome tracking',
        'SIM-based call attribution',
        'Missed call follow-up alerts',
      ],
    ),
    _OnboardingPage(
      icon: Icons.people_alt_rounded,
      iconGradient: [Color(0xFF059669), Color(0xFF10B981)],
      tag: 'Team Management',
      title: 'Manage Your Team\nWith Confidence',
      subtitle:
          'Assign leads, track performance, and collaborate seamlessly across your entire sales organisation.',
      highlights: [
        'Role-based access control',
        'Lead assignment & routing',
        'Team performance dashboards',
        'Real-time activity feed',
      ],
    ),
    _OnboardingPage(
      icon: Icons.bar_chart_rounded,
      iconGradient: [Color(0xFFD97706), Color(0xFFF59E0B)],
      tag: 'Analytics',
      title: 'Data-Driven Decisions\nEvery Day',
      subtitle:
          'Powerful analytics that show you exactly where your pipeline stands and what needs attention right now.',
      highlights: [
        'Pipeline conversion rates',
        'Revenue forecasting',
        'Agent performance metrics',
        'Custom report builder',
      ],
    ),
    _OnboardingPage(
      icon: Icons.workspace_premium_rounded,
      iconGradient: [AppTheme.primary, Color(0xFF7C3AED)],
      tag: 'Pricing',
      title: 'Simple, Transparent\nPricing',
      subtitle:
          'One plan. Everything included. No hidden fees, no per-seat surprises.',
      highlights: [],
      isPricingPage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _entryController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: FadeTransition(
        opacity: _entryOpacity,
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
                          border: Border.all(color: AppTheme.surface200),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Progress text
                    Text(
                      '${_currentPage + 1} / $_totalPages',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (_currentPage < _totalPages - 1)
                      GestureDetector(
                        onTap: _skipToLast,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                  ],
                ),
              ),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _totalPages,
                    backgroundColor: AppTheme.surface200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primary,
                    ),
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    return _PageContent(
                      page: _pages[index],
                      isTablet: isTablet,
                      onBuyNow: () => context.go(AppRoutes.createAccountScreen),
                    );
                  },
                ),
              ),
              // Dot indicators — clickable
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (i) {
                    final isActive = i == _currentPage;
                    return GestureDetector(
                      onTap: () => _jumpToPage(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTheme.primary
                              : AppTheme.surface200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Bottom action
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: _currentPage < _totalPages - 1
                    ? _NextButton(onTap: _nextPage)
                    : _BuyNowButton(
                        onTap: () => context.go(AppRoutes.createAccountScreen),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  final bool isTablet;
  final VoidCallback onBuyNow;

  const _PageContent({
    required this.page,
    required this.isTablet,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 48 : 24,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 480 : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: page.iconGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: page.iconGradient[0].withAlpha(60),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(page.icon, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: page.iconGradient[0].withAlpha(20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                page.tag,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: page.iconGradient[0],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              page.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.8,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              page.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
            if (page.highlights.isNotEmpty) ...[
              const SizedBox(height: 24),
              ...page.highlights.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: page.iconGradient[0].withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: page.iconGradient[0],
                          size: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        h,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (page.isPricingPage) ...[
              const SizedBox(height: 24),
              _PricingCard(),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withAlpha(15),
            const Color(0xFF7C3AED).withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹500',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Text(
                  '/month',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Basic Plan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Everything you need to grow',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          ...[
            'Unlimited leads & contacts',
            'Call tracking & logging',
            'Team management (up to 10)',
            'Analytics & reports',
            'Priority support',
          ].map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
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

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, Color(0xFF7C3AED)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withAlpha(60),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyNowButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BuyNowButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, Color(0xFF7C3AED)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Buy Now — ₹500/month',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final List<Color> iconGradient;
  final String tag;
  final String title;
  final String subtitle;
  final List<String> highlights;
  final bool isPricingPage;

  const _OnboardingPage({
    required this.icon,
    required this.iconGradient,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.highlights,
    this.isPricingPage = false,
  });
}
