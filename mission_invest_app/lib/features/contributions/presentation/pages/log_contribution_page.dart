import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';

class LogContributionPage extends ConsumerStatefulWidget {
  final String missionId;

  const LogContributionPage({super.key, required this.missionId});

  @override
  ConsumerState<LogContributionPage> createState() =>
      _LogContributionPageState();
}

class _LogContributionPageState extends ConsumerState<LogContributionPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final error = Validators.contributionAmount(_amountController.text);
    if (error != null) return;
    setState(() => _isLoading = true);
    // TODO: Call contribution provider to log contribution
    setState(() => _isLoading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Contribution')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How much did you save today?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Amount (\u20B9)',
              controller: _amountController,
              validator: Validators.contributionAmount,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.currency_rupee),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Note (optional)',
              hint: 'What motivated you today?',
              controller: _noteController,
              maxLines: 2,
              prefixIcon: const Icon(Icons.note_outlined),
            ),
            const Spacer(),
            AppButton(
              label: 'Save Contribution',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}
