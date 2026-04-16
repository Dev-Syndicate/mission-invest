import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? missionTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mission name is required';
    if (value.trim().length < 2) return 'Name is too short';
    if (value.trim().length > 50) return 'Name is too long (max 50)';
    return null;
  }

  static String? targetAmount(String? value) {
    if (value == null || value.isEmpty) return 'Target amount is required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Enter a valid number';
    if (amount < AppConstants.minTargetAmount) {
      return 'Minimum target is \u20B9${AppConstants.minTargetAmount.toInt()}';
    }
    return null;
  }

  static String? contributionAmount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Enter a valid number';
    if (amount < AppConstants.minContributionAmount) {
      return 'Minimum is \u20B9${AppConstants.minContributionAmount.toInt()}';
    }
    return null;
  }

  static String? duration(String? value) {
    if (value == null || value.isEmpty) return 'Duration is required';
    final days = int.tryParse(value);
    if (days == null) return 'Enter a valid number';
    if (days < AppConstants.minMissionDurationDays) {
      return 'Minimum ${AppConstants.minMissionDurationDays} days';
    }
    if (days > AppConstants.maxMissionDurationDays) {
      return 'Maximum ${AppConstants.maxMissionDurationDays} days';
    }
    return null;
  }
}
