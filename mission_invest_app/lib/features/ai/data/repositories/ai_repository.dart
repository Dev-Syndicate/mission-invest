import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/nudge_response.dart';
import '../models/prediction_response.dart';
import '../models/adapt_response.dart';
import '../models/motivation_response.dart';

class AiRepository {
  final ApiClient _apiClient;

  AiRepository(this._apiClient);

  Future<NudgeResponse> getNudge({
    required String userId,
    required String missionId,
    required String missionTitle,
    required String trigger,
    required int currentStreak,
    required int missedDays,
    required int daysLeft,
    required double amountLeft,
    required double targetAmount,
    required double completionProbability,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.nudge,
      data: {
        'user_id': userId,
        'mission_id': missionId,
        'mission_title': missionTitle,
        'trigger': trigger,
        'current_streak': currentStreak,
        'missed_days': missedDays,
        'days_left': daysLeft,
        'amount_left': amountLeft,
        'target_amount': targetAmount,
        'completion_probability': completionProbability,
      },
    );
    return NudgeResponse.fromJson(response.data);
  }

  Future<PredictionResponse> getPrediction({
    required String missionId,
    required double streakRatio,
    required double amountRatio,
    required double dayRatio,
    required int missedDays,
    required int totalDays,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.predict,
      data: {
        'mission_id': missionId,
        'streak_ratio': streakRatio,
        'amount_ratio': amountRatio,
        'day_ratio': dayRatio,
        'missed_days': missedDays,
        'total_days': totalDays,
      },
    );
    return PredictionResponse.fromJson(response.data);
  }

  Future<AdaptResponse> getAdaptation({
    required String missionId,
    required String missionTitle,
    required double currentSaved,
    required int daysLeft,
    required double targetAmount,
    required double dailyTarget,
    required int currentStreak,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.adapt,
      data: {
        'mission_id': missionId,
        'mission_title': missionTitle,
        'current_saved': currentSaved,
        'days_left': daysLeft,
        'target_amount': targetAmount,
        'daily_target': dailyTarget,
        'current_streak': currentStreak,
      },
    );
    return AdaptResponse.fromJson(response.data);
  }

  Future<MotivationResponse> getMotivation({
    required String goalName,
    required double amountLeft,
    required int daysLeft,
    required int streak,
    required String category,
    String? userName,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.message,
      data: {
        'goal_name': goalName,
        'amount_left': amountLeft,
        'days_left': daysLeft,
        'streak': streak,
        'category': category,
        if (userName != null) 'user_name': userName,
      },
    );
    return MotivationResponse.fromJson(response.data);
  }
}
