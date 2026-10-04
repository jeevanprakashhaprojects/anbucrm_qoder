import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart' as leads_list;

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> globalReminderMaps = [
  {
    'id': 'rem-001',
    'title': 'Policy renewal due',
    'type': 'Policy Renewal',
    'reminderTag': 'Policy Renewal',
    'status': 'Active',
    'priority': 'High',
    'dateTime': DateTime.now().add(const Duration(hours: 1)),
    'alarmDateTime': DateTime.now().add(const Duration(hours: 1)),
    'hasAlarm': true,
    'repeatFrequency': 'Yearly',
    'remindBefore': '15 minutes',
    'notifyVia': ['Push', 'In-App', 'WhatsApp'],
    'linkedLead': 'Rahul Mehta',
    'linkedLeadId': 'default-1',
    'linkedLeadPhone': '+91 98765 43210',
    'linkedLeadEmail': 'rahul@example.com',
    'assignedHost': 'Priya Sharma',
    'assignedHostInitials': 'PS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Life insurance annual premium due. Amount: ₹25,000.',
    'createdAt': DateTime.now().subtract(const Duration(days: 360)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-002',
    'title': 'Follow-up call',
    'type': 'Follow-up',
    'reminderTag': 'Follow-up',
    'status': 'Active',
    'priority': 'Medium',
    'dateTime': DateTime.now().add(const Duration(hours: 3)),
    'alarmDateTime': null,
    'hasAlarm': false,
    'repeatFrequency': 'None',
    'remindBefore': '30 minutes',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': 'Sneha Kapoor',
    'linkedLeadId': 'default-2',
    'linkedLeadPhone': '+91 87654 32109',
    'linkedLeadEmail': '',
    'assignedHost': 'Rahul Singh',
    'assignedHostInitials': 'RS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 1,
    'notes': 'Call to discuss health insurance comparison sheet.',
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'isCompleted': false,
    'linkedFollowUpId': 'fu-002',
    'linkedSessionId': null,
  },
  {
    'id': 'rem-003',
    'title': 'Proposal review session',
    'type': 'Meeting',
    'reminderTag': 'Appointment',
    'status': 'Snoozed',
    'priority': 'High',
    'dateTime': DateTime.now().add(const Duration(hours: 5)),
    'alarmDateTime': DateTime.now().add(const Duration(hours: 4, minutes: 45)),
    'hasAlarm': true,
    'repeatFrequency': 'None',
    'remindBefore': '1 hour',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': 'Vikram Singh',
    'linkedLeadId': 'default-3',
    'linkedLeadPhone': '+91 76543 21098',
    'linkedLeadEmail': 'vikram@example.com',
    'assignedHost': 'Priya Sharma',
    'assignedHostInitials': 'PS',
    'snoozed': true,
    'snoozeUntil': DateTime.now().add(const Duration(hours: 4)),
    'snoozeCount': 2,
    'notes': 'In-person meeting at client office.',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': 'ses-003',
  },
  {
    'id': 'rem-004',
    'title': 'Weekly pipeline review',
    'type': 'Team Meeting',
    'reminderTag': 'Team Meeting',
    'status': 'Active',
    'priority': 'Medium',
    'dateTime': DateTime.now().add(const Duration(days: 3)),
    'alarmDateTime': null,
    'hasAlarm': false,
    'repeatFrequency': 'Weekly',
    'remindBefore': '1 hour',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': '',
    'linkedLeadId': '',
    'linkedLeadPhone': '',
    'linkedLeadEmail': '',
    'assignedHost': 'Priya Sharma',
    'assignedHostInitials': 'PS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Every Monday 10 AM — team pipeline review.',
    'createdAt': DateTime.now().subtract(const Duration(days: 30)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-005',
    'title': 'Contract signing deadline',
    'type': 'Deadline',
    'reminderTag': 'Deadline',
    'status': 'Active',
    'priority': 'High',
    'dateTime': DateTime.now().add(const Duration(days: 5)),
    'alarmDateTime': DateTime.now().add(const Duration(days: 4, hours: 9)),
    'hasAlarm': true,
    'repeatFrequency': 'None',
    'remindBefore': '1 day',
    'notifyVia': ['Push', 'In-App', 'WhatsApp'],
    'linkedLead': 'Mohammed Al-Rashid',
    'linkedLeadId': 'default-6',
    'linkedLeadPhone': '+971 50 123 4567',
    'linkedLeadEmail': 'mohammed@example.com',
    'assignedHost': 'Priya Sharma',
    'assignedHostInitials': 'PS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Key man insurance contract signing deadline.',
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-006',
    'title': 'Birthday greeting',
    'type': 'Birthday',
    'reminderTag': 'Birthday',
    'status': 'Active',
    'priority': 'Low',
    'dateTime': DateTime.now().add(const Duration(days: 7)),
    'alarmDateTime': null,
    'hasAlarm': false,
    'repeatFrequency': 'Yearly',
    'remindBefore': '1 day',
    'notifyVia': ['Push', 'WhatsApp'],
    'linkedLead': 'Anita Desai',
    'linkedLeadId': 'default-4',
    'linkedLeadPhone': '+91 65432 10987',
    'linkedLeadEmail': 'anita@example.com',
    'assignedHost': 'Ananya Patel',
    'assignedHostInitials': 'AP',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Send birthday wishes and check on policy renewal status.',
    'createdAt': DateTime.now().subtract(const Duration(days: 358)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-007',
    'title': 'SIP portfolio review',
    'type': 'Review',
    'reminderTag': 'Review',
    'status': 'Active',
    'priority': 'Medium',
    'dateTime': DateTime.now().subtract(const Duration(hours: 3)),
    'alarmDateTime': null,
    'hasAlarm': false,
    'repeatFrequency': 'Monthly',
    'remindBefore': '30 minutes',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': 'Karan Joshi',
    'linkedLeadId': 'default-5',
    'linkedLeadPhone': '+91 54321 09876',
    'linkedLeadEmail': '',
    'assignedHost': 'Kavya Menon',
    'assignedHostInitials': 'KM',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 3,
    'notes': 'Monthly SIP portfolio review.',
    'createdAt': DateTime.now().subtract(const Duration(days: 20)),
    'isCompleted': false,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-008',
    'title': 'Q3 target review',
    'type': 'Deadline',
    'reminderTag': 'Deadline',
    'status': 'Completed',
    'priority': 'High',
    'dateTime': DateTime.now().subtract(const Duration(days: 2)),
    'alarmDateTime': null,
    'hasAlarm': false,
    'repeatFrequency': 'Quarterly',
    'remindBefore': '1 day',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': '',
    'linkedLeadId': '',
    'linkedLeadPhone': '',
    'linkedLeadEmail': '',
    'assignedHost': 'Priya Sharma',
    'assignedHostInitials': 'PS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Q3 sales target review with management.',
    'createdAt': DateTime.now().subtract(const Duration(days: 90)),
    'isCompleted': true,
    'linkedFollowUpId': null,
    'linkedSessionId': null,
  },
  {
    'id': 'rem-009',
    'title': 'Retirement plan follow-up',
    'type': 'Follow-up',
    'reminderTag': 'Follow-up',
    'status': 'Active',
    'priority': 'High',
    'dateTime': DateTime.now().copyWith(hour: 14, minute: 30),
    'alarmDateTime': DateTime.now().copyWith(hour: 14, minute: 15),
    'hasAlarm': true,
    'repeatFrequency': 'None',
    'remindBefore': '15 minutes',
    'notifyVia': ['Push', 'In-App'],
    'linkedLead': 'Deepa Krishnan',
    'linkedLeadId': 'default-7',
    'linkedLeadPhone': '+91 54321 09876',
    'linkedLeadEmail': 'deepa@example.com',
    'assignedHost': 'Rahul Singh',
    'assignedHostInitials': 'RS',
    'snoozed': false,
    'snoozeUntil': null,
    'snoozeCount': 0,
    'notes': 'Follow up on retirement corpus planning.',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'isCompleted': false,
    'linkedFollowUpId': 'fu-012',
    'linkedSessionId': null,
  },
];

// ─── Agent Data ───────────────────────────────────────────────────────────────

class _AgentInfo {
  final String name;
  final String initials;
  final String role;
  final Color color;
  const _AgentInfo({
    required this.name,
    required this.initials,
    required this.role,
    required this.color,
  });
}

const _kAgents = [
  _AgentInfo(
    name: 'Priya Sharma',
    initials: 'PS',
    role: 'Admin',
    color: Color(0xFF7C3AED),
  ),
  _AgentInfo(
    name: 'Rahul Singh',
    initials: 'RS',
    role: 'Senior Rep',
    color: Color(0xFF059669),
  ),
  _AgentInfo(
    name: 'Ananya Patel',
    initials: 'AP',
    role: 'Manager',
    color: Color(0xFF0891B2),
  ),
  _AgentInfo(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    color: Color(0xFFEC4899),
  ),
  _AgentInfo(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    color: Color(0xFFF59E0B),
  ),
];

// ─── Sort Options ─────────────────────────────────────────────────────────────

enum _ReminderSortOption {
  dateAscending,
  dateDescending,
  priorityHigh,
  leadAZ,
  createdNewest,
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _reminders = [];
  _ReminderSortOption _sortOption = _ReminderSortOption.dateAscending;

  // Multiselect state
  bool _isMultiSelectMode = false;
  final Set<String> _selectedIds = {};

  // Filter state
  List<String> _selectedHosts = [];
  List<String> _selectedTypes = [];
  String? _selectedPriority;
  bool? _snoozedFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _showCompleted = false;
  bool _showUpcoming = false;
  bool _showOverdue = false;
  bool _showDueToday = false;

  // Section keys for scroll-to
  final _overdueKey = GlobalKey();
  final _dueTodayKey = GlobalKey();
  final _upcomingKey = GlobalKey();
  final _completedKey = GlobalKey();

  static const _typeOptions = [
    'Follow-up',
    'Meeting',
    'Policy Renewal',
    'Deadline',
    'Birthday',
    'Review',
    'Team Meeting',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _reminders = List.from(globalReminderMaps);
        _isLoading = false;
      });
    }
  }

  bool get _hasActiveFilters =>
      _selectedHosts.isNotEmpty ||
      _selectedTypes.isNotEmpty ||
      _selectedPriority != null ||
      _snoozedFilter != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _showCompleted ||
      _showUpcoming ||
      _showOverdue ||
      _showDueToday;

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  List<Map<String, dynamic>> get _filteredReminders {
    final q = _searchQuery.toLowerCase();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Map<String, dynamic>> result = _reminders.where((r) {
      // Status filter logic
      final bool anyStatusFilter =
          _showCompleted || _showUpcoming || _showOverdue || _showDueToday;

      if (anyStatusFilter) {
        bool matchesStatus = false;
        final dt = r['dateTime'] as DateTime;
        final d = DateTime(dt.year, dt.month, dt.day);
        if (_showCompleted && r['isCompleted'] == true) matchesStatus = true;
        if (_showUpcoming && r['isCompleted'] != true && d.isAfter(today)) {
          matchesStatus = true;
        }
        if (_showOverdue &&
            r['isCompleted'] != true &&
            dt.isBefore(now) &&
            !_isToday(dt)) {
          matchesStatus = true;
        }
        if (_showDueToday && r['isCompleted'] != true && _isToday(dt)) {
          matchesStatus = true;
        }
        if (!matchesStatus) return false;
      } else {
        // Default: show active (not completed)
        if (r['isCompleted'] == true) return false;
      }

      final matchesSearch =
          q.isEmpty ||
          (r['title'] as String).toLowerCase().contains(q) ||
          (r['linkedLead'] as String? ?? '').toLowerCase().contains(q) ||
          (r['type'] as String).toLowerCase().contains(q) ||
          (r['reminderTag'] as String? ?? '').toLowerCase().contains(q) ||
          (r['assignedHost'] as String? ?? '').toLowerCase().contains(q) ||
          (r['linkedLeadPhone'] as String? ?? '').contains(q);

      final matchesHost =
          _selectedHosts.isEmpty || _selectedHosts.contains(r['assignedHost']);
      final matchesType =
          _selectedTypes.isEmpty || _selectedTypes.contains(r['type']);
      final matchesPriority =
          _selectedPriority == null || r['priority'] == _selectedPriority;
      final matchesSnoozed =
          _snoozedFilter == null ||
          (_snoozedFilter == true && r['snoozed'] == true) ||
          (_snoozedFilter == false && r['snoozed'] != true);

      bool matchesDate = true;
      final dt = r['dateTime'] as DateTime;
      if (_dateFrom != null && dt.isBefore(_dateFrom!)) matchesDate = false;
      if (_dateTo != null &&
          dt.isAfter(_dateTo!.add(const Duration(days: 1)))) {
        matchesDate = false;
      }

      return matchesSearch &&
          matchesHost &&
          matchesType &&
          matchesPriority &&
          matchesSnoozed &&
          matchesDate;
    }).toList();

    // Apply sort
    switch (_sortOption) {
      case _ReminderSortOption.dateAscending:
        result.sort(
          (a, b) =>
              (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime),
        );
        break;
      case _ReminderSortOption.dateDescending:
        result.sort(
          (a, b) =>
              (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime),
        );
        break;
      case _ReminderSortOption.priorityHigh:
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        result.sort(
          (a, b) =>
              (order[a['priority']] ?? 1).compareTo(order[b['priority']] ?? 1),
        );
        break;
      case _ReminderSortOption.leadAZ:
        result.sort(
          (a, b) =>
              (a['linkedLead'] as String).compareTo(b['linkedLead'] as String),
        );
        break;
      case _ReminderSortOption.createdNewest:
        result.sort(
          (a, b) => (b['createdAt'] as DateTime).compareTo(
            a['createdAt'] as DateTime,
          ),
        );
        break;
    }
    return result;
  }

  List<Map<String, dynamic>> get _overdueReminders {
    final now = DateTime.now();
    return _filteredReminders.where((r) {
      if (r['isCompleted'] == true) return false;
      final dt = r['dateTime'] as DateTime;
      return dt.isBefore(now) && !_isToday(dt);
    }).toList()..sort(
      (a, b) =>
          (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime),
    );
  }

  List<Map<String, dynamic>> get _dueTodayReminders {
    return _filteredReminders.where((r) {
      if (r['isCompleted'] == true) return false;
      return _isToday(r['dateTime'] as DateTime);
    }).toList()..sort(
      (a, b) =>
          (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime),
    );
  }

  List<Map<String, dynamic>> get _upcomingReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _filteredReminders.where((r) {
      if (r['isCompleted'] == true) return false;
      final dt = r['dateTime'] as DateTime;
      final d = DateTime(dt.year, dt.month, dt.day);
      return d.isAfter(today);
    }).toList()..sort(
      (a, b) =>
          (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime),
    );
  }

  List<Map<String, dynamic>> get _completedReminders {
    return _reminders.where((r) => r['isCompleted'] == true).toList()..sort(
      (a, b) =>
          (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime),
    );
  }

  int get _totalCount =>
      _reminders.where((r) => r['isCompleted'] != true).length;
  int get _overdueCount => _reminders.where((r) {
    if (r['isCompleted'] == true) return false;
    final dt = r['dateTime'] as DateTime;
    return dt.isBefore(DateTime.now()) && !_isToday(dt);
  }).length;

  int get _dueTodayCount => _reminders.where((r) {
    if (r['isCompleted'] == true) return false;
    return _isToday(r['dateTime'] as DateTime);
  }).length;

  int get _upcomingCount => _reminders.where((r) {
    if (r['isCompleted'] == true) return false;
    final dt = r['dateTime'] as DateTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    return d.isAfter(today);
  }).length;

  int get _completedCount =>
      _reminders.where((r) => r['isCompleted'] == true).length;

  void _showNewReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _NewReminderSheet(
        onSave: (data) {
          globalReminderMaps.insert(0, data);
          setState(() => _reminders = List.from(globalReminderMaps));
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
                  Text('Reminder created!'),
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
      )),
    );
  }

  void _completeReminder(Map<String, dynamic> r) {
    final repeat = r['repeatFrequency'] as String? ?? 'None';
    final hasRepeat = repeat != 'None';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Complete Reminder',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mark "${r['title']}" as completed?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            if (hasRepeat) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.warning.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.autorenew_rounded,
                      size: 14,
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This reminder repeats $repeat. Remind again next cycle?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          if (hasRepeat) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _doComplete(r, rescheduleNext: true);
              },
              child: Text(
                'Yes, remind next cycle',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _doComplete(r, rescheduleNext: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              hasRepeat ? 'No, just complete' : 'Complete',
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

  void _doComplete(Map<String, dynamic> r, {required bool rescheduleNext}) {
    final timeline = List<Map<String, dynamic>>.from(
      (r['timeline'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    );
    timeline.add({
      'event': 'Completed',
      'timestamp': DateTime.now(),
      'note': rescheduleNext ? 'Completed — next cycle scheduled' : 'Completed',
    });
    setState(() {
      r['isCompleted'] = true;
      r['status'] = 'Completed';
      r['completedAt'] = DateTime.now();
      r['timeline'] = timeline;
      if (rescheduleNext) {
        final repeat = r['repeatFrequency'] as String? ?? 'None';
        final dt = r['dateTime'] as DateTime;
        DateTime nextDt;
        switch (repeat) {
          case 'Daily':
            nextDt = dt.add(const Duration(days: 1));
            break;
          case 'Weekly':
            nextDt = dt.add(const Duration(days: 7));
            break;
          case 'Monthly':
            nextDt = DateTime(
              dt.year,
              dt.month + 1,
              dt.day,
              dt.hour,
              dt.minute,
            );
            break;
          case 'Yearly':
            nextDt = DateTime(
              dt.year + 1,
              dt.month,
              dt.day,
              dt.hour,
              dt.minute,
            );
            break;
          default:
            nextDt = dt;
        }
        final newReminder = Map<String, dynamic>.from(r);
        newReminder['id'] = 'rem-${DateTime.now().millisecondsSinceEpoch}';
        newReminder['isCompleted'] = false;
        newReminder['status'] = 'Active';
        newReminder['dateTime'] = nextDt;
        newReminder['snoozed'] = false;
        newReminder['snoozeCount'] = 0;
        newReminder['snoozeUntil'] = null;
        newReminder['timeline'] = [];
        newReminder['createdAt'] = DateTime.now();
        globalReminderMaps.add(newReminder);
      }
      _reminders = List.from(globalReminderMaps);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          rescheduleNext
              ? 'Completed! Next reminder scheduled.'
              : 'Reminder completed!',
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _completeMultiselect() {
    if (_selectedIds.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Complete ${_selectedIds.length} Reminders',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mark ${_selectedIds.length} reminders as completed?',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.error.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded, size: 14, color: AppTheme.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '⚠️ Warning: Completing via multiselect will disable repeat reminders. Recurring reminders will NOT be rescheduled for the next cycle. Use individual complete to keep repeat reminders active.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                for (final r in _reminders) {
                  if (_selectedIds.contains(r['id'] as String?)) {
                    r['isCompleted'] = true;
                    r['status'] = 'Completed';
                    r['completedAt'] = DateTime.now();
                  }
                }
                _selectedIds.clear();
                _isMultiSelectMode = false;
                _reminders = List.from(globalReminderMaps);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Complete All',
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

  void _showSnoozeSheet(Map<String, dynamic> r) {
    final hasAlarm = r['hasAlarm'] == true;
    if (!hasAlarm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Snooze is only available for reminders with an alarm set.',
          ),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _SnoozeSheet(
        reminder: r,
        onSnooze: (newDt) {
          final timeline = List<Map<String, dynamic>>.from(
            (r['timeline'] as List?)?.cast<Map<String, dynamic>>() ?? [],
          );
          timeline.add({
            'event': 'Snoozed',
            'timestamp': DateTime.now(),
            'note': 'Snoozed until $newDt',
          });
          setState(() {
            r['snoozed'] = true;
            r['status'] = 'Snoozed';
            r['snoozeUntil'] = newDt;
            r['dateTime'] = newDt;
            r['snoozeCount'] = (r['snoozeCount'] as int? ?? 0) + 1;
            r['timeline'] = timeline;
            _reminders = List.from(globalReminderMaps);
          });
        },
      )),
    );
  }

  void _showRescheduleSheet(Map<String, dynamic> r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _RescheduleSheet(
        reminder: r,
        onReschedule: (newDt) {
          final timeline = List<Map<String, dynamic>>.from(
            (r['timeline'] as List?)?.cast<Map<String, dynamic>>() ?? [],
          );
          final oldDt = r['dateTime'] as DateTime;
          timeline.add({
            'event': 'Rescheduled',
            'timestamp': DateTime.now(),
            'note': 'Rescheduled from $oldDt to $newDt',
          });
          setState(() {
            r['dateTime'] = newDt;
            r['status'] = 'Active';
            r['snoozed'] = false;
            r['timeline'] = timeline;
            _reminders = List.from(globalReminderMaps);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reminder rescheduled!'),
              backgroundColor: AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      )),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _ReminderFilterSheet(
        selectedHosts: List.from(_selectedHosts),
        selectedTypes: List.from(_selectedTypes),
        selectedPriority: _selectedPriority,
        snoozedFilter: _snoozedFilter,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        showCompleted: _showCompleted,
        showUpcoming: _showUpcoming,
        showOverdue: _showOverdue,
        showDueToday: _showDueToday,
        onApply:
            (
              hosts,
              types,
              priority,
              snoozed,
              from,
              to,
              showCompleted,
              showUpcoming,
              showOverdue,
              showDueToday,
            ) {
              setState(() {
                _selectedHosts = hosts;
                _selectedTypes = types;
                _selectedPriority = priority;
                _snoozedFilter = snoozed;
                _dateFrom = from;
                _dateTo = to;
                _showCompleted = showCompleted;
                _showUpcoming = showUpcoming;
                _showOverdue = showOverdue;
                _showDueToday = showDueToday;
              });
            },
      )),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _ReminderSortSheet(
        current: _sortOption,
        onSelect: (opt) => setState(() => _sortOption = opt),
      )),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedHosts = [];
      _selectedTypes = [];
      _selectedPriority = null;
      _snoozedFilter = null;
      _dateFrom = null;
      _dateTo = null;
      _showCompleted = false;
      _showUpcoming = false;
      _showOverdue = false;
      _showDueToday = false;
    });
  }

  void _scrollToSection(String section) {
    GlobalKey? key;
    switch (section) {
      case 'overdue':
        key = _overdueKey;
        break;
      case 'today':
        key = _dueTodayKey;
        break;
      case 'upcoming':
        key = _upcomingKey;
        break;
      case 'completed':
        key = _completedKey;
        break;
    }
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReminders;
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
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.alarm_rounded,
                    color: Color(0xFF0891B2),
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
                          'Reminders',
                          maxLines: 1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${filtered.length}/$_totalCount active',
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
                if (_isMultiSelectMode) _buildMultiselectBar(),
                if (_hasActiveFilters) _buildActiveFilterChips(),
                if (_hasActiveFilters) _buildFilteredCountBanner(filtered.length),
              ],
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            _buildSectionedList(),
        ],
      ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showNewReminderSheet,
              backgroundColor: const Color(0xFF0891B2),
              icon: const Icon(Icons.add_alarm_rounded, color: Colors.white),
              label: Text(
                'New Reminder',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildMultiselectBar() {
    return Container(
      color: const Color(0xFF0891B2).withAlpha(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.check_box_rounded,
            size: 18,
            color: const Color(0xFF0891B2),
          ),
          const SizedBox(width: 8),
          Text(
            '${_selectedIds.length} selected',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0891B2),
            ),
          ),
          const Spacer(),
          if (_selectedIds.isNotEmpty)
            GestureDetector(
              onTap: _completeMultiselect,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.success.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Complete All',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() {
              _isMultiSelectMode = false;
              _selectedIds.clear();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
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
              color: const Color(0xFF0891B2).withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0891B2).withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_list_rounded,
                  size: 13,
                  color: Color(0xFF0891B2),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    '$count reminder${count == 1 ? '' : 's'} found',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0891B2),
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
          hintText: 'Search reminders, leads, hosts...',
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
    // Match follow-ups KPI design (2nd image): card with icon box, big number, label, trend indicator
    final kpis = [
      _KpiData(
        'Total',
        '$_totalCount',
        Icons.alarm_rounded,
        const Color(0xFF0891B2),
        '+5%',
        true,
      ),
      _KpiData(
        'Today',
        '$_dueTodayCount',
        Icons.today_rounded,
        AppTheme.warning,
        '-$_dueTodayCount',
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
        const Color(0xFF8B5CF6),
        '-$_upcomingCount',
        false,
      ),
      _KpiData(
        'Completed',
        '$_completedCount',
        Icons.check_circle_rounded,
        AppTheme.success,
        '+$_completedCount',
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
        itemBuilder: (_, i) => _KpiCard(
          data: kpis[i],
          onTap: () {
            switch (i) {
              case 0:
                _scrollToSection('overdue');
                break;
              case 1:
                _scrollToSection('today');
                break;
              case 2:
                _scrollToSection('overdue');
                break;
              case 3:
                _scrollToSection('upcoming');
                break;
              case 4:
                _scrollToSection('completed');
                break;
            }
          },
        ),
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
          if (_selectedPriority != null)
            _ActiveFilterChip(
              label: 'Priority: $_selectedPriority',
              onRemove: () => setState(() => _selectedPriority = null),
            ),
          if (_snoozedFilter != null)
            _ActiveFilterChip(
              label: 'Snoozed: ${_snoozedFilter! ? 'Yes' : 'No'}',
              onRemove: () => setState(() => _snoozedFilter = null),
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
          if (_showOverdue)
            _ActiveFilterChip(
              label: 'Overdue',
              onRemove: () => setState(() => _showOverdue = false),
            ),
          if (_showDueToday)
            _ActiveFilterChip(
              label: 'Due Today',
              onRemove: () => setState(() => _showDueToday = false),
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
                  Icon(
                    Icons.clear_all_rounded,
                    size: 13,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error,
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

  Widget _buildSectionedList() {
    final overdue = _overdueReminders;
    final dueToday = _dueTodayReminders;
    final upcoming = _upcomingReminders;
    final completed = _completedReminders;

    if (overdue.isEmpty &&
        dueToday.isEmpty &&
        upcoming.isEmpty &&
        completed.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmpty(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.paddingOf(context).bottom + 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (overdue.isNotEmpty) ...[
            Container(key: _overdueKey),
            _buildSectionHeader('🔴 Overdue', overdue.length, AppTheme.error),
            ..._buildDateGroupedCards(overdue),
            const SizedBox(height: 8),
          ],
          if (dueToday.isNotEmpty) ...[
            Container(key: _dueTodayKey),
            _buildSectionHeader(
              '🟠 Due Today',
              dueToday.length,
              AppTheme.warning,
            ),
            ..._buildDateGroupedCards(dueToday),
            const SizedBox(height: 8),
          ],
          if (upcoming.isNotEmpty) ...[
            Container(key: _upcomingKey),
            _buildSectionHeader(
              '🔵 Upcoming',
              upcoming.length,
              const Color(0xFF0891B2),
            ),
            ..._buildDateGroupedCards(upcoming),
            const SizedBox(height: 8),
          ],
          if (completed.isNotEmpty) ...[
            Container(key: _completedKey),
            GestureDetector(
              onTap: () => setState(() => _showCompleted = !_showCompleted),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.success.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _showCompleted
                          ? 'Hide completed reminders'
                          : 'View ${completed.length} completed reminder${completed.length == 1 ? '' : 's'}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.success,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _showCompleted
                          ? Icons.expand_less_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),
            ),
            if (_showCompleted) ...[
              const SizedBox(height: 8),
              ..._buildDateGroupedCards(completed),
            ],
          ],
        ]),
      ),
    );
  }

  /// Build date-grouped cards: one header per date, items sorted asc by time within
  List<Widget> _buildDateGroupedCards(List<Map<String, dynamic>> items) {
    final List<Widget> widgets = [];
    String? lastDateKey;
    for (final r in items) {
      final dt = r['dateTime'] as DateTime;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(dt.year, dt.month, dt.day);
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
      final dateKey = '${d.day} ${months[d.month - 1]} ${d.year}';

      if (dateKey != lastDateKey) {
        lastDateKey = dateKey;
        // Date sub-header
        String label;
        if (d == today) {
          label = 'Today · $dateKey';
        } else if (d == today.subtract(const Duration(days: 1))) {
          label = 'Yesterday · $dateKey';
        } else if (d == today.add(const Duration(days: 1))) {
          label = 'Tomorrow · $dateKey';
        } else {
          label = dateKey;
        }
        widgets.add(
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.surface200),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(child: Divider(color: AppTheme.surface200, height: 1)),
              ],
            ),
          ),
        );
      }
      final idx = items.indexOf(r);
      widgets.add(
        _ReminderCard(
          reminder: r,
          index: idx,
          isSelected: _selectedIds.contains(r['id'] as String?),
          isMultiSelectMode: _isMultiSelectMode,
          onComplete: () => _completeReminder(r),
          onSnooze: () => _showSnoozeSheet(r),
          onReschedule: () => _showRescheduleSheet(r),
          onRefresh: () =>
              setState(() => _reminders = List.from(globalReminderMaps)),
          onLongPress: () {
            setState(() {
              _isMultiSelectMode = true;
              _selectedIds.add(r['id'] as String? ?? '');
            });
          },
          onTapSelect: () {
            setState(() {
              final id = r['id'] as String? ?? '';
              if (_selectedIds.contains(id)) {
                _selectedIds.remove(id);
                if (_selectedIds.isEmpty) _isMultiSelectMode = false;
              } else {
                _selectedIds.add(id);
              }
            });
          },
          onTapDetail: () => _showReminderDetail(context, r),
        ),
      );
    }
    return widgets;
  }

  void _showReminderDetail(BuildContext context, Map<String, dynamic> r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _ReminderDetailSheet(
        reminder: r,
        onSnooze: () => _showSnoozeSheet(r),
        onReschedule: () => _showRescheduleSheet(r),
      )),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No reminders found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + New Reminder to create one',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
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
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color.withAlpha(40), height: 1)),
        ],
      ),
    );
  }
}

