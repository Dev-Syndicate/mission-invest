import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AdminTile(
            icon: Icons.people,
            title: 'Users',
            subtitle: 'View and manage users',
            onTap: () => context.goNamed('adminUsers'),
          ),
          _AdminTile(
            icon: Icons.analytics,
            title: 'Analytics',
            subtitle: 'DAU, retention, completion rates',
            onTap: () => context.goNamed('adminAnalytics'),
          ),
          _AdminTile(
            icon: Icons.category,
            title: 'Templates',
            subtitle: 'Manage mission templates',
            onTap: () => context.goNamed('adminTemplates'),
          ),
          _AdminTile(
            icon: Icons.emoji_events,
            title: 'Challenges',
            subtitle: 'Platform-wide savings challenges',
            onTap: () => context.goNamed('adminChallenges'),
          ),
          _AdminTile(
            icon: Icons.notifications,
            title: 'Broadcast',
            subtitle: 'Send push notifications',
            onTap: () => context.goNamed('adminNotifications'),
          ),
          _AdminTile(
            icon: Icons.toggle_on,
            title: 'Feature Flags',
            subtitle: 'Toggle features on/off',
            onTap: () => context.goNamed('adminFeatureFlags'),
          ),
          _AdminTile(
            icon: Icons.smart_toy,
            title: 'AI Review',
            subtitle: 'Review AI-generated messages',
            onTap: () => context.goNamed('adminAiReview'),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
