import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  // 4 tabs: Dashboard(0), Leads(1), Logs(2), Settings(3)
  // Center FAB at index 2 visually, but actual branches are 0,1,2,3
  static const _tabLabels = ['Dashboard', 'Leads', 'Logs', 'Settings'];
  static const _tabIcons = [
    Icons.dashboard_outlined,
    Icons.people_outline_rounded,
    Icons.call_outlined,
    Icons.settings_outlined,
  ];
  static const _tabSelectedIcons = [
    Icons.dashboard_rounded,
    Icons.people_rounded,
    Icons.call_rounded,
    Icons.settings_rounded,
  ];

  void _onTabTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _showDialpad(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _DialpadSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = widget.navigationShell.currentIndex;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, color: AppTheme.surface200),
        Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Left 2 tabs
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: screenWidth / 2 - 36,
                    child: Row(
                      children: [0, 1]
                          .map((i) => _buildTab(i, currentIndex, screenWidth))
                          .toList(),
                    ),
                  ),
                  // Right 2 tabs
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: screenWidth / 2 - 36,
                    child: Row(
                      children: [2, 3]
                          .map((i) => _buildTab(i, currentIndex, screenWidth))
                          .toList(),
                    ),
                  ),
                  // Center FAB — at same level as nav items
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _showDialpad(context),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.primary.withAlpha(200),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(100),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int index, int currentIndex, double screenWidth) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isSelected ? _tabSelectedIcons[index] : _tabIcons[index],
                size: 22,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _tabLabels[index],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dialpad Sheet ────────────────────────────────────────────────────────────

class _DialpadSheet extends StatefulWidget {
  const _DialpadSheet();

  @override
  State<_DialpadSheet> createState() => _DialpadSheetState();
}

class _DialpadSheetState extends State<_DialpadSheet>
    with SingleTickerProviderStateMixin {
  String _number = '';
  String _selectedCode = '+91';
  String _selectedFlag = '🇮🇳';
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _countryCodes = [
    {'flag': '🇮🇳', 'code': '+91', 'name': 'India'},
    {'flag': '🇺🇸', 'code': '+1', 'name': 'USA'},
    {'flag': '🇬🇧', 'code': '+44', 'name': 'UK'},
    {'flag': '🇦🇪', 'code': '+971', 'name': 'UAE'},
    {'flag': '🇦🇺', 'code': '+61', 'name': 'Australia'},
    {'flag': '🇨🇦', 'code': '+1', 'name': 'Canada'},
    {'flag': '🇸🇬', 'code': '+65', 'name': 'Singapore'},
    {'flag': '🇩🇪', 'code': '+49', 'name': 'Germany'},
    {'flag': '🇫🇷', 'code': '+33', 'name': 'France'},
    {'flag': '🇯🇵', 'code': '+81', 'name': 'Japan'},
    {'flag': '🇸🇦', 'code': '+966', 'name': 'Saudi Arabia'},
    {'flag': '🇵🇰', 'code': '+92', 'name': 'Pakistan'},
    {'flag': '🇧🇩', 'code': '+880', 'name': 'Bangladesh'},
    {'flag': '🇱🇰', 'code': '+94', 'name': 'Sri Lanka'},
    {'flag': '🇳🇵', 'code': '+977', 'name': 'Nepal'},
  ];

  // Sub-labels for dialpad keys
  static const _subLabels = {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
    '0': '+',
    '1': '',
    '*': '',
    '#': '',
  };

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    if (_number.length < 15) {
      HapticFeedback.lightImpact();
      setState(() => _number += key);
    }
  }

  void _onDelete() {
    if (_number.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _number = _number.substring(0, _number.length - 1));
    }
  }

  void _onLongDelete() {
    HapticFeedback.mediumImpact();
    setState(() => _number = '');
  }

  String get _formattedNumber {
    if (_number.isEmpty) return '';
    // Format Indian numbers: XXXXX XXXXX
    if (_selectedCode == '+91' && _number.length == 10) {
      return '${_number.substring(0, 5)} ${_number.substring(5)}';
    }
    return _number;
  }

  void _showCountryPicker() {
    String query = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) {
          final filtered = _countryCodes.where((c) {
            final q = query.toLowerCase();
            return q.isEmpty ||
                (c['name'] ?? '').toLowerCase().contains(q) ||
                (c['code'] ?? '').contains(q);
          }).toList();
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (_, ctrl) => Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surface200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search country...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        filled: true,
                        fillColor: AppTheme.surfaceVariantLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (v) => setSheet(() => query = v),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: ctrl,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isSelected =
                            c['code'] == _selectedCode &&
                            c['flag'] == _selectedFlag;
                        return ListTile(
                          leading: Text(
                            c['flag']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            c['name']!,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14),
                          ),
                          trailing: Text(
                            c['code']!,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: AppTheme.primaryContainer,
                          onTap: () {
                            setState(() {
                              _selectedCode = c['code']!;
                              _selectedFlag = c['flag']!;
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Dialpad',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 22),
                  color: AppTheme.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Number display area
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _number.isNotEmpty
                    ? AppTheme.primary.withAlpha(80)
                    : AppTheme.surface200,
              ),
            ),
            child: Row(
              children: [
                // Country code selector
                GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedFlag,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _selectedCode,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Number text
                Expanded(
                  child: Text(
                    _number.isEmpty ? 'Enter number' : _formattedNumber,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: _number.isEmpty ? 15 : 22,
                      fontWeight: _number.isEmpty
                          ? FontWeight.w400
                          : FontWeight.w600,
                      color: _number.isEmpty
                          ? AppTheme.textMuted
                          : AppTheme.textPrimary,
                      letterSpacing: _number.isEmpty ? 0 : 1.5,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Backspace
                GestureDetector(
                  onTap: _onDelete,
                  onLongPress: _onLongDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _number.isNotEmpty
                          ? AppTheme.error.withAlpha(20)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.backspace_rounded,
                      size: 18,
                      color: _number.isNotEmpty
                          ? AppTheme.error
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Dialpad grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ...[
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                  ['*', '0', '#'],
                ].map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: row
                          .map(
                            (key) => _DialKey(
                              label: key,
                              subLabel: _subLabels[key] ?? '',
                              onTap: () => _onKey(key),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Bottom action row: Add to contacts | Call | Message
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add contact
                _ActionButton(
                  icon: Icons.person_add_rounded,
                  color: AppTheme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Add contact: $_selectedCode $_number',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),

                // Call button (center, larger)
                ScaleTransition(
                  scale: _pulseAnim,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.call_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Calling $_selectedCode $_number...',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppTheme.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.success, const Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.success.withAlpha(100),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                // Message / WhatsApp
                _ActionButton(
                  icon: Icons.message_rounded,
                  color: const Color(0xFF25D366),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Message: $_selectedCode $_number',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                        backgroundColor: const Color(0xFF25D366),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          shape: BoxShape.circle,
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

class _DialKey extends StatefulWidget {
  final String label;
  final String subLabel;
  final VoidCallback onTap;
  const _DialKey({
    required this.label,
    required this.subLabel,
    required this.onTap,
  });

  @override
  State<_DialKey> createState() => _DialKeyState();
}

class _DialKeyState extends State<_DialKey>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 80,
          height: 62,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.surface200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (widget.subLabel.isNotEmpty)
                Text(
                  widget.subLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