// ─── KPI Data ─────────────────────────────────────────────────────────────────

class _KpiData {
  final String label;
  final String count;
  final IconData icon;
  final Color color;
  final String subtitle;
  final bool isPositive;
  const _KpiData(
    this.label,
    this.count,
    this.icon,
    this.color,
    this.subtitle,
    this.isPositive,
  );
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  final VoidCallback? onTap;
  const _KpiCard({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                if (data.subtitle.isNotEmpty)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          data.isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          size: 11,
                          color: data.isPositive ? AppTheme.success : AppTheme.warning,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            data.subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: data.isPositive ? AppTheme.success : AppTheme.warning,
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
              data.count,
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
      ),
    );
  }
}

// ─── Reminder Card ────────────────────────────────────────────────────────────

class _ReminderCard extends StatefulWidget {
  final Map<String, dynamic> reminder;
  final int index;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onComplete;
  final VoidCallback onSnooze;
  final VoidCallback onReschedule;
  final VoidCallback onRefresh;
  final VoidCallback onLongPress;
  final VoidCallback onTapSelect;
  final VoidCallback onTapDetail;

  const _ReminderCard({
    required this.reminder,
    required this.index,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onComplete,
    required this.onSnooze,
    required this.onReschedule,
    required this.onRefresh,
    required this.onLongPress,
    required this.onTapSelect,
    required this.onTapDetail,
  });

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

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

