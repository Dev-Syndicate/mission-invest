// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motivation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MotivationResponse _$MotivationResponseFromJson(Map<String, dynamic> json) {
  return _MotivationResponse.fromJson(json);
}

/// @nodoc
mixin _$MotivationResponse {
  String get message => throw _privateConstructorUsedError;
  String get tone => throw _privateConstructorUsedError;

  /// Serializes this MotivationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotivationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotivationResponseCopyWith<MotivationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotivationResponseCopyWith<$Res> {
  factory $MotivationResponseCopyWith(
    MotivationResponse value,
    $Res Function(MotivationResponse) then,
  ) = _$MotivationResponseCopyWithImpl<$Res, MotivationResponse>;
  @useResult
  $Res call({String message, String tone});
}

/// @nodoc
class _$MotivationResponseCopyWithImpl<$Res, $Val extends MotivationResponse>
    implements $MotivationResponseCopyWith<$Res> {
  _$MotivationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotivationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? tone = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            tone: null == tone
                ? _value.tone
                : tone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MotivationResponseImplCopyWith<$Res>
    implements $MotivationResponseCopyWith<$Res> {
  factory _$$MotivationResponseImplCopyWith(
    _$MotivationResponseImpl value,
    $Res Function(_$MotivationResponseImpl) then,
  ) = __$$MotivationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String tone});
}

/// @nodoc
class __$$MotivationResponseImplCopyWithImpl<$Res>
    extends _$MotivationResponseCopyWithImpl<$Res, _$MotivationResponseImpl>
    implements _$$MotivationResponseImplCopyWith<$Res> {
  __$$MotivationResponseImplCopyWithImpl(
    _$MotivationResponseImpl _value,
    $Res Function(_$MotivationResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MotivationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? tone = null}) {
    return _then(
      _$MotivationResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        tone: null == tone
            ? _value.tone
            : tone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MotivationResponseImpl implements _MotivationResponse {
  const _$MotivationResponseImpl({required this.message, required this.tone});

  factory _$MotivationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotivationResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String tone;

  @override
  String toString() {
    return 'MotivationResponse(message: $message, tone: $tone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotivationResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.tone, tone) || other.tone == tone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, tone);

  /// Create a copy of MotivationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotivationResponseImplCopyWith<_$MotivationResponseImpl> get copyWith =>
      __$$MotivationResponseImplCopyWithImpl<_$MotivationResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MotivationResponseImplToJson(this);
  }
}

abstract class _MotivationResponse implements MotivationResponse {
  const factory _MotivationResponse({
    required final String message,
    required final String tone,
  }) = _$MotivationResponseImpl;

  factory _MotivationResponse.fromJson(Map<String, dynamic> json) =
      _$MotivationResponseImpl.fromJson;

  @override
  String get message;
  @override
  String get tone;

  /// Create a copy of MotivationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotivationResponseImplCopyWith<_$MotivationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
