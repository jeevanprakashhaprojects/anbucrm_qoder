import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Follow-up', 'Assignment', 'Deal', 'System'];

  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      id: '1',
      type: 'Follow-up',
      title: 'Follow-up Due',
      message: 'Follow-up with Priya Sharma (Infosys) is due today at 3:00 PM',
      time: '10 min ago',
      isRead: false,
      icon: Icons.schedule_rounded,
      color: AppTheme.warning,
    ),
    _NotificationItem(
      id: '2',
      type: 'Assignment',
      title: 'Lead Assigned',
      message: 'Mohammed Al-Rashid (TCS) has been assigned to you by Admin',
      time: '1h ago',
      isRead: false,
      icon: Icons.person_add_rounded,
      color: AppTheme.primary,
    ),
    _NotificationItem(
      id: '3',
      type: 'Deal',
      title: 'Deal Closed! 🎉',
      message:
          'Vikram Joshi (HDFC Bank) deal worth ₹32L has been marked as Won',
      time: '2h ago',
      isRead: false,
      icon: Icons.emoji_events_rounded,
      color: AppTheme.success,
    ),
    _NotificationItem(
      id: '4',
      type: 'Follow-up',
      title: 'Overdue Follow-up',
      message: 'Follow-up with Sunita Reddy (Wipro) was due 2 days ago',
      time: '3h ago',
      isRead: true,
      icon: Icons.warning_rounded,
      color: AppTheme.error,
    ),
    _NotificationItem(
      id: '5',
      type: 'Deal',
      title: 'Deal Stage Updated',
      message: 'Fatima Nair (Reliance) moved from Proposal to Negotiation',
      time: '5h ago',
      isRead: true,
      icon: Icons.trending_up_rounded,
      color: const Color(0xFF8B5CF6),
    ),
    _NotificationItem(
      id: '6',
      type: 'Assignment',
      title: 'Lead Reassigned',
      message:
          'Rohan Kapoor (Mahindra) has been reassigned from Rahul to Ananya',
      time: '1d ago',
      isRead: true,
      icon: Icons.swap_horiz_rounded,
      color: AppTheme.secondary,
    ),
    _NotificationItem(
      id: '7',
      type: 'System',
      title: 'System Update',
      message: 'AnbuCRM has been updated to v2.1.0 with new features',
      time: '2d ago',
      isRead: true,
      icon: Icons.system_update_rounded,
      color: AppTheme.textSecondary,
    ),
    _NotificationItem(
      id: '8',
      type: 'Follow-up',
      title: 'Upcoming Follow-up',
      message: 'Scheduled call with Arjun Mehta (HCL) tomorrow at 11:00 AM',
      time: '2d ago',
      isRead: true,
      icon: Icons.event_rounded,
      color: AppTheme.warning,
    ),
  ];

  List<_NotificationItem> get _filtered {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n.type == _selectedFilter).toList();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.leadsListScreen),
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final filter = _filters[i];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.surface200,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Notifications list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No notifications',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final notif = _filtered[i];
                      return _NotificationCard(
                        notification: notif,
                        onTap: () => setState(() => notif.isRead = true),
                        onDismiss: () => setState(
                          () => _notifications.removeWhere(
                            (n) => n.id == notif.id,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Notification Item Model ──────────────────────────────────────────────────

class _NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final String time;
  bool isRead;
  final IconData icon;
  final Color color;

  _NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
  });
}

// ─── Notification Card ────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppTheme.surfaceLight
                : AppTheme.primaryContainer.withAlpha(60),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? AppTheme.surface200
                  : AppTheme.primary.withAlpha(60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notification.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  size: 20,
                  color: notification.color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
