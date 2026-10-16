// ==============================================================================
// ANBU CRM — WHATSAPP AUTOMATION REDESIGN (FLUTTER / DART)
// File: lib/presentation/whatsapp_automation/whatsapp_automation_screen.dart
//
// Redesigned to match AnbuCRM Executive Design Language:
// - AppTheme color palette (primary: 0xFF4F46E5, backgroundLight: 0xFFF1F5F9, surface200)
// - GoogleFonts.plusJakartaSans typography
// - SliverAppBar / CRM header with Admin badge and range selector
// - Executive KPI metric cards matching PipelineKPIWidget
// - Consistent Card elevation, borders, status badges, and action affordances
// - Preserves all original WhatsApp Automation features and playbooks
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'suite_drawer.dart';

class WhatsAppAutomationScreen extends StatefulWidget {
  const WhatsAppAutomationScreen({super.key});

  @override
  State<WhatsAppAutomationScreen> createState() => _WhatsAppAutomationScreenState();
}

class _WhatsAppAutomationScreenState extends State<WhatsAppAutomationScreen> {
  String _selectedRange = 'Today';
  final List<String> _ranges = ['Today', 'This Week', 'This Month', 'This Quarter'];

  // State of automation toggle switches
  final Map<String, bool> _activeAutomations = {
    'welcome_lead': true,
    'follow_up_drip': true,
    'policy_renewal': true,
    'session_reminder': true,
    'birthday_greetings': false,
    'keyword_bot': true,
  };

  // In-flight simulation state
  bool _isTestSimulating = false;
  List<Map<String, dynamic>> _simulatedMessages = [
    {
      'sender': 'lead',
      'title': 'Incoming Lead #4092 (Priya Sharma)',
      'time': 'Just now',
      'text': 'Hi, I need a quick quote for Term Life 50L + Health Cover.',
      'source': 'Web Form (Facebook Ads)',
    },
    {
      'sender': 'bot',
      'title': 'AnbuBot Instant Automated Reply',
      'time': 'Delivered (0.4s)',
      'text': 'Hello Priya! Welcome to Anbarasan Insurance Academy. Here is your customized brochure & instant calendar booking: anbu.crm/book/priya',
      'attachment': 'Academy_Brochure_2026.pdf (1.8 MB)',
    },
  ];

