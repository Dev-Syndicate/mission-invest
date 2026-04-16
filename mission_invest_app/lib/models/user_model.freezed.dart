// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get totalMissionsCreated => throw _privateConstructorUsedError;
  int get totalMissionsCompleted => throw _privateConstructorUsedError;
  int get currentGlobalStreak => throw _privateConstructorUsedError;
  int get longestGlobalStreak => throw _privateConstructorUsedError;
  double get totalSaved => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  String get notificationTime => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  bool get onboardingCompleted => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String uid,
    String displayName,
    String email,
    String? photoUrl,
    String? phone,
    DateTime createdAt,
    DateTime updatedAt,
    int totalMissionsCreated,
    int totalMissionsCompleted,
    int currentGlobalStreak,
    int longestGlobalStreak,
    double totalSaved,
    String theme,
    String notificationTime,
    bool notificationsEnabled,
    String? fcmToken,
    bool isAdmin,
    DateTime? lastActiveAt,
    bool onboardingCompleted,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalMissionsCreated = null,
    Object? totalMissionsCompleted = null,
    Object? currentGlobalStreak = null,
    Object? longestGlobalStreak = null,
    Object? totalSaved = null,
    Object? theme = null,
    Object? notificationTime = null,
    Object? notificationsEnabled = null,
    Object? fcmToken = freezed,
    Object? isAdmin = null,
    Object? lastActiveAt = freezed,
    Object? onboardingCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalMissionsCreated: null == totalMissionsCreated
                ? _value.totalMissionsCreated
                : totalMissionsCreated // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMissionsCompleted: null == totalMissionsCompleted
                ? _value.totalMissionsCompleted
                : totalMissionsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            currentGlobalStreak: null == currentGlobalStreak
                ? _value.currentGlobalStreak
                : currentGlobalStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestGlobalStreak: null == longestGlobalStreak
                ? _value.longestGlobalStreak
                : longestGlobalStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSaved: null == totalSaved
                ? _value.totalSaved
                : totalSaved // ignore: cast_nullable_to_non_nullable
                      as double,
            theme: null == theme
                ? _value.theme
                : theme // ignore: cast_nullable_to_non_nullable
                      as String,
            notificationTime: null == notificationTime
                ? _value.notificationTime
                : notificationTime // ignore: cast_nullable_to_non_nullable
                      as String,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            fcmToken: freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAdmin: null == isAdmin
                ? _value.isAdmin
                : isAdmin // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastActiveAt: freezed == lastActiveAt
                ? _value.lastActiveAt
                : lastActiveAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            onboardingCompleted: null == onboardingCompleted
                ? _value.onboardingCompleted
                : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String displayName,
    String email,
    String? photoUrl,
    String? phone,
    DateTime createdAt,
    DateTime updatedAt,
    int totalMissionsCreated,
    int totalMissionsCompleted,
    int currentGlobalStreak,
    int longestGlobalStreak,
    double totalSaved,
    String theme,
    String notificationTime,
    bool notificationsEnabled,
    String? fcmToken,
    bool isAdmin,
    DateTime? lastActiveAt,
    bool onboardingCompleted,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalMissionsCreated = null,
    Object? totalMissionsCompleted = null,
    Object? currentGlobalStreak = null,
    Object? longestGlobalStreak = null,
    Object? totalSaved = null,
    Object? theme = null,
    Object? notificationTime = null,
    Object? notificationsEnabled = null,
    Object? fcmToken = freezed,
    Object? isAdmin = null,
    Object? lastActiveAt = freezed,
    Object? onboardingCompleted = null,
  }) {
    return _then(
      _$UserModelImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalMissionsCreated: null == totalMissionsCreated
            ? _value.totalMissionsCreated
            : totalMissionsCreated // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMissionsCompleted: null == totalMissionsCompleted
            ? _value.totalMissionsCompleted
            : totalMissionsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        currentGlobalStreak: null == currentGlobalStreak
            ? _value.currentGlobalStreak
            : currentGlobalStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestGlobalStreak: null == longestGlobalStreak
            ? _value.longestGlobalStreak
            : longestGlobalStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSaved: null == totalSaved
            ? _value.totalSaved
            : totalSaved // ignore: cast_nullable_to_non_nullable
                  as double,
        theme: null == theme
            ? _value.theme
            : theme // ignore: cast_nullable_to_non_nullable
                  as String,
        notificationTime: null == notificationTime
            ? _value.notificationTime
            : notificationTime // ignore: cast_nullable_to_non_nullable
                  as String,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        fcmToken: freezed == fcmToken
            ? _value.fcmToken
            : fcmToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAdmin: null == isAdmin
            ? _value.isAdmin
            : isAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastActiveAt: freezed == lastActiveAt
            ? _value.lastActiveAt
            : lastActiveAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        onboardingCompleted: null == onboardingCompleted
            ? _value.onboardingCompleted
            : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.totalMissionsCreated = 0,
    this.totalMissionsCompleted = 0,
    this.currentGlobalStreak = 0,
    this.longestGlobalStreak = 0,
    this.totalSaved = 0,
    this.theme = 'dark',
    this.notificationTime = '09:00',
    this.notificationsEnabled = true,
    this.fcmToken,
    this.isAdmin = false,
    this.lastActiveAt,
    this.onboardingCompleted = false,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String? photoUrl;
  @override
  final String? phone;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int totalMissionsCreated;
  @override
  @JsonKey()
  final int totalMissionsCompleted;
  @override
  @JsonKey()
  final int currentGlobalStreak;
  @override
  @JsonKey()
  final int longestGlobalStreak;
  @override
  @JsonKey()
  final double totalSaved;
  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final String notificationTime;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  final String? fcmToken;
  @override
  @JsonKey()
  final bool isAdmin;
  @override
  final DateTime? lastActiveAt;
  @override
  @JsonKey()
  final bool onboardingCompleted;

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email, photoUrl: $photoUrl, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt, totalMissionsCreated: $totalMissionsCreated, totalMissionsCompleted: $totalMissionsCompleted, currentGlobalStreak: $currentGlobalStreak, longestGlobalStreak: $longestGlobalStreak, totalSaved: $totalSaved, theme: $theme, notificationTime: $notificationTime, notificationsEnabled: $notificationsEnabled, fcmToken: $fcmToken, isAdmin: $isAdmin, lastActiveAt: $lastActiveAt, onboardingCompleted: $onboardingCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalMissionsCreated, totalMissionsCreated) ||
                other.totalMissionsCreated == totalMissionsCreated) &&
            (identical(other.totalMissionsCompleted, totalMissionsCompleted) ||
                other.totalMissionsCompleted == totalMissionsCompleted) &&
            (identical(other.currentGlobalStreak, currentGlobalStreak) ||
                other.currentGlobalStreak == currentGlobalStreak) &&
            (identical(other.longestGlobalStreak, longestGlobalStreak) ||
                other.longestGlobalStreak == longestGlobalStreak) &&
            (identical(other.totalSaved, totalSaved) ||
                other.totalSaved == totalSaved) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.notificationTime, notificationTime) ||
                other.notificationTime == notificationTime) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    uid,
    displayName,
    email,
    photoUrl,
    phone,
    createdAt,
    updatedAt,
    totalMissionsCreated,
    totalMissionsCompleted,
    currentGlobalStreak,
    longestGlobalStreak,
    totalSaved,
    theme,
    notificationTime,
    notificationsEnabled,
    fcmToken,
    isAdmin,
    lastActiveAt,
    onboardingCompleted,
  ]);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String uid,
    required final String displayName,
    required final String email,
    final String? photoUrl,
    final String? phone,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final int totalMissionsCreated,
    final int totalMissionsCompleted,
    final int currentGlobalStreak,
    final int longestGlobalStreak,
    final double totalSaved,
    final String theme,
    final String notificationTime,
    final bool notificationsEnabled,
    final String? fcmToken,
    final bool isAdmin,
    final DateTime? lastActiveAt,
    final bool onboardingCompleted,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get displayName;
  @override
  String get email;
  @override
  String? get photoUrl;
  @override
  String? get phone;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get totalMissionsCreated;
  @override
  int get totalMissionsCompleted;
  @override
  int get currentGlobalStreak;
  @override
  int get longestGlobalStreak;
  @override
  double get totalSaved;
  @override
  String get theme;
  @override
  String get notificationTime;
  @override
  bool get notificationsEnabled;
  @override
  String? get fcmToken;
  @override
  bool get isAdmin;
  @override
  DateTime? get lastActiveAt;
  @override
  bool get onboardingCompleted;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
