import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart';
import '../follow_ups_screen/follow_ups_screen.dart' as fu_screen;
import '../sessions_screen/sessions_screen.dart' as sessions_screen;

class LeadDetailScreen extends StatefulWidget {
  final LeadModel lead;
  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeadModel _lead;
  final List<Map<String, dynamic>> _notes = [];
  final List<Map<String, dynamic>> _voiceRecordings = [];
  final _noteController = TextEditingController();
  final _noteFocusNode = FocusNode();
  // Track selected pipeline stage for interactive selector
  String _selectedPipelineStage = '';

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _tabController = TabController(length: 3, vsync: this);
    _selectedPipelineStage = _lead.status;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Color get _priorityColor => AppTheme.priorityColor(_lead.priority);
  Color get _statusColor => AppTheme.leadStatusColor(_lead.status);

  String _formatValue(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  Map<String, dynamic> get _fullMap {
    final globalMap = globalLeadMaps.firstWhere(
      (m) => m['id'] == _lead.id,
      orElse: () => {},
    );
    return {..._lead.toMap(), ...globalMap};
  }

  String _relativeLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
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
    final dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    if (diff.inMinutes < 1) return 'Just now · $dateStr';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago · $dateStr';
    if (diff.inHours < 24) return '${diff.inHours}h ago · $dateStr';
    if (diff.inDays == 1) return 'Yesterday · $dateStr';
    if (diff.inDays < 7) return '${diff.inDays} days ago · $dateStr';
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago · $dateStr';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} months ago · $dateStr';
    }
    return '${(diff.inDays / 365).floor()} years ago · $dateStr';
  }

  // ─── New pipeline stages ───────────────────────────────────────────────────
  static const _kPipelineStages = [
    'New',
    'Contacted',
    'Engaged',
    'Qualified',
    'Proposed',
    'Follow Up',
    'Sessions',
    'Negotiations',
    'Result',
  ];

  // Show bottom sheet with all interest details when user taps an interest
  void _showInterestDetails(String interestName) {
    final map = _fullMap;
    final interestData = map['interest_$interestName'] as Map<String, dynamic>?;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 8), child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.92,
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: AppTheme.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      interestName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (interestData == null || interestData.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.textMuted,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No details filled for this interest yet.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.warning.withAlpha(40)),
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
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Interest Details',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...interestData.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  _formatKey(e.key),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.value.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
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
              ],
            ],
          ),
        ),
      )),
    );
  }

  String _formatKey(String key) {
    // Convert camelCase to readable label
    final result = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (m) => ' ${m.group(0)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Container(
              color: AppTheme.primary,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withAlpha(150),
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Timeline'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildTimelineTab(),
                  _buildNotesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildQuickActions(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withAlpha(220)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      context.go(AppRoutes.leadsListScreen);
                    }
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => _editLead(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _showMoreOptions(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withAlpha(50),
                    child: Text(
                      _lead.name.isNotEmpty ? _lead.name[0].toUpperCase() : 'L',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lead.name.isNotEmpty ? _lead.name : 'New Lead',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_lead.phone.isNotEmpty)
                          Text(
                            _lead.phone,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _HeaderBadge(label: _lead.status, color: _statusColor),
                  _HeaderBadge(label: _lead.priority, color: _priorityColor),
                ],
              ),
            ),
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
          _buildContactInfoCard(),
          _buildProfessionalDetailsCard(),
          _buildBusinessDetailsCard(),
          _buildDealInfoCard(),
          _buildAddressCard(),
          _buildSocialCard(),
          _buildInterestsCard(),
          // Interest-specific Notes
          _buildInterestNotesCard(),
          // Tags
          if (_lead.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Tags',
              icon: Icons.label_outline_rounded,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _lead.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
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
          // Relations
          _buildRelationsCard(),
          // Pipeline stage — interactive horizontal scroll
          const SizedBox(height: 16),
          _buildInteractivePipelineCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// Build interactive pipeline stage card with horizontal scroll
  Widget _buildInteractivePipelineCard() {
    const stages = [
      'New',
      'Contacted',
      'Engaged',
      'Qualified',
      'Proposed',
      'Follow Up',
      'Sessions',
      'Negotiations',
      'Result',
    ];
    final currentIndex = stages.indexOf(_selectedPipelineStage);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surface200),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Pipeline Stage',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.surface200),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bars
                  Row(
                    children: List.generate(stages.length, (i) {
                      final stage = stages[i];
                      final isPast = i < currentIndex;
                      final isCurrent = i == currentIndex;
                      final color = AppTheme.leadStatusColor(stage);
                      return Container(
                        width: 52,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isPast || isCurrent
                              ? color
                              : AppTheme.surface200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // Labels — tappable
                  Row(
                    children: List.generate(stages.length, (i) {
                      final stage = stages[i];
                      final isActive = _selectedPipelineStage == stage;
                      final isPast = i < currentIndex;
                      final color = AppTheme.leadStatusColor(stage);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPipelineStage = stage;
                            _lead = LeadModel(
                              id: _lead.id,
                              name: _lead.name,
                              phone: _lead.phone,
                              email: _lead.email,
                              company: _lead.company,
                              industry: _lead.industry,
                              status: stage,
                              priority: _lead.priority,
                              score: _lead.score,
                              dealValue: _lead.dealValue,
                              ownerInitials: _lead.ownerInitials,
                              ownerName: _lead.ownerName,
                              lastContact: _lead.lastContact,
                              tags: _lead.tags,
                              interests: _lead.interests,
                              createdAt: _lead.createdAt,
                              source: _lead.source,
                              campaign: _lead.campaign,
                              address: _lead.address,
                              city: _lead.city,
                              state: _lead.state,
                              country: _lead.country,
                              whatsapp: _lead.whatsapp,
                            );
                            // Update global map
                            final idx = globalLeadMaps.indexWhere(
                              (m) => m['id'] == _lead.id,
                            );
                            if (idx >= 0) {
                              globalLeadMaps[idx]['status'] = stage;
                            }
                          });
                        },
                        child: Container(
                          width: 56,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: isActive
                              ? BoxDecoration(
                                  color: color.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: color.withAlpha(120),
                                    width: 1.5,
                                  ),
                                )
                              : null,
                          child: Text(
                            stage,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isActive
                                  ? color
                                  : isPast
                                  ? AppTheme.textSecondary
                                  : AppTheme.textMuted,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build notes card showing only notes for each interest
  Widget _buildInterestNotesCard() {
    final map = _fullMap;
    final interests = map['interests'] as List?;
    if (interests == null || interests.isEmpty) return const SizedBox.shrink();

    // Collect interests that have notes
    final interestNotes = <Map<String, dynamic>>[];
    for (final i in interests) {
      final interestName = i.toString();
      final noteKey = 'interest_notes_$interestName';
      final note = map[noteKey] as String?;
      if (note != null && note.trim().isNotEmpty) {
        interestNotes.add({'interest': interestName, 'note': note.trim()});
      }
    }

    if (interestNotes.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Interest Notes',
          icon: Icons.sticky_note_2_outlined,
          children: interestNotes.map<Widget>((item) {
            final itemMap = item;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warning.withAlpha(10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.warning.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          itemMap['interest'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itemMap['note'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityTimelineCard() {
    final leadSessions = sessions_screen.globalSessionMaps
        .where(
          (s) => s['linkedLeadId'] == _lead.id || s['linkedLead'] == _lead.name,
        )
        .toList();
    final leadFollowUps = fu_screen.globalFollowUpMaps
        .where(
          (f) => f['linkedLeadId'] == _lead.id || f['linkedLead'] == _lead.name,
        )
        .toList();

    if (leadSessions.isEmpty && leadFollowUps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.surface200),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.timeline_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Activity Timeline',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${leadSessions.length + leadFollowUps.length} items',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppTheme.surface200),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sessions section
                    if (leadSessions.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_rounded,
                            size: 14,
                            color: Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sessions (${leadSessions.length})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...leadSessions.map((s) {
                        final status = s['status'] as String;
                        Color statusColor;
                        switch (status) {
                          case 'Completed':
                            statusColor = AppTheme.success;
                            break;
                          case 'Scheduled':
                            statusColor = AppTheme.primary;
                            break;
                          case 'In Progress':
                            statusColor = AppTheme.error;
                            break;
                          default:
                            statusColor = AppTheme.textMuted;
                        }
                        final date = s['date'] as DateTime;
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
                        final dateStr = '${date.day} ${months[date.month - 1]}';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: statusColor.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.event_note_rounded,
                                  size: 16,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${s['type']} · $dateStr · ${s['host']}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],
                    // Follow-ups section
                    if (leadFollowUps.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.repeat_rounded,
                            size: 14,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Follow-ups (${leadFollowUps.length})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...leadFollowUps.map((f) {
                        final status = f['status'] as String;
                        final isOverdue =
                            f['isOverdue'] == true || status == 'Overdue';
                        Color statusColor;
                        if (status == 'Completed') {
                          statusColor = AppTheme.success;
                        } else if (isOverdue)
                          statusColor = AppTheme.error;
                        else if (status == 'Upcoming')
                          statusColor = const Color(0xFF0891B2);
                        else
                          statusColor = AppTheme.warning;
                        final dueDate = f['dueDate'] as DateTime;
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
                        final dateStr =
                            '${dueDate.day} ${months[dueDate.month - 1]}';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: statusColor.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.repeat_rounded,
                                  size: 16,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      f['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${f['type']} · $dateStr · ${f['assignedAgent']}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isOverdue ? 'Overdue' : status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoCard() {
    final rows = <Widget>[];
    final map = _fullMap;
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    addRow('Phone', _lead.phone, Icons.phone_outlined);
    addRow('Email', _lead.email, Icons.email_outlined);
    addRow('WhatsApp', _lead.whatsapp, Icons.chat_rounded);
    addRow(
      'Alt Phone',
      map['alternatePhone'] as String?,
      Icons.phone_callback_outlined,
    );
    addRow(
      'Alt Email',
      map['secondaryEmail'] as String?,
      Icons.alternate_email_rounded,
    );
    addRow(
      'Salutation',
      map['salutation'] as String?,
      Icons.person_outline_rounded,
    );
    addRow(
      'Middle Name',
      map['middleName'] as String?,
      Icons.person_outline_rounded,
    );
    addRow(
      'Nickname',
      map['nickname'] as String?,
      Icons.person_outline_rounded,
    );
    addRow('Date of Birth', map['dob'] as String?, Icons.cake_outlined);
    addRow('Gender', map['gender'] as String?, Icons.person_outline_rounded);
    addRow(
      'Marital Status',
      map['maritalStatus'] as String?,
      Icons.favorite_outline_rounded,
    );
    addRow(
      'Anniversary',
      map['anniversaryDate'] as String?,
      Icons.celebration_outlined,
    );
    addRow(
      'Spouse Name',
      map['spouseName'] as String?,
      Icons.people_outline_rounded,
    );
    addRow(
      'Dependents',
      map['numberOfDependents'] as String?,
      Icons.family_restroom_rounded,
    );
    addRow(
      'Annual Income',
      map['annualIncome'] as String?,
      Icons.currency_rupee_rounded,
    );
    addRow(
      'Customer Type',
      map['customerType'] as String?,
      Icons.category_outlined,
    );
    addRow(
      'Language',
      map['preferredLanguage'] as String?,
      Icons.language_rounded,
    );
    addRow(
      'Best Time to Call',
      map['bestTimeToCall'] as String?,
      Icons.access_time_rounded,
    );
    addRow('Timezone', map['timezone'] as String?, Icons.schedule_rounded);
    addRow(
      'Comm. Opt-in',
      map['communicationOptIn'] as String?,
      Icons.notifications_outlined,
    );
    addRow('PAN', map['pan'] as String?, Icons.credit_card_outlined);
    addRow('Aadhaar', map['aadhaar'] as String?, Icons.badge_outlined);
    addRow('GSTIN', map['gstin'] as String?, Icons.receipt_long_outlined);
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Contact Information',
          icon: Icons.person_outline_rounded,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfessionalDetailsCard() {
    final map = _fullMap;
    final rows = <Widget>[];
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    addRow(
      'Occupation',
      map['occupation'] as String?,
      Icons.work_outline_rounded,
    );
    addRow('Degree', map['degree'] as String?, Icons.school_outlined);
    addRow(
      'Company',
      map['companyWorking'] as String?,
      Icons.corporate_fare_rounded,
    );
    addRow(
      'Salary',
      map['workingSalary'] as String?,
      Icons.currency_rupee_rounded,
    );
    addRow(
      'Years of Service',
      map['yearsOfService'] as String?,
      Icons.timeline_rounded,
    );
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Professional Details',
          icon: Icons.work_outline_rounded,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBusinessDetailsCard() {
    final rows = <Widget>[];
    final map = _fullMap;
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    if (_lead.company.isNotEmpty && _lead.company != 'New Company') {
      addRow('Company', _lead.company, Icons.corporate_fare_rounded);
    }
    if (_lead.industry.isNotEmpty && _lead.industry != 'General') {
      addRow('Industry', _lead.industry, Icons.business_outlined);
    }
    addRow('Designation', map['designation'] as String?, Icons.badge_outlined);
    addRow(
      'Department',
      map['department'] as String?,
      Icons.group_work_outlined,
    );
    addRow(
      'Company Size',
      map['companySize'] as String?,
      Icons.people_outline_rounded,
    );
    addRow(
      'Annual Revenue',
      map['annualRevenue'] as String?,
      Icons.trending_up_rounded,
    );
    addRow(
      'Employees',
      map['numberOfEmployees'] as String?,
      Icons.group_outlined,
    );
    addRow(
      'Business Type',
      map['businessType'] as String?,
      Icons.store_outlined,
    );
    addRow('Website', map['website'] as String?, Icons.language_rounded);
    addRow(
      'Company Phone',
      map['companyPhone'] as String?,
      Icons.phone_outlined,
    );
    addRow(
      'Company Email',
      map['companyEmail'] as String?,
      Icons.email_outlined,
    );
    addRow('GST No.', map['gstNumber'] as String?, Icons.receipt_long_outlined);
    addRow(
      'Company PAN',
      map['companyPan'] as String?,
      Icons.credit_card_outlined,
    );
    addRow('CIN', map['cinNumber'] as String?, Icons.numbers_rounded);
    addRow(
      'Year Est.',
      map['yearEstablished'] as String?,
      Icons.calendar_today_rounded,
    );
    addRow(
      'Business Model',
      map['businessModel'] as String?,
      Icons.account_tree_outlined,
    );
    addRow(
      'Funding Stage',
      map['fundingStage'] as String?,
      Icons.rocket_launch_outlined,
    );
    addRow(
      'Key Competitors',
      map['keyCompetitors'] as String?,
      Icons.compare_arrows_rounded,
    );
    addRow(
      'Technologies',
      map['technologiesUsed'] as String?,
      Icons.computer_rounded,
    );
    addRow(
      'Decision Maker',
      map['decisionMakerRole'] as String?,
      Icons.person_pin_outlined,
    );
    addRow(
      'Decision Level',
      map['decisionLevel'] as String?,
      Icons.stairs_rounded,
    );
    addRow(
      'Company Address',
      map['companyAddress'] as String?,
      Icons.location_on_outlined,
    );
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Business Details',
          icon: Icons.business_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDealInfoCard() {
    final rows = <Widget>[];
    final map = _fullMap;
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    addRow('Status', _lead.status, Icons.flag_outlined);
    addRow('Priority', _lead.priority, Icons.priority_high_rounded);
    addRow('Owner', _lead.ownerName, Icons.person_pin_outlined);
    addRow(
      'Source',
      _lead.source ?? map['source'] as String?,
      Icons.input_rounded,
    );
    addRow(
      'Campaign',
      _lead.campaign ?? map['campaign'] as String?,
      Icons.campaign_outlined,
    );
    addRow('UTM Source', map['utmSource'] as String?, Icons.link_rounded);
    addRow('UTM Medium', map['utmMedium'] as String?, Icons.link_rounded);
    addRow(
      'Referral',
      map['referralName'] as String?,
      Icons.people_outline_rounded,
    );
    addRow('Tier', map['tier'] as String?, Icons.star_outline_rounded);
    if (_lead.score > 0) {
      addRow('Score', '${_lead.score}', Icons.analytics_outlined);
    }
    addRow('Lead Grade', map['leadGrade'] as String?, Icons.grade_outlined);
    addRow(
      'Conv. Probability',
      map['conversionProbability'] != null
          ? '${map['conversionProbability']}%'
          : null,
      Icons.percent_rounded,
    );
    addRow(
      'Forecast Category',
      map['forecastCategory'] as String?,
      Icons.bar_chart_rounded,
    );
    addRow(
      'Currency',
      map['currency'] as String?,
      Icons.currency_exchange_rounded,
    );
    addRow(
      'Expected Close',
      map['expectedCloseDate'] as String?,
      Icons.event_rounded,
    );
    addRow(
      'Next Action',
      map['scheduledAction'] as String?,
      Icons.schedule_rounded,
    );
    addRow(
      'Action Date',
      map['scheduledActionDate'] as String?,
      Icons.calendar_today_rounded,
    );
    addRow(
      'Action Time',
      map['scheduledActionTime'] as String?,
      Icons.access_time_rounded,
    );
    addRow('Action Notes', map['actionNotes'] as String?, Icons.notes_rounded);
    addRow(
      'BANT Budget',
      map['bantBudget'] as String?,
      Icons.account_balance_wallet_outlined,
    );
    addRow(
      'BANT Authority',
      map['bantAuthority'] as String?,
      Icons.verified_user_outlined,
    );
    addRow('BANT Need', map['bantNeed'] as String?, Icons.help_outline_rounded);
    addRow(
      'BANT Timeline',
      map['bantTimeline'] as String?,
      Icons.timeline_rounded,
    );
    addRow(
      'Quotation ID',
      map['quotationId'] as String?,
      Icons.receipt_outlined,
    );
    addRow(
      'Proposal Sent',
      map['proposalSentDate'] as String?,
      Icons.send_outlined,
    );
    addRow(
      'Discount',
      map['discountPercent'] as String?,
      Icons.discount_outlined,
    );
    addRow(
      'Contract Length',
      map['contractLength'] as String?,
      Icons.description_outlined,
    );
    addRow(
      'Renewal Freq.',
      map['renewalFrequency'] as String?,
      Icons.refresh_rounded,
    );
    addRow(
      'Next Best Action',
      map['nextBestAction'] as String?,
      Icons.lightbulb_outline_rounded,
    );
    addRow(
      'Status Sub-state',
      map['leadStatusSubState'] as String?,
      Icons.info_outline_rounded,
    );
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Deal Information',
          icon: Icons.trending_up_rounded,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAddressCard() {
    final rows = <Widget>[];
    final map = _fullMap;
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    addRow('Address Type', map['addressType'] as String?, Icons.home_outlined);
    addRow(
      'Address Tag',
      map['addressTag'] as String?,
      Icons.label_outline_rounded,
    );
    addRow('Street', _lead.address, Icons.location_on_outlined);
    addRow('Landmark', map['landmark'] as String?, Icons.place_outlined);
    addRow('City', _lead.city, Icons.location_city_rounded);
    addRow('District', map['district'] as String?, Icons.map_outlined);
    addRow('Pincode', map['pincode'] as String?, Icons.pin_drop_outlined);
    addRow('State', _lead.state, Icons.map_outlined);
    addRow('Country', _lead.country, Icons.public_rounded);
    addRow('Region', map['region'] as String?, Icons.explore_outlined);
    addRow(
      'Ownership',
      map['ownershipStatus'] as String?,
      Icons.house_outlined,
    );
    addRow(
      'Address Since',
      map['addressSince'] as String?,
      Icons.calendar_today_rounded,
    );
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Address',
          icon: Icons.location_on_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSocialCard() {
    final map = _fullMap;
    final rows = <Widget>[];
    void addRow(String label, String? value, IconData icon) {
      if (value != null && value.isNotEmpty) {
        rows.add(_InfoRow(label: label, value: value, icon: icon));
      }
    }

    addRow('LinkedIn', map['linkedin'] as String?, Icons.link_rounded);
    addRow('Facebook', map['facebook'] as String?, Icons.facebook_rounded);
    addRow(
      'Twitter/X',
      map['twitter'] as String?,
      Icons.alternate_email_rounded,
    );
    addRow('Instagram', map['instagram'] as String?, Icons.camera_alt_outlined);
    addRow(
      'YouTube',
      map['youtube'] as String?,
      Icons.play_circle_outline_rounded,
    );
    addRow('GitHub', map['github'] as String?, Icons.code_rounded);
    addRow('Telegram', map['telegram'] as String?, Icons.telegram_rounded);
    addRow('Website', map['website'] as String?, Icons.language_rounded);
    addRow(
      'Meeting Tool',
      map['preferredMeetingTool'] as String?,
      Icons.video_call_outlined,
    );
    addRow(
      'Calendly',
      map['calendlyLink'] as String?,
      Icons.calendar_month_outlined,
    );
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Social Profiles',
          icon: Icons.share_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInterestsCard() {
    final map = _fullMap;
    final interests = map['interests'] as List?;
    if (interests == null || interests.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Interests (tap for details)',
          icon: Icons.star_outline_rounded,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: interests.map<Widget>((i) {
                final interestName = i.toString();
                final hasDetails = map['interest_$interestName'] != null;
                return GestureDetector(
                  onTap: () => _showInterestDetails(interestName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: hasDetails
                            ? AppTheme.warning.withAlpha(100)
                            : AppTheme.warning.withAlpha(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          interestName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warning,
                          ),
                        ),
                        if (hasDetails) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 12,
                            color: AppTheme.warning,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap any interest to see filled details',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRelationsCard() {
    final map = _fullMap;
    final relations = map['relations'] as List?;
    if (relations == null || relations.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Relations',
          icon: Icons.group_outlined,
          children: relations.map<Widget>((r) {
            final rel = r as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryContainer,
                        child: Text(
                          (rel['name'] as String? ?? 'R')[0].toUpperCase(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rel['name'] as String? ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${rel['relation'] ?? ''} · Age: ${rel['age'] ?? 'N/A'}',
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
                  if ((rel['phone'] as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '📞 ${rel['phone']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  if ((rel['occupation'] as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '💼 ${rel['occupation']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  if ((rel['email'] as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '✉️ ${rel['email']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  if ((rel['annualIncome'] as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '💰 ${rel['annualIncome']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  Wrap(
                    spacing: 6,
                    children: [
                      if (rel['isCoApplicant'] == true)
                        _SmallBadge(
                          label: 'Co-Applicant',
                          color: AppTheme.primary,
                        ),
                      if (rel['isBeneficiary'] == true)
                        _SmallBadge(
                          label: 'Beneficiary',
                          color: AppTheme.success,
                        ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimelineTab() {
    final now = DateTime.now();
    final events = <_TimelineEvent>[];
    final createdAt =
        _fullMap['createdAt'] as DateTime? ??
        now.subtract(const Duration(days: 3));

    events.add(
      _TimelineEvent(
        title: 'Lead Created',
        description: 'Lead "${_lead.name}" added to the CRM system',
        dateTime: createdAt,
        icon: Icons.person_add_rounded,
        color: AppTheme.primary,
        category: 'System',
      ),
    );
    events.add(
      _TimelineEvent(
        title: 'Status: ${_lead.status}',
        description: 'Lead status set to ${_lead.status}',
        dateTime: createdAt.add(const Duration(hours: 1)),
        icon: Icons.flag_rounded,
        color: _statusColor,
        category: 'Status',
      ),
    );
    events.add(
      _TimelineEvent(
        title: 'Priority: ${_lead.priority}',
        description: 'Lead priority assigned as ${_lead.priority}',
        dateTime: createdAt.add(const Duration(hours: 2)),
        icon: Icons.priority_high_rounded,
        color: _priorityColor,
        category: 'Priority',
      ),
    );
    if (_lead.ownerName.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Assigned to ${_lead.ownerName}',
          description: 'Lead ownership assigned',
          dateTime: createdAt.add(const Duration(hours: 3)),
          icon: Icons.person_pin_rounded,
          color: AppTheme.success,
          category: 'Assignment',
        ),
      );
    }
    final source = _lead.source ?? _fullMap['source'] as String?;
    if (source != null && source.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Source: $source',
          description: 'Lead acquired via $source',
          dateTime: createdAt,
          icon: Icons.input_rounded,
          color: const Color(0xFF8B5CF6),
          category: 'Source',
        ),
      );
    }
    if (_lead.phone.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Contact Info Added',
          description:
              'Phone: ${_lead.phone}${_lead.email.isNotEmpty ? " · Email: ${_lead.email}" : ""}',
          dateTime: createdAt.add(const Duration(minutes: 30)),
          icon: Icons.contact_phone_rounded,
          color: AppTheme.primary,
          category: 'Contact',
        ),
      );
    }
    if (_lead.dealValue > 0) {
      events.add(
        _TimelineEvent(
          title: 'Deal Value Set',
          description: 'Estimated deal value: ${_formatValue(_lead.dealValue)}',
          dateTime: createdAt.add(const Duration(hours: 4)),
          icon: Icons.currency_rupee_rounded,
          color: AppTheme.success,
          category: 'Deal',
        ),
      );
    }
    final scheduledAction = _fullMap['scheduledAction'] as String?;
    final scheduledDate = _fullMap['scheduledActionDate'] as String?;
    if (scheduledAction != null && scheduledAction.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Action Scheduled: $scheduledAction',
          description: scheduledDate != null
              ? 'Scheduled for $scheduledDate'
              : 'Action planned',
          dateTime: now.add(const Duration(days: 2)),
          icon: Icons.event_rounded,
          color: AppTheme.warning,
          category: 'Scheduled',
          isFuture: true,
        ),
      );
    }
    if (_lead.tags.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Tags Added',
          description: _lead.tags.join(', '),
          dateTime: createdAt.add(const Duration(hours: 5)),
          icon: Icons.label_rounded,
          color: const Color(0xFF06B6D4),
          category: 'Tags',
        ),
      );
    }
    if (_lead.company.isNotEmpty && _lead.company != 'New Company') {
      events.add(
        _TimelineEvent(
          title: 'Company: ${_lead.company}',
          description:
              'Associated with ${_lead.company}${_lead.industry.isNotEmpty ? " (${_lead.industry})" : ""}',
          dateTime: createdAt.add(const Duration(minutes: 45)),
          icon: Icons.corporate_fare_rounded,
          color: const Color(0xFFEC4899),
          category: 'Business',
        ),
      );
    }
    for (final n in _notes) {
      events.add(
        _TimelineEvent(
          title: 'Note by ${n['author']}',
          description: n['note'] as String,
          dateTime: n['dateTime'] as DateTime? ?? now,
          icon: Icons.note_rounded,
          color: AppTheme.primary,
          category: 'Note',
        ),
      );
    }
    // Add session activity timeline entries
    final activityTimeline =
        _fullMap['activityTimeline'] as List<dynamic>? ?? [];
    for (final act in activityTimeline) {
      final actMap = act as Map<String, dynamic>;
      final action =
          actMap['type'] as String? ?? actMap['title'] as String? ?? 'Activity';
      final detail = actMap['detail'] as String? ?? '';
      final timestamp = actMap['timestamp'] as DateTime? ?? now;
      IconData icon;
      Color color;
      switch (action) {
        case 'Call':
          icon = Icons.phone_rounded;
          color = AppTheme.success;
          break;
        case 'Message':
          icon = Icons.message_rounded;
          color = const Color(0xFF8B5CF6);
          break;
        case 'WhatsApp':
          icon = Icons.chat_rounded;
          color = const Color(0xFF25D366);
          break;
        case 'Email':
          icon = Icons.email_rounded;
          color = AppTheme.primary;
          break;
        case 'Video Call':
          icon = Icons.videocam_rounded;
          color = const Color(0xFF0891B2);
          break;
        case 'Instagram':
          icon = Icons.camera_alt_rounded;
          color = const Color(0xFFE1306C);
          break;
        case 'Facebook':
          icon = Icons.facebook_rounded;
          color = const Color(0xFF1877F2);
          break;
        case 'X (Twitter)':
          icon = Icons.close_rounded;
          color = const Color(0xFF1DA1F2);
          break;
        case 'Telegram':
          icon = Icons.send_rounded;
          color = const Color(0xFF0088CC);
          break;
        case 'Session Completed':
          icon = Icons.check_circle_rounded;
          color = AppTheme.success;
          break;
        case 'Session Cancelled':
          icon = Icons.cancel_rounded;
          color = AppTheme.error;
          break;
        case 'Session Rescheduled':
          icon = Icons.event_repeat_rounded;
          color = const Color(0xFF8B5CF6);
          break;
        case 'Session Started':
          icon = Icons.play_circle_rounded;
          color = AppTheme.primary;
          break;
        default:
          icon = Icons.event_note_rounded;
          color = AppTheme.textMuted;
      }
      events.add(
        _TimelineEvent(
          title: action,
          description: detail,
          dateTime: timestamp,
          icon: icon,
          color: color,
          category: 'Session',
        ),
      );
    }
    events.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (events.isEmpty) {
      return Center(
        child: Text(
          'No timeline events yet.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textMuted,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        final isLast = i == events.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: event.isFuture
                        ? event.color.withAlpha(15)
                        : event.color.withAlpha(30),
                    shape: BoxShape.circle,
                    border: event.isFuture
                        ? Border.all(color: event.color.withAlpha(80))
                        : null,
                  ),
                  child: Icon(
                    event.icon,
                    size: 18,
                    color: event.color.withAlpha(event.isFuture ? 150 : 255),
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 50, color: AppTheme.surface200),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: event.isFuture
                        ? event.color.withAlpha(8)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: event.isFuture
                        ? Border.all(color: event.color.withAlpha(40))
                        : null,
                    boxShadow: event.isFuture
                        ? null
                        : [
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: event.color.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              event.category,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: event.color,
                              ),
                            ),
                          ),
                          if (event.isFuture) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Upcoming',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.warning,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _relativeLabel(event.dateTime),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                maxLines: 3,
                showCursor: true,
                cursorColor: AppTheme.primary,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _addVoiceRecording,
                    icon: const Icon(Icons.mic_rounded, size: 16),
                    label: Text(
                      'Voice Note',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: BorderSide(color: AppTheme.primary.withAlpha(100)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Note',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _notes.isEmpty && _voiceRecordings.isEmpty
              ? Center(
                  child: Text(
                    'No notes yet. Add your first note above.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  children: [
                    if (_voiceRecordings.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Voice Recordings',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      ..._voiceRecordings.map(
                        (r) => _VoiceRecordingCard(recording: r),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ..._notes.map(
                      (n) => _NoteCard(
                        author: n['author'] as String,
                        initials: n['initials'] as String,
                        note: n['note'] as String,
                        time: n['time'] as String,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, {
        'author': _lead.ownerName.isNotEmpty ? _lead.ownerName : 'Agent',
        'initials': _lead.ownerInitials.isNotEmpty ? _lead.ownerInitials : 'AG',
        'note': text,
        'time': 'Just now',
        'dateTime': DateTime.now(),
        'isVoice': false,
      });
      _noteController.clear();
      _noteFocusNode.unfocus();
    });
  }

  void _addVoiceRecording() {
    setState(() {
      _voiceRecordings.insert(0, {
        'duration': '0:05',
        'time': 'Just now',
        'label': 'Voice Recording ${_voiceRecordings.length + 1}',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Voice recording saved',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _QuickActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: AppTheme.success,
            onTap: () => _showSnackBar('Calling ${_lead.name}...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.email_rounded,
            label: 'Email',
            color: AppTheme.primary,
            onTap: () => _showSnackBar('Opening email...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: () => _showSnackBar('Opening WhatsApp...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.event_rounded,
            label: 'Schedule',
            color: AppTheme.warning,
            onTap: () => _showScheduleDialog(),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _editLead(BuildContext context) {
    context.go(AppRoutes.addLeadScreen, extra: {'editLead': _fullMap});
  }

  void _showScheduleDialog() {
    _showScheduleSheet(context);
  }

  void _showScheduleSheet(BuildContext context) {
    // Check if there's already an active schedule for this lead
    final map = _fullMap;
    final existingAction = map['scheduledAction'] as String?;
    final existingDate = map['scheduledActionDate'] as String?;
    final hasActiveSchedule =
        existingAction != null &&
        existingAction.isNotEmpty &&
        existingDate != null &&
        existingDate.isNotEmpty;

    if (hasActiveSchedule) {
      // Show warning dialog first
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Schedule Exists',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '$existingAction already scheduled for ${_lead.name}. Do you want to change the schedule?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Keep Existing',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _openScheduleBottomSheet(context);
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: Text(
                'Change Schedule',
                style: GoogleFonts.plusJakartaSans(),
              ),
            ),
          ],
        ),
      );
    } else {
      _openScheduleBottomSheet(context);
    }
  }

  void _openScheduleBottomSheet(BuildContext context) {
    String selectedActionType = 'Appointment';
    String selectedAgent = _lead.ownerName.isNotEmpty
        ? _lead.ownerName
        : 'Priya Sharma';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay? selectedTime;
    String locationController = '';
    String meetingLink = '';
    String agentSearchQuery = '';
    bool isActive = true;

    final agents = [
      {
        'name': 'Priya Sharma',
        'initials': 'PS',
        'role': 'Admin',
        'color': const Color(0xFF7C3AED),
      },
      {
        'name': 'Rahul Singh',
        'initials': 'RS',
        'role': 'Senior Rep',
        'color': const Color(0xFF059669),
      },
      {
        'name': 'Ananya Patel',
        'initials': 'AP',
        'role': 'Manager',
        'color': const Color(0xFF059669),
      },
      {
        'name': 'Kavya Menon',
        'initials': 'KM',
        'role': 'Sales Rep',
        'color': const Color(0xFF059669),
      },
      {
        'name': 'Arjun Das',
        'initials': 'AD',
        'role': 'Sales Rep',
        'color': const Color(0xFF059669),
      },
    ];

    final locationCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 8), child: StatefulBuilder(
        builder: (ctx, setSheet) {
          // Sort agents: selected first
          final sortedAgents = [...agents];
          sortedAgents.sort((a, b) {
            if (a['name'] == selectedAgent) return -1;
            if (b['name'] == selectedAgent) return 1;
            return 0;
          });
          final filteredAgents = agentSearchQuery.isEmpty
              ? sortedAgents
              : sortedAgents
                    .where(
                      (a) =>
                          (a['name'] as String).toLowerCase().contains(
                            agentSearchQuery.toLowerCase(),
                          ) ||
                          (a['role'] as String).toLowerCase().contains(
                            agentSearchQuery.toLowerCase(),
                          ),
                    )
                    .toList();

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.9,
              maxChildSize: 0.95,
              builder: (_, ctrl) => ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Schedule Next Action',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setSheet(() => isActive = v),
                        activeThumbColor: AppTheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action Type
                  Text(
                    'Action Type',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _ActionTypeChip(
                        label: 'Appointment',
                        icon: Icons.people_rounded,
                        isSelected: selectedActionType == 'Appointment',
                        onTap: () => setSheet(() {
                          selectedActionType = 'Appointment';
                          meetingLink = '';
                        }),
                      ),
                      _ActionTypeChip(
                        label: 'Video Call',
                        icon: Icons.videocam_rounded,
                        isSelected: selectedActionType == 'Video Call',
                        onTap: () => setSheet(() {
                          selectedActionType = 'Video Call';
                          meetingLink =
                              'https://meet.google.com/${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
                        }),
                      ),
                      _ActionTypeChip(
                        label: 'Call Back',
                        icon: Icons.phone_callback_rounded,
                        isSelected: selectedActionType == 'Call Back',
                        onTap: () => setSheet(() {
                          selectedActionType = 'Call Back';
                          meetingLink = '';
                        }),
                      ),
                      _ActionTypeChip(
                        label: 'Follow Up',
                        icon: Icons.repeat_rounded,
                        isSelected: selectedActionType == 'Follow Up',
                        onTap: () => setSheet(() {
                          selectedActionType = 'Follow Up';
                          meetingLink = '';
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Assign Member
                  Text(
                    'Assign Member',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Search agents
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
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
                          horizontal: 14,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      onChanged: (v) => setSheet(() => agentSearchQuery = v),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...filteredAgents.map((agent) {
                    final isSelected = selectedAgent == agent['name'];
                    return InkWell(
                      onTap: () => setSheet(
                        () => selectedAgent = agent['name'] as String,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: AppTheme.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: (agent['color'] as Color)
                                  .withAlpha(40),
                              child: Text(
                                agent['initials'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: agent['color'] as Color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    agent['name'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    agent['role'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Date & Time
                  Text(
                    'Date & Time',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (d != null) setSheet(() => selectedDate = d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
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
                              context: ctx,
                              initialTime:
                                  selectedTime ??
                                  const TimeOfDay(hour: 10, minute: 0),
                            );
                            if (t != null) setSheet(() => selectedTime = t);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: selectedTime == null
                                  ? Border.all(
                                      color: AppTheme.error.withAlpha(80),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: selectedTime == null
                                      ? AppTheme.textMuted
                                      : AppTheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  selectedTime == null
                                      ? 'Select time'
                                      : selectedTime!.format(ctx),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: selectedTime == null
                                        ? AppTheme.textMuted
                                        : AppTheme.textPrimary,
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

                  // Appointment Location (only for Appointment)
                  if (selectedActionType == 'Appointment') ...[
                    Row(
                      children: [
                        Text(
                          'Appointment Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          ' *',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: locationController.isEmpty
                            ? Border.all(color: AppTheme.error.withAlpha(60))
                            : null,
                      ),
                      child: TextField(
                        controller: locationCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Office address...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          isDense: true,
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        onChanged: (v) =>
                            setSheet(() => locationController = v),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Video Call auto-link
                  if (selectedActionType == 'Video Call') ...[
                    Text(
                      'Meeting Link',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(60),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              meetingLink,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w500,
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
                              color: AppTheme.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Auto',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        // Validate compulsory fields
                        if (selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a time',
                                style: GoogleFonts.plusJakartaSans(),
                              ),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          return;
                        }
                        if (selectedActionType == 'Appointment' &&
                            locationController.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter appointment location',
                                style: GoogleFonts.plusJakartaSans(),
                              ),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          return;
                        }
                        // Save schedule
                        final timeStr =
                            '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
                        final dateStr =
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                        setState(() {
                          final idx = globalLeadMaps.indexWhere(
                            (m) => m['id'] == _lead.id,
                          );
                          if (idx >= 0) {
                            globalLeadMaps[idx]['scheduledAction'] =
                                selectedActionType;
                            globalLeadMaps[idx]['scheduledActionDate'] =
                                dateStr;
                            globalLeadMaps[idx]['scheduledActionTime'] =
                                timeStr;
                            globalLeadMaps[idx]['scheduledAssignedTo'] =
                                selectedAgent;
                            if (selectedActionType == 'Appointment') {
                              globalLeadMaps[idx]['scheduledLocation'] =
                                  locationController;
                            }
                            if (selectedActionType == 'Video Call') {
                              globalLeadMaps[idx]['scheduledMeetingLink'] =
                                  meetingLink;
                            }
                          }
                        });
                        Navigator.pop(ctx);
                        _showSnackBar(
                          '$selectedActionType scheduled for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedTime!.format(context)}',
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Save Schedule',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
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
      )),
    );
  }

  String _monthName(int month) {
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
    return months[month - 1];
  }

  void _showChangeStatusDialog() {
    const statuses = [
      'New',
      'Contacted',
      'Engaged',
      'Qualified',
      'Proposed',
      'Follow Up',
      'Sessions',
      'Negotiations',
      'Result',
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Change Status',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((s) {
            final color = AppTheme.leadStatusColor(s);
            final isCurrent = s == _lead.status;
            return ListTile(
              dense: true,
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              title: Text(
                s,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent ? color : AppTheme.textPrimary,
                ),
              ),
              trailing: isCurrent
                  ? Icon(Icons.check_rounded, color: color, size: 18)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  final updatedMap = _lead.toMap();
                  updatedMap['status'] = s;
                  _lead = LeadModel.fromMap(updatedMap);
                  final idx = globalLeadMaps.indexWhere(
                    (m) => m['id'] == _lead.id,
                  );
                  if (idx >= 0) globalLeadMaps[idx]['status'] = s;
                });
                _showSnackBar('Status changed to $s');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 8), child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionTile(
              icon: Icons.edit_rounded,
              label: 'Edit Lead',
              onTap: () {
                Navigator.pop(context);
                _editLead(context);
              },
            ),
            _OptionTile(
              icon: Icons.swap_horiz_rounded,
              label: 'Change Status',
              onTap: () {
                Navigator.pop(context);
                _showChangeStatusDialog();
              },
            ),
            _OptionTile(
              icon: Icons.person_add_rounded,
              label: 'Reassign Lead',
              onTap: () {
                Navigator.pop(context);
                _showReassignDialog();
              },
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Lead',
              color: AppTheme.error,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      )),
    );
  }

  void _showReassignDialog() {
    final employees = [
      {
        'name': 'Priya Sharma',
        'role': 'Admin',
        'id': 'ADM-1042',
        'initials': 'PS',
      },
      {
        'name': 'Rahul Singh',
        'role': 'Senior Rep',
        'id': 'EMP-2031',
        'initials': 'RS',
      },
      {
        'name': 'Ananya Patel',
        'role': 'Manager',
        'id': 'EMP-1187',
        'initials': 'AP',
      },
      {
        'name': 'Kavya Menon',
        'role': 'Sales Rep',
        'id': 'EMP-3045',
        'initials': 'KM',
      },
      {
        'name': 'Arjun Das',
        'role': 'Sales Rep',
        'id': 'EMP-3046',
        'initials': 'AD',
      },
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(top: false, minimum: const EdgeInsets.only(bottom: 8), child: StatefulBuilder(
        builder: (ctx, setSheet) {
          String searchQuery = '';
          return StatefulBuilder(
            builder: (ctx, setSearch) {
              final filtered = employees.where((e) {
                final q = searchQuery.toLowerCase();
                return q.isEmpty ||
                    (e['name'] ?? '').toLowerCase().contains(q) ||
                    (e['role'] ?? '').toLowerCase().contains(q);
              }).toList();
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reassign Lead',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        filled: true,
                        fillColor: AppTheme.surfaceVariantLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      onChanged: (v) => setSearch(() => searchQuery = v),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: filtered
                            .map(
                              (e) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryContainer,
                                  child: Text(
                                    e['initials']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  e['name']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${e['role']} · ${e['id']}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: _lead.ownerName == e['name']
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: AppTheme.primary,
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.pop(ctx);
                                  setState(() {
                                    final updatedMap = _lead.toMap();
                                    updatedMap['ownerName'] = e['name'];
                                    updatedMap['ownerInitials'] = e['initials'];
                                    _lead = LeadModel.fromMap(updatedMap);
                                    final idx = globalLeadMaps.indexWhere(
                                      (m) => m['id'] == _lead.id,
                                    );
                                    if (idx >= 0) {
                                      globalLeadMaps[idx]['ownerName'] =
                                          e['name'];
                                      globalLeadMaps[idx]['ownerInitials'] =
                                          e['initials'];
                                    }
                                  });
                                  _showSnackBar(
                                    'Lead reassigned to ${e['name']}',
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Lead',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete ${_lead.name}? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              globalLeadMaps.removeWhere((m) => m['id'] == _lead.id);
              context.go(AppRoutes.leadsListScreen);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Action Type Chip ─────────────────────────────────────────────────────────

class _ActionTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _ActionTypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surface200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _SmallBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
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
}

class _HeaderBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _HeaderBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
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
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
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

class _PipelineProgress extends StatelessWidget {
  final String currentStatus;
  const _PipelineProgress({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    const stages = [
      'New',
      'Contacted',
      'Engaged',
      'Qualified',
      'Proposed',
      'Follow Up',
      'Sessions',
      'Negotiations',
      'Result',
    ];
    final currentIndex = stages.indexOf(currentStatus);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: stages.asMap().entries.map((entry) {
            final i = entry.key;
            final stage = entry.value;
            final isPast = i < currentIndex;
            final isCurrent = i == currentIndex;
            final color = AppTheme.leadStatusColor(stage);
            return Expanded(
              child: Container(
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isPast || isCurrent ? color : AppTheme.surface200,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: stages.asMap().entries.map((entry) {
            final i = entry.key;
            final stage = entry.value;
            final isCurrent = i == currentIndex;
            final color = AppTheme.leadStatusColor(stage);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isCurrent ? color.withAlpha(25) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isCurrent
                    ? Border.all(color: color.withAlpha(80))
                    : null,
              ),
              child: Text(
                stage,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent ? color : AppTheme.textMuted,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TimelineEvent {
  final String title;
  final String description;
  final DateTime dateTime;
  final IconData icon;
  final Color color;
  final String category;
  final bool isFuture;
  const _TimelineEvent({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.icon,
    required this.color,
    required this.category,
    this.isFuture = false,
  });
}

class _NoteCard extends StatelessWidget {
  final String author;
  final String initials;
  final String note;
  final String time;
  const _NoteCard({
    required this.author,
    required this.initials,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
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
              CircleAvatar(
                radius: 14,
                backgroundColor: AppTheme.primaryContainer,
                child: Text(
                  initials,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  author,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceRecordingCard extends StatelessWidget {
  final Map<String, dynamic> recording;
  const _VoiceRecordingCard({required this.recording});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recording['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${recording['duration']} · ${recording['time']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_rounded, color: AppTheme.primary, size: 28),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textPrimary;
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: c,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
