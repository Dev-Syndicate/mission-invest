// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adapt_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdaptResponse _$AdaptResponseFromJson(Map<String, dynamic> json) {
  return _AdaptResponse.fromJson(json);
}

/// @nodoc
mixin _$AdaptResponse {
  String get suggestion => throw _privateConstructorUsedError;
  double? get newDailyAmount => throw _privateConstructorUsedError;
  String? get newEndDate => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;

  /// Serializes this AdaptResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdaptResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdaptResponseCopyWith<AdaptResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdaptResponseCopyWith<$Res> {
  factory $AdaptResponseCopyWith(
    AdaptResponse value,
    $Res Function(AdaptResponse) then,
  ) = _$AdaptResponseCopyWithImpl<$Res, AdaptResponse>;
  @useResult
  $Res call({
    String suggestion,
    double? newDailyAmount,
    String? newEndDate,
    String reasoning,
  });
}

/// @nodoc
class _$AdaptResponseCopyWithImpl<$Res, $Val extends AdaptResponse>
    implements $AdaptResponseCopyWith<$Res> {
  _$AdaptResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdaptResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestion = null,
    Object? newDailyAmount = freezed,
    Object? newEndDate = freezed,
    Object? reasoning = null,
  }) {
    return _then(
      _value.copyWith(
            suggestion: null == suggestion
                ? _value.suggestion
                : suggestion // ignore: cast_nullable_to_non_nullable
                      as String,
            newDailyAmount: freezed == newDailyAmount
                ? _value.newDailyAmount
                : newDailyAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            newEndDate: freezed == newEndDate
                ? _value.newEndDate
                : newEndDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            reasoning: null == reasoning
                ? _value.reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdaptResponseImplCopyWith<$Res>
    implements $AdaptResponseCopyWith<$Res> {
  factory _$$AdaptResponseImplCopyWith(
    _$AdaptResponseImpl value,
    $Res Function(_$AdaptResponseImpl) then,
  ) = __$$AdaptResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String suggestion,
    double? newDailyAmount,
    String? newEndDate,
    String reasoning,
  });
}

/// @nodoc
class __$$AdaptResponseImplCopyWithImpl<$Res>
    extends _$AdaptResponseCopyWithImpl<$Res, _$AdaptResponseImpl>
    implements _$$AdaptResponseImplCopyWith<$Res> {
  __$$AdaptResponseImplCopyWithImpl(
    _$AdaptResponseImpl _value,
    $Res Function(_$AdaptResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdaptResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestion = null,
    Object? newDailyAmount = freezed,
    Object? newEndDate = freezed,
    Object? reasoning = null,
  }) {
    return _then(
      _$AdaptResponseImpl(
        suggestion: null == suggestion
            ? _value.suggestion
            : suggestion // ignore: cast_nullable_to_non_nullable
                  as String,
        newDailyAmount: freezed == newDailyAmount
            ? _value.newDailyAmount
            : newDailyAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        newEndDate: freezed == newEndDate
            ? _value.newEndDate
            : newEndDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        reasoning: null == reasoning
            ? _value.reasoning
            : reasoning // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdaptResponseImpl implements _AdaptResponse {
  const _$AdaptResponseImpl({
    required this.suggestion,
    this.newDailyAmount,
    this.newEndDate,
    required this.reasoning,
  });

  factory _$AdaptResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdaptResponseImplFromJson(json);

  @override
  final String suggestion;
  @override
  final double? newDailyAmount;
  @override
  final String? newEndDate;
  @override
  final String reasoning;

  @override
  String toString() {
    return 'AdaptResponse(suggestion: $suggestion, newDailyAmount: $newDailyAmount, newEndDate: $newEndDate, reasoning: $reasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdaptResponseImpl &&
            (identical(other.suggestion, suggestion) ||
                other.suggestion == suggestion) &&
            (identical(other.newDailyAmount, newDailyAmount) ||
                other.newDailyAmount == newDailyAmount) &&
            (identical(other.newEndDate, newEndDate) ||
                other.newEndDate == newEndDate) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    suggestion,
    newDailyAmount,
    newEndDate,
    reasoning,
  );

  /// Create a copy of AdaptResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdaptResponseImplCopyWith<_$AdaptResponseImpl> get copyWith =>
      __$$AdaptResponseImplCopyWithImpl<_$AdaptResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdaptResponseImplToJson(this);
  }
}

abstract class _AdaptResponse implements AdaptResponse {
  const factory _AdaptResponse({
    required final String suggestion,
    final double? newDailyAmount,
    final String? newEndDate,
    required final String reasoning,
  }) = _$AdaptResponseImpl;

  factory _AdaptResponse.fromJson(Map<String, dynamic> json) =
      _$AdaptResponseImpl.fromJson;

  @override
  String get suggestion;
  @override
  double? get newDailyAmount;
  @override
  String? get newEndDate;
  @override
  String get reasoning;

  /// Create a copy of AdaptResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdaptResponseImplCopyWith<_$AdaptResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
