import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/contract_model.dart';
import '../../data/models/story_suggestions.dart';
import '../providers/mission_create_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/contract_selector.dart';

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
  final _storyHeadlineController = TextEditingController();
  final _personalNoteController = TextEditingController();
  String _selectedCategory = 'trip';
  String _frequency = 'daily';
  String _selectedEmoji = '\u{2708}\u{FE0F}';
  ContractType _selectedContract = ContractType.none;
  bool _isLoading = false;

  static const _emojiOptions = [
    '\u{2708}\u{FE0F}', // plane
    '\u{1F4F1}', // phone
    '\u{1F697}', // car
    '\u{1F6D1}', // stop sign / emergency
    '\u{1F4DA}', // books
    '\u{1F381}', // gift
    '\u{1F3AF}', // target
    '\u{1F680}', // rocket
    '\u{1F4B0}', // money bag
    '\u{2B50}',  // star
    '\u{1F3E0}', // house
    '\u{1F4BB}', // laptop
    '\u{1F3C6}', // trophy
    '\u{2764}\u{FE0F}', // heart
    '\u{1F389}', // party
  ];

  @override
  void initState() {
    super.initState();
    // Auto-fill story headline from default category
    _storyHeadlineController.text = storySuggestions[_selectedCategory] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _durationController.dispose();
    _motivationController.dispose();
    _storyHeadlineController.dispose();
    _personalNoteController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String cat) {
    setState(() {
      _selectedCategory = cat;
      // Auto-fill story headline if the user hasn't customized it
      final currentText = _storyHeadlineController.text;
      final wasAutoFilled = storySuggestions.values.contains(currentText) ||
          currentText.isEmpty;
      if (wasAutoFilled) {
        _storyHeadlineController.text = storySuggestions[cat] ?? '';
      }
    });
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

    final docId = await ref.read(missionCreateProvider.notifier).createMission(
          title: _titleController.text.trim(),
          category: _selectedCategory,
          targetAmount: double.parse(_amountController.text.trim()),
          durationDays: int.parse(_durationController.text.trim()),
          frequency: _frequency,
          motivationMessage: _motivationController.text.trim().isEmpty
              ? null
              : _motivationController.text.trim(),
          storyHeadline: _storyHeadlineController.text.trim().isEmpty
              ? null
              : _storyHeadlineController.text.trim(),
          personalNote: _personalNoteController.text.trim().isEmpty
              ? null
              : _personalNoteController.text.trim(),
          missionEmoji: _selectedEmoji,
          contractType: _selectedContract.name,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (docId != null) {
      context.pop();
    } else {
      final error = ref.read(missionCreateProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.hasError
                ? error.error.toString()
                : 'Failed to create mission',
          ),
        ),
      );
    }
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
              onSelected: _onCategoryChanged,
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
            const SizedBox(height: 28),

            // ── Why This Mission Matters ──
            Text(
              'Why This Mission Matters',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a personal story to stay motivated.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                  ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Story Headline',
              hint: 'Why does this mission matter to you?',
              controller: _storyHeadlineController,
              maxLines: 2,
              prefixIcon: const Icon(Icons.auto_stories),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Personal Note (optional)',
              hint: 'A short note to your future self...',
              controller: _personalNoteController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.note_outlined),
            ),
            const SizedBox(height: 16),

            // Emoji picker
            Text(
              'Mission Emoji',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojiOptions.map((emoji) {
                final isSelected = _selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(20)
                          : null,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // ── Commit Contract ──
            Text(
              'Commit Contract',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Optional: lock in a commitment to boost your discipline.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                  ),
            ),
            const SizedBox(height: 12),
            ContractSelector(
              selected: _selectedContract,
              onSelected: (type) =>
                  setState(() => _selectedContract = type),
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
