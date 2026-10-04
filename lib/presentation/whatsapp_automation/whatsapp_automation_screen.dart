import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class _WColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryContainer = Color(0xFFF3E8FF);
  static const Color primaryDark = Color(0xFF4C1D95);
  static const Color purpleDeep = Color(0xFF381E72);
  static const Color brandGreen = Color(0xFF00C853);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color surface = Color(0xFFF8F9FD);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color alertSuccess = Color(0xFF10B981);
  static const Color alertWarning = Color(0xFFF59E0B);
  static const Color alertRed = Color(0xFFDC2626);
  static const Color amber = Color(0xFFD97706);
  static const Color goldContainer = Color(0xFFFEF3C7);
  static const Color bubbleOutbound = Color(0xFFF3E8FF);
}

// ============================================================================
// ROOT: WhatsApp Automation Suite (Drawer + Body + Bottom Nav)
// ============================================================================
class WhatsAppAutomationScreen extends StatefulWidget {
  const WhatsAppAutomationScreen({super.key});

  @override
  State<WhatsAppAutomationScreen> createState() =>
      _WhatsAppAutomationScreenState();
}

class _WhatsAppAutomationScreenState extends State<WhatsAppAutomationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = false;
  String _selectedSection = 'Overview';
  int _bottomNavIndex = 0;

  final List<String> _bottomNavSections = [
    'Overview',
    'Automations',
    'Inbox',
    'Campaigns',
  ];

  void _onSelectSection(String section) {
    setState(() {
      _selectedSection = section;
      int idx = _bottomNavSections.indexOf(section);
      if (idx >= 0) _bottomNavIndex = idx;
    });
    Navigator.of(context).maybePop();
  }

  void _onSwitchToCrm() {
    context.go(AppRoutes.dashboardScreen);
  }

  void _onConnected() {
    setState(() {
      _isConnected = true;
      _selectedSection = 'Overview';
      _bottomNavIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _WColors.surface,
      drawer: _WhatsAppSuiteDrawer(
        activeSection: _selectedSection,
        isConnected: _isConnected,
        onClose: () => Navigator.of(context).maybePop(),
        onSwitchToCrm: _onSwitchToCrm,
        onSelectSection: _onSelectSection,
      ),
      appBar: _buildTopBar(),
      body: !_isConnected
          ? _OnboardingFlow(onConnected: _onConnected)
          : _buildSectionBody(),
      bottomNavigationBar: _isConnected ? _buildBottomNav() : null,
    );
  }

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: _WColors.textDark),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: _WColors.brandGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.bolt, color: Colors.white, size: 10),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AlaiFlow',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _WColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Anbarasan Insuranc...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _WColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 16, color: _WColors.textMuted),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _WColors.brandGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isConnected
                          ? 'Live Meta Cloud API v20.0'
                          : 'Not connected',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: _WColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  color: _WColors.textDark, size: 22),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _WColors.brandGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            radius: 17,
            backgroundColor: _WColors.primaryContainer,
            child: Icon(Icons.person, color: _WColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionBody() {
    switch (_selectedSection) {
      case 'Overview':
        return const _OverviewScreen();
      case 'Inbox':
        return const _InboxScreen();
      case 'Contacts':
        return const _ContactsScreen();
      case 'Segments':
        return const _SegmentsScreen();
      case 'Templates':
        return const _TemplatesScreen();
      case 'Automations':
        return const _AutomationsScreen();
      case 'Campaigns':
        return const _CampaignsScreen();
      case 'AI Agents':
        return const _AIAgentsScreen();
      case 'Integrations':
        return const _IntegrationsScreen();
      case 'Analytics':
        return const _AnalyticsScreen();
      case 'Usage & Billing':
        return const _UsageBillingScreen();
      case 'Flows':
        return const _FlowsScreen();
      case 'WhatsApp Settings':
        return const _WhatsAppSettingsScreen();
      default:
        return const _OverviewScreen();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: _WColors.borderLight, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _bottomNavIndex = idx;
            _selectedSection = _bottomNavSections[idx];
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: _WColors.primaryContainer,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: _WColors.primary),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            selectedIcon:
                Icon(Icons.account_tree, color: _WColors.primary),
            label: 'Automations',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon:
                Icon(Icons.chat_bubble, color: _WColors.whatsappGreen),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign, color: _WColors.primary),
            label: 'Campaigns',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WHATSAPP SUITE DRAWER (matches CRM _AppDrawer design)
// ============================================================================
class _WhatsAppSuiteDrawer extends StatelessWidget {
  final String activeSection;
  final bool isConnected;
  final VoidCallback onClose;
  final VoidCallback onSwitchToCrm;
  final ValueChanged<String> onSelectSection;

  const _WhatsAppSuiteDrawer({
    required this.activeSection,
    required this.isConnected,
    required this.onClose,
    required this.onSwitchToCrm,
    required this.onSelectSection,
  });

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.84;
    return Drawer(
      width: drawerWidth.clamp(280.0, 340.0),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  _buildQuickStats(),
                  const SizedBox(height: 8),
                  _sectionLabel('ENGAGEMENT'),
                  _drawerItem(Icons.grid_view_outlined, 'Overview',
                      isSelected: activeSection == 'Overview',
                      badge: isConnected ? 'Live' : null,
                      badgeBg: _WColors.primary,
                      onTap: () => onSelectSection('Overview')),
                  _drawerItem(Icons.chat_bubble_outline, 'Inbox',
                      isSelected: activeSection == 'Inbox',
                      badge: '12 unread',
                      badgeBg: _WColors.alertRed,
                      onTap: () => onSelectSection('Inbox')),
                  _drawerItem(Icons.badge_outlined, 'Contacts',
                      isSelected: activeSection == 'Contacts',
                      trailing: '3.4k',
                      onTap: () => onSelectSection('Contacts')),
                  _drawerItem(Icons.filter_alt_outlined, 'Segments',
                      isSelected: activeSection == 'Segments',
                      trailing: '24 lists',
                      onTap: () => onSelectSection('Segments')),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _sectionLabel('AUTOMATION'),
                  _drawerItem(Icons.description_outlined, 'Templates',
                      isSelected: activeSection == 'Templates',
                      badge: '18 Approved',
                      badgeBg: _WColors.textMuted,
                      onTap: () => onSelectSection('Templates')),
                  _drawerItem(Icons.account_tree_outlined, 'Automations',
                      isSelected: activeSection == 'Automations',
                      dotColor: _WColors.amber,
                      onTap: () => onSelectSection('Automations')),
                  _drawerItem(Icons.campaign_outlined, 'Campaigns',
                      isSelected: activeSection == 'Campaigns',
                      trailing: '1 Running',
                      onTap: () => onSelectSection('Campaigns')),
                  _drawerItem(Icons.smart_toy_outlined, 'AI Agents',
                      isSelected: activeSection == 'AI Agents',
                      badge: 'v3.2',
                      badgeBg: _WColors.primary,
                      onTap: () => onSelectSection('AI Agents')),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _sectionLabel('ADMIN'),
                  _drawerItem(Icons.swap_horiz, 'Integrations',
                      isSelected: activeSection == 'Integrations',
                      onTap: () => onSelectSection('Integrations')),
                  _drawerItem(Icons.bar_chart_outlined, 'Analytics',
                      isSelected: activeSection == 'Analytics',
                      trailing: '98.9%',
                      onTap: () => onSelectSection('Analytics')),
                  _drawerItem(Icons.receipt_long_outlined, 'Usage & Billing',
                      isSelected: activeSection == 'Usage & Billing',
                      onTap: () => onSelectSection('Usage & Billing')),
                  _drawerItem(Icons.account_tree_outlined, 'Flows',
                      isSelected: activeSection == 'Flows',
                      onTap: () => onSelectSection('Flows')),
                  _drawerItem(Icons.settings_outlined, 'WhatsApp Settings',
                      isSelected: activeSection == 'WhatsApp Settings',
                      color: _WColors.whatsappGreen,
                      onTap: () => onSelectSection('WhatsApp Settings')),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_WColors.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'JK',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jeevan Kumar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'WhatsApp Suite',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _headerBadge('Admin'),
              const SizedBox(width: 6),
              _headerBadge('ws_anbu_9410'),
              const SizedBox(width: 6),
              _headerBadge('Meta v20'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: onSwitchToCrm,
              style: ElevatedButton.styleFrom(
                backgroundColor: _WColors.amber,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 16),
              label: Text(
                'Move to CRM',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('148k', 'Sent'),
          _statDivider(),
          _stat('84.2%', 'Read'),
          _statDivider(),
          _stat('4.1k', 'Active'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _WColors.primary)),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10, color: _WColors.textMuted)),
      ],
    );
  }

  Widget _statDivider() =>
      Container(width: 1, height: 28, color: _WColors.borderLight);

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _WColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label, {
    bool isSelected = false,
    String? badge,
    Color? badgeBg,
    String? trailing,
    Color? dotColor,
    Color? color,
    required VoidCallback onTap,
  }) {
    final itemColor = color ?? (isSelected ? _WColors.primaryDark : _WColors.textDark);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? _WColors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: itemColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: itemColor),
        ),
        title: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? _WColors.primaryDark : itemColor,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null)
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
            if (trailing != null)
              Text(trailing,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _WColors.textDark)),
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeBg ?? _WColors.primary).withAlpha(31),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: badgeBg ?? _WColors.primary)),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FD),
        border: Border(top: BorderSide(color: _WColors.borderLight)),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_in_talk,
              color: _WColors.textDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isConnected ? '+91 98401 23456' : 'Not connected',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: _WColors.textDark,
                  ),
                ),
                Text(
                  isConnected
                      ? 'Connected - Meta Cloud API'
                      : 'Tap to connect WhatsApp',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: _WColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (isConnected)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _WColors.borderLight),
              ),
              child: Text(
                'LIVE',
                style: GoogleFonts.plusJakartaSans(
                  color: _WColors.alertSuccess,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// ONBOARDING FLOW (shown when not connected)
// ============================================================================
class _OnboardingFlow extends StatefulWidget {
  final VoidCallback onConnected;
  const _OnboardingFlow({required this.onConnected});

  @override
  State<_OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<_OnboardingFlow> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _CapabilitiesPage(onGetStarted: () => setState(() => _step = 1));
      case 1:
        return _ChooseConnectionPage(
          onBack: () => setState(() => _step = 0),
          onConnectMeta: () => setState(() => _step = 2),
          onConnectExisting: () => _showExistingApiDialog(),
        );
      case 2:
        return _MetaSetupWizard(
          onBack: () => setState(() => _step = 1),
          onConnected: widget.onConnected,
        );
      default:
        return _CapabilitiesPage(onGetStarted: () => setState(() => _step = 1));
    }
  }

  void _showExistingApiDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.hub_outlined, color: _WColors.primary),
            SizedBox(width: 8),
            Text('Connect Existing API',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your existing WhatsApp Business Account credentials:',
              style: TextStyle(fontSize: 12, color: _WColors.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'WABA ID',
                hintText: 'e.g. 104819284019',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number ID',
                hintText: 'e.g. 7849104820',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onConnected();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _WColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save & Verify',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// --- Step 0: Capabilities ---
class _CapabilitiesPage extends StatefulWidget {
  final VoidCallback onGetStarted;
  const _CapabilitiesPage({required this.onGetStarted});

  @override
  State<_CapabilitiesPage> createState() => _CapabilitiesPageState();
}

class _CapabilitiesPageState extends State<_CapabilitiesPage> {
  final Map<int, bool> _expanded = {0: true, 1: false, 2: false, 3: false};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _WColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, size: 14, color: _WColors.primary),
                SizedBox(width: 4),
                Text('META CLOUD API V20.0',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _WColors.primary,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('WhatsApp Automation',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _WColors.textDark,
                  letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text(
            'Automate your WhatsApp conversations. Connect your WhatsApp Business account and automate messages, follow-ups, reminders and customer interactions.',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, color: _WColors.textMuted, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WHAT YOU CAN AUTOMATE',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _WColors.textMuted,
                      letterSpacing: 0.6)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _WColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('4 Core Modules',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _WColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _featureCard(0, '💬', 'Auto Replies', 'Instant Conversational AI',
              '24/7 Live', const Color(0xFFF3E8FF), _WColors.primary,
              'Provide instant, contextual answers and guide prospective clients without manual intervention.',
              const [
                'Instant 24/7 AI & keyword triggers with zero latency',
                'Business hours automated responder & custom away notes',
                'FAQ knowledge base lookup & verified brand greetings',
              ]),
          const SizedBox(height: 12),
          _featureCard(1, '👤', 'Lead Follow-ups', 'Smart Drip Engagement',
              'Smart Cadence', _WColors.goldContainer, _WColors.amber,
              'Automatically nurture newly captured prospects from ad campaigns or web forms until converted.',
              const [
                'Automated drip sequences for inbound Facebook & web leads',
                'Intelligent cadence scheduling (1 hr, 24 hrs, 3 days)',
                'Bi-directional CRM status sync & auto sales rep re-assignment',
              ]),
          const SizedBox(height: 12),
          _featureCard(2, '📅', 'Reminders', 'Alerts & Scheduling',
              'Scheduled', const Color(0xFFE0F2FE), const Color(0xFF0284C7),
              'Eliminate missed consultations and ensure timely premium collections with automated notifications.',
              const [
                'Automated appointment alerts & direct confirmation prompts',
                'Insurance policy renewal notices with attached summaries',
                'Invoice payment links & Google/Outlook calendar integration',
              ]),
          const SizedBox(height: 12),
          _featureCard(3, '⚡', 'Customer Journeys', 'Visual Interactive Flows',
              'Pro Workflow', const Color(0xFFDCFCE7), const Color(0xFF16A34A),
              'Construct tailored, multi-step customer journeys with rich WhatsApp native components and logic.',
              const [
                'Multi-step interactive flow branching with button & list menus',
                'Dynamic conditional logic based on tags & client preferences',
                'AI intent routing with seamless transition to live agent handoff',
              ]),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: _WColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _featureCard(int index, String emoji, String title, String subtitle,
      String badgeText, Color badgeBg, Color badgeColor, String summary,
      List<String> details) {
    final isExpanded = _expanded[index] ?? false;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _WColors.borderLight),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded[index] = !isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _WColors.primaryContainer.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _WColors.textDark)),
                            Text(subtitle,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11, color: _WColors.textMuted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(badgeText,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor)),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _WColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(summary,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: _WColors.textDark,
                          height: 1.4)),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: _WColors.borderLight),
            Container(
              padding: const EdgeInsets.all(16),
              color: _WColors.surface.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CAPABILITIES INCLUDED:',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: _WColors.textMuted,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  ...details.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: _WColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(d,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: _WColors.textDark,
                                      height: 1.35)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- Step 1: Choose Connection Method ---
class _ChooseConnectionPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onConnectMeta;
  final VoidCallback onConnectExisting;

  const _ChooseConnectionPage({
    required this.onBack,
    required this.onConnectMeta,
    required this.onConnectExisting,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(8),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 18, color: _WColors.primary),
                SizedBox(width: 4),
                Text('Back',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _WColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _WColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Step 1 of 3',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _WColors.primary)),
          ),
          const SizedBox(height: 10),
          Text('Connect WhatsApp Business',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: _WColors.textDark,
                  letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text(
            'Choose how you want to connect your WhatsApp Business account.',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, color: _WColors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 20),
          _optionCard(
            isRecommended: true,
            badge: 'Recommended',
            title: 'Connect directly with Meta',
            subtitle:
                'Fastest, zero-middleman setup powered by Meta Cloud infrastructure.',
            icon: Icons.cloud_done,
            bullets: const [
              'Official WhatsApp Business Platform',
              'Your own dedicated business phone number',
              'Optimized for high-volume automations & scaling',
              'No third-party BSP or proxy fees required',
            ],
            buttonLabel: 'Connect with Meta',
            buttonColor: _WColors.primary,
            onTap: onConnectMeta,
          ),
          const SizedBox(height: 18),
          _optionCard(
            isRecommended: false,
            badge: null,
            title: 'Connect existing API',
            subtitle: 'For custom BSPs or prior credentials',
            icon: Icons.hub_outlined,
            bullets: const [
              'Use an already configured WhatsApp Business number',
              'Enter system token, Phone Number ID & WABA ID',
            ],
            buttonLabel: 'Connect Existing API',
            buttonColor: _WColors.surface,
            buttonTextColor: _WColors.textDark,
            onTap: onConnectExisting,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline,
                    color: _WColors.primary, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'End-to-end encrypted direct connection via Meta',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _WColors.textDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _optionCard({
    required bool isRecommended,
    required String? badge,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> bullets,
    required String buttonLabel,
    required Color buttonColor,
    Color buttonTextColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRecommended ? _WColors.primary : _WColors.borderLight,
          width: isRecommended ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _WColors.primaryContainer,
                child: Icon(icon, color: _WColors.primary, size: 20),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _WColors.goldContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _WColors.amber)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: _WColors.textDark)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: _WColors.textMuted, height: 1.35)),
          const SizedBox(height: 14),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 16, color: _WColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(b,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: _WColors.textDark,
                              height: 1.35)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: buttonColor == _WColors.surface
                      ? const BorderSide(color: _WColors.borderLight)
                      : BorderSide.none,
                ),
              ),
              child: Text(buttonLabel,
                  style: TextStyle(
                      color: buttonTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step 2: Meta Setup Wizard ---
class _MetaSetupWizard extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onConnected;

  const _MetaSetupWizard({
    required this.onBack,
    required this.onConnected,
  });

  @override
  State<_MetaSetupWizard> createState() => _MetaSetupWizardState();
}

class _MetaSetupWizardState extends State<_MetaSetupWizard> {
  int _activeStep = 1;
  bool _connecting = false;

  void _launchMetaEmbeddedSignup() {
    setState(() => _connecting = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Launching official Meta Embedded Signup OAuth...'),
        backgroundColor: _WColors.primary,
      ),
    );
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _activeStep = 2);
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _activeStep = 3);
    });
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        setState(() => _connecting = false);
        widget.onConnected();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('WhatsApp Business Account Connected Successfully!'),
            backgroundColor: _WColors.alertSuccess,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onBack,
            borderRadius: BorderRadius.circular(8),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 18, color: _WColors.primary),
                SizedBox(width: 4),
                Text('Back',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _WColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _WColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Step 2 of 3',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _WColors.primary)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _WColors.whatsappGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble,
                      color: _WColors.whatsappGreen, size: 40),
                ),
                const SizedBox(height: 16),
                Text('Connect WhatsApp to AlaiFlow',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: _WColors.textDark),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'Link your Meta WhatsApp Business Account to unlock multi-agent inbox, automated lead funnels, and broadcasting.',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: _WColors.textMuted,
                      height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                _bullet('Official Meta Cloud API v20.0',
                    'Zero risk of number ban. Direct enterprise connection.'),
                _bullet('Zero Secret Exposure Architecture',
                    'Webhook secrets reside securely on AlaiFlow KMS backend.'),
                _bullet('1,000 Free Service Conversations',
                    'Every billing cycle includes complimentary user-initiated windows.'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _connecting ? null : _launchMetaEmbeddedSignup,
                    icon: _connecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.shield_outlined,
                            color: Colors.white, size: 18),
                    label: Text(
                      _connecting
                          ? 'Connecting...'
                          : 'Launch Meta Embedded Signup',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Official Meta Business Platform Partner OAuth',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10, color: _WColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3-MINUTE ONBOARDING',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _WColors.textDark)),
                    Text(
                        _connecting ? 'In Progress...' : 'Interactive',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: _WColors.primary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _stepBox('1', 'Login Meta',
                            'Select Portfolio',
                            isDone: _activeStep >= 2)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _stepBox('2', 'Pick Number',
                            'OTP verification',
                            isDone: _activeStep >= 3)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _stepBox('3', 'Webhook Synced',
                            'Ready in seconds',
                            isDone: false)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined,
                    color: _WColors.primaryDark, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Enterprise Security: Your META_APP_SECRET is guarded inside the AlaiFlow Core Microservice. No access keys reside on client devices.',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: _WColors.primaryDark,
                        height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _bullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle,
              size: 16, color: _WColors.alertSuccess),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _WColors.textDark)),
                const SizedBox(height: 2),
                Text(desc,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: _WColors.textMuted,
                        height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBox(String num, String title, String sub,
      {bool isDone = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFDCFCE7) : _WColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDone
              ? _WColors.alertSuccess.withOpacity(0.3)
              : _WColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor:
                isDone ? _WColors.alertSuccess : _WColors.primary,
            child: Text(num,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Text(sub,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 9, color: _WColors.textMuted),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ============================================================================
// SECTION SCREENS
// ============================================================================

class _OverviewScreen extends StatelessWidget {
  const _OverviewScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WhatsApp Overview',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _WColors.textDark)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _WColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('v20.0 Meta',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _WColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _metricCard('Total Sent', '148,290', '99.4% delivery', Icons.file_upload_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _metricCard('Read Rate', '84.2%', '+3.8% this week', Icons.chat_bubble_outline)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _metricCard('Active Flows', '4,120', '< 380ms', Icons.account_tree_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _metricCard('Cost/Conv', '0.72 avg', 'Optimized', Icons.currency_rupee)),
            ],
          ),
          const SizedBox(height: 20),
          Text('QUICK ACTIONS',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _WColors.textMuted,
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          _quickAction(Icons.chat_bubble, 'Open Inbox', '12 unread messages', _WColors.whatsappGreen),
          const SizedBox(height: 8),
          _quickAction(Icons.account_tree, 'View Automations', '4 active flows', _WColors.primary),
          const SizedBox(height: 8),
          _quickAction(Icons.campaign, 'Run Campaign', '1 draft ready', _WColors.amber),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WABA STATUS',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _WColors.textMuted,
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.verified, color: _WColors.alertSuccess, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+91 98401 23456',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _WColors.textDark)),
                          Text('WABA-882194012 - Tier 2 (100k/day)',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11, color: _WColors.textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Connected',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _WColors.alertSuccess)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.718,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(_WColors.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('71,840 / 100,000 sent today',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: _WColors.textMuted)),
                    Text('71.8%',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _WColors.textDark)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _WColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: _WColors.textMuted)),
              Icon(icon, size: 16, color: _WColors.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _WColors.textDark)),
          const SizedBox(height: 2),
          Text(sub,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10, color: _WColors.textMuted)),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _WColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _WColors.textDark)),
                Text(sub,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: _WColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _WColors.textMuted, size: 20),
        ],
      ),
    );
  }
}

