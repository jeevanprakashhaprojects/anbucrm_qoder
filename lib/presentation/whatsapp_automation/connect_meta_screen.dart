import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import 'whatsapp_services.dart';

class ConnectMetaScreen extends StatefulWidget {
  const ConnectMetaScreen({super.key});

  @override
  State<ConnectMetaScreen> createState() => _ConnectMetaScreenState();
}

class _ConnectMetaScreenState extends State<ConnectMetaScreen> {
  bool _isConnecting = false;

  void _triggerMetaOAuth() async {
    setState(() => _isConnecting = true);
    final res = await MetaCloudApiService.exchangeMetaAuthCode('mock_code_123');
    if (!mounted) return;
    setState(() => _isConnecting = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF10B981),
          content: Text('Meta Business Suite Authorized! Now configure phone endpoint.'),
        ),
      );
      context.push(AppRoutes.whatsappNumberSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Webhook Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)),
                    child: const Text('STEP 3 OF 4 - OAUTH AUTHORIZATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF4F46E5))),
                  ),
                  const Text('Meta Cloud v19.0', style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Connect your WhatsApp Business Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              const SizedBox(height: 6),
              const Text(
                'Authorize AnbuCRM with your verified Meta workspace to trigger real-time AI reply flows, sync CRM contacts, and publish broadcast campaigns.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildRequirementItem(Icons.check_circle, 'Meta Business Account', 'An active Meta Business Suite workspace', 'DETECTED', const Color(0xFF10B981)),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildRequirementItem(Icons.check_circle, 'WhatsApp Business Profile', 'Configured brand name, category & bio', 'READY', const Color(0xFF10B981)),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildRequirementItem(Icons.phone_iphone, 'WhatsApp Business Phone Number', 'Must be able to receive SMS or Voice OTP', 'OTP REQUIRED', const Color(0xFFF59E0B)),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildRequirementItem(Icons.admin_panel_settings, 'Meta Admin Permissions', 'Full control to link apps and webhooks', 'REQUIRED', const Color(0xFF64748B)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isConnecting ? null : _triggerMetaOAuth,
                  icon: _isConnecting
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.facebook, color: Colors.white),
                  label: Text(
                    _isConnecting ? 'Authorizing with Meta...' : 'Continue with Meta',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'After clicking, Meta\'s secure embedded signup and OAuth modal will authorize AnbuCRM to manage your WhatsApp templates and webhooks.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.whatsappDashboard),
                  child: const Text('Already connected? Check Connection Status', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String title, String subtitle, String status, Color statusColor) {
    return Row(
      children: [
        Icon(icon, color: statusColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor)),
        )
      ],
    );
  }
}
