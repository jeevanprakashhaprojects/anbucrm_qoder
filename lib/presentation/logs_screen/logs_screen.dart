import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_scaffold.dart';

// ─── Call Log Data Models ─────────────────────────────────────────────────────

class CallLogEntry {
  final String id;
  final DateTime callDateTime;
  final int durationSeconds;
  final String direction;
  final String phoneNumber;
  final String countryCode;
  final String simUsed;
  final String callType;
  final String callStatus;
  final String callOutcome;
  final String? linkedLeadName;
  final String? linkedLeadId;
  final String notes;
  final List<String> tags;
  final String agentName;
  final String agentInitials;
  final String agentRole;
  final String agentPhone;
  final String? appointmentType;
  final DateTime? appointmentDate;
  final String? appointmentNotes;
  final String followUpPriority;
  final String followUpStatus;

  const CallLogEntry({
    required this.id,
    required this.callDateTime,
    required this.durationSeconds,
    required this.direction,
    required this.phoneNumber,
    required this.countryCode,
    required this.simUsed,
    required this.callType,
    required this.callStatus,
    required this.callOutcome,
    this.linkedLeadName,
    this.linkedLeadId,
    required this.notes,
    required this.tags,
    required this.agentName,
    required this.agentInitials,
    required this.agentRole,
    this.agentPhone = '',
    this.appointmentType,
    this.appointmentDate,
    this.appointmentNotes,
    required this.followUpPriority,
    required this.followUpStatus,
  });

