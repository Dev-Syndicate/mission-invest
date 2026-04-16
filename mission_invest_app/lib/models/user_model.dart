import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phone,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int totalMissionsCreated,
    @Default(0) int totalMissionsCompleted,
    @Default(0) int currentGlobalStreak,
    @Default(0) int longestGlobalStreak,
    @Default(0) double totalSaved,
    @Default('dark') String theme,
    @Default('09:00') String notificationTime,
    @Default(true) bool notificationsEnabled,
    String? fcmToken,
    @Default(false) bool isAdmin,
    DateTime? lastActiveAt,
    @Default(false) bool onboardingCompleted,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