class _InboxScreen extends StatelessWidget {
  const _InboxScreen();

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Priya Sharma', 'msg': 'Thanks for the policy details!', 'time': '2m', 'unread': true},
      {'name': 'Rajesh Kumar', 'msg': 'Can you send the brochure?', 'time': '15m', 'unread': true},
      {'name': 'Meena Devi', 'msg': 'I will pay the premium tomorrow', 'time': '1h', 'unread': false},
      {'name': 'Arun Prakash', 'msg': 'What is the claim process?', 'time': '3h', 'unread': false},
      {'name': 'Lakshmi Narayan', 'msg': 'Renewal reminder received', 'time': '5h', 'unread': false},
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _WColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _WColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 18, color: _WColors.textMuted),
                          const SizedBox(width: 8),
                          Text('Search conversations...',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, color: _WColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _WColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.filter_list, color: _WColors.primary, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _filterChip('All', true),
                  const SizedBox(width: 6),
                  _filterChip('Unread', false),
                  const SizedBox(width: 6),
                  _filterChip('Assigned', false),
                  const SizedBox(width: 6),
                  _filterChip('24h SLA', false),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: contacts.length,
            itemBuilder: (ctx, i) {
              final c = contacts[i];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: (c['unread'] as bool) ? Colors.white : _WColors.surface.withOpacity(0.5),
                  border: Border(bottom: BorderSide(color: _WColors.borderLight, width: 0.5)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _WColors.primaryContainer,
                      child: Text((c['name'] as String)[0],
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700, color: _WColors.primary)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(c['name'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
                              Text(c['time'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11, color: _WColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(c['msg'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: (c['unread'] as bool) ? _WColors.textDark : _WColors.textMuted)),
                        ],
                      ),
                    ),
                    if (c['unread'] as bool)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                            color: _WColors.whatsappGreen, shape: BoxShape.circle),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? _WColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? _WColors.primary : _WColors.borderLight),
      ),
      child: Text(label,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : _WColors.textDark)),
    );
  }
}

