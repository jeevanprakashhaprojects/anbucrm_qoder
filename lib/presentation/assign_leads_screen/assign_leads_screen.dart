import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart' as leads_list;
import '../employees_screen/employees_screen.dart' show globalEmployeeMaps;

// ─── Global Assignment Data ───────────────────────────────────────────────────

final List<Map<String, dynamic>> globalAssignmentTasks = [
  {
    'id': 'task-001',
    'taskName': 'Contact New Leads - September Batch',
    'description':
        'Contact all new leads from September and update their status',
    'assignedBy': 'Admin',
    'assignedTo': 'Rahul Singh',
    'assignedToId': 'emp-002',
    'assignmentDate': DateTime.now().subtract(const Duration(days: 2)),
    'dueDate': DateTime.now().add(const Duration(days: 3)),
    'priority': 'High',
    'status': 'In Progress',
    'totalLeads': 20,
    'completedLeads': 8,
    'pendingLeads': 10,
    'overdueLeads': 2,
    'instructions':
        'Contact each lead and update the lead status. Focus on high-priority leads first.',
    'leads': [
      {
        'leadId': 'default-1',
        'leadName': 'Rahul Mehta',
        'phone': '+91 98765 43210',
        'status': 'Completed',
        'result': 'Interested',
        'completedAt': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'leadId': 'default-2',
        'leadName': 'Sneha Kapoor',
        'phone': '+91 87654 32109',
        'status': 'Completed',
        'result': 'Follow-up Required',
        'completedAt': DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        'leadId': 'default-3',
        'leadName': 'Vikram Singh',
        'phone': '+91 76543 21098',
        'status': 'Pending',
        'result': '',
        'completedAt': null,
      },
      {
        'leadId': 'default-4',
        'leadName': 'Anita Desai',
        'phone': '+91 65432 10987',
        'status': 'Pending',
        'result': '',
        'completedAt': null,
      },
      {
        'leadId': 'default-5',
        'leadName': 'Karan Joshi',
        'phone': '+91 54321 09876',
        'status': 'Pending',
        'result': '',
        'completedAt': null,
      },
    ],
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
  },
  {
    'id': 'task-002',
    'taskName': 'Follow-up Calls - Existing Customers',
    'description': 'Follow up with existing customers for policy renewal',
    'assignedBy': 'Admin',
    'assignedTo': 'Ananya Patel',
    'assignedToId': 'emp-003',
    'assignmentDate': DateTime.now().subtract(const Duration(days: 1)),
    'dueDate': DateTime.now().add(const Duration(days: 1)),
    'priority': 'Medium',
    'status': 'Completed',
    'totalLeads': 15,
    'completedLeads': 15,
    'pendingLeads': 0,
    'overdueLeads': 0,
    'instructions':
        'Call existing customers and check on policy renewal status.',
    'leads': [],
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
  },
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class AssignLeadsScreen extends StatefulWidget {
  const AssignLeadsScreen({super.key});

  @override
  State<AssignLeadsScreen> createState() => _AssignLeadsScreenState();
}

class _AssignLeadsScreenState extends State<AssignLeadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _leads = [];
  final Set<String> _selectedLeadIds = {};
  String _selectionMode = 'Manual'; // Manual, Random
  final _randomLeadsCtrl = TextEditingController(text: '5');
  final _randomAgentsCtrl = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeads();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _randomLeadsCtrl.dispose();
    _randomAgentsCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLeads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        // Only show UNASSIGNED leads
        final assignedLeadIds = globalAssignmentTasks
            .expand((t) => (t['leads'] as List).cast<Map<String, dynamic>>())
            .map((l) => l['leadId'] as String)
            .toSet();
        _leads = leads_list.globalLeads
            .where((l) => !assignedLeadIds.contains(l['id']))
            .toList();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredLeads {
    if (_searchQuery.isEmpty) return _leads;
    final q = _searchQuery.toLowerCase();
    return _leads.where((l) {
      final name = (l['name'] as String? ?? '').toLowerCase();
      final phone = (l['phone'] as String? ?? '').toLowerCase();
      return name.contains(q) || phone.contains(q);
    }).toList();
  }

  int get _availableLeadsCount => _leads.length;
  int get _assignedTodayCount => globalAssignmentTasks
      .where((t) {
        final d = t['assignmentDate'] as DateTime;
        final now = DateTime.now();
        return d.year == now.year && d.month == now.month && d.day == now.day;
      })
      .fold<int>(0, (sum, t) => sum + (t['totalLeads'] as int? ?? 0));
  int get _pendingTasksCount =>
      globalAssignmentTasks.where((t) => t['status'] != 'Completed').length;

  void _selectRandom() {
    final leadCount = int.tryParse(_randomLeadsCtrl.text) ?? 5;
    final agentCount = int.tryParse(_randomAgentsCtrl.text) ?? 5;
    // Validate: leads >= agents (1 lead per agent minimum)
    if (leadCount < agentCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Number of leads ($leadCount) must be >= number of agents ($agentCount)',
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    final available = _leads
        .where((l) => !_selectedLeadIds.contains(l['id']))
        .toList();
    available.shuffle();
    final toSelect = available.take(leadCount.clamp(0, available.length));
    setState(() {
      _selectedLeadIds.clear();
      _selectedLeadIds.addAll(toSelect.map((l) => l['id'] as String));
    });
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedLeadIds.length} leads selected randomly for $agentCount agents (${(_selectedLeadIds.length / agentCount).ceil()} leads/agent)',
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_isSearchActive) _buildSearchBar(),
            _buildKpiRow(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeadSelectionTab(),
                  _buildAssignmentHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedLeadIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAssignSheet,
              backgroundColor: AppTheme.primary,
              icon: const Icon(
                Icons.assignment_ind_rounded,
                color: Colors.white,
              ),
              label: Text(
                'Assign ${_selectedLeadIds.length} Leads',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
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
              color: AppTheme.primary.withAlpha(31),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment_ind_rounded,
              color: AppTheme.primary,
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
                    'Assign Leads',
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Admin Only',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w700,
                    ),
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
          hintText: 'Search leads...',
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
        'Available Leads',
        '$_availableLeadsCount',
        Icons.people_outline_rounded,
        AppTheme.primary,
      ),
      (
        'Assigned Today',
        '$_assignedTodayCount',
        Icons.assignment_turned_in_rounded,
        AppTheme.success,
      ),
      (
        'Pending Tasks',
        '$_pendingTasksCount',
        Icons.pending_actions_rounded,
        AppTheme.warning,
      ),
    ];
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final (label, count, icon, color) = kpis[i];
          return Container(
            width: 130,
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
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        count,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surfaceLight,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primary,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
        tabs: const [
          Tab(text: 'Select Leads'),
          Tab(text: 'Assignment History'),
        ],
      ),
    );
  }

  Widget _buildLeadSelectionTab() {
    final filtered = _filteredLeads;
    return Column(
      children: [
        Container(
          color: AppTheme.surfaceLight,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Selection Method',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedLeadIds.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() => _selectedLeadIds.clear()),
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ModeChip(
                    label: 'Manual',
                    selected: _selectionMode == 'Manual',
                    onTap: () => setState(() => _selectionMode = 'Manual'),
                  ),
                  const SizedBox(width: 8),
                  _ModeChip(
                    label: 'Random',
                    selected: _selectionMode == 'Random',
                    onTap: () => setState(() => _selectionMode = 'Random'),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() {
                      if (_selectedLeadIds.length == filtered.length) {
                        _selectedLeadIds.clear();
                      } else {
                        _selectedLeadIds.addAll(
                          filtered.map((l) => l['id'] as String),
                        );
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Text(
                        _selectedLeadIds.length == filtered.length
                            ? 'Deselect All'
                            : 'Select All',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectionMode == 'Random') ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withAlpha(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Random Assignment: Enter number of leads and agents. Leads will be distributed randomly (1 lead per agent minimum).',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No. of Leads',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _randomLeadsCtrl,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 10',
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No. of Agents',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _randomAgentsCtrl,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 5',
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: _selectRandom,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Generate',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedLeadIds.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.success.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: AppTheme.success,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_selectedLeadIds.length} leads selected → ${_randomAgentsCtrl.text} agents (${(_selectedLeadIds.length / (int.tryParse(_randomAgentsCtrl.text) ?? 1)).ceil()} leads/agent)',
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
                ),
              ],
              if (_selectedLeadIds.isNotEmpty &&
                  _selectionMode == 'Manual') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primary.withAlpha(40)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_selectedLeadIds.length} lead${_selectedLeadIds.length == 1 ? '' : 's'} selected',
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
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 48,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No unassigned leads',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'All leads have been assigned',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final lead = filtered[i];
                    final id = lead['id'] as String? ?? '';
                    final isSelected = _selectedLeadIds.contains(id);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (isSelected) {
                          _selectedLeadIds.remove(id);
                        } else {
                          _selectedLeadIds.add(id);
                        }
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryContainer
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.surface200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.surface200,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primary.withAlpha(30),
                              child: Text(
                                (lead['name'] as String? ?? '?')[0],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
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
                                    lead['name'] as String? ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if ((lead['phone'] as String? ?? '')
                                      .isNotEmpty)
                                    Text(
                                      lead['phone'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Show lead ID
                            Text(
                              lead['id'] as String? ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                lead['pipelineStage'] as String? ??
                                    lead['status'] as String? ??
                                    'New',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary,
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
      ],
    );
  }

  Widget _buildAssignmentHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: globalAssignmentTasks.length,
      itemBuilder: (_, i) {
        final task = globalAssignmentTasks[i];
        final total = task['totalLeads'] as int? ?? 0;
        final completed = task['completedLeads'] as int? ?? 0;
        final progress = total > 0 ? completed / total : 0.0;
        final dueDate = task['dueDate'] as DateTime;
        final isOverdue =
            dueDate.isBefore(DateTime.now()) && task['status'] != 'Completed';
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
        final dueDateStr =
            '${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverdue
                  ? AppTheme.error.withAlpha(80)
                  : AppTheme.surface200,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task['taskName'] as String? ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  _StatusBadge(
                    label: task['status'] as String? ?? '',
                    color: task['status'] == 'Completed'
                        ? AppTheme.success
                        : task['status'] == 'In Progress'
                        ? AppTheme.primary
                        : AppTheme.warning,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 13,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task['assignedTo'] as String? ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: isOverdue ? AppTheme.error : AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: $dueDateStr',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isOverdue
                          ? AppTheme.error
                          : AppTheme.textSecondary,
                      fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '$completed / $total leads',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.surface200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? AppTheme.success : AppTheme.primary,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAssignSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 8), child: _AssignLeadsSheet(
        selectedLeadIds: List.from(_selectedLeadIds),
        employees: globalEmployeeMaps
            .where((e) => !(e['isArchived'] as bool? ?? false))
            .toList(),
        onAssign: (taskData) {
          globalAssignmentTasks.insert(0, taskData);
          setState(() => _selectedLeadIds.clear());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${taskData['totalLeads']} leads assigned successfully!',
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
}

// ─── Assign Leads Sheet ───────────────────────────────────────────────────────

class _AssignLeadsSheet extends StatefulWidget {
  final List<String> selectedLeadIds;
  final List<Map<String, dynamic>> employees;
  final void Function(Map<String, dynamic>) onAssign;
  const _AssignLeadsSheet({
    required this.selectedLeadIds,
    required this.employees,
    required this.onAssign,
  });

  @override
  State<_AssignLeadsSheet> createState() => _AssignLeadsSheetState();
}

class _AssignLeadsSheetState extends State<_AssignLeadsSheet> {
  Map<String, dynamic>? _selectedEmployee;
  DateTime? _dueDate;
  String _priority = 'Normal';
  final _taskNameCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  String _empSearch = '';
  final _empSearchCtrl = TextEditingController();

  static const _priorities = ['Low', 'Normal', 'High', 'Urgent'];

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

  List<Map<String, dynamic>> get _filteredEmployees {
    final q = _empSearch.toLowerCase();
    return widget.employees.where((e) {
      final name = (e['name'] as String? ?? '').toLowerCase();
      final role = (e['role'] as String? ?? '').toLowerCase();
      final id = (e['employeeId'] as String? ?? '').toLowerCase();
      return q.isEmpty ||
          name.contains(q) ||
          role.contains(q) ||
          id.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _taskNameCtrl.dispose();
    _instructionsCtrl.dispose();
    _empSearchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Selected employee pinned at top
    final selectedEmpList = _selectedEmployee != null
        ? [_selectedEmployee!]
        : <Map<String, dynamic>>[];
    final unselectedEmps = _filteredEmployees
        .where((e) => e != _selectedEmployee)
        .toList();
    final orderedEmps = [...selectedEmpList, ...unselectedEmps];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Selected Leads',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${widget.selectedLeadIds.length} leads selected',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
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
            _buildLabel('Task Name *'),
            const SizedBox(height: 6),
            TextField(
              controller: _taskNameCtrl,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Contact New Leads - October Batch',
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
            _buildLabel('Assign To *'),
            const SizedBox(height: 6),
            // Search bar for employees (3rd image design)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedEmployee != null
                      ? AppTheme.primary
                      : AppTheme.surface200,
                  width: _selectedEmployee != null ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _empSearchCtrl,
                onChanged: (v) => setState(() => _empSearch = v),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search and select employee...',
                  prefixIcon: const Icon(
                    Icons.people_alt_rounded,
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
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surface200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: orderedEmps.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: AppTheme.surface200),
                itemBuilder: (_, i) {
                  final emp = orderedEmps[i];
                  final isSelected = _selectedEmployee == emp;
                  final color = AppTheme.primary;
                  return InkWell(
                    onTap: () => setState(
                      () => _selectedEmployee = isSelected ? null : emp,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryContainer
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: color.withAlpha(30),
                            child: Text(
                              emp['initials'] as String? ?? '?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  emp['name'] as String? ?? '',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      emp['role'] as String? ?? '',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '· ${emp['employeeId']}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: color,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildLabel('Completion Date *'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 3)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
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
                      _dueDate != null
                          ? _formatDate(_dueDate!)
                          : 'Select completion date',
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
            const SizedBox(height: 12),
            _buildLabel('Priority'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _priorities.map((p) {
                final sel = _priority == p;
                return GestureDetector(
                  onTap: () => setState(() => _priority = p),
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
                      p,
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
            const SizedBox(height: 12),
            _buildLabel('Instructions / Notes'),
            const SizedBox(height: 6),
            TextField(
              controller: _instructionsCtrl,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Add instructions for the employee...',
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selectedEmployee == null ||
                            _dueDate == null ||
                            _taskNameCtrl.text.trim().isEmpty
                        ? null
                        : () {
                            final taskData = {
                              'id':
                                  'task-${DateTime.now().millisecondsSinceEpoch}',
                              'taskName': _taskNameCtrl.text.trim(),
                              'description': _instructionsCtrl.text.trim(),
                              'assignedBy': 'Admin',
                              'assignedTo': _selectedEmployee!['name'],
                              'assignedToId': _selectedEmployee!['id'],
                              'assignmentDate': DateTime.now(),
                              'dueDate': _dueDate!,
                              'priority': _priority,
                              'status': 'Pending',
                              'totalLeads': widget.selectedLeadIds.length,
                              'completedLeads': 0,
                              'pendingLeads': widget.selectedLeadIds.length,
                              'overdueLeads': 0,
                              'instructions': _instructionsCtrl.text.trim(),
                              'leads': widget.selectedLeadIds.map((id) {
                                final lead = leads_list.globalLeads.firstWhere(
                                  (l) => l['id'] == id,
                                  orElse: () => {},
                                );
                                return {
                                  'leadId': id,
                                  'leadName': lead['name'] ?? 'Unknown',
                                  'phone': lead['phone'] ?? '',
                                  'status': 'Pending',
                                  'result': '',
                                  'completedAt': null,
                                };
                              }).toList(),
                              'createdAt': DateTime.now(),
                            };
                            Navigator.pop(context);
                            widget.onAssign(taskData);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Assign Leads',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildLabel(String text) {
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

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surfaceLight,
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
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
