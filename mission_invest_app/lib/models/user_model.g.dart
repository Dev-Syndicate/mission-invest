// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalMissionsCreated:
          (json['totalMissionsCreated'] as num?)?.toInt() ?? 0,
      totalMissionsCompleted:
          (json['totalMissionsCompleted'] as num?)?.toInt() ?? 0,
      currentGlobalStreak: (json['currentGlobalStreak'] as num?)?.toInt() ?? 0,
      longestGlobalStreak: (json['longestGlobalStreak'] as num?)?.toInt() ?? 0,
      totalSaved: (json['totalSaved'] as num?)?.toDouble() ?? 0,
      theme: json['theme'] as String? ?? 'dark',
      notificationTime: json['notificationTime'] as String? ?? '09:00',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      fcmToken: json['fcmToken'] as String?,
      isAdmin: json['isAdmin'] as bool? ?? false,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'phone': instance.phone,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'totalMissionsCreated': instance.totalMissionsCreated,
      'totalMissionsCompleted': instance.totalMissionsCompleted,
      'currentGlobalStreak': instance.currentGlobalStreak,
      'longestGlobalStreak': instance.longestGlobalStreak,
      'totalSaved': instance.totalSaved,
      'theme': instance.theme,
      'notificationTime': instance.notificationTime,
      'notificationsEnabled': instance.notificationsEnabled,
      'fcmToken': instance.fcmToken,
      'isAdmin': instance.isAdmin,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'onboardingCompleted': instance.onboardingCompleted,
    };