class _ContactsScreen extends StatelessWidget {
  const _ContactsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WhatsApp Contacts', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 4),
          Text('3,428 contacts synced from Meta', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _statBox('3.4k', 'Total', _WColors.primary)),
            const SizedBox(width: 8),
            Expanded(child: _statBox('1.2k', 'Active 7d', _WColors.alertSuccess)),
            const SizedBox(width: 8),
            Expanded(child: _statBox('842', 'New 30d', _WColors.amber)),
          ]),
          const SizedBox(height: 20),
          ...List.generate(6, (i) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _WColors.borderLight),
            ),
            child: Row(children: [
              CircleAvatar(radius: 20, backgroundColor: _WColors.primaryContainer, child: Text('${['P','R','M','A','L','S'][i]}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: _WColors.primary))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(['Priya Sharma','Rajesh Kumar','Meena Devi','Arun Prakash','Lakshmi N','Suresh B'][i], style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
                Text('+91 98401 ${['23456','23457','23458','23459','23460','23461'][i]}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                child: Text(['VIP','Regular','VIP','New','Regular','New'][i], style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: _WColors.alertSuccess))),
            ]),
          )),
        ],
      ),
    );
  }
  Widget _statBox(String v, String l, Color c) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
    child: Column(children: [
      Text(v, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: c)),
      Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: _WColors.textMuted)),
    ]),
  );
}

