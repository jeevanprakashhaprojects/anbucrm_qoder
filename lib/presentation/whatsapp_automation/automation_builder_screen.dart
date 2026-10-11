import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AutomationBuilderScreen extends StatelessWidget {
  const AutomationBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Automation Builder', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            Text('Draft v2.4 \u2022 Auto-saved', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Testing flow execution with mock payload...')),
              );
            },
            icon: const Icon(Icons.play_arrow, size: 16, color: Color(0xFF4F46E5)),
            label: const Text('Test Flow', style: TextStyle(color: Color(0xFF4F46E5), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Color(0xFF10B981), content: Text('Flow published to live webhook triggers!')),
                );
                context.pop();
              },
              child: const Text('Publish', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _buildStepCard(
                icon: Icons.person_add,
                type: 'TRIGGER EVENT',
                title: 'CRM Event: New Lead Created',
                description: 'Filter: Source is Web Form OR Facebook Ads \u2022 Lead Score > 40',
                meta: '142 matched today',
              ),
              _buildStepConnector(),
              _buildStepCard(
                icon: Icons.chat,
                type: 'AUTOMATED MESSAGE',
                title: 'Send WhatsApp: lead_welcome_v2',
                description: 'Template Variables: {{lead.first_name}}\nAttachment: Company_Profile.pdf (2.4 MB)',
                meta: 'Fallback: Listen unread timeout (3h)',
                isAccent: true,
              ),
              _buildStepConnector(),
              _buildStepCard(
                icon: Icons.alt_route,
                type: 'DECISION BRANCH',
                title: 'Did lead reply within 3 hours?',
                description: 'Evaluates inbound WhatsApp response channel status and message receipt webhook.',
                meta: 'YES (64%)  |  NO (36%)',
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  side: const BorderSide(color: Color(0xFF4F46E5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select node to insert: Action, Delay, or Condition')),
                  );
                },
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4F46E5)),
                label: const Text('Insert Subsequent Step', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepConnector() {
    return Column(
      children: [
        Container(width: 2, height: 16, color: const Color(0xFFCBD5E1)),
        const Icon(Icons.arrow_downward, size: 14, color: Color(0xFF94A3B8)),
        Container(width: 2, height: 16, color: const Color(0xFFCBD5E1)),
      ],
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String type,
    required String title,
    required String description,
    required String meta,
    bool isAccent = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isAccent ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0), width: isAccent ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAccent ? const Color(0xFF4F46E5) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: isAccent ? Colors.white : const Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.3)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
            child: Text(meta, style: const TextStyle(fontSize: 11, color: Color(0xFF4F46E5), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
