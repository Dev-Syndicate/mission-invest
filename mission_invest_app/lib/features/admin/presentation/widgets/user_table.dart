import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const UserTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No users found.'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: users.length,
      itemBuilder: (context, index) => _UserCard(user: users[index]),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = (user['displayName'] as String?) ?? 'Unknown';
    final email = (user['email'] as String?) ?? '';
    final xpTotal = user['xpTotal'] ?? 0;
    final streak = user['currentGlobalStreak'] ?? 0;
    final createdAt = _formatDate(user['createdAt']);
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                initial,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.star,
                        label: '$xpTotal XP',
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 10),
                      _InfoChip(
                        icon: Icons.local_fire_department,
                        label: '$streak day streak',
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (createdAt != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Joined',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    createdAt,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String? _formatDate(dynamic value) {
    if (value == null) return null;
    try {
      final date = DateTime.parse(value.toString());
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return null;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
