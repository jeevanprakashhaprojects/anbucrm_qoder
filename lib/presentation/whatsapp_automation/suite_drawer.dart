// ==============================================================================
// ANBU CRM — WHATSAPP AUTOMATION REDESIGN (FLUTTER / DART)
// File: lib/presentation/whatsapp_automation/suite_drawer.dart
//
// Redesigned to seamlessly match AnbuCRM _AppDrawer in app_scaffold.dart:
// - Same executive gradient header [AppTheme.primary, Color(0xFF7C3AED)]
// - Quick stats and CRM navigation links
// - Highlights WhatsApp Automation active suite
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

// The WhatsApp master owns the suite drawer; tab screens nest their own
// Scaffolds, so Scaffold.of() from inside a tab finds the wrong scaffold.
// They use this key to open the drawer instead.
final GlobalKey<ScaffoldState> whatsappSuiteScaffoldKey =
    GlobalKey<ScaffoldState>();

class SuiteDrawer extends StatelessWidget {
  const SuiteDrawer({super.key});

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
                  _buildSectionLabel('WhatsApp Suite'),
                  _buildDrawerItem(
                    context,
                    Icons.flash_on_rounded,
                    'Active Automations',
                    () => Scaffold.maybeOf(context)?.closeDrawer(),
                    isSelected: true,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.add_circle_outline_rounded,
                    'Workflow Builder',
                    () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                      context.push(AppRoutes.whatsappBuilder);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.library_books_rounded,
                    'WhatsApp Templates',
                    () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                      context.go(AppRoutes.whatsappDashboardTab1);
                    },
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  _buildSectionLabel('Return to CRM'),
                  _buildDrawerItem(
                    context,
                    Icons.dashboard_rounded,
                    'CRM Dashboard',
                    () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                      context.go(AppRoutes.dashboardScreen);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.people_outline_rounded,
                    'Leads Pipeline',
                    () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                      context.go(AppRoutes.leadsListScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Anbarasan Insurance Academy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Active Flows', '12', AppTheme.primary),
          Container(width: 1, height: 24, color: AppTheme.surface200),
          _buildStatItem('Messages Today', '348', AppTheme.secondary),
          Container(width: 1, height: 24, color: AppTheme.surface200),
          _buildStatItem('Delivery', '99.4%', AppTheme.success),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
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

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppTheme.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    bool isSelected = false,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      leading: Icon(
        icon,
        size: 20,
        color: isSelected ? AppTheme.primary : (color ?? AppTheme.textSecondary),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