class _SegmentsScreen extends StatelessWidget {
  const _SegmentsScreen();
  @override
  Widget build(BuildContext context) {
    final segs = [
      ('Insurance Leads', 1240, 'Active'),
      ('Policy Renewals', 842, 'Auto-msg'),
      ('Claim Queries', 456, 'Active'),
      ('Premium Defaulters', 198, 'Paused'),
      ('VIP Clients', 84, 'Active'),
      ('New Enquiries', 608, 'Active'),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Segments & Tags', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 4),
          Text('24 segments - Organize contacts for targeted messaging', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
          const SizedBox(height: 16),
          ...segs.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
            child: Row(children: [
              Container(width: 38, height: 38, decoration: BoxDecoration(color: _WColors.primaryContainer, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.filter_alt_outlined, color: _WColors.primary, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.$1, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
                Text('${s.$2} contacts', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(
                color: s.$3 == 'Active' ? const Color(0xFFDCFCE7) : _WColors.goldContainer,
                borderRadius: BorderRadius.circular(8)),
                child: Text(s.$3, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: s.$3 == 'Active' ? _WColors.alertSuccess : _WColors.amber))),
            ]),
          )),
        ],
      ),
    );
  }
}

class _TemplatesScreen extends StatelessWidget {
  const _TemplatesScreen();
  @override
  Widget build(BuildContext context) {
    final templates = [
      ('welcome_message', 'Hello {{1}}, welcome to AnbuCRM!', 'Approved'),
      ('policy_reminder', 'Your policy {{1}} expires on {{2}}', 'Approved'),
      ('claim_update', 'Claim #{{1}} status: {{2}}', 'Approved'),
      ('payment_link', 'Pay your premium: {{1}}', 'Approved'),
      ('appointment_confirm', 'Confirm appointment on {{1}}?', 'Pending'),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('HSM Templates', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _WColors.primary, borderRadius: BorderRadius.circular(8)),
              child: Text('+ New Template', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
          const SizedBox(height: 4),
          Text('18 Approved - 2 Pending Review', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
          const SizedBox(height: 16),
          ...templates.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.description_outlined, size: 18, color: _WColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(t.$1, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: _WColors.textDark))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(
                  color: t.$3 == 'Approved' ? const Color(0xFFDCFCE7) : _WColors.goldContainer,
                  borderRadius: BorderRadius.circular(8)),
                  child: Text(t.$3, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: t.$3 == 'Approved' ? _WColors.alertSuccess : _WColors.amber))),
              ]),
              const SizedBox(height: 8),
              Text(t.$2, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted, height: 1.3)),
            ]),
          )),
        ],
      ),
    );
  }
}

