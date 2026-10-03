import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart' as leads_list;
import '../follow_ups_screen/follow_ups_screen.dart' as follow_ups;
import '../sessions_screen/sessions_screen.dart' as sessions;

// ─── Global Important Dates Data ─────────────────────────────────────────────

final List<Map<String, dynamic>> globalImportantDateMaps = [
  {
    'id': 'id-001',
    'leadId': 'default-1',
    'personName': 'Rahul Mehta',
    'relationship': 'Self',
    'dateType': 'Birthday',
    'date': DateTime(1985, 10, 12),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Customer birthday',
    'source': 'Lead Details',
    'ownerId': 'ADM-1042',
    'ownerName': 'Priya Sharma',
    'customerPhone': '+91 98765 43210',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 5)),
    'reminderTime': '09:00 AM',
    'tags': ['VIP', 'Birthday'],
    'interestTags': ['Life Insurance', 'Term Plan'],
    'agentName': 'Priya Sharma',
    'agentInitials': 'PS',
  },
  {
    'id': 'id-002',
    'leadId': 'default-1',
    'personName': 'Priya Mehta',
    'relationship': 'Spouse',
    'dateType': 'Birthday',
    'date': DateTime(1988, 3, 25),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Spouse birthday',
    'source': 'Lead Family Details',
    'ownerId': 'ADM-1042',
    'ownerName': 'Priya Sharma',
    'customerPhone': '+91 98765 43210',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 12)),
    'reminderTime': '10:00 AM',
    'tags': ['Birthday'],
    'interestTags': ['Health Insurance'],
    'agentName': 'Priya Sharma',
    'agentInitials': 'PS',
  },
  {
    'id': 'id-003',
    'leadId': 'default-1',
    'personName': 'Rahul & Priya Mehta',
    'relationship': 'Couple',
    'dateType': 'Marriage Anniversary',
    'date': DateTime(2012, 11, 18),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Wedding anniversary',
    'source': 'Lead Details',
    'ownerId': 'ADM-1042',
    'ownerName': 'Priya Sharma',
    'customerPhone': '+91 98765 43210',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 20)),
    'reminderTime': '11:00 AM',
    'tags': ['Anniversary'],
    'interestTags': ['Joint Policy'],
    'agentName': 'Priya Sharma',
    'agentInitials': 'PS',
  },
  {
    'id': 'id-004',
    'leadId': 'default-2',
    'personName': 'Sneha Kapoor',
    'relationship': 'Self',
    'dateType': 'Birthday',
    'date': DateTime(1992, DateTime.now().month, DateTime.now().day),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Customer birthday - TODAY',
    'source': 'Lead Details',
    'ownerId': 'EMP-2391',
    'ownerName': 'Rahul Singh',
    'customerPhone': '+91 87654 32109',
    'isActive': true,
    'reminderDate': DateTime.now(),
    'reminderTime': '08:00 AM',
    'tags': ['Birthday', 'Today'],
    'interestTags': ['Health Cover', 'Critical Illness'],
    'agentName': 'Rahul Singh',
    'agentInitials': 'RS',
  },
  {
    'id': 'id-005',
    'leadId': 'default-3',
    'personName': 'Vikram Singh',
    'relationship': 'Self',
    'dateType': 'Policy Renewal',
    'date': DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 3,
    ),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Term insurance policy renewal',
    'source': 'Policy Details',
    'ownerId': 'ADM-1042',
    'ownerName': 'Priya Sharma',
    'customerPhone': '+91 76543 21098',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 3)),
    'reminderTime': '09:30 AM',
    'tags': ['Policy', 'Renewal'],
    'interestTags': ['Term Insurance', 'ULIP'],
    'agentName': 'Priya Sharma',
    'agentInitials': 'PS',
  },
  {
    'id': 'id-006',
    'leadId': 'default-4',
    'personName': 'Anita Desai',
    'relationship': 'Self',
    'dateType': 'Birthday',
    'date': DateTime(1975, DateTime.now().month, DateTime.now().day + 1),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Customer birthday - TOMORROW',
    'source': 'Lead Details',
    'ownerId': 'EMP-1874',
    'ownerName': 'Ananya Patel',
    'customerPhone': '+91 65432 10987',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 1)),
    'reminderTime': '09:00 AM',
    'tags': ['Birthday'],
    'interestTags': ['Retirement Plan'],
    'agentName': 'Ananya Patel',
    'agentInitials': 'AP',
  },
  {
    'id': 'id-007',
    'leadId': 'default-5',
    'personName': 'Karan Joshi',
    'relationship': 'Self',
    'dateType': 'Birthday',
    'date': DateTime(1990, DateTime.now().month, DateTime.now().day + 5),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Customer birthday - this week',
    'source': 'Lead Details',
    'ownerId': 'EMP-3012',
    'ownerName': 'Kavya Menon',
    'customerPhone': '+91 54321 09876',
    'isActive': true,
    'reminderDate': DateTime.now().add(const Duration(days: 5)),
    'reminderTime': '10:00 AM',
    'tags': ['Birthday'],
    'interestTags': ['SIP', 'Mutual Fund'],
    'agentName': 'Kavya Menon',
    'agentInitials': 'KM',
  },
  {
    'id': 'id-008',
    'leadId': 'default-6',
    'personName': 'Mohammed Al-Rashid',
    'relationship': 'Self',
    'dateType': 'Birthday',
    'date': DateTime(
      1978,
      DateTime.now().month - 1 > 0 ? DateTime.now().month - 1 : 12,
      15,
    ),
    'isRecurring': true,
    'recurrenceType': 'yearly',
    'notes': 'Customer birthday - overdue this year',
    'source': 'Lead Details',
    'ownerId': 'ADM-1042',
    'ownerName': 'Priya Sharma',
    'customerPhone': '+971 50 123 4567',
    'isActive': true,
    'reminderDate': DateTime.now().subtract(const Duration(days: 2)),
    'reminderTime': '09:00 AM',
    'tags': ['Birthday', 'Overdue'],
    'interestTags': ['Key Man Insurance'],
    'agentName': 'Priya Sharma',
    'agentInitials': 'PS',
  },
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ImportantDatesScreen extends StatefulWidget {
  const ImportantDatesScreen({super.key});

  @override
  State<ImportantDatesScreen> createState() => _ImportantDatesScreenState();
}

