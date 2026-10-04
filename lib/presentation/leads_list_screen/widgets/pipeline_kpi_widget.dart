import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../leads_list_screen.dart';

class PipelineKpiWidget extends StatelessWidget {
  final List<LeadModel> leads;
  const PipelineKpiWidget({super.key, required this.leads});

  @override
  Widget build(BuildContext context) {
    final totalLeads = leads.length;
    final newLeads = leads.where((l) => l.status == 'New').length;
    final sessions = leads.where((l) => l.status == 'Sessions').length;
    final results = leads.where((l) => l.status == 'Result').length;
    final followUpLeads = leads.where((l) => l.status == 'Follow Up').length;
    final negotiations = leads.where((l) => l.status == 'Negotiations').length;

    final kpis = [
      _KpiData(
        label: 'Total Leads',
        value: '$totalLeads',
        icon: Icons.people_rounded,
        color: AppTheme.primary,
        trend: '+12%',
        trendUp: true,
      ),
      _KpiData(
        label: 'New Leads',
        value: '$newLeads',
        icon: Icons.fiber_new_rounded,
        color: AppTheme.secondary,
        trend: '+5%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Sessions',
        value: '$sessions',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF8B5CF6),
        trend: '+8%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Results',
        value: '$results',
        icon: Icons.emoji_events_rounded,
        color: AppTheme.success,
        trend: '+3%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Follow Up',
        value: '$followUpLeads',
        icon: Icons.repeat_rounded,
        color: AppTheme.warning,
        trend: '-$followUpLeads',
        trendUp: false,
      ),
      _KpiData(
        label: 'Negotiations',
        value: '$negotiations',
        icon: Icons.handshake_rounded,
        color: const Color(0xFF0891B2),
        trend: '+$negotiations',
        trendUp: true,
      ),
    ];

    return SizedBox(
      height: 130,
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
