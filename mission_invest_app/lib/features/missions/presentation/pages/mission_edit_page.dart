import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/repositories/mission_repository.dart';
import '../providers/mission_detail_provider.dart';
import '../widgets/category_selector.dart';

class MissionEditPage extends ConsumerStatefulWidget {
  final String missionId;

  const MissionEditPage({super.key, required this.missionId});

  @override
  ConsumerState<MissionEditPage> createState() => _MissionEditPageState();
}

class _MissionEditPageState extends ConsumerState<MissionEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'trip';
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _initFields(
    String title,
    double targetAmount,
    String category,
    DateTime endDate,
  ) {
    if (_initialized) return;
    _titleController.text = title;
    _amountController.text = targetAmount.toStringAsFixed(0);
    _selectedCategory = category;
    _endDate = endDate;
    _initialized = true;
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(missionRepositoryProvider);
      await repo.updateMission(widget.missionId, {
        'title': _titleController.text.trim(),
        'targetAmount': double.parse(_amountController.text.trim()),
        'category': _selectedCategory,
        'endDate': _endDate.toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mission updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update mission: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final missionAsync = ref.watch(missionDetailProvider(widget.missionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Mission')),
      body: missionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (mission) {
          if (mission == null) {
            return const Center(child: Text('Mission not found'));
          }

          _initFields(
            mission.title,
            mission.targetAmount,
            mission.category,
            mission.endDate,
          );

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                AppTextField(
                  label: 'Mission Name',
                  hint: 'e.g., Goa Trip',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a mission name';
                    }
                    return null;
                  },
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
                  onSelected: (cat) =>
                      setState(() => _selectedCategory = cat),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Target Amount (\u20B9)',
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a target amount';
                    }
                    final amount = double.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                const SizedBox(height: 20),
                Text(
                  'End Date',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickEndDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(_endDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Save Changes',
                  onPressed: _handleSave,
                  isLoading: _isLoading,
                  icon: Icons.save,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
