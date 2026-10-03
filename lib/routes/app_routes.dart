import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../presentation/add_lead_screen/add_lead_screen.dart';
import '../presentation/analytics_screen/analytics_screen.dart';
import '../presentation/buy_product_screen/buy_product_screen.dart';
import '../presentation/calls_permission_screen/calls_permission_screen.dart';
import '../presentation/create_account_screen/create_account_screen.dart';
import '../presentation/customers_screen/customers_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/interest_detail_screen/interest_detail_screen.dart';
import '../presentation/interests_screen/interests_screen.dart';
import '../presentation/lead_detail_screen/lead_detail_screen.dart';
import '../presentation/leads_list_screen/leads_list_screen.dart';
import '../presentation/logs_screen/logs_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/sign_up_login_screen/anbu_login_screen.dart';
import '../presentation/sim_selection_screen/sim_selection_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/sessions_screen/sessions_screen.dart';
import '../presentation/follow_ups_screen/follow_ups_screen.dart';
import '../presentation/reminders_screen/reminders_screen.dart';
import '../presentation/employees_screen/employees_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/templates_screen/templates_screen.dart';
import '../presentation/video_session_screen/video_session_screen.dart';
import '../widgets/app_scaffold.dart';
import '../presentation/important_dates_screen/important_dates_screen.dart';
import '../presentation/assign_leads_screen/assign_leads_screen.dart';
import '../presentation/assigned_tasks_screen/assigned_tasks_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash';
  static const String welcomeScreen = '/welcome';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String buyProductScreen = '/buy-product';
  static const String createAccountScreen = '/create-account';
  static const String callsPermissionScreen = '/calls-permission';
  static const String simSelectionScreen = '/sim-selection';
  // Shell branches
  static const String dashboardScreen = '/dashboard-screen';
  static const String leadsListScreen = '/leads-list-screen';
  static const String logsScreen = '/logs-screen';
  static const String settingsShellScreen = '/settings-shell-screen';
  // Legacy / standalone
  static const String interestsScreen = '/interests-screen';
  static const String analyticsScreen = '/analytics-screen';
  static const String customersScreen = '/customers-screen';
  // Standalone (push)
  static const String addLeadScreen = '/add-lead-screen';
  static const String profileScreen = '/profile-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String leadDetailScreen = '/lead-detail-screen';
  static const String interestDetailScreen = '/interest-detail-screen';
  static const String settingsScreen = '/settings-screen';
  static const String sessionsScreen = '/sessions-screen';
  static const String followUpsScreen = '/follow-ups-screen';
  static const String remindersScreen = '/reminders-screen';
  static const String employeesScreen = '/employees-screen';
  static const String templatesScreen = '/templates-screen';
  static const String videoSessionScreen = '/video-session-screen';
  static const String importantDatesScreen = '/important-dates-screen';
  static const String assignLeadsScreen = '/assign-leads-screen';
  static const String assignedTasksScreen = '/assigned-tasks-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppTheme.backgroundLight,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppTheme.error),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'An unexpected error occurred',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboardScreen),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  ),
  routes: [
    // Splash — entry point
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.welcomeScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
    GoRoute(
      path: AppRoutes.signUpLoginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AnbuLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPasswordScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.buyProductScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const BuyProductScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
    GoRoute(
      path: AppRoutes.createAccountScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CreateAccountScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.callsPermissionScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CallsPermissionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.simSelectionScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SimSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Standalone push routes
    GoRoute(
      path: AppRoutes.addLeadScreen,
      pageBuilder: (context, state) {
        // Support editing existing lead via extra: {'editLead': leadMap}
        final extra = state.extra;
        Map<String, dynamic>? editLead;
        if (extra is Map<String, dynamic> && extra.containsKey('editLead')) {
          editLead = extra['editLead'] as Map<String, dynamic>?;
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: AddLeadScreen(editLead: editLead),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(0, 1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notificationsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.leadDetailScreen,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final lead = extra is LeadModel
            ? extra
            : LeadModel.fromMap(extra as Map<String, dynamic>);
        return CustomTransitionPage(
          key: state.pageKey,
          child: LeadDetailScreen(lead: lead),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(1.0, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: const Duration(milliseconds: 320),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.interestDetailScreen,
      pageBuilder: (context, state) {
        final interest = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: InterestDetailScreen(interest: interest),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(1.0, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: const Duration(milliseconds: 320),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.settingsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.profileScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.customersScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CustomersScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.interestsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const InterestsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.analyticsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AnalyticsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.sessionsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SessionsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.followUpsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const FollowUpsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.remindersScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RemindersScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.employeesScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const EmployeesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.templatesScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TemplatesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.importantDatesScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ImportantDatesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.assignLeadsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AssignLeadsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.assignedTasksScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AssignedTasksScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: AppRoutes.videoSessionScreen,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: VideoSessionScreen(
            customerName: extra?['customerName'] as String?,
            customerPhone: extra?['customerPhone'] as String?,
            sessionTitle: extra?['sessionTitle'] as String?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(0, 1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
      },
    ),
    // Main app shell — 4 tabs: Dashboard | Leads | Logs | Settings
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboardScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.leadsListScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LeadsListScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.logsScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LogsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settingsShellScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
