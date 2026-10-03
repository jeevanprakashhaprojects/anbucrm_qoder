import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifLeads = true;
  bool _notifFollowups = true;
  bool _notifRenewals = true;
  bool _notifPayments = true;
  bool _notifMessages = true;
  bool _dailyDigest = true;
  bool _autoSync = true;
  String _syncFrequency = 'Every 30 minutes';
  bool _simLock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 20),
          _buildSection('CRM Modules', Icons.apps_rounded, [
            _buildActionTile(
              'Sessions',
              'View all calls, meetings & video sessions',
              Icons.event_note_rounded,
              const Color(0xFF8B5CF6),
              () => context.push(AppRoutes.sessionsScreen),
            ),
            _buildActionTile(
              'Follow Ups',
              'Manage pending follow-up tasks',
              Icons.repeat_rounded,
              const Color(0xFFD97706),
              () => context.push(AppRoutes.followUpsScreen),
            ),
            _buildActionTile(
              'Reminders',
              'Set alerts, deadlines & notifications',
              Icons.alarm_rounded,
              const Color(0xFF0891B2),
              () => context.push(AppRoutes.remindersScreen),
            ),
            _buildActionTile(
              'Employees',
              'Team members, roles & performance',
              Icons.badge_rounded,
              const Color(0xFF059669),
              () => context.push(AppRoutes.employeesScreen),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Appearance', Icons.palette_rounded, [
            _buildToggleTile(
              'Dark Mode',
              'Switch to dark theme',
              Icons.dark_mode_rounded,
              _darkMode,
              (v) => setState(() => _darkMode = v),
            ),
            _buildDropdownTile(
              'Font Size',
              'Medium',
              Icons.text_fields_rounded,
              ['Small', 'Medium', 'Large'],
              (v) {},
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Notifications', Icons.notifications_rounded, [
            _buildToggleTile(
              'Lead Assignments',
              'Notify when a lead is assigned to you',
              Icons.person_add_rounded,
              _notifLeads,
              (v) => setState(() => _notifLeads = v),
            ),
            _buildToggleTile(
              'Follow-up Reminders',
              'Remind before scheduled follow-ups',
              Icons.repeat_rounded,
              _notifFollowups,
              (v) => setState(() => _notifFollowups = v),
            ),
            _buildToggleTile(
              'Renewal Alerts',
              'Alert before policy renewals',
              Icons.autorenew_rounded,
              _notifRenewals,
              (v) => setState(() => _notifRenewals = v),
            ),
            _buildToggleTile(
              'Payment Due Alerts',
              'Remind about overdue payments',
              Icons.payment_rounded,
              _notifPayments,
              (v) => setState(() => _notifPayments = v),
            ),
            _buildToggleTile(
              'New Messages',
              'Notify on new WhatsApp/email messages',
              Icons.message_rounded,
              _notifMessages,
              (v) => setState(() => _notifMessages = v),
            ),
            _buildToggleTile(
              'Daily Digest',
              'One summary notification per day',
              Icons.summarize_rounded,
              _dailyDigest,
              (v) => setState(() => _dailyDigest = v),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Sync & Data', Icons.sync_rounded, [
            _buildToggleTile(
              'Auto Sync',
              'Automatically sync data in background',
              Icons.cloud_sync_rounded,
              _autoSync,
              (v) => setState(() => _autoSync = v),
            ),
            _buildDropdownTile(
              'Sync Frequency',
              _syncFrequency,
              Icons.timer_rounded,
              [
                'Every 15 minutes',
                'Every 30 minutes',
                'Every hour',
                'Manual only',
              ],
              (v) => setState(() => _syncFrequency = v),
            ),
            _buildInfoTile(
              'Last Synced',
              'Today at 6:45 AM',
              Icons.access_time_rounded,
            ),
            _buildActionTile(
              'Sync Now',
              'Force sync all data',
              Icons.refresh_rounded,
              AppTheme.primary,
              () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Syncing data...'))),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Security', Icons.security_rounded, [
            _buildToggleTile(
              'SIM Lock',
              'Require registered SIM to access app',
              Icons.sim_card_rounded,
              _simLock,
              (v) => setState(() => _simLock = v),
            ),
            _buildActionTile(
              'Change Password',
              'Update your account password',
              Icons.lock_rounded,
              AppTheme.textPrimary,
              () => _showChangePasswordDialog(),
            ),
            _buildActionTile(
              'Login History',
              'View recent login sessions',
              Icons.history_rounded,
              AppTheme.textPrimary,
              () => _showLoginHistory(),
            ),
            _buildActionTile(
              'Active Sessions',
              'Manage devices with active sessions',
              Icons.devices_rounded,
              AppTheme.textPrimary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Showing active sessions...')),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Data Management', Icons.storage_rounded, [
            _buildActionTile(
              'Export All Data',
              'Download your data as CSV/JSON',
              Icons.download_rounded,
              AppTheme.primary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing data export...')),
              ),
            ),
            _buildActionTile(
              'Import Backup',
              'Restore data from a backup file',
              Icons.upload_rounded,
              AppTheme.primary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening file picker...')),
              ),
            ),
            _buildActionTile(
              'Clear Cache',
              'Free up storage space',
              Icons.cleaning_services_rounded,
              AppTheme.warning,
              () => _showClearCacheDialog(),
            ),
            _buildActionTile(
              'Clear All Data',
              'Permanently delete all local data',
              Icons.delete_forever_rounded,
              AppTheme.error,
              () => _showClearAllDataDialog(),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Account', Icons.manage_accounts_rounded, [
            _buildActionTile(
              'Edit Profile',
              'Update name, photo, and contact info',
              Icons.edit_rounded,
              AppTheme.textPrimary,
              () => _showEditProfileDialog(),
            ),
            _buildActionTile(
              'Organization Settings',
              'Manage team and plan details',
              Icons.business_rounded,
              AppTheme.textPrimary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening organization settings...'),
                ),
              ),
            ),
            _buildActionTile(
              'Delete Account',
              'Permanently remove your account',
              Icons.person_remove_rounded,
              AppTheme.error,
              () => _showDeleteAccountDialog(),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('About', Icons.info_rounded, [
            _buildInfoTile(
              'App Version',
              '2.4.1 (Build 241)',
              Icons.apps_rounded,
            ),
            _buildInfoTile(
              'Plan',
              'Basic Plan — ₹500/month',
              Icons.card_membership_rounded,
            ),
            _buildActionTile(
              'Terms of Service',
              'Read our terms and conditions',
              Icons.article_rounded,
              AppTheme.textPrimary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Terms of Service...')),
              ),
            ),
            _buildActionTile(
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip_rounded,
              AppTheme.textPrimary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Privacy Policy...')),
              ),
            ),
            _buildActionTile(
              'Contact Support',
              'Get help from our team',
              Icons.support_agent_rounded,
              AppTheme.secondary,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening support chat...')),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildLogoutButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'JK',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
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
                  'jeevan@anbucrm.in',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Admin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ADM-1042',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditProfileDialog(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.surface200),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String currentValue,
    IconData icon,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                _showOptionPicker(title, options, currentValue, onChanged),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentValue,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color == AppTheme.textPrimary
                          ? AppTheme.textPrimary
                          : color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.error.withAlpha(51)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionPicker(
    String title,
    List<String> options,
    String current,
    ValueChanged<String> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...options.map((o) {
                final isSelected = o == current;
                return GestureDetector(
                  onTap: () {
                    onChanged(o);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryContainer
                          : AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.surface200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            o,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Change Password',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLoginHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login History',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              ...[
                {
                  'device': 'Samsung Galaxy S23',
                  'time': 'Today, 6:30 AM',
                  'location': 'Chennai, India',
                },
                {
                  'device': 'Samsung Galaxy S23',
                  'time': 'Yesterday, 9:15 PM',
                  'location': 'Chennai, India',
                },
                {
                  'device': 'OnePlus 11',
                  'time': 'Sep 11, 2026',
                  'location': 'Bangalore, India',
                },
              ].map(
                (entry) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_android_rounded,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['device']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${entry['time']} • ${entry['location']}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
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
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Clear Cache',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will clear temporary files (24.5 MB). Your data will not be affected.',
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
                const SnackBar(content: Text('Cache cleared — 24.5 MB freed')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDataDialog() {
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
          'This will permanently delete all local data including leads, interests, and call logs. This cannot be undone.',
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: AppTheme.error,
          ),
        ),
        content: Text(
          'This will permanently delete your account and all associated data. This action cannot be reversed.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: 'Jeevan Kumar');
    final emailCtrl = TextEditingController(text: 'jeevan@anbucrm.in');
    final phoneCtrl = TextEditingController(text: '+91 98765 43210');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
