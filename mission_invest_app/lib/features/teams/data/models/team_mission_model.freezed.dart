// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_mission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamMissionModel _$TeamMissionModelFromJson(Map<String, dynamic> json) {
  return _TeamMissionModel.fromJson(json);
}

/// @nodoc
mixin _$TeamMissionModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;
  Map<String, double> get contributions =>
      throw _privateConstructorUsedError; // userId -> amount
  String get status => throw _privateConstructorUsedError; // active, completed
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  /// Serializes this TeamMissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamMissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMissionModelCopyWith<TeamMissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMissionModelCopyWith<$Res> {
  factory $TeamMissionModelCopyWith(
    TeamMissionModel value,
    $Res Function(TeamMissionModel) then,
  ) = _$TeamMissionModelCopyWithImpl<$Res, TeamMissionModel>;
  @useResult
  $Res call({
    String id,
    String title,
    double targetAmount,
    List<String> memberIds,
    Map<String, double> contributions,
    String status,
    DateTime createdAt,
    String createdBy,
  });
}

/// @nodoc
class _$TeamMissionModelCopyWithImpl<$Res, $Val extends TeamMissionModel>
    implements $TeamMissionModelCopyWith<$Res> {
  _$TeamMissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? memberIds = null,
    Object? contributions = null,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            memberIds: null == memberIds
                ? _value.memberIds
                : memberIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            contributions: null == contributions
                ? _value.contributions
                : contributions // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamMissionModelImplCopyWith<$Res>
    implements $TeamMissionModelCopyWith<$Res> {
  factory _$$TeamMissionModelImplCopyWith(
    _$TeamMissionModelImpl value,
    $Res Function(_$TeamMissionModelImpl) then,
  ) = __$$TeamMissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    double targetAmount,
    List<String> memberIds,
    Map<String, double> contributions,
    String status,
    DateTime createdAt,
    String createdBy,
  });
}

/// @nodoc
class __$$TeamMissionModelImplCopyWithImpl<$Res>
    extends _$TeamMissionModelCopyWithImpl<$Res, _$TeamMissionModelImpl>
    implements _$$TeamMissionModelImplCopyWith<$Res> {
  __$$TeamMissionModelImplCopyWithImpl(
    _$TeamMissionModelImpl _value,
    $Res Function(_$TeamMissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamMissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? memberIds = null,
    Object? contributions = null,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = null,
  }) {
    return _then(
      _$TeamMissionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        memberIds: null == memberIds
            ? _value._memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        contributions: null == contributions
            ? _value._contributions
            : contributions // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMissionModelImpl implements _TeamMissionModel {
  const _$TeamMissionModelImpl({
    required this.id,
    required this.title,
    required this.targetAmount,
    final List<String> memberIds = const [],
    final Map<String, double> contributions = const {},
    this.status = 'active',
    required this.createdAt,
    required this.createdBy,
  }) : _memberIds = memberIds,
       _contributions = contributions;

  factory _$TeamMissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMissionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final double targetAmount;
  final List<String> _memberIds;
  @override
  @JsonKey()
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  final Map<String, double> _contributions;
  @override
  @JsonKey()
  Map<String, double> get contributions {
    if (_contributions is EqualUnmodifiableMapView) return _contributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contributions);
  }

  // userId -> amount
  @override
  @JsonKey()
  final String status;
  // active, completed
  @override
  final DateTime createdAt;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'TeamMissionModel(id: $id, title: $title, targetAmount: $targetAmount, memberIds: $memberIds, contributions: $contributions, status: $status, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMissionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            const DeepCollectionEquality().equals(
              other._memberIds,
              _memberIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._contributions,
              _contributions,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    targetAmount,
    const DeepCollectionEquality().hash(_memberIds),
    const DeepCollectionEquality().hash(_contributions),
    status,
    createdAt,
    createdBy,
  );

  /// Create a copy of TeamMissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMissionModelImplCopyWith<_$TeamMissionModelImpl> get copyWith =>
      __$$TeamMissionModelImplCopyWithImpl<_$TeamMissionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMissionModelImplToJson(this);
  }
}

abstract class _TeamMissionModel implements TeamMissionModel {
  const factory _TeamMissionModel({
    required final String id,
    required final String title,
    required final double targetAmount,
    final List<String> memberIds,
    final Map<String, double> contributions,
    final String status,
    required final DateTime createdAt,
    required final String createdBy,
  }) = _$TeamMissionModelImpl;

  factory _TeamMissionModel.fromJson(Map<String, dynamic> json) =
      _$TeamMissionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  double get targetAmount;
  @override
  List<String> get memberIds;
  @override
  Map<String, double> get contributions; // userId -> amount
  @override
  String get status; // active, completed
  @override
  DateTime get createdAt;
  @override
  String get createdBy;

  /// Create a copy of TeamMissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMissionModelImplCopyWith<_$TeamMissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
