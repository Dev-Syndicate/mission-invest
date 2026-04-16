// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContributionModel _$ContributionModelFromJson(Map<String, dynamic> json) {
  return _ContributionModel.fromJson(json);
}

/// @nodoc
mixin _$ContributionModel {
  String get id => throw _privateConstructorUsedError;
  String get missionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get streakDay => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ContributionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContributionModelCopyWith<ContributionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionModelCopyWith<$Res> {
  factory $ContributionModelCopyWith(
    ContributionModel value,
    $Res Function(ContributionModel) then,
  ) = _$ContributionModelCopyWithImpl<$Res, ContributionModel>;
  @useResult
  $Res call({
    String id,
    String missionId,
    String userId,
    double amount,
    DateTime date,
    int streakDay,
    String? note,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ContributionModelCopyWithImpl<$Res, $Val extends ContributionModel>
    implements $ContributionModelCopyWith<$Res> {
  _$ContributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? missionId = null,
    Object? userId = null,
    Object? amount = null,
    Object? date = null,
    Object? streakDay = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            missionId: null == missionId
                ? _value.missionId
                : missionId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            streakDay: null == streakDay
                ? _value.streakDay
                : streakDay // ignore: cast_nullable_to_non_nullable
                      as int,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContributionModelImplCopyWith<$Res>
    implements $ContributionModelCopyWith<$Res> {
  factory _$$ContributionModelImplCopyWith(
    _$ContributionModelImpl value,
    $Res Function(_$ContributionModelImpl) then,
  ) = __$$ContributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String missionId,
    String userId,
    double amount,
    DateTime date,
    int streakDay,
    String? note,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ContributionModelImplCopyWithImpl<$Res>
    extends _$ContributionModelCopyWithImpl<$Res, _$ContributionModelImpl>
    implements _$$ContributionModelImplCopyWith<$Res> {
  __$$ContributionModelImplCopyWithImpl(
    _$ContributionModelImpl _value,
    $Res Function(_$ContributionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? missionId = null,
    Object? userId = null,
    Object? amount = null,
    Object? date = null,
    Object? streakDay = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$ContributionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        missionId: null == missionId
            ? _value.missionId
            : missionId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        streakDay: null == streakDay
            ? _value.streakDay
            : streakDay // ignore: cast_nullable_to_non_nullable
                  as int,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContributionModelImpl implements _ContributionModel {
  const _$ContributionModelImpl({
    required this.id,
    required this.missionId,
    required this.userId,
    required this.amount,
    required this.date,
    this.streakDay = 0,
    this.note,
    required this.createdAt,
  });

  factory _$ContributionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContributionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String missionId;
  @override
  final String userId;
  @override
  final double amount;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final int streakDay;
  @override
  final String? note;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContributionModel(id: $id, missionId: $missionId, userId: $userId, amount: $amount, date: $date, streakDay: $streakDay, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.streakDay, streakDay) ||
                other.streakDay == streakDay) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    missionId,
    userId,
    amount,
    date,
    streakDay,
    note,
    createdAt,
  );

  /// Create a copy of ContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionModelImplCopyWith<_$ContributionModelImpl> get copyWith =>
      __$$ContributionModelImplCopyWithImpl<_$ContributionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionModelImplToJson(this);
  }
}

abstract class _ContributionModel implements ContributionModel {
  const factory _ContributionModel({
    required final String id,
    required final String missionId,
    required final String userId,
    required final double amount,
    required final DateTime date,
    final int streakDay,
    final String? note,
    required final DateTime createdAt,
  }) = _$ContributionModelImpl;

  factory _ContributionModel.fromJson(Map<String, dynamic> json) =
      _$ContributionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get missionId;
  @override
  String get userId;
  @override
  double get amount;
  @override
  DateTime get date;
  @override
  int get streakDay;
  @override
  String? get note;
  @override
  DateTime get createdAt;

  /// Create a copy of ContributionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContributionModelImplCopyWith<_$ContributionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
