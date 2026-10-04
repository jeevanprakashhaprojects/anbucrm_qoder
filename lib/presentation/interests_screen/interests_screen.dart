import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';

// Shared global interests list — starts empty
final List<Map<String, dynamic>> globalInterests = [
  {
    'id': 'int-default-1',
    'customerName': 'Rahul Mehta',
    'phone': '+91 98765 43210',
    'email': 'rahul.mehta@techcorp.in',
    'category': 'New Inquiry',
    'status': 'New',
    'priority': 'High',
    'estimatedValue': 320000.0,
    'assignedEmployee': 'Priya Sharma',
    'assignedInitials': 'PS',
    'notes': 'Interested in enterprise plan',
    'createdAt': '2 days ago',
  },
  {
    'id': 'int-default-2',
    'customerName': 'Sneha Kapoor',
    'phone': '+91 87654 32109',
    'email': 'sneha.k@financeplus.com',
    'category': 'Renewal Interest',
    'status': 'In Progress',
    'priority': 'Medium',
    'estimatedValue': 150000.0,
    'assignedEmployee': 'Amit Kumar',
    'assignedInitials': 'AK',
    'notes': 'Policy renewal due next month',
    'createdAt': '1 week ago',
  },
  {
    'id': 'int-default-3',
    'customerName': 'Vikram Singh',
    'phone': '+91 76543 21098',
    'email': 'vikram@healthbridge.org',
    'category': 'Upgrade Interest',
    'status': 'Quoted',
    'priority': 'High',
    'estimatedValue': 480000.0,
    'assignedEmployee': 'Priya Sharma',
    'assignedInitials': 'PS',
    'notes': 'Looking to upgrade existing plan',
    'createdAt': '3 days ago',
  },
  {
    'id': 'int-default-4',
    'customerName': 'Anita Desai',
    'phone': '+91 65432 10987',
    'email': 'anita.desai@retailhub.in',
    'category': 'Add-on Interest',
    'status': 'Won',
    'priority': 'Low',
    'estimatedValue': 75000.0,
    'assignedEmployee': 'Ravi Verma',
    'assignedInitials': 'RV',
    'notes': 'Add-on coverage for family',
    'createdAt': 'Yesterday',
  },
  {
    'id': 'int-default-5',
    'customerName': 'Karan Joshi',
    'phone': '+91 54321 09876',
    'email': 'karan.j@edutech.co',
    'category': 'Cross-sell Interest',
    'status': 'New',
    'priority': 'Medium',
    'estimatedValue': 120000.0,
    'assignedEmployee': 'Amit Kumar',
    'assignedInitials': 'AK',
    'notes': 'Interested in additional products',
    'createdAt': '5 days ago',
  },
];

