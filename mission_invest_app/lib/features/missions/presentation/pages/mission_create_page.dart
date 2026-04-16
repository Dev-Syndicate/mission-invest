import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/category_selector.dart';

class MissionCreatePage extends ConsumerStatefulWidget {
  const MissionCreatePage({super.key});

  @override
  ConsumerState<MissionCreatePage> createState() => _MissionCreatePageState();
}

class _MissionCreatePageState extends ConsumerState<MissionCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  final _motivationController = TextEditingController();
  String _selectedCategory = 'trip';
  String _frequency = 'daily';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _durationController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  double? get _calculatedDaily {
    final amount = double.tryParse(_amountController.text);
    final days = int.tryParse(_durationController.text);
    if (amount == null || days == null || days == 0) return null;
    return _frequency == 'daily' ? amount / days : amount / (days / 7).ceil();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Call mission create provider
    setState(() => _isLoading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Mission')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AppTextField(
              label: 'Mission Name',
              hint: 'e.g., Goa Trip',
              controller: _titleController,
              validator: Validators.missionTitle,
              prefixIcon: const Icon(Icons.flag_outlined),
            ),
            const SizedBox(height: 20),
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            CategorySelector(
              selected: _selectedCategory,
              onSelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Target Amount (\u20B9)',
              controller: _amountController,
              validator: Validators.targetAmount,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.currency_rupee),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Duration (days)',
              hint: '10 - 180 days',
              controller: _durationController,
              validator: Validators.duration,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.calendar_today),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'daily', label: Text('Daily')),
                ButtonSegment(value: 'weekly', label: Text('Weekly')),
              ],
              selected: {_frequency},
              onSelectionChanged: (v) =>
                  setState(() => _frequency = v.first),
            ),
            if (_calculatedDaily != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 12),
                      Text(
                        _frequency == 'daily'
                            ? '\u20B9${_calculatedDaily!.toStringAsFixed(0)}/day'
                            : '\u20B9${_calculatedDaily!.toStringAsFixed(0)}/week',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            AppTextField(
              label: 'Motivation Message (optional)',
              hint: 'No excuses. You got this.',
              controller: _motivationController,
              maxLines: 2,
              prefixIcon: const Icon(Icons.format_quote),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Launch Mission',
              onPressed: _handleCreate,
              isLoading: _isLoading,
              icon: Icons.rocket_launch,
            ),
          ],
        ),
      ),
    );
  }
}
