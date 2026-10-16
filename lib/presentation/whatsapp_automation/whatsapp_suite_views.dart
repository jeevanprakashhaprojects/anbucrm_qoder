// ==============================================================================
// ANBU CRM — WHATSAPP SUITE TAB VIEWS (FLUTTER / DART)
// File: lib/presentation/whatsapp_automation/whatsapp_suite_views.dart
//
// Templates, Logs & Analytics, and Chatbot Simulator views hosted inside the
// WhatsApp Dashboard Master shell (IndexedStack tabs).
// - AppTheme palette + GoogleFonts.plusJakartaSans
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'suite_drawer.dart';

// Shared header for suite tab views (opens the master shell drawer)
class _SuiteViewHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const _SuiteViewHeader({
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 4, right: 12, bottom: 10),
      child: Row(
        children: [
          IconButton(
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

// ============================== TEMPLATES ==============================
class WhatsAppTemplatesView extends StatelessWidget {
  const WhatsAppTemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SuiteViewHeader(
          title: 'Message Templates',
          subtitle: 'Meta-approved templates synced with CRM',
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '3 Approved',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.success,
                ),
              ),
            ),
          ],
        ),
        Container(color: AppTheme.surface200, height: 1),
        Expanded(
          child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search templates, tags...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.textMuted),
                          filled: true,
                          fillColor: AppTheme.surfaceLight,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppTheme.surface200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppTheme.surface200),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        minimumSize: Size.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 14, color: Colors.white),
                      label: Text(
                        'Create',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildTemplateCard(
                  name: 'lead_welcome_v2',
                  category: 'Utility',
                  status: 'Approved',
                  previewText: 'Hi {{contact_name}}, welcome to AnbuCRM! Here is your requested overview. Reply 1 to chat with an agent.',
                  crmMappings: '{{contact_name}} → Lead.FirstName',
                  stats: '14.2K sent | 99.8% delivery',
                ),
                _buildTemplateCard(
                  name: 'quote_followup_reminder',
                  category: 'Marketing',
                  status: 'Approved',
                  previewText: 'Hello {{deal_contact}}, your proposal for {{deal_title}} is ready for review. Expires on {{expiry_date}}.',
                  crmMappings: '{{deal_contact}} → Deal.ClientName\n{{deal_title}} → Deal.Name',
                  stats: '2.1K sent | 98.4% delivery',
                ),
                _buildTemplateCard(
                  name: 'black_friday_promo',
                  category: 'Marketing',
                  status: 'In Review',
                  previewText: 'Exclusive VIP Access: {{company_name}} unlocks 40% off all enterprise seats until {{offer_deadline}}.',
                  crmMappings: '{{company_name}} → Account.OrgName',
                  stats: 'Submitted 2h ago to Meta review queue',
                  isInReview: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard({
    required String name,
    required String category,
    required String status,
    required String previewText,
    required String crmMappings,
    required String stats,
    bool isInReview = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isInReview ? AppTheme.warningContainer : AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isInReview ? AppTheme.warning : AppTheme.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  previewText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '10:42 AM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, size: 12, color: AppTheme.secondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'DYNAMIC CRM MAPPINGS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            crmMappings,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stats,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================== LOGS & ANALYTICS ==============================
class WhatsAppLogsAnalyticsView extends StatelessWidget {
  const WhatsAppLogsAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SuiteViewHeader(
          title: 'Logs & Analytics',
          subtitle: 'Live webhook ingestion and delivery tracking',
        ),
        Container(color: AppTheme.surface200, height: 1),
        Expanded(
          child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'REAL-TIME INGESTION - Live Polling (3s)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiTile(
                        label: 'Total Sent (30d)',
                        value: '48,290',
                        badge: '+12.4%',
                        badgeColor: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildKpiTile(
                        label: 'Delivery Rate',
                        value: '99.2%',
                        badge: 'Tier-1 Route',
                        badgeColor: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Webhook Activity Logs',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLogTile(
                  name: 'Sarah Jenkins',
                  phone: '+1 555-0192',
                  status: 'READ - 10:42 AM',
                  statusColor: AppTheme.secondary,
                  template: 'quote_followup_reminder',
                  dealContext: 'Cloud Migration (\$42,000)',
                ),
                _buildLogTile(
                  name: 'Marcus Vance',
                  phone: '+1 555-0841',
                  status: 'REPLIED - 10:38 AM',
                  statusColor: AppTheme.success,
                  template: 'lead_welcome_v2',
                  dealContext: 'Inbound Response: "Yes, I would like to schedule a demo"',
                ),
                _buildLogTile(
                  name: 'David Miller',
                  phone: '+1 555-0329',
                  status: 'FAILED - 10:15 AM',
                  statusColor: AppTheme.error,
                  template: 'Meta Code 131026: Undeliverable phone number',
                  dealContext: 'Option: Retry with SMS or Edit Contact',
                  isFailed: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiTile({
    required String label,
    required String value,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogTile({
    required String name,
    required String phone,
    required String status,
    required Color statusColor,
    required String template,
    required String dealContext,
    bool isFailed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFailed ? AppTheme.error.withOpacity(0.4) : AppTheme.surface200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryContainer,
                child: Icon(Icons.person, color: AppTheme.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      phone,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isFailed ? AppTheme.error : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dealContext,
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
    );
  }
}

// ============================== CHATBOT SIMULATOR ==============================
class WhatsAppChatbotSimulatorView extends StatefulWidget {
  const WhatsAppChatbotSimulatorView({super.key});

  @override
  State<WhatsAppChatbotSimulatorView> createState() => _WhatsAppChatbotSimulatorViewState();
}

class _WhatsAppChatbotSimulatorViewState extends State<WhatsAppChatbotSimulatorView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'fromBot': true,
      'text': 'Welcome to Anbarasan Insurance Academy! How can I help you today?\n\nReply 1 for Health Insurance\nReply 2 for Term Life\nReply 3 for Advisor Call',
      'time': '10:40 AM',
    },
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = TimeOfDay.now();
    final timeLabel = '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _messages.add({'fromBot': false, 'text': trimmed, 'time': timeLabel});
    });
    _inputController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'fromBot': true,
          'text': _botReply(trimmed),
          'time': timeLabel,
        });
      });
      _scrollToBottom();
    });
  }

  String _botReply(String userText) {
    final t = userText.toLowerCase().trim();
    if (t == '1' || t.contains('health')) {
      return 'Great choice! Our Family Health Cover starts at Rs. 8,500/year for 5L sum insured.\n\nType "QUOTE" for a detailed premium breakdown or "3" to talk to an advisor.';
    }
    if (t == '2' || t.contains('term')) {
      return 'Term Life 50L plans start at Rs. 620/month. Includes critical illness rider and tax benefits under 80C.\n\nType "QUOTE" for a personalized calculation or "3" for an advisor call.';
    }
    if (t == '3' || t.contains('advisor') || t.contains('call')) {
      return 'Connecting you to a senior advisor. Jeevan Kumar will call you within 15 minutes during business hours (9 AM - 7 PM IST).';
    }
    if (t.contains('quote')) {
      return 'To generate your quote, please share: 1) Your age  2) Family members to cover  3) Preferred sum insured.\n\nExample: "32, 4 members, 10L"';
    }
    return 'Sorry, I did not understand that. Please reply:\n1 for Health Insurance\n2 for Term Life\n3 for Advisor Call';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SuiteViewHeader(
          title: 'Test Bot',
          subtitle: 'Interactive 24/7 Policy Inquiry Chatbot',
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'bot_main_menu',
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
        Container(color: AppTheme.surface200, height: 1),
        Expanded(
          child: Container(
            color: AppTheme.backgroundLight,
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isBot = msg['fromBot'] as bool;
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(11),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
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
                          msg['text'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            height: 1.4,
                            color: isBot ? AppTheme.textPrimary : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['time'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  color: isBot ? AppTheme.textMuted : Colors.white70,
                                ),
                              ),
                              if (!isBot) ...[
                                const SizedBox(width: 3),
                                const Icon(Icons.done_all, size: 11, color: Colors.white70),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          color: AppTheme.surfaceLight,
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onSubmitted: _sendMessage,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Type a message... (try 1, 2 or 3)',
                    hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.surfaceVariantLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppTheme.surface200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppTheme.surface200),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _sendMessage(_inputController.text),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 19),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
