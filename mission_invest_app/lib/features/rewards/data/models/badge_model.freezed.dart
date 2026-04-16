// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) {
  return _BadgeModel.fromJson(json);
}

/// @nodoc
mixin _$BadgeModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get badgeType => throw _privateConstructorUsedError;
  String get missionId => throw _privateConstructorUsedError;
  String get missionTitle => throw _privateConstructorUsedError;
  DateTime get earnedAt => throw _privateConstructorUsedError;

  /// Serializes this BadgeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeModelCopyWith<BadgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeModelCopyWith<$Res> {
  factory $BadgeModelCopyWith(
    BadgeModel value,
    $Res Function(BadgeModel) then,
  ) = _$BadgeModelCopyWithImpl<$Res, BadgeModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String badgeType,
    String missionId,
    String missionTitle,
    DateTime earnedAt,
  });
}

/// @nodoc
class _$BadgeModelCopyWithImpl<$Res, $Val extends BadgeModel>
    implements $BadgeModelCopyWith<$Res> {
  _$BadgeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? badgeType = null,
    Object? missionId = null,
    Object? missionTitle = null,
    Object? earnedAt = null,
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
            badgeType: null == badgeType
                ? _value.badgeType
                : badgeType // ignore: cast_nullable_to_non_nullable
                      as String,
            missionId: null == missionId
                ? _value.missionId
                : missionId // ignore: cast_nullable_to_non_nullable
                      as String,
            missionTitle: null == missionTitle
                ? _value.missionTitle
                : missionTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            earnedAt: null == earnedAt
                ? _value.earnedAt
                : earnedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BadgeModelImplCopyWith<$Res>
    implements $BadgeModelCopyWith<$Res> {
  factory _$$BadgeModelImplCopyWith(
    _$BadgeModelImpl value,
    $Res Function(_$BadgeModelImpl) then,
  ) = __$$BadgeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String badgeType,
    String missionId,
    String missionTitle,
    DateTime earnedAt,
  });
}

/// @nodoc
class __$$BadgeModelImplCopyWithImpl<$Res>
    extends _$BadgeModelCopyWithImpl<$Res, _$BadgeModelImpl>
    implements _$$BadgeModelImplCopyWith<$Res> {
  __$$BadgeModelImplCopyWithImpl(
    _$BadgeModelImpl _value,
    $Res Function(_$BadgeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? badgeType = null,
    Object? missionId = null,
    Object? missionTitle = null,
    Object? earnedAt = null,
  }) {
    return _then(
      _$BadgeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        badgeType: null == badgeType
            ? _value.badgeType
            : badgeType // ignore: cast_nullable_to_non_nullable
                  as String,
        missionId: null == missionId
            ? _value.missionId
            : missionId // ignore: cast_nullable_to_non_nullable
                  as String,
        missionTitle: null == missionTitle
            ? _value.missionTitle
            : missionTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        earnedAt: null == earnedAt
            ? _value.earnedAt
            : earnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeModelImpl implements _BadgeModel {
  const _$BadgeModelImpl({
    required this.id,
    required this.userId,
    required this.badgeType,
    required this.missionId,
    required this.missionTitle,
    required this.earnedAt,
  });

  factory _$BadgeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String badgeType;
  @override
  final String missionId;
  @override
  final String missionTitle;
  @override
  final DateTime earnedAt;

  @override
  String toString() {
    return 'BadgeModel(id: $id, userId: $userId, badgeType: $badgeType, missionId: $missionId, missionTitle: $missionTitle, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.badgeType, badgeType) ||
                other.badgeType == badgeType) &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            (identical(other.missionTitle, missionTitle) ||
                other.missionTitle == missionTitle) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    badgeType,
    missionId,
    missionTitle,
    earnedAt,
  );

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeModelImplCopyWith<_$BadgeModelImpl> get copyWith =>
      __$$BadgeModelImplCopyWithImpl<_$BadgeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeModelImplToJson(this);
  }
}

abstract class _BadgeModel implements BadgeModel {
  const factory _BadgeModel({
    required final String id,
    required final String userId,
    required final String badgeType,
    required final String missionId,
    required final String missionTitle,
    required final DateTime earnedAt,
  }) = _$BadgeModelImpl;

  factory _BadgeModel.fromJson(Map<String, dynamic> json) =
      _$BadgeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get badgeType;
  @override
  String get missionId;
  @override
  String get missionTitle;
  @override
  DateTime get earnedAt;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeModelImplCopyWith<_$BadgeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
