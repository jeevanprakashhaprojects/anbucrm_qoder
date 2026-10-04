import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Monthly';

  static const _periods = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: AppTheme.textPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Text(
          'Analytics',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          // Period selector
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                isDense: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
                icon: const Icon(
                  Icons.expand_more_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
                items: _periods
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPeriod = v!),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Pipeline'),
            Tab(text: 'Team'),
            Tab(text: 'Sources'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildPipelineTab(),
            _buildTeamTab(),
            _buildSourcesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Total Revenue',
                  value: '₹2.4Cr',
                  change: '+18%',
                  up: true,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Deals Closed',
                  value: '24',
                  change: '+6',
                  up: true,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Conversion Rate',
                  value: '32%',
                  change: '+4%',
                  up: true,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Avg Deal Size',
                  value: '₹10L',
                  change: '-2%',
                  up: false,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Revenue chart
          _SectionHeader(title: 'Revenue Trend', subtitle: _selectedPeriod),
          const SizedBox(height: 12),
          _RevenueChart(),
          const SizedBox(height: 24),
          // Conversion funnel
          _SectionHeader(title: 'Conversion Funnel', subtitle: 'Lead to Close'),
          const SizedBox(height: 12),
          _ConversionFunnel(),
          const SizedBox(height: 24),
          // Lead aging
          _SectionHeader(title: 'Lead Aging', subtitle: 'Days in stage'),
          const SizedBox(height: 12),
          _LeadAgingWidget(),
        ],
      ),
    );
  }

  Widget _buildPipelineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Pipeline by Stage',
            subtitle: 'Value distribution',
          ),
          const SizedBox(height: 12),
          _PipelineBarChart(),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Win/Loss Analysis', subtitle: 'Last 6 months'),
          const SizedBox(height: 12),
          _WinLossChart(),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Stage Conversion Rates',
            subtitle: 'Step-by-step',
          ),
          const SizedBox(height: 12),
          _StageConversionList(),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Team Leaderboard',
            subtitle: 'By deals closed',
          ),
          const SizedBox(height: 12),
          _TeamLeaderboard(),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Activity Heatmap',
            subtitle: 'Follow-up compliance',
          ),
          const SizedBox(height: 12),
          _ActivityHeatmap(),
        ],
      ),
    );
  }

  Widget _buildSourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Lead Sources', subtitle: 'Distribution'),
          const SizedBox(height: 12),
          _SourcePieChart(),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Source Performance',
            subtitle: 'Conversion by source',
          ),
          const SizedBox(height: 12),
          _SourcePerformanceList(),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool up;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.change,
    required this.up,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.trending_up_rounded, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 12,
                color: up ? AppTheme.success : AppTheme.error,
              ),
              const SizedBox(width: 2),
              Text(
                change,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: up ? AppTheme.success : AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Revenue Chart ────────────────────────────────────────────────────────────

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  @override
  Widget build(BuildContext context) {
    final spots = [
      FlSpot(0, 18),
      FlSpot(1, 24),
      FlSpot(2, 20),
      FlSpot(3, 32),
      FlSpot(4, 28),
      FlSpot(5, 38),
      FlSpot(6, 42),
    ];
    final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) =>
                FlLine(color: AppTheme.surface200, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, meta) => Text(
                  '₹${v.toInt()}L',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= months.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    months[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      color: AppTheme.textMuted,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primary.withAlpha(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Conversion Funnel ────────────────────────────────────────────────────────

class _ConversionFunnel extends StatelessWidget {
  const _ConversionFunnel();

  @override
  Widget build(BuildContext context) {
    final stages = [
      {
        'label': 'Total Leads',
        'count': 100,
        'pct': 1.0,
        'color': AppTheme.primary,
      },
      {
        'label': 'Contacted',
        'count': 72,
        'pct': 0.72,
        'color': AppTheme.secondary,
      },
      {
        'label': 'Qualified',
        'count': 45,
        'pct': 0.45,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'label': 'Proposal',
        'count': 28,
        'pct': 0.28,
        'color': AppTheme.warning,
      },
      {
        'label': 'Negotiation',
        'count': 15,
        'pct': 0.15,
        'color': const Color(0xFFF97316),
      },
      {'label': 'Won', 'count': 8, 'pct': 0.08, 'color': AppTheme.success},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: stages.map((s) {
          final pct = s['pct'] as double;
          final color = s['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    s['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppTheme.surface100,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${s['count']}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Lead Aging ───────────────────────────────────────────────────────────────

class _LeadAgingWidget extends StatelessWidget {
  const _LeadAgingWidget();

  @override
  Widget build(BuildContext context) {
    final data = [
      {'stage': 'New', 'days': 2, 'color': AppTheme.primary},
      {'stage': 'Contacted', 'days': 5, 'color': AppTheme.secondary},
      {'stage': 'Qualified', 'days': 8, 'color': const Color(0xFF8B5CF6)},
      {'stage': 'Proposal', 'days': 12, 'color': AppTheme.warning},
      {'stage': 'Negotiation', 'days': 18, 'color': const Color(0xFFF97316)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: data.map((d) {
          final days = d['days'] as int;
          final color = d['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    d['stage'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: days / 20,
                      backgroundColor: AppTheme.surface100,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$days days',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Pipeline Bar Chart ───────────────────────────────────────────────────────

class _PipelineBarChart extends StatelessWidget {
  const _PipelineBarChart();

  @override
  Widget build(BuildContext context) {
    final data = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 12,
            color: AppTheme.primary,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 8,
            color: AppTheme.secondary,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 15,
            color: const Color(0xFF8B5CF6),
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 6,
            color: AppTheme.warning,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 4,
            color: const Color(0xFFF97316),
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: 9,
            color: AppTheme.success,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    ];
    final labels = [
      'New',
      'Contacted',
      'Qualified',
      'Proposal',
      'Negot.',
      'Won',
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          barGroups: data,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) =>
                FlLine(color: AppTheme.surface200, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      labels[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (v, meta) => Text(
                  '${v.toInt()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Win/Loss Chart ───────────────────────────────────────────────────────────

class _WinLossChart extends StatelessWidget {
  const _WinLossChart();

  @override
  Widget build(BuildContext context) {
    final winSpots = [
      FlSpot(0, 4),
      FlSpot(1, 6),
      FlSpot(2, 5),
      FlSpot(3, 8),
      FlSpot(4, 7),
      FlSpot(5, 9),
    ];
    final lossSpots = [
      FlSpot(0, 3),
      FlSpot(1, 2),
      FlSpot(2, 4),
      FlSpot(3, 3),
      FlSpot(4, 2),
      FlSpot(5, 1),
    ];
    final months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              _LegendDot(color: AppTheme.success, label: 'Won'),
              const SizedBox(width: 16),
              _LegendDot(color: AppTheme.error, label: 'Lost'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: AppTheme.surface200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        final i = v.toInt();
                        if (i < 0 || i >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          months[i],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            color: AppTheme.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (v, meta) => Text(
                        '${v.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: winSpots,
                    isCurved: true,
                    color: AppTheme.success,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: lossSpots,
                    isCurved: true,
                    color: AppTheme.error,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Stage Conversion List ────────────────────────────────────────────────────

class _StageConversionList extends StatelessWidget {
  const _StageConversionList();

  @override
  Widget build(BuildContext context) {
    final stages = [
      {'from': 'New → Contacted', 'rate': '72%', 'color': AppTheme.secondary},
      {
        'from': 'Contacted → Qualified',
        'rate': '62%',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'from': 'Qualified → Proposal',
        'rate': '62%',
        'color': AppTheme.warning,
      },
      {
        'from': 'Proposal → Negotiation',
        'rate': '54%',
        'color': const Color(0xFFF97316),
      },
      {'from': 'Negotiation → Won', 'rate': '53%', 'color': AppTheme.success},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: stages.map((s) {
          final color = s['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    s['from'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    s['rate'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Team Leaderboard ─────────────────────────────────────────────────────────

class _TeamLeaderboard extends StatelessWidget {
  const _TeamLeaderboard();

  @override
  Widget build(BuildContext context) {
    final members = [
      {
        'name': 'Ananya Patel',
        'role': 'Manager',
        'deals': 12,
        'revenue': '₹48L',
        'initials': 'AP',
        'rank': 1,
      },
      {
        'name': 'Rahul Singh',
        'role': 'Senior Rep',
        'deals': 9,
        'revenue': '₹36L',
        'initials': 'RS',
        'rank': 2,
      },
      {
        'name': 'Kavya Menon',
        'role': 'Sales Rep',
        'deals': 7,
        'revenue': '₹28L',
        'initials': 'KM',
        'rank': 3,
      },
      {
        'name': 'Arjun Das',
        'role': 'Sales Rep',
        'deals': 5,
        'revenue': '₹20L',
        'initials': 'AD',
        'rank': 4,
      },
      {
        'name': 'Vikram Nair',
        'role': 'Contractor',
        'deals': 3,
        'revenue': '₹12L',
        'initials': 'VN',
        'rank': 5,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: members.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          final rank = m['rank'] as int;
          final rankColor = rank == 1
              ? const Color(0xFFD97706)
              : rank == 2
              ? AppTheme.textSecondary
              : const Color(0xFFB45309);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: i < members.length - 1
                  ? Border(bottom: BorderSide(color: AppTheme.surface200))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: rank <= 3
                        ? rankColor.withAlpha(30)
                        : AppTheme.surface100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rank <= 3 ? rankColor : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(
                    m['initials'] as String,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        m['role'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      m['revenue'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      '${m['deals']} deals',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Activity Heatmap ─────────────────────────────────────────────────────────

class _ActivityHeatmap extends StatelessWidget {
  const _ActivityHeatmap();

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [0.8, 0.6, 0.9, 0.7, 0.5, 0.3, 0.1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(days.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    days[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: values[i],
                      backgroundColor: AppTheme.surface100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primary.withAlpha((values[i] * 255).toInt()),
                      ),
                      minHeight: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(values[i] * 100).toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Source Pie Chart ─────────────────────────────────────────────────────────

class _SourcePieChart extends StatelessWidget {
  const _SourcePieChart();

  @override
  Widget build(BuildContext context) {
    final sources = [
      {'label': 'Referral', 'pct': 0.32, 'color': AppTheme.primary},
      {'label': 'Website', 'pct': 0.24, 'color': AppTheme.secondary},
      {'label': 'Cold Call', 'pct': 0.18, 'color': const Color(0xFF8B5CF6)},
      {'label': 'LinkedIn', 'pct': 0.14, 'color': AppTheme.warning},
      {'label': 'Others', 'pct': 0.12, 'color': AppTheme.textMuted},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: PieChart(
              PieChartData(
                sections: sources.map((s) {
                  final color = s['color'] as Color;
                  final pct = s['pct'] as double;
                  return PieChartSectionData(
                    color: color,
                    value: pct * 100,
                    title: '${(pct * 100).toInt()}%',
                    radius: 60,
                    titleStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sources.map((s) {
                final color = s['color'] as Color;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '${((s['pct'] as double) * 100).toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Source Performance List ──────────────────────────────────────────────────

class _SourcePerformanceList extends StatelessWidget {
  const _SourcePerformanceList();

  @override
  Widget build(BuildContext context) {
    final sources = [
      {
        'source': 'Referral',
        'leads': 32,
        'converted': 14,
        'rate': '44%',
        'color': AppTheme.primary,
      },
      {
        'source': 'Website',
        'leads': 24,
        'converted': 8,
        'rate': '33%',
        'color': AppTheme.secondary,
      },
      {
        'source': 'Cold Call',
        'leads': 18,
        'converted': 4,
        'rate': '22%',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'source': 'LinkedIn',
        'leads': 14,
        'converted': 5,
        'rate': '36%',
        'color': AppTheme.warning,
      },
      {
        'source': 'Trade Show',
        'leads': 8,
        'converted': 3,
        'rate': '38%',
        'color': AppTheme.success,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: sources.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final color = s['color'] as Color;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: i < sources.length - 1
                  ? Border(bottom: BorderSide(color: AppTheme.surface200))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s['source'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${s['leads']} leads',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    s['rate'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
