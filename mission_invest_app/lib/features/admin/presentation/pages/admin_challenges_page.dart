import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/admin_provider.dart';

class AdminChallengesPage extends ConsumerWidget {
  const AdminChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(adminChallengesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: challengesAsync.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(adminChallengesProvider),
        ),
        data: (challenges) {
          if (challenges.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No challenges yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create the first challenge',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _ChallengeCard(challenge: challenge);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _CreateChallengeDialog(ref: ref),
    );
  }
}

// ---------------------------------------------------------------------------
// Challenge Card
// ---------------------------------------------------------------------------

class _ChallengeCard extends ConsumerWidget {
  final Map<String, dynamic> challenge;

  const _ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final title = challenge['title'] as String? ?? 'Untitled';
    final description = challenge['description'] as String? ?? '';
    final targetAmount = challenge['targetAmount'];
    final participantCount = challenge['participantCount'] ?? 0;
    final isActive = challenge['isActive'] == true;
    final startDate = _parseDate(challenge['startDate']);
    final endDate = _parseDate(challenge['endDate']);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with active badge and delete button
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error, size: 20),
                  onPressed: () => _confirmDelete(context, ref),
                  tooltip: 'Delete challenge',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Info chips row
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                if (targetAmount != null)
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label:
                        'Target: \$${NumberFormat('#,##0').format(targetAmount)}',
                  ),
                if (startDate != null && endDate != null)
                  _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    label:
                        '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                  ),
                _InfoChip(
                  icon: Icons.people_outline,
                  label: '$participantCount participants',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Challenge'),
        content: Text(
          'Are you sure you want to delete "${challenge['title']}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(adminRepositoryProvider)
            .deleteChallenge(challenge['id'] as String);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Challenge deleted')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: $e')),
          );
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Info Chip
// ---------------------------------------------------------------------------

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Create Challenge Dialog
// ---------------------------------------------------------------------------

class _CreateChallengeDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _CreateChallengeDialog({required this.ref});

  @override
  ConsumerState<_CreateChallengeDialog> createState() =>
      _CreateChallengeDialogState();
}

class _CreateChallengeDialogState
    extends ConsumerState<_CreateChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'targetAmount': num.parse(_targetAmountController.text.trim()),
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'participantCount': 0,
        'isActive': true,
      };

      await widget.ref.read(adminRepositoryProvider).createChallenge(data);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge created')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return AlertDialog(
      title: const Text('New Challenge'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Title',
                  controller: _titleController,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Target Amount',
                  controller: _targetAmountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (num.tryParse(v.trim()) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _DatePickerTile(
                  label: 'Start Date',
                  value: _startDate != null
                      ? dateFormat.format(_startDate!)
                      : 'Select',
                  onTap: () => _pickDate(isStart: true),
                ),
                const SizedBox(height: 12),
                _DatePickerTile(
                  label: 'End Date',
                  value: _endDate != null
                      ? dateFormat.format(_endDate!)
                      : 'Select',
                  onTap: () => _pickDate(isStart: false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Create',
          isLoading: _isLoading,
          onPressed: _submit,
          width: 120,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Date Picker Tile
// ---------------------------------------------------------------------------

class _DatePickerTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
        ),
        child: Text(
          value,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
