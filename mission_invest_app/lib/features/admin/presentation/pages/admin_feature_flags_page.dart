import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/admin_provider.dart';

class AdminFeatureFlagsPage extends ConsumerWidget {
  const AdminFeatureFlagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flagsAsync = ref.watch(featureFlagsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Feature Flags')),
      body: flagsAsync.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: 'Failed to load feature flags.\n$error',
          onRetry: () => ref.invalidate(featureFlagsProvider),
        ),
        data: (flags) {
          if (flags.isEmpty) {
            return const Center(
              child: Text('No feature flags configured.'),
            );
          }

          final sorted = List<Map<String, dynamic>>.from(flags)
            ..sort((a, b) => (a['name'] as String? ?? '')
                .toLowerCase()
                .compareTo((b['name'] as String? ?? '').toLowerCase()));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final flag = sorted[index];
              final id = flag['id'] as String;
              final name = flag['name'] as String? ?? 'Unnamed';
              final description = flag['description'] as String? ?? '';
              final enabled = flag['enabled'] as bool? ?? false;

              return Card(
                child: SwitchListTile(
                  secondary: Icon(
                    Icons.circle,
                    size: 12,
                    color: enabled ? Colors.green : Colors.red,
                  ),
                  title: Text(name),
                  subtitle: description.isNotEmpty ? Text(description) : null,
                  value: enabled,
                  onChanged: (newValue) => _toggleFlag(
                    context,
                    ref,
                    id,
                    newValue,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleFlag(
    BuildContext context,
    WidgetRef ref,
    String flagId,
    bool enabled,
  ) async {
    try {
      await ref
          .read(adminRepositoryProvider)
          .toggleFeatureFlag(flagId, enabled);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Flag ${enabled ? 'enabled' : 'disabled'} successfully.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update flag: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
