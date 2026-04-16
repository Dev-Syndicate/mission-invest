import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/admin_provider.dart';

const _categories = [
  'trip',
  'gadget',
  'vehicle',
  'emergency',
  'course',
  'gift',
  'custom',
];

class AdminTemplatesPage extends ConsumerWidget {
  const AdminTemplatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mission Templates')),
      body: templatesAsync.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(templatesStreamProvider),
        ),
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No templates yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first template',
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
            itemCount: templates.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final template = templates[index];
              return _TemplateCard(template: template);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTemplateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTemplateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _TemplateFormDialog(ref: ref),
    );
  }
}

class _TemplateCard extends ConsumerWidget {
  final Map<String, dynamic> template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final title = template['title'] as String? ?? 'Untitled';
    final description = template['description'] as String? ?? '';
    final category = template['category'] as String? ?? '';
    final targetAmount = template['targetAmount'];
    final durationDays = template['durationDays'];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Edit',
                  onPressed: () => _showEditDialog(context, ref),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (category.isNotEmpty)
                  _InfoChip(
                    icon: Icons.category_outlined,
                    label: category[0].toUpperCase() + category.substring(1),
                  ),
                if (targetAmount != null)
                  _InfoChip(
                    icon: Icons.attach_money,
                    label: _formatAmount(targetAmount),
                  ),
                if (durationDays != null)
                  _InfoChip(
                    icon: Icons.schedule_outlined,
                    label: '$durationDays days',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    final value = amount is num ? amount.toDouble() : double.tryParse(amount.toString()) ?? 0;
    if (value == value.toInt().toDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _TemplateFormDialog(
        ref: ref,
        existingTemplate: template,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final templateId = template['id'] as String;
    final title = template['title'] as String? ?? 'this template';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                final repo = ref.read(adminRepositoryProvider);
                await repo.deleteTemplate(templateId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Template deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateFormDialog extends StatefulWidget {
  final WidgetRef ref;
  final Map<String, dynamic>? existingTemplate;

  const _TemplateFormDialog({
    required this.ref,
    this.existingTemplate,
  });

  @override
  State<_TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends State<_TemplateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _durationController;
  late String _selectedCategory;
  bool _isSaving = false;

  bool get _isEditing => widget.existingTemplate != null;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTemplate;
    _titleController = TextEditingController(text: t?['title'] as String? ?? '');
    _descriptionController =
        TextEditingController(text: t?['description'] as String? ?? '');
    _targetAmountController = TextEditingController(
      text: t?['targetAmount'] != null ? t!['targetAmount'].toString() : '',
    );
    _durationController = TextEditingController(
      text: t?['durationDays'] != null ? t!['durationDays'].toString() : '',
    );
    _selectedCategory = t?['category'] as String? ?? _categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Template' : 'Create Template'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Title',
                  controller: _titleController,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c[0].toUpperCase() + c.substring(1),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedCategory = v);
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Target Amount',
                  controller: _targetAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Target amount is required';
                    }
                    if (double.tryParse(v.trim()) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Duration (days)',
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.schedule_outlined),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Duration is required';
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'Enter a whole number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: _isEditing ? 'Update' : 'Create',
          isLoading: _isSaving,
          width: 120,
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final data = <String, dynamic>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'targetAmount': double.parse(_targetAmountController.text.trim()),
      'durationDays': int.parse(_durationController.text.trim()),
    };

    try {
      final repo = widget.ref.read(adminRepositoryProvider);
      if (_isEditing) {
        final id = widget.existingTemplate!['id'] as String;
        await repo.updateTemplate(id, data);
      } else {
        await repo.createTemplate(data);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Template updated' : 'Template created',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
