// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nudge_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NudgeResponse _$NudgeResponseFromJson(Map<String, dynamic> json) {
  return _NudgeResponse.fromJson(json);
}

/// @nodoc
mixin _$NudgeResponse {
  String get message => throw _privateConstructorUsedError;
  String? get actionSuggestion => throw _privateConstructorUsedError;
  Map<String, dynamic>? get suggestedParams =>
      throw _privateConstructorUsedError;

  /// Serializes this NudgeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NudgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NudgeResponseCopyWith<NudgeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NudgeResponseCopyWith<$Res> {
  factory $NudgeResponseCopyWith(
    NudgeResponse value,
    $Res Function(NudgeResponse) then,
  ) = _$NudgeResponseCopyWithImpl<$Res, NudgeResponse>;
  @useResult
  $Res call({
    String message,
    String? actionSuggestion,
    Map<String, dynamic>? suggestedParams,
  });
}

/// @nodoc
class _$NudgeResponseCopyWithImpl<$Res, $Val extends NudgeResponse>
    implements $NudgeResponseCopyWith<$Res> {
  _$NudgeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NudgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? actionSuggestion = freezed,
    Object? suggestedParams = freezed,
  }) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            actionSuggestion: freezed == actionSuggestion
                ? _value.actionSuggestion
                : actionSuggestion // ignore: cast_nullable_to_non_nullable
                      as String?,
            suggestedParams: freezed == suggestedParams
                ? _value.suggestedParams
                : suggestedParams // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NudgeResponseImplCopyWith<$Res>
    implements $NudgeResponseCopyWith<$Res> {
  factory _$$NudgeResponseImplCopyWith(
    _$NudgeResponseImpl value,
    $Res Function(_$NudgeResponseImpl) then,
  ) = __$$NudgeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String message,
    String? actionSuggestion,
    Map<String, dynamic>? suggestedParams,
  });
}

/// @nodoc
class __$$NudgeResponseImplCopyWithImpl<$Res>
    extends _$NudgeResponseCopyWithImpl<$Res, _$NudgeResponseImpl>
    implements _$$NudgeResponseImplCopyWith<$Res> {
  __$$NudgeResponseImplCopyWithImpl(
    _$NudgeResponseImpl _value,
    $Res Function(_$NudgeResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NudgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? actionSuggestion = freezed,
    Object? suggestedParams = freezed,
  }) {
    return _then(
      _$NudgeResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        actionSuggestion: freezed == actionSuggestion
            ? _value.actionSuggestion
            : actionSuggestion // ignore: cast_nullable_to_non_nullable
                  as String?,
        suggestedParams: freezed == suggestedParams
            ? _value._suggestedParams
            : suggestedParams // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NudgeResponseImpl implements _NudgeResponse {
  const _$NudgeResponseImpl({
    required this.message,
    this.actionSuggestion,
    final Map<String, dynamic>? suggestedParams,
  }) : _suggestedParams = suggestedParams;

  factory _$NudgeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NudgeResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String? actionSuggestion;
  final Map<String, dynamic>? _suggestedParams;
  @override
  Map<String, dynamic>? get suggestedParams {
    final value = _suggestedParams;
    if (value == null) return null;
    if (_suggestedParams is EqualUnmodifiableMapView) return _suggestedParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NudgeResponse(message: $message, actionSuggestion: $actionSuggestion, suggestedParams: $suggestedParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NudgeResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.actionSuggestion, actionSuggestion) ||
                other.actionSuggestion == actionSuggestion) &&
            const DeepCollectionEquality().equals(
              other._suggestedParams,
              _suggestedParams,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    actionSuggestion,
    const DeepCollectionEquality().hash(_suggestedParams),
  );

  /// Create a copy of NudgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NudgeResponseImplCopyWith<_$NudgeResponseImpl> get copyWith =>
      __$$NudgeResponseImplCopyWithImpl<_$NudgeResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NudgeResponseImplToJson(this);
  }
}

abstract class _NudgeResponse implements NudgeResponse {
  const factory _NudgeResponse({
    required final String message,
    final String? actionSuggestion,
    final Map<String, dynamic>? suggestedParams,
  }) = _$NudgeResponseImpl;

  factory _NudgeResponse.fromJson(Map<String, dynamic> json) =
      _$NudgeResponseImpl.fromJson;

  @override
  String get message;
  @override
  String? get actionSuggestion;
  @override
  Map<String, dynamic>? get suggestedParams;

  /// Create a copy of NudgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NudgeResponseImplCopyWith<_$NudgeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
