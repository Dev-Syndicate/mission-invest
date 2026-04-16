import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../providers/contribution_provider.dart';

class LogContributionPage extends ConsumerStatefulWidget {
  final String missionId;

  const LogContributionPage({super.key, required this.missionId});

  @override
  ConsumerState<LogContributionPage> createState() =>
      _LogContributionPageState();
}

class _LogContributionPageState extends ConsumerState<LogContributionPage> {
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _isLoading = true);

    final result =
        await ref.read(contributionFlowProvider.notifier).logContribution(
              missionId: widget.missionId,
              userId: userId,
              amount: amount,
              note: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result != null) {
      // Show success feedback
      final message = result.missionCompleted
          ? 'Mission completed! Congratulations!'
          : 'Saved \u20B9${amount.toStringAsFixed(0)} successfully!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              result.missionCompleted ? Colors.amber : Colors.green,
        ),
      );

      // Show badge notifications if any
      for (final badge in result.newBadges) {
        if (!mounted) break;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Badge earned: ${badge.badgeType}!'),
            backgroundColor: Colors.deepPurple,
          ),
        );
      }

      Navigator.of(context).pop();
    } else {
      final flowState = ref.read(contributionFlowProvider);
      final errorMsg = flowState.hasError
          ? flowState.error.toString()
          : 'Failed to save contribution. Please try again.';
      debugPrint('Contribution error: $errorMsg');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Contribution')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
      ),
    );
  }
}
