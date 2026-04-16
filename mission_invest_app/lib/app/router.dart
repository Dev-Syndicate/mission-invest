import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/providers/home_provider.dart';
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
import '../features/rewards/presentation/pages/marketplace_page.dart';
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
import '../features/seasons/presentation/pages/seasons_page.dart';
import '../features/social/presentation/pages/share_milestone_page.dart';
import '../features/teams/presentation/pages/team_missions_list_page.dart';
import '../features/teams/presentation/pages/team_mission_page.dart';
import '../shared/widgets/bottom_nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userProfile = ref.watch(currentUserProfileProvider);
  final isAdmin = userProfile.valueOrNull?.isAdmin ?? false;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _RouterRefreshNotifier(ref, authStateChangesProvider, currentUserProfileProvider),
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final location = state.matchedLocation;
      final isAuthRoute = location.startsWith('/auth');
      final isOnboarding = location == '/onboarding';

      // While the auth state is loading, don't redirect.
      if (isLoading) return null;

      // Not authenticated → send to login (unless already on an auth page).
      if (!isLoggedIn && !isAuthRoute) return '/auth/login';

      // Authenticated but on an auth page → send to appropriate home.
      if (isLoggedIn && isAuthRoute) {
        return isAdmin ? '/admin' : '/';
      }

      // Authenticated user without a display name likely hasn't onboarded.
      if (isLoggedIn &&
          !isOnboarding &&
          !isAdmin &&
          (user.displayName == null || user.displayName!.isEmpty)) {
        return '/onboarding';
      }

      // Admin users should not access normal user routes.
      if (isLoggedIn && isAdmin) {
        final isUserRoute = location == '/' ||
            location.startsWith('/missions') ||
            location.startsWith('/rewards');
        if (isUserRoute) return '/admin';
      }

      // Normal users should not access admin routes.
      if (isLoggedIn && !isAdmin && location.startsWith('/admin')) {
        return '/';
      }

      return null;
    },
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
          GoRoute(
            path: '/admin',
            name: 'adminDashboard',
            builder: (_, __) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: '/admin/users',
            name: 'adminUsers',
            builder: (_, __) => const AdminUsersPage(),
          ),
          GoRoute(
            path: '/admin/analytics',
            name: 'adminAnalytics',
            builder: (_, __) => const AdminAnalyticsPage(),
          ),
        ],
      ),

      // Marketplace (full-screen)
      GoRoute(
        path: '/rewards/marketplace',
        name: 'marketplace',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const MarketplacePage(),
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

      // Seasons
      GoRoute(
        path: '/seasons',
        name: 'seasons',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const SeasonsPage(),
      ),

      // Social – share milestone
      GoRoute(
        path: '/share/:missionId',
        name: 'shareMilestone',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => ShareMilestonePage(
          missionId: state.pathParameters['missionId']!,
        ),
      ),

      // Team missions
      GoRoute(
        path: '/teams',
        name: 'teamMissions',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const TeamMissionsListPage(),
      ),
      GoRoute(
        path: '/teams/:teamId',
        name: 'teamMissionDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => TeamMissionPage(
          teamId: state.pathParameters['teamId']!,
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

      // Admin sub-routes (full-screen, no bottom nav)
      GoRoute(
        path: '/admin/templates',
        name: 'adminTemplates',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AdminTemplatesPage(),
      ),
      GoRoute(
        path: '/admin/challenges',
        name: 'adminChallenges',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AdminChallengesPage(),
      ),
      GoRoute(
        path: '/admin/notifications',
        name: 'adminNotifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AdminNotificationsPage(),
      ),
      GoRoute(
        path: '/admin/feature-flags',
        name: 'adminFeatureFlags',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AdminFeatureFlagsPage(),
      ),
      GoRoute(
        path: '/admin/ai-review',
        name: 'adminAiReview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AdminAiReviewPage(),
      ),
    ],
  );
});

/// A [ChangeNotifier] that triggers GoRouter refreshes whenever the watched
/// Riverpod provider emits a new value.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(
    Ref ref,
    StreamProvider<dynamic> authProvider,
    StreamProvider<dynamic> profileProvider,
  ) {
    _authSub = ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
    _profileSub = ref.listen(profileProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AsyncValue<dynamic>> _authSub;
  late final ProviderSubscription<AsyncValue<dynamic>> _profileSub;

  @override
  void dispose() {
    _authSub.close();
    _profileSub.close();
    super.dispose();
  }
}
