import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/admin_provider.dart';

class AdminNotificationsPage extends ConsumerStatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  ConsumerState<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState
    extends ConsumerState<AdminNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  // Segment dropdown state
  static const _segments = <String, String?>{
    'All Users': null,
    'Active Savers': 'active',
    'Inactive': 'inactive',
    'New Users': 'new',
  };
  String _selectedSegmentLabel = 'All Users';

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Broadcast'),
        content: Text(
          'Send notification to $_selectedSegmentLabel?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSending = true);

    try {
      await ref.read(adminRepositoryProvider).sendBroadcast(
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
            segment: _segments[_selectedSegmentLabel],
          );

      if (!mounted) return;
      _titleController.clear();
      _bodyController.clear();
      setState(() => _selectedSegmentLabel = 'All Users');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Broadcast sent successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send broadcast: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleText = _titleController.text.trim();
    final bodyText = _bodyController.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Broadcast Notifications')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Title field ---
              AppTextField(
                label: 'Title',
                hint: 'Notification title',
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Body field ---
              AppTextField(
                label: 'Body',
                hint: 'Notification body text',
                controller: _bodyController,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Body is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Segment dropdown ---
              DropdownButtonFormField<String>(
                initialValue: _selectedSegmentLabel,
                decoration: InputDecoration(
                  labelText: 'Target Segment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: _segments.keys
                    .map(
                      (label) => DropdownMenuItem<String>(
                        value: label,
                        child: Text(label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSegmentLabel = value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // --- Preview card ---
              Text(
                'Preview',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleText.isNotEmpty
                                  ? titleText
                                  : 'Notification Title',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: titleText.isNotEmpty
                                    ? null
                                    : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bodyText.isNotEmpty
                                  ? bodyText
                                  : 'Notification body text will appear here',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: bodyText.isNotEmpty
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Send button ---
              AppButton(
                label: 'Send Broadcast',
                icon: Icons.send,
                isLoading: _isSending,
                onPressed: _isSending ? null : _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
