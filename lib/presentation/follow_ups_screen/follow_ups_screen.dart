import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart' as leads_list;
import '../reminders_screen/reminders_screen.dart' show globalReminderMaps;
import '../sessions_screen/sessions_screen.dart' show globalSessionMaps;
import '../templates_screen/templates_screen.dart' show globalTemplateMaps;

// ─── Agent Data ───────────────────────────────────────────────────────────────

class _AgentInfo {
  final String name;
  final String initials;
  final String role;
  final String id;
  final String phone;
  final Color color;
  const _AgentInfo({
    required this.name,
    required this.initials,
    required this.role,
    required this.id,
    required this.phone,
    required this.color,
  });
}

const _kAgents = [
  _AgentInfo(
    name: 'Priya Sharma',
    initials: 'PS',
    role: 'Admin',
    id: 'ADM-1042',
    phone: '+91 98765 11111',
    color: Color(0xFF7C3AED),
  ),
  _AgentInfo(
    name: 'Rahul Singh',
    initials: 'RS',
    role: 'Senior Rep',
    id: 'EMP-2391',
    phone: '+91 87654 22222',
    color: Color(0xFF059669),
  ),
  _AgentInfo(
    name: 'Ananya Patel',
    initials: 'AP',
    role: 'Manager',
    id: 'EMP-1874',
    phone: '+91 76543 33333',
    color: Color(0xFF059669),
  ),
  _AgentInfo(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    id: 'EMP-3012',
    phone: '+91 65432 44444',
    color: Color(0xFF059669),
  ),
  _AgentInfo(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    id: 'EMP-2756',
    phone: '+91 54321 55555',
    color: Color(0xFF059669),
  ),
];