class _AutomationsScreen extends StatelessWidget {
  const _AutomationsScreen();
  @override
  Widget build(BuildContext context) {
    final flows = [
      ('Lead Welcome Sequence', '3 steps', 'Active', _WColors.alertSuccess),
      ('Policy Renewal Reminder', '5 steps', 'Active', _WColors.alertSuccess),
      ('Claim Status Updates', '4 steps', 'Active', _WColors.alertSuccess),
      ('Payment Follow-up', '2 steps', 'Paused', _WColors.amber),
      ('Feedback Collection', '3 steps', 'Draft', _WColors.textMuted),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Automations', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _WColors.primary, borderRadius: BorderRadius.circular(8)),
              child: Text('+ New Flow', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
          const SizedBox(height: 4),
          Text('4 Active - 1 Paused - 1 Draft', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
          const SizedBox(height: 16),
          ...flows.map((f) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
            child: Row(children: [
              Container(width: 38, height: 38, decoration: BoxDecoration(color: f.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.account_tree_outlined, color: f.$4, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(f.$1, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
                Text(f.$2, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: f.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(f.$3, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: f.$4))),
            ]),
          )),
        ],
      ),
    );
  }
}

class _CampaignsScreen extends StatelessWidget {
  const _CampaignsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Campaigns & Broadcasts', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _WColors.primary, borderRadius: BorderRadius.circular(8)),
              child: Text('+ New Campaign', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _WColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ANTI-BAN HEALTH', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: _WColors.textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFDCFCE7), shape: BoxShape.circle),
                  child: Center(child: Text('92', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900, color: _WColors.alertSuccess)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Excellent Health Score', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.alertSuccess)),
                  Text('Low risk of number restriction', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          _campaignCard('Diwali Offer Blast', '1,240 / 5,000 sent', 'Running', _WColors.alertSuccess, 0.248),
          const SizedBox(height: 8),
          _campaignCard('Policy Renewal Notice', '842 / 842 sent', 'Completed', _WColors.primary, 1.0),
          const SizedBox(height: 8),
          _campaignCard('New Product Launch', '0 / 2,000 scheduled', 'Scheduled', _WColors.amber, 0.0),
        ],
      ),
    );
  }
  Widget _campaignCard(String name, String progress, String status, Color color, double value) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
        ]),
        const SizedBox(height: 8),
        Text(progress, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: value, minHeight: 6, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color))),
      ]),
    );
  }
}

