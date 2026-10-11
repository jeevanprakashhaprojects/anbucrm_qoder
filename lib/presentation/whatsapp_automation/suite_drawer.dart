import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';

class SuiteDrawer extends StatelessWidget {
  const SuiteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('WA Automation', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            SizedBox(width: 4),
                            Icon(Icons.verified, color: Color(0xFF4F46E5), size: 14),
                          ],
                        ),
                        Text('+91 98765 43210', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF64748B)),
                    onPressed: () => Scaffold.maybeOf(context)?.closeDrawer(),
                  )
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search flows, templates, logs...',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('WHATSAPP SUITE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                  ),
                  _buildDrawerItem(Icons.space_dashboard_outlined, 'Overview', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.chat_bubble_outline, 'Inbox', false, () => Scaffold.maybeOf(context)?.closeDrawer(), badge: '5 New'),
                  _buildDrawerItem(Icons.people_outline, 'Contacts', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.category_outlined, 'Segments', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.copy_outlined, 'Templates', false, () {
                    Scaffold.maybeOf(context)?.closeDrawer();
                    context.go(AppRoutes.whatsappDashboardTab1);
                  }),
                  _buildDrawerItem(Icons.account_tree, 'Automations', true, () {
                    Scaffold.maybeOf(context)?.closeDrawer();
                    context.go(AppRoutes.whatsappDashboard);
                  }),
                  _buildDrawerItem(Icons.campaign_outlined, 'Campaigns', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.psychology_outlined, 'AI Agents', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.extension_outlined, 'Integrations', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.analytics_outlined, 'Analytics', false, () {
                    Scaffold.maybeOf(context)?.closeDrawer();
                    context.go(AppRoutes.whatsappDashboardTab2);
                  }),
                  _buildDrawerItem(Icons.credit_card_outlined, 'Usage & Billing', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                  _buildDrawerItem(Icons.settings_outlined, 'WhatsApp Settings', false, () => Scaffold.maybeOf(context)?.closeDrawer()),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF4F46E5),
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AnbuCRM Core', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        Text('Move to Core CRM', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => context.go(AppRoutes.dashboardScreen),
                    child: const Text('Move', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool active, VoidCallback onTap, {String? badge}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEEF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: active ? const Color(0xFF4F46E5) : const Color(0xFF475569), size: 18),
        title: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF4F46E5) : const Color(0xFF1E293B),
            fontSize: 13,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF166534))),
              )
            : null,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        onTap: onTap,
      ),
    );
  }
}
