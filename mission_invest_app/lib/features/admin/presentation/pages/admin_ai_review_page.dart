import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/admin_provider.dart';

class AdminAiReviewPage extends ConsumerStatefulWidget {
  const AdminAiReviewPage({super.key});

  @override
  ConsumerState<AdminAiReviewPage> createState() => _AdminAiReviewPageState();
}

class _AdminAiReviewPageState extends ConsumerState<AdminAiReviewPage> {
  bool _flaggedOnly = false;

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(
      _flaggedOnly ? flaggedAiLogsProvider : aiLogsProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('AI Review')),
      body: Column(
        children: [
          // ---------- Filter toggle ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('All')),
                ButtonSegment(value: true, label: Text('Flagged Only')),
              ],
              selected: {_flaggedOnly},
              onSelectionChanged: (selection) {
                setState(() => _flaggedOnly = selection.first);
              },
            ),
          ),

          // ---------- Log list ----------
          Expanded(
            child: logsAsync.when(
              loading: () => const AppLoading(),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(
                  _flaggedOnly ? flaggedAiLogsProvider : aiLogsProvider,
                ),
              ),
              data: (logs) {
                if (logs.isEmpty) {
                  return Center(
                    child: Text(
                      _flaggedOnly
                          ? 'No flagged AI logs.'
                          : 'No AI logs yet.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) =>
                      _AiLogCard(log: logs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual log card
// ---------------------------------------------------------------------------

class _AiLogCard extends ConsumerWidget {
  final Map<String, dynamic> log;

  const _AiLogCard({required this.log});

  static const _typeColors = {
    'nudge': Colors.blue,
    'prediction': Colors.purple,
    'adapt': Colors.orange,
    'motivation': Colors.green,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = (log['type'] as String?) ?? 'unknown';
    final userId = (log['userId'] as String?) ?? '-';
    final flagged = (log['flagged'] as bool?) ?? false;
    final prompt = (log['prompt'] as String?) ?? '';
    final response = (log['response'] as String?) ?? '';
    final createdAt = log['createdAt'] as String?;
    final chipColor = _typeColors[type] ?? Colors.grey;

    final formattedDate = _formatDate(createdAt);
    final truncatedUserId =
        userId.length > 8 ? '${userId.substring(0, 8)}...' : userId;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Chip(
          label: Text(
            type,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: chipColor,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        title: Text(
          truncatedUserId,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          formattedDate,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                flagged ? Icons.flag : Icons.flag_outlined,
                color: flagged
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
              tooltip: flagged ? 'Unflag' : 'Flag',
              onPressed: () => _toggleFlag(context, ref),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSection(context, 'Prompt', prompt),
                const SizedBox(height: 12),
                _buildSection(context, 'Response', response),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            text.isEmpty ? '(empty)' : text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _toggleFlag(BuildContext context, WidgetRef ref) {
    final logId = log['id'] as String;
    final currentFlagged = (log['flagged'] as bool?) ?? false;

    ref
        .read(adminRepositoryProvider)
        .flagAiLog(logId, !currentFlagged)
        .then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentFlagged ? 'Log unflagged' : 'Log flagged',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }).catchError((Object error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update flag: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoString;
    }
  }
}