  String get formattedDuration {
    if (durationSeconds == 0) return '0 sec';
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    if (m == 0) return '${s}s';
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(callDateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${callDateTime.day}/${callDateTime.month}/${callDateTime.year}';
  }

  String get formattedDate {
    final months = [
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
    return '${callDateTime.day} ${months[callDateTime.month - 1]} ${callDateTime.year}';
  }

  String get formattedTime {
    final h = callDateTime.hour;
    final m = callDateTime.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }
}

// ─── Generate 1 Year of Random Call Log Data ──────────────────────────────────

List<CallLogEntry> _generateYearOfCallLogs() {
  final now = DateTime.now();
  final agents = [
    {
      'name': 'Priya Sharma',
      'initials': 'PS',
      'role': 'Admin',
      'phone': '+91 98765 11111',
    },
    {
      'name': 'Rahul Singh',
      'initials': 'RS',
      'role': 'Senior Rep',
      'phone': '+91 98765 22222',
    },
    {
      'name': 'Ananya Patel',
      'initials': 'AP',
      'role': 'Manager',
      'phone': '+91 98765 33333',
    },
    {
      'name': 'Kavya Menon',
      'initials': 'KM',
      'role': 'Sales Rep',
      'phone': '+91 98765 44444',
    },
    {
      'name': 'Arjun Das',
      'initials': 'AD',
      'role': 'Sales Rep',
      'phone': '+91 98765 55555',
    },
    {
      'name': 'Amit Kumar',
      'initials': 'AK',
      'role': 'Employee',
      'phone': '+91 98765 66666',
    },
    {
      'name': 'Ravi Verma',
      'initials': 'RV',
      'role': 'Employee',
      'phone': '+91 98765 77777',
    },
  ];
  final directions = ['Incoming', 'Outgoing', 'Missed'];
  final callTypes = [
    'Appointment Call',
    'Cold Call',
    'Follow-up Call',
    'Video Call',
    'Warm Call',
    'Support Call',
    'Negotiation Call',
    'Closing Call',
    'Reminder Call',
  ];
  final statuses = [
    'Connected',
    'No Answer',
    'Busy',
    'Switched Off',
    'Connected — Voicemail left',
    'Interested',
    'Appointment Set',
  ];
  final outcomes = [
    'Success',
    'Partial',
    'Neutral',
    'Pending',
    'Appointment Booked',
    'Price Discussion',
    'Demo Requested',
  ];
  final leadNames = [
    'Rahul Mehta',
    'Sneha Kapoor',
    'Vikram Singh',
    'Anita Desai',
    'Karan Joshi',
    'Mohammed Al-Rashid',
    'Sunita Reddy',
    'Pradeep Kumar',
    'Meena Iyer',
    'Suresh Nair',
    'Deepa Pillai',
    'Arun Sharma',
    'Lakshmi Devi',
    'Rajesh Gupta',
    'Pooja Verma',
  ];
  final phones = [
    '+91 98765 43210',
    '+91 87654 32109',
    '+91 76543 21098',
    '+91 65432 10987',
    '+91 54321 09876',
    '+91 91234 56789',
    '+91 99887 76655',
    '+91 88776 65544',
    '+91 77665 54433',
    '+91 66554 43322',
  ];
  final apptTypes = [
    'Appointment',
    'Follow-up',
    'Video Call',
    null,
    null,
    null,
  ];
  final tagSets = [
    ['Hot Lead', 'Interested'],
    ['Follow-up Required'],
    ['Warm Lead'],
    ['Existing Customer'],
    ['Cold Lead'],
    ['VIP Customer'],
    [],
    ['Upsell Opportunity'],
  ];
  final notesList = [
    'Confirmed interest in enterprise plan.',
    'No answer. Will try again tomorrow.',
    'Customer called to inquire about premium upgrade.',
    'Left voicemail about renewal offer.',
    'Phone switched off. Try WhatsApp.',
    'Long negotiation on pricing.',
    'Customer had query about policy terms.',
    'Discussed product features in detail.',
    'Sent proposal via email after call.',
    'Scheduled demo for next week.',
    'Customer requested callback.',
    'Interested in family floater plan.',
    'Needs more time to decide.',
    'Budget approved for Q4.',
    'Referred by existing customer.',
  ];

  final List<CallLogEntry> logs = [];
  int idCounter = 1;

  for (int week = 0; week < 52; week++) {
    final weekStart = now.subtract(Duration(days: (52 - week) * 7));
    final callsThisWeek = 3 + (idCounter % 3);
    for (int c = 0; c < callsThisWeek; c++) {
      final daysOffset = c % 5;
      final hoursOffset = 8 + (c * 3 % 10);
      final callDt = weekStart.add(
        Duration(
          days: daysOffset,
          hours: hoursOffset,
          minutes: (idCounter * 7) % 60,
        ),
      );
      final dirIdx = idCounter % 3;
      final direction = directions[dirIdx];
      final agentIdx = idCounter % agents.length;
      final agent = agents[agentIdx];
      final typeIdx = idCounter % callTypes.length;
      final statusIdx = idCounter % statuses.length;
      final outcomeIdx = idCounter % outcomes.length;
      final leadIdx = idCounter % leadNames.length;
      final phoneIdx = idCounter % phones.length;
      final noteIdx = idCounter % notesList.length;
      final tagIdx = idCounter % tagSets.length;
      final apptTypeIdx = idCounter % apptTypes.length;
      final apptType = apptTypes[apptTypeIdx];
      final duration = direction == 'Missed'
          ? 0
          : (30 + (idCounter * 37) % 600);

      logs.add(
        CallLogEntry(
          id: 'call-$idCounter',
          callDateTime: callDt,
          durationSeconds: duration,
          direction: direction,
          phoneNumber: phones[phoneIdx],
          countryCode: '+91',
          simUsed: idCounter % 2 == 0 ? 'SIM 1' : 'SIM 2',
          callType: callTypes[typeIdx],
          callStatus: direction == 'Missed' ? 'No Answer' : statuses[statusIdx],
          callOutcome: direction == 'Missed' ? 'Pending' : outcomes[outcomeIdx],
          linkedLeadName: idCounter % 4 != 0 ? leadNames[leadIdx] : null,
          notes: notesList[noteIdx],
          tags: tagSets[tagIdx].cast<String>(),
          agentName: agent['name']!,
          agentInitials: agent['initials']!,
          agentRole: agent['role']!,
          agentPhone: agent['phone']!,
          appointmentType: apptType,
          appointmentDate: apptType != null
              ? callDt.add(Duration(days: 1 + (idCounter % 14)))
              : null,
          appointmentNotes: apptType != null ? 'Follow up on proposal' : null,
          followUpPriority: idCounter % 3 == 0
              ? 'High'
              : idCounter % 3 == 1
              ? 'Medium'
              : 'Low',
          followUpStatus: idCounter % 5 == 0 ? 'completed' : 'pending',
        ),
      );
      idCounter++;
    }
  }

  // Add today's calls
  logs.addAll([
    CallLogEntry(
      id: 'call-today-1',
      callDateTime: now.subtract(const Duration(hours: 2)),
      durationSeconds: 154,
      direction: 'Outgoing',
      phoneNumber: '+91 98765 43210',
      countryCode: '+91',
      simUsed: 'SIM 1',
      callType: 'Appointment Call',
      callStatus: 'Connected',
      callOutcome: 'Appointment Set',
      linkedLeadName: 'Rahul Mehta',
      linkedLeadId: 'default-1',
      notes:
          'Confirmed interest in enterprise plan. Scheduled demo for next week.',
      tags: ['Hot Lead', 'Interested'],
      agentName: 'Priya Sharma',
      agentInitials: 'PS',
      agentRole: 'Admin',
      agentPhone: '+91 98765 11111',
      appointmentType: 'Appointment',
      appointmentDate: now.add(const Duration(days: 7)),
      appointmentNotes: 'Product demo scheduled',
      followUpPriority: 'High',
      followUpStatus: 'pending',
    ),
    CallLogEntry(
      id: 'call-today-2',
      callDateTime: now.subtract(const Duration(hours: 5)),
      durationSeconds: 0,
      direction: 'Missed',
      phoneNumber: '+91 87654 32109',
      countryCode: '+91',
      simUsed: 'SIM 1',
      callType: 'Follow-up Call',
      callStatus: 'No Answer',
      callOutcome: 'Pending',
      linkedLeadName: 'Sneha Kapoor',
      linkedLeadId: 'default-2',
      notes: 'No answer. Will try again tomorrow.',
      tags: ['Follow-up Required'],
      agentName: 'Amit Kumar',
      agentInitials: 'AK',
      agentRole: 'Employee',
      agentPhone: '+91 98765 66666',
      followUpPriority: 'Medium',
      followUpStatus: 'pending',
    ),
    CallLogEntry(
      id: 'call-today-3',
      callDateTime: now.subtract(const Duration(hours: 1)),
      durationSeconds: 320,
      direction: 'Incoming',
      phoneNumber: '+91 76543 21098',
      countryCode: '+91',
      simUsed: 'SIM 2',
      callType: 'Warm Call',
      callStatus: 'Connected',
      callOutcome: 'Interested',
      linkedLeadName: 'Vikram Singh',
      linkedLeadId: 'default-3',
      notes:
          'Customer called to inquire about premium upgrade. Very interested.',
      tags: ['Warm Lead', 'Upsell Opportunity'],
      agentName: 'Priya Sharma',
      agentInitials: 'PS',
      agentRole: 'Admin',
      agentPhone: '+91 98765 11111',
      appointmentType: 'Follow-up',
      appointmentDate: now.add(const Duration(days: 3)),
      appointmentNotes: 'Send proposal first',
      followUpPriority: 'High',
      followUpStatus: 'pending',
    ),
  ]);

  logs.sort((a, b) => b.callDateTime.compareTo(a.callDateTime));
  return logs;
}

final List<CallLogEntry> globalCallLogs = _generateYearOfCallLogs();

// ─── Logs Screen ──────────────────────────────────────────────────────────────

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchCtrl = TextEditingController();
  // Default to 'Today' — only today's calls shown by default
  String _dateFilter = 'Today';
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _directionFilter = 'All';
  List<String> _selectedEmployees = [];
  List<String> _selectedCallTypes = [];
  List<String> _selectedStatuses = [];
  String _sortOption = 'Newest First';

  static const _directions = ['All', 'Incoming', 'Outgoing', 'Missed'];
  static const _callTypes = [
    'Appointment Call',
    'Cold Call',
    'Callback',
    'Follow-up Call',
    'Video Call',
    'Warm Call',
    'Support Call',
    'Negotiation Call',
    'Closing Call',
    'Service Call',
    'Reminder Call',
    'Other',
  ];
  static const _callStatuses = [
    'Connected',
    'Connected — Voicemail left',
    'No Answer',
    'Busy',
    'Switched Off',
    'Wrong Number',
    'Not Interested',
    'Interested',
    'Appointment Set',
    'Deal Closed',
    'Call Dropped',
  ];
  static const _sortOptions = [
    'Newest First',
    'Oldest First',
    'Longest Duration',
    'Shortest Duration',
    'Lead Name A-Z',
  ];

  List<CallLogEntry> get _filteredLogs {
    List<CallLogEntry> result = globalCallLogs.where((log) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!log.phoneNumber.toLowerCase().contains(q) &&
            !(log.linkedLeadName?.toLowerCase().contains(q) ?? false) &&
            !log.notes.toLowerCase().contains(q) &&
            !log.agentName.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_directionFilter != 'All' && log.direction != _directionFilter) {
        return false;
      }
      if (_selectedEmployees.isNotEmpty &&
          !_selectedEmployees.contains(log.agentName)) {
        return false;
      }
      if (_selectedCallTypes.isNotEmpty &&
          !_selectedCallTypes.contains(log.callType)) {
        return false;
      }
      if (_selectedStatuses.isNotEmpty &&
          !_selectedStatuses.contains(log.callStatus)) {
        return false;
      }

      // Date range filter (From/To) takes priority over quick filter
      if (_dateFrom != null || _dateTo != null) {
        final logDate = DateTime(
          log.callDateTime.year,
          log.callDateTime.month,
          log.callDateTime.day,
        );
        if (_dateFrom != null) {
          final from = DateTime(
            _dateFrom!.year,
            _dateFrom!.month,
            _dateFrom!.day,
          );
          if (logDate.isBefore(from)) return false;
        }
        if (_dateTo != null) {
          final to = DateTime(_dateTo!.year, _dateTo!.month, _dateTo!.day);
          if (logDate.isAfter(to)) return false;
        }
        return true;
      }

      // Quick date filter
      if (_dateFilter != 'All') {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final logDate = DateTime(
          log.callDateTime.year,
          log.callDateTime.month,
          log.callDateTime.day,
        );
        switch (_dateFilter) {
          case 'Today':
            if (logDate != today) return false;
            break;
          case 'Yesterday':
            if (logDate != today.subtract(const Duration(days: 1))) {
              return false;
            }
            break;
          case 'This Week':
            if (log.callDateTime.isBefore(
              today.subtract(Duration(days: today.weekday - 1)),
            )) {
              return false;
            }
            break;
          case 'This Month':
            if (log.callDateTime.month != now.month ||
                log.callDateTime.year != now.year) {
              return false;
            }
            break;
        }
      }
      return true;
    }).toList();

