import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedRange = 'Today';
  final List<String> _ranges = [
    'Today',
    'This Week',
    'This Month',
    'This Quarter',
  ];

  final List<Map<String, dynamic>> _recentActivity = [
    {
      'icon': Icons.person_add_rounded,
      'color': Color(0xFF4F46E5),
      'title': 'New lead added',
      'subtitle': 'Priya Sharma — Referral',
      'time': '2m ago',
    },
    {
      'icon': Icons.swap_horiz_rounded,
      'color': Color(0xFF0EA5E9),
      'title': 'Interest status changed',
      'subtitle': 'Arjun Mehta → In Progress',
      'time': '15m ago',
    },
    {
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF059669),
      'title': 'Follow-up completed',
      'subtitle': 'Fatima Nair — Health Insurance',
      'time': '1h ago',
    },
    {
      'icon': Icons.calendar_today_rounded,
      'color': Color(0xFFF59E0B),
      'title': 'Session scheduled',
      'subtitle': 'Mohammed Al-Rashid — Tomorrow 10 AM',
      'time': '2h ago',
    },
    {
      'icon': Icons.star_rounded,
      'color': Color(0xFF8B5CF6),
      'title': 'Lead converted',
      'subtitle': 'Sunita Reddy — ₹12L deal',
      'time': '3h ago',
    },
    {
      'icon': Icons.receipt_rounded,
      'color': Color(0xFF059669),
      'title': 'Payment received',
      'subtitle': 'Vikram Joshi — ₹8,500 premium',
      'time': '5h ago',
    },
    {
      'icon': Icons.assignment_rounded,
      'color': Color(0xFFF97316),
      'title': 'Policy issued',
      'subtitle': 'Kavya Menon — Term Life 50L',
      'time': '6h ago',
    },
  ];

  final List<Map<String, dynamic>> _upcomingToday = [
    {
      'type': 'follow_up',
      'name': 'Priya Sharma',
      'time': '10:00 AM',
      'detail': 'Health Insurance renewal',
      'overdue': false,
    },
    {
      'type': 'session',
      'name': 'Mohammed Al-Rashid',
      'time': '11:30 AM',
      'detail': 'Video call — Term plan',
      'overdue': false,
    },
    {
      'type': 'overdue',
      'name': 'Arjun Mehta',
      'time': '3 days ago',
      'detail': 'Follow-up pending',
      'overdue': true,
    },
    {
      'type': 'birthday',
      'name': 'Sunita Reddy',
      'time': 'Today',
      'detail': 'Customer birthday 🎂',
      'overdue': false,
    },
    {
      'type': 'renewal',
      'name': 'Fatima Nair',
      'time': 'In 3 days',
      'detail': 'Policy expiry — ₹45,000',
      'overdue': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(greeting),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildDateRangeSelector(),
                  const SizedBox(height: 20),
                  _buildStatCardsRow1(),
                  const SizedBox(height: 12),
                  _buildStatCardsRow2(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildLeadTrendChart(),
                  const SizedBox(height: 16),
                  _buildConversionFunnel(),
                  const SizedBox(height: 16),
                  _buildAgentPerformanceChart(),
                  const SizedBox(height: 24),
                  _buildUpcomingToday(),
                  const SizedBox(height: 24),
                  _buildRecentActivity(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(String greeting) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppTheme.surfaceLight,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppTheme.surfaceLight,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
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
                        ),
                        const SizedBox(width: 10),
                        Text(
                          greeting,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Admin',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jeevan Kumar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      "Let's crush your goals today! 🚀",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notificationsScreen),
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariantLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
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
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, Color(0xFF7C3AED)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'JK',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _ranges.map((range) {
          final isSelected = _selectedRange == range;
          return GestureDetector(
            onTap: () => setState(() => _selectedRange = range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surface200,
                ),
              ),
              child: Text(
                range,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatCardsRow1() {
    final cards = [
      {
        'label': 'Calls Today',
        'value': '24',
        'trend': '+18%',
        'up': true,
        'icon': Icons.phone_rounded,
        'color': const Color(0xFF4F46E5),
      },
      {
        'label': 'New Leads',
        'value': '7',
        'trend': '+40%',
        'up': true,
        'icon': Icons.person_add_rounded,
        'color': const Color(0xFF0EA5E9),
      },
      {
        'label': 'Follow-ups',
        'value': '12',
        'trend': '-5%',
        'up': false,
        'icon': Icons.repeat_rounded,
        'color': const Color(0xFFF59E0B),
      },
      {
        'label': 'Active Staff',
        'value': '8',
        'trend': 'All active',
        'up': true,
        'icon': Icons.group_rounded,
        'color': const Color(0xFF059669),
      },
    ];
    return Row(
      children: List.generate(cards.length, (i) {
        final c = cards[i];
        final color = c['color'] as Color;
        final isUp = c['up'] as bool;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < cards.length - 1 ? 6 : 0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withAlpha(31),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(c['icon'] as IconData, size: 14, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  c['value'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  c['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      isUp
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 10,
                      color: isUp ? AppTheme.success : AppTheme.error,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        c['trend'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: isUp ? AppTheme.success : AppTheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCardsRow2() {
    final cards = [
      {
        'label': 'Interests',
        'value': '31',
        'sub': 'This week',
        'icon': Icons.star_rounded,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'label': 'Revenue',
        'value': '₹4.2L',
        'sub': 'This month',
        'icon': Icons.currency_rupee_rounded,
        'color': const Color(0xFF059669),
      },
      {
        'label': 'Renewals',
        'value': '5',
        'sub': 'Due this week',
        'icon': Icons.autorenew_rounded,
        'color': const Color(0xFFF97316),
      },
      {
        'label': 'Pending',
        'value': '₹1.8L',
        'sub': 'Collections',
        'icon': Icons.pending_actions_rounded,
        'color': const Color(0xFFDC2626),
      },
    ];
    return Row(
      children: List.generate(cards.length, (i) {
        final c = cards[i];
        final color = c['color'] as Color;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < cards.length - 1 ? 6 : 0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withAlpha(31),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(c['icon'] as IconData, size: 14, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  c['value'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  c['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  c['sub'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    color: AppTheme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'label': 'Add Lead',
        'icon': Icons.person_add_rounded,
        'color': const Color(0xFF4F46E5),
        'route': AppRoutes.addLeadScreen,
        'push': true,
      },
      {
        'label': 'Sessions',
        'icon': Icons.event_note_rounded,
        'color': const Color(0xFF8B5CF6),
        'route': AppRoutes.sessionsScreen,
        'push': true,
      },
      {
        'label': 'Follow Ups',
        'icon': Icons.repeat_rounded,
        'color': const Color(0xFFD97706),
        'route': AppRoutes.followUpsScreen,
        'push': true,
      },
      {
        'label': 'Reminders',
        'icon': Icons.alarm_rounded,
        'color': const Color(0xFF0891B2),
        'route': AppRoutes.remindersScreen,
        'push': true,
      },
      {
        'label': 'Employees',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF059669),
        'route': AppRoutes.employeesScreen,
        'push': true,
      },
      {
        'label': 'Imp. Dates',
        'icon': Icons.cake_rounded,
        'color': const Color(0xFFEC4899),
        'route': AppRoutes.importantDatesScreen,
        'push': true,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, idx) {
              final a = actions[idx];
              final color = a['color'] as Color;
              return GestureDetector(
                onTap: () {
                  final route = a['route'] as String?;
                  if (route != null) context.push(route);
                },
                child: SizedBox(
                  width: 56,
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withAlpha(31),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withAlpha(51)),
                        ),
                        child: Icon(a['icon'] as IconData, color: color, size: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildModulesGrid(),
      ],
    );
  }

  Widget _buildModulesGrid() {
    final modules = [
      {
        'label': 'Sessions',
        'icon': Icons.event_note_rounded,
        'color': const Color(0xFF8B5CF6),
        'desc': 'Calls & meetings',
        'route': AppRoutes.sessionsScreen,
      },
      {
        'label': 'Follow Ups',
        'icon': Icons.repeat_rounded,
        'color': const Color(0xFFD97706),
        'desc': 'Pending actions',
        'route': AppRoutes.followUpsScreen,
      },
      {
        'label': 'Reminders',
        'icon': Icons.alarm_rounded,
        'color': const Color(0xFF0891B2),
        'desc': 'Alerts & deadlines',
        'route': AppRoutes.remindersScreen,
      },
      {
        'label': 'Employees',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF059669),
        'desc': 'Team & performance',
        'route': AppRoutes.employeesScreen,
      },
      {
        'label': 'Important Dates',
        'icon': Icons.cake_rounded,
        'color': const Color(0xFFEC4899),
        'desc': 'Birthdays & renewals',
        'route': AppRoutes.importantDatesScreen,
      },
      {
        'label': 'Assign Leads',
        'icon': Icons.assignment_ind_rounded,
        'color': const Color(0xFF4F46E5),
        'desc': 'Admin: assign tasks',
        'route': AppRoutes.assignLeadsScreen,
      },
      {
        'label': 'Assigned Tasks',
        'icon': Icons.task_alt_rounded,
        'color': const Color(0xFF059669),
        'desc': 'My assigned work',
        'route': AppRoutes.assignedTasksScreen,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modules',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: modules.map((m) {
            final color = m['color'] as Color;
            return GestureDetector(
              onTap: () => context.push(m['route'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
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
                        color: color.withAlpha(31),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        m['icon'] as IconData,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            m['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            m['desc'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLeadTrendChart() {
    final spots = [
      FlSpot(0, 8),
      FlSpot(1, 12),
      FlSpot(2, 7),
      FlSpot(3, 15),
      FlSpot(4, 11),
      FlSpot(5, 18),
      FlSpot(6, 14),
      FlSpot(7, 22),
      FlSpot(8, 17),
      FlSpot(9, 25),
      FlSpot(10, 20),
      FlSpot(11, 28),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lead Trend',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+28% this month',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: AppTheme.surface200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (v, m) {
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
                        final idx = v.toInt();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox();
                        }
                        return Text(
                          months[idx],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            color: AppTheme.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 2.5,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withAlpha(51),
                          AppTheme.primary.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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

  Widget _buildConversionFunnel() {
    final stages = [
      {'label': 'New', 'count': 48, 'color': const Color(0xFF6366F1)},
      {'label': 'Contacted', 'count': 35, 'color': const Color(0xFF0EA5E9)},
      {'label': 'Qualified', 'count': 22, 'color': const Color(0xFF10B981)},
      {'label': 'Quoted', 'count': 14, 'color': const Color(0xFFF59E0B)},
      {'label': 'Won', 'count': 8, 'color': const Color(0xFF059669)},
    ];
    const maxCount = 48;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Funnel',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...stages.map((s) {
            final pct = (s['count'] as int) / maxCount;
            final color = s['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      s['label'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: AppTheme.surface200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${s['count']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAgentPerformanceChart() {
    final agents = [
      {'name': 'Ananya P.', 'value': 8, 'color': const Color(0xFF4F46E5)},
      {'name': 'Rahul S.', 'value': 6, 'color': const Color(0xFF0EA5E9)},
      {'name': 'Kavya M.', 'value': 5, 'color': const Color(0xFF10B981)},
      {'name': 'Arjun D.', 'value': 3, 'color': const Color(0xFFF59E0B)},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agent Performance',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Conversions this month',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          ...agents.map((a) {
            final color = a['color'] as Color;
            final val = a['value'] as int;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      a['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: val / 10,
                        backgroundColor: AppTheme.surface200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$val',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUpcomingToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today at a Glance',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${_upcomingToday.length} items',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            children: _upcomingToday.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isOverdue = item['overdue'] as bool;
              final typeIcon = _upcomingTypeIcon(item['type'] as String);
              final typeColor = _upcomingTypeColor(item['type'] as String);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(31),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(typeIcon, size: 18, color: typeColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                item['detail'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? AppTheme.errorContainer
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item['time'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isOverdue
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < _upcomingToday.length - 1)
                    Divider(height: 1, color: AppTheme.surface200, indent: 62),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _upcomingTypeIcon(String type) {
    switch (type) {
      case 'follow_up':
        return Icons.repeat_rounded;
      case 'session':
        return Icons.video_call_rounded;
      case 'overdue':
        return Icons.warning_rounded;
      case 'birthday':
        return Icons.cake_rounded;
      case 'renewal':
        return Icons.autorenew_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _upcomingTypeColor(String type) {
    switch (type) {
      case 'follow_up':
        return AppTheme.primary;
      case 'session':
        return AppTheme.secondary;
      case 'overdue':
        return AppTheme.error;
      case 'birthday':
        return const Color(0xFF8B5CF6);
      case 'renewal':
        return AppTheme.warning;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            children: _recentActivity.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final color = item['color'] as Color;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withAlpha(31),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 18,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                item['subtitle'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['time'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < _recentActivity.length - 1)
                    Divider(height: 1, color: AppTheme.surface200, indent: 62),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
