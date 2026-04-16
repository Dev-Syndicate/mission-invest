// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SeasonModel _$SeasonModelFromJson(Map<String, dynamic> json) {
  return _SeasonModel.fromJson(json);
}

/// @nodoc
mixin _$SeasonModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // trip, gadget, education, etc.
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get participantCount => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  String? get badgeId => throw _privateConstructorUsedError;
  String? get bannerImageUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this SeasonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeasonModelCopyWith<SeasonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonModelCopyWith<$Res> {
  factory $SeasonModelCopyWith(
    SeasonModel value,
    $Res Function(SeasonModel) then,
  ) = _$SeasonModelCopyWithImpl<$Res, SeasonModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    DateTime startDate,
    DateTime endDate,
    int participantCount,
    double completionRate,
    String? badgeId,
    String? bannerImageUrl,
    bool isActive,
  });
}

/// @nodoc
class _$SeasonModelCopyWithImpl<$Res, $Val extends SeasonModel>
    implements $SeasonModelCopyWith<$Res> {
  _$SeasonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? participantCount = null,
    Object? completionRate = null,
    Object? badgeId = freezed,
    Object? bannerImageUrl = freezed,
    Object? isActive = null,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            participantCount: null == participantCount
                ? _value.participantCount
                : participantCount // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            badgeId: freezed == badgeId
                ? _value.badgeId
                : badgeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bannerImageUrl: freezed == bannerImageUrl
                ? _value.bannerImageUrl
                : bannerImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeasonModelImplCopyWith<$Res>
    implements $SeasonModelCopyWith<$Res> {
  factory _$$SeasonModelImplCopyWith(
    _$SeasonModelImpl value,
    $Res Function(_$SeasonModelImpl) then,
  ) = __$$SeasonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    DateTime startDate,
    DateTime endDate,
    int participantCount,
    double completionRate,
    String? badgeId,
    String? bannerImageUrl,
    bool isActive,
  });
}

/// @nodoc
class __$$SeasonModelImplCopyWithImpl<$Res>
    extends _$SeasonModelCopyWithImpl<$Res, _$SeasonModelImpl>
    implements _$$SeasonModelImplCopyWith<$Res> {
  __$$SeasonModelImplCopyWithImpl(
    _$SeasonModelImpl _value,
    $Res Function(_$SeasonModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? participantCount = null,
    Object? completionRate = null,
    Object? badgeId = freezed,
    Object? bannerImageUrl = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$SeasonModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        participantCount: null == participantCount
            ? _value.participantCount
            : participantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        badgeId: freezed == badgeId
            ? _value.badgeId
            : badgeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bannerImageUrl: freezed == bannerImageUrl
            ? _value.bannerImageUrl
            : bannerImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonModelImpl implements _SeasonModel {
  const _$SeasonModelImpl({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    required this.endDate,
    this.participantCount = 0,
    this.completionRate = 0.0,
    this.badgeId,
    this.bannerImageUrl,
    this.isActive = true,
  });

  factory _$SeasonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  // trip, gadget, education, etc.
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final int participantCount;
  @override
  @JsonKey()
  final double completionRate;
  @override
  final String? badgeId;
  @override
  final String? bannerImageUrl;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'SeasonModel(id: $id, title: $title, category: $category, startDate: $startDate, endDate: $endDate, participantCount: $participantCount, completionRate: $completionRate, badgeId: $badgeId, bannerImageUrl: $bannerImageUrl, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.badgeId, badgeId) || other.badgeId == badgeId) &&
            (identical(other.bannerImageUrl, bannerImageUrl) ||
                other.bannerImageUrl == bannerImageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    category,
    startDate,
    endDate,
    participantCount,
    completionRate,
    badgeId,
    bannerImageUrl,
    isActive,
  );

  /// Create a copy of SeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonModelImplCopyWith<_$SeasonModelImpl> get copyWith =>
      __$$SeasonModelImplCopyWithImpl<_$SeasonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonModelImplToJson(this);
  }
}

abstract class _SeasonModel implements SeasonModel {
  const factory _SeasonModel({
    required final String id,
    required final String title,
    required final String category,
    required final DateTime startDate,
    required final DateTime endDate,
    final int participantCount,
    final double completionRate,
    final String? badgeId,
    final String? bannerImageUrl,
    final bool isActive,
  }) = _$SeasonModelImpl;

  factory _SeasonModel.fromJson(Map<String, dynamic> json) =
      _$SeasonModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get category; // trip, gadget, education, etc.
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get participantCount;
  @override
  double get completionRate;
  @override
  String? get badgeId;
  @override
  String? get bannerImageUrl;
  @override
  bool get isActive;

  /// Create a copy of SeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeasonModelImplCopyWith<_$SeasonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
