import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../follow_ups_screen/follow_ups_screen.dart' as fu_screen;
import '../leads_list_screen/leads_list_screen.dart' as leads_list;
import '../leads_list_screen/widgets/lead_card_widget.dart'
    show globalStarredLeadIds;
import '../reminders_screen/reminders_screen.dart' show globalReminderMaps;
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
    color: Color(0xFF0891B2),
  ),
  _AgentInfo(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    id: 'EMP-3012',
    phone: '+91 65432 44444',
    color: Color(0xFFEC4899),
  ),
  _AgentInfo(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    id: 'EMP-2756',
    phone: '+91 54321 55555',
    color: Color(0xFFF59E0B),
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

// ─── Activity Timeline Logger ─────────────────────────────────────────────────

void _logSessionActivityToLead(
  String leadId,
  String leadName,
  String action,
  String detail,
) {
  final idx = leads_list.globalLeads.indexWhere(
    (m) => (leadId.isNotEmpty && m['id'] == leadId) || m['name'] == leadName,
  );
  if (idx < 0) return;
  final activities =
      (leads_list.globalLeads[idx]['activityTimeline'] as List<dynamic>?) ??
      <dynamic>[];
  final newActivity = {
    'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
    'type': action,
    'title': action,
    'detail': detail,
    'timestamp': DateTime.now(),
  };
  activities.insert(0, newActivity);
  leads_list.globalLeads[idx]['activityTimeline'] = activities;
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> globalSessionMaps = [
  {
    'id': 'ses-001',
    'title': 'Enterprise Insurance Review',
    'type': 'Video Call',
    'status': 'Completed',
    'date': DateTime.now().subtract(const Duration(hours: 2)),
    'host': 'Priya Sharma',
    'hostInitials': 'PS',
    'participants': ['Rahul Mehta', 'Priya Mehta'],
    'linkedLead': 'Rahul Mehta',
    'linkedLeadId': 'default-1',
    'customerPhone': '+91 98765 43210',
    'preferredContact': ['Video Call', 'Email'],
    'meetingLink': 'meet.google.com/abc-defg-hij',
    'videoCallMode': 'Inbuilt',
    'platform': 'Google Meet',
    'recording': true,
    'recordingUrl': 'drive.google.com/rec/ses-001',
    'notes':
        'Discussed enterprise plan pricing. Client interested in ₹1Cr life cover + health floater.',
    'actionItems': [
      'Send revised quotation',
      'Schedule follow-up call',
      'Share policy brochure',
    ],
    'outcome': 'Positive — Moving to Proposal',
    'rating': 4,
    'agenda': 'Review insurance portfolio and finalize premium structure',
    'location': 'Online',
    'reminderSent': true,
    'followUpScheduled': true,
    'followUpDate': DateTime.now().add(const Duration(days: 3)),
    'dealValue': 1250000.0,
    'priority': 'High',
    'startedAt': DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    'endedAt': DateTime.now().subtract(const Duration(hours: 2)),
    'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    'videoCallCount': 1,
    'callCount': 0,
    'appointmentCount': 0,
    'isExistingCustomer': true,
    'interestTags': ['Life Insurance', 'Health Cover'],
    'instagram': 'rahulmehta_official',
    'facebook': 'rahul.mehta.123',
    'twitter': 'rahulmehta',
    'telegram': 'rahulmehta_tg',
  },
  {
    'id': 'ses-002',
    'title': 'Health Cover Consultation',
    'type': 'Call Back',
    'status': 'Completed',
    'date': DateTime.now().subtract(const Duration(hours: 5)),
    'host': 'Rahul Singh',
    'hostInitials': 'RS',
    'participants': ['Sneha Kapoor'],
    'linkedLead': 'Sneha Kapoor',
    'linkedLeadId': 'default-2',
    'customerPhone': '+91 87654 32109',
    'preferredContact': ['Calls', 'WhatsApp Messages'],
    'meetingLink': '',
    'platform': 'Phone',
    'recording': false,
    'notes':
        'Explained family floater benefits. Client comparing with competitor.',
    'actionItems': ['Send comparison sheet', 'Call back in 2 days'],
    'outcome': 'Neutral — Client comparing options',
    'rating': 3,
    'agenda': 'Health insurance options for family of 4',
    'location': 'Phone',
    'reminderSent': true,
    'followUpScheduled': true,
    'followUpDate': DateTime.now().add(const Duration(days: 2)),
    'dealValue': 280000.0,
    'priority': 'Medium',
    'startedAt': DateTime.now().subtract(const Duration(hours: 5, minutes: 20)),
    'endedAt': DateTime.now().subtract(const Duration(hours: 5)),
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'videoCallCount': 0,
    'callCount': 2,
    'appointmentCount': 0,
    'isExistingCustomer': false,
  },
  {
    'id': 'ses-003',
    'title': 'Term Plan Proposal Meeting',
    'type': 'Appointment',
    'status': 'Scheduled',
    'date': DateTime.now().add(const Duration(hours: 3)),
    'host': 'Priya Sharma',
    'hostInitials': 'PS',
    'participants': ['Vikram Singh', 'Ananya Patel'],
    'linkedLead': 'Vikram Singh',
    'linkedLeadId': 'default-3',
    'customerPhone': '+91 76543 21098',
    'preferredContact': ['Calls', 'Email'],
    'meetingLink': '',
    'platform': 'In-Person',
    'recording': false,
    'notes': '',
    'actionItems': ['Prepare proposal deck', 'Bring policy documents'],
    'outcome': '',
    'rating': 0,
    'agenda': 'Present term plan proposal and discuss premium options',
    'location': 'Client Office, Hyderabad',
    'reminderSent': true,
    'followUpScheduled': false,
    'dealValue': 620000.0,
    'priority': 'High',
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'videoCallCount': 0,
    'callCount': 0,
    'appointmentCount': 1,
    'isExistingCustomer': true,
  },
  {
    'id': 'ses-004',
    'title': 'Mutual Fund Portfolio Review',
    'type': 'Video Call',
    'status': 'Scheduled',
    'date': DateTime.now().add(const Duration(days: 1, hours: 2)),
    'host': 'Kavya Menon',
    'hostInitials': 'KM',
    'participants': ['Karan Joshi'],
    'linkedLead': 'Karan Joshi',
    'linkedLeadId': 'default-5',
    'customerPhone': '+91 65432 10987',
    'preferredContact': ['Video Call', 'Email'],
    'meetingLink': 'zoom.us/j/123456789',
    'videoCallMode': '3rd Party',
    'platform': 'Zoom',
    'recording': false,
    'notes': '',
    'actionItems': ['Prepare fund comparison', 'SIP calculator'],
    'outcome': '',
    'rating': 0,
    'agenda': 'Review SIP options and risk profile',
    'location': 'Online',
    'reminderSent': false,
    'followUpScheduled': false,
    'dealValue': 95000.0,
    'priority': 'Medium',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'videoCallCount': 0,
    'callCount': 0,
    'appointmentCount': 0,
    'isExistingCustomer': false,
  },
  {
    'id': 'ses-005',
    'title': 'Corporate Key Man Insurance',
    'type': 'Video Call',
    'status': 'In Progress',
    'date': DateTime.now().subtract(const Duration(minutes: 20)),
    'host': 'Priya Sharma',
    'hostInitials': 'PS',
    'participants': ['Mohammed Al-Rashid', 'CFO Team'],
    'linkedLead': 'Mohammed Al-Rashid',
    'linkedLeadId': 'default-6',
    'customerPhone': '+971 50 123 4567',
    'preferredContact': ['Video Call', 'Email'],
    'meetingLink': 'teams.microsoft.com/meet/abc',
    'videoCallMode': '3rd Party',
    'platform': 'MS Teams',
    'recording': true,
    'recordingUrl': '',
    'notes': 'Presenting key man insurance for 3 directors.',
    'actionItems': [
      'Draft policy terms',
      'Legal review',
      'Send final proposal',
    ],
    'outcome': '',
    'rating': 0,
    'agenda': 'Key man insurance for C-suite executives',
    'location': 'Online',
    'reminderSent': true,
    'followUpScheduled': false,
    'dealValue': 4500000.0,
    'priority': 'High',
    'startedAt': DateTime.now().subtract(const Duration(minutes: 20)),
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'videoCallCount': 1,
    'callCount': 0,
    'appointmentCount': 0,
    'isExistingCustomer': true,
  },
  {
    'id': 'ses-006',
    'title': 'Retirement Planning Session',
    'type': 'Call Back',
    'status': 'Cancelled',
    'date': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    'host': 'Ananya Patel',
    'hostInitials': 'AP',
    'participants': ['Deepa Krishnan'],
    'linkedLead': 'Deepa Krishnan',
    'linkedLeadId': 'default-7',
    'customerPhone': '+91 54321 09876',
    'preferredContact': ['Calls'],
    'meetingLink': '',
    'platform': 'Phone',
    'recording': false,
    'notes':
        'Client did not join. Sent follow-up message.\nCancelled Reason: Client had a family emergency and requested reschedule.',
    'actionItems': ['Reschedule session', 'Send reminder'],
    'outcome': 'Cancelled — Reschedule needed',
    'rating': 0,
    'agenda': 'Retirement corpus planning and pension options',
    'location': 'Phone',
    'reminderSent': true,
    'followUpScheduled': true,
    'followUpDate': DateTime.now().add(const Duration(days: 1)),
    'dealValue': 350000.0,
    'priority': 'Medium',
    'createdAt': DateTime.now().subtract(const Duration(days: 4)),
    'videoCallCount': 0,
    'callCount': 1,
    'appointmentCount': 0,
    'cancelReason': 'Client had a family emergency and requested reschedule.',
    'isExistingCustomer': false,
  },
  {
    'id': 'ses-006b',
    'title': 'Mutual Fund Portfolio Review',
    'type': 'Video Call',
    'status': 'Rescheduled',
    'date': DateTime.now().add(const Duration(days: 2, hours: 1)),
    'host': 'Jeevan Kumar',
    'hostInitials': 'JK',
    'participants': ['Priya Sharma'],
    'linkedLead': 'Priya Sharma',
    'linkedLeadId': 'default-3',
    'customerPhone': '+91 78945 61230',
    'preferredContact': ['Video Call', 'Email'],
    'meetingLink': '',
    'platform': 'Google Meet',
    'recording': false,
    'notes': 'Rescheduled from original date due to client request.',
    'actionItems': ['Send updated meeting link'],
    'outcome': '',
    'rating': 0,
    'agenda': 'Review mutual fund portfolio performance and rebalancing',
    'location': 'Video Call',
    'reminderSent': false,
    'followUpScheduled': false,
    'dealValue': 500000.0,
    'priority': 'High',
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'videoCallCount': 0,
    'callCount': 0,
    'appointmentCount': 0,
    'videoCallMode': 'Inbuilt',
    'isExistingCustomer': true,
  },
  // ─── Default Due Sessions (for testing Dues filter) ───────────────────────
  {
    'id': 'ses-007',
    'title': 'Life Insurance Review — Overdue',
    'type': 'Call Back',
    'status': 'Scheduled',
    'date': DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    'host': 'Rahul Singh',
    'hostInitials': 'RS',
    'participants': ['Arjun Mehta'],
    'linkedLead': 'Arjun Mehta',
    'linkedLeadId': '',
    'customerPhone': '+91 91234 56789',
    'preferredContact': ['Calls'],
    'meetingLink': '',
    'platform': 'Phone',
    'recording': false,
    'notes': 'Missed call — needs rescheduling. Client was unavailable.',
    'actionItems': ['Reschedule call', 'Send reminder SMS'],
    'outcome': '',
    'rating': 0,
    'agenda': 'Review term life insurance options',
    'location': 'Phone',
    'reminderSent': true,
    'followUpScheduled': false,
    'dealValue': 450000.0,
    'priority': 'High',
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'videoCallCount': 0,
    'callCount': 1,
    'appointmentCount': 0,
    'isExistingCustomer': false,
  },
  {
    'id': 'ses-008',
    'title': 'Health Floater Appointment — Overdue',
    'type': 'Appointment',
    'status': 'Scheduled',
    'date': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    'host': 'Kavya Menon',
    'hostInitials': 'KM',
    'participants': ['Sunita Rao'],
    'linkedLead': 'Sunita Rao',
    'linkedLeadId': '',
    'customerPhone': '+91 80123 45678',
    'preferredContact': ['Email', 'Calls'],
    'meetingLink': '',
    'platform': 'In-Person',
    'recording': false,
    'notes': 'Client did not show up. Needs follow-up.',
    'actionItems': ['Call to reschedule', 'Send apology email'],
    'outcome': '',
    'rating': 0,
    'agenda': 'Health floater plan for family of 5',
    'location': 'Branch Office, Chennai',
    'reminderSent': true,
    'followUpScheduled': false,
    'dealValue': 180000.0,
    'priority': 'Medium',
    'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    'videoCallCount': 0,
    'callCount': 0,
    'appointmentCount': 1,
    'isExistingCustomer': true,
  },
  {
    'id': 'ses-009',
    'title': 'SIP Investment Video Call — Overdue',
    'type': 'Video Call',
    'status': 'Scheduled',
    'date': DateTime.now().subtract(const Duration(hours: 6)),
    'host': 'Arjun Das',
    'hostInitials': 'AD',
    'participants': ['Pradeep Kumar'],
    'linkedLead': 'Pradeep Kumar',
    'linkedLeadId': '',
    'customerPhone': '+91 70987 65432',
    'preferredContact': ['Video Call'],
    'meetingLink': 'meet.google.com/xyz-abcd-efg',
    'videoCallMode': 'Inbuilt',
    'platform': 'Google Meet',
    'recording': false,
    'notes': 'Client joined late and call dropped. Needs to be rescheduled.',
    'actionItems': ['Resend meeting link', 'Reschedule for tomorrow'],
    'outcome': '',
    'rating': 0,
    'agenda': 'SIP investment planning and portfolio review',
    'location': 'Online',
    'reminderSent': true,
    'followUpScheduled': false,
    'dealValue': 120000.0,
    'priority': 'Medium',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'videoCallCount': 0,
    'callCount': 0,
    'appointmentCount': 0,
    'isExistingCustomer': false,
  },
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

enum _SessionSortOption { dateAscending, dateDescending, priorityHigh, leadAZ }

class _SessionsScreenState extends State<SessionsScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  String _selectedFilter = 'Today';
  _SessionSortOption _sortOption = _SessionSortOption.dateDescending;

  List<String> _selectedHosts = [];
  List<String> _selectedTypes = [];
  List<String> _selectedStatuses = [];
  bool? _existingCustomerFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _sessions = [];

  static const _statusFilters = [
    'Today',
    'All',
    'Dues',
    'Rescheduled',
    'Completed',
    'Appointments',
    'Call Backs',
    'Video Call',
    'Cancelled',
  ];
  static const _typeOptions = ['Video Call', 'Appointment', 'Call Back'];

  List<String> get _hostOptions => _kAgents.map((a) => a.name).toList();

  // Whether a filter sheet filter is active (hides horizontal chips)
  bool get _isFilterActive => _hasActiveFilters;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _sessions = List.from(globalSessionMaps);
        _isLoading = false;
      });
    }
  }

  bool get _hasActiveFilters =>
      _selectedHosts.isNotEmpty ||
      _selectedTypes.isNotEmpty ||
      _selectedStatuses.isNotEmpty ||
      _existingCustomerFilter != null ||
      _dateFrom != null ||
      _dateTo != null;

  List<Map<String, dynamic>> get _filteredSessions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    List<Map<String, dynamic>> result = _sessions.where((s) {
      bool matchesFilter = true;
      switch (_selectedFilter) {
        case 'All':
          matchesFilter = true;
          break;
        case 'Today':
          final d = s['date'] as DateTime;
          final day = DateTime(d.year, d.month, d.day);
          matchesFilter = day == today;
          break;
        case 'Dues':
          final d = s['date'] as DateTime;
          matchesFilter =
              d.isBefore(now) &&
              s['status'] != 'Completed' &&
              s['status'] != 'Cancelled';
          break;
        case 'Rescheduled':
          matchesFilter = s['status'] == 'Rescheduled';
          break;
        case 'Completed':
          matchesFilter = s['status'] == 'Completed';
          break;
        case 'Appointments':
          matchesFilter = s['type'] == 'Appointment';
          break;
        case 'Call Backs':
          matchesFilter = s['type'] == 'Call Back';
          break;
        case 'Video Call':
          matchesFilter = s['type'] == 'Video Call';
          break;
        case 'Cancelled':
          matchesFilter = s['status'] == 'Cancelled';
          break;
        default:
          matchesFilter = true;
      }
      final matchesSearch =
          _searchQuery.isEmpty ||
          (s['title'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (s['linkedLead'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (s['host'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (s['customerPhone'] as String? ?? '').contains(_searchQuery);
      final matchesHost =
          _selectedHosts.isEmpty || _selectedHosts.contains(s['host']);
      final matchesType =
          _selectedTypes.isEmpty || _selectedTypes.contains(s['type']);
      // Status filter from filter sheet
      bool matchesStatus = true;
      if (_selectedStatuses.isNotEmpty) {
        final sStatus = s['status'] as String? ?? '';
        final sDate = s['date'] as DateTime;
        matchesStatus = _selectedStatuses.any((st) {
          switch (st) {
            case 'Upcoming':
              return sStatus == 'Scheduled' && !sDate.isBefore(now);
            case 'Completed':
              return sStatus == 'Completed';
            case 'Dues':
              return sStatus == 'Scheduled' && sDate.isBefore(now);
            case 'Rescheduled':
              return sStatus == 'Rescheduled';
            case 'Cancelled':
              return sStatus == 'Cancelled';
            default:
              return false;
          }
        });
      }
      final matchesExisting =
          _existingCustomerFilter == null ||
          (_existingCustomerFilter == true &&
              s['isExistingCustomer'] == true) ||
          (_existingCustomerFilter == false && s['isExistingCustomer'] != true);
      bool matchesDate = true;
      final date = s['date'] as DateTime;
      if (_dateFrom != null && date.isBefore(_dateFrom!)) matchesDate = false;
      if (_dateTo != null &&
          date.isAfter(_dateTo!.add(const Duration(days: 1)))) {
        matchesDate = false;
      }
      return matchesFilter &&
          matchesSearch &&
          matchesHost &&
          matchesType &&
          matchesStatus &&
          matchesExisting &&
          matchesDate;
    }).toList();

    // Sort: today first, then by date
    result.sort((a, b) {
      final aDate = a['date'] as DateTime;
      final bDate = b['date'] as DateTime;
      final aDay = DateTime(aDate.year, aDate.month, aDate.day);
      final bDay = DateTime(bDate.year, bDate.month, bDate.day);
      final todayDay = DateTime(now.year, now.month, now.day);
      final aIsToday = aDay == todayDay;
      final bIsToday = bDay == todayDay;
      if (aIsToday && !bIsToday) return -1;
      if (!aIsToday && bIsToday) return 1;
      if (aIsToday && bIsToday) return aDate.compareTo(bDate);
      return bDate.compareTo(aDate);
    });
    return result;
  }

  int get _totalSessions => _sessions.length;
  int get _videoCallCount =>
      _sessions.where((s) => s['type'] == 'Video Call').length;
  int get _appointmentCount =>
      _sessions.where((s) => s['type'] == 'Appointment').length;
  int get _callBackCount =>
      _sessions.where((s) => s['type'] == 'Call Back').length;
  int get _completedCount =>
      _sessions.where((s) => s['status'] == 'Completed').length;
  int get _rescheduledCount =>
      _sessions.where((s) => s['status'] == 'Rescheduled').length;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _FilterSheet(
          selectedHosts: List.from(_selectedHosts),
          selectedTypes: List.from(_selectedTypes),
          selectedStatuses: List.from(_selectedStatuses),
          existingCustomerFilter: _existingCustomerFilter,
          hostOptions: _hostOptions,
          typeOptions: _typeOptions,
          dateFrom: _dateFrom,
          dateTo: _dateTo,
          onApply: (hosts, types, statuses, existingCustomer, from, to) {
            setState(() {
              _selectedHosts = hosts;
              _selectedTypes = types;
              _selectedStatuses = statuses;
              _existingCustomerFilter = existingCustomer;
              _dateFrom = from;
              _dateTo = to;
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
        minimum: EdgeInsets.only(bottom: 8),
        child: _SortSheet(
          current: _sortOption,
          onSelect: (opt) => setState(() => _sortOption = opt),
        ),
      ),
    );
  }

  void _showAddSessionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _NewSessionSheet(
          agents: _kAgents,
          onSave: (sessionData) {
          // Check: max 1 active session per customer
          final customerName = sessionData['linkedLead'] as String? ?? '';
          final customerId = sessionData['linkedLeadId'] as String? ?? '';
          final conflict = globalSessionMaps.any((m) {
            final mStatus = m['status'] as String? ?? '';
            if (mStatus == 'Completed' || mStatus == 'Cancelled') return false;
            final mLead = m['linkedLead'] as String? ?? '';
            final mLeadId = m['linkedLeadId'] as String? ?? '';
            return (customerName.isNotEmpty && mLead == customerName) ||
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
                        'Active Session Exists',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  '$customerName already has an active session. A customer cannot have more than 1 active session at a time. Please complete or cancel the existing session first.',
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
            return;
          }
          globalSessionMaps.insert(0, sessionData);
          setState(() {
            _sessions = List.from(globalSessionMaps);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text('Session scheduled successfully!'),
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

  void _clearAllFilters() {
    setState(() {
      _selectedHosts = [];
      _selectedTypes = [];
      _selectedStatuses = [];
      _existingCustomerFilter = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }

  // ─── Dues section: group past-date non-completed/cancelled sessions by date ─
  Widget _buildDuesSectionedList(List<Map<String, dynamic>> filtered) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Only dues: past date, not completed, not cancelled, NOT in progress (video calls in progress are live)
    final dues = filtered.where((s) {
      final d = s['date'] as DateTime;
      return d.isBefore(now) &&
          s['status'] != 'Completed' &&
          s['status'] != 'Cancelled' &&
          s['status'] != 'In Progress'; // In Progress video calls not overdue
    }).toList();
    dues.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    final List<dynamic> items = [];
    String? lastKey;
    for (final s in dues) {
      final date = s['date'] as DateTime;
      final d = DateTime(date.year, date.month, date.day);
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
      final diff = today.difference(d).inDays;
      final dateStr = '${date.day} ${months[date.month - 1]} ${date.year}';
      final headerLabel = diff == 0
          ? 'Today (Overdue)'
          : diff == 1
          ? 'Yesterday · $dateStr'
          : '${diff}d Overdue · $dateStr';
      if (headerLabel != lastKey) {
        items.add({
          '_header': headerLabel,
          '_isPast': true,
          '_isToday': diff == 0,
        });
        lastKey = headerLabel;
      }
      items.add(s);
    }
    if (items.isEmpty) return SliverToBoxAdapter(child: _buildEmpty());
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, MediaQuery.paddingOf(context).bottom + 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final item = items[i];
            if (item is Map && item.containsKey('_header')) {
              final header = item['_header'] as String;
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
                        color: AppTheme.error.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.error.withAlpha(60)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            size: 12,
                            color: AppTheme.error,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              header,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.error,
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
                        color: AppTheme.error.withAlpha(40),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              );
            }
            final s = item as Map<String, dynamic>;
            return _SessionCard(
              session: s,
              index: dues.indexOf(s),
              onUpdate: () => setState(() {
                _sessions = List.from(globalSessionMaps);
              }),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  // ─── Section label for date grouping ──────────────────────────────────────
  String _sectionLabel(Map<String, dynamic> s) {
    final date = s['date'] as DateTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
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
    final h = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$h:${date.minute.toString().padLeft(2, '0')} $ampm';
    final dateStr = '${date.day} ${months[date.month - 1]} ${date.year}';

    if (d == today) return 'Today · $timeStr';
    if (d.isBefore(today)) {
      final diff = today.difference(d).inDays;
      final label = diff == 1 ? 'Yesterday' : '${diff}d ago';
      return '$label · $dateStr $timeStr';
    }
    if (d == today.add(const Duration(days: 1))) return 'Tomorrow · $timeStr';
    return '$dateStr · $timeStr';
  }

  Widget _buildSectionedList(List<Map<String, dynamic>> filtered) {
    final List<dynamic> items = [];
    String? lastDateKey;
    for (final s in filtered) {
      final date = s['date'] as DateTime;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(date.year, date.month, date.day);
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
      final dateStr = '${date.day} ${months[date.month - 1]} ${date.year}';
      final status = s['status'] as String;
      final isInProgress = status == 'In Progress';

      // Date-only key for grouping (all items on same date share one header)
      String headerLabel;
      bool isOverdueHeader = false;
      if (d == today) {
        headerLabel = 'Today';
      } else if (d.isBefore(today)) {
        final diff = today.difference(d).inDays;
        if (status == 'Completed' || status == 'Cancelled' || isInProgress) {
          headerLabel = diff == 1
              ? 'Yesterday · $dateStr'
              : '${diff}d ago · $dateStr';
        } else {
          headerLabel = diff == 1
              ? 'Yesterday (Overdue) · $dateStr'
              : '${diff}d Overdue · $dateStr';
          isOverdueHeader = true;
        }
      } else if (d == today.add(const Duration(days: 1))) {
        headerLabel = 'Tomorrow';
      } else {
        headerLabel = dateStr;
      }

      if (headerLabel != lastDateKey) {
        items.add({
          '_header': headerLabel,
          '_isPast': d.isBefore(today),
          '_isToday': d == today,
          '_isOverdue': isOverdueHeader,
        });
        lastDateKey = headerLabel;
      }
      items.add(s);
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, MediaQuery.paddingOf(context).bottom + 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final item = items[i];
            if (item is Map && item.containsKey('_header')) {
              final header = item['_header'] as String;
              final isPast = item['_isPast'] as bool;
              final isToday = item['_isToday'] as bool;
              final isOverdue = item['_isOverdue'] as bool? ?? false;
              final headerColor = isOverdue
                  ? AppTheme.error
                  : isToday
                  ? AppTheme.primary
                  : isPast
                  ? AppTheme.textMuted
                  : AppTheme.success;
              final headerIcon = isOverdue
                  ? Icons.warning_rounded
                  : isToday
                  ? Icons.today_rounded
                  : isPast
                  ? Icons.history_rounded
                  : Icons.calendar_today_rounded;
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
                        color: headerColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: headerColor.withAlpha(60)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(headerIcon, size: 12, color: headerColor),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              header,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: headerColor,
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
                      child: Divider(color: headerColor.withAlpha(40), height: 1),
                    ),
                  ],
                ),
              );
            }
            final s = item as Map<String, dynamic>;
            final idx = filtered.indexOf(s);
            return _SessionCard(
              session: s,
              index: idx,
              onUpdate: () => setState(() {
                _sessions = List.from(globalSessionMaps);
              }),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSessions;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.event_note_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sessions',
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${_filteredSessions.length}/$_totalSessions sessions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearchActive ? Icons.search_off_rounded : Icons.search_rounded,
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
              _HeaderButton(
                icon: Icons.filter_list_rounded,
                hasActive: _hasActiveFilters,
                onTap: _showFilterSheet,
              ),
              const SizedBox(width: 6),
              _HeaderButton(
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
                if (_isFilterActive) _buildActiveFilterIndicator(),
                if (_hasActiveFilters) _buildActiveFilterChips(),
                if (_hasActiveFilters || _selectedFilter != 'All')
                  _buildFilteredCountBanner(filtered.length),
              ],
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filtered.isEmpty)
            SliverFillRemaining(
              child: _buildEmpty(),
            )
          else
            _selectedFilter == 'Dues'
                ? _buildDuesSectionedList(filtered)
                : _buildSectionedList(filtered),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSessionSheet,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(4, 12, 8, 12),
      child: Row(
        children: [
          IconButton(
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withAlpha(31),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: Color(0xFF8B5CF6),
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
                    'Sessions',
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                // X/Total format
                Text(
                  '${_filteredSessions.length}/$_totalSessions sessions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isSearchActive ? Icons.search_off_rounded : Icons.search_rounded,
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
          _HeaderButton(
            icon: Icons.filter_list_rounded,
            hasActive: _hasActiveFilters,
            onTap: _showFilterSheet,
          ),
          const SizedBox(width: 6),
          _HeaderButton(
            icon: Icons.sort_rounded,
            hasActive: false,
            onTap: _showSortSheet,
          ),
          const SizedBox(width: 4),
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
          hintText: 'Search sessions, leads, hosts, phone...',
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
    final now = DateTime.now();
    final dueCount = _sessions
        .where(
          (s) =>
              (s['date'] as DateTime).isBefore(now) &&
              s['status'] != 'Completed' &&
              s['status'] != 'Cancelled' &&
              s['status'] != 'In Progress', // In Progress not overdue
        )
        .length;
    final cancelledCount = _sessions
        .where((s) => s['status'] == 'Cancelled')
        .length;
    final kpis = [
      _KpiData(
        'All',
        '$_totalSessions',
        Icons.event_note_rounded,
        AppTheme.primary,
        '+$_totalSessions',
        false,
      ),
      _KpiData(
        'Video Calls',
        '$_videoCallCount',
        Icons.videocam_rounded,
        const Color(0xFF0891B2),
        '+$_videoCallCount',
        false,
      ),
      _KpiData(
        'Appointments',
        '$_appointmentCount',
        Icons.people_rounded,
        const Color(0xFF8B5CF6),
        '+$_appointmentCount',
        false,
      ),
      _KpiData(
        'Call Backs',
        '$_callBackCount',
        Icons.phone_callback_rounded,
        AppTheme.success,
        '+$_callBackCount',
        false,
      ),
      _KpiData(
        'Completed',
        '$_completedCount',
        Icons.check_circle_rounded,
        AppTheme.warning,
        '+$_completedCount',
        true,
      ),
      _KpiData(
        'Dues',
        '$dueCount',
        Icons.warning_rounded,
        AppTheme.error,
        '-$dueCount',
        false,
      ),
      _KpiData(
        'Rescheduled',
        '$_rescheduledCount',
        Icons.schedule_rounded,
        const Color(0xFF8B5CF6),
        '-$_rescheduledCount',
        false,
      ),
      _KpiData(
        'Cancelled',
        '$cancelledCount',
        Icons.cancel_rounded,
        AppTheme.textMuted,
        '-$cancelledCount',
        false,
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

  Widget _buildStatusFilterBar() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _statusFilters[i];
          final selected = _selectedFilter == f;
          // Count for each filter
          int count = 0;
          switch (f) {
            case 'All':
              count = _sessions.length;
              break;
            case 'Today':
              count = _sessions.where((s) {
                final d = s['date'] as DateTime;
                final day = DateTime(d.year, d.month, d.day);
                return day == today;
              }).length;
              break;
            case 'Dues':
              count = _sessions.where((s) {
                final d = s['date'] as DateTime;
                return d.isBefore(now) &&
                    s['status'] != 'Completed' &&
                    s['status'] != 'Cancelled';
              }).length;
              break;
            case 'Rescheduled':
              count = _sessions
                  .where((s) => s['status'] == 'Rescheduled')
                  .length;
              break;
            case 'Completed':
              count = _sessions.where((s) => s['status'] == 'Completed').length;
              break;
            case 'Appointments':
              count = _sessions.where((s) => s['type'] == 'Appointment').length;
              break;
            case 'Call Backs':
              count = _sessions.where((s) => s['type'] == 'Call Back').length;
              break;
            case 'Video Call':
              count = _sessions.where((s) => s['type'] == 'Video Call').length;
              break;
            case 'Cancelled':
              count = _sessions.where((s) => s['status'] == 'Cancelled').length;
              break;
          }
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.primary : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppTheme.primary : AppTheme.surface200,
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

  Widget _buildActiveFilterChips() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          ..._selectedHosts.map(
            (h) => _ActiveFilterChip(
              label: 'Host: $h',
              onRemove: () => setState(() => _selectedHosts.remove(h)),
            ),
          ),
          ..._selectedTypes.map(
            (t) => _ActiveFilterChip(
              label: 'Type: $t',
              onRemove: () => setState(() => _selectedTypes.remove(t)),
            ),
          ),
          ..._selectedStatuses.map(
            (st) => _ActiveFilterChip(
              label: 'Status: $st',
              onRemove: () => setState(() => _selectedStatuses.remove(st)),
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
          Icon(Icons.event_note_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No sessions found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
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
              color: AppTheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primary.withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 13,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  '$count session${count == 1 ? '' : 's'} found',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterIndicator() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int count = 0;
    switch (_selectedFilter) {
      case 'All':
        count = _sessions.length;
        break;
      case 'Today':
        count = _sessions.where((s) {
          final d = s['date'] as DateTime;
          final day = DateTime(d.year, d.month, d.day);
          return day == today;
        }).length;
        break;
      case 'Dues':
        count = _sessions.where((s) {
          final d = s['date'] as DateTime;
          return d.isBefore(now) &&
              s['status'] != 'Completed' &&
              s['status'] != 'Cancelled';
        }).length;
        break;
      case 'Completed':
        count = _sessions.where((s) => s['status'] == 'Completed').length;
        break;
      case 'Appointments':
        count = _sessions.where((s) => s['type'] == 'Appointment').length;
        break;
      case 'Call Backs':
        count = _sessions.where((s) => s['type'] == 'Call Back').length;
        break;
      case 'Video Call':
        count = _sessions.where((s) => s['type'] == 'Video Call').length;
        break;
      case 'Cancelled':
        count = _sessions.where((s) => s['status'] == 'Cancelled').length;
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
              color: AppTheme.primary,
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
                  '$_selectedFilter ($count)',
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
            onTap: () => setState(() => _selectedFilter = 'Today'),
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
          const Spacer(),
          // Show all filter chips in a scrollable row
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusFilters.where((f) => f != _selectedFilter).map(
                  (f) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
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
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Session Card ─────────────────────────────────────────────────────────────

class _SessionCard extends StatefulWidget {
  final Map<String, dynamic> session;
  final int index;
  final VoidCallback onUpdate;
  const _SessionCard({
    required this.session,
    required this.index,
    required this.onUpdate,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard>
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
      case 'Scheduled':
        return AppTheme.primary;
      case 'In Progress':
        return AppTheme.error;
      case 'Cancelled':
        return AppTheme.textMuted;
      default:
        return AppTheme.textMuted;
    }
  }

  // Compute display status for badge: In Progress, Today, Due, Completed On Time, Completed After Due, Cancelled
  String _computedStatusLabel(Map<String, dynamic> s) {
    final status = s['status'] as String? ?? '';
    if (status == 'In Progress') return 'In Progress';
    if (status == 'Rescheduled') return 'Rescheduled';
    if (status == 'Completed') {
      final endedAt = s['endedAt'] as DateTime?;
      final date = s['date'] as DateTime;
      if (endedAt != null) {
        final scheduledDay = DateTime(date.year, date.month, date.day);
        final completedDay = DateTime(endedAt.year, endedAt.month, endedAt.day);
        return !completedDay.isAfter(scheduledDay)
            ? 'Completed On Time'
            : 'Completed After Due';
      }
      return 'Completed';
    }
    if (status == 'Cancelled') return 'Cancelled';
    // Scheduled — check if today or due
    final date = s['date'] as DateTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (date.isBefore(now)) return 'Due';
    return 'Scheduled';
  }

  Color _computedStatusColor(Map<String, dynamic> s) {
    final label = _computedStatusLabel(s);
    switch (label) {
      case 'In Progress':
        return AppTheme.error;
      case 'Rescheduled':
        return const Color(0xFF8B5CF6);
      case 'Completed':
      case 'Completed On Time':
        return AppTheme.success;
      case 'Completed After Due':
        return AppTheme.warning;
      case 'Cancelled':
        return AppTheme.textMuted;
      case 'Today':
        return AppTheme.primary;
      case 'Due':
        return const Color(0xFFDC2626);
      default:
        return AppTheme.primary;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Video Call':
        return Icons.videocam_rounded;
      case 'Appointment':
        return Icons.people_rounded;
      case 'Call Back':
        return Icons.phone_callback_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'Video Call':
        return const Color(0xFF0891B2);
      case 'Appointment':
        return const Color(0xFF8B5CF6);
      case 'Call Back':
        return AppTheme.success;
      default:
        return AppTheme.primary;
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
    if (diff.inMinutes.abs() < 60 && diff.inDays == 0) {
      if (diff.inMinutes < 0) return '${(-diff.inMinutes)}m ago';
      if (diff.inMinutes == 0) return 'Now';
      return 'In ${diff.inMinutes}m';
    }
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return 'Today $h:${dt.minute.toString().padLeft(2, '0')} $ampm';
    }
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
    return '${dt.day} ${months[dt.month - 1]}, ${dt.hour > 12 ? dt.hour - 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _formatFullDateTime(DateTime dt) {
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

  String _computedDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '';
    final diff = end.difference(start);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  bool _canStartSession(Map<String, dynamic> s) {
    if (s['type'] != 'Video Call') return false;
    if (s['status'] != 'Scheduled') return false;
    return true; // No 30-min restriction — just show warning if too early
  }

  bool _isStartingEarly(Map<String, dynamic> s) {
    if (s['type'] != 'Video Call') return false;
    final scheduledDate = s['date'] as DateTime;
    final now = DateTime.now();
    final diff = scheduledDate.difference(now);
    return diff.inMinutes > 30; // More than 30 min before = "too early"
  }

  // Determine if video call uses inbuilt link (auto-generated) or 3rd party
  bool _isInbuiltVideoCall(Map<String, dynamic> s) {
    final mode = s['videoCallMode'] as String? ?? '';
    if (mode == '3rd Party') return false;
    if (mode == 'Inbuilt') return true;
    // Legacy: if meetingLink looks like an auto-generated one (meet.google.com/xxx-xxx-xxx pattern with short code)
    final link = s['meetingLink'] as String? ?? '';
    if (link.isEmpty) return true; // No link = inbuilt (will be generated)
    // If link was provided externally (zoom, teams, etc.) treat as 3rd party
    final isThirdParty =
        link.contains('zoom.us') ||
        link.contains('teams.microsoft') ||
        link.contains('webex') ||
        link.contains('skype');
    return !isThirdParty;
  }

  // Check if session can be completed based on type-specific rules
  // Returns null if can complete, or a String message explaining why not
  String? _canCompleteReason(Map<String, dynamic> s) {
    final type = s['type'] as String? ?? '';
    final status = s['status'] as String? ?? '';
    final scheduledDate = s['date'] as DateTime;
    final now = DateTime.now();

    if (status == 'Completed') return 'Session already completed';
    if (status == 'Cancelled') return 'Session is cancelled';

    if (type == 'Video Call') {
      final isInbuilt = _isInbuiltVideoCall(s);
      if (isInbuilt) {
        // Inbuilt: can only complete after start time AND only from live session (In Progress)
        if (status != 'In Progress') {
          if (now.isBefore(scheduledDate)) {
            return 'Video call must be started first. Session has not started yet.';
          }
          return 'Video call must be started first. Tap "Start Session" to begin.';
        }
        // In Progress — can complete
        return null;
      } else {
        // 3rd party: can complete anytime after scheduled time
        if (now.isBefore(scheduledDate)) {
          return 'Cannot complete before scheduled time (${_formatFullDateTime(scheduledDate)}).';
        }
        return null;
      }
    } else if (type == 'Call Back') {
      // Can only complete if a call was made today
      final callCount = s['callCount'] as int? ?? 0;
      final lastCallDate = s['lastCallDate'] as DateTime?;
      final today = DateTime(now.year, now.month, now.day);
      bool calledToday = false;
      if (lastCallDate != null) {
        final callDay = DateTime(
          lastCallDate.year,
          lastCallDate.month,
          lastCallDate.day,
        );
        calledToday = callDay == today;
      }
      // Also check if callCount > 0 and session was called today (fallback)
      if (callCount == 0 && !calledToday) {
        return 'Call Back can only be completed after making a call today. Tap "Call" first.';
      }
      if (callCount > 0 && !calledToday && lastCallDate == null) {
        // If callCount > 0 but no lastCallDate, allow (legacy data)
        return null;
      }
      if (!calledToday && callCount == 0) {
        return 'Call Back can only be completed after making a call today. Tap "Call" first.';
      }
      return null;
    } else if (type == 'Appointment') {
      // Can complete only after scheduled date and time
      if (now.isBefore(scheduledDate)) {
        return 'Appointment can only be completed after the scheduled time (${_formatFullDateTime(scheduledDate)}).';
      }
      return null;
    }
    return null;
  }

  // Compute completion status label
  String _completionStatusLabel(Map<String, dynamic> s) {
    final endedAt = s['endedAt'] as DateTime?;
    final scheduledDate = s['date'] as DateTime;
    if (endedAt == null) return '';
    // "On Time" = completed within the same calendar day as scheduled
    final scheduledDay = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );
    final completedDay = DateTime(endedAt.year, endedAt.month, endedAt.day);
    if (!completedDay.isAfter(scheduledDay)) return 'Completed On Time';
    return 'Completed After Due';
  }

  // Check if lead is starred
  bool _isLeadStarred(Map<String, dynamic> s) {
    final leadId = s['linkedLeadId'] as String? ?? '';
    final leadName = s['linkedLead'] as String? ?? '';
    if (leadId.isNotEmpty && globalStarredLeadIds.contains(leadId)) return true;
    // Also check by name
    final lead = leads_list.globalLeads.firstWhere(
      (m) => m['name'] == leadName,
      orElse: () => {},
    );
    if (lead.isNotEmpty) {
      return globalStarredLeadIds.contains(lead['id'] as String? ?? '');
    }
    return false;
  }

  void _showThreeDotsMenu(BuildContext context, Map<String, dynamic> s) {
    final preferred = (s['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = s['linkedLead'] as String;

    void checkPreferenceAndProceed(String action, VoidCallback onConfirm) {
      bool isPreferred = preferred.isEmpty || preferred.contains(action);
      if (!isPreferred) {
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
                    'Preference Mismatch',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              '$customerName has not preferred $action. Do you want to continue?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
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
                  onConfirm();
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
        onConfirm();
      }
    }

    void logAction(String actionKey) {
      final idx = globalSessionMaps.indexWhere((m) => m['id'] == s['id']);
      if (idx >= 0) {
        globalSessionMaps[idx][actionKey] =
            (globalSessionMaps[idx][actionKey] as int? ?? 0) + 1;
        s[actionKey] = (s[actionKey] as int? ?? 0) + 1;
      }
      widget.onUpdate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action logged for $customerName'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    void cancelSession() {
      // Ask for cancel reason
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
                  'Cancel Session',
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
                    hintText: 'e.g. Customer requested reschedule...',
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
                        final idx = globalSessionMaps.indexWhere(
                          (m) => m['id'] == s['id'],
                        );
                        if (idx >= 0) {
                          globalSessionMaps[idx]['status'] = 'Cancelled';
                          globalSessionMaps[idx]['cancelReason'] = reason;
                          globalSessionMaps[idx]['cancelledAt'] =
                              DateTime.now();
                          final existingNotes =
                              globalSessionMaps[idx]['notes'] as String? ?? '';
                          globalSessionMaps[idx]['notes'] =
                              existingNotes.isNotEmpty
                              ? '$existingNotes\nCancelled Reason: $reason'
                              : 'Cancelled Reason: $reason';
                        }
                        s['status'] = 'Cancelled';
                        s['cancelReason'] = reason;
                        s['cancelledAt'] = DateTime.now();
                        widget.onUpdate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Session cancelled'),
                            backgroundColor: AppTheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        // Ask if they want to reschedule
                        Future.delayed(const Duration(milliseconds: 400), () {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.event_repeat_rounded,
                                    color: AppTheme.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reschedule Session?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Session was cancelled.\nReason: $reason\n\nWould you like to reschedule with the same agenda?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => SafeArea(
                                        top: false,
                                        minimum: EdgeInsets.only(bottom: 8),
                                        child: _RescheduleFromCancelSheet(
                                          session: s,
                                          cancelReason: reason,
                                          onSave: (sessionData) {
                                            globalSessionMaps.insert(
                                              0,
                                              sessionData,
                                            );
                                            widget.onUpdate();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Session rescheduled successfully!',
                                                ),
                                                backgroundColor: AppTheme.success,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                  ),
                                  child: Text(
                                    'Yes, Reschedule',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: Text(
                  'Cancel Session',
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

    void showScheduledAction() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 8),
          child: _ScheduledActionSheet(
          session: s,
          onSave: (actionData) {
            final customerName = s['linkedLead'] as String;
            final customerId = s['linkedLeadId'] as String? ?? '';
            // Conflict check: customer already in another active session
            final conflict = globalSessionMaps.any((m) {
              if (m['id'] == s['id']) return false;
              final mStatus = m['status'] as String;
              if (mStatus == 'Completed' || mStatus == 'Cancelled') {
                return false;
              }
              final mLead = m['linkedLead'] as String;
              final mLeadId = m['linkedLeadId'] as String? ?? '';
              return mLead == customerName ||
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
                          'Customer Conflict',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    '$customerName is already in another active session. A customer cannot be in more than one active session at a time.',
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
            // Remove current session from global list
            globalSessionMaps.removeWhere((m) => m['id'] == s['id']);
            // Create new session from action data
            final newSession = {
              'id': 'ses-${DateTime.now().millisecondsSinceEpoch}',
              'title': '${actionData['type']} with $customerName',
              'type': actionData['type'] as String,
              'status': 'Scheduled',
              'date': actionData['date'] as DateTime,
              'host': actionData['assignedAgent'] as String? ?? s['host'],
              'hostInitials':
                  actionData['assignedAgentInitials'] as String? ??
                  s['hostInitials'],
              'participants': s['participants'],
              'linkedLead': customerName,
              'linkedLeadId': customerId,
              'customerPhone': s['customerPhone'] ?? '',
              'preferredContact': s['preferredContact'] ?? <String>[],
              'meetingLink': actionData['meetingLink'] as String? ?? '',
              'platform': actionData['type'] == 'Video Call'
                  ? 'Online'
                  : actionData['type'] == 'Appointment'
                  ? 'In-Person'
                  : 'Phone',
              'recording': false,
              'notes': actionData['notes'] as String? ?? '',
              'actionItems': <String>[],
              'outcome': '',
              'rating': 0,
              'agenda': '',
              'location': actionData['location'] as String? ?? '',
              'reminderSent': false,
              'followUpScheduled': false,
              'dealValue': s['dealValue'] ?? 0.0,
              'priority': s['priority'] ?? 'Medium',
              'createdAt': DateTime.now(),
              'videoCallCount': 0,
              'callCount': 0,
              'appointmentCount': 0,
              'isExistingCustomer': s['isExistingCustomer'] ?? false,
            };
            globalSessionMaps.insert(0, newSession);
            widget.onUpdate();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Session moved to next scheduled action'),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  // Star indicator if lead is important
                  if (_isLeadStarred(s)) ...[
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      customerName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
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
            _MenuTile(
              icon: Icons.info_outline_rounded,
              label: 'Session Details',
              color: AppTheme.primary,
              onTap: () {
                Navigator.pop(context);
                _showSessionDetailsSheet(context, s);
              },
            ),
            _MenuTile(
              icon: Icons.phone_rounded,
              label: 'Call',
              color: AppTheme.success,
              onTap: () {
                Navigator.pop(context);
                checkPreferenceAndProceed(
                  'Calls',
                  () => logAction('callCount'),
                );
              },
            ),
            _MenuTile(
              icon: Icons.videocam_rounded,
              label: 'Video Call',
              color: const Color(0xFF0891B2),
              onTap: () {
                Navigator.pop(context);
                checkPreferenceAndProceed(
                  'Video Call',
                  () => logAction('videoCallCount'),
                );
              },
            ),
            if (s['status'] != 'Completed' && s['status'] != 'Cancelled')
              _DisabledMenuTile(
                icon: Icons.calendar_month_rounded,
                label: 'Reschedule Action (Complete session first)',
                color: AppTheme.textMuted,
              )
            else
              _MenuTile(
                icon: Icons.calendar_month_rounded,
                label: 'Reschedule Action',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.pop(context);
                  showScheduledAction();
                },
              ),
            if (s['status'] != 'Completed' && s['status'] != 'Cancelled')
              _MenuTile(
                icon: Icons.cancel_rounded,
                label: 'Cancel Session',
                color: AppTheme.error,
                onTap: () {
                  Navigator.pop(context);
                  cancelSession();
                },
              )
            else if (s['status'] == 'Cancelled')
              _DisabledMenuTile(
                icon: Icons.cancel_rounded,
                label: 'Already Cancelled',
                color: AppTheme.textMuted,
              )
            else
              _DisabledMenuTile(
                icon: Icons.cancel_rounded,
                label: 'Cannot cancel completed session',
                color: AppTheme.textMuted,
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );
  }

  void _startSession(BuildContext context, Map<String, dynamic> s) {
    // Show warning if starting too early, but allow to proceed
    if (_isStartingEarly(s)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.schedule_rounded, color: AppTheme.warning, size: 22),
              const SizedBox(width: 8),
              Text(
                'Starting Too Early',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Text(
            'You are starting too early. The session is scheduled for ${_formatFullDateTime(s['date'] as DateTime)}.\n\nDo you want to continue anyway?',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'No, go back',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _doStartSession(context, s);
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.warning),
              child: Text(
                'Yes, continue',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
      return;
    }
    _doStartSession(context, s);
  }

  void _doStartSession(BuildContext context, Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.play_circle_rounded, color: AppTheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Start Session',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Start "${s['title']}" with ${s['linkedLead']}?',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final idx = globalSessionMaps.indexWhere(
                (m) => m['id'] == s['id'],
              );
              if (idx >= 0) {
                globalSessionMaps[idx]['status'] = 'In Progress';
                globalSessionMaps[idx]['startedAt'] = DateTime.now();
                globalSessionMaps[idx]['videoCallCount'] =
                    (globalSessionMaps[idx]['videoCallCount'] as int? ?? 0) + 1;
              }
              s['status'] = 'In Progress';
              s['startedAt'] = DateTime.now();
              widget.onUpdate();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Session started!'),
                  backgroundColor: AppTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
            child: Text(
              'Start',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _endSession(BuildContext context, Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _CompleteSessionSheet(
          session: s,
          onComplete:
            (
              outcome,
              rating,
              notes,
              scheduleFollowUp,
              followUpDate,
              nextActionType,
            ) {
              final endTime = DateTime.now();
              final idx = globalSessionMaps.indexWhere(
                (m) => m['id'] == s['id'],
              );
              if (idx >= 0) {
                globalSessionMaps[idx]['status'] = 'Completed';
                globalSessionMaps[idx]['outcome'] = outcome;
                globalSessionMaps[idx]['rating'] = rating;
                globalSessionMaps[idx]['notes'] = notes;
                globalSessionMaps[idx]['endedAt'] = endTime;
                globalSessionMaps[idx]['followUpScheduled'] = scheduleFollowUp;
                if (scheduleFollowUp && followUpDate != null) {
                  globalSessionMaps[idx]['followUpDate'] = followUpDate;
                  globalSessionMaps[idx]['rescheduledSessionType'] =
                      nextActionType ?? 'Appointment';
                  globalSessionMaps[idx]['rescheduledSessionDate'] =
                      followUpDate;
                  // Create new scheduled session
                  final cName = s['linkedLead'] as String;
                  final cId = s['linkedLeadId'] as String? ?? '';
                  final fuType = nextActionType ?? 'Appointment';
                  final newSession = {
                    'id': 'ses-next-${DateTime.now().millisecondsSinceEpoch}',
                    'title': '$fuType with $cName',
                    'type': fuType == 'Follow Up' ? 'Appointment' : fuType,
                    'status': 'Scheduled',
                    'date': followUpDate,
                    'host': s['host'] as String,
                    'hostInitials': s['hostInitials'] as String,
                    'participants': s['participants'],
                    'linkedLead': cName,
                    'linkedLeadId': cId,
                    'customerPhone': s['customerPhone'] ?? '',
                    'preferredContact': s['preferredContact'] ?? <String>[],
                    'meetingLink': fuType == 'Video Call'
                        ? 'meet.google.com/${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}'
                        : '',
                    'platform': fuType == 'Video Call'
                        ? 'Online'
                        : fuType == 'Appointment'
                        ? 'In-Person'
                        : 'Phone',
                    'recording': false,
                    'notes': 'Follow-up from completed session: ${s['title']}',
                    'actionItems': <String>[],
                    'outcome': '',
                    'rating': 0,
                    'agenda': '',
                    'location': '',
                    'reminderSent': false,
                    'followUpScheduled': false,
                    'dealValue': s['dealValue'] ?? 0.0,
                    'priority': s['priority'] ?? 'Medium',
                    'createdAt': DateTime.now(),
                    'videoCallCount': 0,
                    'callCount': 0,
                    'appointmentCount': 0,
                    'isExistingCustomer': s['isExistingCustomer'] ?? false,
                    'rescheduledFromId': s['id'],
                    'interestTags': s['interestTags'] ?? <String>[],
                  };
                  globalSessionMaps.insert(0, newSession);
                  // Also create follow-up
                  final newFu = {
                    'id': 'fu-ses-${DateTime.now().millisecondsSinceEpoch}',
                    'title': 'Follow up after session: ${s['title']}',
                    'type': fuType == 'Follow Up' ? 'Calls' : fuType,
                    'status': 'Upcoming',
                    'priority': 'High',
                    'dueDate': followUpDate,
                    'assignedAgent': s['host'] as String,
                    'agentInitials': s['hostInitials'] as String,
                    'linkedLead': cName,
                    'linkedLeadId': cId,
                    'customerPhone': s['customerPhone'] as String? ?? '',
                    'notes':
                        'Post-session follow-up. Outcome: $outcome. Next action: $fuType',
                    'outcome': '',
                    'isRecurring': false,
                    'recurringFrequency': 'Custom',
                    'isOverdue': false,
                    'completedAt': null,
                    'createdAt': DateTime.now(),
                    'tags': <String>[],
                    'preferredContact': ['Calls'],
                    'contactMethod': 'Calls',
                    'reminderBefore': '1 hour',
                    'isExistingCustomer': false,
                    'callsDone': 0,
                    'messagesDone': 0,
                    'whatsappDone': 0,
                    'emailDone': 0,
                    'videoDone': 0,
                    'upcomingFollowUps': <String>[],
                    'linkedSessionId': s['id'],
                  };
                  fu_screen.globalFollowUpMaps.add(newFu);
                }
              }
              s['status'] = 'Completed';
              s['outcome'] = outcome;
              s['rating'] = rating;
              s['notes'] = notes;
              s['endedAt'] = endTime;
              _logSessionActivityToLead(
                s['linkedLeadId'] as String? ?? '',
                s['linkedLead'] as String,
                'Session Completed',
                'Session completed. Outcome: $outcome. Rating: $rating/5',
              );
              // Mark linked reminder as completed too (interconnected logic)
              final sesId = s['id'] as String? ?? '';
              if (sesId.isNotEmpty) {
                for (final rem in globalReminderMaps) {
                  if (rem['linkedSessionId'] == sesId) {
                    rem['isCompleted'] = true;
                    rem['status'] = 'Completed';
                  }
                }
              }
              widget.onUpdate();
            },
        ),
        ),
      );
  }

  void _showSessionDetailsSheet(BuildContext context, Map<String, dynamic> s) {
    final statusColor = _statusColor(s['status'] as String);
    final typeColor = _typeColor(s['type'] as String);
    final rating = s['rating'] as int;
    final actionItems = (s['actionItems'] as List).cast<String>();
    final participants = (s['participants'] as List).cast<String>();
    final agent = _agentByName(s['host'] as String);
    final startedAt = s['startedAt'] as DateTime?;
    final endedAt = s['endedAt'] as DateTime?;
    final duration = _computedDuration(startedAt, endedAt);
    final videoCallCount = s['videoCallCount'] as int? ?? 0;
    final callCount = s['callCount'] as int? ?? 0;
    final appointmentCount = s['appointmentCount'] as int? ?? 0;
    final cancelReason = s['cancelReason'] as String? ?? '';
    final notes = s['notes'] as String? ?? '';

    void showScheduledAction() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 8),
          child: _ScheduledActionSheet(
          session: s,
          onSave: (actionData) {
            final customerName = s['linkedLead'] as String;
            final customerId = s['linkedLeadId'] as String? ?? '';
            final conflict = globalSessionMaps.any((m) {
              if (m['id'] == s['id']) return false;
              final mStatus = m['status'] as String;
              if (mStatus == 'Completed' ||
                  mStatus == 'Cancelled' ||
                  mStatus == 'Rescheduled') {
                return false;
              }
              final mLead = m['linkedLead'] as String;
              final mLeadId = m['linkedLeadId'] as String? ?? '';
              return mLead == customerName ||
                  (customerId.isNotEmpty && mLeadId == customerId);
            });
            if (conflict) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Customer Conflict',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: Text(
                    '$customerName is already in another active session.',
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
              return;
            }
            final isActiveSession =
                s['status'] != 'Completed' && s['status'] != 'Cancelled';
            final idx = globalSessionMaps.indexWhere((m) => m['id'] == s['id']);
            if (idx >= 0) {
              globalSessionMaps[idx]['rescheduledSessionType'] =
                  actionData['type'] as String;
              globalSessionMaps[idx]['rescheduledSessionDate'] =
                  actionData['date'] as DateTime;
              if (isActiveSession) {
                // Mark original as Rescheduled (keep in list with tag)
                globalSessionMaps[idx]['status'] = 'Rescheduled';
                globalSessionMaps[idx]['rescheduleReason'] =
                    actionData['rescheduleReason'] as String? ?? '';
              }
            }
            if (!isActiveSession) {
              globalSessionMaps.removeWhere((m) => m['id'] == s['id']);
            }
            final newSession = {
              'id': 'ses-${DateTime.now().millisecondsSinceEpoch}',
              'title': '${actionData['type']} with $customerName',
              'type': actionData['type'] as String,
              'status': 'Scheduled',
              'date': actionData['date'] as DateTime,
              'host': actionData['assignedAgent'] as String? ?? s['host'],
              'hostInitials':
                  actionData['assignedAgentInitials'] as String? ??
                  s['hostInitials'],
              'participants': s['participants'],
              'linkedLead': customerName,
              'linkedLeadId': customerId,
              'customerPhone': s['customerPhone'] ?? '',
              'preferredContact': s['preferredContact'] ?? <String>[],
              'meetingLink': actionData['meetingLink'] as String? ?? '',
              'videoCallMode':
                  actionData['videoCallMode'] as String? ?? 'Inbuilt',
              'platform': actionData['type'] == 'Video Call'
                  ? 'Online'
                  : actionData['type'] == 'Appointment'
                  ? 'In-Person'
                  : 'Phone',
              'recording': false,
              'notes': actionData['notes'] as String? ?? '',
              'actionItems': <String>[],
              'outcome': '',
              'rating': 0,
              'agenda': '',
              'location': actionData['location'] as String? ?? '',
              'reminderSent': false,
              'followUpScheduled': false,
              'dealValue': s['dealValue'] ?? 0.0,
              'priority': s['priority'] ?? 'Medium',
              'createdAt': DateTime.now(),
              'videoCallCount': 0,
              'callCount': 0,
              'appointmentCount': 0,
              'isExistingCustomer': s['isExistingCustomer'] ?? false,
              'rescheduledFromId': s['id'],
              'interestTags': s['interestTags'] ?? <String>[],
            };
            globalSessionMaps.insert(0, newSession);
            _logSessionActivityToLead(
              s['linkedLeadId'] as String? ?? '',
              customerName,
              'Session Rescheduled',
              'Session rescheduled to ${actionData['type']} on ${_formatFullDateTime(actionData['date'] as DateTime)}',
            );
            widget.onUpdate();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Session moved to next scheduled action'),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
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
        minimum: EdgeInsets.only(bottom: 8),
        child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Back button — goes back to actions sheet
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showActionsBottomSheet(context, s);
                      },
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      color: AppTheme.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: typeColor.withAlpha(31),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _typeIcon(s['type'] as String),
                        color: typeColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  s['status'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  s['type'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: typeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surface100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppTheme.surface200),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Customer info
                    if ((s['linkedLead'] as String).isNotEmpty) ...[
                      _SDetailSection(title: 'Customer'),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppTheme.primary.withAlpha(40),
                              child: Text(
                                (s['linkedLead'] as String).isNotEmpty
                                    ? (s['linkedLead'] as String)[0]
                                    : '?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s['linkedLead'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                      if (_isLeadStarred(s)) ...[
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 14,
                                          color: Color(0xFFF59E0B),
                                        ),
                                        Text(
                                          ' Important',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: Color(0xFFB45309),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if ((s['customerPhone'] as String? ?? '')
                                      .isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_rounded,
                                          size: 12,
                                          color: AppTheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          s['customerPhone'] as String,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Host
                    _SDetailSection(title: 'Assigned Host'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: agent.color.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: agent.color.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: agent.color.withAlpha(40),
                            child: Text(
                              agent.initials,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: agent.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agent.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${agent.role} · ${agent.id}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                if (agent.phone.isNotEmpty)
                                  Text(
                                    agent.phone,
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
                    ),
                    const SizedBox(height: 16),
                    // Session details
                    _SDetailSection(title: 'Session Details'),
                    _SDetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Scheduled',
                      value: _formatFullDateTime(s['date'] as DateTime),
                    ),
                    if (startedAt != null)
                      _SDetailRow(
                        icon: Icons.play_arrow_rounded,
                        label: 'Started',
                        value: _formatFullDateTime(startedAt),
                      ),
                    if (endedAt != null)
                      _SDetailRow(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Completed',
                        value: _formatFullDateTime(endedAt),
                      ),
                    if (duration.isNotEmpty)
                      _SDetailRow(
                        icon: Icons.timer_outlined,
                        label: 'Duration',
                        value: duration,
                      ),
                    _SDetailRow(
                      icon: Icons.devices_rounded,
                      label: 'Platform',
                      value: s['platform'] as String,
                    ),
                    if ((s['location'] as String? ?? '').isNotEmpty)
                      _SDetailRow(
                        icon: Icons.location_on_rounded,
                        label: 'Location',
                        value: s['location'] as String,
                      ),
                    if ((s['agenda'] as String? ?? '').isNotEmpty)
                      _SDetailRow(
                        icon: Icons.assignment_rounded,
                        label: 'Title',
                        value: s['agenda'] as String,
                      ),
                    if (participants.isNotEmpty)
                      _SDetailRow(
                        icon: Icons.group_rounded,
                        label: 'Participants',
                        value: participants.join(', '),
                      ),
                    if ((s['meetingLink'] as String? ?? '').isNotEmpty)
                      _SDetailRow(
                        icon: Icons.link_rounded,
                        label: 'Meeting Link',
                        value: s['meetingLink'] as String,
                      ),
                    if (s['recording'] == true)
                      _SDetailRow(
                        icon: Icons.fiber_manual_record_rounded,
                        label: 'Recording',
                        value: 'Available',
                      ),
                    const SizedBox(height: 16),
                    // Interest Tags in session details
                    if ((s['interestTags'] as List?)?.isNotEmpty == true) ...[
                      _SDetailSection(title: 'Interest Tags'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children:
                            ((s['interestTags'] as List?)?.cast<String>() ?? [])
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF0891B2,
                                      ).withAlpha(15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF0891B2,
                                        ).withAlpha(50),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF0891B2),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Contact attempt counters
                    _SDetailSection(title: 'Contact Attempts'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (videoCallCount > 0)
                          _CountBadge(
                            icon: Icons.videocam_rounded,
                            label: 'Video Call: $videoCallCount',
                            color: const Color(0xFF0891B2),
                          ),
                        if (callCount > 0)
                          _CountBadge(
                            icon: Icons.phone_rounded,
                            label: 'Call: $callCount',
                            color: AppTheme.success,
                          ),
                        if (appointmentCount > 0)
                          _CountBadge(
                            icon: Icons.people_rounded,
                            label: 'Appointment: $appointmentCount',
                            color: const Color(0xFF8B5CF6),
                          ),
                        if (videoCallCount == 0 &&
                            callCount == 0 &&
                            appointmentCount == 0)
                          Text(
                            'No contact attempts yet',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Rating
                    if (rating > 0) ...[
                      _SDetailSection(title: 'Rating'),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 24,
                            color: AppTheme.warning,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Outcome
                    if ((s['outcome'] as String? ?? '').isNotEmpty) ...[
                      _SDetailSection(title: 'Outcome'),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.success.withAlpha(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              size: 16,
                              color: AppTheme.success,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                s['outcome'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Notes — only show when session is Completed AND notes were written
                    if (s['status'] == 'Completed' && notes.isNotEmpty) ...[
                      _SDetailSection(title: 'Notes'),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surface100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          notes,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // ── Status Section ──────────────────────────────────
                    _SDetailSection(title: 'Status'),
                    _buildDetailsCompletionStatus(s),
                    const SizedBox(height: 16),
                    // ── Next Schedule (shown when rescheduled session exists) ──
                    if ((s['rescheduledSessionType'] as String? ?? '')
                        .isNotEmpty) ...[
                      _SDetailSection(title: 'Next Schedule'),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6).withAlpha(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_repeat_rounded,
                              size: 16,
                              color: const Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['rescheduledSessionType'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                  if (s['rescheduledSessionDate'] != null)
                                    Text(
                                      _formatFullDateTime(
                                        s['rescheduledSessionDate'] as DateTime,
                                      ),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withAlpha(180),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // ── See Customer / See Lead Links ────────────────────
                    _SDetailSection(title: 'Quick Links'),
                    const SizedBox(height: 4),
                    if ((s['linkedLead'] as String? ?? '').isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to customers screen
                          context.go(AppRoutes.customersScreen);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primary.withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                size: 18,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'See Customer Details',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      s['linkedLead'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.primary.withAlpha(180),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppTheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if ((s['linkedLeadId'] as String? ?? '').isNotEmpty ||
                        (s['linkedLead'] as String? ?? '').isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          // Find the lead in globalLeads by id or name
                          final leadId = s['linkedLeadId'] as String? ?? '';
                          final leadName = s['linkedLead'] as String? ?? '';
                          final leadMap = leads_list.globalLeads.firstWhere(
                            (m) =>
                                (leadId.isNotEmpty && m['id'] == leadId) ||
                                m['name'] == leadName,
                            orElse: () => {},
                          );
                          Navigator.pop(context);
                          if (leadMap.isNotEmpty) {
                            final lead = leads_list.LeadModel.fromMap(leadMap);
                            context.push(
                              AppRoutes.leadDetailScreen,
                              extra: lead,
                            );
                          } else {
                            // Fallback: go to leads list
                            context.go(AppRoutes.leadsListScreen);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withAlpha(15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6).withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.leaderboard_rounded,
                                size: 18,
                                color: const Color(0xFF8B5CF6),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'See Lead Details',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF8B5CF6),
                                      ),
                                    ),
                                    Text(
                                      '${s['linkedLead']} — Lead Profile',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withAlpha(180),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
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

  Widget _buildDetailsCompletionStatus(Map<String, dynamic> s) {
    final status = s['status'] as String? ?? '';
    final date = s['date'] as DateTime;
    final endedAt = s['endedAt'] as DateTime?;
    final cancelReason = s['cancelReason'] as String? ?? '';
    final now = DateTime.now();

    if (status == 'Completed' && endedAt != null) {
      // "On Time" = completed within the same calendar day as scheduled
      final scheduledDay = DateTime(date.year, date.month, date.day);
      final completedDay = DateTime(endedAt.year, endedAt.month, endedAt.day);
      final isOnTime = !completedDay.isAfter(scheduledDay);
      final label = isOnTime ? 'Completed On Time' : 'Completed After Due';
      final color = isOnTime ? AppTheme.success : AppTheme.warning;
      final icon = isOnTime
          ? Icons.check_circle_rounded
          : Icons.schedule_rounded;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    'Completed at ${_formatFullDateTime(endedAt)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: color.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (status == 'Cancelled') {
      final isAfterDue = date.isBefore(now);
      final label = isAfterDue ? 'Cancelled After Due' : 'Cancelled Before Due';
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cancel_rounded, size: 18, color: AppTheme.error),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
            if (cancelReason.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Reason: $cancelReason',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.error.withAlpha(200),
                ),
              ),
            ],
          ],
        ),
      );
    } else if (status == 'In Progress') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withAlpha(50)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'In Progress — Session is Live',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      );
    } else {
      // Scheduled — show Today, Due, or Scheduled
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(date.year, date.month, date.day);
      String label;
      Color color;
      IconData icon;
      if (d == today) {
        label = 'Today';
        color = AppTheme.primary;
        icon = Icons.today_rounded;
      } else if (date.isBefore(now)) {
        label = 'Due';
        color = const Color(0xFFDC2626);
        icon = Icons.warning_amber_rounded;
      } else {
        label = 'Scheduled';
        color = AppTheme.primary;
        icon = Icons.event_rounded;
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    _formatFullDateTime(date),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: color.withAlpha(180),
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

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final statusColor = _computedStatusColor(s);
    final statusLabel = _computedStatusLabel(s);
    final typeColor = _typeColor(s['type'] as String);
    final rating = s['rating'] as int;
    final isInProgress = s['status'] == 'In Progress';
    final isVideoCall = s['type'] == 'Video Call';
    final isCancelled = s['status'] == 'Cancelled';
    final isRescheduled = s['status'] == 'Rescheduled';
    final startedAt = s['startedAt'] as DateTime?;
    final endedAt = s['endedAt'] as DateTime?;
    final duration = _computedDuration(startedAt, endedAt);
    final videoCallCount = s['videoCallCount'] as int? ?? 0;
    final callCount = s['callCount'] as int? ?? 0;
    final appointmentCount = s['appointmentCount'] as int? ?? 0;
    final hasAttempts = videoCallCount + callCount + appointmentCount > 0;
    final isStarred = _isLeadStarred(s);
    final interestTags = (s['interestTags'] as List?)?.cast<String>() ?? [];
    final isExistingCustomer = s['isExistingCustomer'] == true;
    final cancelReason = s['cancelReason'] as String? ?? '';
    final isInbuilt = _isInbuiltVideoCall(s);

    // For video sessions, show multiple participants
    final participants = (s['participants'] as List?)?.cast<String>() ?? [];
    String displayLead = s['linkedLead'] as String;
    if (isVideoCall && participants.length > 1) {
      final first = participants.first;
      final others = participants.length - 1;
      displayLead = '$first +$others other${others > 1 ? 's' : ''}';
    }

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _showActionsBottomSheet(context, s),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isInProgress
                        ? AppTheme.error.withAlpha(80)
                        : isCancelled
                        ? AppTheme.error.withAlpha(40)
                        : isRescheduled
                        ? const Color(0xFF8B5CF6).withAlpha(60)
                        : AppTheme.surface200,
                    width: isInProgress ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isStarred
                          ? const Color(0xFFF59E0B).withAlpha(25)
                          : Colors.black.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // In Progress LIVE banner
                    if (isInProgress)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withAlpha(20),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'LIVE — In Progress',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.error,
                              ),
                            ),
                            const Spacer(),
                            if (startedAt != null)
                              Text(
                                'Started ${_formatDate(startedAt)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                    // Cancelled banner with red flag
                    if (isCancelled)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withAlpha(15),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              size: 14,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cancelled',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.error,
                              ),
                            ),
                            if (cancelReason.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '· $cancelReason',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: AppTheme.error.withAlpha(180),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    // Rescheduled banner
                    if (isRescheduled)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withAlpha(15),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event_repeat_rounded,
                              size: 14,
                              color: Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Rescheduled',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                            if ((s['rescheduleReason'] as String? ?? '')
                                .isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '· ${s['rescheduleReason']}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: const Color(
                                      0xFF8B5CF6,
                                    ).withAlpha(180),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
                                  _typeIcon(s['type'] as String),
                                  color: typeColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (isStarred) ...[
                                          const Icon(
                                            Icons.star_rounded,
                                            size: 13,
                                            color: Color(0xFFF59E0B),
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        Expanded(
                                          child: Text(
                                            s['title'] as String,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
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
                                            displayLead,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: AppTheme.textSecondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((s['customerPhone'] as String? ?? '')
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
                                              s['customerPhone'] as String,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
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
                              _buildCardStatusBadge(
                                s,
                                statusLabel,
                                statusColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _InfoChip(
                                icon: Icons.access_time_rounded,
                                label: _formatDate(s['date'] as DateTime),
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              if (isVideoCall && duration.isNotEmpty) ...[
                                _InfoChip(
                                  icon: Icons.timer_outlined,
                                  label: duration,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: _InfoChip(
                                  icon: Icons.person_rounded,
                                  label: s['host'] as String,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _TypeBadge(
                                label: s['type'] as String,
                                color: typeColor,
                              ),
                              const Spacer(),
                              if (isExistingCustomer)
                                Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF059669,
                                    ).withAlpha(15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF059669,
                                      ).withAlpha(60),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 10,
                                        color: Color(0xFF059669),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Existing Customer',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF059669),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (s['recording'] == true)
                                _InfoChip(
                                  icon: Icons.fiber_manual_record_rounded,
                                  label: 'Rec',
                                  color: AppTheme.error,
                                ),
                              if (rating > 0) ...[
                                const SizedBox(width: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < rating
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 12,
                                      color: AppTheme.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // Interest tags — below type badge row
                          if (interestTags.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: interestTags
                                    .map(
                                      (tag) => Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF0891B2,
                                          ).withAlpha(15),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF0891B2,
                                            ).withAlpha(50),
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF0891B2),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                          // Video Call card actions: Start Session (inbuilt only when Scheduled)
                          if (isVideoCall &&
                              s['status'] == 'Scheduled' &&
                              isInbuilt) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _startSession(context, s),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withAlpha(15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.primary.withAlpha(60),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_circle_rounded,
                                      size: 14,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Start Session',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          // Go to Video link for live in-progress video calls
                          if (isInProgress &&
                              isVideoCall &&
                              (s['meetingLink'] as String? ?? '')
                                  .isNotEmpty) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Opening: ${s['meetingLink']}',
                                    ),
                                    backgroundColor: AppTheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.error.withAlpha(15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.error.withAlpha(60),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Go to Video',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.error,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.open_in_new_rounded,
                                      size: 12,
                                      color: AppTheme.error,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if ((s['outcome'] as String? ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    size: 13,
                                    color: AppTheme.success,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      s['outcome'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStatusBadge(
    Map<String, dynamic> s,
    String statusLabel,
    Color statusColor,
  ) {
    final endedAt = s['endedAt'] as DateTime?;
    final cancelledAt = s['cancelledAt'] as DateTime?;
    final isCompleted = s['status'] == 'Completed';
    final isCancelled = s['status'] == 'Cancelled';
    if (isCompleted && endedAt != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatDate(endedAt),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: statusColor.withAlpha(180),
            ),
          ),
        ],
      );
    }
    if (isCancelled) {
      // Show actual cancelled date if available, else use current time as fallback
      final displayDate = cancelledAt ?? DateTime.now();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Cancelled',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatDate(displayDate),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              color: statusColor.withAlpha(180),
            ),
          ),
        ],
      );
    }
    // For non-completed, non-cancelled: show status badge with scheduled date/time
    final date = s['date'] as DateTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusBadge(label: statusLabel, color: statusColor),
        const SizedBox(height: 2),
        Text(
          _formatDate(date),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9,
            color: statusColor.withAlpha(160),
          ),
        ),
      ],
    );
  }

  Widget _buildCardStatusTag(Map<String, dynamic> s) {
    final status = s['status'] as String? ?? '';
    final date = s['date'] as DateTime;
    final endedAt = s['endedAt'] as DateTime?;
    final cancelReason = s['cancelReason'] as String? ?? '';
    final now = DateTime.now();

    if (status == 'Completed' && endedAt != null) {
      // "On Time" = completed within the same calendar day as scheduled
      final scheduledDay = DateTime(date.year, date.month, date.day);
      final completedDay = DateTime(endedAt.year, endedAt.month, endedAt.day);
      final isOnTime = !completedDay.isAfter(scheduledDay);
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
      final isAfterDue = date.isBefore(now);
      final label = isAfterDue ? 'Cancelled After Due' : 'Cancelled Before Due';
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
    } else if (status == 'In Progress') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.error.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'In Progress',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      );
    } else {
      // Scheduled — show Today or Due
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(date.year, date.month, date.day);
      if (d == today) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primary.withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.today_rounded, size: 11, color: AppTheme.primary),
              const SizedBox(width: 4),
              Text(
                'Today',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        );
      } else if (date.isBefore(now)) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDC2626).withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 11,
                color: const Color(0xFFDC2626),
              ),
              const SizedBox(width: 4),
              Text(
                'Due',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primary.withAlpha(40)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_rounded, size: 11, color: AppTheme.primary),
              const SizedBox(width: 4),
              Text(
                'Scheduled',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildInlineActionsPanel(
    BuildContext context,
    Map<String, dynamic> s,
  ) {
    final preferred = (s['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = s['linkedLead'] as String;
    final leadMap = leads_list.globalLeads.firstWhere(
      (m) => m['id'] == s['linkedLeadId'] || m['name'] == customerName,
      orElse: () => {},
    );
    final hasInstagram = (leadMap['instagram'] as String? ?? '').isNotEmpty;
    final hasFacebook = (leadMap['facebook'] as String? ?? '').isNotEmpty;
    final hasTwitter = (leadMap['twitter'] as String? ?? '').isNotEmpty;
    final hasTelegram = (leadMap['telegram'] as String? ?? '').isNotEmpty;

    void logAction(String actionKey) {
      final idx = globalSessionMaps.indexWhere((m) => m['id'] == s['id']);
      if (idx >= 0) {
        globalSessionMaps[idx][actionKey] =
            (globalSessionMaps[idx][actionKey] as int? ?? 0) + 1;
        s[actionKey] = (s[actionKey] as int? ?? 0) + 1;
      }
      widget.onUpdate();
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
              'Preference Mismatch',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              '$customerName has not preferred $action. Continue?',
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
                  logAction(actionKey);
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
        logAction(actionKey);
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
        logAction(actionKey);
      }
    }

    void cancelSession() {
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
                  'Cancel Session',
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
                    hintText: 'e.g. Customer requested reschedule...',
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
                        final idx = globalSessionMaps.indexWhere(
                          (m) => m['id'] == s['id'],
                        );
                        if (idx >= 0) {
                          globalSessionMaps[idx]['status'] = 'Cancelled';
                          globalSessionMaps[idx]['cancelReason'] = reason;
                          globalSessionMaps[idx]['cancelledAt'] =
                              DateTime.now();
                        }
                        s['status'] = 'Cancelled';
                        s['cancelReason'] = reason;
                        s['cancelledAt'] = DateTime.now();
                        setState(() => _actionsExpanded = false);
                        widget.onUpdate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Session cancelled'),
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
                  'Cancel Session',
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
                onTap: () => checkPreferenceAndLog('Calls', 'callCount'),
              ),
              _ActionBtn(
                icon: Icons.message_rounded,
                label: 'Message',
                color: const Color(0xFF8B5CF6),
                onTap: () => logAction('messageCount'),
              ),
              _ActionBtn(
                icon: Icons.chat_rounded,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => logAction('whatsappCount'),
              ),
              _ActionBtn(
                icon: Icons.email_rounded,
                label: 'Email',
                color: AppTheme.primary,
                onTap: () => logAction('emailCount'),
              ),
              _ActionBtn(
                icon: Icons.videocam_rounded,
                label: 'Video Call',
                color: const Color(0xFF0891B2),
                onTap: () =>
                    checkPreferenceAndLog('Video Call', 'videoCallCount'),
              ),
              _ActionBtn(
                icon: Icons.camera_alt_rounded,
                label: 'Instagram',
                color: hasInstagram
                    ? const Color(0xFFE1306C)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Instagram', hasInstagram, 'instagramCount'),
              ),
              _ActionBtn(
                icon: Icons.facebook_rounded,
                label: 'Facebook',
                color: hasFacebook
                    ? const Color(0xFF1877F2)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Facebook', hasFacebook, 'facebookCount'),
              ),
              _ActionBtn(
                icon: Icons.close_rounded,
                label: 'X (Twitter)',
                color: hasTwitter
                    ? const Color(0xFF000000)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('X (Twitter)', hasTwitter, 'twitterCount'),
              ),
              _ActionBtn(
                icon: Icons.send_rounded,
                label: 'Telegram',
                color: hasTelegram
                    ? const Color(0xFF0088CC)
                    : AppTheme.textMuted,
                onTap: () =>
                    doSocialAction('Telegram', hasTelegram, 'telegramCount'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (s['status'] != 'Completed' && s['status'] != 'Cancelled')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _endSession(context, s);
                },
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (s['status'] != 'Completed' && s['status'] != 'Cancelled') ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  cancelSession();
                },
                icon: const Icon(Icons.cancel_outlined, size: 16),
                label: Text(
                  'Cancel Session',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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

  void _showActionsBottomSheet(BuildContext context, Map<String, dynamic> s) {
    final preferred = (s['preferredContact'] as List?)?.cast<String>() ?? [];
    final customerName = s['linkedLead'] as String;
    final leadMap = leads_list.globalLeads.firstWhere(
      (m) => m['id'] == s['linkedLeadId'] || m['name'] == customerName,
      orElse: () => {},
    );
    // Check social data from both session map and lead map
    final hasInstagram =
        (s['instagram'] as String? ?? '').isNotEmpty ||
        (leadMap['instagram'] as String? ?? '').isNotEmpty;
    final hasFacebook =
        (s['facebook'] as String? ?? '').isNotEmpty ||
        (leadMap['facebook'] as String? ?? '').isNotEmpty;
    final hasTwitter =
        (s['twitter'] as String? ?? '').isNotEmpty ||
        (leadMap['twitter'] as String? ?? '').isNotEmpty;
    final hasTelegram =
        (s['telegram'] as String? ?? '').isNotEmpty ||
        (leadMap['telegram'] as String? ?? '').isNotEmpty;

    // Determine if session is frozen (completed, cancelled, or rescheduled old)
    final isFrozen =
        s['status'] == 'Completed' ||
        s['status'] == 'Cancelled' ||
        s['status'] == 'Rescheduled';

    void logAction(String actionKey, String actionLabel) {
      if (isFrozen) return; // Don't update counts for frozen sessions
      final idx = globalSessionMaps.indexWhere((m) => m['id'] == s['id']);
      if (idx >= 0) {
        globalSessionMaps[idx][actionKey] =
            (globalSessionMaps[idx][actionKey] as int? ?? 0) + 1;
        s[actionKey] = (s[actionKey] as int? ?? 0) + 1;
        if (actionKey == 'callCount') {
          globalSessionMaps[idx]['lastCallDate'] = DateTime.now();
          s['lastCallDate'] = DateTime.now();
        }
      }
      _logSessionActivityToLead(
        s['linkedLeadId'] as String? ?? '',
        customerName,
        actionLabel,
        '$actionLabel action performed for session: ${s['title']}',
      );
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

    // Show template picker for messaging actions — opens WhatsApp for WhatsApp action
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
          minimum: EdgeInsets.only(bottom: 8),
          child: _TemplatePickerSheet(
            actionLabel: actionLabel,
            templates: templates,
            customerName: customerName,
            isWhatsApp: platform?.toLowerCase() == 'whatsapp',
            onUseTemplate: (templateBody) {
              logAction(actionKey, actionLabel);
            },
            onCustomMessage: () {
              logAction(actionKey, actionLabel);
            },
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
              'Preference Mismatch',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Text(
              '$customerName has not preferred $action. Continue?',
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
                      action == 'Message' ||
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
        if (action == 'WhatsApp Messages' ||
            action == 'Message' ||
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

    void cancelSession() {
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
                  'Cancel Session',
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
                    hintText: 'e.g. Customer requested reschedule...',
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
                        final idx = globalSessionMaps.indexWhere(
                          (m) => m['id'] == s['id'],
                        );
                        if (idx >= 0) {
                          globalSessionMaps[idx]['status'] = 'Cancelled';
                          globalSessionMaps[idx]['cancelReason'] = reason;
                          globalSessionMaps[idx]['cancelledAt'] =
                              DateTime.now();
                        }
                        s['status'] = 'Cancelled';
                        s['cancelReason'] = reason;
                        s['cancelledAt'] = DateTime.now();
                        _logSessionActivityToLead(
                          s['linkedLeadId'] as String? ?? '',
                          customerName,
                          'Session Cancelled',
                          'Session cancelled. Reason: $reason',
                        );
                        setState(() {});
                        widget.onUpdate();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Session cancelled'),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                        // Ask if they want to reschedule
                        Future.delayed(const Duration(milliseconds: 400), () {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.event_repeat_rounded,
                                    color: AppTheme.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reschedule Session?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Session was cancelled.\nReason: $reason\n\nWould you like to reschedule with the same customer?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => SafeArea(
                                        top: false,
                                        minimum: EdgeInsets.only(bottom: 8),
                                        child: _RescheduleFromCancelSheet(
                                          session: s,
                                          cancelReason: reason,
                                          onSave: (sessionData) {
                                            globalSessionMaps.insert(
                                              0,
                                              sessionData,
                                            );
                                            _logSessionActivityToLead(
                                              s['linkedLeadId'] as String? ?? '',
                                              customerName,
                                              'Session Rescheduled',
                                              'Session rescheduled after cancellation for ${sessionData['type']}',
                                            );
                                            widget.onUpdate();
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Session rescheduled successfully!',
                                                  ),
                                                  backgroundColor:
                                                      AppTheme.success,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                  ),
                                  child: Text(
                                    'Yes, Reschedule',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                child: Text(
                  'Cancel Session',
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

    void showScheduleAction() {
      Navigator.pop(context);
      final isActiveSession =
          s['status'] != 'Completed' && s['status'] != 'Cancelled';
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 8),
          child: _ScheduledActionSheet(
          session: s,
          isActiveSession: isActiveSession,
          onSave: (actionData) {
            final cName = s['linkedLead'] as String;
            final cId = s['linkedLeadId'] as String? ?? '';
            final conflict = globalSessionMaps.any((m) {
              if (m['id'] == s['id']) return false;
              final mStatus = m['status'] as String;
              if (mStatus == 'Completed' ||
                  mStatus == 'Cancelled' ||
                  mStatus == 'Rescheduled') {
                return false;
              }
              return m['linkedLead'] == cName ||
                  (cId.isNotEmpty && m['linkedLeadId'] == cId);
            });
            if (conflict) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Customer Conflict',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: Text(
                    '$cName is already in another active session.',
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
              return;
            }
            final rescheduleReason =
                actionData['rescheduleReason'] as String? ?? '';
            final idx = globalSessionMaps.indexWhere((m) => m['id'] == s['id']);

            // Copy action counts from old session to new session
            final oldVideoCallCount = s['videoCallCount'] as int? ?? 0;
            final oldCallCount = s['callCount'] as int? ?? 0;
            final oldAppointmentCount = s['appointmentCount'] as int? ?? 0;
            final oldMessageCount = s['messageCount'] as int? ?? 0;
            final oldWhatsappCount = s['whatsappCount'] as int? ?? 0;
            final oldEmailCount = s['emailCount'] as int? ?? 0;

            if (idx >= 0) {
              globalSessionMaps[idx]['rescheduledSessionType'] =
                  actionData['type'] as String;
              globalSessionMaps[idx]['rescheduledSessionDate'] =
                  actionData['date'] as DateTime;
              if (rescheduleReason.isNotEmpty) {
                globalSessionMaps[idx]['rescheduleReason'] = rescheduleReason;
              }
              if (isActiveSession) {
                globalSessionMaps[idx]['status'] = 'Rescheduled';
              }
            }
            if (!isActiveSession) {
              globalSessionMaps.removeWhere((m) => m['id'] == s['id']);
            }
            final newSession = {
              'id': 'ses-${DateTime.now().millisecondsSinceEpoch}',
              'title': '${actionData['type']} with $cName',
              'type': actionData['type'] as String,
              'status': 'Scheduled',
              'date': actionData['date'] as DateTime,
              'host': actionData['assignedAgent'] as String? ?? s['host'],
              'hostInitials':
                  actionData['assignedAgentInitials'] as String? ??
                  s['hostInitials'],
              'participants': s['participants'],
              'linkedLead': cName,
              'linkedLeadId': cId,
              'customerPhone': s['customerPhone'] ?? '',
              'preferredContact': s['preferredContact'] ?? <String>[],
              'meetingLink': actionData['meetingLink'] as String? ?? '',
              'videoCallMode':
                  actionData['videoCallMode'] as String? ?? 'Inbuilt',
              'platform': actionData['type'] == 'Video Call'
                  ? 'Online'
                  : actionData['type'] == 'Appointment'
                  ? 'In-Person'
                  : 'Phone',
              'recording': false,
              'notes': actionData['notes'] as String? ?? '',
              'actionItems': <String>[],
              'outcome': '',
              'rating': 0,
              'agenda': '',
              'location': actionData['location'] as String? ?? '',
              'reminderSent': false,
              'followUpScheduled': false,
              'dealValue': s['dealValue'] ?? 0.0,
              'priority': s['priority'] ?? 'Medium',
              'createdAt': DateTime.now(),
              // Copy action counts from old session
              'videoCallCount': oldVideoCallCount,
              'callCount': oldCallCount,
              'appointmentCount': oldAppointmentCount,
              'messageCount': oldMessageCount,
              'whatsappCount': oldWhatsappCount,
              'emailCount': oldEmailCount,
              'isExistingCustomer': s['isExistingCustomer'] ?? false,
              'rescheduledFromId': s['id'],
              'interestTags': s['interestTags'] ?? <String>[],
            };
            globalSessionMaps.insert(0, newSession);
            _logSessionActivityToLead(
              s['linkedLeadId'] as String? ?? '',
              cName,
              'Session Rescheduled',
              'Session rescheduled to ${actionData['type']} on ${_formatFullDateTime(actionData['date'] as DateTime)}',
            );
            widget.onUpdate();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Session rescheduled successfully!'),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
        ),
      );
    }

    void tryMarkComplete() {
      final reason = _canCompleteReason(s);
      if (reason != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.lock_rounded, color: AppTheme.warning, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cannot Complete Yet',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              reason,
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
        return;
      }
      Navigator.pop(context);
      _endSession(context, s);
    }

    // Build action counts display for frozen sessions
    Widget buildFrozenActionCounts() {
      final videoCallCount = s['videoCallCount'] as int? ?? 0;
      final callCount = s['callCount'] as int? ?? 0;
      final appointmentCount = s['appointmentCount'] as int? ?? 0;
      final messageCount = s['messageCount'] as int? ?? 0;
      final whatsappCount = s['whatsappCount'] as int? ?? 0;
      final emailCount = s['emailCount'] as int? ?? 0;
      final instagramCount = s['instagramCount'] as int? ?? 0;
      final facebookCount = s['facebookCount'] as int? ?? 0;
      final twitterCount = s['twitterCount'] as int? ?? 0;
      final telegramCount = s['telegramCount'] as int? ?? 0;

      final counts = <Widget>[];
      if (videoCallCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.videocam_rounded,
            label: 'Video Call: $videoCallCount',
            color: const Color(0xFF0891B2),
          ),
        );
      }
      if (callCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.phone_rounded,
            label: 'Call: $callCount',
            color: AppTheme.success,
          ),
        );
      }
      if (appointmentCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.people_rounded,
            label: 'Appointment: $appointmentCount',
            color: const Color(0xFF8B5CF6),
          ),
        );
      }
      if (messageCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.message_rounded,
            label: 'Message: $messageCount',
            color: const Color(0xFF8B5CF6),
          ),
        );
      }
      if (whatsappCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.chat_rounded,
            label: 'WhatsApp: $whatsappCount',
            color: const Color(0xFF25D366),
          ),
        );
      }
      if (emailCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.email_rounded,
            label: 'Email: $emailCount',
            color: AppTheme.primary,
          ),
        );
      }
      if (instagramCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.camera_alt_rounded,
            label: 'Instagram: $instagramCount',
            color: const Color(0xFFE1306C),
          ),
        );
      }
      if (facebookCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.facebook_rounded,
            label: 'Facebook: $facebookCount',
            color: const Color(0xFF1877F2),
          ),
        );
      }
      if (twitterCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.close_rounded,
            label: 'X: $twitterCount',
            color: Colors.black,
          ),
        );
      }
      if (telegramCount > 0) {
        counts.add(
          _CountBadge(
            icon: Icons.send_rounded,
            label: 'Telegram: $telegramCount',
            color: const Color(0xFF0088CC),
          ),
        );
      }

      if (counts.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTION COUNTS (FROZEN)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: counts),
          const SizedBox(height: 12),
        ],
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
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
                            s['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (s['status'] == 'Rescheduled')
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6).withAlpha(60),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.event_repeat_rounded,
                              size: 10,
                              color: Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Rescheduled',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B5CF6),
                              ),
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
                    // For frozen sessions: show disabled actions with inline counts
                    if (isFrozen) ...[
                      _ActionRowDisabled(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.textMuted,
                        count: s['callCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: AppTheme.textMuted,
                        count: s['messageCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: AppTheme.textMuted,
                        count: s['whatsappCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.textMuted,
                        count: s['emailCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: AppTheme.textMuted,
                        count: s['videoCallCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: AppTheme.textMuted,
                        count: s['instagramCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: AppTheme.textMuted,
                        count: s['facebookCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: AppTheme.textMuted,
                        count: s['twitterCount'] as int? ?? 0,
                      ),
                      _ActionRowDisabled(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: AppTheme.textMuted,
                        count: s['telegramCount'] as int? ?? 0,
                      ),
                      const Divider(height: 20),
                      _ActionRowDisabled(
                        icon: Icons.event_repeat_rounded,
                        label: 'Reschedule Action (Disabled)',
                        color: AppTheme.textMuted,
                      ),
                      const Divider(height: 20),
                    ] else ...[
                      // Active session actions — show inline counts
                      _ActionRow(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: AppTheme.success,
                        count: s['callCount'] as int? ?? 0,
                        onTap: () =>
                            checkPreferenceAndLog('Calls', 'callCount'),
                      ),
                      _ActionRow(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        color: const Color(0xFF8B5CF6),
                        count: s['messageCount'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'Message',
                          'messageCount',
                          platform: 'SMS',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.chat_rounded,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        count: s['whatsappCount'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'WhatsApp',
                          'whatsappCount',
                          platform: 'WhatsApp',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppTheme.primary,
                        count: s['emailCount'] as int? ?? 0,
                        onTap: () => showTemplatePicker(
                          'Email',
                          'emailCount',
                          platform: 'Email',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.videocam_rounded,
                        label: 'Video Call',
                        color: const Color(0xFF0891B2),
                        count: s['videoCallCount'] as int? ?? 0,
                        onTap: () => checkPreferenceAndLog(
                          'Video Call',
                          'videoCallCount',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        color: hasInstagram
                            ? const Color(0xFFE1306C)
                            : AppTheme.textMuted,
                        count: s['instagramCount'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Instagram',
                          hasInstagram,
                          'instagramCount',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: hasFacebook
                            ? const Color(0xFF1877F2)
                            : AppTheme.textMuted,
                        count: s['facebookCount'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Facebook',
                          hasFacebook,
                          'facebookCount',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.close_rounded,
                        label: 'X (Twitter)',
                        color: hasTwitter
                            ? const Color(0xFF1DA1F2)
                            : AppTheme.textMuted,
                        count: s['twitterCount'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'X (Twitter)',
                          hasTwitter,
                          'twitterCount',
                        ),
                      ),
                      _ActionRow(
                        icon: Icons.send_rounded,
                        label: 'Telegram',
                        color: hasTelegram
                            ? const Color(0xFF0088CC)
                            : AppTheme.textMuted,
                        count: s['telegramCount'] as int? ?? 0,
                        onTap: () => doSocialAction(
                          'Telegram',
                          hasTelegram,
                          'telegramCount',
                        ),
                      ),
                      const Divider(height: 20),
                      // Reschedule — disabled for Rescheduled sessions
                      if (s['status'] == 'Rescheduled')
                        _ActionRowDisabled(
                          icon: Icons.event_repeat_rounded,
                          label: 'Reschedule Action (Already Rescheduled)',
                          color: AppTheme.textMuted,
                        )
                      else
                        _ActionRow(
                          icon: Icons.event_repeat_rounded,
                          label: 'Reschedule Action',
                          color: const Color(0xFF8B5CF6),
                          onTap: showScheduleAction,
                        ),
                      const Divider(height: 20),
                      if (s['status'] != 'Completed' &&
                          s['status'] != 'Cancelled' &&
                          s['status'] != 'Rescheduled') ...[
                        _ActionRow(
                          icon: Icons.check_circle_rounded,
                          label: 'Mark as Completed',
                          color: const Color(0xFF3D9970),
                          onTap: tryMarkComplete,
                        ),
                        _ActionRow(
                          icon: Icons.cancel_outlined,
                          label: 'Cancel Session',
                          color: AppTheme.error,
                          onTap: () {
                            Navigator.pop(context);
                            cancelSession();
                          },
                        ),
                        const Divider(height: 20),
                      ],
                    ],
                    _ActionRow(
                      icon: Icons.info_outline_rounded,
                      label: 'See Details',
                      color: AppTheme.primary,
                      onTap: () {
                        Navigator.pop(context);
                        _showSessionDetailsSheet(context, s);
                      },
                    ),
                    // Video Call specific: Start Session (inbuilt) or Go to Video Call (only when In Progress)
                    // Placed at BOTTOM of actions sheet
                    if (s['type'] == 'Video Call' && !isFrozen) ...[
                      const SizedBox(height: 8),
                      if (s['status'] == 'Scheduled' && _isInbuiltVideoCall(s))
                        _ActionRow(
                          icon: Icons.play_circle_rounded,
                          label: 'Start Session',
                          color: AppTheme.primary,
                          onTap: () {
                            Navigator.pop(context);
                            _startSession(context, s);
                          },
                        )
                      else if (s['status'] == 'In Progress')
                        _ActionRow(
                          icon: Icons.videocam_rounded,
                          label: 'Go to Video Call',
                          color: AppTheme.error,
                          onTap: () {
                            final link = s['meetingLink'] as String? ?? '';
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    link.isNotEmpty
                                        ? 'Opening: $link'
                                        : 'Session is live',
                                  ),
                                  backgroundColor: AppTheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                    ],
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

  Widget _buildAppointmentCompletionBadge(Map<String, dynamic> s) {
    final endedAt = s['endedAt'] as DateTime?;
    final scheduledDate = s['date'] as DateTime;
    if (endedAt == null) return const SizedBox.shrink();
    final dueWithGrace = scheduledDate.add(const Duration(days: 1));
    final isOnTime = endedAt.isBefore(dueWithGrace);
    return Container(
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
            size: 12,
            color: isOnTime ? AppTheme.success : AppTheme.warning,
          ),
          const SizedBox(width: 5),
          Text(
            isOnTime ? 'Completed On Time' : 'Completed After Due',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isOnTime ? AppTheme.success : AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallBackCompleteButton(
    BuildContext context,
    Map<String, dynamic> s,
  ) {
    final callCount = s['callCount'] as int? ?? 0;
    final canComplete = callCount > 0;

    if (!canComplete) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_rounded, size: 14, color: AppTheme.textMuted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Complete unlocks after a call is made within 24hrs',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _endSession(context, s),
        icon: const Icon(Icons.check_circle_rounded, size: 16),
        label: Text(
          'Complete Call Back',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.success,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// ─── Reschedule From Cancel Sheet ────────────────────────────────────────────

class _RescheduleFromCancelSheet extends StatefulWidget {
  final Map<String, dynamic> session;
  final String cancelReason;
  final void Function(Map<String, dynamic>) onSave;
  const _RescheduleFromCancelSheet({
    required this.session,
    required this.cancelReason,
    required this.onSave,
  });

  @override
  State<_RescheduleFromCancelSheet> createState() =>
      _RescheduleFromCancelSheetState();
}

class _RescheduleFromCancelSheetState
    extends State<_RescheduleFromCancelSheet> {
  late TextEditingController _titleCtrl;
  String _actionType = 'Appointment';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  _AgentInfo? _selectedAgent;

  static const _actionTypes = ['Appointment', 'Video Call', 'Call Back'];

  @override
  void initState() {
    super.initState();
    // Pre-fill title from cancelled session
    _titleCtrl = TextEditingController(
      text: widget.session['title'] as String? ?? '',
    );
    // Pre-fill type from session
    final sType = widget.session['type'] as String? ?? 'Appointment';
    _actionType = _actionTypes.contains(sType) ? sType : 'Appointment';
    // Pre-fill agent
    final hostName = widget.session['host'] as String? ?? '';
    _selectedAgent = _kAgents.firstWhere(
      (a) => a.name == hostName,
      orElse: () => _kAgents.first,
    );
    // Pre-fill location if appointment
    _locationCtrl.text = widget.session['location'] as String? ?? '';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_titleCtrl.text.trim().isEmpty) return false;
    if (_selectedDate == null || _selectedTime == null) return false;
    if (_actionType == 'Appointment' && _locationCtrl.text.trim().isEmpty) {
      return false;
    }
    return true;
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

  Color _actionColor(String a) {
    switch (a) {
      case 'Appointment':
        return const Color(0xFF8B5CF6);
      case 'Video Call':
        return const Color(0xFF0891B2);
      case 'Call Back':
        return AppTheme.success;
      default:
        return AppTheme.primary;
    }
  }

  IconData _actionIcon(String a) {
    switch (a) {
      case 'Appointment':
        return Icons.people_rounded;
      case 'Video Call':
        return Icons.videocam_rounded;
      case 'Call Back':
        return Icons.phone_callback_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
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
                      color: AppTheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.event_repeat_rounded,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reschedule Session',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'For ${s['linkedLead']}',
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
            // Cancel reason banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.error.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(Icons.cancel_rounded, size: 14, color: AppTheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cancelled: ${widget.cancelReason}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.error,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Title *',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleCtrl,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Session title...',
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
                        suffixIcon: _titleCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () =>
                                    setState(() => _titleCtrl.clear()),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Action Type *',
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
                      children: _actionTypes.map((t) {
                        final sel = _actionType == t;
                        final color = _actionColor(t);
                        return GestureDetector(
                          onTap: () => setState(() => _actionType = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? color.withAlpha(25)
                                  : AppTheme.surface100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? color : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _actionIcon(t),
                                  size: 14,
                                  color: sel ? color : AppTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: sel ? color : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Assign Member *',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SingleAgentPicker(
                      agents: _kAgents,
                      selected: _selectedAgent,
                      onSelect: (a) => setState(() => _selectedAgent = a),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Date & Time *',
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
                              if (d != null) setState(() => _selectedDate = d);
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
                                  color: _selectedDate != null
                                      ? AppTheme.primary.withAlpha(60)
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedDate != null
                                        ? _formatDate(_selectedDate!)
                                        : 'Select date',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: _selectedDate != null
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
                              if (t != null) setState(() => _selectedTime = t);
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
                                  color: _selectedTime != null
                                      ? AppTheme.primary.withAlpha(60)
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedTime != null
                                        ? _selectedTime!.format(context)
                                        : 'Select time',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: _selectedTime != null
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
                    if (_actionType == 'Appointment') ...[
                      const SizedBox(height: 16),
                      Text(
                        'Appointment Location *',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'e.g. Office address, branch...',
                          filled: true,
                          fillColor: AppTheme.surface100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ],
                    if (_actionType == 'Video Call') ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0891B2).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF0891B2).withAlpha(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 16,
                              color: Color(0xFF0891B2),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Meeting link will be auto-generated.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: const Color(0xFF0891B2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Reason for Rescheduling — removed (isActiveSession not defined on _RescheduleFromCancelSheet)
                    Text(
                      'Notes (optional)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add notes for rescheduled session...',
                        filled: true,
                        fillColor: AppTheme.surface100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _canSave
                            ? () {
                                final date = _selectedDate!;
                                final time = _selectedTime!;
                                final actionDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                final meetingLink = _actionType == 'Video Call'
                                    ? 'meet.google.com/${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}'
                                    : '';
                                final newSession = {
                                  'id':
                                      'ses-rsc-${DateTime.now().millisecondsSinceEpoch}',
                                  'title': _titleCtrl.text.trim(),
                                  'type': _actionType,
                                  'status': 'Scheduled',
                                  'date': actionDate,
                                  'host': _selectedAgent?.name ?? s['host'],
                                  'hostInitials':
                                      _selectedAgent?.initials ??
                                      s['hostInitials'],
                                  'participants': s['participants'],
                                  'linkedLead': s['linkedLead'],
                                  'linkedLeadId': s['linkedLeadId'] ?? '',
                                  'customerPhone': s['customerPhone'] ?? '',
                                  'preferredContact':
                                      s['preferredContact'] ?? <String>[],
                                  'meetingLink': meetingLink,
                                  'platform': _actionType == 'Video Call'
                                      ? 'Online'
                                      : _actionType == 'Appointment'
                                      ? 'In-Person'
                                      : 'Phone',
                                  'recording': false,
                                  'notes': _notesCtrl.text.trim().isNotEmpty
                                      ? _notesCtrl.text.trim()
                                      : 'Rescheduled from cancelled session. Original reason: ${widget.cancelReason}',
                                  'actionItems': <String>[],
                                  'outcome': '',
                                  'rating': 0,
                                  'agenda': s['agenda'] ?? '',
                                  'location': _actionType == 'Appointment'
                                      ? _locationCtrl.text.trim()
                                      : '',
                                  'reminderSent': false,
                                  'followUpScheduled': false,
                                  'dealValue': s['dealValue'] ?? 0.0,
                                  'priority': s['priority'] ?? 'Medium',
                                  'createdAt': DateTime.now(),
                                  'videoCallCount': 0,
                                  'callCount': 0,
                                  'appointmentCount': 0,
                                  'isExistingCustomer':
                                      s['isExistingCustomer'] ?? false,
                                };
                                Navigator.pop(context);
                                widget.onSave(newSession);
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reschedule Session',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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

// ─── Scheduled Action Sheet ───────────────────────────────────────────────────

class _ScheduledActionSheet extends StatefulWidget {
  final Map<String, dynamic> session;
  final void Function(Map<String, dynamic>) onSave;
  final bool isActiveSession;

  const _ScheduledActionSheet({
    required this.session,
    required this.onSave,
    this.isActiveSession = false,
  });

  @override
  State<_ScheduledActionSheet> createState() => _ScheduledActionSheetState();
}

class _ScheduledActionSheetState extends State<_ScheduledActionSheet> {
  String _actionType = 'Appointment';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _rescheduleReasonCtrl = TextEditingController();
  final _thirdPartyLinkCtrl = TextEditingController();
  _AgentInfo? _selectedAgent;
  String _videoCallMode = 'Inbuilt'; // 'Inbuilt' or '3rd Party'

  static const _actionTypes = ['Appointment', 'Video Call', 'Call Back'];

  @override
  void initState() {
    super.initState();
    // Default agent = session's host
    final hostName = widget.session['host'] as String? ?? '';
    _selectedAgent = _kAgents.firstWhere(
      (a) => a.name == hostName,
      orElse: () => _kAgents.first,
    );
  }

  bool get _canSave {
    if (_selectedDate == null || _selectedTime == null) return false;
    if (_actionType == 'Appointment' && _locationCtrl.text.trim().isEmpty) {
      return false;
    }
    // Require reason for rescheduling when session is active
    if (widget.isActiveSession && _rescheduleReasonCtrl.text.trim().isEmpty) {
      return false;
    }
    return true;
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

  Color _actionColor(String a) {
    switch (a) {
      case 'Appointment':
        return const Color(0xFF8B5CF6);
      case 'Video Call':
        return const Color(0xFF0891B2);
      case 'Call Back':
        return AppTheme.success;
      default:
        return AppTheme.primary;
    }
  }

  IconData _actionIcon(String a) {
    switch (a) {
      case 'Appointment':
        return Icons.people_rounded;
      case 'Video Call':
        return Icons.videocam_rounded;
      case 'Call Back':
        return Icons.phone_callback_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _locationCtrl.dispose();
    _thirdPartyLinkCtrl.dispose();
    _rescheduleReasonCtrl.dispose();
    super.dispose();
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
                      color: const Color(0xFF8B5CF6).withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reschedule Action',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'For ${widget.session['linkedLead']}',
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Action Type *',
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
                      children: _actionTypes.map((t) {
                        final sel = _actionType == t;
                        final color = _actionColor(t);
                        return GestureDetector(
                          onTap: () => setState(() => _actionType = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? color.withAlpha(25)
                                  : AppTheme.surface100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? color : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _actionIcon(t),
                                  size: 14,
                                  color: sel ? color : AppTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: sel ? color : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Assign Member (single select, default = session host)
                    Text(
                      'Assign Member *',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SingleAgentPicker(
                      agents: _kAgents,
                      selected: _selectedAgent,
                      onSelect: (a) => setState(() => _selectedAgent = a),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Date & Time *',
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
                              if (d != null) setState(() => _selectedDate = d);
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
                                  color: _selectedDate != null
                                      ? AppTheme.primary.withAlpha(60)
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedDate != null
                                        ? _formatDate(_selectedDate!)
                                        : 'Select date',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: _selectedDate != null
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
                              if (t != null) setState(() => _selectedTime = t);
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
                                  color: _selectedTime != null
                                      ? AppTheme.primary.withAlpha(60)
                                      : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedTime != null
                                        ? _selectedTime!.format(context)
                                        : 'Select time',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: _selectedTime != null
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
                    // Appointment: ask for location
                    if (_actionType == 'Appointment') ...[
                      const SizedBox(height: 16),
                      Text(
                        'Appointment Location *',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'e.g. Office address, branch...',
                          filled: true,
                          fillColor: AppTheme.surface100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ],
                    // Video Call: auto meeting link info
                    if (_actionType == 'Video Call') ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0891B2).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF0891B2).withAlpha(50),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.videocam_rounded,
                                  size: 16,
                                  color: Color(0xFF0891B2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Video Call Type',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0891B2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _videoCallMode = 'Inbuilt',
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _videoCallMode == 'Inbuilt'
                                            ? const Color(0xFF0891B2)
                                            : AppTheme.surfaceLight,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF0891B2,
                                          ).withAlpha(80),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Inbuilt (Auto-link)',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _videoCallMode == 'Inbuilt'
                                                ? Colors.white
                                                : const Color(0xFF0891B2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _videoCallMode = '3rd Party',
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _videoCallMode == '3rd Party'
                                            ? const Color(0xFF0891B2)
                                            : AppTheme.surfaceLight,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF0891B2,
                                          ).withAlpha(80),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '3rd Party Link',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _videoCallMode == '3rd Party'
                                                ? Colors.white
                                                : const Color(0xFF0891B2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_videoCallMode == 'Inbuilt') ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.link_rounded,
                                    size: 14,
                                    color: Color(0xFF0891B2),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Meeting link will be auto-generated.',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: const Color(0xFF0891B2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_videoCallMode == '3rd Party') ...[
                              const SizedBox(height: 8),
                              TextField(
                                controller: _thirdPartyLinkCtrl,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText:
                                      'Paste video session link (optional)...',
                                  prefixIcon: const Icon(
                                    Icons.link_rounded,
                                    size: 16,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.surfaceLight,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    // Reason for Rescheduling — shown when session is active (not completed/cancelled)
                    if (widget.isActiveSession) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Reason for Rescheduling',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '*',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _rescheduleReasonCtrl,
                        maxLines: 3,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Customer requested a different time...',
                          filled: true,
                          fillColor: AppTheme.error.withAlpha(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.error.withAlpha(60),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.error.withAlpha(60),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.error),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      'Notes (optional)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add notes for this scheduled action...',
                        filled: true,
                        fillColor: AppTheme.surface100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _canSave
                            ? () {
                                final date = _selectedDate!;
                                final time = _selectedTime!;
                                final actionDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                // Meeting link based on mode
                                String meetingLink = '';
                                if (_actionType == 'Video Call') {
                                  if (_videoCallMode == 'Inbuilt') {
                                    meetingLink =
                                        'meet.google.com/${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
                                  } else {
                                    meetingLink = _thirdPartyLinkCtrl.text
                                        .trim();
                                  }
                                }
                                Navigator.pop(context);
                                widget.onSave({
                                  'type': _actionType,
                                  'date': actionDate,
                                  'notes': _notesCtrl.text.trim(),
                                  'assignedAgent': _selectedAgent?.name ?? '',
                                  'assignedAgentInitials':
                                      _selectedAgent?.initials ?? '',
                                  'location': _actionType == 'Appointment'
                                      ? _locationCtrl.text.trim()
                                      : '',
                                  'meetingLink': meetingLink,
                                  'videoCallMode': _actionType == 'Video Call'
                                      ? _videoCallMode
                                      : 'Inbuilt',
                                  'rescheduleReason': _rescheduleReasonCtrl.text
                                      .trim(),
                                });
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reschedule Session',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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

// ─── Complete Session Sheet ───────────────────────────────────────────────────

class _CompleteSessionSheet extends StatefulWidget {
  final Map<String, dynamic> session;
  final void Function(
    String outcome,
    int rating,
    String notes,
    bool scheduleFollowUp,
    DateTime? followUpDate,
    String? nextActionType,
  )
  onComplete;
  const _CompleteSessionSheet({
    required this.session,
    required this.onComplete,
  });

  @override
  State<_CompleteSessionSheet> createState() => _CompleteSessionSheetState();
}

class _CompleteSessionSheetState extends State<_CompleteSessionSheet> {
  final _outcomeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _thirdPartyVideoLinkCtrl = TextEditingController();
  int _rating = 0;
  bool _scheduleNextAction = false;
  String _nextActionType = 'Appointment';
  DateTime? _nextActionDate;
  TimeOfDay? _nextActionTime;
  _AgentInfo? _nextActionAgent;
  final _locationCtrl = TextEditingController();
  String _videoCallMode = 'Inbuilt'; // 'Inbuilt' or '3rd Party'

  static const _nextActionTypes = [
    'Appointment',
    'Video Call',
    'Call Back',
    'Follow Up',
  ];

  @override
  void initState() {
    super.initState();
    // Default agent = session's host
    final hostName = widget.session['host'] as String? ?? '';
    _nextActionAgent = _kAgents.firstWhere(
      (a) => a.name == hostName,
      orElse: () => _kAgents.first,
    );
  }

  bool get _canComplete => _outcomeCtrl.text.trim().isNotEmpty && _rating > 0;

  Color _actionColor(String a) {
    switch (a) {
      case 'Appointment':
        return const Color(0xFF8B5CF6);
      case 'Video Call':
        return const Color(0xFF0891B2);
      case 'Call Back':
        return AppTheme.success;
      case 'Follow Up':
        return AppTheme.warning;
      default:
        return AppTheme.primary;
    }
  }

  IconData _actionIcon(String a) {
    switch (a) {
      case 'Appointment':
        return Icons.people_rounded;
      case 'Video Call':
        return Icons.videocam_rounded;
      case 'Call Back':
        return Icons.phone_callback_rounded;
      case 'Follow Up':
        return Icons.repeat_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }

  @override
  void dispose() {
    _outcomeCtrl.dispose();
    _notesCtrl.dispose();
    _locationCtrl.dispose();
    _thirdPartyVideoLinkCtrl.dispose();
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
    final s = widget.session;
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
              Text(
                'Complete Session',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in the session outcome to complete.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primary.withAlpha(30),
                      child: Text(
                        (s['linkedLead'] as String).isNotEmpty
                            ? (s['linkedLead'] as String)[0]
                            : '?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['linkedLead'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                          if ((s['customerPhone'] as String? ?? '').isNotEmpty)
                            Text(
                              s['customerPhone'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      s['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Session Rating',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        i < _rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 32,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ),
              ),
              if (_rating == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Rating is required',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Outcome',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _outcomeCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'e.g. Positive — Moving to Proposal',
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
              const SizedBox(height: 16),
              Text(
                'Notes (optional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Session notes, key discussion points...',
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
              const SizedBox(height: 16),
              // ── Schedule Next Action ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _scheduleNextAction
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _scheduleNextAction
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
                          Icons.next_plan_rounded,
                          size: 18,
                          color: _scheduleNextAction
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Schedule Next Action',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _scheduleNextAction
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: _scheduleNextAction,
                          onChanged: (v) => setState(() {
                            _scheduleNextAction = v;
                            if (v && _nextActionDate == null) {
                              _nextActionDate = DateTime.now().add(
                                const Duration(days: 1),
                              );
                            }
                          }),
                          activeThumbColor: AppTheme.primary,
                        ),
                      ],
                    ),
                    if (_scheduleNextAction) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Action Type',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _nextActionTypes.map((t) {
                          final sel = _nextActionType == t;
                          final color = _actionColor(t);
                          return GestureDetector(
                            onTap: () => setState(() => _nextActionType = t),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? color.withAlpha(25)
                                    : AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: sel ? color : AppTheme.surface200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _actionIcon(t),
                                    size: 13,
                                    color: sel ? color : AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    t,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: sel
                                          ? color
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
                      Text(
                        'Assign Member',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SingleAgentPicker(
                        agents: _kAgents,
                        selected: _nextActionAgent,
                        onSelect: (a) => setState(() => _nextActionAgent = a),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Date & Time',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
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
                                  initialDate:
                                      _nextActionDate ??
                                      DateTime.now().add(
                                        const Duration(days: 1),
                                      ),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (d != null) {
                                  setState(() => _nextActionDate = d);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _nextActionDate != null
                                        ? AppTheme.primary.withAlpha(60)
                                        : AppTheme.surface200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _nextActionDate != null
                                          ? _formatDate(_nextActionDate!)
                                          : 'Select date',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: _nextActionDate != null
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
                                      _nextActionTime ?? TimeOfDay.now(),
                                );
                                if (t != null) {
                                  setState(() => _nextActionTime = t);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _nextActionTime != null
                                        ? AppTheme.primary.withAlpha(60)
                                        : AppTheme.surface200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _nextActionTime != null
                                          ? _nextActionTime!.format(context)
                                          : 'Select time',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: _nextActionTime != null
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
                      // Appointment location
                      if (_nextActionType == 'Appointment') ...[
                        const SizedBox(height: 12),
                        Text(
                          'Appointment Location *',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _locationCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'e.g. Office address...',
                            filled: true,
                            fillColor: AppTheme.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        ),
                      ],
                      if (_nextActionType == 'Video Call') ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0891B2).withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF0891B2).withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.link_rounded,
                                size: 14,
                                color: Color(0xFF0891B2),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Meeting link will be auto-generated.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFF0891B2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Video call type dropdown for next action
                      if (_nextActionType == 'Video Call') ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0891B2).withAlpha(10),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF0891B2).withAlpha(40),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Video Call Type',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0891B2),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _videoCallMode = 'Inbuilt',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _videoCallMode == 'Inbuilt'
                                              ? const Color(0xFF0891B2)
                                              : AppTheme.surfaceLight,
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF0891B2,
                                            ).withAlpha(80),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Inbuilt (Auto-link)',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: _videoCallMode == 'Inbuilt'
                                                  ? Colors.white
                                                  : const Color(0xFF0891B2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _videoCallMode = '3rd Party',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _videoCallMode == '3rd Party'
                                              ? const Color(0xFF0891B2)
                                              : AppTheme.surfaceLight,
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF0891B2,
                                            ).withAlpha(80),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '3rd Party Link',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  _videoCallMode == '3rd Party'
                                                  ? Colors.white
                                                  : const Color(0xFF0891B2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_videoCallMode == '3rd Party') ...[
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _thirdPartyVideoLinkCtrl,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Paste video session link (optional)...',
                                    prefixIcon: const Icon(
                                      Icons.link_rounded,
                                      size: 14,
                                    ),
                                    filled: true,
                                    fillColor: AppTheme.surfaceLight,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canComplete
                      ? () {
                          DateTime? actionDateTime;
                          if (_scheduleNextAction && _nextActionDate != null) {
                            final t =
                                _nextActionTime ??
                                const TimeOfDay(hour: 10, minute: 0);
                            actionDateTime = DateTime(
                              _nextActionDate!.year,
                              _nextActionDate!.month,
                              _nextActionDate!.day,
                              t.hour,
                              t.minute,
                            );
                          }
                          Navigator.pop(context);
                          widget.onComplete(
                            _outcomeCtrl.text.trim(),
                            _rating,
                            _notesCtrl.text.trim(),
                            _scheduleNextAction,
                            actionDateTime,
                            _scheduleNextAction ? _nextActionType : null,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Complete Session',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: _canComplete ? Colors.white : AppTheme.textMuted,
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

// ─── New Session Sheet ────────────────────────────────────────────────────────

class _NewSessionSheet extends StatefulWidget {
  final List<_AgentInfo> agents;
  final void Function(Map<String, dynamic>) onSave;
  const _NewSessionSheet({required this.agents, required this.onSave});

  @override
  State<_NewSessionSheet> createState() => _NewSessionSheetState();
}

class _NewSessionSheetState extends State<_NewSessionSheet> {
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _leadSearchCtrl = TextEditingController();
  final _thirdPartyLinkCtrl = TextEditingController();
  final _newLeadNameCtrl = TextEditingController();
  final _newLeadPhoneCtrl = TextEditingController();

  String _selectedType = 'Video Call';
  _AgentInfo? _selectedAgent;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';
  Map<String, dynamic>? _selectedLead;
  String _leadSearchQuery = '';
  bool _showLeadSearch = false;
  bool _addToReminders = true; // Default ON
  String _videoCallMode = 'Inbuilt'; // 'Inbuilt' or '3rd Party'
  // Multi-lead for video call
  final List<Map<String, dynamic>> _videoCallLeads = [];
  bool _showVideoLeadSearch = false;
  String _videoLeadSearchQuery = '';
  final _videoLeadSearchCtrl = TextEditingController();
  bool _showAddNewLead = false;
  int? _editingLeadIndex; // index being edited

  // Reminder fields (shown when _addToReminders is true)
  bool _hasAlarm = false;
  DateTime? _alarmDate;
  TimeOfDay? _alarmTime;
  String _remindBefore = '15 minutes';
  String _repeat = 'None';
  final List<String> _notifyVia = ['Push', 'In-App'];

  static const _types = ['Video Call', 'Appointment', 'Call Back'];
  static const _priorities = ['High', 'Medium', 'Low'];
  static const _remindBeforeOptions = [
    '5 minutes',
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2 hours',
    '1 day',
  ];
  static const _repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly'];
  static const _notifyOptions = ['Push', 'In-App', 'WhatsApp', 'Email'];

  bool get _canSave {
    if (_titleCtrl.text.trim().isEmpty) return false;
    if (_selectedAgent == null) return false;
    if (_selectedDate == null || _selectedTime == null) return false;
    if (_selectedType == 'Appointment' && _locationCtrl.text.trim().isEmpty) {
      return false;
    }
    // For video call: need at least one lead
    if (_selectedType == 'Video Call') {
      return _videoCallLeads.isNotEmpty;
    }
    return _selectedLead != null;
  }

  @override
  void initState() {
    super.initState();
    // Default agent = first agent (current user)
    _selectedAgent = widget.agents.isNotEmpty ? widget.agents.first : null;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _leadSearchCtrl.dispose();
    _thirdPartyLinkCtrl.dispose();
    _newLeadNameCtrl.dispose();
    _newLeadPhoneCtrl.dispose();
    _videoLeadSearchCtrl.dispose();
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

  List<Map<String, dynamic>> get _filteredLeads {
    final q = _leadSearchQuery.toLowerCase();
    return leads_list.globalLeads.where((m) {
      final name = (m['name'] as String? ?? '').toLowerCase();
      final phone = (m['phone'] as String? ?? '').toLowerCase();
      return q.isEmpty || name.contains(q) || phone.contains(q);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredVideoLeads {
    final q = _videoLeadSearchQuery.toLowerCase();
    return leads_list.globalLeads.where((m) {
      final name = (m['name'] as String? ?? '').toLowerCase();
      final phone = (m['phone'] as String? ?? '').toLowerCase();
      return q.isEmpty || name.contains(q) || phone.contains(q);
    }).toList();
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'Video Call':
        return const Color(0xFF0891B2);
      case 'Appointment':
        return const Color(0xFF8B5CF6);
      case 'Call Back':
        return AppTheme.success;
      default:
        return AppTheme.primary;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Video Call':
        return Icons.videocam_rounded;
      case 'Appointment':
        return Icons.people_rounded;
      case 'Call Back':
        return Icons.phone_callback_rounded;
      default:
        return Icons.event_rounded;
    }
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
                      'Schedule New Session',
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
              _buildLabel('Session Title *'),
              const SizedBox(height: 6),
              TextField(
                controller: _titleCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Insurance Review with Rahul',
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
              ),
              const SizedBox(height: 12),

              // Customer search from existing leads (only for non-video call types)
              if (_selectedType != 'Video Call') ...[
                _buildLabel('Customer *'),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () =>
                      setState(() => _showLeadSearch = !_showLeadSearch),
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
                                    if ((_selectedLead!['phone'] as String? ??
                                            '')
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
                              final name = lead['name'] as String? ?? '';
                              final phone = lead['phone'] as String? ?? '';
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedLead = lead;
                                    _showLeadSearch = false;
                                    _leadSearchQuery = '';
                                    _leadSearchCtrl.clear();
                                  });
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
                                        radius: 16,
                                        backgroundColor: AppTheme.primary
                                            .withAlpha(30),
                                        child: Text(
                                          name.isNotEmpty ? name[0] : '?',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
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
                                              name,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            if (phone.isNotEmpty)
                                              Text(
                                                phone,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 11,
                                                      color: AppTheme
                                                          .textSecondary,
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
                ], // end if (_showLeadSearch)
              ], // end if (_selectedType != 'Video Call') for customer
              // Session Type
              _buildLabel('Session Type *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final sel = _selectedType == t;
                  final color = _typeColor(t);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? color.withAlpha(25) : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? color : AppTheme.surface200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _typeIcon(t),
                            size: 14,
                            color: sel ? color : AppTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel ? color : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Assign Host / Agent — single select, same design as filter
              _buildLabel('Assign Host / Agent *'),
              const SizedBox(height: 8),
              _SingleAgentPicker(
                agents: widget.agents,
                selected: _selectedAgent,
                onSelect: (a) => setState(() => _selectedAgent = a),
              ),
              const SizedBox(height: 12),

              // Date & Time
              _buildLabel('Date & Time *'),
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
                        if (d != null) setState(() => _selectedDate = d);
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
                            color: _selectedDate != null
                                ? AppTheme.primary.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDate != null
                                  ? _formatDate(_selectedDate!)
                                  : 'Select date',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _selectedDate != null
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
                        if (t != null) setState(() => _selectedTime = t);
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
                            color: _selectedTime != null
                                ? AppTheme.primary.withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Select time',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _selectedTime != null
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

              // Appointment: ask for location
              if (_selectedType == 'Appointment') ...[
                _buildLabel('Appointment Location *'),
                const SizedBox(height: 6),
                TextField(
                  controller: _locationCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'e.g. Office address, branch...',
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
                const SizedBox(height: 12),
              ],

              // Video Call: inbuilt/3rd party + multi-lead
              if (_selectedType == 'Video Call') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF0891B2).withAlpha(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_rounded,
                            size: 16,
                            color: Color(0xFF0891B2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Video Call Type',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0891B2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _videoCallMode = 'Inbuilt'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _videoCallMode == 'Inbuilt'
                                      ? const Color(0xFF0891B2)
                                      : AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF0891B2,
                                    ).withAlpha(80),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Inbuilt (Auto-link)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _videoCallMode == 'Inbuilt'
                                          ? Colors.white
                                          : const Color(0xFF0891B2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _videoCallMode = '3rd Party'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _videoCallMode == '3rd Party'
                                      ? const Color(0xFF0891B2)
                                      : AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF0891B2,
                                    ).withAlpha(80),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '3rd Party Link',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _videoCallMode == '3rd Party'
                                          ? Colors.white
                                          : const Color(0xFF0891B2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_videoCallMode == 'Inbuilt') ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 14,
                              color: Color(0xFF0891B2),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Meeting link will be auto-generated.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF0891B2),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (_videoCallMode == '3rd Party') ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: _thirdPartyLinkCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText:
                                'Paste video session link (Zoom, Teams, etc.)...',
                            prefixIcon: const Icon(
                              Icons.link_rounded,
                              size: 16,
                            ),
                            filled: true,
                            fillColor: AppTheme.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Multi-lead for video call
                _buildLabel('Participants (Leads) *'),
                const SizedBox(height: 6),
                // Show added leads
                if (_videoCallLeads.isNotEmpty) ...[
                  ...List.generate(_videoCallLeads.length, (i) {
                    final lead = _videoCallLeads[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(60),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.primary.withAlpha(30),
                            child: Text(
                              (lead['name'] as String? ?? '?')[0],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead['name'] as String? ?? '',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                if ((lead['phone'] as String? ?? '').isNotEmpty)
                                  Text(
                                    lead['phone'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _editingLeadIndex = i;
                                _newLeadNameCtrl.text =
                                    lead['name'] as String? ?? '';
                                _newLeadPhoneCtrl.text =
                                    lead['phone'] as String? ?? '';
                                _showAddNewLead = true;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: AppTheme.error,
                            ),
                            onPressed: () =>
                                setState(() => _videoCallLeads.removeAt(i)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                // Add lead from existing leads
                if (!_showAddNewLead) ...[
                  GestureDetector(
                    onTap: () => setState(
                      () => _showVideoLeadSearch = !_showVideoLeadSearch,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_add_rounded,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add existing lead',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            _showVideoLeadSearch
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showVideoLeadSearch) ...[
                    const SizedBox(height: 6),
                    TextField(
                      controller: _videoLeadSearchCtrl,
                      autofocus: true,
                      onChanged: (v) =>
                          setState(() => _videoLeadSearchQuery = v),
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
                    const SizedBox(height: 4),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 160),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _filteredVideoLeads.length,
                        itemBuilder: (_, i) {
                          final lead = _filteredVideoLeads[i];
                          final alreadyAdded = _videoCallLeads.any(
                            (l) => l['name'] == lead['name'],
                          );
                          return InkWell(
                            onTap: alreadyAdded
                                ? null
                                : () {
                                    setState(() {
                                      _videoCallLeads.add({
                                        'name': lead['name'],
                                        'phone': lead['phone'] ?? '',
                                        'id': lead['id'] ?? '',
                                      });
                                      _showVideoLeadSearch = false;
                                      _videoLeadSearchQuery = '';
                                      _videoLeadSearchCtrl.clear();
                                    });
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: alreadyAdded
                                    ? AppTheme.surface100
                                    : null,
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
                                    radius: 12,
                                    backgroundColor: AppTheme.primary.withAlpha(
                                      30,
                                    ),
                                    child: Text(
                                      (lead['name'] as String? ?? '?')[0],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${lead['name']}${(lead['phone'] as String? ?? '').isNotEmpty ? ' · ${lead['phone']}' : ''}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: alreadyAdded
                                            ? AppTheme.textMuted
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (alreadyAdded)
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: AppTheme.success,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAddNewLead = true;
                        _editingLeadIndex = null;
                        _newLeadNameCtrl.clear();
                        _newLeadPhoneCtrl.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add new lead (name + phone)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                // Add new lead form
                if (_showAddNewLead) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.surface200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editingLeadIndex != null ? 'Edit Lead' : 'New Lead',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newLeadNameCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Name *',
                            filled: true,
                            fillColor: AppTheme.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newLeadPhoneCtrl,
                          onChanged: (_) => setState(() {}),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone *',
                            filled: true,
                            fillColor: AppTheme.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _showAddNewLead = false;
                                  _editingLeadIndex = null;
                                  _newLeadNameCtrl.clear();
                                  _newLeadPhoneCtrl.clear();
                                }),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.textSecondary,
                                  side: BorderSide(color: AppTheme.surface200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed:
                                    (_newLeadNameCtrl.text.trim().isEmpty ||
                                        _newLeadPhoneCtrl.text.trim().isEmpty)
                                    ? null
                                    : () {
                                        final newLead = {
                                          'name': _newLeadNameCtrl.text.trim(),
                                          'phone': _newLeadPhoneCtrl.text
                                              .trim(),
                                          'id': '',
                                        };
                                        setState(() {
                                          if (_editingLeadIndex != null) {
                                            _videoCallLeads[_editingLeadIndex!] =
                                                newLead;
                                          } else {
                                            _videoCallLeads.add(newLead);
                                          }
                                          _showAddNewLead = false;
                                          _editingLeadIndex = null;
                                          _newLeadNameCtrl.clear();
                                          _newLeadPhoneCtrl.clear();
                                        });
                                      },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  _editingLeadIndex != null ? 'Update' : 'Add',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 8),
              // Add to Reminders toggle with expanded fields
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
                                if (v) {
                                  _alarmDate = _selectedDate;
                                  _alarmTime = _selectedTime;
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
                                        _selectedDate ??
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
                                        _selectedTime ??
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
                      // Remind Before
                      Text(
                        'Remind Me Before',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _remindBeforeOptions.map((o) {
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
                                    : AppTheme.surfaceLight,
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
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _repeatOptions.map((o) {
                          final sel = _repeat == o;
                          return GestureDetector(
                            onTap: () => setState(() => _repeat = o),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppTheme.primaryContainer
                                    : AppTheme.surfaceLight,
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
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _notifyOptions.map((o) {
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
                                    : AppTheme.surfaceLight,
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave
                      ? () {
                          final date = _selectedDate!;
                          final time = _selectedTime!;
                          final sessionDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );

                          // For video call: use first lead as primary, rest as participants
                          final isVideoCall = _selectedType == 'Video Call';
                          final String customerName;
                          final String customerId;
                          final String customerPhone;
                          final List<String> participantNames;
                          if (isVideoCall) {
                            final firstLead = _videoCallLeads.first;
                            customerName = firstLead['name'] as String? ?? '';
                            customerId = firstLead['id'] as String? ?? '';
                            customerPhone = firstLead['phone'] as String? ?? '';
                            participantNames = _videoCallLeads
                                .map((l) => l['name'] as String? ?? '')
                                .toList();
                          } else {
                            final lead = _selectedLead!;
                            customerName = lead['name'] as String? ?? '';
                            customerId = lead['id'] as String? ?? '';
                            customerPhone = lead['phone'] as String? ?? '';
                            participantNames = [customerName];
                          }

                          // Conflict check (only for non-video or first lead)
                          final conflict = globalSessionMaps.any((m) {
                            final mStatus = m['status'] as String;
                            if (mStatus == 'Completed' ||
                                mStatus == 'Cancelled') {
                              return false;
                            }
                            final mLead = m['linkedLead'] as String;
                            final mLeadId = m['linkedLeadId'] as String? ?? '';
                            return mLead == customerName ||
                                (customerId.isNotEmpty &&
                                    mLeadId == customerId);
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
                                        'Customer Conflict',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  '$customerName is already in an active session. A customer cannot be in more than one active session at a time.',
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
                          // Meeting link based on video call mode
                          String meetingLink = '';
                          String videoCallMode = '';
                          if (isVideoCall) {
                            videoCallMode = _videoCallMode;
                            if (_videoCallMode == 'Inbuilt') {
                              meetingLink =
                                  'meet.google.com/${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
                            } else {
                              meetingLink = _thirdPartyLinkCtrl.text.trim();
                            }
                          }
                          final lead = isVideoCall
                              ? (_videoCallLeads.isNotEmpty
                                    ? _videoCallLeads.first
                                    : <String, dynamic>{})
                              : _selectedLead!;
                          final newSession = {
                            'id':
                                'ses-${DateTime.now().millisecondsSinceEpoch}',
                            'title': _titleCtrl.text.trim(),
                            'type': _selectedType,
                            'status': 'Scheduled',
                            'date': sessionDate,
                            'host': _selectedAgent!.name,
                            'hostInitials': _selectedAgent!.initials,
                            'participants': participantNames,
                            'linkedLead': customerName,
                            'linkedLeadId': customerId,
                            'customerPhone': customerPhone,
                            'preferredContact': isVideoCall
                                ? <String>['Video Call']
                                : (lead['preferredContact'] as List?)
                                          ?.cast<String>() ??
                                      <String>[],
                            'meetingLink': meetingLink,
                            'videoCallMode': videoCallMode,
                            'platform': _selectedType == 'Video Call'
                                ? 'Online'
                                : _selectedType == 'Appointment'
                                ? 'In-Person'
                                : 'Phone',
                            'recording': false,
                            'notes': '',
                            'actionItems': <String>[],
                            'outcome': '',
                            'rating': 0,
                            'agenda': '',
                            'location': _selectedType == 'Appointment'
                                ? _locationCtrl.text.trim()
                                : '',
                            'reminderSent': false,
                            'followUpScheduled': false,
                            'dealValue': 0.0,
                            'priority': _priority,
                            'createdAt': DateTime.now(),
                            'videoCallCount': 0,
                            'callCount': 0,
                            'appointmentCount': 0,
                            'isExistingCustomer': isVideoCall
                                ? false
                                : (lead['isExistingCustomer'] ?? false),
                            // Store all video call leads for display
                            'videoCallLeads': isVideoCall
                                ? List<Map<String, dynamic>>.from(
                                    _videoCallLeads,
                                  )
                                : <Map<String, dynamic>>[],
                          };
                          Navigator.pop(context);
                          // Auto-create reminder if toggle is on
                          if (_addToReminders) {
                            final sessionId =
                                'ses-${DateTime.now().millisecondsSinceEpoch}';
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
                                  'rem-ses-${DateTime.now().millisecondsSinceEpoch}',
                              'title':
                                  '$customerName — $_selectedType: ${_titleCtrl.text.trim()}',
                              'type': 'Meeting',
                              'reminderTag': _selectedType,
                              'status': 'Active',
                              'priority': _priority,
                              'dateTime': sessionDate,
                              'alarmDateTime': alarmDt,
                              'hasAlarm': _hasAlarm && alarmDt != null,
                              'repeatFrequency': _repeat,
                              'remindBefore': _remindBefore,
                              'notifyVia': List<String>.from(_notifyVia),
                              'linkedLead': customerName,
                              'linkedLeadId': customerId,
                              'linkedLeadPhone': customerPhone,
                              'linkedLeadEmail': isVideoCall
                                  ? ''
                                  : (lead['email'] as String? ?? ''),
                              'assignedHost': _selectedAgent!.name,
                              'assignedHostInitials': _selectedAgent!.initials,
                              'snoozed': false,
                              'snoozeUntil': null,
                              'snoozeCount': 0,
                              'notes': '',
                              'createdAt': DateTime.now(),
                              'isCompleted': false,
                              'linkedFollowUpId': null,
                              'linkedSessionId': sessionId,
                            });
                          }
                          widget.onSave(newSession);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Schedule Session',
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

// ─── Single Agent Picker (for schedule action assign member) ──────────────────

class _SingleAgentPicker extends StatefulWidget {
  final List<_AgentInfo> agents;
  final _AgentInfo? selected;
  final ValueChanged<_AgentInfo> onSelect;
  const _SingleAgentPicker({
    required this.agents,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_SingleAgentPicker> createState() => _SingleAgentPickerState();
}

class _SingleAgentPickerState extends State<_SingleAgentPicker> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_AgentInfo> get _filtered {
    List<_AgentInfo> list;
    if (_query.isEmpty) {
      list = List.from(widget.agents);
    } else {
      final q = _query.toLowerCase();
      list = widget.agents
          .where(
            (a) =>
                a.name.toLowerCase().contains(q) ||
                a.role.toLowerCase().contains(q),
          )
          .toList();
    }
    // Selected agent always at top
    if (widget.selected != null) {
      list.removeWhere((a) => a.name == widget.selected!.name);
      final sel = widget.agents.firstWhere(
        (a) => a.name == widget.selected!.name,
        orElse: () => widget.selected!,
      );
      list.insert(0, sel);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search agents...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 16,
                color: AppTheme.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              isDense: true,
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
        ),
        const SizedBox(height: 6),
        ..._filtered.map((a) {
          final sel = widget.selected?.name == a.name;
          return InkWell(
            onTap: () => widget.onSelect(a),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              decoration: sel
                  ? BoxDecoration(
                      color: a.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: a.color.withAlpha(40),
                    child: Text(
                      a.initials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: a.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          a.role,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (sel)
                    Icon(Icons.check_circle_rounded, color: a.color, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final List<String> selectedHosts;
  final List<String> selectedTypes;
  final List<String> selectedStatuses;
  final List<String> hostOptions;
  final List<String> typeOptions;
  final bool? existingCustomerFilter;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final void Function(
    List<String> hosts,
    List<String> types,
    List<String> statuses,
    bool? existingCustomer,
    DateTime? from,
    DateTime? to,
  )
  onApply;

  const _FilterSheet({
    required this.selectedHosts,
    required this.selectedTypes,
    required this.selectedStatuses,
    required this.hostOptions,
    required this.typeOptions,
    required this.existingCustomerFilter,
    required this.dateFrom,
    required this.dateTo,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late List<String> _hosts;
  late List<String> _types;
  late List<String> _statuses;
  bool? _existingCustomer;
  DateTime? _from;
  DateTime? _to;

  static const _statusOptions = [
    'Upcoming',
    'Completed',
    'Dues',
    'Rescheduled',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _hosts = List.from(widget.selectedHosts);
    _types = List.from(widget.selectedTypes);
    _statuses = List.from(widget.selectedStatuses);
    _existingCustomer = widget.existingCustomerFilter;
    _from = widget.dateFrom;
    _to = widget.dateTo;
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

  Color _statusColor(String st) {
    switch (st) {
      case 'Upcoming':
        return AppTheme.primary;
      case 'Completed':
        return AppTheme.success;
      case 'Dues':
        return const Color(0xFFDC2626);
      case 'Rescheduled':
        return const Color(0xFF8B5CF6);
      case 'Cancelled':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  'Filter Sessions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _hosts.clear();
                    _types.clear();
                    _statuses.clear();
                    _existingCustomer = null;
                    _from = null;
                    _to = null;
                  }),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.error,
                      fontSize: 13,
                    ),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status filter
                  Text(
                    'Status',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _statusOptions.map((st) {
                      final sel = _statuses.contains(st);
                      final color = _statusColor(st);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _statuses.remove(st);
                          } else {
                            _statuses.add(st);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? color.withAlpha(25)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? color : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            st,
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
                  const SizedBox(height: 16),
                  // Session Type
                  Text(
                    'Session Type',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.typeOptions.map((t) {
                      final sel = _types.contains(t);
                      final color = t == 'Video Call'
                          ? const Color(0xFF0891B2)
                          : t == 'Appointment'
                          ? const Color(0xFF8B5CF6)
                          : AppTheme.success;
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _types.remove(t);
                          } else {
                            _types.add(t);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? color.withAlpha(25)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? color : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            t,
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
                  const SizedBox(height: 16),
                  // Existing Customer
                  Text(
                    'Existing Customer',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _existingCustomer = null),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _existingCustomer == null
                                ? AppTheme.primaryContainer
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _existingCustomer == null
                                  ? AppTheme.primary
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            'All',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _existingCustomer == null
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _existingCustomer = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _existingCustomer == true
                                ? AppTheme.success.withAlpha(25)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _existingCustomer == true
                                  ? AppTheme.success
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _existingCustomer == true
                                  ? AppTheme.success
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _existingCustomer = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _existingCustomer == false
                                ? AppTheme.error.withAlpha(25)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _existingCustomer == false
                                  ? AppTheme.error
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _existingCustomer == false
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Assigned Host
                  Text(
                    'Assigned Host',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SessionAssignedFilter(
                    selectedHosts: _hosts,
                    onChanged: (h) => setState(() => _hosts = h),
                  ),
                  const SizedBox(height: 16),
                  // Date Range
                  Text(
                    'Date Range',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
                              initialDate: _from ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (d != null) setState(() => _from = d);
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
                                color: _from != null
                                    ? AppTheme.primary.withAlpha(60)
                                    : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _from != null ? _formatDate(_from!) : 'From',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: _from != null
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
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _to ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (d != null) setState(() => _to = d);
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
                                color: _to != null
                                    ? AppTheme.primary.withAlpha(60)
                                    : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _to != null ? _formatDate(_to!) : 'To',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: _to != null
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onApply(
                          _hosts,
                          _types,
                          _statuses,
                          _existingCustomer,
                          _from,
                          _to,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
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
}

// ─── Session Assigned Filter (search bar + list rows) ─────────────────────────

class _SessionAssignedFilter extends StatefulWidget {
  final List<String> selectedHosts;
  final ValueChanged<List<String>> onChanged;
  const _SessionAssignedFilter({
    required this.selectedHosts,
    required this.onChanged,
  });

  @override
  State<_SessionAssignedFilter> createState() => _SessionAssignedFilterState();
}

class _SessionAssignedFilterState extends State<_SessionAssignedFilter> {
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
        .where((a) => widget.selectedHosts.contains(a.name))
        .toList();
    final unselected = _kAgents
        .where((a) => !widget.selectedHosts.contains(a.name))
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
          'Select all agents',
          '',
          AppTheme.primary,
          widget.selectedHosts.isEmpty ||
              widget.selectedHosts.length == _kAgents.length,
          () {
            if (widget.selectedHosts.isEmpty ||
                widget.selectedHosts.length == _kAgents.length) {
              widget.onChanged([]);
            } else {
              widget.onChanged(_kAgents.map((a) => a.name).toList());
            }
          },
        ),
        ..._displayList.map(
          (a) => _buildRow(
            a.initials,
            a.name,
            a.role,
            a.id,
            a.color,
            widget.selectedHosts.contains(a.name),
            () {
              final updated = List<String>.from(widget.selectedHosts);
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

class _SortSheet extends StatelessWidget {
  final _SessionSortOption current;
  final void Function(_SessionSortOption) onSelect;

  const _SortSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        _SessionSortOption.dateAscending,
        'Date (Ascending)',
        Icons.arrow_upward_rounded,
      ),
      (
        _SessionSortOption.dateDescending,
        'Date (Descending)',
        Icons.arrow_downward_rounded,
      ),
      (
        _SessionSortOption.priorityHigh,
        'Priority (High First)',
        Icons.flag_rounded,
      ),
      (
        _SessionSortOption.leadAZ,
        'Lead Name (A-Z)',
        Icons.sort_by_alpha_rounded,
      ),
    ];
    return Container(
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
                Text(
                  'Sort Sessions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...options.map((opt) {
            final isSelected = current == opt.$1;
            return ListTile(
              leading: Icon(
                opt.$3,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                size: 20,
              ),
              title: Text(
                opt.$2,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_rounded, color: AppTheme.primary, size: 18)
                  : null,
              onTap: () {
                Navigator.pop(context);
                onSelect(opt.$1);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final bool hasActive;
  final VoidCallback onTap;

  const _HeaderButton({
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
          color: hasActive
              ? AppTheme.primary.withAlpha(20)
              : AppTheme.surface100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasActive
                ? AppTheme.primary.withAlpha(60)
                : AppTheme.surface200,
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

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
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

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
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
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
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
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CountChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CountBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _DisabledMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _DisabledMenuTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      ),
      trailing: Icon(Icons.lock_rounded, size: 14, color: color),
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
        border: Border.all(color: AppTheme.primary.withAlpha(60)),
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
            child: Icon(Icons.close_rounded, size: 12, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SDetailSection extends StatelessWidget {
  final String title;
  const _SDetailSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}

class _SDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
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

// Full-width stacked action row for bottom sheet
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int count;
  const _ActionRow({
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

// Disabled full-width action row
class _ActionRowDisabled extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;
  const _ActionRowDisabled({
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

// ─── Template Picker Sheet ────────────────────────────────────────────────────

class _TemplatePickerSheet extends StatefulWidget {
  final String actionLabel;
  final List<Map<String, dynamic>> templates;
  final String customerName;
  final bool isWhatsApp;
  final void Function(String templateBody) onUseTemplate;
  final VoidCallback onCustomMessage;

  const _TemplatePickerSheet({
    required this.actionLabel,
    required this.templates,
    required this.customerName,
    this.isWhatsApp = false,
    required this.onUseTemplate,
    required this.onCustomMessage,
  });

  @override
  State<_TemplatePickerSheet> createState() => _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends State<_TemplatePickerSheet> {
  final _customCtrl = TextEditingController();
  bool _showCustom = false;

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _openWhatsApp(String message) {
    // Simulate opening WhatsApp
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.chat_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Opening WhatsApp for ${widget.customerName}...',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    widget.onUseTemplate(message);
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

// ─── Lead Detail Wrapper (for back navigation to session details) ─────────────
// This is a placeholder - actual navigation uses context.push which respects back stack
