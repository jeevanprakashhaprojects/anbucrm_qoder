import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../assign_leads_screen/assign_leads_screen.dart' show globalAssignmentTasks;
import '../leads_list_screen/leads_list_screen.dart' as leads_list;

// ─── Screen ───────────────────────────────────────────────────────────────────

class AssignedTasksScreen extends StatefulWidget {
  const AssignedTasksScreen({super.key});

  @override
  State<AssignedTasksScreen> createState() => _AssignedTasksScreenState();
}

class _AssignedTasksScreenState extends State<AssignedTasksScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _sortBy = 'Due Date';
  List<Map<String, dynamic>> _tasks = [];
  final ScrollController _scrollController = ScrollController();

  static const _statusFilters = ['All', 'Pending', 'In Progress', 'Completed', 'Overdue'];
  static const _sortOptions = ['Due Date', 'Priority', 'Progress', 'Assigned Date'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _tasks = List.from(globalAssignmentTasks);
        _isLoading = false;
      });
    }
  }

  bool _isOverdue(Map<String, dynamic> task) {
    final dueDate = task['dueDate'] as DateTime;
    return dueDate.isBefore(DateTime.now()) && task['status'] != 'Completed';
  }

  List<Map<String, dynamic>> get _filteredTasks {
    List<Map<String, dynamic>> result = _tasks.where((t) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Overdue') return _isOverdue(t);
      return t['status'] == _selectedFilter;
    }).toList();

    switch (_sortBy) {
      case 'Due Date':
        result.sort((a, b) => (a['dueDate'] as DateTime).compareTo(b['dueDate'] as DateTime));
        break;
      case 'Priority':
        const order = {'Urgent': 0, 'High': 1, 'Normal': 2, 'Low': 3};
        result.sort((a, b) => (order[a['priority']] ?? 2).compareTo(order[b['priority']] ?? 2));
        break;
      case 'Progress':
        result.sort((a, b) {
          final aP = (a['totalLeads'] as int) > 0 ? (a['completedLeads'] as int) / (a['totalLeads'] as int) : 0.0;
          final bP = (b['totalLeads'] as int) > 0 ? (b['completedLeads'] as int) / (b['totalLeads'] as int) : 0.0;
          return bP.compareTo(aP);
        });
        break;
      case 'Assigned Date':
        result.sort((a, b) => (b['assignmentDate'] as DateTime).compareTo(a['assignmentDate'] as DateTime));
        break;
    }
    return result;
  }

  int get _totalCount => _tasks.length;
  int get _pendingCount => _tasks.where((t) => t['status'] == 'Pending').length;
  int get _inProgressCount => _tasks.where((t) => t['status'] == 'In Progress').length;
  int get _completedCount => _tasks.where((t) => t['status'] == 'Completed').length;
  int get _overdueCount => _tasks.where(_isOverdue).length;

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
          decoration: const BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.surface200, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Sort Tasks', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._sortOptions.map((o) {
              final sel = _sortBy == o;
              return ListTile(
                leading: Icon(
                  o == 'Due Date' ? Icons.event_rounded : o == 'Priority' ? Icons.flag_rounded : o == 'Progress' ? Icons.trending_up_rounded : Icons.calendar_today_rounded,
                  color: sel ? AppTheme.success : AppTheme.textSecondary, size: 20,
                ),
                title: Text(o, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? AppTheme.success : AppTheme.textPrimary)),
                trailing: sel ? const Icon(Icons.check_rounded, color: AppTheme.success, size: 18) : null,
                onTap: () { setState(() => _sortBy = o); Navigator.pop(context); },
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: RefreshIndicator(
          onRefresh: _loadTasks,
          child: _isLoading
              ? CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                  _buildSliverAppBar(filtered),
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(filtered),
                  SliverToBoxAdapter(child: _buildKpiRow()),
                  SliverToBoxAdapter(child: _buildStatusFilterBar()),
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      child: _buildEmpty(),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, navBarHeight + 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _TaskCard(
                            task: filtered[i],
                            onUpdate: () => setState(() { _tasks = List.from(globalAssignmentTasks); }),
                          ),
                          childCount: filtered.length,
                        ),
                      ),
                    ),
                ],
              ),
      ),
      ),
    );
  }

  Widget _buildSliverAppBar(List<Map<String, dynamic>> filtered) {
    return SliverAppBar(
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
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppTheme.success.withAlpha(31), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.task_alt_rounded, color: AppTheme.success, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('Assigned Tasks', maxLines: 1, style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
                Text('${filtered.length}/$_totalCount tasks', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: _showSortSheet,
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.surface100, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.surface200)),
            child: const Icon(Icons.sort_rounded, size: 16, color: AppTheme.textSecondary),
          ),
        ),
      ],
    );
  }

  // KPI row matching follow-ups 2nd image: icon box top-left, trend label top-right, big number, label
  Widget _buildKpiRow() {
    final kpis = [
      ('Total', '$_totalCount', Icons.task_alt_rounded, AppTheme.primary, '+5%', true),
      ('Pending', '$_pendingCount', Icons.pending_actions_rounded, AppTheme.warning, '$_pendingCount pending', false),
      ('In Progress', '$_inProgressCount', Icons.autorenew_rounded, AppTheme.primary, '$_inProgressCount active', false),
      ('Completed', '$_completedCount', Icons.check_circle_rounded, AppTheme.success, '+done', true),
      ('Overdue', '$_overdueCount', Icons.warning_rounded, AppTheme.error, '$_overdueCount urgent', false),
    ];
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final (label, count, icon, color, trend, trendUp) = kpis[i];
          final isSelected = _selectedFilter == label;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter == label ? _selectedFilter = 'All' : _selectedFilter = label),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(20) : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? color : Colors.transparent, width: isSelected ? 1.5 : 1),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2))],
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
                      Row(
                        children: [
                          Icon(
                            trendUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            size: 11,
                            color: trendUp ? AppTheme.success : AppTheme.warning,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              trend,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: trendUp ? AppTheme.success : AppTheme.warning,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(count, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Status filter bar — oval chips matching follow-ups design with count
  Widget _buildStatusFilterBar() {
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
              count = _tasks.length;
              break;
            case 'Pending':
              count = _pendingCount;
              break;
            case 'In Progress':
              count = _inProgressCount;
              break;
            case 'Completed':
              count = _completedCount;
              break;
            case 'Overdue':
              count = _overdueCount;
              break;
          }
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.success : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? AppTheme.success : AppTheme.surface200),
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text('No assigned tasks', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text('Tasks assigned to you will appear here', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

// ─── Task Card ────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onUpdate;
  const _TaskCard({required this.task, required this.onUpdate});

  bool get _isOverdue {
    final dueDate = task['dueDate'] as DateTime;
    return dueDate.isBefore(DateTime.now()) && task['status'] != 'Completed';
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Completed': return AppTheme.success;
      case 'In Progress': return AppTheme.primary;
      case 'Pending': return AppTheme.warning;
      case 'Overdue': return AppTheme.error;
      default: return AppTheme.textMuted;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'Urgent': return AppTheme.error;
      case 'High': return AppTheme.warning;
      case 'Normal': return AppTheme.primary;
      default: return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = task['totalLeads'] as int? ?? 0;
    final completed = task['completedLeads'] as int? ?? 0;
    final pending = task['pendingLeads'] as int? ?? 0;
    final overdue = task['overdueLeads'] as int? ?? 0;
    final progress = total > 0 ? completed / total : 0.0;
    final dueDate = task['dueDate'] as DateTime;
    final assignedDate = task['assignmentDate'] as DateTime;
    final status = _isOverdue ? 'Overdue' : task['status'] as String? ?? '';
    final statusColor = _statusColor(status);
    final priority = task['priority'] as String? ?? 'Normal';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOverdue ? AppTheme.error.withAlpha(80) : AppTheme.surface200,
          width: _isOverdue ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          if (_isOverdue)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(20),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Row(children: [
                Icon(Icons.warning_rounded, size: 13, color: AppTheme.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('OVERDUE — Due ${_formatDate(dueDate)}', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.error), overflow: TextOverflow.ellipsis, maxLines: 2),
                ),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(task['taskName'] as String? ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: _priorityColor(priority).withAlpha(20), borderRadius: BorderRadius.circular(6)),
                      child: Text(priority, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: _priorityColor(priority))),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withAlpha(20), borderRadius: BorderRadius.circular(8), border: Border.all(color: statusColor.withAlpha(60))),
                      child: Text(status, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                  ],
                ),
                if ((task['instructions'] as String? ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppTheme.primary.withAlpha(10), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.primary.withAlpha(30))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded, size: 13, color: AppTheme.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            task['instructions'] as String,
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_rounded, size: 13, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text('By: ${task['assignedBy']}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.calendar_today_rounded, size: 13, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(_formatDate(assignedDate), style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.event_rounded, size: 13, color: _isOverdue ? AppTheme.error : AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text('Due: ${_formatDate(dueDate)}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _isOverdue ? AppTheme.error : AppTheme.textSecondary, fontWeight: _isOverdue ? FontWeight.w600 : FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('$completed / $total leads', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const Spacer(),
                    Text('${(progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: progress >= 1.0 ? AppTheme.success : AppTheme.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.surface200,
                    valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? AppTheme.success : AppTheme.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                // Stat chips — same design as 4th image follow-ups
                Row(
                  children: [
                    _StatChip(label: 'Completed', count: completed, color: AppTheme.success),
                    const SizedBox(width: 6),
                    _StatChip(label: 'Pending', count: pending, color: AppTheme.warning),
                    if (overdue > 0) ...[
                      const SizedBox(width: 6),
                      _StatChip(label: 'Overdue', count: overdue, color: AppTheme.error),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openTaskDetails(context),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
                    label: Text(
                      progress >= 1.0 ? 'View Completed Task' : 'Continue Task',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: progress >= 1.0 ? AppTheme.success : AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openTaskDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _TaskDetailScreen(task: task, onUpdate: onUpdate)),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text('$label: $count', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ─── Task Detail Screen ───────────────────────────────────────────────────────

class _TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final VoidCallback onUpdate;
  const _TaskDetailScreen({required this.task, required this.onUpdate});

  @override
  State<_TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<_TaskDetailScreen> {
  String _leadFilter = 'All'; // All, Open, Completed

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final total = task['totalLeads'] as int? ?? 0;
    final completed = task['completedLeads'] as int? ?? 0;
    final progress = total > 0 ? completed / total : 0.0;
    final leads = (task['leads'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final dueDate = task['dueDate'] as DateTime;
    final assignedDate = task['assignmentDate'] as DateTime;
    final instructions = task['instructions'] as String? ?? '';

    final openLeads = leads.where((l) => l['status'] != 'Completed').toList();
    final completedLeads = leads.where((l) => l['status'] == 'Completed').toList();
    final displayLeads = _leadFilter == 'Open' ? openLeads : _leadFilter == 'Completed' ? completedLeads : leads;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Task Details', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Instructions prominently at top
          if (instructions.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.notes_rounded, size: 16, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Text('Instructions / Notes', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  ]),
                  const SizedBox(height: 8),
                  Text(instructions, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Task info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['taskName'] as String? ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if ((task['description'] as String? ?? '').isNotEmpty)
                  Text(task['description'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.person_rounded, label: 'Assigned by', value: task['assignedBy'] as String? ?? ''),
                _InfoRow(icon: Icons.person_outline_rounded, label: 'Assigned to', value: task['assignedTo'] as String? ?? ''),
                _InfoRow(icon: Icons.calendar_today_rounded, label: 'Assigned', value: _formatDate(assignedDate)),
                _InfoRow(icon: Icons.event_rounded, label: 'Due Date', value: _formatDate(dueDate)),
                _InfoRow(icon: Icons.flag_rounded, label: 'Priority', value: task['priority'] as String? ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Progress card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('$completed / $total leads', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text('${(progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: progress >= 1.0 ? AppTheme.success : AppTheme.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.surface200,
                    valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? AppTheme.success : AppTheme.primary),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatChip(label: 'Completed', count: completedLeads.length, color: AppTheme.success),
                    const SizedBox(width: 8),
                    _StatChip(label: 'Open', count: openLeads.length, color: AppTheme.warning),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Leads list with filter
          Row(
            children: [
              Text('Leads (${leads.length})', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              // Lead filter chips
              ...[('All', leads.length), ('Open', openLeads.length), ('Completed', completedLeads.length)].map((f) {
                final sel = _leadFilter == f.$1;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _leadFilter = f.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sel ? AppTheme.primary : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: sel ? AppTheme.primary : AppTheme.surface200),
                      ),
                      child: Text('${f.$1} (${f.$2})', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: sel ? Colors.white : AppTheme.textSecondary, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          ...displayLeads.map((lead) {
            final leadStatus = lead['status'] as String? ?? 'Pending';
            final isCompleted = leadStatus == 'Completed';
            final result = lead['result'] as String? ?? '';
            final completedAt = lead['completedAt'] as DateTime?;
            final phone = lead['phone'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isCompleted ? AppTheme.success.withAlpha(60) : AppTheme.surface200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppTheme.success.withAlpha(25) : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: isCompleted ? AppTheme.success : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead['leadName'] as String? ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                        if (phone.isNotEmpty)
                          Text(phone, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
                        if (isCompleted && result.isNotEmpty)
                          Text(result, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.success)),
                        if (isCompleted && completedAt != null)
                          Text(_formatDate(completedAt), style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                  if (!isCompleted) ...[
                    // View Lead button
                    GestureDetector(
                      onTap: () {
                        final leadId = lead['leadId'] as String? ?? '';
                        final leadMap = leads_list.globalLeads.firstWhere(
                          (m) => m['id'] == leadId,
                          orElse: () => {},
                        );
                        if (leadMap.isNotEmpty) {
                          context.push(AppRoutes.leadDetailScreen, extra: leads_list.LeadModel.fromMap(leadMap));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primary.withAlpha(40)),
                        ),
                        child: Text('View Lead', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _showCompleteLeadSheet(context, lead),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.success.withAlpha(40)),
                        ),
                        child: Text('Complete', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ] else ...[
                    // Completed lead: View Lead button
                    GestureDetector(
                      onTap: () {
                        final leadId = lead['leadId'] as String? ?? '';
                        final leadMap = leads_list.globalLeads.firstWhere(
                          (m) => m['id'] == leadId,
                          orElse: () => {},
                        );
                        if (leadMap.isNotEmpty) {
                          context.push(AppRoutes.leadDetailScreen, extra: leads_list.LeadModel.fromMap(leadMap));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('View Lead', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showCompleteLeadSheet(BuildContext context, Map<String, dynamic> lead) {
    String result = 'Contacted';
    final notesCtrl = TextEditingController();
    const results = ['Contacted', 'Interested', 'Follow-up Required', 'Appointment Booked', 'Not Interested', 'Wrong Number', 'Converted'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setModalState) => Container(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
            ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.surface200, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text('Complete Assigned Lead', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(lead['leadName'] as String? ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Text('Result *', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 6,
                  children: results.map((r) {
                    final sel = result == r;
                    return GestureDetector(
                      onTap: () => setModalState(() => result = r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? AppTheme.success : AppTheme.surface100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? AppTheme.success : AppTheme.surface200),
                        ),
                        child: Text(r, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: sel ? Colors.white : AppTheme.textSecondary, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text('Notes', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 6),
                TextField(
                  controller: notesCtrl,
                  maxLines: 3,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Add notes...',
                    filled: true, fillColor: AppTheme.surface100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lead['status'] = 'Completed';
                        lead['result'] = result;
                        lead['completedAt'] = DateTime.now();
                        final task = widget.task;
                        final leads = (task['leads'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                        final completedCount = leads.where((l) => l['status'] == 'Completed').length;
                        task['completedLeads'] = completedCount;
                        task['pendingLeads'] = leads.length - completedCount;
                        if (completedCount == leads.length) {
                          task['status'] = 'Completed';
                        } else {
                          task['status'] = 'In Progress';
                        }
                      });
                      Navigator.pop(ctx);
                      widget.onUpdate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Complete', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          Text('$label: ', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
          Expanded(child: Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
        ],
      ),
    );
  }
}