// ==============================================================================
// ANBU CRM — WHATSAPP AUTOMATION REDESIGN (FLUTTER / DART)
// File: lib/presentation/whatsapp_automation/automation_builder_screen.dart
//
// Visual Flow Builder redesigned to match AnbuCRM executive design:
// - AppTheme cards, subtle borders, clean step connectors
// - GoogleFonts.plusJakartaSans
// - Trigger, Action, Delay, and Decision step nodes
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class AutomationBuilderScreen extends StatefulWidget {
  const AutomationBuilderScreen({super.key});

  @override
  State<AutomationBuilderScreen> createState() => _AutomationBuilderScreenState();
}

class _AutomationBuilderScreenState extends State<AutomationBuilderScreen> {
  final List<Map<String, dynamic>> _nodes = [
    {
      'type': 'TRIGGER',
      'title': 'CRM Event: New Lead Created',
      'detail': 'Source: Web Form, Facebook Ads, or Google Ads · Score > 30',
      'icon': Icons.bolt_rounded,
      'color': AppTheme.primary,
      'container': AppTheme.primaryContainer,
      'badge': 'ENTRY POINT',
    },
    {
      'type': 'ACTION',
      'title': 'Send WhatsApp: lead_welcome_v2',
      'detail': 'Template: Academy Welcome + Brochure PDF + Calendar Link',
      'icon': Icons.chat_bubble_rounded,
      'color': AppTheme.secondary,
      'container': AppTheme.secondaryContainer,
      'badge': 'IMMEDIATE',
    },
    {
      'type': 'DELAY',
      'title': 'Wait Delay: 24 Hours',
      'detail': 'Check whether customer replied to initial message',
      'icon': Icons.access_time_filled_rounded,
      'color': AppTheme.warning,
      'container': AppTheme.warningContainer,
      'badge': 'TIMER',
    },
    {
      'type': 'CONDITION',
      'title': 'Condition: Has Lead Replied?',
      'detail': 'Branch YES: Route to Senior Advisor | Branch NO: Send Follow-up Reminder',
      'icon': Icons.alt_route_rounded,
      'color': const Color(0xFF8B5CF6),
      'container': const Color(0xFFEDE9FE),
      'badge': 'DECISION',
    },
    {
      'type': 'ACTION',
      'title': 'Send Follow-up Drip: lead_followup_reminder',
      'detail': 'Dynamic fields: {{lead.name}}, {{lead.dealValue}}',
      'icon': Icons.mark_chat_unread_rounded,
      'color': AppTheme.success,
      'container': AppTheme.successContainer,
      'badge': 'STEP 2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.surface200, height: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workflow Builder',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Lead Welcome & Drip Sequence · Active',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppTheme.primary,
                  content: Text('Simulating flow with mock lead payload...'),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 16),
            label: Text(
              'Test Flow',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppTheme.success,
                    content: Text('Workflow published & live to WhatsApp webhooks!'),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                'Publish',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _nodes.length,
        itemBuilder: (context, idx) {
          final node = _nodes[idx];
          final isLast = idx == _nodes.length - 1;

          return Column(
            children: [
              _buildStepCard(node, idx + 1),
              if (!isLast) _buildConnector(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> node, int stepNumber) {
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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: node['container'] as Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(node['icon'] as IconData, size: 18, color: node['color'] as Color),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Step $stepNumber · ${node['type']}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: node['color'] as Color,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surface100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  node['badge'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            node['title'],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            node['detail'],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector() {
    return Container(
      width: 2,
      height: 24,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface200,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
