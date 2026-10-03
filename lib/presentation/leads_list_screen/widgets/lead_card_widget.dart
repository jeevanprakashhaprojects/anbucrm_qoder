import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../leads_list_screen.dart' as leads_screen;
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import '../../follow_ups_screen/follow_ups_screen.dart' show globalFollowUpMaps;
import '../../sessions_screen/sessions_screen.dart' show globalSessionMaps;

final Set<String> globalStarredLeadIds = {};
final ValueNotifier<Set<String>> globalStarredNotifier =
    ValueNotifier<Set<String>>(<String>{});
final List<Map<String, dynamic>> globalLeadMaps = [];

class _StarButton extends StatelessWidget {
  final String leadId;
  const _StarButton({required this.leadId});

  void _toggle() {
    final ids = Set<String>.from(globalStarredNotifier.value);
    if (ids.contains(leadId)) {
      ids.remove(leadId);
    } else {
      ids.add(leadId);
    }
    globalStarredLeadIds.clear();
    globalStarredLeadIds.addAll(ids);
    globalStarredNotifier.value = ids;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: globalStarredNotifier,
      builder: (context, starred, _) {
        final isStarred = starred.contains(leadId);
        return GestureDetector(
          onTap: _toggle,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isStarred ? const Color(0xFFFEF3C7) : AppTheme.surface100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isStarred
                    ? const Color(0xFFF59E0B).withAlpha(120)
                    : AppTheme.surface200,
              ),
            ),
            child: Icon(
              isStarred ? Icons.star_rounded : Icons.star_border_rounded,
              size: 16,
              color: isStarred ? const Color(0xFFF59E0B) : AppTheme.textMuted,
            ),
          ),
        );
      },
    );
  }
}

class LeadCardWidget extends StatefulWidget {
  final leads_screen.LeadModel lead;
  final int index;
  final VoidCallback? onRemove;

  const LeadCardWidget({
    super.key,
    required this.lead,
    required this.index,
    this.onRemove,
  });

  @override
  State<LeadCardWidget> createState() => _LeadCardWidgetState();
}