class _AIAgentsScreen extends StatelessWidget {
  const _AIAgentsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Agents (RAG)', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 4),
          Text('AI-powered intent routing & knowledge retrieval', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
          const SizedBox(height: 16),
          _agentCard('Intent Classifier', 'v3.2', 'Routes messages to correct department', _WColors.alertSuccess),
          const SizedBox(height: 10),
          _agentCard('FAQ Bot', 'v2.8', 'Answers 84% of queries without human help', _WColors.primary),
          const SizedBox(height: 10),
          _agentCard('Lead Qualifier', 'v1.5', 'Scores and routes inbound leads', _WColors.amber),
          const SizedBox(height: 10),
          _agentCard('Escalation Manager', 'v1.0', 'Detects frustration & hands off to agent', _WColors.alertRed),
        ],
      ),
    );
  }
  Widget _agentCard(String name, String version, String desc, Color color) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.smart_toy_outlined, color: color, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: _WColors.primaryContainer, borderRadius: BorderRadius.circular(6)),
              child: Text(version, style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: _WColors.primary))),
          ]),
          Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
        ])),
      ]),
    );
  }
}

class _IntegrationsScreen extends StatelessWidget {
  const _IntegrationsScreen();
  @override
  Widget build(BuildContext context) {
    final integrations = [
      ('Meta Cloud API', 'Connected', 'v20.0', _WColors.alertSuccess),
      ('Webhook Endpoint', 'Active', '200 OK', _WColors.alertSuccess),
      ('Google Calendar', 'Connected', 'Synced', _WColors.primary),
      ('Razorpay', 'Connected', 'Payment links', _WColors.amber),
      ('Zapier', 'Disconnected', 'Not configured', _WColors.textMuted),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Integrations & Webhooks', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 16),
          ...integrations.map((i) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
            child: Row(children: [
              Container(width: 38, height: 38, decoration: BoxDecoration(color: i.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.swap_horiz, color: i.$4, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(i.$1, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: _WColors.textDark)),
                Text(i.$3, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: i.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(i.$2, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: i.$4))),
            ]),
          )),
        ],
      ),
    );
  }
}

