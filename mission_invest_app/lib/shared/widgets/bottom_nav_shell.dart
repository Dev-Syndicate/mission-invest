import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/providers/home_provider.dart';

class BottomNavShell extends ConsumerWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  int _adminIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/admin') return 0;
    if (location.startsWith('/admin/users')) return 1;
    if (location.startsWith('/admin/analytics')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  int _userIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/') return 0;
    if (location.startsWith('/missions')) return 1;
    if (location.startsWith('/rewards')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final isAdmin = userProfile.valueOrNull?.isAdmin ?? false;

    final selectedIndex =
        isAdmin ? _adminIndex(context) : _userIndex(context);

    final destinations =
        isAdmin ? _adminDestinations : _userDestinations;

    void onTap(int index) {
      if (isAdmin) {
        switch (index) {
          case 0: context.go('/admin');
          case 1: context.go('/admin/users');
          case 2: context.go('/admin/analytics');
          case 3: context.go('/profile');
        }
      } else {
        switch (index) {
          case 0: context.go('/');
          case 1: context.go('/missions');
          case 2: context.go('/rewards');
          case 3: context.go('/profile');
        }
      }
    }

    return Stack(
      children: [
        child,
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: SafeArea(
            top: false,
            child: _FloatingNavBar(
            selectedIndex: selectedIndex,
            destinations: destinations,
            onTap: onTap,
          ),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const _adminDestinations = [
  _NavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard'),
  _NavItem(
      icon: Icons.people_outlined,
      selectedIcon: Icons.people,
      label: 'Users'),
  _NavItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Analytics'),
  _NavItem(
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
      label: 'Profile'),
];

const _userDestinations = [
  _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home'),
  _NavItem(
      icon: Icons.flag_outlined,
      selectedIcon: Icons.flag_rounded,
      label: 'Missions'),
  _NavItem(
      icon: Icons.emoji_events_outlined,
      selectedIcon: Icons.emoji_events_rounded,
      label: 'Rewards'),
  _NavItem(
      icon: Icons.person_outlined,
      selectedIcon: Icons.person_rounded,
      label: 'Profile'),
];

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> destinations;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.destinations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xE6111111)
            : const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 20),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: destinations.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          return _NavBarItem(
            icon: isSelected ? item.selectedIcon : item.icon,
            label: item.label,
            isSelected: isSelected,
            onTap: () => onTap(index),
          );
        }).toList(),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? primary.withAlpha(25) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? primary
                    : theme.colorScheme.onSurface.withAlpha(120),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? primary
                    : theme.colorScheme.onSurface.withAlpha(120),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
