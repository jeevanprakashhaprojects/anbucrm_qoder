import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class InterestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> interest;
  const InterestDetailScreen({required this.interest, super.key});

  @override
  State<InterestDetailScreen> createState() => _InterestDetailScreenState();
}

class _InterestDetailScreenState extends State<InterestDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentStatus = '';
  bool _isCompleted = false;

  final List<Map<String, dynamic>> _sessions = [];
  final List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentStatus = widget.interest['status'] as String? ?? 'New';
    _isCompleted = _currentStatus == 'Won';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
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

  @override
  Widget build(BuildContext context) {
    final interest = widget.interest;
    final statusColor = _statusColor(_currentStatus);
    final categoryColor = _categoryColor(interest['category'] as String? ?? '');
    final priorityColor = AppTheme.priorityColor(
      interest['priority'] as String? ?? 'Medium',
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Fixed header — no NestedScrollView to prevent content merging over header
          _buildHeader(
            context,
            interest,
            statusColor,
            categoryColor,
            priorityColor,
          ),
          // Tab bar — separate from header
          Container(
            color: AppTheme.surfaceLight,
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
              indicatorColor: AppTheme.primary,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Sessions'),
                Tab(text: 'Notes'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(interest),
                _buildSessionsTab(),
                _buildNotesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Map<String, dynamic> interest,
    Color statusColor,
    Color categoryColor,
    Color priorityColor,
  ) {
    return Container(
      color: AppTheme.surfaceLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppTheme.textPrimary,
                ),
                const Spacer(),
                if (_isCompleted)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
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
            ),
            // Customer info row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withAlpha(153)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        (interest['customerName'] as String? ?? 'C')[0]
                            .toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interest['customerName'] as String? ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _SmallBadge(
                              label: interest['category'] as String? ?? '',
                              color: categoryColor,
                            ),
                            const SizedBox(width: 6),
                            _SmallBadge(
                              label: _currentStatus,
                              color: statusColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _SmallBadge(
                    label: interest['priority'] as String? ?? 'Medium',
                    color: priorityColor,
                  ),
                ],
              ),
            ),
            // Quick actions row — separate from badges
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: _buildQuickActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.phone_rounded, 'label': 'Call', 'color': AppTheme.success},
      {
        'icon': Icons.chat_rounded,
        'label': 'WhatsApp',
        'color': const Color(0xFF25D366),
      },
      {
        'icon': Icons.calendar_today_rounded,
        'label': 'Schedule',
        'color': AppTheme.primary,
      },
      {
        'icon': Icons.swap_horiz_rounded,
        'label': 'Status',
        'color': AppTheme.warning,
      },
      {
        'icon': Icons.note_add_rounded,
        'label': 'Note',
        'color': AppTheme.secondary,
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        final color = a['color'] as Color;
        return GestureDetector(
          onTap: () {
            if (a['label'] == 'Status') {
              _showStatusPicker(context);
            } else if (a['label'] == 'Schedule') {
              _showScheduleDialog(context);
            } else if (a['label'] == 'Note') {
              _showAddNoteDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${a['label']} action for ${widget.interest['customerName']}',
                  ),
                ),
              );
            }
          },
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(51)),
                ),
                child: Icon(a['icon'] as IconData, size: 18, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                a['label'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> interest) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Information — only show filled fields
          _buildCustomerInfoCard(interest),
          const SizedBox(height: 12),
          _buildSectionCard('Interest Details', Icons.star_rounded, [
            if ((interest['description'] as String? ?? '').isNotEmpty)
              _infoRow(
                Icons.description_rounded,
                'Description',
                interest['description'] as String,
              ),
            if ((interest['estimatedValue'] as double? ?? 0) > 0)
              _infoRow(
                Icons.currency_rupee_rounded,
                'Est. Value',
                _formatValue(interest['estimatedValue'] as double),
              ),
            _infoRow(
              Icons.flag_rounded,
              'Priority',
              interest['priority'] as String? ?? 'Medium',
            ),
            _infoRow(Icons.info_rounded, 'Status', _currentStatus),
          ]),
          const SizedBox(height: 12),
          _buildEmployeeCard(interest),
          const SizedBox(height: 12),
          _buildActionsCard(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard(Map<String, dynamic> interest) {
    final rows = <Widget>[];
    final phone = interest['phone'] as String? ?? '';
    final email = interest['email'] as String? ?? '';
    final source = interest['source'] as String? ?? '';
    final date = interest['interestDate'] as String? ?? '';

    if (phone.isNotEmpty) {
      rows.add(_infoRow(Icons.phone_rounded, 'Phone', phone));
    }
    if (email.isNotEmpty) {
      rows.add(_infoRow(Icons.email_rounded, 'Email', email));
    }
    if (source.isNotEmpty) {
      rows.add(_infoRow(Icons.source_rounded, 'Source', source));
    }
    if (date.isNotEmpty) {
      rows.add(_infoRow(Icons.calendar_today_rounded, 'Date', date));
    }

    if (rows.isEmpty) {
      rows.add(
        Text(
          'No contact details available.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return _buildSectionCard(
      'Customer Information',
      Icons.person_rounded,
      rows,
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> interest) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_rounded, size: 16, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                'Assigned Employee',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    (interest['assignedEmployee'] as String? ?? 'E')[0]
                        .toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interest['assignedEmployee'] as String? ?? 'Unassigned',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Senior Sales Representative',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest['assignedId'] as String? ?? 'EMP-0000',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statChip('12', 'Leads'),
              const SizedBox(width: 8),
              _statChip('4', 'Won'),
              const SizedBox(width: 8),
              _statChip('33%', 'Rate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Convert as Result (renamed from "Convert to Policy")
          _actionButton(
            'Convert as Result',
            Icons.check_circle_rounded,
            AppTheme.success,
            () {
              setState(() {
                _currentStatus = 'Won';
                _isCompleted = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Interest converted as result!')),
              );
            },
          ),
          const SizedBox(height: 8),
          // Mark as Completed toggle
          _actionButton(
            _isCompleted ? 'Mark as Pending' : 'Mark as Completed',
            _isCompleted
                ? Icons.radio_button_unchecked_rounded
                : Icons.check_circle_outline_rounded,
            _isCompleted ? AppTheme.textSecondary : AppTheme.primary,
            () {
              setState(() {
                _isCompleted = !_isCompleted;
                if (_isCompleted) _currentStatus = 'Won';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isCompleted ? 'Marked as completed' : 'Marked as pending',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Mark as Lost
          _actionButton(
            'Mark as Lost',
            Icons.cancel_rounded,
            AppTheme.error,
            () => _showMarkLostDialog(context),
          ),
          const SizedBox(height: 8),
          // Reassign Employee — opens picker with all employees
          _actionButton(
            'Reassign Employee',
            Icons.swap_horiz_rounded,
            AppTheme.warning,
            () => _showReassignDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_sessions.length} Sessions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => _showScheduleDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Schedule',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (_sessions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No sessions yet. Tap Schedule to add one.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ..._sessions.map((s) => _buildSessionCard(s)),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final isCompleted = session['completed'] as bool? ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.surfaceVariantLight
            : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(31),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  session['type'] as String? ?? 'Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: () {
                    setState(() => session['completed'] = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session marked as complete'),
                      ),
                    );
                  },
                  child: Text(
                    'Mark Complete',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: AppTheme.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                '${session['date']} at ${session['time']}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if ((session['notes'] as String? ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              session['notes'] as String,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Add note area
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
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textMuted,
                  ),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    setState(
                      () => _notes.insert(0, {
                        'text': text.trim(),
                        'time': 'Just now',
                      }),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddNoteDialog(context),
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
          child: _notes.isEmpty
              ? Center(
                  child: Text(
                    'No notes yet.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  children: _notes
                      .map(
                        (n) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n['text'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                n['time'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  String _formatValue(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  void _showStatusPicker(BuildContext context) {
    final statuses = ['New', 'In Progress', 'Quoted', 'Won', 'Lost'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
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
                'Change Status',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...statuses.map((s) {
                final color = _statusColor(s);
                final isSelected = s == _currentStatus;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentStatus = s;
                      _isCompleted = s == 'Won';
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Status changed to $s')),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withAlpha(26)
                          : AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppTheme.surface200,
                      ),
                    ),
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
                        const SizedBox(width: 10),
                        Text(
                          s,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? color : AppTheme.textPrimary,
                          ),
                        ),
                        if (isSelected) ...[
                          const Spacer(),
                          Icon(Icons.check_rounded, size: 16, color: color),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    String selectedType = 'Follow-up';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Schedule Follow-up',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type',
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
                children: ['Follow-up', 'Appointment', 'Video Call', 'Callback']
                    .map(
                      (t) => ChoiceChip(
                        label: Text(
                          t,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        ),
                        selected: selectedType == t,
                        onSelected: (_) =>
                            setDialogState(() => selectedType = t),
                        selectedColor: AppTheme.primaryContainer,
                        checkmarkColor: AppTheme.primary,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setDialogState(() => selectedDate = d);
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: selectedTime,
                    );
                    if (t != null) setDialogState(() => selectedTime = t);
                  },
                  icon: const Icon(Icons.access_time_rounded, size: 16),
                  label: Text(
                    selectedTime.format(ctx),
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _sessions.add({
                    'type': selectedType,
                    'date':
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    'time': selectedTime.format(context),
                    'notes': '',
                    'completed': false,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$selectedType scheduled for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: Text('Schedule', style: GoogleFonts.plusJakartaSans()),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
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
                  'Add Note',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: ctrl,
                  maxLines: 4,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Write your note here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ctrl.text.trim().isNotEmpty) {
                        setState(
                          () => _notes.insert(0, {
                            'text': ctrl.text.trim(),
                            'time': 'Just now',
                          }),
                        );
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Note',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMarkLostDialog(BuildContext context) {
    String reason = 'Price';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            'Mark as Lost',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select reason:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: reason,
                decoration: const InputDecoration(labelText: 'Lost Reason'),
                items:
                    [
                          'Price',
                          'Competitor',
                          'Not Interested',
                          'Delayed Decision',
                          'Budget',
                          'Other',
                        ]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                onChanged: (v) => setDialogState(() => reason = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStatus = 'Lost';
                  _isCompleted = false;
                });
                Navigator.pop(ctx);
                // Close the interest detail screen (mark as lost = close)
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Interest marked as lost — $reason')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReassignDialog(BuildContext context) {
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
      {
        'name': 'Vikram Nair',
        'role': 'Contractor',
        'id': 'CONT-8391',
        'initials': 'VN',
      },
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
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
                'Reassign Employee',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...employees.map(
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
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  trailing: widget.interest['assignedEmployee'] == e['name']
                      ? const Icon(Icons.check_rounded, color: AppTheme.primary)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reassigned to ${e['name']}')),
                    );
                  },
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
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