enum _InterestSortOption {
  dateNewest,
  dateOldest,
  nameAZ,
  nameZA,
  valueHigh,
  valueLow,
  priorityHigh,
}

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isSearchActive = false;
  _InterestSortOption _sortOption = _InterestSortOption.dateNewest;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _interests = [];

  static const _statusFilters = [
    'All',
    'New',
    'In Progress',
    'Quoted',
    'Won',
    'Lost',
  ];

  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _interests = List<Map<String, dynamic>>.from(globalInterests);
        _isLoading = false;
      });
    }
    return;
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _interests = List<Map<String, dynamic>>.from(globalInterests);
        _isLoading = false;
      });
    }
    return;
  }

  void _removeInterest(String id) {
    setState(() {
      _interests.removeWhere((i) => i['id'] == id);
      globalInterests.removeWhere((i) => i['id'] == id);
    });
  }

  List<Map<String, dynamic>> get _filtered {
    List<Map<String, dynamic>> result = _interests.where((i) {
      final matchFilter =
          _selectedFilter == 'All' || i['status'] == _selectedFilter;
      final matchSearch =
          _searchQuery.isEmpty ||
          (i['customerName'] as String? ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (i['phone'] as String? ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (i['category'] as String? ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchFilter && matchSearch;
    }).toList();

    switch (_sortOption) {
      case _InterestSortOption.nameAZ:
        result.sort(
          (a, b) => (a['customerName'] as String? ?? '').compareTo(
            b['customerName'] as String? ?? '',
          ),
        );
        break;
      case _InterestSortOption.nameZA:
        result.sort(
          (a, b) => (b['customerName'] as String? ?? '').compareTo(
            a['customerName'] as String? ?? '',
          ),
        );
        break;
      case _InterestSortOption.valueHigh:
        result.sort(
          (a, b) => ((b['estimatedValue'] as num?) ?? 0).compareTo(
            (a['estimatedValue'] as num?) ?? 0,
          ),
        );
        break;
      case _InterestSortOption.valueLow:
        result.sort(
          (a, b) => ((a['estimatedValue'] as num?) ?? 0).compareTo(
            (b['estimatedValue'] as num?) ?? 0,
          ),
        );
        break;
      case _InterestSortOption.priorityHigh:
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        result.sort(
          (a, b) => (order[a['priority'] as String? ?? 'Medium'] ?? 1)
              .compareTo(order[b['priority'] as String? ?? 'Medium'] ?? 1),
        );
        break;
      case _InterestSortOption.dateOldest:
        result = result.reversed.toList();
        break;
      case _InterestSortOption.dateNewest:
        break;
    }
    return result;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'New':
        return AppTheme.statusNew;
      case 'In Progress':
        return AppTheme.statusContacted;
      case 'Quoted':
        return AppTheme.statusProposal;
      case 'Won':
        return AppTheme.statusWon;
      case 'Lost':
        return AppTheme.statusLost;
      default:
        return AppTheme.textMuted;
    }
  }

  Color _priorityColor(String p) => AppTheme.priorityColor(p);

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'New Inquiry':
        return const Color(0xFF4F46E5);
      case 'Renewal Interest':
        return const Color(0xFF0EA5E9);
      case 'Add-on Interest':
        return const Color(0xFF10B981);
      case 'Upgrade Interest':
        return const Color(0xFFF59E0B);
      case 'Cross-sell Interest':
        return const Color(0xFF8B5CF6);
      case 'Re-engagement Interest':
        return const Color(0xFFF97316);
      default:
        return AppTheme.textMuted;
    }
  }

  String _formatValue(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  String get _sortLabel {
    switch (_sortOption) {
      case _InterestSortOption.nameAZ:
        return 'Name A-Z';
      case _InterestSortOption.nameZA:
        return 'Name Z-A';
      case _InterestSortOption.valueHigh:
        return 'Value ↓';
      case _InterestSortOption.valueLow:
        return 'Value ↑';
      case _InterestSortOption.priorityHigh:
        return 'Priority';
      case _InterestSortOption.dateNewest:
        return 'Sort';
      case _InterestSortOption.dateOldest:
        return 'Oldest';
    }
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SingleChildScrollView(
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
                    'Sort & Filter',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sort By',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...[
                    (
                      _InterestSortOption.dateNewest,
                      Icons.calendar_today_rounded,
                      'Newest First',
                    ),
                    (
                      _InterestSortOption.dateOldest,
                      Icons.calendar_today_outlined,
                      'Oldest First',
                    ),
                    (
                      _InterestSortOption.nameAZ,
                      Icons.sort_by_alpha_rounded,
                      'Name A → Z',
                    ),
                    (
                      _InterestSortOption.nameZA,
                      Icons.sort_by_alpha_rounded,
                      'Name Z → A',
                    ),
                    (
                      _InterestSortOption.valueHigh,
                      Icons.trending_up_rounded,
                      'Value: High → Low',
                    ),
                    (
                      _InterestSortOption.valueLow,
                      Icons.trending_down_rounded,
                      'Value: Low → High',
                    ),
                    (
                      _InterestSortOption.priorityHigh,
                      Icons.priority_high_rounded,
                      'Priority: High First',
                    ),
                  ].map((item) {
                    final (opt, icon, label) = item;
                    final isSelected = _sortOption == opt;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        icon,
                        size: 20,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      title: Text(
                        label,
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
                      },
                    );
                  }),
                  const SizedBox(height: 16),
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
                        'Apply',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  void _showAddInterestDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: _AddInterestSheet(
          onAdd: (interest) {
            setState(() {
              globalInterests.insert(0, interest);
              _interests = List<Map<String, dynamic>>.from(globalInterests);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
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
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  tooltip: 'Menu',
                ),
              ),
              title: _isSearchActive
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search interests, phone...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppTheme.textMuted,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    )
                  : Text(
                      'Interests',
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
                  onPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) {
                        _searchController.clear();
                        _searchQuery = '';
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryContainer,
                    child: Text(
                      'PS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // KPI Stats Row
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildKpiSkeleton()
                  : _InterestKpiWidget(interests: _interests),
            ),

            // Filter Bar (pinned)
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterBarDelegate(
                child: _InterestFilterBar(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (f) => setState(() => _selectedFilter = f),
                ),
              ),
            ),

            // Results count + sort
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(
                      _isLoading
                          ? 'Loading...'
                          : '${_filtered.length} interest${_filtered.length != 1 ? 's' : ''}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _showSortSheet,
                      icon: const Icon(Icons.sort_rounded, size: 16),
                      label: Text(_sortLabel),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            _sortOption == _InterestSortOption.dateNewest
                            ? AppTheme.textSecondary
                            : AppTheme.primary,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List content
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => const _InterestCardSkeleton(),
                  childCount: 5,
                ),
              )
            else if (_filtered.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.star_outline_rounded,
                  title: 'No interests found',
                  subtitle: _searchQuery.isNotEmpty
                      ? 'Try a different search term or clear filters'
                      : 'Start tracking customer interests by adding your first one',
                ),
              )
            else
              isTablet
                  ? SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, navBarHeight + 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _InterestCardWidget(
                            interest: _filtered[index],
                            index: index,
                            onRemove: () => _removeInterest(
                              _filtered[index]['id'] as String? ?? '',
                            ),
                          ),
                          childCount: _filtered.length,
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.only(bottom: navBarHeight + 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _InterestCardWidget(
                            interest: _filtered[index],
                            index: index,
                            onRemove: () => _removeInterest(
                              _filtered[index]['id'] as String? ?? '',
                            ),
                          ),
                          childCount: _filtered.length,
                        ),
                      ),
                    ),
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddInterestDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Interest'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      );
  }

  Widget _buildKpiSkeleton() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const LoadingSkeletonWidget(
          width: 120,
          height: 86,
          borderRadius: 16,
        ),
      ),
    );
  }
}