  void _triggerTestAutomation() async {
    setState(() => _isTestSimulating = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primary,
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              'Simulating incoming WhatsApp lead webhook...',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() {
      _isTestSimulating = false;
      _simulatedMessages.insert(0, {
        'sender': 'lead',
        'title': 'Incoming Lead #${(4093 + DateTime.now().millisecond % 50)} (Arjun Kapoor)',
        'time': 'Just now',
        'text': 'Can someone help calculate my family health policy premium?',
        'source': 'Google Ads Landing Page',
      });
      _simulatedMessages.insert(1, {
        'sender': 'bot',
        'title': 'AnbuBot Auto-Reply Triggered',
        'time': 'Delivered (0.2s)',
        'text': 'Namaste Arjun! We have received your query. Our senior advisor Jeevan Kumar has been assigned to your case.',
        'attachment': 'Family_Health_Calculator_Guide.pdf',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.success,
        content: Text(
          'Workflow Executed: Instant welcome + PDF sent to WhatsApp!',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConnectionStatusBar(),
                  const SizedBox(height: 16),
                  _buildDateRangeSelector(),
                  const SizedBox(height: 16),
                  _buildExecutiveKpiCards(),
                  const SizedBox(height: 20),
                  _buildQuickActionStrip(),
                  const SizedBox(height: 24),
                  _buildInFlightAutomationCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    title: 'Active Automation Playbooks',
                    subtitle: 'Production WhatsApp workflows integrated with your CRM leads',
                  ),
                  const SizedBox(height: 12),
                  ..._buildAutomationPlaybooksList(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIVER APP BAR — Consistent with DashboardScreen & LeadsListScreen
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 110,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.surfaceLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppTheme.surface200, height: 1),
      ),
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: const Icon(Icons.menu_rounded, size: 20, color: AppTheme.textPrimary),
        ),
        onPressed: () => whatsappSuiteScaffoldKey.currentState?.openDrawer(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'WhatsApp Automation',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Cloud API',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '+91 98765 43210 · Anbarasan Insurance Academy',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Test Webhook Flow',
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.play_arrow_rounded, size: 20, color: AppTheme.primary),
          ),
          onPressed: _triggerTestAutomation,
        ),
        IconButton(
          tooltip: 'Connection Settings',
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: const Icon(Icons.settings_outlined, size: 18, color: AppTheme.textSecondary),
          ),
          onPressed: () {
            context.push(AppRoutes.whatsappChooseConnection);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // CONNECTION STATUS BANNER
  Widget _buildConnectionStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Meta Graph API v21.0 Connected',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· 0.2s Latency',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Webhooks active for lead capture, delivery receipts, and chat replies.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              context.push(AppRoutes.whatsappChooseConnection);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.surface200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Switch',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DATE RANGE SELECTOR — Clean segmented control matching Dashboard
  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        children: _ranges.map((range) {
          final isSelected = _selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  range,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // EXECUTIVE KPI CARDS
  Widget _buildExecutiveKpiCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Messages Delivered',
                value: '1,420',
                delta: '+14% vs last period',
                isPositive: true,
                icon: Icons.mark_chat_read_rounded,
                iconColor: AppTheme.primary,
                iconBg: AppTheme.primaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Leads Captured',
                value: '348',
                delta: '+28% conversion',
                isPositive: true,
                icon: Icons.person_add_alt_1_rounded,
                iconColor: AppTheme.secondary,
                iconBg: AppTheme.secondaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Response Rate',
                value: '72.4%',
                delta: '< 45s avg reply time',
                isPositive: true,
                icon: Icons.bolt_rounded,
                iconColor: AppTheme.success,
                iconBg: AppTheme.successContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Free Tier Used',
                value: '682 / 1,000',
                delta: '318 remaining this month',
                isPositive: false,
                icon: Icons.pie_chart_outline_rounded,
                iconColor: AppTheme.warning,
                iconBg: AppTheme.warningContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String delta,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            delta,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isPositive ? AppTheme.success : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // QUICK ACTIONS
  Widget _buildQuickActionStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'New Flow',
            color: AppTheme.primary,
            onTap: () => context.push(AppRoutes.whatsappBuilder),
          ),
          _buildQuickActionButton(
            icon: Icons.send_rounded,
            label: 'Test Msg',
            color: AppTheme.secondary,
            onTap: _triggerTestAutomation,
          ),
          _buildQuickActionButton(
            icon: Icons.library_books_outlined,
            label: 'Templates',
            color: const Color(0xFF8B5CF6),
            onTap: () => context.push(AppRoutes.whatsappDashboardTab1),
          ),
          _buildQuickActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Logs',
            color: AppTheme.textSecondary,
            onTap: () => context.push(AppRoutes.whatsappDashboardTab2),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
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
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // IN-FLIGHT AUTOMATION PREVIEW
  Widget _buildInFlightAutomationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Webhook Simulation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _triggerTestAutomation,
                icon: _isTestSimulating
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded, size: 14),
                label: Text(
                  'Fire Lead Event',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _simulatedMessages[0]['title'] ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      _simulatedMessages[0]['time'] ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '"${_simulatedMessages[0]['text'] ?? ''}"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryContainer),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.smart_toy_rounded, size: 14, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            _simulatedMessages[1]['title'] ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.done_all_rounded, size: 14, color: AppTheme.secondary),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '"${_simulatedMessages[1]['text'] ?? ''}"',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  if (_simulatedMessages[1]['attachment'] != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.picture_as_pdf_rounded, size: 14, color: AppTheme.error),
                          const SizedBox(width: 6),
                          Text(
                            _simulatedMessages[1]['attachment'],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION HEADER
  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // AUTOMATION PLAYBOOKS LIST
  List<Widget> _buildAutomationPlaybooksList() {
    final playbooks = [
      {
        'key': 'welcome_lead',
        'icon': Icons.flash_on_rounded,
        'title': 'Instant Lead Welcome & Brochure Dispatch',
        'desc': 'Triggers automatically whenever a new lead is created in CRM. Delivers academy brochure PDF and agent calendar link within 15 seconds.',
        'trigger': 'CRM Event: New Lead Created',
        'template': 'template: lead_welcome_v2',
        'runs': '842 sent',
        'color': AppTheme.primary,
        'container': AppTheme.primaryContainer,
      },
      {
        'key': 'follow_up_drip',
        'icon': Icons.repeat_rounded,
        'title': 'Intelligent Lead Follow-up Drip Sequence',
        'desc': 'Sends structured reminders at +24h and +72h if lead interest remains uncontacted, gently qualifying policy budget and interest.',
        'trigger': 'Status = "New" & Unreplied (24h)',
        'template': 'template: lead_followup_reminder',
        'runs': '319 sent',
        'color': AppTheme.secondary,
        'container': AppTheme.secondaryContainer,
      },
      {
        'key': 'policy_renewal',
        'icon': Icons.autorenew_rounded,
        'title': 'Policy Renewal & Premium Payment Alerts',
        'desc': 'Dispatches timely WhatsApp reminders 30 days, 15 days, and 3 days before insurance policy expiry with UPI payment button.',
        'trigger': 'Policy Due Date ≤ 30 Days',
        'template': 'template: policy_renewal_urgent',
        'runs': '195 sent',
        'color': AppTheme.warning,
        'container': AppTheme.warningContainer,
      },
      {
        'key': 'session_reminder',
        'icon': Icons.videocam_rounded,
        'title': 'Video Training & Session Reminders',
        'desc': 'Alerts registered attendees 2 hours and 15 minutes before Zoom/Academy sessions with direct joining URL and agenda.',
        'trigger': 'Session Time - 2h',
        'template': 'template: session_link_invite',
        'runs': '112 sent',
        'color': const Color(0xFF8B5CF6),
        'container': const Color(0xFFEDE9FE),
      },
      {
        'key': 'birthday_greetings',
        'icon': Icons.cake_rounded,
        'title': 'Customer Birthday & Policy Anniversary',
        'desc': 'Personalized birthday greetings sent at 9:00 AM on the customer\'s birthdate with an exclusive loyalty policy discount voucher.',
        'trigger': 'Lead DOB = Today',
        'template': 'template: birthday_greetings_v1',
        'runs': '64 sent',
        'color': const Color(0xFFEC4899),
        'container': const Color(0xFFFCE7F3),
      },
      {
        'key': 'keyword_bot',
        'icon': Icons.chat_bubble_outline_rounded,
        'title': 'Interactive 24/7 Policy Inquiry Chatbot',
        'desc': 'Automates replies to inquiries (e.g. Reply 1 for Health, 2 for Term Life, 3 for Advisor Call). Routes hot leads to agent in CRM.',
        'trigger': 'Inbound WhatsApp Message',
        'template': 'Interactive Flow: bot_main_menu',
        'runs': '1,120 routed',
        'color': AppTheme.success,
        'container': AppTheme.successContainer,
      },
    ];

    return playbooks.map((item) {
      final key = item['key'] as String;
      final isEnabled = _activeAutomations[key] ?? false;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEnabled ? AppTheme.surface200 : AppTheme.surface200.withOpacity(0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item['container'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item['desc'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppTheme.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch.adaptive(
                  value: isEnabled,
                  activeColor: AppTheme.primary,
                  onChanged: (val) {
                    setState(() => _activeAutomations[key] = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1500),
                        content: Text(
                          '${item['title']} is now ${val ? "Active" : "Paused"}',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item['trigger']}  ·  ${item['runs']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(AppRoutes.whatsappBuilder);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Edit Flow',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded, size: 14, color: AppTheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