  Color _typeColor(String t) {
    switch (t) {
      case 'Policy Renewal':
        return AppTheme.success;
      case 'Follow-up':
        return AppTheme.warning;
      case 'Meeting':
        return const Color(0xFF8B5CF6);
      case 'Team Meeting':
        return AppTheme.primary;
      case 'Deadline':
        return AppTheme.error;
      case 'Birthday':
        return const Color(0xFFEC4899);
      case 'Review':
        return const Color(0xFF0891B2);
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Policy Renewal':
        return Icons.autorenew_rounded;
      case 'Follow-up':
        return Icons.repeat_rounded;
      case 'Meeting':
        return Icons.people_rounded;
      case 'Team Meeting':
        return Icons.groups_rounded;
      case 'Deadline':
        return Icons.flag_rounded;
      case 'Birthday':
        return Icons.cake_rounded;
      case 'Review':
        return Icons.rate_review_rounded;
      default:
        return Icons.alarm_rounded;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'High':
        return AppTheme.error;
      case 'Medium':
        return AppTheme.warning;
      case 'Low':
        return AppTheme.success;
      default:
        return AppTheme.textMuted;
    }
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
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
    final timeStr = '$h:${dt.minute.toString().padLeft(2, '0')} $ampm';
    final dateStr = '${dt.day} ${months[dt.month - 1]}';
    if (diff.isNegative) {
      final abs = diff.abs();
      if (abs.inMinutes < 60) return '${abs.inMinutes}m ago · $timeStr';
      if (abs.inHours < 24) return '${abs.inHours}h ago · $timeStr';
      return '$dateStr · $timeStr';
    }
    if (diff.inMinutes < 60) return 'In ${diff.inMinutes}m · $timeStr';
    if (diff.inHours < 24) return 'In ${diff.inHours}h · $timeStr';
    if (diff.inDays == 1) return 'Tomorrow · $timeStr';
    return '$dateStr · $timeStr';
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

  Color _agentColor(String initials) {
    const colors = [
      Color(0xFF7C3AED),
      Color(0xFF059669),
      Color(0xFF0891B2),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
    ];
    if (initials.isEmpty) return colors[0];
    return colors[initials.codeUnitAt(0) % colors.length];
  }

  bool get _isConnected {
    final r = widget.reminder;
    final fuId = r['linkedFollowUpId'] as String?;
    final sesId = r['linkedSessionId'] as String?;
    return (fuId != null && fuId.isNotEmpty) ||
        (sesId != null && sesId.isNotEmpty);
  }

  void _showThreeDots(BuildContext context) {
    final r = widget.reminder;
    final phone = (r['linkedLeadPhone'] as String?) ?? '';
    final email = (r['linkedLeadEmail'] as String?) ?? '';
    final isConnected = _isConnected;
    final isCompleted = r['isCompleted'] == true;
    final snoozeCount = r['snoozeCount'] as int? ?? 0;
    final hasPhone = phone.isNotEmpty;
    final hasEmail = email.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 24,
        ),
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
            const SizedBox(height: 12),
            // Lead info header
            if ((r['linkedLead'] as String? ?? '').isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primary.withAlpha(30),
                      child: Text(
                        (r['linkedLead'] as String)[0],
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
                            r['linkedLead'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                          if (hasPhone)
                            Text(
                              phone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Show Call/SMS/WhatsApp only if phone exists
            if (hasPhone) ...[
              _MenuOption(
                icon: Icons.phone_rounded,
                label: 'Call',
                color: AppTheme.success,
                onTap: () => Navigator.pop(context),
              ),
              _MenuOption(
                icon: Icons.message_rounded,
                label: 'SMS',
                color: AppTheme.primary,
                onTap: () => Navigator.pop(context),
              ),
              _MenuOption(
                icon: Icons.chat_rounded,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => Navigator.pop(context),
              ),
            ],
            // Show Email only if email exists
            if (hasEmail)
              _MenuOption(
                icon: Icons.email_rounded,
                label: 'Email',
                color: const Color(0xFF0891B2),
                onTap: () => Navigator.pop(context),
              ),
            // Telegram always shown if lead exists
            if ((r['linkedLead'] as String? ?? '').isNotEmpty)
              _MenuOption(
                icon: Icons.telegram,
                label: 'Telegram',
                color: const Color(0xFF229ED9),
                onTap: () => Navigator.pop(context),
              ),
            if (hasPhone ||
                hasEmail ||
                (r['linkedLead'] as String? ?? '').isNotEmpty)
              const Divider(height: 16),
            // Snooze — only if alarm set
            if (r['hasAlarm'] == true)
              _MenuOption(
                icon: Icons.snooze_rounded,
                label: 'Snooze ($snoozeCount times snoozed)',
                color: AppTheme.textSecondary,
                onTap: () {
                  Navigator.pop(context);
                  widget.onSnooze();
                },
              ),
            // Reschedule
            _MenuOption(
              icon: Icons.edit_calendar_rounded,
              label: 'Reschedule',
              color: AppTheme.primary,
              onTap: () {
                Navigator.pop(context);
                widget.onReschedule();
              },
            ),
            // Complete
            if (!isCompleted)
              _MenuOption(
                icon: Icons.check_circle_rounded,
                label: 'Mark Complete',
                color: AppTheme.success,
                onTap: () {
                  Navigator.pop(context);
                  widget.onComplete();
                },
              ),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reminder;
    final isCompleted = r['isCompleted'] == true;
    final isSnoozed = r['snoozed'] == true;
    final typeColor = _typeColor(r['type'] as String);
    final dt = r['dateTime'] as DateTime;
    final now = DateTime.now();
    final isOverdue = dt.isBefore(now) && !isCompleted;
    final channels = (r['notifyVia'] as List?)?.cast<String>() ?? [];
    final snoozeCount = r['snoozeCount'] as int? ?? 0;
    final hostInitials = (r['assignedHostInitials'] as String?) ?? 'PS';
    final hostName = (r['assignedHost'] as String?) ?? '';
    final linkedLead = (r['linkedLead'] as String?) ?? '';
    final linkedPhone = (r['linkedLeadPhone'] as String?) ?? '';
    final reminderTag = (r['reminderTag'] as String?) ?? (r['type'] as String);
    final hasAlarm = r['hasAlarm'] == true;
    final isConnected = _isConnected;
    final priority = (r['priority'] as String?) ?? 'Medium';

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onLongPress: widget.isMultiSelectMode ? null : widget.onLongPress,
          onTap: widget.isMultiSelectMode
              ? widget.onTapSelect
              : widget.onTapDetail,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? const Color(0xFF0891B2).withAlpha(15)
                  : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? const Color(0xFF0891B2)
                    : isCompleted
                    ? AppTheme.surface200
                    : isOverdue
                    ? AppTheme.error.withAlpha(80)
                    : isSnoozed
                    ? AppTheme.textMuted.withAlpha(60)
                    : isConnected
                    ? AppTheme.primary.withAlpha(60)
                    : AppTheme.surface200,
                width: isOverdue || isConnected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Connected banner
                if (isConnected && !isCompleted)
                  GestureDetector(
                    onTap: widget.onComplete, // Navigate directly
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            size: 12,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Connected to ${(r['linkedFollowUpId'] as String? ?? '').isNotEmpty ? 'Follow-up' : 'Session'} — Tap to go there',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Icon + Title + 3-dots (NO colored dot)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.surface200
                                  : typeColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _typeIcon(r['type'] as String),
                              size: 18,
                              color: isCompleted
                                  ? AppTheme.textMuted
                                  : typeColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['title'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? AppTheme.textMuted
                                        : AppTheme.textPrimary,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (linkedLead.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        size: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        linkedLead,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (linkedPhone.isNotEmpty) ...[
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.phone_rounded,
                                          size: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            linkedPhone,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: AppTheme.textSecondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // NO 3-dots button — tap card to see all details + actions
                          // (removed separate 3-dots as per user request)
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row 2: Assigned host + date/time (full date and time shown)
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _agentColor(hostInitials),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                hostInitials,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            hostName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: isOverdue
                                ? AppTheme.error
                                : AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatFullDateTime(dt),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isOverdue
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Interest tags + existing customer tag
                      Builder(
                        builder: (_) {
                          final interestTags =
                              (r['interestTags'] as List?)?.cast<String>() ??
                              [];
                          final isExistingCustomer =
                              (r['linkedLeadId'] as String? ?? '').isNotEmpty;
                          if (interestTags.isEmpty && !isExistingCustomer) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: [
                                if (isExistingCustomer)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF059669,
                                      ).withAlpha(15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF059669,
                                        ).withAlpha(50),
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
                                ...interestTags.map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
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
                                      t,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF0891B2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Row 3: Tags + snooze count + alarm + channels
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: typeColor.withAlpha(50),
                              ),
                            ),
                            child: Text(
                              reminderTag,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: typeColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Snooze count badge (unlimited)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: snoozeCount > 0
                                  ? AppTheme.warning.withAlpha(20)
                                  : AppTheme.surface100,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: snoozeCount > 0
                                    ? AppTheme.warning.withAlpha(60)
                                    : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.snooze_rounded,
                                  size: 10,
                                  color: snoozeCount > 0
                                      ? AppTheme.warning
                                      : AppTheme.textMuted,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  snoozeCount > 0
                                      ? '${snoozeCount}x snoozed'
                                      : 'No snooze',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: snoozeCount > 0
                                        ? AppTheme.warning
                                        : AppTheme.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hasAlarm) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0891B2).withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF0891B2).withAlpha(50),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.alarm_rounded,
                                    size: 10,
                                    color: Color(0xFF0891B2),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Alarm',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: const Color(0xFF0891B2),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          ...channels.take(3).map((ch) {
                            IconData ico;
                            switch (ch) {
                              case 'Push':
                                ico = Icons.notifications_rounded;
                                break;
                              case 'In-App':
                                ico = Icons.phone_android_rounded;
                                break;
                              case 'WhatsApp':
                                ico = Icons.chat_rounded;
                                break;
                              case 'Email':
                                ico = Icons.email_rounded;
                                break;
                              default:
                                ico = Icons.notifications_rounded;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                ico,
                                size: 13,
                                color: AppTheme.textMuted,
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Row 4: Snoozed badge + action buttons
                      Row(
                        children: [
                          if (isSnoozed) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.textMuted.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.snooze_rounded,
                                    size: 10,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Snoozed',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppTheme.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if ((r['repeatFrequency'] as String? ?? 'None') !=
                              'None') ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.surface200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.autorenew_rounded,
                                    size: 10,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    r['repeatFrequency'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          const Spacer(),
                          if (!isCompleted) ...[
                            // Complete tick button (always shown)
                            GestureDetector(
                              onTap: widget.onComplete,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.success.withAlpha(60),
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: AppTheme.success,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Snooze — only if alarm set
                            if (hasAlarm) ...[
                              GestureDetector(
                                onTap: widget.onSnooze,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.surface200,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.snooze_rounded,
                                        size: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Snooze',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            // Reschedule
                            GestureDetector(
                              onTap: widget.onReschedule,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withAlpha(15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.primary.withAlpha(50),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_calendar_rounded,
                                      size: 13,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Reschedule',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withAlpha(15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 13,
                                    color: AppTheme.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Done',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
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
}

// ─── Reminder Detail Sheet ────────────────────────────────────────────────────

class _ReminderDetailSheet extends StatelessWidget {
  final Map<String, dynamic> reminder;
  final VoidCallback onSnooze;
  final VoidCallback onReschedule;
  const _ReminderDetailSheet({
    required this.reminder,
    required this.onSnooze,
    required this.onReschedule,
  });

  String _fmt(DateTime dt) {
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

  @override
  Widget build(BuildContext context) {
    final r = reminder;
    final title = r['title'] as String? ?? '';
    final type = r['type'] as String? ?? '';
    final status = r['status'] as String? ?? '';
    final priority = r['priority'] as String? ?? '';
    final dt = r['dateTime'] as DateTime?;
    final alarmDt = r['alarmDateTime'] as DateTime?;
    final hasAlarm = r['hasAlarm'] == true;
    final snoozeCount = r['snoozeCount'] as int? ?? 0;
    final notes = r['notes'] as String? ?? '';
    final linkedLead = r['linkedLead'] as String? ?? '';
    final linkedLeadId = r['linkedLeadId'] as String? ?? '';
    final repeat = r['repeatFrequency'] as String? ?? 'None';
    final createdAt = r['createdAt'] as DateTime?;
    final completedAt = r['completedAt'] as DateTime?;
    final isCompleted = r['isCompleted'] == true;
    final isOverdue = dt != null && dt.isBefore(DateTime.now()) && !isCompleted;
    final timeline =
        (r['timeline'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final interestTags = (r['interestTags'] as List?)?.cast<String>() ?? [];
    final isExistingCustomer = linkedLeadId.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
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
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: [
                _DetailTag(type, const Color(0xFF0891B2)),
                _DetailTag(
                  priority,
                  priority == 'High'
                      ? AppTheme.error
                      : priority == 'Medium'
                      ? AppTheme.warning
                      : AppTheme.success,
                ),
                if (isCompleted) _DetailTag('Completed', AppTheme.success),
                if (isOverdue) _DetailTag('Overdue', AppTheme.error),
                if (isExistingCustomer)
                  _DetailTag('Existing Customer', const Color(0xFF059669)),
              ],
            ),
            const SizedBox(height: 12),
            if (interestTags.isNotEmpty) ...[
              Wrap(
                spacing: 5,
                runSpacing: 4,
                children: interestTags
                    .map((t) => _DetailTag(t, const Color(0xFF0891B2)))
                    .toList(),
              ),
              const SizedBox(height: 10),
            ],
            if (linkedLead.isNotEmpty)
              _DetailRow(Icons.person_rounded, 'Lead', linkedLead),
            if (dt != null)
              _DetailRow(Icons.schedule_rounded, 'Due Date', _fmt(dt)),
            if (hasAlarm && alarmDt != null)
              _DetailRow(Icons.alarm_rounded, 'Alarm', _fmt(alarmDt)),
            if (!hasAlarm)
              _DetailRow(Icons.alarm_off_rounded, 'Alarm', 'No alarm set'),
            _DetailRow(Icons.autorenew_rounded, 'Repeat', repeat),
            _DetailRow(
              Icons.snooze_rounded,
              'Snoozed',
              '$snoozeCount time${snoozeCount == 1 ? '' : 's'}',
            ),
            if (createdAt != null)
              _DetailRow(
                Icons.add_circle_outline_rounded,
                'Created',
                _fmt(createdAt),
              ),
            if (completedAt != null)
              _DetailRow(
                Icons.check_circle_rounded,
                'Completed',
                _fmt(completedAt),
              ),
            if (notes.isNotEmpty)
              _DetailRow(Icons.notes_rounded, 'Notes', notes),
            // Timeline
            if (timeline.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Timeline',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...timeline.map((entry) {
                final event = entry['event'] as String? ?? '';
                final ts = entry['timestamp'] as DateTime?;
                final note = entry['note'] as String? ?? '';
                final color = event == 'Completed'
                    ? AppTheme.success
                    : event == 'Snoozed'
                    ? AppTheme.warning
                    : AppTheme.primary;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4, right: 10),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            if (ts != null)
                              Text(
                                _fmt(ts),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            if (note.isNotEmpty)
                              Text(
                                note,
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
                );
              }),
            ],
            const SizedBox(height: 16),
            if (!isCompleted)
              Row(
                children: [
                  if (hasAlarm)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onSnooze();
                        },
                        icon: const Icon(Icons.snooze_rounded, size: 16),
                        label: Text(
                          'Snooze',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.warning,
                          side: BorderSide(color: AppTheme.warning),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  if (hasAlarm) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onReschedule();
                      },
                      icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                      label: Text(
                        'Reschedule',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailTag extends StatelessWidget {
  final String label;
  final Color color;
  const _DetailTag(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withAlpha(60)),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
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
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Reschedule Sheet ─────────────────────────────────────────────────────────

class _RescheduleSheet extends StatefulWidget {
  final Map<String, dynamic> reminder;
  final void Function(DateTime) onReschedule;
  const _RescheduleSheet({required this.reminder, required this.onReschedule});
  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  DateTime? _newDate;
  TimeOfDay? _newTime;

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
    final r = widget.reminder;
    final isOverdue = (r['dateTime'] as DateTime).isBefore(DateTime.now());
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
            'Reschedule Reminder',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            r['title'] as String? ?? '',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isOverdue) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.warning.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.warning.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, size: 14, color: AppTheme.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'This reminder is overdue. Rescheduling after due date will be recorded in the timeline.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
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
                          _newDate != null
                              ? _formatDate(_newDate!)
                              : 'New date *',
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
                          _newTime != null
                              ? _newTime!.format(context)
                              : 'Time (opt)',
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _newDate == null
                  ? null
                  : () {
                      final d = _newDate!;
                      final t = _newTime;
                      final dt = t != null
                          ? DateTime(d.year, d.month, d.day, t.hour, t.minute)
                          : DateTime(d.year, d.month, d.day, 9, 0);
                      Navigator.pop(context);
                      widget.onReschedule(dt);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor: AppTheme.surface200,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reschedule',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: _newDate != null ? Colors.white : AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Snooze Sheet ─────────────────────────────────────────────────────────────

class _SnoozeSheet extends StatefulWidget {
  final Map<String, dynamic> reminder;
  final void Function(DateTime) onSnooze;
  const _SnoozeSheet({required this.reminder, required this.onSnooze});

  @override
  State<_SnoozeSheet> createState() => _SnoozeSheetState();
}

class _SnoozeSheetState extends State<_SnoozeSheet> {
  DateTime? _customDate;
  TimeOfDay? _customTime;
  bool _showCustom = false;

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
    final r = widget.reminder;
    final snoozeCount = r['snoozeCount'] as int? ?? 0;
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
                Text(
                  'Snooze Reminder',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$snoozeCount times snoozed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              r['title'] as String,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            ...[
              (
                'Today (in 15 min)',
                DateTime.now().add(const Duration(minutes: 15)),
              ),
              (
                'Today (in 30 min)',
                DateTime.now().add(const Duration(minutes: 30)),
              ),
              (
                'Today (in 1 hour)',
                DateTime.now().add(const Duration(hours: 1)),
              ),
              (
                'Tomorrow (same time)',
                DateTime.now().add(const Duration(days: 1)),
              ),
            ].map((opt) {
              final (label, dt) = opt;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.snooze_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                title: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onSnooze(dt);
                },
              );
            }),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              title: Text(
                'Custom Date & Time',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                _showCustom
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: AppTheme.textMuted,
              ),
              onTap: () => setState(() => _showCustom = !_showCustom),
            ),
            if (_showCustom) ...[
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
                        if (d != null) setState(() => _customDate = d);
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
                            color: _customDate != null
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
                              _customDate != null
                                  ? _formatDate(_customDate!)
                                  : 'Select date',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: _customDate != null
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
                          initialTime: TimeOfDay.now(),
                        );
                        if (t != null) setState(() => _customTime = t);
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
                            color: _customTime != null
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
                              _customTime != null
                                  ? _customTime!.format(context)
                                  : 'Time (optional)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: _customTime != null
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _customDate == null
                      ? null
                      : () {
                          final d = _customDate!;
                          final t = _customTime;
                          final dt = t != null
                              ? DateTime(
                                  d.year,
                                  d.month,
                                  d.day,
                                  t.hour,
                                  t.minute,
                                )
                              : DateTime(d.year, d.month, d.day, 9, 0);
                          Navigator.pop(context);
                          widget.onSnooze(dt);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Set Custom Snooze',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: _customDate != null
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─── New Reminder Sheet ───────────────────────────────────────────────────────

class _NewReminderSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;
  const _NewReminderSheet({required this.onSave});

  @override
  State<_NewReminderSheet> createState() => _NewReminderSheetState();
}

class _NewReminderSheetState extends State<_NewReminderSheet> {
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _leadSearchCtrl = TextEditingController();
  final _customRemindCtrl = TextEditingController();
  final _othersTagCtrl = TextEditingController();
  final _manualCustomerNameCtrl = TextEditingController();
  final _manualCustomerPhoneCtrl = TextEditingController();

  String _selectedType = 'Follow-up';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _hasAlarm = false;
  DateTime? _alarmDate;
  TimeOfDay? _alarmTime;
  String _remindBefore = '15 minutes';
  bool _showCustomRemind = false;
  String _repeat = 'None';
  String _priority = 'Medium';
  _AgentInfo? _selectedHost;
  Map<String, dynamic>? _selectedLead;
  String _leadSearchQuery = '';
  bool _showLeadSearch = false;
  bool _useManualCustomer = false;
  final List<String> _notifyVia = ['Push', 'In-App'];
  final List<String> _othersTags = [];

  static const _types = [
    'Follow-up',
    'Meeting',
    'Policy Renewal',
    'Deadline',
    'Birthday',
    'Review',
    'Team Meeting',
    'Others',
  ];
  static const _remindBeforeOptions = [
    '5 minutes',
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2 hours',
    '1 day',
    '2 days',
    'Custom',
  ];
  static const _repeatOptions = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  static const _priorities = ['High', 'Medium', 'Low'];
  static const _notifyOptions = ['Push', 'In-App', 'WhatsApp', 'Email'];

  bool get _canSave =>
      _titleCtrl.text.trim().isNotEmpty &&
      _selectedDate != null &&
      (_selectedType != 'Others' || _othersTags.isNotEmpty);

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
  void initState() {
    super.initState();
    _selectedHost = _kAgents.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _leadSearchCtrl.dispose();
    _customRemindCtrl.dispose();
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
                      'Create Reminder',
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

              // Title
              _buildLabel('Reminder Title *'),
              const SizedBox(height: 6),
              TextField(
                controller: _titleCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Follow up with Rahul',
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

              // Lead / Customer picker — replaced by toggle above, show appropriate UI
              if (!_useManualCustomer) ...[
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
                    constraints: const BoxConstraints(maxHeight: 180),
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
                                onTap: () => setState(() {
                                  _selectedLead = lead;
                                  _showLeadSearch = false;
                                  _leadSearchQuery = '';
                                  _leadSearchCtrl.clear();
                                }),
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
                                              style:
                                                  GoogleFonts.plusJakartaSans(
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
                ],
              ] else ...[
                // Manual customer entry
                TextField(
                  controller: _manualCustomerNameCtrl,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Customer name',
                    prefixIcon: const Icon(Icons.person_rounded, size: 16),
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
                const SizedBox(height: 8),
                TextField(
                  controller: _manualCustomerPhoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Customer phone (optional)',
                    prefixIcon: const Icon(Icons.phone_rounded, size: 16),
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
              ],
              const SizedBox(height: 12),

              // Reminder Type
              _buildLabel('Reminder Type *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final sel = _selectedType == t;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFF0891B2).withAlpha(25)
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel
                              ? const Color(0xFF0891B2)
                              : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel
                              ? const Color(0xFF0891B2)
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Others type — compulsory tag input
              if (_selectedType == 'Others') ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withAlpha(8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF0891B2).withAlpha(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.label_rounded,
                            size: 14,
                            color: Color(0xFF0891B2),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Specify Type Tag *',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0891B2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(required)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppTheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _othersTagCtrl,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'e.g. Medical, Legal...',
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
                              onSubmitted: (v) {
                                if (v.trim().isNotEmpty) {
                                  setState(() {
                                    _othersTags.add(v.trim());
                                    _othersTagCtrl.clear();
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (_othersTagCtrl.text.trim().isNotEmpty) {
                                setState(() {
                                  _othersTags.add(_othersTagCtrl.text.trim());
                                  _othersTagCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0891B2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_othersTags.isEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Add at least one tag',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.error,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (_othersTags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _othersTags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0891B2,
                                    ).withAlpha(20),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF0891B2,
                                      ).withAlpha(60),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        tag,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: const Color(0xFF0891B2),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => _othersTags.remove(tag),
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 12,
                                          color: Color(0xFF0891B2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Customer — search from leads OR manual entry
              _buildLabel('Customer (Optional)'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _useManualCustomer = false;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !_useManualCustomer
                              ? const Color(0xFF0891B2).withAlpha(20)
                              : AppTheme.surface100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: !_useManualCustomer
                                ? const Color(0xFF0891B2)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_rounded,
                              size: 14,
                              color: !_useManualCustomer
                                  ? const Color(0xFF0891B2)
                                  : AppTheme.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Search Lead',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: !_useManualCustomer
                                    ? const Color(0xFF0891B2)
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
                      onTap: () => setState(() {
                        _useManualCustomer = true;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _useManualCustomer
                              ? const Color(0xFF0891B2).withAlpha(20)
                              : AppTheme.surface100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _useManualCustomer
                                ? const Color(0xFF0891B2)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: _useManualCustomer
                                  ? const Color(0xFF0891B2)
                                  : AppTheme.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Manual Entry',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _useManualCustomer
                                    ? const Color(0xFF0891B2)
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
              const SizedBox(height: 8),
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

              // Assigned Host — same design as follow-up filter (SingleAgentPicker style)
              _buildLabel('Assigned Host'),
              const SizedBox(height: 8),
              _ReminderHostPicker(
                agents: _kAgents,
                selected: _selectedHost,
                onSelect: (a) => setState(() => _selectedHost = a),
              ),
              const SizedBox(height: 12),

              // Date (compulsory)
              _buildLabel('Reminder Date *'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (d != null) {
                          setState(() {
                            _selectedDate = d;
                            // Auto-fill alarm date when reminder date is selected and alarm is on
                            if (_hasAlarm) _alarmDate = d;
                          });
                        }
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
                                ? const Color(0xFF0891B2).withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: Color(0xFF0891B2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDate != null
                                  ? _formatDate(_selectedDate!)
                                  : 'Select date *',
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
                        if (t != null) {
                          setState(() {
                            _selectedTime = t;
                            // Auto-fill alarm time when reminder time is selected and alarm is on
                            if (_hasAlarm) _alarmTime = t;
                          });
                        }
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
                                ? const Color(0xFF0891B2).withAlpha(60)
                                : AppTheme.surface200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: Color(0xFF0891B2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Time (optional)',
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

              // Set Alarm toggle — auto-fills from reminder date when toggled on
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _hasAlarm
                      ? const Color(0xFF0891B2).withAlpha(15)
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasAlarm
                        ? const Color(0xFF0891B2).withAlpha(80)
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
                          color: _hasAlarm
                              ? const Color(0xFF0891B2)
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Set Alarm',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _hasAlarm
                                      ? const Color(0xFF0891B2)
                                      : AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                _hasAlarm
                                    ? 'Alarm will ring at set date & time'
                                    : 'Toggle to set an alarm',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: _hasAlarm
                                      ? const Color(0xFF0891B2)
                                      : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _hasAlarm,
                          onChanged: (v) {
                            setState(() {
                              _hasAlarm = v;
                              // Auto-fill alarm date/time from reminder date when toggled on
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
                      const SizedBox(height: 12),
                      Text(
                        'Alarm Date & Time *',
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
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _alarmDate != null
                                        ? const Color(0xFF0891B2).withAlpha(60)
                                        : AppTheme.surface200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: Color(0xFF0891B2),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _alarmDate != null
                                          ? _formatDate(_alarmDate!)
                                          : 'Alarm date *',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
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
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _alarmTime != null
                                        ? const Color(0xFF0891B2).withAlpha(60)
                                        : AppTheme.surface200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: Color(0xFF0891B2),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _alarmTime != null
                                          ? _alarmTime!.format(context)
                                          : 'Alarm time *',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
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
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Remind Before — with Custom option
              _buildLabel('Remind Me Before'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _remindBeforeOptions.map((o) {
                  final sel = _remindBefore == o;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _remindBefore = o;
                        _showCustomRemind = o == 'Custom';
                      });
                    },
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
                        o,
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
              if (_showCustomRemind) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _customRemindCtrl,
                  onChanged: (v) => setState(
                    () => _remindBefore = v.isNotEmpty ? v : 'Custom',
                  ),
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'e.g. 3 hours, 45 minutes...',
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
              ],
              const SizedBox(height: 12),

              // Repeat
              _buildLabel('Repeat'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _repeatOptions.map((o) {
                  final sel = _repeat == o;
                  return GestureDetector(
                    onTap: () => setState(() => _repeat = o),
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
                        o,
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

              // Notify Via
              _buildLabel('Notify Via'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _notifyOptions.map((o) {
                  final sel = _notifyVia.contains(o);
                  return GestureDetector(
                    onTap: () => setState(
                      () => sel ? _notifyVia.remove(o) : _notifyVia.add(o),
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
                            o,
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

              // Notes — grows with content
              _buildLabel('Notes (optional)'),
              const SizedBox(height: 6),
              TextField(
                controller: _notesCtrl,
                maxLines: null, // grows with content
                minLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add notes...',
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
                  onPressed: _canSave
                      ? () {
                          final date = _selectedDate!;
                          final time = _selectedTime;
                          final dt = time != null
                              ? DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                )
                              : DateTime(date.year, date.month, date.day, 9, 0);

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

                          final data = {
                            'id':
                                'rem-${DateTime.now().millisecondsSinceEpoch}',
                            'title': _titleCtrl.text.trim(),
                            'type':
                                _selectedType == 'Others' &&
                                    _othersTags.isNotEmpty
                                ? _othersTags.first
                                : _selectedType,
                            'reminderTag':
                                _selectedType == 'Others' &&
                                    _othersTags.isNotEmpty
                                ? _othersTags.first
                                : _selectedType,
                            'status': 'Active',
                            'priority': _priority,
                            'dateTime': dt,
                            'alarmDateTime': alarmDt,
                            'hasAlarm': _hasAlarm && alarmDt != null,
                            'repeatFrequency': _repeat,
                            'remindBefore': _remindBefore,
                            'notifyVia': List<String>.from(_notifyVia),
                            'linkedLead': _useManualCustomer
                                ? _manualCustomerNameCtrl.text.trim()
                                : (_selectedLead?['name'] as String? ?? ''),
                            'linkedLeadId': _useManualCustomer
                                ? ''
                                : (_selectedLead?['id'] as String? ?? ''),
                            'linkedLeadPhone': _useManualCustomer
                                ? _manualCustomerPhoneCtrl.text.trim()
                                : (_selectedLead?['phone'] as String? ?? ''),
                            'linkedLeadEmail': _useManualCustomer
                                ? ''
                                : (_selectedLead?['email'] as String? ?? ''),
                            'assignedHost':
                                _selectedHost?.name ?? 'Priya Sharma',
                            'assignedHostInitials':
                                _selectedHost?.initials ?? 'PS',
                            'snoozed': false,
                            'snoozeUntil': null,
                            'snoozeCount': 0,
                            'notes': _notesCtrl.text.trim(),
                            'createdAt': DateTime.now(),
                            'isCompleted': false,
                            'linkedFollowUpId': null,
                            'linkedSessionId': null,
                            'interestTags': [],
                            'timeline': [],
                          };
                          Navigator.pop(context);
                          widget.onSave(data);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Reminder',
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

// ─── Reminder Host Picker (same design as follow-up filter assigned host) ─────

class _ReminderHostPicker extends StatefulWidget {
  final List<_AgentInfo> agents;
  final _AgentInfo? selected;
  final ValueChanged<_AgentInfo> onSelect;
  const _ReminderHostPicker({
    required this.agents,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_ReminderHostPicker> createState() => _ReminderHostPickerState();
}

class _ReminderHostPickerState extends State<_ReminderHostPicker> {
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

// ─── Reminder Filter Sheet ────────────────────────────────────────────────────

class _ReminderFilterSheet extends StatefulWidget {
  final List<String> selectedHosts;
  final List<String> selectedTypes;
  final String? selectedPriority;
  final bool? snoozedFilter;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool showCompleted;
  final bool showUpcoming;
  final bool showOverdue;
  final bool showDueToday;
  final void Function(
    List<String>,
    List<String>,
    String?,
    bool?,
    DateTime?,
    DateTime?,
    bool,
    bool,
    bool,
    bool,
  )
  onApply;

  const _ReminderFilterSheet({
    required this.selectedHosts,
    required this.selectedTypes,
    required this.selectedPriority,
    required this.snoozedFilter,
    required this.dateFrom,
    required this.dateTo,
    required this.showCompleted,
    required this.showUpcoming,
    required this.showOverdue,
    required this.showDueToday,
    required this.onApply,
  });

  @override
  State<_ReminderFilterSheet> createState() => _ReminderFilterSheetState();
}

class _ReminderFilterSheetState extends State<_ReminderFilterSheet> {
  late List<String> _hosts;
  late List<String> _types;
  String? _priority;
  bool? _snoozed;
  DateTime? _from;
  DateTime? _to;
  late bool _showCompleted;
  late bool _showUpcoming;
  late bool _showOverdue;
  late bool _showDueToday;

  static const _typeOptions = [
    'Follow-up',
    'Meeting',
    'Policy Renewal',
    'Deadline',
    'Birthday',
    'Review',
    'Team Meeting',
    'Others',
  ];
  static const _priorityOptions = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _hosts = List.from(widget.selectedHosts);
    _types = List.from(widget.selectedTypes);
    _priority = widget.selectedPriority;
    _snoozed = widget.snoozedFilter;
    _from = widget.dateFrom;
    _to = widget.dateTo;
    _showCompleted = widget.showCompleted;
    _showUpcoming = widget.showUpcoming;
    _showOverdue = widget.showOverdue;
    _showDueToday = widget.showDueToday;
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
                  'Filter Reminders',
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
                    _priority = null;
                    _snoozed = null;
                    _from = null;
                    _to = null;
                    _showCompleted = false;
                    _showUpcoming = false;
                    _showOverdue = false;
                    _showDueToday = false;
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
                  // Status filter — including Upcoming
                  _filterLabel('Status'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _filterChip(
                        'Due Today',
                        _showDueToday,
                        () => setState(() => _showDueToday = !_showDueToday),
                      ),
                      _filterChip(
                        'Overdue',
                        _showOverdue,
                        () => setState(() => _showOverdue = !_showOverdue),
                      ),
                      _filterChip(
                        'Upcoming',
                        _showUpcoming,
                        () => setState(() => _showUpcoming = !_showUpcoming),
                      ),
                      _filterChip(
                        'Completed',
                        _showCompleted,
                        () => setState(() => _showCompleted = !_showCompleted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reminder Type
                  _filterLabel('Reminder Type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _typeOptions.map((t) {
                      final sel = _types.contains(t);
                      return GestureDetector(
                        onTap: () => setState(
                          () => sel ? _types.remove(t) : _types.add(t),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFF0891B2).withAlpha(25)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? const Color(0xFF0891B2)
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel
                                  ? const Color(0xFF0891B2)
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Priority
                  _filterLabel('Priority'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _priority = null),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _priority == null
                                ? AppTheme.primaryContainer
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _priority == null
                                  ? AppTheme.primary
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            'All',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _priority == null
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      ..._priorityOptions.map((p) {
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
                              color: sel
                                  ? color.withAlpha(25)
                                  : AppTheme.surface100,
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
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Snoozed
                  _filterLabel('Snoozed Status'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _filterChip(
                        'All',
                        _snoozed == null,
                        () => setState(() => _snoozed = null),
                      ),
                      _filterChip(
                        'Snoozed',
                        _snoozed == true,
                        () => setState(() => _snoozed = true),
                      ),
                      _filterChip(
                        'Not Snoozed',
                        _snoozed == false,
                        () => setState(() => _snoozed = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Assigned Host — same design as sessions filter
                  _filterLabel('Assigned Host'),
                  const SizedBox(height: 8),
                  _ReminderHostFilterWidget(
                    selectedHosts: _hosts,
                    onChanged: (h) => setState(() => _hosts = h),
                  ),
                  const SizedBox(height: 16),

                  // Date Range
                  _filterLabel('Date Range'),
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
                          _priority,
                          _snoozed,
                          _from,
                          _to,
                          _showCompleted,
                          _showUpcoming,
                          _showOverdue,
                          _showDueToday,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0891B2),
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

  Widget _filterLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.surface200,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Reminder Host Filter Widget (same as sessions) ───────────────────────────

class _ReminderHostFilterWidget extends StatefulWidget {
  final List<String> selectedHosts;
  final ValueChanged<List<String>> onChanged;
  const _ReminderHostFilterWidget({
    required this.selectedHosts,
    required this.onChanged,
  });

  @override
  State<_ReminderHostFilterWidget> createState() =>
      _ReminderHostFilterWidgetState();
}

class _ReminderHostFilterWidgetState extends State<_ReminderHostFilterWidget> {
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
            color: AppTheme.surface100,
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
                  fontSize: 10,
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
              Icon(Icons.check_circle_rounded, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Sort Sheet ───────────────────────────────────────────────────────────────

class _ReminderSortSheet extends StatelessWidget {
  final _ReminderSortOption current;
  final ValueChanged<_ReminderSortOption> onSelect;
  const _ReminderSortSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        _ReminderSortOption.dateAscending,
        'Date (Soonest First)',
        Icons.arrow_upward_rounded,
      ),
      (
        _ReminderSortOption.dateDescending,
        'Date (Latest First)',
        Icons.arrow_downward_rounded,
      ),
      (
        _ReminderSortOption.priorityHigh,
        'Priority (High First)',
        Icons.priority_high_rounded,
      ),
      (
        _ReminderSortOption.leadAZ,
        'Lead Name (A–Z)',
        Icons.sort_by_alpha_rounded,
      ),
      (
        _ReminderSortOption.createdNewest,
        'Created (Newest First)',
        Icons.new_releases_rounded,
      ),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                'Sort Reminders',
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
          const SizedBox(height: 8),
          ...options.map((opt) {
            final (option, label, icon) = opt;
            final sel = current == option;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: sel
                      ? AppTheme.primary.withAlpha(20)
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: sel ? AppTheme.primary : AppTheme.textMuted,
                ),
              ),
              title: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
              trailing: sel
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                onSelect(option);
              },
            );
          }),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

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
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
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

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: color),
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