// ─── KPI Widget ───────────────────────────────────────────────────────────────

class _InterestKpiWidget extends StatelessWidget {
  final List<Map<String, dynamic>> interests;
  const _InterestKpiWidget({required this.interests});

  @override
  Widget build(BuildContext context) {
    final total = interests.length;
    final newCount = interests.where((i) => i['status'] == 'New').length;
    final inProgress = interests
        .where((i) => i['status'] == 'In Progress')
        .length;
    final quoted = interests.where((i) => i['status'] == 'Quoted').length;
    final won = interests.where((i) => i['status'] == 'Won').length;

    final kpis = [
      _KpiData(
        label: 'Total Interests',
        value: '$total',
        icon: Icons.star_rounded,
        color: AppTheme.primary,
        trend: '+$total',
        trendUp: true,
      ),
      _KpiData(
        label: 'New Interests',
        value: '$newCount',
        icon: Icons.fiber_new_rounded,
        color: AppTheme.secondary,
        trend: '+$newCount',
        trendUp: true,
      ),
      _KpiData(
        label: 'In Progress',
        value: '$inProgress',
        icon: Icons.timeline_rounded,
        color: const Color(0xFF8B5CF6),
        trend: '+$inProgress',
        trendUp: true,
      ),
      _KpiData(
        label: 'Quoted',
        value: '$quoted',
        icon: Icons.request_quote_rounded,
        color: AppTheme.warning,
        trend: '-$quoted',
        trendUp: false,
      ),
      _KpiData(
        label: 'Won',
        value: '$won',
        icon: Icons.emoji_events_rounded,
        color: AppTheme.success,
        trend: '+$won',
        trendUp: true,
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _KpiCard(data: kpis[i]),
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
  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
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
              fontFeatures: const [FontFeature.tabularFigures()],
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

// ─── Filter Bar ───────────────────────────────────────────────────────────────

class _InterestFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _InterestFilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const _filters = [
    'All',
    'New',
    'In Progress',
    'Quoted',
    'Won',
    'Lost',
  ];

  Color _statusColor(String f) {
    switch (f) {
      case 'New':
        return AppTheme.statusNew;
      case 'In Progress':
        return AppTheme.statusContacted;
      case 'Quoted':
        return AppTheme.statusProposal;
      case 'Won':
        return AppTheme.statusWon;
      case 'Lost':
        return AppTheme.statusLost;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final isSelected = selectedFilter == filter;
          final color = filter == 'All'
              ? AppTheme.primary
              : _statusColor(filter);

          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? color : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : AppTheme.surface200,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withAlpha(64),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                filter,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Interest Card ────────────────────────────────────────────────────────────

class _InterestCardWidget extends StatefulWidget {
  final Map<String, dynamic> interest;
  final int index;
  final VoidCallback? onRemove;

  const _InterestCardWidget({
    required this.interest,
    required this.index,
    this.onRemove,
  });

  @override
  State<_InterestCardWidget> createState() => _InterestCardWidgetState();
}

class _InterestCardWidgetState extends State<_InterestCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    Future.delayed(
      Duration(milliseconds: (widget.index * 60).clamp(0, 400)),
      () {
        if (mounted) _entranceController.forward();
      },
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'New':
        return AppTheme.statusNew;
      case 'In Progress':
        return AppTheme.statusContacted;
      case 'Quoted':
        return AppTheme.statusProposal;
      case 'Won':
        return AppTheme.statusWon;
      case 'Lost':
        return AppTheme.statusLost;
      default:
        return AppTheme.textMuted;
    }
  }

  Color _priorityColor(String p) => AppTheme.priorityColor(p);

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'New Inquiry':
        return const Color(0xFF4F46E5);
      case 'Renewal Interest':
        return const Color(0xFF0EA5E9);
      case 'Add-on Interest':
        return const Color(0xFF10B981);
      case 'Upgrade Interest':
        return const Color(0xFFF59E0B);
      case 'Cross-sell Interest':
        return const Color(0xFF8B5CF6);
      case 'Re-engagement Interest':
        return const Color(0xFFF97316);
      default:
        return AppTheme.textMuted;
    }
  }

  String _formatValue(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final interest = widget.interest;
    final status = interest['status'] as String? ?? 'New';
    final priority = interest['priority'] as String? ?? 'Medium';
    final category = interest['category'] as String? ?? 'New Inquiry';
    final statusColor = _statusColor(status);
    final priorityColor = _priorityColor(priority);
    final categoryColor = _categoryColor(category);
    final estimatedValue =
        (interest['estimatedValue'] as num?)?.toDouble() ?? 0.0;
    final customerName = interest['customerName'] as String? ?? '';
    final phone = interest['phone'] as String? ?? '';
    final assignedEmployee =
        interest['assignedEmployee'] as String? ?? 'Unassigned';
    final id = interest['id'] as String? ?? '';

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Dismissible(
          key: Key(id.isEmpty ? UniqueKey().toString() : id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.error,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Remove Interest',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      'Remove $customerName from interests?',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.error,
                        ),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ) ??
                false;
          },
          onDismissed: (_) => widget.onRemove?.call(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: priorityColor, width: 3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () =>
                  context.push(AppRoutes.interestDetailScreen, extra: interest),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Name + Status badge + 3-dot menu
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customerName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(31),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _InterestCardMenu(
                          interest: interest,
                          onRemove: widget.onRemove,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Phone number (like lead card shows phone instead of company)
                    if (phone.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              phone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 6),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    if ((interest['description'] as String? ?? '').isNotEmpty)
                      Text(
                        interest['description'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 10),
                    // Bottom row: assigned employee + value + priority
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            assignedEmployee,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (estimatedValue > 0) ...[
                          Icon(
                            Icons.currency_rupee_rounded,
                            size: 13,
                            color: AppTheme.success,
                          ),
                          Flexible(
                            child: Text(
                              _formatValue(estimatedValue),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.success,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withAlpha(31),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            priority,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: priorityColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Interest Card 3-dot Menu ─────────────────────────────────────────────────

class _InterestCardMenu extends StatelessWidget {
  final Map<String, dynamic> interest;
  final VoidCallback? onRemove;
  const _InterestCardMenu({required this.interest, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: 18, color: AppTheme.textMuted),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 16),
              const SizedBox(width: 8),
              Text(
                'View Details',
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'schedule',
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16),
              const SizedBox(width: 8),
              Text(
                'Schedule Follow-up',
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'remove',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: AppTheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Remove',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'view':
            context.push(AppRoutes.interestDetailScreen, extra: interest);
            break;
          case 'schedule':
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Schedule follow-up for ${interest['customerName']}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            break;
          case 'remove':
            onRemove?.call();
            break;
        }
      },
    );
  }
}

// ─── Card Skeleton ────────────────────────────────────────────────────────────

class _InterestCardSkeleton extends StatelessWidget {
  const _InterestCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: AppTheme.surface200, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LoadingSkeletonWidget(width: 140, height: 14, borderRadius: 7),
              const Spacer(),
              LoadingSkeletonWidget(width: 60, height: 20, borderRadius: 10),
            ],
          ),
          const SizedBox(height: 8),
          LoadingSkeletonWidget(width: 100, height: 12, borderRadius: 6),
          const SizedBox(height: 8),
          LoadingSkeletonWidget(width: 80, height: 20, borderRadius: 6),
          const SizedBox(height: 8),
          LoadingSkeletonWidget(
            width: double.infinity,
            height: 12,
            borderRadius: 6,
          ),
          const SizedBox(height: 4),
          LoadingSkeletonWidget(width: 200, height: 12, borderRadius: 6),
          const SizedBox(height: 10),
          Row(
            children: [
              LoadingSkeletonWidget(width: 100, height: 12, borderRadius: 6),
              const Spacer(),
              LoadingSkeletonWidget(width: 60, height: 12, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Filter Bar Delegate ──────────────────────────────────────────────────────

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _FilterBarDelegate({required this.child});

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppTheme.backgroundLight, child: child);
  }

  @override
  bool shouldRebuild(_FilterBarDelegate oldDelegate) =>
      child != oldDelegate.child;
}

// ─── Add Interest Sheet ───────────────────────────────────────────────────────

class _AddInterestSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  const _AddInterestSheet({required this.onAdd});

  @override
  State<_AddInterestSheet> createState() => _AddInterestSheetState();
}

class _AddInterestSheetState extends State<_AddInterestSheet> {
  bool? _isExistingCustomer;

  @override
  Widget build(BuildContext context) {
    if (_isExistingCustomer == null) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Add Interest',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Is this for an existing customer?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.person_rounded,
                    label: 'Existing Customer',
                    subtitle: 'Pre-fill from leads',
                    color: AppTheme.primary,
                    onTap: () => setState(() => _isExistingCustomer = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.person_add_rounded,
                    label: 'New Customer',
                    subtitle: 'Fresh entry',
                    color: AppTheme.secondary,
                    onTap: () => setState(() => _isExistingCustomer = false),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_isExistingCustomer == true) {
      return _ExistingCustomerInterestForm(
        onAdd: widget.onAdd,
        onBack: () => setState(() => _isExistingCustomer = null),
      );
    }

    return _NewInterestForm(
      onAdd: widget.onAdd,
      onBack: () => setState(() => _isExistingCustomer = null),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Existing Customer Form ───────────────────────────────────────────────────

class _ExistingCustomerInterestForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  final VoidCallback onBack;
  const _ExistingCustomerInterestForm({
    required this.onAdd,
    required this.onBack,
  });

  @override
  State<_ExistingCustomerInterestForm> createState() =>
      _ExistingCustomerInterestFormState();
}

class _ExistingCustomerInterestFormState
    extends State<_ExistingCustomerInterestForm> {
  String _searchQuery = '';
  Map<String, dynamic>? _selectedLead;
  String _category = 'New Inquiry';
  String _priority = 'Medium';
  final _descCtrl = TextEditingController();

  List<Map<String, dynamic>> get _filteredLeads {
    final leads = <Map<String, dynamic>>[];
    if (_searchQuery.isEmpty) return leads;
    return leads.where((l) {
      final name = (l['name'] as String? ?? '').toLowerCase();
      final phone = (l['phone'] as String? ?? '').toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          phone.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: widget.onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                'Select Existing Customer',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or phone...',
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 8),
          if (<Map<String, dynamic>>[].isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No leads found. Add leads first.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: _filteredLeads.length,
                itemBuilder: (context, i) {
                  final lead = _filteredLeads[i];
                  final isSelected = _selectedLead?['id'] == lead['id'];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primaryContainer,
                      child: Text(
                        (lead['name'] as String? ?? 'U')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      lead['name'] as String? ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      lead['phone'] as String? ?? '',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primary,
                          )
                        : null,
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () => setState(() => _selectedLead = lead),
                  );
                },
              ),
            ),
          if (_selectedLead != null) ...[
            const Divider(height: 16),
            _buildCategoryPicker(),
            _buildPriorityPicker(),
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppTheme.surface200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppTheme.surface200),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Interest',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryPicker() {
    final categories = [
      'New Inquiry',
      'Renewal Interest',
      'Add-on Interest',
      'Upgrade Interest',
      'Cross-sell Interest',
      'Re-engagement Interest',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          items: categories
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(
                    c,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPriorityPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: ['High', 'Medium', 'Low'].map((p) {
            final isSelected = _priority == p;
            final color = AppTheme.priorityColor(p);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _priority = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    p,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _submit() {
    if (_selectedLead == null) return;
    final lead = _selectedLead!;
    final now = DateTime.now();
    final interest = {
      'id': now.millisecondsSinceEpoch.toString(),
      'customerName': lead['name'] ?? '',
      'phone': lead['phone'] ?? '',
      'email': lead['email'] ?? '',
      'category': _category,
      'priority': _priority,
      'status': 'New',
      'description': _descCtrl.text.trim(),
      'assignedEmployee': lead['ownerName'] ?? 'Unassigned',
      'estimatedValue': lead['dealValue'] ?? 0.0,
      'leadId': lead['id'],
      'createdAt': now.toIso8601String(),
    };
    widget.onAdd(interest);
    Navigator.pop(context);
  }
}

// ─── New Customer Interest Form ───────────────────────────────────────────────

class _NewInterestForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  final VoidCallback onBack;
  const _NewInterestForm({required this.onAdd, required this.onBack});

  @override
  State<_NewInterestForm> createState() => _NewInterestFormState();
}

class _NewInterestFormState extends State<_NewInterestForm> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'New Inquiry';
  String _priority = 'Medium';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: widget.onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                'New Customer Interest',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField('Customer Name *', _nameCtrl),
          _buildField('Phone Number', _phoneCtrl),
          _buildCategoryPicker(),
          _buildPriorityPicker(),
          _buildField('Description', _descCtrl, maxLines: 2),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Interest',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCategoryPicker() {
    final categories = [
      'New Inquiry',
      'Renewal Interest',
      'Add-on Interest',
      'Upgrade Interest',
      'Cross-sell Interest',
      'Re-engagement Interest',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          items: categories
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(
                    c,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPriorityPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: ['High', 'Medium', 'Low'].map((p) {
            final isSelected = _priority == p;
            final color = AppTheme.priorityColor(p);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _priority = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    p,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) return;
    final now = DateTime.now();
    final interest = {
      'id': now.millisecondsSinceEpoch.toString(),
      'customerName': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'email': '',
      'category': _category,
      'priority': _priority,
      'status': 'New',
      'description': _descCtrl.text.trim(),
      'assignedEmployee': 'Unassigned',
      'estimatedValue': 0.0,
      'createdAt': now.toIso8601String(),
    };
    widget.onAdd(interest);
    Navigator.pop(context);
  }
}
