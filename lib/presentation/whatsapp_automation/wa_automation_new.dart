import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../templates_screen/templates_screen.dart';

// ─── Models ─────────────────────────────────────────────────────────────────

class WaAutomationRule {
  final String id;
  String name;
  String trigger;
  String condition;
  String actionTemplateId;
  int delayMinutes;
  bool isActive;
  int timesTriggered;
  int messagesSent;
  int replies;
  DateTime createdAt;

  WaAutomationRule({
    required this.id,
    required this.name,
    required this.trigger,
    required this.condition,
    required this.actionTemplateId,
    required this.delayMinutes,
    required this.isActive,
    this.timesTriggered = 0,
    this.messagesSent = 0,
    this.replies = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class WaBroadcast {
  final String id;
  String name;
  String templateId;
  String targetAudience;
  int recipientCount;
  int sentCount;
  int deliveredCount;
  int readCount;
  int failedCount;
  String status;
  DateTime sentAt;
  DateTime createdAt;

  WaBroadcast({
    required this.id,
    required this.name,
    required this.templateId,
    required this.targetAudience,
    required this.recipientCount,
    this.sentCount = 0,
    this.deliveredCount = 0,
    this.readCount = 0,
    this.failedCount = 0,
    this.status = 'draft',
    DateTime? sentAt,
    DateTime? createdAt,
  })  : sentAt = sentAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();
}

class WaMessage {
  final String id;
  String ruleName;
  String contactName;
  String contactPhone;
  String messagePreview;
  String status;
  DateTime sentAt;
  bool isReplied;
  String? replyText;

  WaMessage({
    required this.id,
    required this.ruleName,
    required this.contactName,
    required this.contactPhone,
    required this.messagePreview,
    required this.status,
    required this.sentAt,
    this.isReplied = false,
    this.replyText,
  });
}

class WaConnection {
  String businessName;
  String phoneNumber;
  String wabaId;
  String qualityRating;
  int dailyLimit;
  int messagesUsed;
  DateTime connectedAt;

  WaConnection({
    required this.businessName,
    required this.phoneNumber,
    required this.wabaId,
    required this.qualityRating,
    required this.dailyLimit,
    required this.messagesUsed,
    required this.connectedAt,
  });

  double get quotaPercent => dailyLimit == 0 ? 0 : messagesUsed / dailyLimit;
}

// ─── Global Data ────────────────────────────────────────────────────────────

WaConnection? globalWaConnection;

final List<WaAutomationRule> globalWaRules = [
  WaAutomationRule(
    id: 'rule_1',
    name: 'Welcome New Lead',
    trigger: 'New lead created',
    condition: 'All new leads',
    actionTemplateId: 'tmpl_welcome',
    delayMinutes: 0,
    isActive: true,
    timesTriggered: 1240,
    messagesSent: 1240,
    replies: 186,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),
  WaAutomationRule(
    id: 'rule_2',
    name: 'Follow-up After 2 Days',
    trigger: 'No response',
    condition: 'Leads inactive for 2 days',
    actionTemplateId: 'tmpl_followup',
    delayMinutes: 2880,
    isActive: true,
    timesTriggered: 486,
    messagesSent: 472,
    replies: 89,
    createdAt: DateTime.now().subtract(const Duration(days: 38)),
  ),
  WaAutomationRule(
    id: 'rule_3',
    name: 'Policy Renewal Reminder',
    trigger: 'Policy renewal due',
    condition: 'Renewal within 30 days',
    actionTemplateId: 'tmpl_renewal',
    delayMinutes: 0,
    isActive: true,
    timesTriggered: 312,
    messagesSent: 312,
    replies: 145,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  WaAutomationRule(
    id: 'rule_4',
    name: 'Meeting Confirmation',
    trigger: 'Meeting scheduled',
    condition: 'All meetings',
    actionTemplateId: 'tmpl_meeting',
    delayMinutes: 30,
    isActive: false,
    timesTriggered: 98,
    messagesSent: 96,
    replies: 54,
    createdAt: DateTime.now().subtract(const Duration(days: 21)),
  ),
  WaAutomationRule(
    id: 'rule_5',
    name: 'Birthday Wish',
    trigger: 'Birthday today',
    condition: 'All contacts',
    actionTemplateId: 'tmpl_birthday',
    delayMinutes: 540,
    isActive: true,
    timesTriggered: 67,
    messagesSent: 67,
    replies: 41,
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
];

final List<WaBroadcast> globalWaBroadcasts = [
  WaBroadcast(
    id: 'bcast_1',
    name: 'Diwali Greeting',
    templateId: 'tmpl_diwali',
    targetAudience: 'All contacts',
    recipientCount: 2150,
    sentCount: 2150,
    deliveredCount: 2118,
    readCount: 1834,
    failedCount: 32,
    status: 'completed',
    sentAt: DateTime.now().subtract(const Duration(days: 12)),
  ),
  WaBroadcast(
    id: 'bcast_2',
    name: 'New Product Launch',
    templateId: 'tmpl_launch',
    targetAudience: 'Active leads',
    recipientCount: 860,
    sentCount: 860,
    deliveredCount: 851,
    readCount: 620,
    failedCount: 9,
    status: 'completed',
    sentAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  WaBroadcast(
    id: 'bcast_3',
    name: 'Month-End Offers',
    templateId: 'tmpl_offer',
    targetAudience: 'Cold leads',
    recipientCount: 1200,
    sentCount: 445,
    deliveredCount: 431,
    readCount: 210,
    failedCount: 14,
    status: 'sending',
    sentAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];

final List<WaMessage> globalWaMessages = [
  WaMessage(
    id: 'msg_1',
    ruleName: 'Welcome New Lead',
    contactName: 'Ravi Kumar',
    contactPhone: '+91 98410 12345',
    messagePreview: 'Hi Ravi! Welcome to Anbarasan Insurance...',
    status: 'read',
    sentAt: DateTime.now().subtract(const Duration(minutes: 4)),
    isReplied: true,
    replyText: 'Thank you! Please share more details.',
  ),
  WaMessage(
    id: 'msg_2',
    ruleName: 'Welcome New Lead',
    contactName: 'Priya Sharma',
    contactPhone: '+91 98410 67890',
    messagePreview: 'Hi Priya! Welcome to Anbarasan Insurance...',
    status: 'delivered',
    sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
  ),
  WaMessage(
    id: 'msg_3',
    ruleName: 'Policy Renewal Reminder',
    contactName: 'Suresh Menon',
    contactPhone: '+91 98410 11111',
    messagePreview: 'Dear Suresh, your policy renewal is due...',
    status: 'read',
    sentAt: DateTime.now().subtract(const Duration(minutes: 28)),
    isReplied: true,
    replyText: 'Renewed already, thanks!',
  ),
  WaMessage(
    id: 'msg_4',
    ruleName: 'Follow-up After 2 Days',
    contactName: 'Anita Desai',
    contactPhone: '+91 98410 22222',
    messagePreview: 'Hi Anita, just checking in on our last...',
    status: 'sent',
    sentAt: DateTime.now().subtract(const Duration(minutes: 45)),
  ),
  WaMessage(
    id: 'msg_5',
    ruleName: 'Birthday Wish',
    contactName: 'Vikram Rao',
    contactPhone: '+91 98410 33333',
    messagePreview: 'Happy Birthday Vikram! Wishing you...',
    status: 'failed',
    sentAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  WaMessage(
    id: 'msg_6',
    ruleName: 'Welcome New Lead',
    contactName: 'Meena Iyer',
    contactPhone: '+91 98410 44444',
    messagePreview: 'Hi Meena! Welcome to Anbarasan Insurance...',
    status: 'read',
    sentAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  WaMessage(
    id: 'msg_7',
    ruleName: 'Meeting Confirmation',
    contactName: 'Karthik Nair',
    contactPhone: '+91 98410 55555',
    messagePreview: 'Your meeting with our advisor is confirmed...',
    status: 'delivered',
    sentAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  WaMessage(
    id: 'msg_8',
    ruleName: 'Month-End Offers',
    contactName: 'Deepa Pillai',
    contactPhone: '+91 98410 66666',
    messagePreview: 'Exclusive month-end offer on term plans...',
    status: 'read',
    sentAt: DateTime.now().subtract(const Duration(hours: 5)),
    isReplied: true,
    replyText: 'Interested. Call me tomorrow.',
  ),
  WaMessage(
    id: 'msg_9',
    ruleName: 'Welcome New Lead',
    contactName: 'Arjun Singh',
    contactPhone: '+91 98410 77777',
    messagePreview: 'Hi Arjun! Welcome to Anbarasan Insurance...',
    status: 'sent',
    sentAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  WaMessage(
    id: 'msg_10',
    ruleName: 'Policy Renewal Reminder',
    contactName: 'Lakshmi Narayan',
    contactPhone: '+91 98410 88888',
    messagePreview: 'Dear Lakshmi, your policy renewal is due...',
    status: 'delivered',
    sentAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
];

// ─── Screen ─────────────────────────────────────────────────────────────────

class WhatsAppAutomationScreen extends StatefulWidget {
  const WhatsAppAutomationScreen({super.key});

  @override
  State<WhatsAppAutomationScreen> createState() =>
      _WhatsAppAutomationScreenState();
}

class _WhatsAppAutomationScreenState extends State<WhatsAppAutomationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  static const _primary = Color(0xFF6750A4);
  static const _primaryContainer = Color(0xFFF3E8FF);
  static const _tierDark = Color(0xFF4C1D95);
  static const _brandGreen = Color(0xFF00C853);
  static const _textDark = Color(0xFF1E293B);
  static const _textMuted = Color(0xFF64748B);
  static const _borderLight = Color(0xFFE2E8F0);
  static const _alertWarning = Color(0xFFF59E0B);
  static const _alertSuccess = Color(0xFF10B981);
  static const _pink = Color(0xFFDB2777);
  static const _pinkLight = Color(0xFFFDF2F8);
  static const _fbBlue = Color(0xFF1877F2);

  final List<String> _waTriggers = [
    'New lead created',
    'Lead status changed',
    'No response',
    'Policy renewal due',
    'Meeting scheduled',
    'Birthday today',
    'Payment received',
    'Quote accepted',
    'Form submitted',
    'Custom event',
  ];

  final List<String> _waConditions = [
    'All leads',
    'Leads inactive for 2 days',
    'Leads inactive for 7 days',
    'Renewal within 30 days',
    'Renewal within 15 days',
    'Hot leads only',
    'Cold leads',
    'Active leads',
    'Specific product interest',
    'All meetings',
    'All contacts',
    'Premium above ₹50k',
    'Custom filter',
  ];

  final List<String> _waDelays = [
    'Instant',
    '5 minutes',
    '15 minutes',
    '30 minutes',
    '1 hour',
    '3 hours',
    '6 hours',
    '12 hours',
    '1 day',
    '2 days',
    '3 days',
    '1 week',
  ];

  int _delayToMinutes(String delay) {
    switch (delay) {
      case 'Instant':
        return 0;
      case '5 minutes':
        return 5;
      case '15 minutes':
        return 15;
      case '30 minutes':
        return 30;
      case '1 hour':
        return 60;
      case '3 hours':
        return 180;
      case '6 hours':
        return 360;
      case '12 hours':
        return 720;
      case '1 day':
        return 1440;
      case '2 days':
        return 2880;
      case '3 days':
        return 4320;
      case '1 week':
        return 10080;
      default:
        return 0;
    }
  }

  String _formatDelay(int minutes) {
    if (minutes == 0) return 'Instant';
    if (minutes < 60) return '${minutes}m';
    if (minutes < 1440) {
      final h = minutes ~/ 60;
      return '${h}h';
    }
    final d = minutes ~/ 1440;
    return '${d}d';
  }

  String _formatNumber(int value) {
    final s = value.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '${m[1]},');
  }

  bool get _isConnected => globalWaConnection != null;

  int get _totalSent => globalWaRules.fold<int>(0, (sum, r) => sum + r.messagesSent) +
      globalWaBroadcasts.fold<int>(0, (b, c) => b + c.sentCount);

  int get _totalReplies => globalWaRules.fold<int>(0, (sum, r) => sum + r.replies);

  int get _totalTriggered => globalWaRules.fold<int>(0, (sum, r) => sum + r.timesTriggered);

  int get _activeFlowRuns =>
      globalWaRules.fold<int>(0, (sum, r) => sum + r.timesTriggered) + 4020;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _runAutomationEngine() {
    setState(() {
      for (var rule in globalWaRules) {
        if (rule.isActive) {
          rule.timesTriggered += 1;
          rule.messagesSent += 1;
        }
      }
      if (globalWaConnection != null) {
        globalWaConnection!.messagesUsed++;
      }
    });
  }

  void _toggleRule(String ruleId, bool value) {
    setState(() {
      final idx = globalWaRules.indexWhere((r) => r.id == ruleId);
      if (idx != -1) globalWaRules[idx].isActive = value;
    });
  }

  void _deleteRule(String ruleId) {
    setState(() {
      globalWaRules.removeWhere((r) => r.id == ruleId);
    });
  }

  void _deleteBroadcast(String bcastId) {
    setState(() {
      globalWaBroadcasts.removeWhere((b) => b.id == bcastId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return _buildConnectGate();
    }
    return _buildHub(globalWaConnection!);
  }

  // __PART2__
}