class _AnalyticsScreen extends StatelessWidget {
  const _AnalyticsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics & Delivery', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _analyticsCard('Delivery Rate', '99.4%', '+0.2%', _WColors.alertSuccess)),
            const SizedBox(width: 8),
            Expanded(child: _analyticsCard('Read Rate', '84.2%', '+3.8%', _WColors.primary)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _analyticsCard('Reply Rate', '42.1%', '-1.2%', _WColors.amber)),
            const SizedBox(width: 8),
            Expanded(child: _analyticsCard('Avg Response', '3.2m', '-0.8m', _WColors.alertSuccess)),
          ]),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _WColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('WEEKLY TREND', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: _WColors.textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              ...['Mon','Tue','Wed','Thu','Fri','Sat','Sun'].asMap().entries.map((e) {
                final values = [85.0, 92.0, 78.0, 95.0, 88.0, 62.0, 45.0];
                return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                  SizedBox(width: 30, child: Text(e.value, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted))),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: values[e.key] / 100, minHeight: 8, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(_WColors.primary)))),
                  const SizedBox(width: 8),
                  Text('${values[e.key]}%', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: _WColors.textDark)),
                ]));
              }),
            ]),
          ),
        ],
      ),
    );
  }
  Widget _analyticsCard(String label, String value, String change, Color color) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: _WColors.textDark)),
        Text(change, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

class _UsageBillingScreen extends StatelessWidget {
  const _UsageBillingScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usage & Billing', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _WColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CURRENT PLAN', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: _WColors.textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Row(children: [
                Text('Growth Plan', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.primary)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: _WColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text('Monthly', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: _WColors.primary))),
              ]),
              const SizedBox(height: 4),
              Text('4,999/month + conversation charges', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _usageCard('Conversations', '12,840', '50,000 limit', _WColors.primary, 0.257)),
            const SizedBox(width: 8),
            Expanded(child: _usageCard('Messages Sent', '71,840', '100,000 limit', _WColors.whatsappGreen, 0.718)),
          ]),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Meta Conversation Breakdown', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: _WColors.textDark)),
              const SizedBox(height: 10),
              _convRow('Marketing', '2,400', '0.72', '1,728'),
              _convRow('Utility', '5,200', '0.40', '2,080'),
              _convRow('Service (Free)', '5,240', '0.00', '0'),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total Estimated', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _WColors.textDark)),
                Text('3,808', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _WColors.primary)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
  Widget _usageCard(String label, String value, String limit, Color color, double progress) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color))),
        const SizedBox(height: 4),
        Text(limit, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: _WColors.textMuted)),
      ]),
    );
  }
  Widget _convRow(String type, String count, String rate, String cost) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      Expanded(child: Text(type, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textDark))),
      Text(count, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
      const SizedBox(width: 16),
      Text('$rate/ea', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
      const SizedBox(width: 16),
      Text(cost, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _WColors.textDark)),
    ]));
  }
}