_AgentInfo _agentByName(String name) {
  return _kAgents.firstWhere(
    (a) => a.name == name,
    orElse: () => _AgentInfo(
      name: name,
      initials: name.isNotEmpty ? name[0] : '?',
      role: 'Agent',
      id: '',
      phone: '',
      color: AppTheme.primary,
    ),
  );
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> globalFollowUpMaps = [
  {
    'id': 'fu-001',
    'title': 'Send revised quotation to Rahul Mehta',
    'type': 'Email',
    'status': 'Pending',
    'priority': 'High',
    'dueDate': DateTime.now().copyWith(hour: 10, minute: 30, second: 0),
    'assignedAgent': 'Priya Sharma',
    'agentInitials': 'PS',
    'linkedLead': 'Rahul Mehta',
    'linkedLeadId': 'default-1',
    'customerPhone': '+91 98765 43210',
    'notes':
        'Client requested revised pricing for ₹1Cr life cover + health floater bundle. Include 5% loyalty discount.',
    'outcome': '',
    'isRecurring': true,
    'recurringFrequency': 'Monthly',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'tags': ['Life Insurance', 'Health Cover'],
    'preferredContact': ['Email'],
    'contactMethod': 'Email',
    'reminderBefore': '30 minutes',
    'isExistingCustomer': true,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 2,
    'videoDone': 0,
    'instagramDone': 0,
    'facebookDone': 0,
    'twitterDone': 0,
    'telegramDone': 0,
    'upcomingFollowUps': ['Monthly check-in', 'Renewal reminder'],
  },
  {
    'id': 'fu-002',
    'title': 'Call back Sneha Kapoor — comparison sheet',
    'type': 'Calls',
    'status': 'Pending',
    'priority': 'Medium',
    'dueDate': DateTime.now().copyWith(hour: 14, minute: 0, second: 0),
    'assignedAgent': 'Rahul Singh',
    'agentInitials': 'RS',
    'linkedLead': 'Sneha Kapoor',
    'linkedLeadId': 'default-2',
    'customerPhone': '+91 87654 32109',
    'notes':
        'Send health insurance comparison sheet. Client comparing with HDFC Ergo.',
    'outcome': '',
    'isRecurring': true,
    'recurringFrequency': 'Weekly',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
    'tags': ['Health Cover'],
    'preferredContact': ['Calls', 'WhatsApp Messages'],
    'contactMethod': 'Calls',
    'reminderBefore': '1 hour',
    'isExistingCustomer': false,
    'callsDone': 2,
    'messagesDone': 1,
    'whatsappDone': 0,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': ['Weekly check-in'],
  },
  // Overdue — 3 hours ago
  {
    'id': 'fu-003',
    'title': 'Monthly check-in — Vikram Singh',
    'type': 'Calls',
    'status': 'Overdue',
    'priority': 'Medium',
    'dueDate': DateTime.now().subtract(const Duration(hours: 3)),
    'assignedAgent': 'Priya Sharma',
    'agentInitials': 'PS',
    'linkedLead': 'Vikram Singh',
    'linkedLeadId': 'default-3',
    'customerPhone': '+91 76543 21098',
    'notes':
        'Monthly relationship check-in. Discuss proposal progress and any concerns.',
    'outcome': '',
    'isRecurring': true,
    'recurringFrequency': 'Monthly',
    'isOverdue': true,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 30)),
    'tags': ['Term Insurance', 'Health Cover'],
    'preferredContact': ['Calls'],
    'contactMethod': 'Calls',
    'reminderBefore': '1 day',
    'isExistingCustomer': true,
    'callsDone': 5,
    'messagesDone': 2,
    'whatsappDone': 1,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': ['Monthly check-in next cycle'],
  },
  // Completed — yesterday
  {
    'id': 'fu-004',
    'title': 'WhatsApp — Policy renewal reminder Anita Desai',
    'type': 'WhatsApp Messages',
    'status': 'Completed',
    'priority': 'Low',
    'dueDate': DateTime.now().subtract(const Duration(days: 1)),
    'assignedAgent': 'Ananya Patel',
    'agentInitials': 'AP',
    'linkedLead': 'Anita Desai',
    'linkedLeadId': 'default-4',
    'customerPhone': '+91 65432 10987',
    'notes':
        'Annual policy renewal due. Send renewal notice with updated premium.',
    'outcome': 'Client confirmed renewal. Payment received.',
    'isRecurring': true,
    'recurringFrequency': 'Yearly',
    'isOverdue': false,
    'completedAt': DateTime.now().subtract(const Duration(hours: 20)),
    'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    'tags': ['Add-on Cover'],
    'preferredContact': ['WhatsApp Messages'],
    'contactMethod': 'WhatsApp Messages',
    'reminderBefore': '2 days',
    'isExistingCustomer': true,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 3,
    'emailDone': 1,
    'videoDone': 0,
    'upcomingFollowUps': ['Yearly renewal reminder'],
  },
  // Upcoming — tomorrow (about 20h to go)
  {
    'id': 'fu-005',
    'title': 'Send SIP calculator to Karan Joshi',
    'type': 'Email',
    'status': 'Upcoming',
    'priority': 'Medium',
    'dueDate': DateTime.now().add(const Duration(hours: 20)),
    'assignedAgent': 'Kavya Menon',
    'agentInitials': 'KM',
    'linkedLead': 'Karan Joshi',
    'linkedLeadId': 'default-5',
    'customerPhone': '+91 54321 09876',
    'notes':
        'Prepare SIP calculator showing returns at 12%, 15%, 18% CAGR. Include tax saving options.',
    'outcome': '',
    'isRecurring': false,
    'recurringFrequency': 'Daily',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'tags': ['Mutual Funds', 'SIP'],
    'preferredContact': ['Email'],
    'contactMethod': 'Email',
    'reminderBefore': '30 minutes',
    'isExistingCustomer': false,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 1,
    'videoDone': 0,
    'upcomingFollowUps': ['Daily SIP update', 'Tax planning session'],
  },
  // Upcoming — 3 days
  {
    'id': 'fu-006',
    'title': 'Draft Key Man policy terms — Al-Rashid',
    'type': 'Video Call',
    'status': 'Upcoming',
    'priority': 'High',
    'dueDate': DateTime.now().add(const Duration(days: 3)),
    'assignedAgent': 'Priya Sharma',
    'agentInitials': 'PS',
    'linkedLead': 'Mohammed Al-Rashid',
    'linkedLeadId': 'default-6',
    'customerPhone': '+971 50 123 4567',
    'notes':
        'Draft key man insurance policy terms for 3 C-suite executives. Budget AED 200K/yr approved.',
    'outcome': '',
    'isRecurring': false,
    'recurringFrequency': 'Custom',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'tags': ['Corporate Plan', 'Key Man Insurance'],
    'preferredContact': ['Video Call', 'Email'],
    'contactMethod': 'Video Call',
    'reminderBefore': '1 day',
    'isExistingCustomer': true,
    'callsDone': 1,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 2,
    'videoDone': 1,
    'upcomingFollowUps': ['Contract review', 'Legal sign-off'],
  },
  // Overdue — 2 days ago
  {
    'id': 'fu-007',
    'title': 'Reschedule call — Deepa Nair',
    'type': 'Calls',
    'status': 'Overdue',
    'priority': 'High',
    'dueDate': DateTime.now().subtract(const Duration(days: 2)),
    'assignedAgent': 'Rahul Singh',
    'agentInitials': 'RS',
    'linkedLead': 'Deepa Nair',
    'linkedLeadId': '',
    'customerPhone': '+91 99887 76655',
    'notes':
        'Client cancelled previous session. Need to reschedule SIP & tax planning meeting.',
    'outcome': '',
    'isRecurring': false,
    'recurringFrequency': 'Weekly',
    'isOverdue': true,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'tags': ['SIP', 'Tax Planning'],
    'preferredContact': ['Calls'],
    'contactMethod': 'Calls',
    'reminderBefore': '1 hour',
    'isExistingCustomer': false,
    'callsDone': 1,
    'messagesDone': 0,
    'whatsappDone': 1,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': [],
  },
  // Upcoming — 4 days
  {
    'id': 'fu-008',
    'title': 'Weekly pipeline review — all leads',
    'type': 'Messages',
    'status': 'Upcoming',
    'priority': 'Medium',
    'dueDate': DateTime.now().add(const Duration(days: 4)),
    'assignedAgent': 'Priya Sharma',
    'agentInitials': 'PS',
    'linkedLead': 'Team',
    'linkedLeadId': '',
    'customerPhone': '',
    'notes':
        'Weekly team pipeline review. Discuss conversion rates, pending proposals, and upcoming sessions.',
    'outcome': '',
    'isRecurring': true,
    'recurringFrequency': 'Weekly',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    'tags': ['Pipeline Review'],
    'preferredContact': ['Messages'],
    'contactMethod': 'Messages',
    'reminderBefore': '1 hour',
    'isExistingCustomer': false,
    'callsDone': 0,
    'messagesDone': 3,
    'whatsappDone': 0,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': ['Next weekly review'],
  },
  // Upcoming — 4 hours to go
  {
    'id': 'fu-009',
    'title': 'Video call with Pradeep Kumar — SIP review',
    'type': 'Video Call',
    'status': 'Upcoming',
    'priority': 'High',
    'dueDate': DateTime.now().add(const Duration(hours: 4)),
    'assignedAgent': 'Arjun Das',
    'agentInitials': 'AD',
    'linkedLead': 'Pradeep Kumar',
    'linkedLeadId': '',
    'customerPhone': '+91 70987 65432',
    'notes':
        'SIP investment planning and portfolio review. Client wants to start ₹25K/month SIP.',
    'outcome': '',
    'isRecurring': false,
    'recurringFrequency': 'Custom',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'tags': ['SIP', 'Mutual Funds'],
    'preferredContact': ['Video Call'],
    'contactMethod': 'Video Call',
    'reminderBefore': '30 minutes',
    'isExistingCustomer': false,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': [],
  },
  // Completed — 2 days ago
  {
    'id': 'fu-010',
    'title': 'Term plan proposal — Arjun Mehta',
    'type': 'Calls',
    'status': 'Completed',
    'priority': 'High',
    'dueDate': DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    'assignedAgent': 'Kavya Menon',
    'agentInitials': 'KM',
    'linkedLead': 'Arjun Mehta',
    'linkedLeadId': '',
    'customerPhone': '+91 91234 56789',
    'notes': 'Discussed term plan options. Client interested in ₹50L cover.',
    'outcome': 'Client agreed to proceed. Sent proposal document.',
    'isRecurring': false,
    'recurringFrequency': 'Custom',
    'isOverdue': false,
    'completedAt': DateTime.now().subtract(const Duration(days: 2)),
    'createdAt': DateTime.now().subtract(const Duration(days: 4)),
    'tags': ['Term Insurance'],
    'preferredContact': ['Calls'],
    'contactMethod': 'Calls',
    'reminderBefore': '1 hour',
    'isExistingCustomer': true,
    'callsDone': 3,
    'messagesDone': 0,
    'whatsappDone': 1,
    'emailDone': 1,
    'videoDone': 0,
    'upcomingFollowUps': [],
  },
  // Overdue — 5 hours ago
  {
    'id': 'fu-011',
    'title': 'WhatsApp follow-up — Sunita Rao health floater',
    'type': 'WhatsApp Messages',
    'status': 'Overdue',
    'priority': 'Medium',
    'dueDate': DateTime.now().subtract(const Duration(hours: 5)),
    'assignedAgent': 'Ananya Patel',
    'agentInitials': 'AP',
    'linkedLead': 'Sunita Rao',
    'linkedLeadId': '',
    'customerPhone': '+91 80123 45678',
    'notes':
        'Send health floater plan details for family of 5. Include premium comparison.',
    'outcome': '',
    'isRecurring': false,
    'recurringFrequency': 'Custom',
    'isOverdue': true,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    'tags': ['Health Cover'],
    'preferredContact': ['WhatsApp Messages'],
    'contactMethod': 'WhatsApp Messages',
    'reminderBefore': '30 minutes',
    'isExistingCustomer': true,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': [],
  },
  // Upcoming — 7 days
  {
    'id': 'fu-012',
    'title': 'Email — Retirement corpus plan for Deepa Krishnan',
    'type': 'Email',
    'status': 'Upcoming',
    'priority': 'Low',
    'dueDate': DateTime.now().add(const Duration(days: 7)),
    'assignedAgent': 'Rahul Singh',
    'agentInitials': 'RS',
    'linkedLead': 'Deepa Krishnan',
    'linkedLeadId': 'default-7',
    'customerPhone': '+91 54321 09876',
    'notes':
        'Send retirement corpus planning document. Target corpus ₹2Cr by age 60.',
    'outcome': '',
    'isRecurring': true,
    'recurringFrequency': 'Monthly',
    'isOverdue': false,
    'completedAt': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'tags': ['Retirement Planning'],
    'preferredContact': ['Email'],
    'contactMethod': 'Email',
    'reminderBefore': '1 day',
    'isExistingCustomer': false,
    'callsDone': 0,
    'messagesDone': 0,
    'whatsappDone': 0,
    'emailDone': 0,
    'videoDone': 0,
    'upcomingFollowUps': ['Monthly retirement review'],
  },
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class FollowUpsScreen extends StatefulWidget {
  const FollowUpsScreen({super.key});

  @override
  State<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

enum _FollowUpSortOption {
  dueDateSoonest,
  dueDateLatest,
  priorityHigh,
  createdNewest,
  leadAZ,
}

class _FollowUpsScreenState extends State<FollowUpsScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  _FollowUpSortOption _sortOption = _FollowUpSortOption.dueDateSoonest;

  // Filter state
  List<String> _selectedAgents = [];
  List<String> _selectedTypes = [];
  List<String> _selectedFrequencies = [];
  bool? _existingCustomerFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _showCompleted = false;
  bool _showUpcoming = false;
  bool _showOverdue = false;
  bool _showCancelled = false;
  bool _showDues = false;
  bool _showToday = false;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _followUps = [];

  static const _typeOptions = [
    'Calls',
    'Video Call',
    'WhatsApp Messages',
    'Email',
    'Messages',
    'Instagram',
    'Facebook',
    'X (Twitter)',
    'Telegram',
  ];
  static const _frequencyOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    _loadFollowUps();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowUps() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _followUps = List.from(globalFollowUpMaps);
        _isLoading = false;
      });
    }
  }

  bool get _hasActiveFilters =>
      _selectedAgents.isNotEmpty ||
      _selectedTypes.isNotEmpty ||
      _selectedFrequencies.isNotEmpty ||
      _existingCustomerFilter != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _showCompleted ||
      _showUpcoming ||
      _showOverdue ||
      _showCancelled ||
      _showDues ||
      _showToday;

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  // Round filter chips (same as sessions)
  String _selectedStatusFilter = 'All';
  static const _statusFilterOptions = [
    'All',
    'Today',
    'Overdue',
    'Upcoming',
    'Completed',
    'Cancelled',
  ];

  // Whether a non-default filter is active (hides horizontal chips)
  bool get _isFilterActive => _hasActiveFilters;

  Widget _buildStatusFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _statusFilterOptions[i];
          final selected = _selectedStatusFilter == f;
          // Count for each filter
          int count = 0;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          switch (f) {
            case 'All':
              count = _followUps.length;
              break;
            case 'Today':
              count = _followUps
                  .where(
                    (fu) =>
                        _isToday(fu['dueDate'] as DateTime) &&
                        fu['status'] != 'Completed',
                  )
                  .length;
              break;
            case 'Overdue':
              count = _followUps
                  .where(
                    (fu) =>
                        fu['isOverdue'] == true || fu['status'] == 'Overdue',
                  )
                  .length;
              break;
            case 'Upcoming':
              count = _followUps
                  .where((fu) => fu['status'] == 'Upcoming')
                  .length;
              break;
            case 'Completed':
              count = _followUps
                  .where((fu) => fu['status'] == 'Completed')
                  .length;
              break;
            case 'Cancelled':
              count = _followUps
                  .where((fu) => fu['status'] == 'Cancelled')
                  .length;
              break;
          }
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedStatusFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.warning : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppTheme.warning : AppTheme.surface200,
                  ),
                ),
                child: Text(
                '$f ($count)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredFollowUps {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    List<Map<String, dynamic>> result = _followUps.where((f) {
      final status = f['status'] as String;
      final dueDate = f['dueDate'] as DateTime;

      // Apply round status filter first
      if (_selectedStatusFilter != 'All') {
        switch (_selectedStatusFilter) {
          case 'Today':
            if (!(_isToday(dueDate) && status != 'Completed')) return false;
            break;
          case 'Overdue':
            if (!(f['isOverdue'] == true || status == 'Overdue')) return false;
            break;
          case 'Upcoming':
            if (status != 'Upcoming') return false;
            break;
          case 'Completed':
            if (status != 'Completed') return false;
            break;
          case 'Cancelled':
            if (status != 'Cancelled') return false;
            break;
        }
      } else {
        // Default: show today first, then all others
        // Show all statuses in All view
      }

      // With status filters active: apply status logic
      final bool anyStatusFilter =
          _showCompleted ||
          _showUpcoming ||
          _showOverdue ||
          _showCancelled ||
          _showDues ||
          _showToday;
      if (anyStatusFilter) {
        bool matchesStatus = false;
        if (_showCompleted && status == 'Completed') matchesStatus = true;
        if (_showUpcoming && status == 'Upcoming') matchesStatus = true;
        if (_showOverdue && (f['isOverdue'] == true || status == 'Overdue')) {
          matchesStatus = true;
        }
        if (_showCancelled && status == 'Cancelled') matchesStatus = true;
        if (_showDues) {
          final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
          if (dueDay.isBefore(today) &&
              status != 'Completed' &&
              status != 'Cancelled') {
            matchesStatus = true;
          }
        }
        if (_showToday && _isToday(dueDate) && status != 'Completed') {
          matchesStatus = true;
        }
        if (!matchesStatus) return false;
      }

      final matchesSearch =
          _searchQuery.isEmpty ||
          (f['linkedLead'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (f['customerPhone'] as String? ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (f['assignedAgent'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (f['title'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesAgent =
          _selectedAgents.isEmpty ||
          _selectedAgents.contains(f['assignedAgent']);
      final matchesType =
          _selectedTypes.isEmpty || _selectedTypes.contains(f['type']);
      final matchesFreq =
          _selectedFrequencies.isEmpty ||
          _selectedFrequencies.contains(f['recurringFrequency']);
      final matchesExisting =
          _existingCustomerFilter == null ||
          (_existingCustomerFilter == true &&
              f['isExistingCustomer'] == true) ||
          (_existingCustomerFilter == false && f['isExistingCustomer'] != true);

      bool matchesDate = true;
      if (_dateFrom != null && dueDate.isBefore(_dateFrom!)) {
        matchesDate = false;
      }
      if (_dateTo != null &&
          dueDate.isAfter(_dateTo!.add(const Duration(days: 1)))) {
        matchesDate = false;
      }

      return matchesSearch &&
          matchesAgent &&
          matchesType &&
          matchesFreq &&
          matchesExisting &&
          matchesDate;
    }).toList();

    // Sort: today first (time asc), then overdue desc, then rest
    result.sort((a, b) {
      final aDate = a['dueDate'] as DateTime;
      final bDate = b['dueDate'] as DateTime;
      final aIsToday = _isToday(aDate);
      final bIsToday = _isToday(bDate);
      final aIsOverdue = a['isOverdue'] == true || a['status'] == 'Overdue';
      final bIsOverdue = b['isOverdue'] == true || b['status'] == 'Overdue';

      // Today first (time ascending)
      if (aIsToday && !bIsToday) return -1;
      if (!aIsToday && bIsToday) return 1;
      if (aIsToday && bIsToday) return aDate.compareTo(bDate); // time asc

      // Both overdue: sort desc (most recently overdue first)
      if (aIsOverdue && bIsOverdue) return bDate.compareTo(aDate);

      return aDate.compareTo(bDate);
    });

    return result;
  }

  int get _totalCount => _followUps.length;
  int get _todayCount => _followUps
      .where(
        (f) => _isToday(f['dueDate'] as DateTime) && f['status'] != 'Completed',
      )
      .length;
  int get _overdueCount => _followUps
      .where((f) => f['isOverdue'] == true || f['status'] == 'Overdue')
      .length;
  int get _upcomingCount =>
      _followUps.where((f) => f['status'] == 'Upcoming').length;
  int get _completedCount =>
      _followUps.where((f) => f['status'] == 'Completed').length;
  int get _cancelledCount =>
      _followUps.where((f) => f['status'] == 'Cancelled').length;
  int get _duesCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _followUps.where((f) {
      final dueDate = f['dueDate'] as DateTime;
      final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final status = f['status'] as String;
      return dueDay.isBefore(today) &&
          status != 'Completed' &&
          status != 'Cancelled';
    }).length;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedAgents = [];
      _selectedTypes = [];
      _selectedFrequencies = [];
      _existingCustomerFilter = null;
      _dateFrom = null;
      _dateTo = null;
      _showCompleted = false;
      _showUpcoming = false;
      _showOverdue = false;
      _showCancelled = false;
      _showDues = false;
      _showToday = false;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _FUFilterSheet(
        selectedAgents: List.from(_selectedAgents),
        selectedTypes: List.from(_selectedTypes),
        selectedFrequencies: List.from(_selectedFrequencies),
        existingCustomerFilter: _existingCustomerFilter,
        showCompleted: _showCompleted,
        showUpcoming: _showUpcoming,
        showOverdue: _showOverdue,
        showCancelled: _showCancelled,
        showDues: _showDues,
        showToday: _showToday,
        typeOptions: _typeOptions,
        frequencyOptions: _frequencyOptions,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        onApply:
            (
              agents,
              types,
              freqs,
              existing,
              from,
              to,
              showCompleted,
              showUpcoming,
              showOverdue,
              showCancelled,
              showDues,
              showToday,
            ) {
              setState(() {
                _selectedAgents = agents;
                _selectedTypes = types;
                _selectedFrequencies = freqs;
                _existingCustomerFilter = existing;
                _dateFrom = from;
                _dateTo = to;
                _showCompleted = showCompleted;
                _showUpcoming = showUpcoming;
                _showOverdue = showOverdue;
                _showCancelled = showCancelled;
                _showDues = showDues;
                _showToday = showToday;
              });
            },
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _FUSortSheet(
        current: _sortOption,
        onSelect: (o) => setState(() => _sortOption = o),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFollowUps;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: RefreshIndicator(
          onRefresh: _loadFollowUps,
          child: CustomScrollView(
            controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppTheme.surfaceLight,
              elevation: 0,
              scrolledUnderElevation: 1,
              shadowColor: AppTheme.surface200,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 22),
                color: AppTheme.textPrimary,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    context.go(AppRoutes.dashboardScreen);
                  }
                },
              ),
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withAlpha(31),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.repeat_rounded,
                      color: AppTheme.warning,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Follow Ups',
                            maxLines: 1,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${filtered.length}/$_totalCount shown',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchActive
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    color: AppTheme.textSecondary,
                    size: 22,
                  ),
                  onPressed: () => setState(() {
                    _isSearchActive = !_isSearchActive;
                    if (!_isSearchActive) {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  }),
                ),
                _HeaderBtn(
                  icon: Icons.filter_list_rounded,
                  hasActive: _hasActiveFilters,
                  onTap: _showFilterSheet,
                ),
                const SizedBox(width: 6),
                _HeaderBtn(
                  icon: Icons.sort_rounded,
                  hasActive: false,
                  onTap: _showSortSheet,
                ),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (_isSearchActive) _buildSearchBar(),
                  _buildKpiRow(),
                  if (!_isFilterActive) _buildStatusFilterBar(),
                  if (_isFilterActive) _buildFollowUpActiveFilterIndicator(),
                  if (_hasActiveFilters) _buildActiveFilterChips(),
                  if (_hasActiveFilters)
                    _buildFilteredCountBanner(filtered.length),
                ],
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filtered.isEmpty)
              SliverFillRemaining(child: _buildEmpty())
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, navBarHeight + 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final items = _buildSectionedItems(filtered);
                      final item = items[i];
                      if (item is String) {
                        final isToday = item.startsWith('Today');
                        final isOverdue = item.contains('Overdue') ||
                            item.startsWith('Yesterday');
                        return Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppTheme.primary.withAlpha(20)
                                      : isOverdue
                                          ? AppTheme.error.withAlpha(20)
                                          : AppTheme.surface200,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isToday
                                        ? AppTheme.primary.withAlpha(60)
                                        : isOverdue
                                            ? AppTheme.error.withAlpha(60)
                                            : AppTheme.surface200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isToday
                                          ? Icons.today_rounded
                                          : isOverdue
                                              ? Icons.warning_rounded
                                              : Icons.calendar_today_rounded,
                                      size: 12,
                                      color: isToday
                                          ? AppTheme.primary
                                          : isOverdue
                                              ? AppTheme.error
                                              : AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        item,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isToday
                                              ? AppTheme.primary
                                              : isOverdue
                                                  ? AppTheme.error
                                                  : AppTheme.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Divider(
                                  color: isToday
                                      ? AppTheme.primary.withAlpha(40)
                                      : isOverdue
                                          ? AppTheme.error.withAlpha(40)
                                          : AppTheme.surface200,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final f = item as Map<String, dynamic>;
                      final idx = filtered.indexOf(f);
                      return _FollowUpCard(
                        followUp: f,
                        index: idx,
                        onUpdate: () => setState(() {
                          _followUps = List.from(globalFollowUpMaps);
                        }),
                      );
                    },
                    childCount: _buildSectionedItems(filtered).length,
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'fu_template',
            onPressed: _showTemplatesSheet,
            backgroundColor: AppTheme.primary,
            child: const Icon(
              Icons.library_books_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'fu_new',
            onPressed: _showNewFollowUpSheet,
            backgroundColor: AppTheme.warning,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: Text(
              'New Follow-up',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      );
  }

  Widget _buildFilteredCountBanner(int count) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.warning.withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 13,
                  color: AppTheme.warning,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    '$count follow-up${count == 1 ? '' : 's'} found',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warning,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpActiveFilterIndicator() {
    int count = 0;
    final now = DateTime.now();
    switch (_selectedStatusFilter) {
      case 'All':
        count = _followUps.length;
        break;
      case 'Today':
        count = _followUps
            .where(
              (fu) =>
                  _isToday(fu['dueDate'] as DateTime) &&
                  fu['status'] != 'Completed',
            )
            .length;
        break;
      case 'Overdue':
        count = _followUps
            .where((fu) => fu['isOverdue'] == true || fu['status'] == 'Overdue')
            .length;
        break;
      case 'Upcoming':
        count = _followUps.where((fu) => fu['status'] == 'Upcoming').length;
        break;
      case 'Completed':
        count = _followUps.where((fu) => fu['status'] == 'Completed').length;
        break;
      case 'Cancelled':
        count = _followUps.where((fu) => fu['status'] == 'Cancelled').length;
        break;
    }
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.warning,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_list_rounded,
                  size: 13,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  '$_selectedStatusFilter ($count)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedStatusFilter = 'All'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusFilterOptions
                    .where((f) => f != _selectedStatusFilter)
                    .map((f) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedStatusFilter = f),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.plusJakartaSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search name, phone, agent...',
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          filled: true,
          fillColor: AppTheme.surface100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow() {
    final kpis = [
      _KpiData(
        'Total',
        '$_totalCount',
        Icons.repeat_rounded,
        AppTheme.warning,
        '+5%',
        true,
      ),
      _KpiData(
        'Today',
        '$_todayCount',
        Icons.today_rounded,
        AppTheme.primary,
        '-$_todayCount',
        false,
      ),
      _KpiData(
        'Overdue',
        '$_overdueCount',
        Icons.warning_rounded,
        AppTheme.error,
        '-$_overdueCount',
        false,
      ),
      _KpiData(
        'Upcoming',
        '$_upcomingCount',
        Icons.schedule_rounded,
        const Color(0xFF0891B2),
        '-$_upcomingCount',
        false,
      ),
      _KpiData(
        'Completed',
        '$_completedCount',
        Icons.check_circle_rounded,
        AppTheme.success,
        '+8%',
        true,
      ),
    ];
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _KpiCard(data: kpis[i]),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          ..._selectedAgents.map(
            (a) => _ActiveFilterChip(
              label: 'Agent: $a',
              onRemove: () => setState(() => _selectedAgents.remove(a)),
            ),
          ),
          ..._selectedTypes.map(
            (t) => _ActiveFilterChip(
              label: 'Type: $t',
              onRemove: () => setState(() => _selectedTypes.remove(t)),
            ),
          ),
          ..._selectedFrequencies.map(
            (f) => _ActiveFilterChip(
              label: 'Freq: $f',
              onRemove: () => setState(() => _selectedFrequencies.remove(f)),
            ),
          ),
          if (_existingCustomerFilter != null)
            _ActiveFilterChip(
              label: 'Existing: ${_existingCustomerFilter! ? 'Yes' : 'No'}',
              onRemove: () => setState(() => _existingCustomerFilter = null),
            ),
          if (_dateFrom != null)
            _ActiveFilterChip(
              label: 'From: ${_dateFrom!.day}/${_dateFrom!.month}',
              onRemove: () => setState(() => _dateFrom = null),
            ),
          if (_dateTo != null)
            _ActiveFilterChip(
              label: 'To: ${_dateTo!.day}/${_dateTo!.month}',
              onRemove: () => setState(() => _dateTo = null),
            ),
          if (_showOverdue)
            _ActiveFilterChip(
              label: 'Overdue',
              onRemove: () => setState(() => _showOverdue = false),
            ),
          if (_showCompleted)
            _ActiveFilterChip(
              label: 'Completed',
              onRemove: () => setState(() => _showCompleted = false),
            ),
          if (_showUpcoming)
            _ActiveFilterChip(
              label: 'Upcoming',
              onRemove: () => setState(() => _showUpcoming = false),
            ),
          if (_showCancelled)
            _ActiveFilterChip(
              label: 'Cancelled',
              onRemove: () => setState(() => _showCancelled = false),
            ),
          if (_showDues)
            _ActiveFilterChip(
              label: 'Dues',
              onRemove: () => setState(() => _showDues = false),
            ),
          if (_showToday)
            _ActiveFilterChip(
              label: 'Today',
              onRemove: () => setState(() => _showToday = false),
            ),
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.error.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.clear_all_rounded,
                    size: 14,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.repeat_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No follow-ups for today',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Use filters to view all follow-ups',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sectioned list with sticky date headers ───────────────────────────────

  String _sectionLabel(Map<String, dynamic> f) {
    final dueDate = f['dueDate'] as DateTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dueDate.hour > 12
        ? dueDate.hour - 12
        : (dueDate.hour == 0 ? 12 : dueDate.hour);
    final ampm = dueDate.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$h:${dueDate.minute.toString().padLeft(2, '0')} $ampm';
    final dateStr =
        '${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}';

    if (due == today) return 'Today · $timeStr';
    if (due.isBefore(today)) {
      final diff = today.difference(due).inDays;
      final overdueLabel = diff == 1 ? 'Yesterday' : '${diff}d Overdue';
      return '$overdueLabel · $dateStr $timeStr';
    }
    if (due == today.add(const Duration(days: 1))) return 'Tomorrow · $timeStr';
    return '$dateStr · $timeStr';
  }

  String _statusLabel(Map<String, dynamic> f) {
    final status = f['status'] as String? ?? '';
    final dueDate = f['dueDate'] as DateTime;
    final now = DateTime.now();

    if (status == 'Completed') return 'Completed';

    // Determine Due vs Upcoming based on date
    if (dueDate.isBefore(now)) {
      return 'Due'; // Past date, no action taken
    } else {
      return 'Upcoming'; // Future date
    }
  }

  List<dynamic> _buildSectionedItems(List<Map<String, dynamic>> filtered) {
    final List<dynamic> items = [];
    String? lastDateKey;
    for (final f in filtered) {
      final dueDate = f['dueDate'] as DateTime;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final dateStr =
          '${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}';

      String dateKey;
      if (due == today) {
        dateKey = 'Today';
      } else if (due.isBefore(today)) {
        final diff = today.difference(due).inDays;
        dateKey = diff == 1
            ? 'Yesterday · $dateStr'
            : '${diff}d Overdue · $dateStr';
      } else if (due == today.add(const Duration(days: 1))) {
        dateKey = 'Tomorrow · $dateStr';
      } else {
        dateKey = dateStr;
      }

      if (dateKey != lastDateKey) {
        items.add(dateKey);
        lastDateKey = dateKey;
      }
      items.add(f);
    }
    return items;
  }

  void _showNewFollowUpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _NewFollowUpSheet(
        agents: _kAgents,
        onSave: (followUpData) {
          // Check: max 1 active follow-up per customer
          final customerName = followUpData['linkedLead'] as String? ?? '';
          final customerId = followUpData['linkedLeadId'] as String? ?? '';
          if (customerName.isNotEmpty) {
            final conflict = globalFollowUpMaps.any((m) {
              final mStatus = m['status'] as String? ?? '';
              if (mStatus == 'Completed' || mStatus == 'Cancelled') {
                return false;
              }
              final mLead = m['linkedLead'] as String? ?? '';
              final mLeadId = m['linkedLeadId'] as String? ?? '';
              return (mLead == customerName) ||
                  (customerId.isNotEmpty && mLeadId == customerId);
            });
            if (conflict) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppTheme.warning,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Active Follow-up Exists',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    '$customerName already has an active follow-up. A customer cannot have more than 1 active follow-up at a time. Please complete or cancel the existing follow-up first.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              return;
            }
          }
          globalFollowUpMaps.insert(0, followUpData);
          setState(() {
            _followUps = List.from(globalFollowUpMaps);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text('Follow-up created successfully!'),
                ],
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        ),
      ),
    );
  }

  void _showTemplatesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _FollowUpTemplatesSheet(
        onUseTemplate: (templateData) {
          globalFollowUpMaps.insert(0, templateData);
          setState(() {
            _followUps = List.from(globalFollowUpMaps);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Follow-up created from template!'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}

// ─── Follow-Up Card ───────────────────────────────────────────────────────────

class _FollowUpCard extends StatefulWidget {
  final Map<String, dynamic> followUp;
  final int index;
  final VoidCallback onUpdate;
  const _FollowUpCard({
    required this.followUp,
    required this.index,
    required this.onUpdate,
  });

  @override
  State<_FollowUpCard> createState() => _FollowUpCardState();
}

class _FollowUpCardState extends State<_FollowUpCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _actionsExpanded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(
      Duration(milliseconds: (widget.index * 50).clamp(0, 350)),
      () {
        if (mounted) _ctrl.forward();
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Completed':
        return AppTheme.success;
      case 'Due':
        return AppTheme.error;
      case 'Upcoming':
        return const Color(0xFF0891B2);
      // Legacy support
      case 'Pending':
        return AppTheme.primary;
      case 'Overdue':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Calls':
        return Icons.phone_rounded;
      case 'Email':
        return Icons.email_rounded;
      case 'WhatsApp Messages':
        return Icons.chat_rounded;
      case 'Messages':
        return Icons.message_rounded;
      case 'Video Call':
        return Icons.videocam_rounded;
      default:
        return Icons.repeat_rounded;
    }
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'Calls':
        return AppTheme.success;
      case 'Email':
        return AppTheme.primary;
      case 'WhatsApp Messages':
        return const Color(0xFF25D366);
      case 'Messages':
        return const Color(0xFF8B5CF6);
      case 'Video Call':
        return const Color(0xFF0891B2);
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatDue(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
    final status = widget.followUp['status'] as String? ?? '';
    if (status == 'Completed') {
      final completedAt = widget.followUp['completedAt'] as DateTime?;
      if (completedAt != null) {
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final h = completedAt.hour > 12
            ? completedAt.hour - 12
            : (completedAt.hour == 0 ? 12 : completedAt.hour);
        final ampm = completedAt.hour >= 12 ? 'PM' : 'AM';
        return 'Done ${completedAt.day} ${months[completedAt.month - 1]}, $h:${completedAt.minute.toString().padLeft(2, '0')} $ampm';
      }
      return 'Completed';
    }
    if (diff.isNegative) {
      final abs = diff.abs();
      if (abs.inMinutes < 60) return 'Due · ${abs.inMinutes}m ago';
      if (abs.inHours < 24) return 'Due · ${abs.inHours}h ago';
      if (abs.inDays == 1) return 'Due · Yesterday';
      if (abs.inDays < 365) return 'Overdue · ${abs.inDays}d';
      return 'Overdue · ${(abs.inDays / 365).floor()}y ${abs.inDays % 365}d';
    }
    if (diff.inMinutes < 60) return 'Due in ${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h to go';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 30) return 'In ${diff.inDays}d';
    if (diff.inDays < 365) return 'In ${(diff.inDays / 30).floor()}mo';
    return 'In ${(diff.inDays / 365).floor()}y';
  }

  String _formatDueDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:${dt.minute.toString().padLeft(2, '0')} $ampm';
  }

  void _showActionsBottomSheet(BuildContext context, Map<String, dynamic> f) {
    final preferred = (f['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = f['linkedLead'] as String;
    final leadMap = leads_list.globalLeads.firstWhere(
      (m) => m['id'] == f['linkedLeadId'] || m['name'] == customerName,
      orElse: () => {},
    );
    final hasInstagram = (leadMap['instagram'] as String? ?? '').isNotEmpty;
    final hasFacebook = (leadMap['facebook'] as String? ?? '').isNotEmpty;
    final hasTwitter = (leadMap['twitter'] as String? ?? '').isNotEmpty;
    final hasTelegram = (leadMap['telegram'] as String? ?? '').isNotEmpty;

    final isFrozen = f['status'] == 'Completed' || f['status'] == 'Cancelled';

    void logAction(String actionKey, String actionLabel) {
      if (isFrozen) return;
      final idx = globalFollowUpMaps.indexWhere((m) => m['id'] == f['id']);
      if (idx >= 0) {
        globalFollowUpMaps[idx][actionKey] =
            (globalFollowUpMaps[idx][actionKey] as int? ?? 0) + 1;
      }
      setState(() {
        f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
      });
      widget.onUpdate();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$actionLabel logged for $customerName'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }

    void showTemplatePicker(
      String actionLabel,
      String actionKey, {
      String? platform,
    }) {
      final templates = globalTemplateMaps.where((t) {
        final cat = (t['category'] as String? ?? '').toLowerCase();
        if (platform != null) {
          return cat.contains(platform.toLowerCase()) ||
              cat == 'sms' ||
              cat == 'email';
        }
        return true;
      }).toList();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: _FUTemplatePickerSheet(
          actionLabel: actionLabel,
          templates: templates,
          customerName: customerName,
          isWhatsApp: platform?.toLowerCase() == 'whatsapp',
          onUseTemplate: (_) => logAction(actionKey, actionLabel),
          onCustomMessage: () => logAction(actionKey, actionLabel),
          ),
        ),
      );
    }

    void checkPreferenceAndLog(String action, String actionKey) {
      bool isPreferred = preferred.isEmpty || preferred.contains(action);
      if (!isPreferred) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Not Preferred',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              '$action is not preferred for $customerName. Proceed anyway?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (action == 'WhatsApp Messages' ||
                      action == 'Messages' ||
                      action == 'Email') {
                    showTemplatePicker(action, actionKey, platform: action);
                  } else {
                    logAction(actionKey, action);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.warning,
                ),
                child: Text(
                  'Proceed',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        if (action == 'WhatsApp Messages' ||
            action == 'Messages' ||
            action == 'Email') {
          showTemplatePicker(action, actionKey, platform: action);
        } else {
          logAction(actionKey, action);
        }
      }
    }

    void doSocialAction(String platform, bool hasData, String actionKey) {
      if (!hasData) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'No Data Found',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'No $platform data found for $customerName.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        showTemplatePicker(platform, actionKey, platform: platform);
      }
    }

    void cancelFollowUp() {
      final reasonCtrl = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (ctx, setS) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.cancel_rounded, color: AppTheme.error, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Cancel Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a reason for cancellation:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  onChanged: (_) => setS(() {}),
                  decoration: InputDecoration(
                    hintText: 'e.g. Customer not interested...',
                    filled: true,
                    fillColor: AppTheme.surface100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Back',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: reasonCtrl.text.trim().isEmpty
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        final reason = reasonCtrl.text.trim();
                        final idx = globalFollowUpMaps.indexWhere(
                          (m) => m['id'] == f['id'],
                        );
                        if (idx >= 0) {
                          globalFollowUpMaps[idx]['status'] = 'Cancelled';
                          globalFollowUpMaps[idx]['cancelReason'] = reason;
                          globalFollowUpMaps[idx]['cancelledAt'] =
                              DateTime.now();
                        }
                        setState(() {
                          f['status'] = 'Cancelled';
                          f['cancelReason'] = reason;
                          f['cancelledAt'] = DateTime.now();
                        });
                        widget.onUpdate();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Follow-up cancelled'),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: Text(
                  'Cancel Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      color: AppTheme.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            f['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 20,
                      color: AppTheme.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  children: [
                    Text(
                      'ACTIONS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isFrozen) ...[
                      _FUActionRowDisabled(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.textMuted,
                        count: f['callsDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: AppTheme.textMuted,
                        count: f['messagesDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: AppTheme.textMuted,
                        count: f['whatsappDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.textMuted,
                        count: f['emailDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: AppTheme.textMuted,
                        count: f['videoDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: AppTheme.textMuted,
                        count: f['instagramDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: AppTheme.textMuted,
                        count: f['facebookDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: AppTheme.textMuted,
                        count: f['twitterDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: AppTheme.textMuted,
                        count: f['telegramDone'] as int? ?? 0,
                      ),
                    ] else ...[
                      _FUActionRow(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.success,
                        count: f['callsDone'] as int? ?? 0,
                        onTap: () =>
                            checkPreferenceAndLog('Calls', 'callsDone'),
                      ),
                      _FUActionRow(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: const Color(0xFF8B5CF6),
                        count: f['messagesDone'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'Message',
                          'messagesDone',
                          platform: 'SMS',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        count: f['whatsappDone'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'WhatsApp',
                          'whatsappDone',
                          platform: 'WhatsApp',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.primary,
                        count: f['emailDone'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'Email',
                          'emailDone',
                          platform: 'Email',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: const Color(0xFF0891B2),
                        count: f['videoDone'] as int? ?? 0,
                        onTap: () =>
                            checkPreferenceAndLog('Video Call', 'videoDone'),
                      ),
                      _FUActionRow(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: hasInstagram
                            ? const Color(0xFFE1306C)
                            : AppTheme.textMuted,
                        count: f['instagramDone'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Instagram',
                          hasInstagram,
                          'instagramDone',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: hasFacebook
                            ? const Color(0xFF1877F2)
                            : AppTheme.textMuted,
                        count: f['facebookDone'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Facebook',
                          hasFacebook,
                          'facebookDone',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: hasTwitter
                            ? const Color(0xFF1DA1F2)
                            : AppTheme.textMuted,
                        count: f['twitterDone'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'X (Twitter)',
                          hasTwitter,
                          'twitterDone',
                        ),
                      ),
                      _FUActionRow(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: hasTelegram
                            ? const Color(0xFF0088CC)
                            : AppTheme.textMuted,
                        count: f['telegramDone'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Telegram',
                          hasTelegram,
                          'telegramDone',
                        ),
                      ),
                      const Divider(height: 20),
                      _FUActionRow(
                        icon: Icons.check_circle_rounded,
                        label: 'Mark as Completed',
                        color: const Color(0xFF3D9970),
                        onTap: () {
                          Navigator.pop(context);
                          _markComplete(context);
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.cancel_outlined,
                        label: 'Cancel Follow-up',
                        color: AppTheme.error,
                        onTap: () {
                          Navigator.pop(context);
                          cancelFollowUp();
                        },
                      ),
                      const Divider(height: 20),
                    ],
                    _FUActionRow(
                      icon: Icons.info_outline_rounded,
                      label: 'See Details',
                      color: AppTheme.primary,
                      onTap: () {
                        Navigator.pop(context);
                        _showDetailsSheet(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _showThreeDots(BuildContext context) {
    final f = widget.followUp;
    final preferred = (f['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = f['linkedLead'] as String;

    // Get lead data to check social/contact fields
    final leadMap = leads_list.globalLeads.firstWhere(
      (m) => m['id'] == f['linkedLeadId'] || m['name'] == customerName,
      orElse: () => {},
    );
    final hasInstagram = (leadMap['instagram'] as String? ?? '').isNotEmpty;
    final hasFacebook = (leadMap['facebook'] as String? ?? '').isNotEmpty;
    final hasTwitter = (leadMap['twitter'] as String? ?? '').isNotEmpty;
    final hasTelegram = (leadMap['telegram'] as String? ?? '').isNotEmpty;

    void doAction(String action, String actionKey) {
      // Check preferred contact warning
      bool isPreferred = preferred.isEmpty || preferred.contains(action);
      if (!isPreferred) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Not Preferred',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              '$action is not in preferred contact for $customerName. Are you sure you want to send $action to $customerName?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
                  });
                  widget.onUpdate();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.warning,
                ),
                child: Text(
                  'Yes, Proceed',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
        });
        widget.onUpdate();
      }
    }

    void doSocialAction(String platform, bool hasData) {
      if (!hasData) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.warning,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'No Data Found',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            content: Text(
              'No $platform data found for $customerName. Please add their $platform handle/profile in the lead details first.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Each platform gets its own counter
        final actionKey = platform == 'X (Twitter)'
            ? 'twitterDone'
            : platform == 'Instagram'
            ? 'instagramDone'
            : platform == 'Facebook'
            ? 'facebookDone'
            : platform == 'Telegram'
            ? 'telegramDone'
            : 'messagesDone';
        setState(() {
          f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
        });
        widget.onUpdate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$platform message logged for $customerName'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          onTap: () => Future.microtask(() => _showDetailsSheet(context)),
          child: _MenuRow(
            icon: Icons.info_outline_rounded,
            label: 'Show Details',
            color: AppTheme.primary,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => Future.microtask(() => doAction('Calls', 'callsDone')),
          child: _MenuRow(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: AppTheme.success,
          ),
        ),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doAction('Messages', 'messagesDone')),
          child: _MenuRow(
            icon: Icons.message_rounded,
            label: 'Send Message',
            color: const Color(0xFF8B5CF6),
          ),
        ),
        PopupMenuItem(
          onTap: () => Future.microtask(
            () => doAction('WhatsApp Messages', 'whatsappDone'),
          ),
          child: _MenuRow(
            icon: Icons.chat_rounded,
            label: 'WhatsApp Message',
            color: const Color(0xFF25D366),
          ),
        ),
        PopupMenuItem(
          onTap: () => Future.microtask(() => doAction('Email', 'emailDone')),
          child: _MenuRow(
            icon: Icons.email_rounded,
            label: 'Email',
            color: AppTheme.primary,
          ),
        ),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doAction('Video Call', 'videoDone')),
          child: _MenuRow(
            icon: Icons.videocam_rounded,
            label: 'Video Call',
            color: const Color(0xFF0891B2),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doSocialAction('Instagram', hasInstagram)),
          child: _MenuRow(
            icon: Icons.camera_alt_rounded,
            label: hasInstagram ? 'Instagram' : 'Instagram (No data)',
            color: hasInstagram ? const Color(0xFFE1306C) : AppTheme.textMuted,
          ),
        ),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doSocialAction('Facebook', hasFacebook)),
          child: _MenuRow(
            icon: Icons.facebook_rounded,
            label: hasFacebook ? 'Facebook' : 'Facebook (No data)',
            color: hasFacebook ? const Color(0xFF1877F2) : AppTheme.textMuted,
          ),
        ),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doSocialAction('X (Twitter)', hasTwitter)),
          child: _MenuRow(
            icon: Icons.close_rounded,
            label: hasTwitter ? 'X (Twitter)' : 'X (Twitter) (No data)',
            color: hasTwitter ? const Color(0xFF000000) : AppTheme.textMuted,
          ),
        ),
        PopupMenuItem(
          onTap: () =>
              Future.microtask(() => doSocialAction('Telegram', hasTelegram)),
          child: _MenuRow(
            icon: Icons.send_rounded,
            label: hasTelegram ? 'Telegram' : 'Telegram (No data)',
            color: hasTelegram ? const Color(0xFF0088CC) : AppTheme.textMuted,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => Future.microtask(() => _markComplete(context)),
          child: _MenuRow(
            icon: Icons.check_circle_rounded,
            label: 'Mark Complete',
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }

  void _showDetailsSheet(BuildContext context) {
    final f = widget.followUp;
    final agent = _agentByName(f['assignedAgent'] as String);
    final tags = (f['tags'] as List?)?.cast<String>() ?? [];
    final upcoming = (f['upcomingFollowUps'] as List?)?.cast<String>() ?? [];
    final preferred = (f['preferredContact'] as List?)?.cast<String>() ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Follow-up Details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if ((f['linkedLeadId'] as String? ?? '').isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          final leadMap = leads_list.globalLeads.firstWhere(
                            (m) => m['id'] == f['linkedLeadId'],
                            orElse: () => {},
                          );
                          if (leadMap.isNotEmpty) {
                            context.push(
                              AppRoutes.leadDetailScreen,
                              extra: leads_list.LeadModel.fromMap(leadMap),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 14),
                        label: Text(
                          'Lead Details',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Customer contact
                    _SectionHeader(title: 'Contact'),
                    _DetailRow(
                      icon: Icons.person_rounded,
                      label: 'Customer',
                      value: f['linkedLead'] as String,
                    ),
                    if ((f['customerPhone'] as String? ?? '').isNotEmpty)
                      _DetailRow(
                        icon: Icons.phone_rounded,
                        label: 'Phone',
                        value: f['customerPhone'] as String,
                      ),
                    const SizedBox(height: 12),
                    // Agent details
                    _SectionHeader(title: 'Agent'),
                    _DetailRow(
                      icon: Icons.badge_rounded,
                      label: 'Agent',
                      value: agent.name,
                    ),
                    _DetailRow(
                      icon: Icons.work_rounded,
                      label: 'Role',
                      value: '${agent.role} · ${agent.id}',
                    ),
                    if (agent.phone.isNotEmpty)
                      _DetailRow(
                        icon: Icons.phone_rounded,
                        label: 'Agent Phone',
                        value: agent.phone,
                      ),
                    const SizedBox(height: 12),
                    // Follow-up info
                    _SectionHeader(title: 'Follow-up Info'),
                    _DetailRow(
                      icon: Icons.title_rounded,
                      label: 'Title',
                      value: f['title'] as String,
                    ),
                    _DetailRow(
                      icon: Icons.schedule_rounded,
                      label: 'Due Date',
                      value: _formatDueDateTime(f['dueDate'] as DateTime),
                    ),
                    if (f['createdAt'] != null)
                      _DetailRow(
                        icon: Icons.calendar_today_rounded,
                        label: 'Created',
                        value: _formatDueDateTime(f['createdAt'] as DateTime),
                      ),
                    _DetailRow(
                      icon: Icons.autorenew_rounded,
                      label: 'Frequency',
                      value: f['recurringFrequency'] as String,
                    ),
                    if (preferred.isNotEmpty)
                      _DetailRow(
                        icon: Icons.star_rounded,
                        label: 'Preferred',
                        value: preferred.join(', '),
                      ),
                    if ((f['notes'] as String? ?? '').isNotEmpty)
                      _DetailRow(
                        icon: Icons.notes_rounded,
                        label: 'Notes',
                        value: f['notes'] as String,
                      ),
                    if ((f['outcome'] as String? ?? '').isNotEmpty)
                      _DetailRow(
                        icon: Icons.flag_rounded,
                        label: 'Outcome',
                        value: f['outcome'] as String,
                      ),
                    const SizedBox(height: 12),
                    // Status tags (Completed On Time / Completed Late / status)
                    _SectionHeader(title: 'Status'),
                    _buildStatusTags(f),
                    const SizedBox(height: 12),
                    // Interest tags
                    if (tags.isNotEmpty) ...[
                      _SectionHeader(title: 'Interest Tags'),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: tags
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  t,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Contact counts
                    _SectionHeader(title: 'Contact Activity'),
                    _buildContactCounts(f),
                    const SizedBox(height: 16),
                    // ── Actions ──────────────────────────────────────────────
                    _SectionHeader(title: 'Actions'),
                    const SizedBox(height: 8),
                    if (f['status'] == 'Completed' ||
                        f['status'] == 'Cancelled') ...[
                      _FUActionRowDisabled(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.textMuted,
                        count: f['callsDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: AppTheme.textMuted,
                        count: f['messagesDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: AppTheme.textMuted,
                        count: f['whatsappDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.textMuted,
                        count: f['emailDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: AppTheme.textMuted,
                        count: f['videoDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: AppTheme.textMuted,
                        count: f['instagramDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: AppTheme.textMuted,
                        count: f['facebookDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: AppTheme.textMuted,
                        count: f['twitterDone'] as int? ?? 0,
                      ),
                      _FUActionRowDisabled(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: AppTheme.textMuted,
                        count: f['telegramDone'] as int? ?? 0,
                      ),
                    ] else ...[
                      _FUActionRow(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.success,
                        count: f['callsDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['callsDone'] = (f['callsDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: const Color(0xFF8B5CF6),
                        count: f['messagesDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['messagesDone'] =
                                (f['messagesDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        count: f['whatsappDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['whatsappDone'] =
                                (f['whatsappDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.primary,
                        count: f['emailDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['emailDone'] = (f['emailDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: const Color(0xFF0891B2),
                        count: f['videoDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['videoDone'] = (f['videoDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: const Color(0xFFE1306C),
                        count: f['instagramDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['instagramDone'] =
                                (f['instagramDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        count: f['facebookDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['facebookDone'] =
                                (f['facebookDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: const Color(0xFF1DA1F2),
                        count: f['twitterDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['twitterDone'] =
                                (f['twitterDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                      _FUActionRow(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: const Color(0xFF0088CC),
                        count: f['telegramDone'] as int? ?? 0,
                        onTap: () {
                          setState(() {
                            f['telegramDone'] =
                                (f['telegramDone'] as int? ?? 0) + 1;
                          });
                          widget.onUpdate();
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (f['status'] != 'Completed')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _markComplete(context);
                          },
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                          ),
                          label: Text(
                            'Mark Complete',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildStatusTags(Map<String, dynamic> f) {
    final status = f['status'] as String? ?? '';
    final dueDate = f['dueDate'] as DateTime;
    final completedAt = f['completedAt'] as DateTime?;
    final now = DateTime.now();

    final List<Widget> tags = [];

    if (status == 'Completed' && completedAt != null) {
      // Check if completed on time or late
      final isOnTime =
          completedAt.isBefore(dueDate) ||
          completedAt.isAtSameMomentAs(dueDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final h = completedAt.hour > 12
          ? completedAt.hour - 12
          : (completedAt.hour == 0 ? 12 : completedAt.hour);
      final ampm = completedAt.hour >= 12 ? 'PM' : 'AM';
      final completedStr =
          '${completedAt.day} ${months[completedAt.month - 1]} ${completedAt.year}, $h:${completedAt.minute.toString().padLeft(2, '0')} $ampm';

      tags.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isOnTime
                ? AppTheme.success.withAlpha(20)
                : AppTheme.warning.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isOnTime
                  ? AppTheme.success.withAlpha(60)
                  : AppTheme.warning.withAlpha(60),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnTime ? Icons.check_circle_rounded : Icons.schedule_rounded,
                size: 13,
                color: isOnTime ? AppTheme.success : AppTheme.warning,
              ),
              const SizedBox(width: 5),
              Text(
                isOnTime ? 'Completed on time' : 'Completed after due time',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOnTime ? AppTheme.success : AppTheme.warning,
                ),
              ),
            ],
          ),
        ),
      );
      tags.add(const SizedBox(height: 6));
      tags.add(
        Text(
          completedStr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      );
    } else if (status == 'Overdue' ||
        (dueDate.isBefore(now) && status != 'Completed')) {
      final diff = now.difference(dueDate);
      final overdueStr = diff.inDays > 0
          ? '${diff.inDays}d overdue'
          : '${diff.inHours}h overdue';
      tags.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.error.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.error.withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_rounded, size: 13, color: AppTheme.error),
              const SizedBox(width: 5),
              Text(
                'Due — $overdueStr',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      tags.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF0891B2).withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF0891B2).withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 13,
                color: Color(0xFF0891B2),
              ),
              const SizedBox(width: 5),
              Text(
                'Upcoming',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0891B2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: tags);
  }

  Widget _buildContactCounts(Map<String, dynamic> f) {
    final items = [
      (
        'Calls',
        Icons.phone_rounded,
        AppTheme.success,
        f['callsDone'] as int? ?? 0,
      ),
      (
        'Messages',
        Icons.message_rounded,
        const Color(0xFF8B5CF6),
        f['messagesDone'] as int? ?? 0,
      ),
      (
        'WhatsApp',
        Icons.chat_rounded,
        const Color(0xFF25D366),
        f['whatsappDone'] as int? ?? 0,
      ),
      (
        'Email',
        Icons.email_rounded,
        AppTheme.primary,
        f['emailDone'] as int? ?? 0,
      ),
      (
        'Video',
        Icons.videocam_rounded,
        const Color(0xFF0891B2),
        f['videoDone'] as int? ?? 0,
      ),
      (
        'Instagram',
        Icons.camera_alt_rounded,
        const Color(0xFFE1306C),
        f['instagramDone'] as int? ?? 0,
      ),
      (
        'Facebook',
        Icons.facebook_rounded,
        const Color(0xFF1877F2),
        f['facebookDone'] as int? ?? 0,
      ),
      (
        'X (Twitter)',
        Icons.close_rounded,
        const Color(0xFF000000),
        f['twitterDone'] as int? ?? 0,
      ),
      (
        'Telegram',
        Icons.send_rounded,
        const Color(0xFF0088CC),
        f['telegramDone'] as int? ?? 0,
      ),
    ];
    final nonZero = items.where((item) => item.$4 > 0).toList();
    if (nonZero.isEmpty) {
      return Text(
        'No contact activity yet',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: AppTheme.textMuted,
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: nonZero.map((item) {
        final (label, icon, color, count) = item;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                '$label: $count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _markComplete(BuildContext context) {
    final f = widget.followUp;
    final type = f['type'] as String? ?? '';

    // Gate: check if the required action has been performed at least once
    bool actionDone = false;
    String requiredAction = '';
    if (type == 'Calls') {
      actionDone = (f['callsDone'] as int? ?? 0) > 0;
      requiredAction = 'Call';
    } else if (type == 'Messages') {
      actionDone = (f['messagesDone'] as int? ?? 0) > 0;
      requiredAction = 'Send Message';
    } else if (type == 'WhatsApp Messages') {
      actionDone = (f['whatsappDone'] as int? ?? 0) > 0;
      requiredAction = 'Send WhatsApp Message';
    } else if (type == 'Email') {
      actionDone = (f['emailDone'] as int? ?? 0) > 0;
      requiredAction = 'Send Email';
    } else if (type == 'Video Call') {
      actionDone = (f['videoDone'] as int? ?? 0) > 0;
      requiredAction = 'Start Video Call';
    } else {
      actionDone = true; // unknown type — allow
    }

    if (!actionDone) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.block_rounded, color: AppTheme.error, size: 22),
              const SizedBox(width: 8),
              Text(
                'Action Required',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Text(
            'You must "$requiredAction" before marking this follow-up as completed. Please perform the scheduled action first using the action menu.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Got it',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      f['status'] = 'Completed';
      f['completedAt'] = DateTime.now();
    });
    // Mark linked reminder as completed too (interconnected logic)
    final fuId = f['id'] as String? ?? '';
    if (fuId.isNotEmpty) {
      for (final rem in globalReminderMaps) {
        if (rem['linkedFollowUpId'] == fuId) {
          rem['isCompleted'] = true;
          rem['status'] = 'Completed';
        }
      }
    }
    widget.onUpdate();
    // Show reschedule sheet — non-dismissible until filled
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _RescheduleSheetWidget(
        followUp: f,
        onReschedule: (newFu) {
          globalFollowUpMaps.add(newFu);
          widget.onUpdate();
        },
        ),
      ),
    );
  }

  String _statusLabel(Map<String, dynamic> f) {
    final status = f['status'] as String? ?? '';
    final dueDate = f['dueDate'] as DateTime;
    final now = DateTime.now();

    if (status == 'Completed') return 'Completed';

    // Determine Due vs Upcoming based on date
    if (dueDate.isBefore(now)) {
      return 'Due'; // Past date, no action taken
    } else {
      return 'Upcoming'; // Future date
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.followUp;
    final dueDate = f['dueDate'] as DateTime;
    final now = DateTime.now();
    // Compute correct status: Due (past, no action) / Upcoming (future) / Completed
    final computedStatus = _statusLabel(f);
    final isCompleted = computedStatus == 'Completed';
    final isOverdue =
        computedStatus == 'Due' && dueDate.isBefore(now) && !isCompleted;
    final statusColor = _statusColor(computedStatus);
    final typeColor = _typeColor(f['type'] as String);
    final tags = (f['tags'] as List?)?.cast<String>() ?? [];
    final agent = _agentByName(f['assignedAgent'] as String);
    final freq = f['recurringFrequency'] as String? ?? '';
    final callsDone = f['callsDone'] as int? ?? 0;
    final msgDone = f['messagesDone'] as int? ?? 0;
    final waDone = f['whatsappDone'] as int? ?? 0;
    final emailDone = f['emailDone'] as int? ?? 0;
    final videoDone = f['videoDone'] as int? ?? 0;
    final instagramDone = f['instagramDone'] as int? ?? 0;
    final facebookDone = f['facebookDone'] as int? ?? 0;
    final twitterDone = f['twitterDone'] as int? ?? 0;
    final telegramDone = f['telegramDone'] as int? ?? 0;
    final hasActivity =
        callsDone +
            msgDone +
            waDone +
            emailDone +
            videoDone +
            instagramDone +
            facebookDone +
            twitterDone +
            telegramDone >
        0;
    final hoursOverdue = isOverdue ? now.difference(dueDate).inHours : 0;
    final isEscalated = hoursOverdue > 24;
    final isCritical = hoursOverdue > 48;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _showActionsBottomSheet(context, f),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCritical
                        ? AppTheme.error
                        : isOverdue
                        ? AppTheme.error.withAlpha(80)
                        : AppTheme.surface200,
                    width: isCritical || isOverdue ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (isOverdue)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isCritical
                              ? AppTheme.error.withAlpha(30)
                              : AppTheme.error.withAlpha(20),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCritical
                                  ? Icons.error_rounded
                                  : Icons.warning_rounded,
                              size: 13,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isCritical
                                  ? '⚠️ CRITICAL — ${hoursOverdue}h overdue — Escalate now!'
                                  : isEscalated
                                  ? '🔴 ESCALATED — ${hoursOverdue}h overdue'
                                  : 'DUE — ${_formatDue(dueDate)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: typeColor.withAlpha(31),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _typeIcon(f['type'] as String),
                                  color: typeColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      f['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline_rounded,
                                          size: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            f['linkedLead'] as String,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: AppTheme.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((f['customerPhone'] as String? ?? '')
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_rounded,
                                            size: 11,
                                            color: AppTheme.textMuted,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              f['customerPhone'] as String,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 10,
                                                    color: AppTheme.textMuted,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Use computed status label
                              _StatusBadge(
                                label: computedStatus,
                                color: statusColor,
                              ),
                              // No 3-dots — tap card to see all details + actions
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: agent.color.withAlpha(40),
                                child: Text(
                                  agent.initials,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: agent.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  freq.isNotEmpty
                                      ? '${agent.name} · $freq'
                                      : agent.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Due date/time + due status row
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: isOverdue
                                    ? AppTheme.error
                                    : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDueDateTime(dueDate),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: isOverdue
                                      ? AppTheme.error
                                      : AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isOverdue
                                      ? AppTheme.error.withAlpha(20)
                                      : computedStatus == 'Upcoming'
                                      ? const Color(0xFF0891B2).withAlpha(20)
                                      : computedStatus == 'Completed'
                                      ? AppTheme.success.withAlpha(20)
                                      : AppTheme.primary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _formatDue(dueDate),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isOverdue
                                        ? AppTheme.error
                                        : computedStatus == 'Upcoming'
                                        ? const Color(0xFF0891B2)
                                        : computedStatus == 'Completed'
                                        ? AppTheme.success
                                        : AppTheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _TypeBadge(
                                label: f['type'] as String,
                                color: typeColor,
                              ),
                              const SizedBox(width: 8),
                              _PriorityBadge(priority: f['priority'] as String),
                              if (freq.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                _InfoChip(
                                  icon: Icons.autorenew_rounded,
                                  label: freq,
                                  color: const Color(0xFF8B5CF6),
                                ),
                              ],
                            ],
                          ),
                          if (tags.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                // Existing customer tag
                                if (f['isExistingCustomer'] == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.success.withAlpha(20),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppTheme.success.withAlpha(60),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified_rounded,
                                          size: 10,
                                          color: AppTheme.success,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          'Existing Customer',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            color: AppTheme.success,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ...tags.map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      t,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          // Status tag on card
                          const SizedBox(height: 8),
                          _buildCardStatusTag(f),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Card tap opens bottom sheet with actions + See Details
          ],
        ),
      ),
    );
  }

  Widget _buildCardStatusTag(Map<String, dynamic> f) {
    final status = f['status'] as String? ?? '';
    final dueDate = f['dueDate'] as DateTime;
    final completedAt = f['completedAt'] as DateTime?;
    final cancelReason = f['cancelReason'] as String? ?? '';

    if (status == 'Completed' && completedAt != null) {
      final isOnTime =
          completedAt.isBefore(dueDate) ||
          completedAt.isAtSameMomentAs(dueDate);
      final label = isOnTime ? 'Completed On Time' : 'Completed After Due';
      final color = isOnTime ? AppTheme.success : AppTheme.warning;
      final icon = isOnTime
          ? Icons.check_circle_rounded
          : Icons.schedule_rounded;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
    } else if (status == 'Cancelled') {
      final now = DateTime.now();
      final isAfterDue = dueDate.isBefore(now);
      final label = isAfterDue ? 'Cancelled After Due' : 'Cancelled';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.error.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_rounded, size: 11, color: AppTheme.error),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
          if (cancelReason.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Reason: $cancelReason',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.error,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInlineActionsPanel(
    BuildContext context,
    Map<String, dynamic> f,
  ) {
    final preferred = (f['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = f['linkedLead'] as String;
    final leadMap = leads_list.globalLeads.firstWhere(
      (m) => m['id'] == f['linkedLeadId'] || m['name'] == customerName,
      orElse: () => {},
    );
    final hasInstagram = (leadMap['instagram'] as String? ?? '').isNotEmpty;
    final hasFacebook = (leadMap['facebook'] as String? ?? '').isNotEmpty;
    final hasTwitter = (leadMap['twitter'] as String? ?? '').isNotEmpty;
    final hasTelegram = (leadMap['telegram'] as String? ?? '').isNotEmpty;

    void doAction(String action, String actionKey) {
      bool isPreferred = preferred.isEmpty || preferred.contains(action);
      if (!isPreferred) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Not Preferred',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              '$action is not preferred for $customerName. Proceed anyway?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
                  });
                  widget.onUpdate();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.warning,
                ),
                child: Text(
                  'Proceed',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
        });
        widget.onUpdate();
      }
    }

    void doSocialAction(String platform, bool hasData, String actionKey) {
      if (!hasData) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'No Data Found',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'No $platform data found for $customerName.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          f[actionKey] = (f[actionKey] as int? ?? 0) + 1;
        });
        widget.onUpdate();
      }
    }

    void cancelFollowUp() {
      final reasonCtrl = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (ctx, setS) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.cancel_rounded, color: AppTheme.error, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Cancel Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a reason for cancellation:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  onChanged: (_) => setS(() {}),
                  decoration: InputDecoration(
                    hintText: 'e.g. Customer not interested...',
                    filled: true,
                    fillColor: AppTheme.surface100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Back',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: reasonCtrl.text.trim().isEmpty
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        final reason = reasonCtrl.text.trim();
                        final idx = globalFollowUpMaps.indexWhere(
                          (m) => m['id'] == f['id'],
                        );
                        if (idx >= 0) {
                          globalFollowUpMaps[idx]['status'] = 'Cancelled';
                          globalFollowUpMaps[idx]['cancelReason'] = reason;
                        }
                        setState(() {
                          f['status'] = 'Cancelled';
                          f['cancelReason'] = reason;
                          _actionsExpanded = false;
                        });
                        widget.onUpdate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Follow-up cancelled'),
                            backgroundColor: AppTheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: Text(
                  'Cancel Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppTheme.surface100,
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionBtn(
                icon: Icons.phone_rounded,
                label: 'Call',
                color: AppTheme.success,
                onTap: () => doAction('Calls', 'callsDone'),
              ),
              _ActionBtn(
                icon: Icons.message_rounded,
                label: 'Message',
                color: const Color(0xFF8B5CF6),
                onTap: () => doAction('Messages', 'messagesDone'),
              ),
              _ActionBtn(
                icon: Icons.chat_rounded,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => doAction('WhatsApp Messages', 'whatsappDone'),
              ),
              _ActionBtn(
                icon: Icons.email_rounded,
                label: 'Email',
                color: AppTheme.primary,
                onTap: () => doAction('Email', 'emailDone'),
              ),
              _ActionBtn(
                icon: Icons.videocam_rounded,
                label: 'Video Call',
                color: const Color(0xFF0891B2),
                onTap: () => doAction('Video Call', 'videoDone'),
              ),
              _ActionBtn(
                icon: Icons.camera_alt_rounded,
                label: 'Instagram',
                color: hasInstagram
                    ? const Color(0xFFE1306C)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Instagram', hasInstagram, 'instagramDone'),
              ),
              _ActionBtn(
                icon: Icons.facebook_rounded,
                label: 'Facebook',
                color: hasFacebook
                    ? const Color(0xFF1877F2)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Facebook', hasFacebook, 'facebookDone'),
              ),
              _ActionBtn(
                icon: Icons.close_rounded,
                label: 'X (Twitter)',
                color: hasTwitter
                    ? const Color(0xFF000000)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('X (Twitter)', hasTwitter, 'twitterDone'),
              ),
              _ActionBtn(
                icon: Icons.send_rounded,
                label: 'Telegram',
                color: hasTelegram
                    ? const Color(0xFF0088CC)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Telegram', hasTelegram, 'telegramDone'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (f['status'] != 'Completed' && f['status'] != 'Cancelled')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _markComplete(context),
                icon: const Icon(Icons.check_circle_rounded, size: 16),
                label: Text(
                  'Mark Complete',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D9970),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (f['status'] != 'Completed' && f['status'] != 'Cancelled') ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: cancelFollowUp,
                icon: const Icon(Icons.cancel_outlined, size: 16),
                label: Text(
                  'Cancel Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Reschedule Sheet ─────────────────────────────────────────────────────────

class _RescheduleSheetWidget extends StatefulWidget {
  final Map<String, dynamic> followUp;
  final void Function(Map<String, dynamic>) onReschedule;
  const _RescheduleSheetWidget({
    required this.followUp,
    required this.onReschedule,
  });

  @override
  State<_RescheduleSheetWidget> createState() => _RescheduleSheetWidgetState();
}

class _RescheduleSheetWidgetState extends State<_RescheduleSheetWidget> {
  DateTime? _newDate;
  TimeOfDay? _newTime;
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surface200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Follow-up Completed!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Schedule the next follow-up to keep track of this lead.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Next Follow-up Date & Time *',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(
                            const Duration(days: 1),
                          ),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (d != null) setState(() => _newDate = d);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _newDate != null
                                ? AppTheme.warning.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _newDate != null
                                  ? _formatDate(_newDate!)
                                  : 'Select date',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _newDate != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (t != null) setState(() => _newTime = t);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _newTime != null
                                ? AppTheme.warning.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _newTime != null
                                  ? _newTime!.format(context)
                                  : 'Select time',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _newTime != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Notes (optional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add notes for next follow-up...',
                  filled: true,
                  fillColor: AppTheme.surface100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _newDate == null
                      ? null
                      : () {
                          final f = widget.followUp;
                          final date = _newDate!;
                          final time = _newTime ?? TimeOfDay.now();
                          final dueDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          final newFu = Map<String, dynamic>.from(f)
                            ..['id'] =
                                'fu-${DateTime.now().millisecondsSinceEpoch}'
                            ..['status'] = 'Upcoming'
                            ..['dueDate'] = dueDateTime
                            ..['isOverdue'] = false
                            ..['completedAt'] = null
                            ..['createdAt'] = DateTime.now()
                            ..['notes'] = _notesCtrl.text.trim().isNotEmpty
                                ? _notesCtrl.text.trim()
                                : f['notes']
                            ..['outcome'] = '';
                          Navigator.pop(context);
                          widget.onReschedule(newFu);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warning,
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Schedule Next Follow-up',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: _newDate != null
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Skip for now',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── New Follow-Up Sheet ──────────────────────────────────────────────────────

class _NewFollowUpSheet extends StatefulWidget {
  final List<_AgentInfo> agents;
  final void Function(Map<String, dynamic>) onSave;
  const _NewFollowUpSheet({required this.agents, required this.onSave});

  @override
  State<_NewFollowUpSheet> createState() => _NewFollowUpSheetState();
}

class _NewFollowUpSheetState extends State<_NewFollowUpSheet> {
  final _titleCtrl = TextEditingController();
  final _leadSearchCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _type = 'Calls';
  String _priority = 'Medium';
  String _frequency = 'Weekly';
  final List<String> _preferredContact = ['Calls'];
  _AgentInfo? _selectedAgent;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  bool _addToReminders = true; // Default ON

  // Alarm / reminder fields (shown when _addToReminders is true)
  bool _hasAlarm = false;
  DateTime? _alarmDate;
  TimeOfDay? _alarmTime;
  String _remindBefore = '15 minutes';
  String _reminderRepeat = 'None';
  final List<String> _notifyVia = ['Push', 'In-App'];

  // Lead picker state (same as sessions)
  Map<String, dynamic>? _selectedLead;
  String _leadSearchQuery = '';
  bool _showLeadSearch = false;

  static const _types = [
    'Calls',
    'Video Call',
    'WhatsApp Messages',
    'Email',
    'Messages',
  ];
  static const _priorities = ['High', 'Medium', 'Low'];
  static const _frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Custom',
  ];
  static const _contactModes = [
    'Calls',
    'Messages',
    'WhatsApp Messages',
    'Email',
    'Video Call',
  ];

  bool get _canSave =>
      _titleCtrl.text.trim().isNotEmpty &&
      _selectedLead != null &&
      _selectedAgent != null &&
      _dueDate != null &&
      _preferredContact.isNotEmpty;

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  List<Map<String, dynamic>> get _filteredLeads {
    final q = _leadSearchQuery.toLowerCase();
    return leads_list.globalLeads.where((m) {
      final name = (m['name'] as String? ?? '').toLowerCase();
      final phone = (m['phone'] as String? ?? '').toLowerCase();
      return q.isEmpty || name.contains(q) || phone.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _leadSearchCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surface200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'New Follow-up',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.surface100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildField(
                'Title *',
                _titleCtrl,
                'e.g. Follow up with Rahul Mehta',
              ),
              const SizedBox(height: 12),
              // Customer picker from leads (same as sessions)
              _buildLabel('Customer *'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => setState(() => _showLeadSearch = !_showLeadSearch),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedLead != null
                        ? AppTheme.primaryContainer
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedLead != null
                          ? AppTheme.primary.withAlpha(60)
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 16,
                        color: _selectedLead != null
                            ? AppTheme.primary
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _selectedLead != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedLead!['name'] as String? ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  if ((_selectedLead!['phone'] as String? ?? '')
                                      .isNotEmpty)
                                    Text(
                                      _selectedLead!['phone'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                ],
                              )
                            : Text(
                                'Search and select customer from leads',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                      ),
                      if (_selectedLead != null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedLead = null),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                        )
                      else
                        Icon(
                          _showLeadSearch
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          size: 18,
                          color: AppTheme.textMuted,
                        ),
                    ],
                  ),
                ),
              ),
              if (_showLeadSearch) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _leadSearchCtrl,
                  autofocus: true,
                  onChanged: (v) => setState(() => _leadSearchQuery = v),
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 16),
                    filled: true,
                    fillColor: AppTheme.surface100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.surface200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: _filteredLeads.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No leads found',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _filteredLeads.length,
                          itemBuilder: (_, i) {
                            final lead = _filteredLeads[i];
                            return InkWell(
                              onTap: () {
                                final name = lead['name'] as String? ?? '';
                                final id = lead['id'] as String? ?? '';
                                // Check if customer already in active follow-up or session
                                final inFollowUp = globalFollowUpMaps.any((f) {
                                  final fStatus = f['status'] as String? ?? '';
                                  if (fStatus == 'Completed' ||
                                      fStatus == 'Cancelled') {
                                    return false;
                                  }
                                  return f['linkedLead'] == name ||
                                      (id.isNotEmpty &&
                                          f['linkedLeadId'] == id);
                                });
                                final inSession = globalSessionMaps.any((s) {
                                  final sStatus = s['status'] as String? ?? '';
                                  if (sStatus == 'Completed' ||
                                      sStatus == 'Cancelled') {
                                    return false;
                                  }
                                  return s['linkedLead'] == name ||
                                      (id.isNotEmpty &&
                                          s['linkedLeadId'] == id);
                                });
                                if (inFollowUp || inSession) {
                                  final where = inFollowUp
                                      ? 'Follow-up'
                                      : 'Session';
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: AppTheme.warning,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Already in $where',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        '$name is already assigned in an active $where. Do you want to reschedule to this follow-up or continue that $where?',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Go to that screen
                                            if (inFollowUp) {
                                              Navigator.pop(context);
                                              context.go(
                                                AppRoutes.followUpsScreen,
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              context.go(
                                                AppRoutes.sessionsScreen,
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Go to $where',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppTheme.primary,
                                            ),
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              _selectedLead = lead;
                                              _showLeadSearch = false;
                                              _leadSearchQuery = '';
                                              _leadSearchCtrl.clear();
                                            });
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: AppTheme.warning,
                                          ),
                                          child: Text(
                                            'Continue',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _selectedLead = lead;
                                    _showLeadSearch = false;
                                    _leadSearchQuery = '';
                                    _leadSearchCtrl.clear();
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.surface200,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: AppTheme.primary
                                          .withAlpha(30),
                                      child: Text(
                                        (lead['name'] as String? ?? '?')[0],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lead['name'] as String? ?? '',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if ((lead['phone'] as String? ?? '')
                                              .isNotEmpty)
                                            Text(
                                              lead['phone'] as String,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.textSecondary,
                                                  ),
                                            ),
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
              ],
              const SizedBox(height: 12),
              // Type
              _buildLabel('Follow-up Type *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final sel = _type == t;
                  return GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.warning.withAlpha(30)
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppTheme.warning : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel
                              ? AppTheme.warning
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Priority
              _buildLabel('Priority'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _priorities.map((p) {
                  final sel = _priority == p;
                  final color = p == 'High'
                      ? AppTheme.error
                      : p == 'Medium'
                      ? AppTheme.warning
                      : AppTheme.success;
                  return GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? color.withAlpha(30) : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? color : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        p,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel ? color : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Frequency
              _buildLabel('Frequency *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _frequencies.map((f) {
                  final sel = _frequency == f;
                  return GestureDetector(
                    onTap: () => setState(() => _frequency = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryContainer
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppTheme.primary : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Preferred Contact
              _buildLabel('Preferred Mode of Contact *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _contactModes.map((m) {
                  final sel = _preferredContact.contains(m);
                  return GestureDetector(
                    onTap: () => setState(
                      () => sel
                          ? _preferredContact.remove(m)
                          : _preferredContact.add(m),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryContainer
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppTheme.primary : AppTheme.surface200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (sel) ...[
                            const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            m,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Assign Agent
              _buildLabel('Assign Agent *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.agents.map((a) {
                  final sel = _selectedAgent?.name == a.name;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAgent = a),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? a.color.withAlpha(30)
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? a.color : AppTheme.surface200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: a.color.withAlpha(40),
                            child: Text(
                              a.initials,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: a.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            a.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel ? a.color : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Due Date & Time
              _buildLabel('Due Date & Time *'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (d != null) setState(() => _dueDate = d);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _dueDate != null
                                ? AppTheme.warning.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _dueDate != null
                                  ? _formatDate(_dueDate!)
                                  : 'Select date',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _dueDate != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (t != null) setState(() => _dueTime = t);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _dueTime != null
                                ? AppTheme.warning.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _dueTime != null
                                  ? _dueTime!.format(context)
                                  : 'Select time',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _dueTime != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildField(
                'Notes (optional)',
                _notesCtrl,
                'Add notes...',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Add to Reminders toggle with full alarm logic (same as schedule new session)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _addToReminders
                      ? AppTheme.primary.withAlpha(15)
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _addToReminders
                        ? AppTheme.primary.withAlpha(80)
                        : AppTheme.surface200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.alarm_rounded,
                          size: 18,
                          color: _addToReminders
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add to Reminders',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _addToReminders
                                      ? AppTheme.primary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                _addToReminders
                                    ? 'A reminder will be created automatically'
                                    : 'No reminder will be created',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: _addToReminders
                                      ? AppTheme.primary
                                      : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _addToReminders,
                          onChanged: (v) => setState(() => _addToReminders = v),
                          activeThumbColor: AppTheme.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    if (_addToReminders) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      // Set Alarm toggle
                      Row(
                        children: [
                          Icon(
                            Icons.alarm_on_rounded,
                            size: 16,
                            color: _hasAlarm
                                ? const Color(0xFF0891B2)
                                : AppTheme.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Set Alarm',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _hasAlarm
                                    ? const Color(0xFF0891B2)
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          Switch(
                            value: _hasAlarm,
                            onChanged: (v) {
                              setState(() {
                                _hasAlarm = v;
                                if (v && _dueDate != null) {
                                  _alarmDate = _dueDate;
                                  _alarmTime = _dueTime;
                                }
                              });
                            },
                            activeThumbColor: const Color(0xFF0891B2),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                      if (_hasAlarm) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _alarmDate ??
                                        _dueDate ??
                                        DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  );
                                  if (d != null) setState(() => _alarmDate = d);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _alarmDate != null
                                          ? const Color(
                                              0xFF0891B2,
                                            ).withAlpha(60)
                                          : AppTheme.surface200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 13,
                                        color: Color(0xFF0891B2),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _alarmDate != null
                                            ? '${_alarmDate!.day}/${_alarmDate!.month}/${_alarmDate!.year}'
                                            : 'Alarm date',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: _alarmDate != null
                                              ? AppTheme.textPrimary
                                              : AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final t = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _alarmTime ??
                                        _dueTime ??
                                        TimeOfDay.now(),
                                  );
                                  if (t != null) setState(() => _alarmTime = t);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _alarmTime != null
                                          ? const Color(
                                              0xFF0891B2,
                                            ).withAlpha(60)
                                          : AppTheme.surface200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 13,
                                        color: Color(0xFF0891B2),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _alarmTime != null
                                            ? _alarmTime!.format(context)
                                            : 'Alarm time',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: _alarmTime != null
                                              ? AppTheme.textPrimary
                                              : AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      // Remind Me Before
                      Text(
                        'Remind Me Before',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            [
                              '5 minutes',
                              '15 minutes',
                              '30 minutes',
                              '1 hour',
                              '2 hours',
                              '1 day',
                            ].map((o) {
                              final sel = _remindBefore == o;
                              return GestureDetector(
                                onTap: () => setState(() => _remindBefore = o),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? AppTheme.primaryContainer
                                        : AppTheme.surface100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: sel
                                          ? AppTheme.primary
                                          : AppTheme.surface200,
                                    ),
                                  ),
                                  child: Text(
                                    o,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: sel
                                          ? AppTheme.primary
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      // Repeat
                      Text(
                        'Repeat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: ['None', 'Daily', 'Weekly', 'Monthly'].map((
                          o,
                        ) {
                          final sel = _reminderRepeat == o;
                          return GestureDetector(
                            onTap: () => setState(() => _reminderRepeat = o),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppTheme.primaryContainer
                                    : AppTheme.surface100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: sel
                                      ? AppTheme.primary
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Text(
                                o,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: sel
                                      ? AppTheme.primary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      // Notify Via
                      Text(
                        'Notify Via',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: ['Push', 'In-App', 'WhatsApp', 'Email'].map((
                          o,
                        ) {
                          final sel = _notifyVia.contains(o);
                          return GestureDetector(
                            onTap: () => setState(
                              () => sel
                                  ? _notifyVia.remove(o)
                                  : _notifyVia.add(o),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppTheme.primaryContainer
                                    : AppTheme.surface100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: sel
                                      ? AppTheme.primary
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (sel) ...[
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 11,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 3),
                                  ],
                                  Text(
                                    o,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: sel
                                          ? AppTheme.primary
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave
                      ? () {
                          final date = _dueDate!;
                          final time = _dueTime ?? TimeOfDay.now();
                          final dueDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          final lead = _selectedLead!;
                          final customerName = lead['name'] as String? ?? '';
                          final customerId = lead['id'] as String? ?? '';
                          final customerPhone = lead['phone'] as String? ?? '';
                          final newFu = {
                            'id': 'fu-${DateTime.now().millisecondsSinceEpoch}',
                            'title': _titleCtrl.text.trim(),
                            'type': _type,
                            'status': 'Upcoming',
                            'priority': _priority,
                            'dueDate': dueDateTime,
                            'assignedAgent': _selectedAgent!.name,
                            'agentInitials': _selectedAgent!.initials,
                            'linkedLead': customerName,
                            'linkedLeadId': customerId,
                            'customerPhone': customerPhone,
                            'notes': _notesCtrl.text.trim(),
                            'outcome': '',
                            'isRecurring': _frequency != 'Custom',
                            'recurringFrequency': _frequency,
                            'isOverdue': false,
                            'completedAt': null,
                            'createdAt': DateTime.now(),
                            'tags': <String>[],
                            'preferredContact': List<String>.from(
                              _preferredContact,
                            ),
                            'contactMethod': _preferredContact.isNotEmpty
                                ? _preferredContact.first
                                : _type,
                            'reminderBefore': '1 hour',
                            'isExistingCustomer':
                                lead['isExistingCustomer'] ?? false,
                            'callsDone': 0,
                            'messagesDone': 0,
                            'whatsappDone': 0,
                            'emailDone': 0,
                            'videoDone': 0,
                            'twitterDone': 0,
                            'upcomingFollowUps': <String>[],
                          };
                          // Auto-create reminder if toggle is on
                          final fuId =
                              'fu-${DateTime.now().millisecondsSinceEpoch}';
                          if (_addToReminders) {
                            DateTime? alarmDt;
                            if (_hasAlarm && _alarmDate != null) {
                              final at = _alarmTime;
                              alarmDt = at != null
                                  ? DateTime(
                                      _alarmDate!.year,
                                      _alarmDate!.month,
                                      _alarmDate!.day,
                                      at.hour,
                                      at.minute,
                                    )
                                  : DateTime(
                                      _alarmDate!.year,
                                      _alarmDate!.month,
                                      _alarmDate!.day,
                                      9,
                                      0,
                                    );
                            }
                            globalReminderMaps.insert(0, {
                              'id':
                                  'rem-fu-${DateTime.now().millisecondsSinceEpoch}',
                              'title':
                                  '$customerName — Follow-up: ${_titleCtrl.text.trim()}',
                              'type': 'Follow-up',
                              'reminderTag': 'Follow-up',
                              'status': 'Active',
                              'priority': _priority,
                              'dateTime': dueDateTime,
                              'alarmDateTime': alarmDt,
                              'hasAlarm': _hasAlarm && alarmDt != null,
                              'repeatFrequency': _reminderRepeat,
                              'remindBefore': _remindBefore,
                              'notifyVia': List<String>.from(_notifyVia),
                              'linkedLead': customerName,
                              'linkedLeadId': customerId,
                              'linkedLeadPhone': customerPhone,
                              'linkedLeadEmail': lead['email'] as String? ?? '',
                              'assignedHost': _selectedAgent!.name,
                              'assignedHostInitials': _selectedAgent!.initials,
                              'snoozed': false,
                              'snoozeUntil': null,
                              'snoozeCount': 0,
                              'notes': _notesCtrl.text.trim(),
                              'createdAt': DateTime.now(),
                              'isCompleted': false,
                              'linkedFollowUpId': fuId,
                              'linkedSessionId': null,
                            });
                          }
                          Navigator.pop(context);
                          widget.onSave(newFu);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warning,
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Follow-up',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: _canSave ? Colors.white : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppTheme.surface100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

// ─── Follow-Up Templates Sheet ────────────────────────────────────────────────

class _FollowUpTemplatesSheet extends StatelessWidget {
  final void Function(Map<String, dynamic>) onUseTemplate;
  const _FollowUpTemplatesSheet({required this.onUseTemplate});

  List<Map<String, dynamic>> get _templates => [
    {
      'name': 'Quick Call Check-in',
      'icon': Icons.phone_rounded,
      'color': AppTheme.success,
      'type': 'Calls',
      'priority': 'Medium',
      'frequency': 'Weekly',
      'preferredContact': ['Calls'],
      'titlePrefix': 'Weekly call with',
    },
    {
      'name': 'Policy Renewal Reminder',
      'icon': Icons.autorenew_rounded,
      'color': AppTheme.warning,
      'type': 'Email',
      'priority': 'High',
      'frequency': 'Yearly',
      'preferredContact': ['Email', 'Calls'],
      'titlePrefix': 'Policy renewal for',
    },
    {
      'name': 'Post-Session Follow-up',
      'icon': Icons.videocam_rounded,
      'color': const Color(0xFF0891B2),
      'type': 'Calls',
      'priority': 'High',
      'frequency': 'Custom',
      'preferredContact': ['Calls', 'WhatsApp Messages'],
      'titlePrefix': 'Post-session follow-up with',
    },
    {
      'name': 'WhatsApp Check-in',
      'icon': Icons.chat_rounded,
      'color': const Color(0xFF25D366),
      'type': 'WhatsApp Messages',
      'priority': 'Low',
      'frequency': 'Monthly',
      'preferredContact': ['WhatsApp Messages'],
      'titlePrefix': 'Monthly WhatsApp check-in with',
    },
    {
      'name': 'Proposal Follow-up',
      'icon': Icons.description_rounded,
      'color': const Color(0xFF8B5CF6),
      'type': 'Calls',
      'priority': 'High',
      'frequency': 'Weekly',
      'preferredContact': ['Calls', 'Email'],
      'titlePrefix': 'Proposal follow-up with',
    },
    {
      'name': 'Birthday Greeting',
      'icon': Icons.cake_rounded,
      'color': AppTheme.error,
      'type': 'WhatsApp Messages',
      'priority': 'Low',
      'frequency': 'Yearly',
      'preferredContact': ['WhatsApp Messages'],
      'titlePrefix': 'Birthday greeting for',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Follow-up Templates',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.surface100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a template to create a follow-up instantly',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ..._templates.map(
            (t) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
                final newFu = {
                  'id': 'fu-tpl-${DateTime.now().millisecondsSinceEpoch}',
                  'title': '${t['titlePrefix']} Customer',
                  'type': t['type'] as String,
                  'status': 'Upcoming',
                  'priority': t['priority'] as String,
                  'dueDate': DateTime.now().add(const Duration(days: 1)),
                  'assignedAgent': 'Priya Sharma',
                  'agentInitials': 'PS',
                  'linkedLead': 'Customer',
                  'linkedLeadId': '',
                  'customerPhone': '',
                  'notes': 'Created from template: ${t['name']}',
                  'outcome': '',
                  'isRecurring': t['frequency'] != 'Custom',
                  'recurringFrequency': t['frequency'] as String,
                  'isOverdue': false,
                  'completedAt': null,
                  'createdAt': DateTime.now(),
                  'tags': <String>[],
                  'preferredContact': List<String>.from(
                    t['preferredContact'] as List,
                  ),
                  'contactMethod': (t['preferredContact'] as List).first,
                  'reminderBefore': '1 hour',
                  'isExistingCustomer': false,
                  'callsDone': 0,
                  'messagesDone': 0,
                  'whatsappDone': 0,
                  'emailDone': 0,
                  'videoDone': 0,
                  'upcomingFollowUps': <String>[],
                };
                onUseTemplate(newFu);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (t['color'] as Color).withAlpha(10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (t['color'] as Color).withAlpha(40),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (t['color'] as Color).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        t['icon'] as IconData,
                        color: t['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['name'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${t['type']} · ${t['frequency']} · ${t['priority']} priority',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: t['color'] as Color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bulk Action Button ───────────────────────────────────────────────────────

class _BulkBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _BulkBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action Button Widget ─────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Follow-up Action Row (full-width with inline count) ──────────────────────

class _FUActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int count;
  const _FUActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (count > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(60)),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: color.withAlpha(150),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Follow-up Disabled Action Row ───────────────────────────────────────────

class _FUActionRowDisabled extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;
  const _FUActionRowDisabled({
    required this.icon,
    required this.label,
    required this.color,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          if (count > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 10, color: AppTheme.textMuted),
                  const SizedBox(width: 3),
                  Text(
                    '$count',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Icon(Icons.lock_rounded, size: 14, color: color),
          ],
        ],
      ),
    );
  }
}

// ─── Follow-up Template Picker Sheet ─────────────────────────────────────────

class _FUTemplatePickerSheet extends StatefulWidget {
  final String actionLabel;
  final List<Map<String, dynamic>> templates;
  final String customerName;
  final bool isWhatsApp;
  final void Function(String templateBody) onUseTemplate;
  final VoidCallback onCustomMessage;

  const _FUTemplatePickerSheet({
    required this.actionLabel,
    required this.templates,
    required this.customerName,
    this.isWhatsApp = false,
    required this.onUseTemplate,
    required this.onCustomMessage,
  });

  @override
  State<_FUTemplatePickerSheet> createState() => _FUTemplatePickerSheetState();
}

class _FUTemplatePickerSheetState extends State<_FUTemplatePickerSheet> {
  final _customCtrl = TextEditingController();
  bool _showCustom = false;

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _openWhatsApp(String message) {
    Navigator.pop(context);
    widget.onUseTemplate(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp for ${widget.customerName}...'),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.isWhatsApp
                          ? const Color(0xFF25D366).withAlpha(20)
                          : AppTheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.isWhatsApp
                          ? Icons.chat_rounded
                          : Icons.description_rounded,
                      color: widget.isWhatsApp
                          ? const Color(0xFF25D366)
                          : AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.actionLabel} Templates',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'To: ${widget.customerName}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_showCustom) ...[
                      if (widget.templates.isNotEmpty) ...[
                        Text(
                          'Saved Templates',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...widget.templates.map((t) {
                          final color =
                              t['color'] as Color? ?? AppTheme.primary;
                          return GestureDetector(
                            onTap: () {
                              final body = (t['body'] as String? ?? '')
                                  .replaceAll(
                                    '@customer_name',
                                    widget.customerName,
                                  );
                              if (widget.isWhatsApp) {
                                _openWhatsApp(body);
                              } else {
                                Navigator.pop(context);
                                widget.onUseTemplate(body);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withAlpha(10),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color.withAlpha(50)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        t['icon'] as IconData? ??
                                            Icons.description_rounded,
                                        size: 14,
                                        color: color,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          t['name'] as String? ?? '',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withAlpha(20),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          t['category'] as String? ?? '',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    (t['body'] as String? ?? '').replaceAll(
                                      '@customer_name',
                                      widget.customerName,
                                    ),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                      GestureDetector(
                        onTap: () => setState(() => _showCustom = true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Write Custom Message',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: AppTheme.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _showCustom = false),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Custom Message',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customCtrl,
                        maxLines: 5,
                        autofocus: true,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText:
                              'Type your message to ${widget.customerName}...',
                          filled: true,
                          fillColor: AppTheme.surface100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _customCtrl.text.trim().isEmpty
                              ? null
                              : () {
                                  if (widget.isWhatsApp) {
                                    _openWhatsApp(_customCtrl.text.trim());
                                  } else {
                                    Navigator.pop(context);
                                    widget.onCustomMessage();
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: widget.isWhatsApp
                                ? const Color(0xFF25D366)
                                : AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.isWhatsApp
                                ? 'Open WhatsApp'
                                : 'Send Message',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  const _CountChip({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final bool hasActive;
  final VoidCallback onTap;
  const _HeaderBtn({
    required this.icon,
    required this.hasActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasActive ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasActive ? AppTheme.primary : AppTheme.surface200,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: hasActive ? AppTheme.primary : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.priorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 4),
          Text(
            priority,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String label, value, trend;
  final IconData icon;
  final Color color;
  final bool trendUp;
  const _KpiData(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.trend,
    this.trendUp,
  );
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: data.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 14, color: data.color),
              ),
              if (data.trend.isNotEmpty)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.trendUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 11,
                        color: data.trendUp ? AppTheme.success : AppTheme.warning,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          data.trend,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: data.trendUp ? AppTheme.success : AppTheme.warning,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────

class _FUFilterSheet extends StatefulWidget {
  final List<String> selectedAgents,
      selectedTypes,
      selectedFrequencies,
      typeOptions,
      frequencyOptions;
  final bool? existingCustomerFilter;
  final bool showCompleted,
      showUpcoming,
      showOverdue,
      showCancelled,
      showDues,
      showToday;
  final DateTime? dateFrom, dateTo;
  final Function(
    List<String>,
    List<String>,
    List<String>,
    bool?,
    DateTime?,
    DateTime?,
    bool,
    bool,
    bool,
    bool,
    bool,
    bool,
  )
  onApply;

  const _FUFilterSheet({
    required this.selectedAgents,
    required this.selectedTypes,
    required this.selectedFrequencies,
    required this.existingCustomerFilter,
    required this.showCompleted,
    required this.showUpcoming,
    required this.showOverdue,
    required this.showCancelled,
    required this.showDues,
    required this.showToday,
    required this.typeOptions,
    required this.frequencyOptions,
    required this.dateFrom,
    required this.dateTo,
    required this.onApply,
  });

  @override
  State<_FUFilterSheet> createState() => _FUFilterSheetState();
}

class _FUFilterSheetState extends State<_FUFilterSheet> {
  late List<String> _agents, _types, _freqs;
  bool? _existingCustomer;
  bool _showCompleted = false, _showUpcoming = false, _showOverdue = false;
  bool _showCancelled = false, _showDues = false, _showToday = false;
  DateTime? _from, _to;

  @override
  void initState() {
    super.initState();
    _agents = List.from(widget.selectedAgents);
    _types = List.from(widget.selectedTypes);
    _freqs = List.from(widget.selectedFrequencies);
    _existingCustomer = widget.existingCustomerFilter;
    _showCompleted = widget.showCompleted;
    _showUpcoming = widget.showUpcoming;
    _showOverdue = widget.showOverdue;
    _showCancelled = widget.showCancelled;
    _showDues = widget.showDues;
    _showToday = widget.showToday;
    _from = widget.dateFrom;
    _to = widget.dateTo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Filter Follow-ups',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _agents = [];
                    _types = [];
                    _freqs = [];
                    _existingCustomer = null;
                    _from = null;
                    _to = null;
                    _showCompleted = false;
                    _showUpcoming = false;
                    _showOverdue = false;
                    _showCancelled = false;
                    _showDues = false;
                    _showToday = false;
                  }),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ─── Status Section ───────────────────────────────────────────
            Text(
              'Status',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'Completed',
                  isSelected: _showCompleted,
                  onTap: () => setState(() => _showCompleted = !_showCompleted),
                ),
                _FilterChip(
                  label: 'Cancelled',
                  isSelected: _showCancelled,
                  onTap: () => setState(() => _showCancelled = !_showCancelled),
                ),
                _FilterChip(
                  label: 'Dues',
                  isSelected: _showDues,
                  onTap: () => setState(() => _showDues = !_showDues),
                ),
                _FilterChip(
                  label: 'Today',
                  isSelected: _showToday,
                  onTap: () => setState(() => _showToday = !_showToday),
                ),
                _FilterChip(
                  label: 'Upcoming',
                  isSelected: _showUpcoming,
                  onTap: () => setState(() => _showUpcoming = !_showUpcoming),
                ),
                _FilterChip(
                  label: 'Overdue',
                  isSelected: _showOverdue,
                  onTap: () => setState(() => _showOverdue = !_showOverdue),
                ),
              ],
            ),
            const Divider(height: 24),
            // Type
            Text(
              'Type',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.typeOptions.map((t) {
                final sel = _types.contains(t);
                return _FilterChip(
                  label: t,
                  isSelected: sel,
                  onTap: () =>
                      setState(() => sel ? _types.remove(t) : _types.add(t)),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            // Frequency
            Text(
              'Follow-up Frequency',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.frequencyOptions.map((f) {
                final sel = _freqs.contains(f);
                return _FilterChip(
                  label: f,
                  isSelected: sel,
                  onTap: () =>
                      setState(() => sel ? _freqs.remove(f) : _freqs.add(f)),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            // Existing Customer
            Text(
              'Existing Customer',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _existingCustomer == null,
                  onTap: () => setState(() => _existingCustomer = null),
                ),
                _FilterChip(
                  label: 'Yes',
                  isSelected: _existingCustomer == true,
                  onTap: () => setState(() => _existingCustomer = true),
                ),
                _FilterChip(
                  label: 'No',
                  isSelected: _existingCustomer == false,
                  onTap: () => setState(() => _existingCustomer = false),
                ),
              ],
            ),
            const Divider(height: 24),
            // Assigned Member (same as leads)
            Text(
              'Assigned Member',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _FUAssignedFilter(
              selectedAgents: _agents,
              onChanged: (a) => setState(() => _agents = a),
            ),
            const Divider(height: 24),
            // Date range
            Text(
              'Date Range',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate:
                            _from ??
                            DateTime.now().subtract(const Duration(days: 30)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null) setState(() => _from = d);
                    },
                    icon: const Icon(Icons.calendar_today_rounded, size: 14),
                    label: Text(
                      _from != null
                          ? '${_from!.day}/${_from!.month}/${_from!.year}'
                          : 'From',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _to ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null) setState(() => _to = d);
                    },
                    icon: const Icon(Icons.calendar_today_rounded, size: 14),
                    label: Text(
                      _to != null
                          ? '${_to!.day}/${_to!.month}/${_to!.year}'
                          : 'To',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                if (_from != null || _to != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: AppTheme.error,
                    ),
                    onPressed: () => setState(() {
                      _from = null;
                      _to = null;
                    }),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                widget.onApply(
                  _agents,
                  _types,
                  _freqs,
                  _existingCustomer,
                  _from,
                  _to,
                  _showCompleted,
                  _showUpcoming,
                  _showOverdue,
                  _showCancelled,
                  _showDues,
                  _showToday,
                );
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.warning,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surface200,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Assigned Filter (same as leads) ─────────────────────────────────────────

class _FUAssignedFilter extends StatefulWidget {
  final List<String> selectedAgents;
  final ValueChanged<List<String>> onChanged;
  const _FUAssignedFilter({
    required this.selectedAgents,
    required this.onChanged,
  });

  @override
  State<_FUAssignedFilter> createState() => _FUAssignedFilterState();
}

class _FUAssignedFilterState extends State<_FUAssignedFilter> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_AgentInfo> get _displayList {
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      return _kAgents
          .where(
            (a) =>
                a.name.toLowerCase().contains(q) ||
                a.role.toLowerCase().contains(q),
          )
          .toList();
    }
    final selected = _kAgents
        .where((a) => widget.selectedAgents.contains(a.name))
        .toList();
    final unselected = _kAgents
        .where((a) => !widget.selectedAgents.contains(a.name))
        .take(3)
        .toList();
    return [...selected, ...unselected];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Search agents...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppTheme.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: 8),
        _buildRow(
          'ALL',
          'All Agents',
          'Show all',
          '',
          AppTheme.textSecondary,
          widget.selectedAgents.isEmpty,
          () => widget.onChanged([]),
        ),
        ..._displayList.map(
          (a) => _buildRow(
            a.initials,
            a.name,
            a.role,
            a.id,
            a.color,
            widget.selectedAgents.contains(a.name),
            () {
              final updated = List<String>.from(widget.selectedAgents);
              updated.contains(a.name)
                  ? updated.remove(a.name)
                  : updated.add(a.name);
              widget.onChanged(updated);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    String initials,
    String name,
    String role,
    String id,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withAlpha(40),
              child: Text(
                initials.length > 2 ? initials.substring(0, 2) : initials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    role,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Sort Sheet ───────────────────────────────────────────────────────────────

class _FUSortSheet extends StatelessWidget {
  final _FollowUpSortOption current;
  final ValueChanged<_FollowUpSortOption> onSelect;
  const _FUSortSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        _FollowUpSortOption.dueDateSoonest,
        'Due Date — Soonest First',
        Icons.arrow_upward_rounded,
      ),
      (
        _FollowUpSortOption.dueDateLatest,
        'Due Date — Latest First',
        Icons.arrow_downward_rounded,
      ),
      (
        _FollowUpSortOption.priorityHigh,
        'Priority — High to Low',
        Icons.priority_high_rounded,
      ),
      (
        _FollowUpSortOption.createdNewest,
        'Created — Newest First',
        Icons.fiber_new_rounded,
      ),
      (
        _FollowUpSortOption.leadAZ,
        'Lead Name — A to Z',
        Icons.sort_by_alpha_rounded,
      ),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sort Follow-ups',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((o) {
            final sel = current == o.$1;
            return ListTile(
              leading: Icon(
                o.$3,
                color: sel ? AppTheme.warning : AppTheme.textSecondary,
                size: 20,
              ),
              title: Text(
                o.$2,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? AppTheme.warning : AppTheme.textPrimary,
                ),
              ),
              trailing: sel
                  ? Icon(Icons.check_rounded, color: AppTheme.warning, size: 18)
                  : null,
              onTap: () {
                onSelect(o.$1);
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}
