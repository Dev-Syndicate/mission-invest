// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) {
  return _MissionModel.fromJson(json);
}

/// @nodoc
mixin _$MissionModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get savedAmount => throw _privateConstructorUsedError;
  double get dailyTarget => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get durationDays => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastContributionDate => throw _privateConstructorUsedError;
  int get missedDays => throw _privateConstructorUsedError;
  bool get recoveryUsedThisWeek => throw _privateConstructorUsedError;
  DateTime? get recoveryWeekStart => throw _privateConstructorUsedError;
  double get completionProbability => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get visionImageUrl => throw _privateConstructorUsedError;
  String? get motivationMessage =>
      throw _privateConstructorUsedError; // Story card fields
  String? get storyHeadline => throw _privateConstructorUsedError;
  String? get personalNote => throw _privateConstructorUsedError;
  String? get missionEmoji =>
      throw _privateConstructorUsedError; // Commit contract fields
  String get contractType => throw _privateConstructorUsedError;
  String get contractStatus => throw _privateConstructorUsedError;
  DateTime? get contractRecoveryDeadline => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this MissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionModelCopyWith<MissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionModelCopyWith<$Res> {
  factory $MissionModelCopyWith(
    MissionModel value,
    $Res Function(MissionModel) then,
  ) = _$MissionModelCopyWithImpl<$Res, MissionModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String category,
    double targetAmount,
    double savedAmount,
    double dailyTarget,
    String frequency,
    DateTime startDate,
    DateTime endDate,
    int durationDays,
    int currentStreak,
    int longestStreak,
    DateTime? lastContributionDate,
    int missedDays,
    bool recoveryUsedThisWeek,
    DateTime? recoveryWeekStart,
    double completionProbability,
    String status,
    String? visionImageUrl,
    String? motivationMessage,
    String? storyHeadline,
    String? personalNote,
    String? missionEmoji,
    String contractType,
    String contractStatus,
    DateTime? contractRecoveryDeadline,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$MissionModelCopyWithImpl<$Res, $Val extends MissionModel>
    implements $MissionModelCopyWith<$Res> {
  _$MissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? category = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? dailyTarget = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? durationDays = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastContributionDate = freezed,
    Object? missedDays = null,
    Object? recoveryUsedThisWeek = null,
    Object? recoveryWeekStart = freezed,
    Object? completionProbability = null,
    Object? status = null,
    Object? visionImageUrl = freezed,
    Object? motivationMessage = freezed,
    Object? storyHeadline = freezed,
    Object? personalNote = freezed,
    Object? missionEmoji = freezed,
    Object? contractType = null,
    Object? contractStatus = null,
    Object? contractRecoveryDeadline = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            savedAmount: null == savedAmount
                ? _value.savedAmount
                : savedAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyTarget: null == dailyTarget
                ? _value.dailyTarget
                : dailyTarget // ignore: cast_nullable_to_non_nullable
                      as double,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationDays: null == durationDays
                ? _value.durationDays
                : durationDays // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastContributionDate: freezed == lastContributionDate
                ? _value.lastContributionDate
                : lastContributionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            missedDays: null == missedDays
                ? _value.missedDays
                : missedDays // ignore: cast_nullable_to_non_nullable
                      as int,
            recoveryUsedThisWeek: null == recoveryUsedThisWeek
                ? _value.recoveryUsedThisWeek
                : recoveryUsedThisWeek // ignore: cast_nullable_to_non_nullable
                      as bool,
            recoveryWeekStart: freezed == recoveryWeekStart
                ? _value.recoveryWeekStart
                : recoveryWeekStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completionProbability: null == completionProbability
                ? _value.completionProbability
                : completionProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            visionImageUrl: freezed == visionImageUrl
                ? _value.visionImageUrl
                : visionImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            motivationMessage: freezed == motivationMessage
                ? _value.motivationMessage
                : motivationMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            storyHeadline: freezed == storyHeadline
                ? _value.storyHeadline
                : storyHeadline // ignore: cast_nullable_to_non_nullable
                      as String?,
            personalNote: freezed == personalNote
                ? _value.personalNote
                : personalNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            missionEmoji: freezed == missionEmoji
                ? _value.missionEmoji
                : missionEmoji // ignore: cast_nullable_to_non_nullable
                      as String?,
            contractType: null == contractType
                ? _value.contractType
                : contractType // ignore: cast_nullable_to_non_nullable
                      as String,
            contractStatus: null == contractStatus
                ? _value.contractStatus
                : contractStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            contractRecoveryDeadline: freezed == contractRecoveryDeadline
                ? _value.contractRecoveryDeadline
                : contractRecoveryDeadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MissionModelImplCopyWith<$Res>
    implements $MissionModelCopyWith<$Res> {
  factory _$$MissionModelImplCopyWith(
    _$MissionModelImpl value,
    $Res Function(_$MissionModelImpl) then,
  ) = __$$MissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String category,
    double targetAmount,
    double savedAmount,
    double dailyTarget,
    String frequency,
    DateTime startDate,
    DateTime endDate,
    int durationDays,
    int currentStreak,
    int longestStreak,
    DateTime? lastContributionDate,
    int missedDays,
    bool recoveryUsedThisWeek,
    DateTime? recoveryWeekStart,
    double completionProbability,
    String status,
    String? visionImageUrl,
    String? motivationMessage,
    String? storyHeadline,
    String? personalNote,
    String? missionEmoji,
    String contractType,
    String contractStatus,
    DateTime? contractRecoveryDeadline,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$MissionModelImplCopyWithImpl<$Res>
    extends _$MissionModelCopyWithImpl<$Res, _$MissionModelImpl>
    implements _$$MissionModelImplCopyWith<$Res> {
  __$$MissionModelImplCopyWithImpl(
    _$MissionModelImpl _value,
    $Res Function(_$MissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? category = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? dailyTarget = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? durationDays = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastContributionDate = freezed,
    Object? missedDays = null,
    Object? recoveryUsedThisWeek = null,
    Object? recoveryWeekStart = freezed,
    Object? completionProbability = null,
    Object? status = null,
    Object? visionImageUrl = freezed,
    Object? motivationMessage = freezed,
    Object? storyHeadline = freezed,
    Object? personalNote = freezed,
    Object? missionEmoji = freezed,
    Object? contractType = null,
    Object? contractStatus = null,
    Object? contractRecoveryDeadline = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$MissionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        savedAmount: null == savedAmount
            ? _value.savedAmount
            : savedAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyTarget: null == dailyTarget
            ? _value.dailyTarget
            : dailyTarget // ignore: cast_nullable_to_non_nullable
                  as double,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationDays: null == durationDays
            ? _value.durationDays
            : durationDays // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastContributionDate: freezed == lastContributionDate
            ? _value.lastContributionDate
            : lastContributionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        missedDays: null == missedDays
            ? _value.missedDays
            : missedDays // ignore: cast_nullable_to_non_nullable
                  as int,
        recoveryUsedThisWeek: null == recoveryUsedThisWeek
            ? _value.recoveryUsedThisWeek
            : recoveryUsedThisWeek // ignore: cast_nullable_to_non_nullable
                  as bool,
        recoveryWeekStart: freezed == recoveryWeekStart
            ? _value.recoveryWeekStart
            : recoveryWeekStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completionProbability: null == completionProbability
            ? _value.completionProbability
            : completionProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        visionImageUrl: freezed == visionImageUrl
            ? _value.visionImageUrl
            : visionImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        motivationMessage: freezed == motivationMessage
            ? _value.motivationMessage
            : motivationMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        storyHeadline: freezed == storyHeadline
            ? _value.storyHeadline
            : storyHeadline // ignore: cast_nullable_to_non_nullable
                  as String?,
        personalNote: freezed == personalNote
            ? _value.personalNote
            : personalNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        missionEmoji: freezed == missionEmoji
            ? _value.missionEmoji
            : missionEmoji // ignore: cast_nullable_to_non_nullable
                  as String?,
        contractType: null == contractType
            ? _value.contractType
            : contractType // ignore: cast_nullable_to_non_nullable
                  as String,
        contractStatus: null == contractStatus
            ? _value.contractStatus
            : contractStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        contractRecoveryDeadline: freezed == contractRecoveryDeadline
            ? _value.contractRecoveryDeadline
            : contractRecoveryDeadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionModelImpl implements _MissionModel {
  const _$MissionModelImpl({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.targetAmount,
    this.savedAmount = 0,
    required this.dailyTarget,
    this.frequency = 'daily',
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastContributionDate,
    this.missedDays = 0,
    this.recoveryUsedThisWeek = false,
    this.recoveryWeekStart,
    this.completionProbability = 1.0,
    this.status = 'active',
    this.visionImageUrl,
    this.motivationMessage,
    this.storyHeadline,
    this.personalNote,
    this.missionEmoji,
    this.contractType = 'none',
    this.contractStatus = 'none',
    this.contractRecoveryDeadline,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory _$MissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String category;
  @override
  final double targetAmount;
  @override
  @JsonKey()
  final double savedAmount;
  @override
  final double dailyTarget;
  @override
  @JsonKey()
  final String frequency;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int durationDays;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final DateTime? lastContributionDate;
  @override
  @JsonKey()
  final int missedDays;
  @override
  @JsonKey()
  final bool recoveryUsedThisWeek;
  @override
  final DateTime? recoveryWeekStart;
  @override
  @JsonKey()
  final double completionProbability;
  @override
  @JsonKey()
  final String status;
  @override
  final String? visionImageUrl;
  @override
  final String? motivationMessage;
  // Story card fields
  @override
  final String? storyHeadline;
  @override
  final String? personalNote;
  @override
  final String? missionEmoji;
  // Commit contract fields
  @override
  @JsonKey()
  final String contractType;
  @override
  @JsonKey()
  final String contractStatus;
  @override
  final DateTime? contractRecoveryDeadline;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'MissionModel(id: $id, userId: $userId, title: $title, category: $category, targetAmount: $targetAmount, savedAmount: $savedAmount, dailyTarget: $dailyTarget, frequency: $frequency, startDate: $startDate, endDate: $endDate, durationDays: $durationDays, currentStreak: $currentStreak, longestStreak: $longestStreak, lastContributionDate: $lastContributionDate, missedDays: $missedDays, recoveryUsedThisWeek: $recoveryUsedThisWeek, recoveryWeekStart: $recoveryWeekStart, completionProbability: $completionProbability, status: $status, visionImageUrl: $visionImageUrl, motivationMessage: $motivationMessage, storyHeadline: $storyHeadline, personalNote: $personalNote, missionEmoji: $missionEmoji, contractType: $contractType, contractStatus: $contractStatus, contractRecoveryDeadline: $contractRecoveryDeadline, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.dailyTarget, dailyTarget) ||
                other.dailyTarget == dailyTarget) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastContributionDate, lastContributionDate) ||
                other.lastContributionDate == lastContributionDate) &&
            (identical(other.missedDays, missedDays) ||
                other.missedDays == missedDays) &&
            (identical(other.recoveryUsedThisWeek, recoveryUsedThisWeek) ||
                other.recoveryUsedThisWeek == recoveryUsedThisWeek) &&
            (identical(other.recoveryWeekStart, recoveryWeekStart) ||
                other.recoveryWeekStart == recoveryWeekStart) &&
            (identical(other.completionProbability, completionProbability) ||
                other.completionProbability == completionProbability) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visionImageUrl, visionImageUrl) ||
                other.visionImageUrl == visionImageUrl) &&
            (identical(other.motivationMessage, motivationMessage) ||
                other.motivationMessage == motivationMessage) &&
            (identical(other.storyHeadline, storyHeadline) ||
                other.storyHeadline == storyHeadline) &&
            (identical(other.personalNote, personalNote) ||
                other.personalNote == personalNote) &&
            (identical(other.missionEmoji, missionEmoji) ||
                other.missionEmoji == missionEmoji) &&
            (identical(other.contractType, contractType) ||
                other.contractType == contractType) &&
            (identical(other.contractStatus, contractStatus) ||
                other.contractStatus == contractStatus) &&
            (identical(
                  other.contractRecoveryDeadline,
                  contractRecoveryDeadline,
                ) ||
                other.contractRecoveryDeadline == contractRecoveryDeadline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    title,
    category,
    targetAmount,
    savedAmount,
    dailyTarget,
    frequency,
    startDate,
    endDate,
    durationDays,
    currentStreak,
    longestStreak,
    lastContributionDate,
    missedDays,
    recoveryUsedThisWeek,
    recoveryWeekStart,
    completionProbability,
    status,
    visionImageUrl,
    motivationMessage,
    storyHeadline,
    personalNote,
    missionEmoji,
    contractType,
    contractStatus,
    contractRecoveryDeadline,
    createdAt,
    updatedAt,
    completedAt,
  ]);

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionModelImplCopyWith<_$MissionModelImpl> get copyWith =>
      __$$MissionModelImplCopyWithImpl<_$MissionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionModelImplToJson(this);
  }
}

abstract class _MissionModel implements MissionModel {
  const factory _MissionModel({
    required final String id,
    required final String userId,
    required final String title,
    required final String category,
    required final double targetAmount,
    final double savedAmount,
    required final double dailyTarget,
    final String frequency,
    required final DateTime startDate,
    required final DateTime endDate,
    required final int durationDays,
    final int currentStreak,
    final int longestStreak,
    final DateTime? lastContributionDate,
    final int missedDays,
    final bool recoveryUsedThisWeek,
    final DateTime? recoveryWeekStart,
    final double completionProbability,
    final String status,
    final String? visionImageUrl,
    final String? motivationMessage,
    final String? storyHeadline,
    final String? personalNote,
    final String? missionEmoji,
    final String contractType,
    final String contractStatus,
    final DateTime? contractRecoveryDeadline,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? completedAt,
  }) = _$MissionModelImpl;

  factory _MissionModel.fromJson(Map<String, dynamic> json) =
      _$MissionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get category;
  @override
  double get targetAmount;
  @override
  double get savedAmount;
  @override
  double get dailyTarget;
  @override
  String get frequency;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get durationDays;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastContributionDate;
  @override
  int get missedDays;
  @override
  bool get recoveryUsedThisWeek;
  @override
  DateTime? get recoveryWeekStart;
  @override
  double get completionProbability;
  @override
  String get status;
  @override
  String? get visionImageUrl;
  @override
  String? get motivationMessage; // Story card fields
  @override
  String? get storyHeadline;
  @override
  String? get personalNote;
  @override
  String? get missionEmoji; // Commit contract fields
  @override
  String get contractType;
  @override
  String get contractStatus;
  @override
  DateTime? get contractRecoveryDeadline;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionModelImplCopyWith<_$MissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