class _FlowsScreen extends StatelessWidget {
  const _FlowsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Flow Builder', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _WColors.primary, borderRadius: BorderRadius.circular(8)),
              child: Text('+ New Flow', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _WColors.borderLight)),
            child: Column(children: [
              Icon(Icons.account_tree, size: 48, color: _WColors.primary.withOpacity(0.4)),
              const SizedBox(height: 12),
              Text('Visual Flow Canvas', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: _WColors.textDark)),
              const SizedBox(height: 6),
              Text('Drag & drop nodes to build automation flows', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                _nodeChip('Trigger', Icons.play_arrow, _WColors.alertSuccess),
                _nodeChip('Delay', Icons.timer, _WColors.amber),
                _nodeChip('Send Message', Icons.send, _WColors.primary),
                _nodeChip('Condition', Icons.call_split, const Color(0xFF0284C7)),
                _nodeChip('AI Agent', Icons.smart_toy, _WColors.primaryDark),
                _nodeChip('Webhook', Icons.webhook, _WColors.whatsappGreen),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
  Widget _nodeChip(String label, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _WhatsAppSettingsScreen extends StatelessWidget {
  const _WhatsAppSettingsScreen();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WhatsApp Settings', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: _WColors.textDark)),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _WColors.alertSuccess, width: 1.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.verified, color: _WColors.alertSuccess, size: 24),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('WhatsApp Connected', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15, color: _WColors.textDark)),
                  Text('Anbarasan Insurance Academy', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: _WColors.primaryContainer, borderRadius: BorderRadius.circular(6)),
                  child: Text('Live v20', style: GoogleFonts.plusJakartaSans(color: _WColors.primary, fontSize: 10, fontWeight: FontWeight.bold))),
              ]),
              const Divider(height: 24),
              _settingRow('Phone', '+91 98401 23456'),
              _settingRow('WABA ID', 'WABA-882194012'),
              _settingRow('Phone Number ID', 'PHONE-7849104820'),
              _settingRow('Daily Quota', '100,000 (Tier 2)'),
              _settingRow('Webhook', 'Active - 200 OK'),
            ]),
          ),
          const SizedBox(height: 16),
          Text('CONFIGURATION', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: _WColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 10),
          _settingsTile(Icons.webhook, 'Webhook URL', 'api.alaiflow.io/v1/webhook'),
          _settingsTile(Icons.key, 'Access Token', '************7f3a'),
          _settingsTile(Icons.verified_user, 'Business Verification', 'Verified'),
          _settingsTile(Icons.phone_locked, '2FA PIN', 'Configured'),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 48, child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(foregroundColor: _WColors.alertRed, side: const BorderSide(color: _WColors.alertRed), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Disconnect WhatsApp', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }
  Widget _settingRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _WColors.textMuted)),
      Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _WColors.textDark)),
    ]));
  }
  Widget _settingsTile(IconData icon, String title, String sub) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _WColors.borderLight)),
      child: Row(children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: _WColors.primaryContainer, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: _WColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: _WColors.textDark)),
          Text(sub, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _WColors.textMuted)),
        ])),
        const Icon(Icons.chevron_right, size: 18, color: _WColors.textMuted),
      ]),
    );
  }
}
