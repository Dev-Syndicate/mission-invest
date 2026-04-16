import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/missions/presentation/pages/mission_list_page.dart';
import '../features/missions/presentation/pages/mission_create_page.dart';
import '../features/missions/presentation/pages/mission_detail_page.dart';
import '../features/missions/presentation/pages/mission_edit_page.dart';
import '../features/contributions/presentation/pages/log_contribution_page.dart';
import '../features/contributions/presentation/pages/contribution_history_page.dart';
import '../features/rewards/presentation/pages/badges_page.dart';
import '../features/rewards/presentation/pages/certificate_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/notifications/presentation/pages/notification_settings_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/admin_users_page.dart';
import '../features/admin/presentation/pages/admin_analytics_page.dart';
import '../features/admin/presentation/pages/admin_templates_page.dart';
import '../features/admin/presentation/pages/admin_challenges_page.dart';
import '../features/admin/presentation/pages/admin_notifications_page.dart';
import '../features/admin/presentation/pages/admin_feature_flags_page.dart';
import '../features/admin/presentation/pages/admin_ai_review_page.dart';
import '../shared/widgets/bottom_nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  // TODO: Add redirect logic after Firebase Auth setup
  // redirect: (context, state) {
  //   final isLoggedIn = ...;
  //   final isAuthRoute = state.matchedLocation.startsWith('/auth');
  //   if (!isLoggedIn && !isAuthRoute) return '/auth/login';
  //   if (isLoggedIn && isAuthRoute) return '/';
  //   return null;
  // },
  routes: [
    // Auth routes
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/auth/login',
      name: 'login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      name: 'register',
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      name: 'forgotPassword',
      builder: (_, __) => const ForgotPasswordPage(),
    ),

    // Main app with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: '/missions',
          name: 'missionList',
          builder: (_, __) => const MissionListPage(),
        ),
        GoRoute(
          path: '/rewards',
          name: 'rewards',
          builder: (_, __) => const BadgesPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    ),

    // Full-screen mission routes
    GoRoute(
      path: '/missions/create',
      name: 'missionCreate',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const MissionCreatePage(),
    ),
    GoRoute(
      path: '/missions/:missionId',
      name: 'missionDetail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => MissionDetailPage(
        missionId: state.pathParameters['missionId']!,
      ),
    ),
    GoRoute(
      path: '/missions/:missionId/edit',
      name: 'missionEdit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => MissionEditPage(
        missionId: state.pathParameters['missionId']!,
      ),
    ),
    GoRoute(
      path: '/missions/:missionId/contribute',
      name: 'logContribution',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => LogContributionPage(
        missionId: state.pathParameters['missionId']!,
      ),
    ),
    GoRoute(
      path: '/missions/:missionId/history',
      name: 'contributionHistory',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => ContributionHistoryPage(
        missionId: state.pathParameters['missionId']!,
      ),
    ),
    GoRoute(
      path: '/missions/:missionId/certificate',
      name: 'certificate',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => CertificatePage(
        missionId: state.pathParameters['missionId']!,
      ),
    ),

    // Settings & notifications
    GoRoute(
      path: '/settings',
      name: 'settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notificationSettings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const NotificationSettingsPage(),
    ),

    // Admin routes
    GoRoute(
      path: '/admin',
      name: 'adminDashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminDashboardPage(),
      routes: [
        GoRoute(
          path: 'users',
          name: 'adminUsers',
          builder: (_, __) => const AdminUsersPage(),
        ),
        GoRoute(
          path: 'analytics',
          name: 'adminAnalytics',
          builder: (_, __) => const AdminAnalyticsPage(),
        ),
        GoRoute(
          path: 'templates',
          name: 'adminTemplates',
          builder: (_, __) => const AdminTemplatesPage(),
        ),
        GoRoute(
          path: 'challenges',
          name: 'adminChallenges',
          builder: (_, __) => const AdminChallengesPage(),
        ),
        GoRoute(
          path: 'notifications',
          name: 'adminNotifications',
          builder: (_, __) => const AdminNotificationsPage(),
        ),
        GoRoute(
          path: 'feature-flags',
          name: 'adminFeatureFlags',
          builder: (_, __) => const AdminFeatureFlagsPage(),
        ),
        GoRoute(
          path: 'ai-review',
          name: 'adminAiReview',
          builder: (_, __) => const AdminAiReviewPage(),
        ),
      ],
    ),
  ],
);
