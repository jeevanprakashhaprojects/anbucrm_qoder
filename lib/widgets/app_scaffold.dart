import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import './app_navigation.dart';

// Global scaffold key so inner screens can open the root drawer
final GlobalKey<ScaffoldState> appScaffoldKey = GlobalKey<ScaffoldState>();

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppScaffold({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appScaffoldKey,
      drawer: _AppDrawer(),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: AppNavigation(navigationShell: navigationShell),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surfaceLight,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildQuickStats(),
                  const SizedBox(height: 8),
                  _buildSectionLabel('Main'),
                  _buildDrawerItem(
                    context,
                    Icons.person_rounded,
                    'Profile',
                    () => context.push(AppRoutes.profileScreen),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.person_add_rounded,
                    'Add Lead',
                    () => context.push(AppRoutes.addLeadScreen),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.repeat_rounded,
                    'Follow-ups',
                    () => _comingSoon(context, 'Follow-ups'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.call_rounded,
                    'Call Logs',
                    () => context.go(AppRoutes.logsScreen),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.star_rounded,
                    'Interests',
                    () => context.push(AppRoutes.interestsScreen),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.people_alt_rounded,
                    'Customers',
                    () {
                      Navigator.pop(context);
                      context.push(AppRoutes.customersScreen);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.calendar_today_rounded,
                    'Sessions',
                    () => _comingSoon(context, 'Sessions'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.group_rounded,
                    'Employees',
                    () => _comingSoon(context, 'Employees'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.analytics_rounded,
                    'Analytics',
                    () {
                      Navigator.pop(context);
                      context.push(AppRoutes.analyticsScreen);
                    },
                    color: const Color(0xFFF59E0B),
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _buildSectionLabel('Automation'),
                  _buildDrawerItem(
                    context,
                    Icons.library_books_rounded,
                    'Templates',
                    () {
                      Navigator.pop(context);
                      context.push(AppRoutes.templatesScreen);
                    },
                    color: AppTheme.primary,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.chat_rounded,
                    'WhatsApp Automation',
                    () => _comingSoon(context, 'WhatsApp Automation'),
                    color: const Color(0xFF25D366),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.videocam_rounded,
                    'Video Session',
                    () {
                      Navigator.pop(context);
                      context.push(AppRoutes.videoSessionScreen);
                    },
                    color: const Color(0xFF0891B2),
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _buildSectionLabel('System'),
                  _buildDrawerItemWithBadge(
                    context,
                    Icons.integration_instructions_rounded,
                    'Integrations',
                    'Coming Soon',
                    AppTheme.warning,
                    () => _comingSoon(context, 'Integrations'),
                  ),
                  _buildDrawerItemWithBadge(
                    context,
                    Icons.help_rounded,
                    'Help',
                    'Coming Soon',
                    AppTheme.warning,
                    () => _comingSoon(context, 'Help'),
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _buildSectionLabel('Account'),
                  _buildDrawerItem(
                    context,
                    Icons.settings_rounded,
                    'Settings',
                    () => context.push(AppRoutes.settingsScreen),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.delete_forever_rounded,
                    'Clear All Data',
                    () => _showClearDataDialog(context),
                    color: AppTheme.error,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.logout_rounded,
                    'Logout',
                    () => _showLogoutDialog(context),
                    color: AppTheme.error,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'JK',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'jeevan@anbucrm.in',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _headerBadge('Admin'),
              const SizedBox(width: 6),
              _headerBadge('ADM-1042'),
              const SizedBox(width: 6),
              _headerBadge('Basic Plan'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'AnbuCRM',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.white.withAlpha(179),
              fontWeight: FontWeight.w500,
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
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickStat('48', 'Leads'),
          _quickStatDivider(),
          _quickStat('24', 'Calls Today'),
          _quickStatDivider(),
          _quickStat('12', 'Follow-ups'),
        ],
      ),
    );
  }

  Widget _quickStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _quickStatDivider() {
    return Container(width: 1, height: 30, color: AppTheme.surface200);
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    final itemColor = color ?? AppTheme.textPrimary;
    return ListTile(
      dense: true,
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
          fontWeight: FontWeight.w500,
          color: itemColor,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildDrawerItemWithBadge(
    BuildContext context,
    IconData icon,
    String label,
    String badge,
    Color badgeColor,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppTheme.textSecondary),
      ),
      title: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(31),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.surface200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'v2.4.1 (Build 241)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening support chat...')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.support_agent_rounded,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Contact Support',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
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

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Coming Soon!'),
        backgroundColor: AppTheme.warning,
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Clear All Data',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: AppTheme.error,
          ),
        ),
        content: Text(
          'This will permanently delete all local data. This cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: AppTheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.signUpLoginScreen);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
