// ==============================================================================
// ANBU CRM — WHATSAPP AUTOMATION REDESIGN (FLUTTER / DART)
// File: lib/presentation/whatsapp_automation/whatsapp_dashboard_master.dart
// 
// Master Tabbed Shell for WhatsApp Automation:
// - Seamlessly integrated into AnbuCRM theme and AppDrawer
// - Tab 1: Automations Overview & Playbooks
// - Tab 2: WhatsApp Approved Message Templates
// - Tab 3: Delivery Logs & Analytics
// - Tab 4: Interactive Live Chatbot Simulator
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'suite_drawer.dart';
import 'whatsapp_automation_screen.dart';

class WhatsAppDashboardMaster extends StatefulWidget {
  final int initialTab;
  const WhatsAppDashboardMaster({super.key, this.initialTab = 0});

  @override
  State<WhatsAppDashboardMaster> createState() => _WhatsAppDashboardMasterState();
}

class _WhatsAppDashboardMasterState extends State<WhatsAppDashboardMaster> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const WhatsAppAutomationScreen(),
      const WhatsAppTemplatesView(),
      const WhatsAppLogsAnalyticsView(),
      const WhatsAppChatbotSimulatorView(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      drawer: const SuiteDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          border: Border(top: BorderSide(color: AppTheme.surface200)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: AppTheme.surfaceLight,
          indicatorColor: AppTheme.primaryContainer,
          elevation: 0,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.flash_on_outlined, size: 22, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.flash_on_rounded, size: 22, color: AppTheme.primary),
              label: 'Automations',
            ),
            NavigationDestination(
              icon: const Icon(Icons.library_books_outlined, size: 22, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.library_books_rounded, size: 22, color: AppTheme.primary),
              label: 'Templates',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined, size: 22, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.bar_chart_rounded, size: 22, color: AppTheme.primary),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 22, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.chat_bubble_rounded, size: 22, color: AppTheme.primary),
              label: 'Test Bot',
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// TAB 2: WhatsApp Approved Message Templates
// ==============================================================================
class WhatsAppTemplatesView extends StatelessWidget {
  const WhatsAppTemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = [
      {
        'name': 'lead_welcome_v2',
        'status': 'Approved',
        'category': 'Marketing',
        'updated': '2 days ago',
        'preview': 'Hello {{1}}! Welcome to Anbarasan Insurance Academy. Here is your personalized brochure and calendar link...',
        'color': AppTheme.success,
        'icon': Icons.verified_rounded,
      },
      {
        'name': 'lead_followup_reminder',
        'status': 'Approved',
        'category': 'Utility',
        'updated': '5 days ago',
        'preview': 'Hi {{1}}, we noticed you haven\'t reviewed your quote yet. Our advisors are ready to help...',
        'color': AppTheme.success,
        'icon': Icons.verified_rounded,
      },
      {
        'name': 'policy_renewal_urgent',
        'status': 'Approved',
        'category': 'Utility',
        'updated': '1 week ago',
        'preview': 'Dear {{1}}, your policy {{2}} is due for renewal in {{3}} days. Pay now to avoid lapse...',
        'color': AppTheme.success,
        'icon': Icons.verified_rounded,
      },
      {
        'name': 'session_link_invite',
        'status': 'Approved',
        'category': 'Utility',
        'updated': '1 week ago',
        'preview': 'Your session "{{1}}" starts in {{2}} hours. Join here: {{3}}',
        'color': AppTheme.success,
        'icon': Icons.verified_rounded,
      },
      {
        'name': 'birthday_greetings_v1',
        'status': 'Approved',
        'category': 'Marketing',
        'updated': '2 weeks ago',
        'preview': 'Happy Birthday {{1}}! 🎂 As a valued member, enjoy an exclusive loyalty discount...',
        'color': AppTheme.success,
        'icon': Icons.verified_rounded,
      },
      {
        'name': 'claim_status_update',
        'status': 'Pending',
        'category': 'Utility',
        'updated': 'Submitted today',
        'preview': 'Your claim #{{1}} has been {{2}}. Our team will contact you within 24 hours...',
        'color': AppTheme.warning,
        'icon': Icons.pending_rounded,
      },
    ];

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.surfaceLight,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: AppTheme.surface200, height: 1),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WhatsApp Templates',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${templates.length} templates · Meta Business verified',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.add_rounded, size: 18, color: AppTheme.primary),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Meta Template Editor...')),
                    );
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) {
                  final t = templates[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surface100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.description_rounded, size: 16, color: AppTheme.textSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      t['name'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(t['icon'] as IconData, size: 13, color: t['color'] as Color),
                                const SizedBox(width: 3),
                                Text(
                                  t['status'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: t['color'] as Color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t['preview'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surface100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                t['category'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              t['updated'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                childCount: templates.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ==============================================================================
// TAB 3: Delivery Logs & Analytics
// ==============================================================================
class WhatsAppLogsAnalyticsView extends StatelessWidget {
  const WhatsAppLogsAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {'type': 'sent', 'icon': Icons.send_rounded, 'color': AppTheme.primary, 'title': 'lead_welcome_v2 → Priya Sharma', 'time': '2 min ago', 'status': 'Delivered', 'statusColor': AppTheme.success},
      {'type': 'read', 'icon': Icons.done_all_rounded, 'color': AppTheme.secondary, 'title': 'lead_followup_reminder → Arjun Kapoor', 'time': '8 min ago', 'status': 'Read', 'statusColor': AppTheme.secondary},
      {'type': 'failed', 'icon': Icons.error_outline_rounded, 'color': AppTheme.error, 'title': 'policy_renewal_urgent → Ravi Kumar', 'time': '15 min ago', 'status': 'Failed (235)', 'statusColor': AppTheme.error},
      {'type': 'sent', 'icon': Icons.send_rounded, 'color': AppTheme.primary, 'title': 'session_link_invite → Meena Devi', 'time': '22 min ago', 'status': 'Delivered', 'statusColor': AppTheme.success},
      {'type': 'reply', 'icon': Icons.reply_rounded, 'color': AppTheme.success, 'title': 'Inbound reply from Karthik R', 'time': '30 min ago', 'status': 'Processed', 'statusColor': AppTheme.success},
      {'type': 'sent', 'icon': Icons.send_rounded, 'color': AppTheme.primary, 'title': 'birthday_greetings_v1 → Lakshmi N', 'time': '1 hour ago', 'status': 'Delivered', 'statusColor': AppTheme.success},
      {'type': 'read', 'icon': Icons.done_all_rounded, 'color': AppTheme.secondary, 'title': 'bot_main_menu → Anonymous User', 'time': '1.5 hours ago', 'status': 'Read', 'statusColor': AppTheme.secondary},
      {'type': 'sent', 'icon': Icons.send_rounded, 'color': AppTheme.primary, 'title': 'lead_welcome_v2 → Sanjay M', 'time': '2 hours ago', 'status': 'Delivered', 'statusColor': AppTheme.success},
    ];

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.surfaceLight,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: AppTheme.surface200, height: 1),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Logs & Analytics',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Real-time webhook delivery tracking',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLogStatCard('Sent', '1,420', AppTheme.primary, AppTheme.primaryContainer),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLogStatCard('Delivered', '1,398', AppTheme.success, AppTheme.successContainer),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLogStatCard('Failed', '22', AppTheme.error, AppTheme.errorContainer),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLogStatCard('Read Rate', '72.4%', AppTheme.secondary, AppTheme.secondaryContainer),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLogStatCard('Reply Rate', '48.1%', const Color(0xFF8B5CF6), const Color(0xFFEDE9FE)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLogStatCard('Avg Latency', '0.2s', AppTheme.warning, AppTheme.warningContainer),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Last 24 hours',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...logs.map((log) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.surface200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: (log['color'] as Color).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(log['icon'] as IconData, size: 16, color: log['color'] as Color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['title'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                log['time'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: (log['statusColor'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            log['status'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: log['statusColor'] as Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogStatCard(String label, String value, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// TAB 4: Interactive Live Chatbot Simulator
// ==============================================================================
class WhatsAppChatbotSimulatorView extends StatefulWidget {
  const WhatsAppChatbotSimulatorView({super.key});

  @override
  State<WhatsAppChatbotSimulatorView> createState() => _WhatsAppChatbotSimulatorViewState();
}

class _WhatsAppChatbotSimulatorViewState extends State<WhatsAppChatbotSimulatorView> {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text': 'Hello! Welcome to Anbarasan Insurance Academy. 🎓\n\nReply with a number:\n1️⃣ Health Insurance\n2️⃣ Term Life\n3️⃣ Talk to Advisor\n4️⃣ Policy Status',
      'time': 'Now',
    },
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': 'Now',
      });
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      String reply;
      switch (text) {
        case '1':
          reply = '🏥 Health Insurance Plans:\n\n• Family Floater — ₹899/mo\n• Senior Citizen — ₹1,299/mo\n• Critical Illness — ₹599/mo\n\nWant a detailed quote? Share your age & family size.';
          break;
        case '2':
          reply = '🛡️ Term Life Plans:\n\n• 50L Cover (30yr) — ₹649/mo\n• 1Cr Cover (30yr) — ₹1,099/mo\n• 2Cr Cover (30yr) — ₹1,899/mo\n\nWant to calculate premium? Share your age.';
          break;
        case '3':
          reply = '📞 Connecting you to a Senior Advisor...\n\nOur team will call you within 15 minutes during business hours (9AM - 7PM IST).';
          break;
        case '4':
          reply = '📋 Policy Status:\n\nPlease share your policy number or registered phone number to check your policy status.';
          break;
        default:
          reply = 'I didn\'t understand that. Please reply with 1, 2, 3, or 4 from the menu above.';
      }
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': reply,
          'time': 'Now',
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              border: Border(bottom: BorderSide(color: AppTheme.surface200)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.smart_toy_rounded, size: 20, color: AppTheme.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AnbuBot Simulator',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Interactive Flow: bot_main_menu · Live Preview',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final reversedIdx = _messages.length - 1 - idx;
                final msg = _messages[reversedIdx];
                final isBot = msg['sender'] == 'bot';

                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? AppTheme.surfaceLight : AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isBot ? 4 : 12),
                        bottomRight: Radius.circular(isBot ? 12 : 4),
                      ),
                      border: isBot ? Border.all(color: AppTheme.surface200) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: isBot ? AppTheme.textPrimary : Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            color: isBot ? AppTheme.textMuted : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              border: Border(top: BorderSide(color: AppTheme.surface200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Reply 1, 2, 3, or 4...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceVariantLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppTheme.surface200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppTheme.surface200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppTheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
