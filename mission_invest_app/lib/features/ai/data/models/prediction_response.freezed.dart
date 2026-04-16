// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prediction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PredictionResponse _$PredictionResponseFromJson(Map<String, dynamic> json) {
  return _PredictionResponse.fromJson(json);
}

/// @nodoc
mixin _$PredictionResponse {
  double get completionProbability => throw _privateConstructorUsedError;
  String get riskLevel => throw _privateConstructorUsedError;
  List<String> get factors => throw _privateConstructorUsedError;

  /// Serializes this PredictionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionResponseCopyWith<PredictionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionResponseCopyWith<$Res> {
  factory $PredictionResponseCopyWith(
    PredictionResponse value,
    $Res Function(PredictionResponse) then,
  ) = _$PredictionResponseCopyWithImpl<$Res, PredictionResponse>;
  @useResult
  $Res call({
    double completionProbability,
    String riskLevel,
    List<String> factors,
  });
}

/// @nodoc
class _$PredictionResponseCopyWithImpl<$Res, $Val extends PredictionResponse>
    implements $PredictionResponseCopyWith<$Res> {
  _$PredictionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionProbability = null,
    Object? riskLevel = null,
    Object? factors = null,
  }) {
    return _then(
      _value.copyWith(
            completionProbability: null == completionProbability
                ? _value.completionProbability
                : completionProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            riskLevel: null == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            factors: null == factors
                ? _value.factors
                : factors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PredictionResponseImplCopyWith<$Res>
    implements $PredictionResponseCopyWith<$Res> {
  factory _$$PredictionResponseImplCopyWith(
    _$PredictionResponseImpl value,
    $Res Function(_$PredictionResponseImpl) then,
  ) = __$$PredictionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double completionProbability,
    String riskLevel,
    List<String> factors,
  });
}

/// @nodoc
class __$$PredictionResponseImplCopyWithImpl<$Res>
    extends _$PredictionResponseCopyWithImpl<$Res, _$PredictionResponseImpl>
    implements _$$PredictionResponseImplCopyWith<$Res> {
  __$$PredictionResponseImplCopyWithImpl(
    _$PredictionResponseImpl _value,
    $Res Function(_$PredictionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PredictionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionProbability = null,
    Object? riskLevel = null,
    Object? factors = null,
  }) {
    return _then(
      _$PredictionResponseImpl(
        completionProbability: null == completionProbability
            ? _value.completionProbability
            : completionProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        riskLevel: null == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        factors: null == factors
            ? _value._factors
            : factors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictionResponseImpl implements _PredictionResponse {
  const _$PredictionResponseImpl({
    required this.completionProbability,
    required this.riskLevel,
    final List<String> factors = const [],
  }) : _factors = factors;

  factory _$PredictionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionResponseImplFromJson(json);

  @override
  final double completionProbability;
  @override
  final String riskLevel;
  final List<String> _factors;
  @override
  @JsonKey()
  List<String> get factors {
    if (_factors is EqualUnmodifiableListView) return _factors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_factors);
  }

  @override
  String toString() {
    return 'PredictionResponse(completionProbability: $completionProbability, riskLevel: $riskLevel, factors: $factors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionResponseImpl &&
            (identical(other.completionProbability, completionProbability) ||
                other.completionProbability == completionProbability) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            const DeepCollectionEquality().equals(other._factors, _factors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    completionProbability,
    riskLevel,
    const DeepCollectionEquality().hash(_factors),
  );

  /// Create a copy of PredictionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionResponseImplCopyWith<_$PredictionResponseImpl> get copyWith =>
      __$$PredictionResponseImplCopyWithImpl<_$PredictionResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionResponseImplToJson(this);
  }
}

abstract class _PredictionResponse implements PredictionResponse {
  const factory _PredictionResponse({
    required final double completionProbability,
    required final String riskLevel,
    final List<String> factors,
  }) = _$PredictionResponseImpl;

  factory _PredictionResponse.fromJson(Map<String, dynamic> json) =
      _$PredictionResponseImpl.fromJson;

  @override
  double get completionProbability;
  @override
  String get riskLevel;
  @override
  List<String> get factors;

  /// Create a copy of PredictionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionResponseImplCopyWith<_$PredictionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