    switch (_sortOption) {
      case 'Oldest First':
        result.sort((a, b) => a.callDateTime.compareTo(b.callDateTime));
        break;
      case 'Longest Duration':
        result.sort((a, b) => b.durationSeconds.compareTo(a.durationSeconds));
        break;
      case 'Shortest Duration':
        result.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
        break;
      case 'Lead Name A-Z':
        result.sort(
          (a, b) => (a.linkedLeadName ?? a.phoneNumber).compareTo(
            b.linkedLeadName ?? b.phoneNumber,
          ),
        );
        break;
      default:
        result.sort((a, b) => b.callDateTime.compareTo(a.callDateTime));
    }
    return result;
  }

  bool get _hasActiveFilters =>
      _dateFilter != 'Today' ||
      _dateFrom != null ||
      _dateTo != null ||
      _directionFilter != 'All' ||
      _selectedEmployees.isNotEmpty ||
      _selectedCallTypes.isNotEmpty ||
      _selectedStatuses.isNotEmpty;

  void _clearAllFilters() {
    setState(() {
      _dateFilter = 'Today';
      _dateFrom = null;
      _dateTo = null;
      _directionFilter = 'All';
      _selectedEmployees = [];
      _selectedCallTypes = [];
      _selectedStatuses = [];
    });
  }

  // Stats computed from today's calls only
  int get _todayConnectedCount {
    final now = DateTime.now();
    return globalCallLogs
        .where(
          (l) =>
              l.callDateTime.day == now.day &&
              l.callDateTime.month == now.month &&
              l.callDateTime.year == now.year &&
              l.callStatus.startsWith('Connected'),
        )
        .length;
  }

  int get _todayMissedCount {
    final now = DateTime.now();
    return globalCallLogs
        .where(
          (l) =>
              l.callDateTime.day == now.day &&
              l.callDateTime.month == now.month &&
              l.callDateTime.year == now.year &&
              l.direction == 'Missed',
        )
        .length;
  }

  int get _todayAppointmentCount {
    final now = DateTime.now();
    return globalCallLogs
        .where(
          (l) =>
              l.callDateTime.day == now.day &&
              l.callDateTime.month == now.month &&
              l.callDateTime.year == now.year &&
              l.appointmentType != null,
        )
        .length;
  }

  int get _todayFollowUpsCount {
    final now = DateTime.now();
    return globalCallLogs
        .where(
          (l) =>
              l.callDateTime.day == now.day &&
              l.callDateTime.month == now.month &&
              l.callDateTime.year == now.year &&
              l.followUpStatus == 'pending',
        )
        .length;
  }

  int get _todayTotalCount {
    final now = DateTime.now();
    return globalCallLogs
        .where(
          (l) =>
              l.callDateTime.day == now.day &&
              l.callDateTime.month == now.month &&
              l.callDateTime.year == now.year,
        )
        .length;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<dynamic> get _groupedLogs {
    final filtered = _filteredLogs;
    final List<dynamic> grouped = [];
    String? lastDateKey;
    for (final log in filtered) {
      final dateKey = log.formattedDate;
      if (dateKey != lastDateKey) {
        grouped.add(dateKey);
        lastDateKey = dateKey;
      }
      grouped.add(log);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    print('🔵 LogsScreen.build() called');
    final grouped = _groupedLogs;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    print(' grouped.length: ${grouped.length}, navBarHeight: $navBarHeight');

    try {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(bottom: navBarHeight),
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                snap: true,
                backgroundColor: AppTheme.backgroundLight,
                elevation: 0,
                scrolledUnderElevation: 1,
                shadowColor: AppTheme.surface200,
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        size: 20,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    onPressed: () => appScaffoldKey.currentState?.openDrawer(),
                  ),
                ),
                title: _isSearchActive
                    ? Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primary.withAlpha(120),
                          ),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search calls, leads, notes...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                      )
                    : Text(
                        'Call Logs',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isSearchActive
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      color: AppTheme.textPrimary,
                    ),
                    onPressed: () => setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) {
                        _searchCtrl.clear();
                        _searchQuery = '';
                      }
                    }),
                  ),
                  // Filter button
                  IconButton(
                    icon: Stack(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: _hasActiveFilters
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                        if (_hasActiveFilters)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () => _showFilterSheet(),
                  ),
                  // Sort button
                  IconButton(
                    icon: Icon(
                      Icons.sort_rounded,
                      color: _sortOption != 'Newest First'
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                    onPressed: () => _showSortSheet(),
                  ),
                ],
              ),

              // Stats row
              SliverToBoxAdapter(child: _buildStatsRow()),

              // Active filter chips
              if (_hasActiveFilters)
                SliverToBoxAdapter(child: _buildActiveFilterChips()),

              // Results count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    '${_filteredLogs.length} call${_filteredLogs.length != 1 ? 's' : ''}${_dateFilter == 'Today' && _dateFrom == null && _dateTo == null ? ' today' : ''}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),

              // Call log list with date headers
              if (grouped.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_outlined,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No calls found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try adjusting your filters',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(bottom: navBarHeight + 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final item = grouped[i];
                        if (item is String) return _buildDateHeader(item);
                        // TEMP: Simple container to test
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Call log ${(item as CallLogEntry).phoneNumber}'),
                        );
                      },
                      childCount: grouped.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e, stack) {
      print('🔴 LogsScreen.build() EXCEPTION: $e');
      print(' Stack: $stack');
      return Scaffold(
        body: Center(
          child: Text('Error: $e'),
        ),
      );
    }
  }

  Widget _buildDateHeader(String dateStr) {
    final now = DateTime.now();
    final months = [
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
    final today = '${now.day} ${months[now.month - 1]} ${now.year}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yestStr =
        '${yesterday.day} ${months[yesterday.month - 1]} ${yesterday.year}';
    String label = dateStr;
    if (dateStr == today) {
      label = 'Today';
    } else if (dateStr == yestStr)
      label = 'Yesterday';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: AppTheme.surface200, height: 1)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final kpis = [
      _LogsKpiData(
        label: 'Today',
        value: '$_todayTotalCount',
        icon: Icons.today_rounded,
        color: AppTheme.primary,
        trend: '+$_todayTotalCount',
        trendUp: true,
      ),
      _LogsKpiData(
        label: 'Connected',
        value: '$_todayConnectedCount',
        icon: Icons.call_rounded,
        color: AppTheme.success,
        trend: '+$_todayConnectedCount',
        trendUp: true,
      ),
      _LogsKpiData(
        label: 'Sessions',
        value: '$_todayAppointmentCount',
        icon: Icons.event_available_rounded,
        color: const Color(0xFF8B5CF6),
        trend: '+$_todayAppointmentCount',
        trendUp: true,
      ),
      _LogsKpiData(
        label: 'Follow Ups',
        value: '$_todayFollowUpsCount',
        icon: Icons.schedule_rounded,
        color: AppTheme.warning,
        trend: '-$_todayFollowUpsCount',
        trendUp: false,
      ),
      _LogsKpiData(
        label: 'Missed',
        value: '$_todayMissedCount',
        icon: Icons.call_missed_rounded,
        color: AppTheme.error,
        trend: '-$_todayMissedCount',
        trendUp: false,
      ),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _LogsKpiCard(data: kpis[i]),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          if (_dateFilter != 'Today')
            _ActiveChip(
              label: _dateFilter,
              onRemove: () => setState(() => _dateFilter = 'Today'),
            ),
          if (_dateFrom != null)
            _ActiveChip(
              label:
                  'From: ${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}',
              onRemove: () => setState(() => _dateFrom = null),
            ),
          if (_dateTo != null)
            _ActiveChip(
              label: 'To: ${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}',
              onRemove: () => setState(() => _dateTo = null),
            ),
          if (_directionFilter != 'All')
            _ActiveChip(
              label: _directionFilter,
              onRemove: () => setState(() => _directionFilter = 'All'),
            ),
          ..._selectedEmployees.map(
            (e) => _ActiveChip(
              label: e,
              onRemove: () => setState(() => _selectedEmployees.remove(e)),
            ),
          ),
          ..._selectedCallTypes.map(
            (t) => _ActiveChip(
              label: t,
              onRemove: () => setState(() => _selectedCallTypes.remove(t)),
            ),
          ),
          ..._selectedStatuses.map(
            (s) => _ActiveChip(
              label: s,
              onRemove: () => setState(() => _selectedStatuses.remove(s)),
            ),
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) {
            return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            maxChildSize: 0.95,
            builder: (_, ctrl) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ListView(
                controller: ctrl,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_hasActiveFilters)
                        TextButton(
                          onPressed: () {
                            _clearAllFilters();
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date Range (From / To) — shows all logs in that range
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
                              context: ctx,
                              initialDate:
                                  _dateFrom ??
                                  DateTime.now().subtract(
                                    const Duration(days: 30),
                                  ),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) {
                              setState(() {
                                _dateFrom = d;
                                _dateFilter = 'All';
                              });
                              setSheet(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                          ),
                          label: Text(
                            _dateFrom != null
                                ? '${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}'
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
                              context: ctx,
                              initialDate: _dateTo ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (d != null) {
                              setState(() {
                                _dateTo = d;
                                _dateFilter = 'All';
                              });
                              setSheet(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                          ),
                          label: Text(
                            _dateTo != null
                                ? '${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}'
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
                      if (_dateFrom != null || _dateTo != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: AppTheme.error,
                          ),
                          onPressed: () {
                            setState(() {
                              _dateFrom = null;
                              _dateTo = null;
                              _dateFilter = 'Today';
                            });
                            setSheet(() {});
                          },
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Or use quick filter:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        ['All', 'Today', 'Yesterday', 'This Week', 'This Month']
                            .map(
                              (f) => _SheetChip(
                                label: f,
                                isSelected:
                                    _dateFilter == f &&
                                    _dateFrom == null &&
                                    _dateTo == null,
                                onTap: () {
                                  setState(() {
                                    _dateFilter = f;
                                    _dateFrom = null;
                                    _dateTo = null;
                                  });
                                  setSheet(() {});
                                },
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Direction
                  Text(
                    'Direction',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _directions
                        .map(
                          (d) => _SheetChip(
                            label: d,
                            isSelected: _directionFilter == d,
                            onTap: () {
                              setState(() => _directionFilter = d);
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Assigned Employee — multiselect with pinned selected at top
                  Text(
                    'Assigned Employee',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LogsAssignedEmployeeFilter(
                    selectedEmployees: _selectedEmployees,
                    onChanged: (employees) {
                      setState(() => _selectedEmployees = employees);
                      setSheet(() {});
                    },
                  ),
                  const SizedBox(height: 16),

                  // Call types
                  Text(
                    'Call Type',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _callTypes
                        .map(
                          (t) => _SheetChip(
                            label: t,
                            isSelected: _selectedCallTypes.contains(t),
                            onTap: () {
                              setState(() {
                                if (_selectedCallTypes.contains(t)) {
                                  _selectedCallTypes.remove(t);
                                } else {
                                  _selectedCallTypes.add(t);
                                }
                              });
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  Text(
                    'Call Status',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _callStatuses
                        .map(
                          (s) => _SheetChip(
                            label: s,
                            isSelected: _selectedStatuses.contains(s),
                            onTap: () {
                              setState(() {
                                if (_selectedStatuses.contains(s)) {
                                  _selectedStatuses.remove(s);
                                } else {
                                  _selectedStatuses.add(s);
                                }
                              });
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Sort By',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ..._sortOptions.map((opt) {
                final isSelected = _sortOption == opt;
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.sort_rounded,
                    size: 20,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  title: Text(
                    opt,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    setState(() => _sortOption = opt);
                    setSheet(() {});
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _showCallDetail(CallLogEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _CallDetailSheet(entry: entry),
      ),
    );
  }
}

// ─── Logs Assigned Employee Filter (multiselect with pinned selected at top) ──

class _LogsEmployeeEntry {
  final String name;
  final String initials;
  final String role;
  final String id;
  final Color avatarColor;
  const _LogsEmployeeEntry({
    required this.name,
    required this.initials,
    required this.role,
    required this.id,
    required this.avatarColor,
  });
}

const _kLogsEmployees = [
  _LogsEmployeeEntry(
    name: 'Priya Sharma',
    initials: 'PS',
    role: 'Admin',
    id: 'ADM-1042',
    avatarColor: Color(0xFF7C3AED),
  ),
  _LogsEmployeeEntry(
    name: 'Rahul Singh',
    initials: 'RS',
    role: 'Senior Rep',
    id: 'EMP-2391',
    avatarColor: Color(0xFF059669),
  ),
  _LogsEmployeeEntry(
    name: 'Ananya Patel',
    initials: 'AP',
    role: 'Manager',
    id: 'EMP-1874',
    avatarColor: Color(0xFF059669),
  ),
  _LogsEmployeeEntry(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    id: 'EMP-3012',
    avatarColor: Color(0xFF059669),
  ),
  _LogsEmployeeEntry(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    id: 'EMP-2756',
    avatarColor: Color(0xFF059669),
  ),
  _LogsEmployeeEntry(
    name: 'Amit Kumar',
    initials: 'AK',
    role: 'Employee',
    id: 'EMP-4001',
    avatarColor: Color(0xFF059669),
  ),
  _LogsEmployeeEntry(
    name: 'Ravi Verma',
    initials: 'RV',
    role: 'Employee',
    id: 'EMP-4002',
    avatarColor: Color(0xFF059669),
  ),
];

class _LogsAssignedEmployeeFilter extends StatefulWidget {
  final List<String> selectedEmployees;
  final ValueChanged<List<String>> onChanged;
  const _LogsAssignedEmployeeFilter({
    required this.selectedEmployees,
    required this.onChanged,
  });

  @override
  State<_LogsAssignedEmployeeFilter> createState() =>
      _LogsAssignedEmployeeFilterState();
}

class _LogsAssignedEmployeeFilterState
    extends State<_LogsAssignedEmployeeFilter> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_LogsEmployeeEntry> get _displayList {
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      return _kLogsEmployees
          .where(
            (e) =>
                e.name.toLowerCase().contains(q) ||
                e.role.toLowerCase().contains(q) ||
                e.id.toLowerCase().contains(q),
          )
          .toList();
    }
    // Pinned selected at top, then unselected (max 3)
    final selected = _kLogsEmployees
        .where((e) => widget.selectedEmployees.contains(e.name))
        .toList();
    final unselected = _kLogsEmployees
        .where((e) => !widget.selectedEmployees.contains(e.name))
        .take(3)
        .toList();
    return [...selected, ...unselected];
  }

  Color _idColor(String id) {
    if (id.startsWith('ADM')) return const Color(0xFF7C3AED);
    if (id.startsWith('EMP')) return const Color(0xFF059669);
    return const Color(0xFFD97706);
  }

  Color _idBgColor(String id) {
    if (id.startsWith('ADM')) return const Color(0xFFEDE9FE);
    if (id.startsWith('EMP')) return const Color(0xFFD1FAE5);
    return const Color(0xFFFEF3C7);
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
              hintText: 'Search to see all employees...',
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
          'All Employees',
          'Show all logs',
          '',
          AppTheme.textSecondary,
          widget.selectedEmployees.isEmpty,
          () {
            widget.onChanged([]);
          },
        ),
        ..._displayList.map(
          (emp) => _buildRow(
            emp.initials,
            emp.name,
            emp.role,
            emp.id,
            emp.avatarColor,
            widget.selectedEmployees.contains(emp.name),
            () {
              final updated = List<String>.from(widget.selectedEmployees);
              if (updated.contains(emp.name)) {
                updated.remove(emp.name);
              } else {
                updated.add(emp.name);
              }
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
    Color avatarColor,
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
              radius: 20,
              backgroundColor: avatarColor.withAlpha(40),
              child: Text(
                initials.length > 2 ? initials.substring(0, 2) : initials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: avatarColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (id.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _idBgColor(id),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            id,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _idColor(id),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Logs KPI Data & Card (matches leads KPI design) ─────────────────────────

class _LogsKpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;
  const _LogsKpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });
}

class _LogsKpiCard extends StatelessWidget {
  final _LogsKpiData data;
  const _LogsKpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
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
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

// ─── Call Log Card ────────────────────────────────────────────────────────────

class _CallLogCard extends StatelessWidget {
  final CallLogEntry entry;
  final VoidCallback onTap;
  const _CallLogCard({required this.entry, required this.onTap});

  Color get _directionColor {
    switch (entry.direction) {
      case 'Incoming':
        return AppTheme.success;
      case 'Outgoing':
        return AppTheme.primary;
      case 'Missed':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  IconData get _directionIcon {
    switch (entry.direction) {
      case 'Incoming':
        return Icons.call_received_rounded;
      case 'Outgoing':
        return Icons.call_made_rounded;
      case 'Missed':
        return Icons.call_missed_rounded;
      default:
        return Icons.call_rounded;
    }
  }

  String _formatApptDate(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(now);
    final absDiff = diff.abs();

    if (diff.isNegative) {
      // Past / overdue
      final months = [
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
      final dateStr = '${d.day} ${months[d.month - 1]} ${d.year}';
      final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
      final m = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return 'Overdue · $dateStr $h:$m $ampm';
    }

    // Future
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return '${diff.inDays} days';
    // Beyond 7 days: show actual date
    final months = [
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
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatApptTime(DateTime d) {
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final m = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: _directionColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _directionColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_directionIcon, size: 18, color: _directionColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.linkedLeadName ?? entry.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        entry.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      entry.formattedTime,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Text(
                      entry.relativeTime,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Row(
                children: [
                  Flexible(child: _InfoBadge(label: entry.direction, color: _directionColor)),
                  const SizedBox(width: 6),
                  Flexible(child: _InfoBadge(label: entry.callType, color: AppTheme.primary)),
                  const SizedBox(width: 6),
                  Flexible(child: _InfoBadge(
                    label: entry.formattedDuration,
                    color: AppTheme.textSecondary,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      entry.agentInitials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.agentName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                _StatusBadge(status: entry.callStatus),
              ],
            ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (entry.appointmentType != null &&
                entry.appointmentDate != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withAlpha(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${entry.appointmentType} · ${_formatApptDate(entry.appointmentDate!)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppTheme.primary.withAlpha(60),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatApptTime(entry.appointmentDate!),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Call Detail Sheet ────────────────────────────────────────────────────────

class _CallDetailSheet extends StatelessWidget {
  final CallLogEntry entry;
  const _CallDetailSheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Call Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Call Info — no SIM, no Outcome; includes agent name + phone
            _DetailSection(
              title: 'Call Info',
              icon: Icons.call_rounded,
              children: [
                _DetailRow(label: 'Type', value: entry.callType),
                _DetailRow(label: 'Status', value: entry.callStatus),
                _DetailRow(label: 'Direction', value: entry.direction),
                _DetailRow(label: 'Duration', value: entry.formattedDuration),
                _DetailRow(label: 'Date', value: entry.formattedDate),
                _DetailRow(label: 'Time', value: entry.formattedTime),
                _DetailRow(label: 'Agent', value: entry.agentName),
                _DetailRow(label: 'Agent Role', value: entry.agentRole),
                if (entry.agentPhone.isNotEmpty)
                  _DetailRow(label: 'Agent Phone', value: entry.agentPhone),
              ],
            ),
            const SizedBox(height: 12),
            // Customer Details (renamed from Contact)
            _DetailSection(
              title: 'Customer Details',
              icon: Icons.person_outline_rounded,
              children: [
                _DetailRow(label: 'Number', value: entry.phoneNumber),
                if (entry.linkedLeadName != null)
                  _DetailRow(label: 'Name', value: entry.linkedLeadName!),
              ],
            ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Notes',
                icon: Icons.notes_rounded,
                children: [
                  Text(
                    entry.notes,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            if (entry.appointmentType != null &&
                entry.appointmentDate != null) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Appointment',
                icon: Icons.calendar_today_rounded,
                children: [
                  _DetailRow(label: 'Type', value: entry.appointmentType!),
                  _DetailRow(
                    label: 'Date',
                    value:
                        '${entry.appointmentDate!.day}/${entry.appointmentDate!.month}/${entry.appointmentDate!.year}',
                  ),
                  _DetailRow(
                    label: 'Time',
                    value:
                        '${entry.appointmentDate!.hour.toString().padLeft(2, '0')}:${entry.appointmentDate!.minute.toString().padLeft(2, '0')}',
                  ),
                  if (entry.appointmentNotes != null)
                    _DetailRow(label: 'Notes', value: entry.appointmentNotes!),
                ],
              ),
            ],
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Tags',
                icon: Icons.label_outline_rounded,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: entry.tags
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
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    if (status.startsWith('Connected')) return AppTheme.success;
    if (status == 'No Answer' || status == 'Missed') return AppTheme.error;
    if (status == 'Busy' || status == 'Switched Off') return AppTheme.warning;
    if (status == 'Appointment Set' || status == 'Deal Closed') {
      return AppTheme.primary;
    }
    return AppTheme.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withAlpha(60)),
      ),
      child: Text(
        status,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
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
              size: 12,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SheetChip({
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
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
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
