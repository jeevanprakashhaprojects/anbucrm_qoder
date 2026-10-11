import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import 'suite_drawer.dart';

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
      const AutomationsDashboardScreen(),
      const MessageTemplatesScreen(),
      const LogsAndAnalyticsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const SuiteDrawer(),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            activeIcon: Icon(Icons.account_tree),
            label: 'Automations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Logs & Analytics',
          ),
        ],
      ),
    );
  }
}

class AutomationsDashboardScreen extends StatelessWidget {
  const AutomationsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.trending_up, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AnbuCRM', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text('API CONNECTED', style: TextStyle(fontSize: 9, color: Color(0xFF10B981), fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          const IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF4F46E5),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            onPressed: null,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: () => context.push(AppRoutes.whatsappBuilder),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Automation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PIPELINE AUTOMATION SUITE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF4F46E5), letterSpacing: 0.6)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Meta Cloud v19.0', style: TextStyle(fontSize: 10, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('WhatsApp Automations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              const Text('Manage CRM triggers, automatic lead follow-ups, and drip journeys.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildKpiCard('12', 'Active Triggers', '+18%', Icons.bolt, const Color(0xFF4F46E5))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildKpiCard('24.8K', 'Delivered', '99.4%', Icons.chat_bubble, const Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildKpiCard('4.2K', 'Replies Received', '16.9%', Icons.reply, const Color(0xFF6366F1))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildKpiCard('82%', 'Meta API Quota', 'Tier 3', Icons.cloud_done, const Color(0xFF0EA5E9))),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All Workflows', true),
                    _buildFilterChip('Lead Nurture', false),
                    _buildFilterChip('Deal Alerts', false),
                    _buildFilterChip('Support Drip', false),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildAutomationRuleCard(
                context,
                title: 'New Lead Instant Welcome & PDF',
                category: 'Lead Nurture',
                id: '#WA-108',
                trigger: 'CRM Lead Created',
                filter: 'Source = Inbound Campaign',
                action: 'Send WhatsApp Template w/ PDF brochure',
                runs: '1,420 runs',
                metric: '38% reply rate',
                isActive: true,
              ),
              _buildAutomationRuleCard(
                context,
                title: 'Deal Stage Changed: Quote Sent',
                category: 'Deal Alerts',
                id: '#WA-204',
                trigger: "Deal → 'Proposal Sent'",
                filter: '24 Hours grace window',
                action: 'Send Quote summary & Stripe paylink',
                runs: '312 runs',
                metric: '\$48.2k generated',
                isActive: true,
              ),
              _buildAutomationRuleCard(
                context,
                title: 'Inactivity Re-engagement (30 Days)',
                category: 'Lead Nurture',
                id: '#WA-042',
                trigger: 'No contact for 30 days',
                filter: 'VIP and Enterprise tags',
                action: 'Send WhatsApp Win-back offer & VIP perks',
                runs: 'Paused',
                metric: 'Sequence Paused',
                isActive: false,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String value, String label, String badge, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF475569),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0)),
        onSelected: (_) {},
      ),
    );
  }

  Widget _buildAutomationRuleCard(
    BuildContext context, {
    required String title,
    required String category,
    required String id,
    required String trigger,
    required String filter,
    required String action,
    required String runs,
    required String metric,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => context.push(AppRoutes.whatsappBuilder),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                      child: Text(category, style: const TextStyle(fontSize: 10, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    Text(id, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
                Switch(value: isActive, activeColor: const Color(0xFF4F46E5), onChanged: (val) {}),
              ],
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  _buildRuleRow(Icons.bolt, 'Trigger', trigger),
                  const SizedBox(height: 4),
                  _buildRuleRow(Icons.filter_alt_outlined, 'Filter', filter),
                  const SizedBox(height: 4),
                  _buildRuleRow(Icons.send_outlined, 'Action', action),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(runs, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  ],
                ),
                Text(metric, style: const TextStyle(fontSize: 11, color: Color(0xFF4F46E5), fontWeight: FontWeight.w700)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRuleRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF1E293B)))),
      ],
    );
  }
}

class MessageTemplatesScreen extends StatelessWidget {
  const MessageTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Message Templates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Meta-approved templates synced with CRM.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: const Text('Create', style: TextStyle(fontSize: 11, color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search templates, tags...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
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
            ],
          ),
        ),
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isInReview ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: isInReview ? const Color(0xFF92400E) : const Color(0xFF166534)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(previewText, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('10:42 AM', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                      SizedBox(width: 4),
                      Icon(Icons.done_all, size: 12, color: Color(0xFF0EA5E9)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('DYNAMIC CRM MAPPINGS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(crmMappings, style: const TextStyle(fontSize: 11, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(stats, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

class LogsAndAnalyticsScreen extends StatelessWidget {
  const LogsAndAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Logs & Analytics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                  SizedBox(width: 6),
                  Text('REAL-TIME INGESTION - Live Polling (3s)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Sent (30d)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('48,290', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          Text('+12.4%', style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivery Rate', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('99.2%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          Text('Tier-1 Route', style: TextStyle(fontSize: 10, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Webhook Activity Logs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 10),
              _buildLogTile(
                name: 'Sarah Jenkins',
                phone: '+1 555-0192',
                status: 'READ - 10:42 AM',
                statusColor: const Color(0xFF0EA5E9),
                template: 'quote_followup_reminder',
                dealContext: 'Cloud Migration (\$42,000)',
                avatar: '',
              ),
              _buildLogTile(
                name: 'Marcus Vance',
                phone: '+1 555-0841',
                status: 'REPLIED - 10:38 AM',
                statusColor: const Color(0xFF10B981),
                template: 'lead_welcome_v2',
                dealContext: 'Inbound Response: "Yes, I would like to schedule a demo"',
                avatar: '',
              ),
              _buildLogTile(
                name: 'David Miller',
                phone: '+1 555-0329',
                status: 'FAILED - 10:15 AM',
                statusColor: const Color(0xFFEF4444),
                template: 'Meta Code 131026: Undeliverable phone number',
                dealContext: 'Option: Retry with SMS or Edit Contact',
                avatar: '',
                isFailed: true,
              ),
            ],
          ),
        ),
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
    required String avatar,
    bool isFailed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isFailed ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFEEF2FF),
                child: const Icon(Icons.person, color: Color(0xFF4F46E5), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(phone, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(template, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isFailed ? const Color(0xFFDC2626) : const Color(0xFF334155))),
                const SizedBox(height: 2),
                Text(dealContext, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