class _ImportantDatesScreenState extends State<ImportantDatesScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  String _selectedTimeFilter = 'All';
  List<Map<String, dynamic>> _dates = [];
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _sortBy = 'Date (Ascending)';
  List<String> _selectedDateTypes = [];

  static const _timeFilters = [
    'All',
    'Today',
    'Tomorrow',
    'This Week',
    'This Month',
    'Overdue',
    'Completed',
  ];

  static const _sortOptions = [
    'Date (Ascending)',
    'Date (Descending)',
    'Name A-Z',
    'Name Z-A',
    'Type',
  ];

  static const _allDateTypes = [
    'Birthday',
    'Marriage Anniversary',
    'Policy Renewal',
    'Child Birthday',
    'Spouse Birthday',
    'Parent Birthday',
    'Relationship Birthday',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _dates = List.from(globalImportantDateMaps);
        _isLoading = false;
      });
    }
  }

  DateTime _nextOccurrence(DateTime original) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(now.year, original.month, original.day);
    if (next.isBefore(today)) {
      next = DateTime(now.year + 1, original.month, original.day);
    }
    return next;
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    final next = _nextOccurrence(dt);
    return next.year == now.year &&
        next.month == now.month &&
        next.day == now.day;
  }

  bool _isTomorrow(DateTime dt) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final next = _nextOccurrence(dt);
    return next.year == tomorrow.year &&
        next.month == tomorrow.month &&
        next.day == tomorrow.day;
  }

  bool _isThisWeek(DateTime dt) {
    final now = DateTime.now();
    final next = _nextOccurrence(dt);
    final diff = next.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff >= 0 && diff <= 7;
  }

  bool _isThisMonth(DateTime dt) {
    final now = DateTime.now();
    final next = _nextOccurrence(dt);
    return next.year == now.year && next.month == now.month;
  }

  bool _isOverdue(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final next = _nextOccurrence(dt);
    return next.isBefore(today);
  }

  bool _isCompleted(Map<String, dynamic> d) {
    return d['isCompleted'] == true;
  }

  List<Map<String, dynamic>> get _filteredDates {
    return _dates.where((d) {
      final personName = d['personName'] as String? ?? '';
      final ownerName = d['ownerName'] as String? ?? '';
      final dateType = d['dateType'] as String? ?? '';
      final date = d['date'] as DateTime;

      if (_selectedTimeFilter == 'Completed') {
        if (!_isCompleted(d)) return false;
      } else if (_selectedTimeFilter != 'All') {
        switch (_selectedTimeFilter) {
          case 'Today':
            if (!_isToday(date)) return false;
            break;
          case 'Tomorrow':
            if (!_isTomorrow(date)) return false;
            break;
          case 'This Week':
            if (!_isThisWeek(date)) return false;
            break;
          case 'This Month':
            if (!_isThisMonth(date)) return false;
            break;
          case 'Overdue':
            if (!_isOverdue(date)) return false;
            break;
        }
      }

      if (_selectedDateTypes.isNotEmpty &&
          !_selectedDateTypes.contains(dateType)) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!personName.toLowerCase().contains(q) &&
            !ownerName.toLowerCase().contains(q) &&
            !dateType.toLowerCase().contains(q)) {
          return false;
        }
      }

      return true;
    }).toList()..sort((a, b) {
      switch (_sortBy) {
        case 'Date (Ascending)':
          return _nextOccurrence(
            a['date'] as DateTime,
          ).compareTo(_nextOccurrence(b['date'] as DateTime));
        case 'Date (Descending)':
          return _nextOccurrence(
            b['date'] as DateTime,
          ).compareTo(_nextOccurrence(a['date'] as DateTime));
        case 'Name A-Z':
          return (a['personName'] as String? ?? '').compareTo(
            b['personName'] as String? ?? '',
          );
        case 'Name Z-A':
          return (b['personName'] as String? ?? '').compareTo(
            a['personName'] as String? ?? '',
          );
        case 'Type':
          return (a['dateType'] as String? ?? '').compareTo(
            b['dateType'] as String? ?? '',
          );
        default:
          return _nextOccurrence(
            a['date'] as DateTime,
          ).compareTo(_nextOccurrence(b['date'] as DateTime));
      }
    });
  }

  int get _todayCount =>
      _dates.where((d) => _isToday(d['date'] as DateTime)).length;
  int get _thisWeekCount =>
      _dates.where((d) => _isThisWeek(d['date'] as DateTime)).length;
  int get _thisMonthCount =>
      _dates.where((d) => _isThisMonth(d['date'] as DateTime)).length;
  int get _overdueCount =>
      _dates.where((d) => _isOverdue(d['date'] as DateTime)).length;
  int get _completedCount => _dates.where((d) => _isCompleted(d)).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDates;
    final hasFilter = _selectedDateTypes.isNotEmpty;
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
                    color: const Color(0xFF8B5CF6).withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cake_rounded,
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
                          'Important Dates',
                          maxLines: 1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${filtered.length} dates',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: hasFilter
                                  ? const Color(0xFF8B5CF6)
                                  : AppTheme.textSecondary,
                              fontWeight: hasFilter
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (hasFilter) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withAlpha(20),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'filtered',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  color: const Color(0xFF8B5CF6),
                                  fontWeight: FontWeight.w600,
                                ),
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
              GestureDetector(
                onTap: _showFilterSheet,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasFilter
                        ? const Color(0xFF8B5CF6).withAlpha(20)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasFilter
                          ? const Color(0xFF8B5CF6).withAlpha(80)
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list_rounded,
                    size: 16,
                    color: hasFilter
                        ? const Color(0xFF8B5CF6)
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showSortSheet,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _sortBy != 'Date (Ascending)'
                        ? const Color(0xFF8B5CF6).withAlpha(20)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sortBy != 'Date (Ascending)'
                          ? const Color(0xFF8B5CF6).withAlpha(80)
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: _sortBy != 'Date (Ascending)'
                        ? const Color(0xFF8B5CF6)
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_isSearchActive) _buildSearchBar(),
                _buildKpiRow(),
                _buildTimeFilter(),
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
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, navBarHeight + 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final items = _buildSectionedItems(filtered);
                    final item = items[i];
                    if (item is Map && item['_type'] == 'section') {
                      final label = item['label'] as String;
                      final isToday = label == 'Today';
                      final isOverdue = label == 'Overdue';
                      final isTomorrow = label == 'Tomorrow';
                      final isCompleted = label == 'Completed';
                      final headerColor = isOverdue
                          ? AppTheme.error
                          : isToday
                          ? AppTheme.primary
                          : isTomorrow
                          ? AppTheme.warning
                          : isCompleted
                          ? const Color(0xFF059669)
                          : const Color(0xFF8B5CF6);
                      final headerIcon = isOverdue
                          ? Icons.warning_rounded
                          : isToday
                          ? Icons.today_rounded
                          : isTomorrow
                          ? Icons.help_outline
                          : isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.calendar_today_rounded;
                      return Container(
                        margin: const EdgeInsets.only(top: 14, bottom: 4),
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
                                      label,
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
                    if (item is Map && item['_type'] == 'dateType') {
                      final label = item['label'] as String;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4),
                        child: Row(
                          children: [
                            Icon(_typeIcon(label), size: 13, color: _typeColor(label)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _typeColor(label),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Divider(
                                color: _typeColor(label).withAlpha(30),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final d = item as Map<String, dynamic>;
                    return _ImportantDateCard(
                      dateItem: d,
                      onUpdate: () => setState(() {
                        _dates = List.from(globalImportantDateMaps);
                      }),
                      nextOccurrence: _nextOccurrence(d['date'] as DateTime),
                      isToday: _isToday(d['date'] as DateTime),
                      isOverdue: _isOverdue(d['date'] as DateTime),
                    );
                  },
                  childCount: _buildSectionedItems(filtered).length,
                ),
              ),
            ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDateSheet,
        backgroundColor: const Color(0xFF8B5CF6),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Important Date',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      );
  }

  List<dynamic> _buildSectionedItems(List<Map<String, dynamic>> filtered) {
    final grouped = <String, Map<String, List<Map<String, dynamic>>>>{};
    final sectionOrder = <String>[];

    for (final d in filtered) {
      final date = d['date'] as DateTime;
      final next = _nextOccurrence(date);
      String section;

      if (_isOverdue(date)) {
        section = 'Overdue';
      } else if (_isToday(date)) {
        section = 'Today';
      } else if (next.year == DateTime.now().year &&
          next.month == DateTime.now().month &&
          next.day == DateTime.now().day + 1) {
        section = 'Tomorrow';
      } else if (d['tags']?.contains('Completed') == true) {
        section = 'Completed';
      } else if (next.isBefore(DateTime.now())) {
        section = 'Overdue';
      } else if (next.year == DateTime.now().year &&
          next.month == DateTime.now().month &&
          next.day == DateTime.now().day) {
        section = 'Today';
      } else {
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
        section = '${next.day} ${months[next.month - 1]} ${next.year}';
      }

      final dateType = d['dateType'] as String;
      if (!grouped.containsKey(section)) {
        grouped[section] = {};
        sectionOrder.add(section);
      }
      if (!grouped[section]!.containsKey(dateType)) {
        grouped[section]![dateType] = [];
      }
      grouped[section]![dateType]!.add(d);
    }

    final List<dynamic> items = [];
    for (final section in sectionOrder) {
      items.add({'_type': 'section', 'label': section});
      final typeMap = grouped[section]!;
      for (final dateType in typeMap.keys) {
        items.add({'_type': 'dateType', 'label': dateType, 'section': section});
        for (final d in typeMap[dateType]!) {
          items.add(d);
        }
      }
    }
    return items;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _IDFilterSheet(
          selectedTypes: List.from(_selectedDateTypes),
          allTypes: _allDateTypes,
          onApply: (types) => setState(() => _selectedDateTypes = types),
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
        child: _IDSortSheet(
          current: _sortBy,
          options: _sortOptions,
          onSelect: (s) => setState(() => _sortBy = s),
        ),
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
          hintText: 'Search dates...',
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
      (
        'Overdue',
        '$_overdueCount',
        Icons.warning_rounded,
        AppTheme.error,
        '$_overdueCount urgent',
      ),
      (
        'Today',
        '$_todayCount',
        Icons.today_rounded,
        AppTheme.primary,
        '$_todayCount due',
      ),
      (
        'This Week',
        '$_thisWeekCount',
        Icons.date_range_rounded,
        const Color(0xFF8B5CF6),
        '$_thisWeekCount upcoming',
      ),
      (
        'This Month',
        '$_thisMonthCount',
        Icons.calendar_month_rounded,
        AppTheme.success,
        '$_thisMonthCount total',
      ),
      (
        'Completed',
        '$_completedCount',
        Icons.check_circle_rounded,
        const Color(0xFF059669),
        '$_completedCount done',
      ),
    ];
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final (label, count, icon, color, sub) = kpis[i];
          return Container(
            width: 110,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surface200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 6,
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
                        color: color.withAlpha(31),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 14, color: color),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_down_rounded,
                            size: 11,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              sub,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
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
                const SizedBox(height: 6),
                Text(
                  count,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _timeFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final tf = _timeFilters[i];
          final selected = _selectedTimeFilter == tf;
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeFilter = tf),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF8B5CF6)
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF8B5CF6)
                        : AppTheme.surface200,
                  ),
                ),
                child: Text(
                  tf,
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cake_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No important dates found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add dates from leads or manually',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Birthday':
      case 'Child Birthday':
      case 'Spouse Birthday':
      case 'Parent Birthday':
      case 'Relationship Birthday':
        return Icons.cake_rounded;
      case 'Marriage Anniversary':
        return Icons.favorite_rounded;
      case 'Policy Renewal':
        return Icons.assignment_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Birthday':
      case 'Child Birthday':
      case 'Spouse Birthday':
      case 'Parent Birthday':
      case 'Relationship Birthday':
        return const Color(0xFFEC4899);
      case 'Marriage Anniversary':
        return const Color(0xFFEF4444);
      case 'Policy Renewal':
        return const Color(0xFF0891B2);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  void _showAddDateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _AddImportantDateSheet(
          onSave: (dateData) {
            globalImportantDateMaps.insert(0, dateData);
            setState(() {
              _dates = List.from(globalImportantDateMaps);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Important date added!'),
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

// ─── Important Date Card ──────────────────────────────────────────────────────

class _ImportantDateCard extends StatelessWidget {
  final Map<String, dynamic> dateItem;
  final VoidCallback onUpdate;
  final DateTime nextOccurrence;
  final bool isToday;
  final bool isOverdue;

  const _ImportantDateCard({
    required this.dateItem,
    required this.onUpdate,
    required this.nextOccurrence,
    required this.isToday,
    required this.isOverdue,
  });

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Birthday':
      case 'Child Birthday':
      case 'Spouse Birthday':
      case 'Parent Birthday':
      case 'Relationship Birthday':
        return Icons.cake_rounded;
      case 'Marriage Anniversary':
        return Icons.favorite_rounded;
      case 'Policy Renewal':
        return Icons.assignment_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Birthday':
      case 'Child Birthday':
      case 'Spouse Birthday':
      case 'Parent Birthday':
      case 'Relationship Birthday':
        return const Color(0xFFEC4899);
      case 'Marriage Anniversary':
        return const Color(0xFFEF4444);
      case 'Policy Renewal':
        return const Color(0xFF0891B2);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  String _formatNextDate(DateTime dt) {
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

  /// Returns human-readable time remaining/overdue in years/months/days/hours format
  /// e.g. "In 1yr 11mo", "In 3mo 5d", "2d overdue"
  String _timeUntil(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = target.difference(today);

    if (diff.inDays == 0) return 'Today!';
    if (diff.inDays == 1) return 'Tomorrow';

    final isOverdue = diff.inDays < 0;
    final absDays = diff.inDays.abs();

    if (isOverdue) {
      if (absDays < 1) {
        final hrs = now.difference(dt).inHours;
        return '${hrs}h overdue';
      }
      if (absDays < 30) return '${absDays}d overdue';
      if (absDays < 365) {
        final months = (absDays / 30).floor();
        final days = absDays % 30;
        if (days == 0) return '${months}mo overdue';
        return '${months}mo ${days}d overdue';
      }
      final years = (absDays / 365).floor();
      final rem = absDays % 365;
      final months = (rem / 30).floor();
      final days = rem % 30;
      if (months == 0 && days == 0) return '${years}yr overdue';
      if (days == 0) return '${years}yr ${months}mo overdue';
      return '${years}yr ${months}mo ${days}d overdue';
    } else {
      if (absDays < 30) return 'In ${absDays}d';
      if (absDays < 365) {
        final months = (absDays / 30).floor();
        final days = absDays % 30;
        if (days == 0) return 'In ${months}mo';
        return 'In ${months}mo ${days}d';
      }
      final years = (absDays / 365).floor();
      final rem = absDays % 365;
      final months = (rem / 30).floor();
      final days = rem % 30;
      if (months == 0 && days == 0) return 'In ${years}yr';
      if (days == 0) return 'In ${years}yr ${months}mo';
      return 'In ${years}yr ${months}mo ${days}d';
    }
  }

  String _formatReminderDateTime(Map<String, dynamic> item) {
    final rd = item['reminderDate'] as DateTime?;
    final rt = item['reminderTime'] as String? ?? '';
    if (rd == null) return '';
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
    final dateStr = '${rd.day} ${months[rd.month - 1]} ${rd.year}';
    return rt.isNotEmpty ? '$dateStr · $rt' : dateStr;
  }

  /// Find if this lead is in a follow-up or session
  Map<String, dynamic>? _findFollowUp(String leadId) {
    if (leadId.isEmpty) return null;
    try {
      final fu = follow_ups.globalFollowUpMaps.firstWhere(
        (m) =>
            (m['leadId'] as String? ?? '') == leadId &&
            m['isCompleted'] != true,
        orElse: () => {},
      );
      return fu.isEmpty ? null : fu;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _findSession(String leadId) {
    if (leadId.isEmpty) return null;
    try {
      final ses = sessions.globalSessionMaps.firstWhere(
        (m) =>
            (m['leadId'] as String? ?? '') == leadId &&
            m['status'] != 'Completed',
        orElse: () => {},
      );
      return ses.isEmpty ? null : ses;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateType = dateItem['dateType'] as String? ?? '';
    final personName = dateItem['personName'] as String? ?? '';
    final relationship = dateItem['relationship'] as String? ?? '';
    final phone = dateItem['customerPhone'] as String? ?? '';
    final notes = dateItem['notes'] as String? ?? '';
    final typeColor = _typeColor(dateType);
    final leadId = dateItem['leadId'] as String? ?? '';
    final isLinkedToLead = leadId.isNotEmpty;
    final isExistingCustomer = isLinkedToLead;
    final instagram = dateItem['instagram'] as String? ?? '';
    final facebook = dateItem['facebook'] as String? ?? '';
    final twitter = dateItem['twitter'] as String? ?? '';
    final telegram = dateItem['telegram'] as String? ?? '';
    final email = dateItem['email'] as String? ?? '';
    final tags = (dateItem['tags'] as List?)?.cast<String>() ?? [];
    final interestTags =
        (dateItem['interestTags'] as List?)?.cast<String>() ?? [];
    final agentName = dateItem['agentName'] as String? ?? '';
    final agentInitials = dateItem['agentInitials'] as String? ?? '';
    final reminderStr = _formatReminderDateTime(dateItem);

    // Lead details snippet
    Map<String, dynamic>? linkedLead;
    if (isLinkedToLead) {
      try {
        linkedLead = leads_list.globalLeads.firstWhere(
          (m) => m['id'] == leadId,
          orElse: () => {},
        );
        if (linkedLead.isEmpty) linkedLead = null;
      } catch (_) {
        linkedLead = null;
      }
    }

    // Check if in follow-up or session
    final activeFollowUp = _findFollowUp(leadId);
    final activeSession = _findSession(leadId);

    return GestureDetector(
      onTap: () => _showDetailSheet(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isToday
                ? const Color(0xFF8B5CF6).withAlpha(100)
                : isOverdue
                ? AppTheme.error.withAlpha(80)
                : AppTheme.surface200,
            width: isToday || isOverdue ? 2 : 1,
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
            if (isToday)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(25),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.celebration_rounded,
                      size: 12,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '🎉 Today! Don\'t forget to wish!',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8B5CF6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            if (isOverdue && !isToday)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.error.withAlpha(20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 12,
                      color: AppTheme.error,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Overdue — ${_timeUntil(nextOccurrence)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.error,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: icon + name + time badge + 3-dots
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _typeIcon(dateType),
                          color: typeColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TooltipText(
                              text: personName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              relationship.isNotEmpty
                                  ? '$dateType · $relationship'
                                  : dateType,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: typeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Mobile number below self/reason label
                            if (phone.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_rounded,
                                    size: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      phone,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(0xFF8B5CF6).withAlpha(20)
                              : isOverdue
                              ? AppTheme.error.withAlpha(20)
                              : AppTheme.surface100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _timeUntil(nextOccurrence),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? const Color(0xFF8B5CF6)
                                : isOverdue
                                ? AppTheme.error
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // 3-dots menu
                      GestureDetector(
                        onTap: () => _showThreeDotsMenu(
                          context,
                          phone: phone,
                          email: email,
                          instagram: instagram,
                          facebook: facebook,
                          twitter: twitter,
                          telegram: telegram,
                          leadId: leadId,
                          isLinkedToLead: isLinkedToLead,
                        ),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.surface100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.more_vert_rounded,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Agent row
                  if (agentName.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              agentInitials.isNotEmpty ? agentInitials[0] : 'A',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          agentName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  // Interest tags
                  if (interestTags.isNotEmpty) ...[
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: interestTags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0891B2).withAlpha(15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF0891B2).withAlpha(50),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: const Color(0xFF0891B2),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 6),
                  ],
                  // Follow-up or Session tag with date/time
                  if (activeFollowUp != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.warning.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.repeat_rounded,
                            size: 11,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'In Follow-up',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppTheme.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (activeFollowUp['dueDate'] != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '· ${_formatShortDate(activeFollowUp['dueDate'] as DateTime)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppTheme.warning,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ] else if (activeSession != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF8B5CF6).withAlpha(50),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.video_call_rounded,
                            size: 11,
                            color: Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'In Session',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: const Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (activeSession['date'] != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '· ${_formatShortDate(activeSession['date'] as DateTime)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  // Tags row: Existing Customer + Connected to Lead
                  if (isExistingCustomer || isLinkedToLead) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (isExistingCustomer)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669).withAlpha(15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF059669).withAlpha(60),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 11,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Existing Customer',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isLinkedToLead)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.primary.withAlpha(60),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link_rounded,
                                  size: 11,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Connected to Lead',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Lead details snippet
                  if (linkedLead != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  linkedLead['name'] as String? ?? 'Lead',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                if ((linkedLead['phone'] as String? ?? '')
                                    .isNotEmpty)
                                  Text(
                                    linkedLead['phone'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if ((linkedLead['status'] as String? ?? '')
                              .isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                linkedLead['status'] as String? ?? '',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Reminder date/time with tag
                  if (reminderStr.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.alarm_rounded,
                          size: 12,
                          color: const Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminderStr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF8B5CF6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (tags.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tags.first,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: const Color(0xFF8B5CF6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  // Notes preview
                  if (notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.notes_rounded,
                          size: 12,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            notes,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Follow-up style action row
                  _buildActionRow(context, phone: phone, email: email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(DateTime dt) {
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
    return '${dt.day} ${months[dt.month - 1]}, $h:${dt.minute.toString().padLeft(2, '0')} $ampm';
  }

  Widget _buildActionRow(
    BuildContext context, {
    required String phone,
    required String email,
  }) {
    final hasPhone = phone.isNotEmpty;
    final hasEmail = email.isNotEmpty;
    final instagram = dateItem['instagram'] as String? ?? '';
    final facebook = dateItem['facebook'] as String? ?? '';
    final twitter = dateItem['twitter'] as String? ?? '';
    final telegram = dateItem['telegram'] as String? ?? '';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ActionBadgeBtn(
            icon: Icons.phone_rounded,
            count: hasPhone ? 1 : 0,
            color: const Color(0xFF059669),
            enabled: hasPhone,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionBadgeBtn(
            icon: Icons.chat_bubble_rounded,
            count: hasPhone ? 1 : 0,
            color: const Color(0xFF3B82F6),
            enabled: hasPhone,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionBadgeBtn(
            icon: Icons.chat_rounded,
            count: hasPhone ? 1 : 0,
            color: const Color(0xFF25D366),
            enabled: hasPhone,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionBadgeBtn(
            icon: Icons.email_rounded,
            count: hasEmail ? 1 : 0,
            color: const Color(0xFF8B5CF6),
            enabled: hasEmail,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          // X (Twitter) — always shown and enabled
          _ActionBadgeBtn(
            icon: Icons.close_rounded,
            count: twitter.isNotEmpty ? 1 : 0,
            color: const Color(0xFF000000),
            enabled: true,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          // Telegram — always shown and enabled
          _ActionBadgeBtn(
            icon: Icons.send_rounded,
            count: telegram.isNotEmpty ? 1 : 0,
            color: const Color(0xFF0088CC),
            enabled: true,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          // Facebook — always shown and enabled
          _ActionBadgeBtn(
            icon: Icons.facebook_rounded,
            count: facebook.isNotEmpty ? 1 : 0,
            color: const Color(0xFF1877F2),
            enabled: true,
            onTap: () {},
          ),
          if (instagram.isNotEmpty) ...[
            const SizedBox(width: 6),
            _ActionBadgeBtn(
              icon: Icons.camera_alt_rounded,
              count: 1,
              color: const Color(0xFFE1306C),
              enabled: true,
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _IDDetailSheet(dateItem: dateItem),
      ),
    );
  }

  void _showThreeDotsMenu(
    BuildContext context, {
    required String phone,
    required String email,
    required String instagram,
    required String facebook,
    required String twitter,
    required String telegram,
    required String leadId,
    required bool isLinkedToLead,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _IDThreeDotsSheet(
          phone: phone,
          email: email,
          instagram: instagram,
          facebook: facebook,
          twitter: twitter,
          telegram: telegram,
          leadId: leadId,
          isLinkedToLead: isLinkedToLead,
          onViewLead: () {
            if (leadId.isNotEmpty) {
              final leadMap = leads_list.globalLeads.firstWhere(
                (m) => m['id'] == leadId,
                orElse: () => {},
              );
              if (leadMap.isNotEmpty) {
                context.push(
                  AppRoutes.leadDetailScreen,
                  extra: leads_list.LeadModel.fromMap(leadMap),
                );
              }
            }
          },
          onViewCustomer: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Opening customer details...'),
                backgroundColor: AppTheme.primary,
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
}

// ─── Action Badge Button (follow-up style) ────────────────────────────────────

class _ActionBadgeBtn extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionBadgeBtn({
    required this.icon,
    required this.count,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: enabled ? color.withAlpha(15) : AppTheme.surface100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? color.withAlpha(60) : AppTheme.surface200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: enabled ? color : AppTheme.textMuted),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: enabled ? color : AppTheme.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Detail Sheet ─────────────────────────────────────────────────────────────

class _IDDetailSheet extends StatelessWidget {
  final Map<String, dynamic> dateItem;

  const _IDDetailSheet({required this.dateItem});

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
    final personName = dateItem['personName'] as String? ?? '';
    final relationship = dateItem['relationship'] as String? ?? '';
    final dateType = dateItem['dateType'] as String? ?? '';
    final date = dateItem['date'] as DateTime?;
    final notes = dateItem['notes'] as String? ?? '';
    final phone = dateItem['customerPhone'] as String? ?? '';
    final ownerName = dateItem['ownerName'] as String? ?? '';
    final source = dateItem['source'] as String? ?? '';
    final tags = (dateItem['tags'] as List?)?.cast<String>() ?? [];
    final interestTags =
        (dateItem['interestTags'] as List?)?.cast<String>() ?? [];
    final reminderDate = dateItem['reminderDate'] as DateTime?;
    final reminderTime = dateItem['reminderTime'] as String? ?? '';
    final leadId = dateItem['leadId'] as String? ?? '';
    final agentName = dateItem['agentName'] as String? ?? '';

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
                    personName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
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
            Text(
              relationship.isNotEmpty ? '$dateType · $relationship' : dateType,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF8B5CF6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _DetailItem(
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value: date != null ? _formatDate(date) : 'N/A',
            ),
            if (phone.isNotEmpty)
              _DetailItem(
                icon: Icons.phone_rounded,
                label: 'Phone',
                value: phone,
              ),
            if (reminderDate != null)
              _DetailItem(
                icon: Icons.alarm_rounded,
                label: 'Reminder',
                value: reminderTime.isNotEmpty
                    ? '${_formatDate(reminderDate)} · $reminderTime'
                    : _formatDate(reminderDate),
              ),
            if (agentName.isNotEmpty)
              _DetailItem(
                icon: Icons.person_pin_rounded,
                label: 'Agent',
                value: agentName,
              ),
            if (interestTags.isNotEmpty)
              _DetailItem(
                icon: Icons.interests_rounded,
                label: 'Interests',
                value: interestTags.join(', '),
              ),
            if (tags.isNotEmpty)
              _DetailItem(
                icon: Icons.label_rounded,
                label: 'Tags',
                value: tags.join(', '),
              ),
            if (notes.isNotEmpty)
              _DetailItem(
                icon: Icons.notes_rounded,
                label: 'Notes',
                value: notes,
              ),
            if (ownerName.isNotEmpty)
              _DetailItem(
                icon: Icons.person_outline_rounded,
                label: 'Created by',
                value: ownerName,
              ),
            if (source.isNotEmpty)
              _DetailItem(
                icon: Icons.source_rounded,
                label: 'Source',
                value: source,
              ),
            if (leadId.isNotEmpty)
              _DetailItem(
                icon: Icons.link_rounded,
                label: 'Lead ID',
                value: leadId,
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
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
}

// ─── Tooltip Text Widget ──────────────────────────────────────────────────────

class _TooltipText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const _TooltipText({
    required this.text,
    required this.style,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        final overlay = Overlay.of(context);
        late OverlayEntry entry;
        entry = OverlayEntry(
          builder: (_) =>
              _TooltipOverlay(text: text, onDismiss: () => entry.remove()),
        );
        overlay.insert(entry);
        Future.delayed(const Duration(seconds: 3), () {
          if (entry.mounted) entry.remove();
        });
      },
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final String text;
  final VoidCallback onDismiss;
  const _TooltipOverlay({required this.text, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 3-Dots Menu Sheet ────────────────────────────────────────────────────────

class _IDThreeDotsSheet extends StatelessWidget {
  final String phone;
  final String email;
  final String instagram;
  final String facebook;
  final String twitter;
  final String telegram;
  final String leadId;
  final bool isLinkedToLead;
  final VoidCallback onViewLead;
  final VoidCallback onViewCustomer;

  const _IDThreeDotsSheet({
    required this.phone,
    required this.email,
    required this.instagram,
    required this.facebook,
    required this.twitter,
    required this.telegram,
    required this.leadId,
    required this.isLinkedToLead,
    required this.onViewLead,
    required this.onViewCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhone = phone.isNotEmpty;
    final hasEmail = email.isNotEmpty;
    final hasInstagram = instagram.isNotEmpty;
    final hasFacebook = facebook.isNotEmpty;
    final hasTwitter = twitter.isNotEmpty;
    final hasTelegram = telegram.isNotEmpty;
    final hasLead = leadId.isNotEmpty && isLinkedToLead;

    final items = [
      _IDMenuItem(
        icon: Icons.info_outline_rounded,
        label: 'View Lead',
        color: AppTheme.primary,
        enabled: hasLead,
        onTap: () {
          Navigator.pop(context);
          onViewLead();
        },
      ),
      _IDMenuItem(
        icon: Icons.person_rounded,
        label: 'View Customer Details',
        color: const Color(0xFF059669),
        enabled: hasLead,
        onTap: () {
          Navigator.pop(context);
          onViewCustomer();
        },
      ),
      _IDMenuItem(
        icon: Icons.phone_rounded,
        label: 'Call',
        color: const Color(0xFF059669),
        enabled: hasPhone,
        onTap: () => Navigator.pop(context),
      ),
      _IDMenuItem(
        icon: Icons.chat_bubble_rounded,
        label: 'Message',
        color: const Color(0xFF3B82F6),
        enabled: hasPhone,
        onTap: () => Navigator.pop(context),
      ),
      _IDMenuItem(
        icon: Icons.chat_rounded,
        label: 'WhatsApp',
        color: const Color(0xFF25D366),
        enabled: hasPhone,
        onTap: () => Navigator.pop(context),
      ),
      _IDMenuItem(
        icon: Icons.email_rounded,
        label: 'Email',
        color: const Color(0xFF8B5CF6),
        enabled: hasEmail,
        onTap: () => Navigator.pop(context),
      ),
      _IDMenuItem(
        icon: Icons.camera_alt_rounded,
        label: 'Instagram',
        color: const Color(0xFFE1306C),
        enabled: hasInstagram,
        onTap: () => Navigator.pop(context),
      ),
      // Facebook — always shown
      _IDMenuItem(
        icon: Icons.facebook_rounded,
        label: 'Facebook',
        color: const Color(0xFF1877F2),
        enabled: hasFacebook,
        onTap: () => Navigator.pop(context),
      ),
      // X (Twitter) — always shown and enabled
      _IDMenuItem(
        icon: Icons.close_rounded,
        label: 'X (Twitter)',
        color: const Color(0xFF000000),
        enabled: true,
        onTap: () => Navigator.pop(context),
      ),
      // Telegram — always shown and enabled
      _IDMenuItem(
        icon: Icons.send_rounded,
        label: 'Telegram',
        color: const Color(0xFF0088CC),
        enabled: true,
        onTap: () => Navigator.pop(context),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Actions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => _buildMenuItem(item)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_IDMenuItem item) {
    return InkWell(
      onTap: item.enabled ? item.onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.enabled
                    ? item.color.withAlpha(20)
                    : AppTheme.surface100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 18,
                color: item.enabled ? item.color : AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              item.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: item.enabled ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ),
            if (!item.enabled) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surface100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'N/A',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IDMenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;
  const _IDMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.enabled,
    required this.onTap,
  });
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────

class _IDFilterSheet extends StatefulWidget {
  final List<String> selectedTypes;
  final List<String> allTypes;
  final void Function(List<String>) onApply;

  const _IDFilterSheet({
    required this.selectedTypes,
    required this.allTypes,
    required this.onApply,
  });

  @override
  State<_IDFilterSheet> createState() => _IDFilterSheetState();
}

class _IDFilterSheetState extends State<_IDFilterSheet> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  'Filter by Date Type',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selected.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => selected.clear()),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.allTypes.map((type) {
              final sel = selected.contains(type);
              return GestureDetector(
                onTap: () => setState(() {
                  if (sel) {
                    selected.remove(type);
                  } else {
                    selected.add(type);
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF8B5CF6) : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sel
                          ? const Color(0xFF8B5CF6)
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    type,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      color: sel ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(selected);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filter',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sort Sheet ───────────────────────────────────────────────────────────────

class _IDSortSheet extends StatelessWidget {
  final String current;
  final List<String> options;
  final void Function(String) onSelect;

  const _IDSortSheet({
    required this.current,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Sort By',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((opt) {
            final sel = current == opt;
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                onSelect(opt);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                          color: sel
                              ? const Color(0xFF8B5CF6)
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (sel)
                      const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Color(0xFF8B5CF6),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Important Date Sheet ─────────────────────────────────────────────────

class _AddImportantDateSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;
  const _AddImportantDateSheet({required this.onSave});

  @override
  State<_AddImportantDateSheet> createState() => _AddImportantDateSheetState();
}

class _AddImportantDateSheetState extends State<_AddImportantDateSheet> {
  final nameCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final otherTagCtrl = TextEditingController();
  final otherRelationshipCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String dateType = 'Birthday';
  String relationship = 'Self';
  DateTime? selectedDate;
  Map<String, dynamic>? selectedLead;
  bool showLeadSearch = false;
  String leadSearchQuery = '';
  final leadSearchCtrl = TextEditingController();
  final List<String> otherTags = [];

  static const dateTypes = [
    'Birthday',
    'Marriage Anniversary',
    'Relationship Birthday',
    'Child Birthday',
    'Spouse Birthday',
    'Parent Birthday',
    'Policy Renewal',
    'Other',
  ];
  static const relationships = [
    'Self',
    'Spouse',
    'Child',
    'Father',
    'Mother',
    'Sibling',
    'Relative',
    'Other',
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    notesCtrl.dispose();
    leadSearchCtrl.dispose();
    otherTagCtrl.dispose();
    otherRelationshipCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLeads {
    final q = leadSearchQuery.toLowerCase();
    return leads_list.globalLeads.where((m) {
      final name = (m['name'] as String? ?? '').toLowerCase();
      final phone = (m['phone'] as String? ?? '').toLowerCase();
      return q.isEmpty || name.contains(q) || phone.contains(q);
    }).toList();
  }

  String formatDate(DateTime dt) {
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

  bool get _canSave {
    if (nameCtrl.text.trim().isEmpty || selectedDate == null) return false;
    if (dateType == 'Other' && otherTags.isEmpty) return false;
    if (relationship == 'Other' && otherRelationshipCtrl.text.trim().isEmpty) {
      return false;
    }
    return true;
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
                    'Add Important Date',
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
            // Link to Lead
            buildLabel('Link to Lead'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => setState(() => showLeadSearch = !showLeadSearch),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selectedLead != null
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedLead != null
                        ? AppTheme.primary.withAlpha(60)
                        : AppTheme.surface200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      size: 16,
                      color: selectedLead != null
                          ? AppTheme.primary
                          : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedLead != null
                            ? (selectedLead!['name'] as String? ?? '')
                            : 'Search and select customer from leads',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: selectedLead != null
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ),
                    Icon(
                      showLeadSearch
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                      color: AppTheme.textMuted,
                    ),
                  ],
                ),
              ),
            ),
            if (showLeadSearch) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: TextField(
                  controller: leadSearchCtrl,
                  autofocus: true,
                  onChanged: (v) => setState(() => leadSearchQuery = v),
                  style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppTheme.textMuted,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _filteredLeads.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: AppTheme.surface200),
                  itemBuilder: (_, i) {
                    final lead = _filteredLeads[i];
                    final name = lead['name'] as String? ?? '';
                    final phone = lead['phone'] as String? ?? '';
                    return InkWell(
                      onTap: () => setState(() {
                        selectedLead = lead;
                        showLeadSearch = false;
                        nameCtrl.text = name;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primary.withAlpha(30),
                              child: Text(
                                name.isNotEmpty ? name[0] : '?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (phone.isNotEmpty)
                                  Text(
                                    phone,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                              ],
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
            buildLabel('Person Name *'),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Enter person name',
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
            buildLabel('Date Type *'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: dateTypes.map((t) {
                final sel = dateType == t;
                return GestureDetector(
                  onTap: () => setState(() => dateType = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: sel
                          ? const Color(0xFF8B5CF6)
                          : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? const Color(0xFF8B5CF6)
                            : AppTheme.surface200,
                      ),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: sel ? Colors.white : AppTheme.textSecondary,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            // If "Other" date type selected — COMPULSORY tags input
            if (dateType == 'Other') ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withAlpha(40),
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
                          color: Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Specify Date Type Tags *',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B5CF6),
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
                            controller: otherTagCtrl,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: InputDecoration(
                              hintText:
                                  'e.g. Business Anniversary, Graduation...',
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
                                  otherTags.add(v.trim());
                                  otherTagCtrl.clear();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            if (otherTagCtrl.text.trim().isNotEmpty) {
                              setState(() {
                                otherTags.add(otherTagCtrl.text.trim());
                                otherTagCtrl.clear();
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6),
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
                    if (otherTags.isEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Please add at least one tag to describe this date type',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.error,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (otherTags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: otherTags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6).withAlpha(20),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF8B5CF6,
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
                                        color: const Color(0xFF8B5CF6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => otherTags.remove(tag)),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 12,
                                        color: Color(0xFF8B5CF6),
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
            buildLabel('Relationship'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: relationships.map((r) {
                final sel = relationship == r;
                return GestureDetector(
                  onTap: () => setState(() => relationship = r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? AppTheme.primary : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? AppTheme.primary : AppTheme.surface200,
                      ),
                    ),
                    child: Text(
                      r,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: sel ? Colors.white : AppTheme.textSecondary,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            // If "Other" relationship selected — COMPULSORY text input
            if (relationship == 'Other') ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withAlpha(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mention Relationship *',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
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
                    TextField(
                      controller: otherRelationshipCtrl,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g. Business Partner, Mentor, Friend...',
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
                    if (otherRelationshipCtrl.text.trim().isEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Please specify the relationship',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.error,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            buildLabel('Date *'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1990, 1, 1),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                );
                if (d != null) setState(() => selectedDate = d);
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
                    color: selectedDate != null
                        ? const Color(0xFF8B5CF6).withAlpha(60)
                        : AppTheme.surface200,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate != null
                          ? formatDate(selectedDate!)
                          : 'Select date',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: selectedDate != null
                            ? AppTheme.textPrimary
                            : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Phone Number — optional
            buildLabel('Phone Number (Optional)'),
            const SizedBox(height: 6),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. +91 98765 43210',
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
            const SizedBox(height: 12),
            buildLabel('Notes'),
            const SizedBox(height: 6),
            TextField(
              controller: notesCtrl,
              maxLines: 2,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
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
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave
                    ? () {
                        final finalRelationship = relationship == 'Other'
                            ? otherRelationshipCtrl.text.trim()
                            : relationship;
                        final finalDateType =
                            dateType == 'Other' && otherTags.isNotEmpty
                            ? otherTags.first
                            : dateType;
                        final dateData = {
                          'id': 'id-${DateTime.now().millisecondsSinceEpoch}',
                          'leadId': selectedLead?['id'] ?? '',
                          'personName': nameCtrl.text.trim(),
                          'relationship': finalRelationship,
                          'dateType': finalDateType,
                          'date': selectedDate!,
                          'isRecurring': true,
                          'recurrenceType': 'yearly',
                          'notes': notesCtrl.text.trim(),
                          'source': 'Manual',
                          'ownerId': 'ADM-1042',
                          'ownerName': 'Admin',
                          'customerPhone': phoneCtrl.text.trim().isNotEmpty
                              ? phoneCtrl.text.trim()
                              : (selectedLead?['phone'] ?? ''),
                          'isActive': true,
                          'tags': otherTags.isNotEmpty
                              ? List.from(otherTags)
                              : [finalDateType],
                          'interestTags': [],
                          'agentName': 'Admin',
                          'agentInitials': 'AD',
                          'reminderDate': DateTime.now().add(
                            const Duration(days: 1),
                          ),
                          'reminderTime': '09:00 AM',
                        };
                        Navigator.pop(context);
                        widget.onSave(dateData);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  disabledBackgroundColor: AppTheme.surface200,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Important Date',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}