class _LeadCardWidgetState extends State<LeadCardWidget>
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

  Color _priorityColor(String p) => AppTheme.priorityColor(p);

  String _relativeAge(dynamic dt) {
    final diff = dt is DateTime
        ? DateTime.now().difference(dt)
        : const Duration();
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? 's' : ''} ago';
    }
    return '${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() > 1 ? 's' : ''} ago';
  }

  String _formatDate(dynamic dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatTime(dynamic dt) {
    final hour = (dt as dynamic).hour > 12
        ? (dt as dynamic).hour - 12
        : ((dt as dynamic).hour == 0 ? 12 : (dt as dynamic).hour);
    final ampm = (dt as dynamic).hour >= 12 ? 'PM' : 'AM';
    final min = (dt as dynamic).minute.toString().padLeft(2, '0');
    return '$hour:$min $ampm';
  }

  String _formatScheduledDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    final parts = dateStr.split('/');
    if (parts.length != 3) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final day = int.tryParse(parts[0]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 1;
    final year = parts[2];
    if (month < 1 || month > 12) return dateStr;
    return '$day ${months[month - 1]} $year';
  }

  String _formatScheduledTime(String timeStr) {
    if (timeStr.isEmpty) return '';
    final parts = timeStr.split(':');
    if (parts.length != 2) return timeStr;
    final hour = int.tryParse(parts[0]) ?? 0;
    final min = parts[1];
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h:$min $ampm';
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$h:${dt.minute.toString().padLeft(2, '0')} $ampm';
    if (d == today) return 'Today · $timeStr';
    if (d == today.add(const Duration(days: 1))) return 'Tomorrow · $timeStr';
    return '${dt.day} ${months[dt.month - 1]} · $timeStr';
  }

  IconData _actionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'appointment':
        return Icons.calendar_today_rounded;
      case 'follow-up':
      case 'follow up':
        return Icons.repeat_rounded;
      case 'video call':
        return Icons.videocam_outlined;
      case 'call back':
        return Icons.phone_callback_rounded;
      case 'not interested':
        return Icons.do_not_disturb_alt_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  Color _actionColor(String action) {
    switch (action.toLowerCase()) {
      case 'appointment':
        return AppTheme.primary;
      case 'follow-up':
      case 'follow up':
        return const Color(0xFF7C3AED);
      case 'video call':
        return const Color(0xFF0891B2);
      case 'call back':
        return AppTheme.success;
      case 'not interested':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _ownerAvatarColor(String initials) {
    const colors = [
      Color(0xFF7C3AED),
      Color(0xFF059669),
      Color(0xFF0891B2),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF6366F1),
    ];
    if (initials.isEmpty) return colors[0];
    return colors[initials.codeUnitAt(0) % colors.length];
  }

  Map<String, dynamic>? _getActiveFollowUp(String leadId, String leadName) {
    final now = DateTime.now();
    final candidates = globalFollowUpMaps.where((f) {
      if (f['status'] == 'Completed' || f['status'] == 'Cancelled') {
        return false;
      }
      final fLeadId = (f['linkedLeadId'] as String?) ?? '';
      final fLeadName = (f['linkedLead'] as String?) ?? '';
      return (fLeadId.isNotEmpty && fLeadId == leadId) ||
          (fLeadId.isEmpty &&
              fLeadName.toLowerCase() == leadName.toLowerCase());
    }).toList();
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) {
      final aDate = a['dueDate'] as DateTime;
      final bDate = b['dueDate'] as DateTime;
      final aUpcoming = aDate.isAfter(now);
      final bUpcoming = bDate.isAfter(now);
      if (aUpcoming && !bUpcoming) return -1;
      if (!aUpcoming && bUpcoming) return 1;
      return aDate.compareTo(bDate);
    });
    return candidates.first;
  }

  Map<String, dynamic>? _getActiveSession(String leadId, String leadName) {
    final now = DateTime.now();
    final candidates = globalSessionMaps.where((s) {
      if (s['status'] == 'Completed' || s['status'] == 'Cancelled') {
        return false;
      }
      final sLeadId = (s['linkedLeadId'] as String?) ?? '';
      final sLeadName = (s['linkedLead'] as String?) ?? '';
      return (sLeadId.isNotEmpty && sLeadId == leadId) ||
          (sLeadId.isEmpty &&
              sLeadName.toLowerCase() == leadName.toLowerCase());
    }).toList();
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) {
      final aDate = a['date'] as DateTime;
      final bDate = b['date'] as DateTime;
      final aUpcoming = aDate.isAfter(now);
      final bUpcoming = bDate.isAfter(now);
      if (aUpcoming && !bUpcoming) return -1;
      if (!aUpcoming && bUpcoming) return 1;
      return aDate.compareTo(bDate);
    });
    return candidates.first;
  }

  String _formatDealValue(double? value) {
    if (value == null || value == 0) return '';
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)}K';
    }
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final statusColor = AppTheme.leadStatusColor(lead.status);
    final priorityColor = _priorityColor(lead.priority);
    final isVip = lead.tags.contains('VIP');

    final map = globalLeadMaps.firstWhere(
      (m) => m['id'] == lead.id,
      orElse: () => <String, dynamic>{},
    );
    final scheduledAction = (map['scheduledAction'] as String?) ?? '';
    final scheduledActionDate = (map['scheduledActionDate'] as String?) ?? '';
    final scheduledActionTime = (map['scheduledActionTime'] as String?) ?? '';
    final createdAt = map.isEmpty
        ? lead.createdAt
        : map['createdAt'] as DateTime?;
    final ownerName = (map['ownerName'] as String?) ?? lead.ownerName;
    final ownerInitials =
        (map['ownerInitials'] as String?) ?? lead.ownerInitials;
    final isExistingCustomerFromMap = map['isExistingCustomer'] as bool? ?? false;
    final hasAnySession = globalSessionMaps.any((s) {
      final sLeadId = (s['linkedLeadId'] as String?) ?? '';
      final sLeadName = (s['linkedLead'] as String?) ?? '';
      return (sLeadId.isNotEmpty && sLeadId == lead.id) ||
          (sLeadId.isEmpty && sLeadName.toLowerCase() == lead.name.toLowerCase());
    });
    final isExistingCustomer = isExistingCustomerFromMap || hasAnySession;
    final dealValue = (map['dealValue'] as num?)?.toDouble();
    final dealValueStr = _formatDealValue(dealValue);
    final phone = lead.phone;
    final email = (map['email'] as String?) ?? '';

    final activeFollowUp = _getActiveFollowUp(lead.id, lead.name);
    final activeSession = _getActiveSession(lead.id, lead.name);

    final contentChild = _buildCardContent(
      lead: lead,
      statusColor: statusColor,
      priorityColor: priorityColor,
      isVip: isVip,
      createdAt: createdAt,
      ownerName: ownerName,
      ownerInitials: ownerInitials,
      isExistingCustomer: isExistingCustomer,
      dealValueStr: dealValueStr,
      phone: phone,
      email: email,
      scheduledAction: scheduledAction,
      scheduledActionDate: scheduledActionDate,
      scheduledActionTime: scheduledActionTime,
      activeFollowUp: activeFollowUp,
      activeSession: activeSession,
    );

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Dismissible(
          key: Key(lead.id),
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
                      'Remove Lead',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      'Remove ${lead.name} from your pipeline?',
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
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: globalStarredNotifier,
            child: contentChild,
            builder: (context, starredIds, cachedChild) {
              final isStarred = starredIds.contains(lead.id);
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isStarred
                        ? const Color(0xFFF59E0B).withAlpha(100)
                        : Colors.transparent,
                  ),
                  boxShadow: [
                    if (isStarred)
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withAlpha(30),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: priorityColor,
                          width: 3,
                        ),
                      ),
                    ),
                    child: cachedChild,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent({
    required leads_screen.LeadModel lead,
    required Color statusColor,
    required Color priorityColor,
    required bool isVip,
    required DateTime? createdAt,
    required String ownerName,
    required String ownerInitials,
    required bool isExistingCustomer,
    required String dealValueStr,
    required String phone,
    required String email,
    required String scheduledAction,
    required String scheduledActionDate,
    required String scheduledActionTime,
    required Map<String, dynamic>? activeFollowUp,
    required Map<String, dynamic>? activeSession,
  }) {
    return InkWell(
      onTap: () => context.go(AppRoutes.leadDetailScreen, extra: lead),
      borderRadius: BorderRadius.circular(16),
      splashColor: AppTheme.primaryContainer.withAlpha(128),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP ROW: Priority + Status + VIP badges + Star + age ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: [
                    StatusBadgeWidget(
                      label: lead.priority,
                      color: priorityColor,
                    ),
                    StatusBadgeWidget(
                      label: lead.status,
                      color: statusColor,
                    ),
                    if (isVip)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFB45309).withAlpha(80),
                          ),
                        ),
                        child: Text(
                          'VIP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                _StarButton(leadId: lead.id),
                if (createdAt != null) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.access_time_rounded,
                    size: 11,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _relativeAge(createdAt),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // ── NAME + ASSIGNED MEMBER (side by side like call logs) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (phone.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 12,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                phone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Assigned member — same design as call logs
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: _ownerAvatarColor(ownerInitials),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              ownerInitials,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          ownerName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // ── CREATED DATE + TIME + EXISTING CUSTOMER TAG ──
            if (createdAt != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 11,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(createdAt),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.access_time_rounded,
                    size: 11,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _formatTime(createdAt),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const Spacer(),
                  if (isExistingCustomer) _buildExistingCustomerBadge(),
                ],
              ),
            ] else if (isExistingCustomer) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildExistingCustomerBadge(),
                ],
              ),
            ],

            // ── DEAL VALUE ──
            if (dealValueStr.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.success.withAlpha(40),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.currency_rupee_rounded,
                      size: 12,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dealValueStr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),

            // ── INTEREST TAGS ──
            if (lead.interests?.isNotEmpty ?? false) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: lead.interests!.map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withAlpha(180),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      interest,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // ── FOLLOW-UP BADGE (from globalFollowUpMaps) ──
            if (activeFollowUp != null) ...[
              _buildFollowUpBadge(activeFollowUp),
            ],

            // ── SESSION BADGE (from globalSessionMaps) ──
            if (activeSession != null) ...[
              _buildSessionBadge(activeSession),
            ],

            // ── SCHEDULED ACTION BADGE ──
            if (scheduledAction.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _actionColor(scheduledAction).withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _actionColor(scheduledAction).withAlpha(50),
                  ),
                ),
                child: scheduledAction.toLowerCase() == 'not interested'
                    ? Wrap(
                        spacing: 5,
                        children: [
                          Icon(
                            _actionIcon(scheduledAction),
                            size: 13,
                            color: _actionColor(scheduledAction),
                          ),
                          Text(
                            'Not Interested',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _actionColor(scheduledAction),
                            ),
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: [
                          Icon(
                            _actionIcon(scheduledAction),
                            size: 13,
                            color: _actionColor(scheduledAction),
                          ),
                          Text(
                            scheduledAction,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _actionColor(scheduledAction),
                            ),
                          ),
                          if (scheduledActionDate.isNotEmpty ||
                              scheduledActionTime.isNotEmpty) ...[
                            Text(
                              '•',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: _actionColor(
                                  scheduledAction,
                                ).withAlpha(150),
                              ),
                            ),
                            if (scheduledActionDate.isNotEmpty) ...[
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 11,
                                color: _actionColor(scheduledAction),
                              ),
                              Text(
                                _formatScheduledDate(
                                  scheduledActionDate,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: _actionColor(scheduledAction),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (scheduledActionTime.isNotEmpty) ...[
                              Icon(
                                Icons.access_time_rounded,
                                size: 11,
                                color: _actionColor(scheduledAction),
                              ),
                              Text(
                                _formatScheduledTime(
                                  scheduledActionTime,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: _actionColor(scheduledAction),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExistingCustomerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
          const Icon(Icons.verified_rounded, size: 10, color: Color(0xFF059669)),
          const SizedBox(width: 3),
          Text(
            'Existing Customer',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpBadge(Map<String, dynamic> fu) {
    final dueDate = fu['dueDate'] as DateTime;
    final type = (fu['type'] as String?) ?? 'Follow-up';
    const color = Color(0xFF7C3AED);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 4,
        children: [
          const Icon(Icons.repeat_rounded, size: 13, color: color),
          Text(
            'Follow-up · $type',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            '•',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: color.withAlpha(150),
            ),
          ),
          const Icon(Icons.calendar_today_rounded, size: 11, color: color),
          Text(
            _formatDateTime(dueDate),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionBadge(Map<String, dynamic> session) {
    final date = session['date'] as DateTime;
    final type = (session['type'] as String?) ?? 'Session';
    const color = Color(0xFF0891B2);
    IconData icon;
    switch (type) {
      case 'Video Call':
        icon = Icons.videocam_rounded;
        break;
      case 'Appointment':
        icon = Icons.people_rounded;
        break;
      case 'Call Back':
        icon = Icons.phone_callback_rounded;
        break;
      default:
        icon = Icons.event_rounded;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 4,
        children: [
          Icon(icon, size: 13, color: color),
          Text(
            type,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            '•',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: color.withAlpha(150),
            ),
          ),
          const Icon(Icons.calendar_today_rounded, size: 11, color: color),
          Text(
            _formatDateTime(date),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
