import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

// ─── SIM Card Data Model ──────────────────────────────────────────────────────

class _SimCard {
  final int slot;
  final String name;
  final String number;
  final String carrier;
  final String networkType;
  final String iccid;
  final String operator;

  const _SimCard({
    required this.slot,
    required this.name,
    required this.number,
    required this.carrier,
    required this.networkType,
    required this.iccid,
    required this.operator,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class SimSelectionScreen extends StatefulWidget {
  const SimSelectionScreen({super.key});

  @override
  State<SimSelectionScreen> createState() => _SimSelectionScreenState();
}

class _SimSelectionScreenState extends State<SimSelectionScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  int? _selectedIndex;
  bool _isSaving = false;
  bool _saveSuccess = false;

  late AnimationController _entryController;
  late AnimationController _successController;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;
  late Animation<double> _successScale;

  final List<_SimCard> _sims = const [
    _SimCard(
      slot: 1,
      name: 'SIM 1',
      number: '+91 98765 43210',
      carrier: 'Airtel',
      networkType: '4G',
      iccid: '8991101200003204510',
      operator: 'Bharti Airtel Ltd.',
    ),
    _SimCard(
      slot: 2,
      name: 'SIM 2',
      number: '+91 87654 32109',
      carrier: 'Jio',
      networkType: '5G',
      iccid: '8991101200003204511',
      operator: 'Reliance Jio Infocomm',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _entryFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    // Simulate loading SIM data
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _selectSim(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _saveSim() async {
    if (_selectedIndex == null) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isSaving = false;
        _saveSuccess = true;
      });
      _successController.forward();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) context.go(AppRoutes.dashboardScreen);
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _isLoading = false);
  }

  void _showMismatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SimMismatchDialog(
        oldNumber: '+91 ••••• 43210',
        newNumber: _selectedIndex != null ? _sims[_selectedIndex!].number : '',
        onCancel: () {
          Navigator.pop(context);
          context.go(AppRoutes.signUpLoginScreen);
        },
        onContinue: () {
          Navigator.pop(context);
          _saveSim();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 48 : 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 480 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step indicator (2 of 2)
                _PermissionStepIndicator(currentStep: 1),
                const SizedBox(height: 28),
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Your SIM',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose the SIM used for your sales calls',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Refresh button
                    GestureDetector(
                      onTap: _isLoading ? null : _refresh,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.surface200),
                        ),
                        child: AnimatedRotation(
                          turns: _isLoading ? 1 : 0,
                          duration: const Duration(milliseconds: 800),
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 20,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // SIM cards or skeleton
                if (_isLoading)
                  ...[0, 1].map((_) => _SimCardSkeleton())
                else
                  FadeTransition(
                    opacity: _entryFade,
                    child: SlideTransition(
                      position: _entrySlide,
                      child: Column(
                        children: List.generate(_sims.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _SimCardWidget(
                              sim: _sims[i],
                              isSelected: _selectedIndex == i,
                              onTap: () => _selectSim(i),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Security note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.primary.withAlpha(40)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your SIM details are encrypted and stored securely. Only your assigned number is used for call matching.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.primary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Save / Success button
                if (_saveSuccess)
                  Center(
                    child: ScaleTransition(
                      scale: _successScale,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.success, Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.success.withAlpha(70),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'SIM Saved! Redirecting...',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _selectedIndex != null && !_isSaving
                        ? _saveSim
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: _selectedIndex != null
                            ? const LinearGradient(
                                colors: [AppTheme.primary, Color(0xFF7C3AED)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: _selectedIndex == null
                            ? AppTheme.surface200
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _selectedIndex != null
                            ? [
                                BoxShadow(
                                  color: AppTheme.primary.withAlpha(60),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sim_card_rounded,
                                    color: _selectedIndex != null
                                        ? Colors.white
                                        : AppTheme.textMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedIndex != null
                                        ? 'Save & Continue'
                                        : 'Select a SIM to continue',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: _selectedIndex != null
                                          ? Colors.white
                                          : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SIM Card Widget ──────────────────────────────────────────────────────────

class _SimCardWidget extends StatefulWidget {
  final _SimCard sim;
  final bool isSelected;
  final VoidCallback onTap;

  const _SimCardWidget({
    required this.sim,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SimCardWidget> createState() => _SimCardWidgetState();
}

class _SimCardWidgetState extends State<_SimCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _selectController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _selectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _selectController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _selectController.forward().then((_) => _selectController.reverse());
    widget.onTap();
  }

  Color get _networkColor {
    switch (widget.sim.networkType) {
      case '5G':
        return AppTheme.primary;
      case '4G':
        return AppTheme.success;
      case '3G':
        return const Color(0xFFD97706);
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primary.withAlpha(8)
                : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected ? AppTheme.primary : AppTheme.surface200,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // SIM chip visual
                  _SimChipVisual(
                    slot: widget.sim.slot,
                    isSelected: widget.isSelected,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.sim.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: widget.isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Network type badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _networkColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.sim.networkType,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: _networkColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.sim.carrier,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.sim.number,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isSelected
                          ? AppTheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.isSelected
                            ? AppTheme.primary
                            : AppTheme.surface200,
                        width: 2,
                      ),
                    ),
                    child: widget.isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                  ),
                ],
              ),
              // Extra details (ICCID, operator)
              if (widget.isSelected) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SimDetailItem(
                        label: 'ICCID',
                        value: widget.sim.iccid,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SimDetailItem(
                        label: 'Operator',
                        value: widget.sim.operator,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SimDetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _SimDetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ─── SIM Chip Visual ──────────────────────────────────────────────────────────

class _SimChipVisual extends StatelessWidget {
  final int slot;
  final bool isSelected;

  const _SimChipVisual({required this.slot, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 68,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [AppTheme.primary, const Color(0xFF7C3AED)]
              : [const Color(0xFF64748B), const Color(0xFF475569)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: (isSelected ? AppTheme.primary : const Color(0xFF64748B))
                .withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Chip contact pads
          Positioned(
            top: 10,
            left: 6,
            child: Container(
              width: 28,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_ChipPad(), _ChipPad()],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_ChipPad(), _ChipPad()],
                  ),
                ],
              ),
            ),
          ),
          // SIM slot number
          Positioned(
            bottom: 6,
            right: 6,
            child: Text(
              'SIM $slot',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(60),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

// ─── Loading Skeleton ─────────────────────────────────────────────────────────

class _SimCardSkeleton extends StatefulWidget {
  @override
  State<_SimCardSkeleton> createState() => _SimCardSkeletonState();
}

class _SimCardSkeletonState extends State<_SimCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmerAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, __) => Opacity(
        opacity: _shimmerAnim.value,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 68,
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.surface200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.surface200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.surface200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SIM Mismatch Dialog ──────────────────────────────────────────────────────

class _SimMismatchDialog extends StatelessWidget {
  final String oldNumber;
  final String newNumber;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const _SimMismatchDialog({
    required this.oldNumber,
    required this.newNumber,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Security warning icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                color: AppTheme.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SIM Mismatch Detected',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'The selected SIM does not match the registered number for this account.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Number comparison
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Registered',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        oldNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'New SIM',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        newNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Continuing will replace the registered SIM. This action is logged for security.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.error,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onContinue,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Replace SIM',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reuse step indicator from calls_permission_screen ───────────────────────

class _PermissionStepIndicator extends StatelessWidget {
  final int currentStep;
  const _PermissionStepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PermStepCircle(
          label: 'Call Logs',
          icon: Icons.phone_outlined,
          isActive: currentStep == 0,
          isDone: currentStep > 0,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(bottom: 22),
            color: currentStep > 0 ? AppTheme.success : AppTheme.surface200,
          ),
        ),
        _PermStepCircle(
          label: 'SIM Select',
          icon: Icons.sim_card_outlined,
          isActive: currentStep == 1,
          isDone: currentStep > 1,
        ),
      ],
    );
  }
}

class _PermStepCircle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;

  const _PermStepCircle({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
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
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
