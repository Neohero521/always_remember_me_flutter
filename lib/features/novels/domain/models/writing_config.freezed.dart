// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'writing_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WritingConfig _$WritingConfigFromJson(Map<String, dynamic> json) {
  return _WritingConfig.fromJson(json);
}

/// @nodoc
mixin _$WritingConfig {
  String get provider => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  int get maxTokens => throw _privateConstructorUsedError;
  double get topP => throw _privateConstructorUsedError;

  /// Serializes this WritingConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WritingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WritingConfigCopyWith<WritingConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WritingConfigCopyWith<$Res> {
  factory $WritingConfigCopyWith(
          WritingConfig value, $Res Function(WritingConfig) then) =
      _$WritingConfigCopyWithImpl<$Res, WritingConfig>;
  @useResult
  $Res call(
      {String provider,
      String model,
      double temperature,
      int maxTokens,
      double topP});
}

/// @nodoc
class _$WritingConfigCopyWithImpl<$Res, $Val extends WritingConfig>
    implements $WritingConfigCopyWith<$Res> {
  _$WritingConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WritingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? model = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? topP = null,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WritingConfigImplCopyWith<$Res>
    implements $WritingConfigCopyWith<$Res> {
  factory _$$WritingConfigImplCopyWith(
          _$WritingConfigImpl value, $Res Function(_$WritingConfigImpl) then) =
      __$$WritingConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String provider,
      String model,
      double temperature,
      int maxTokens,
      double topP});
}

/// @nodoc
class __$$WritingConfigImplCopyWithImpl<$Res>
    extends _$WritingConfigCopyWithImpl<$Res, _$WritingConfigImpl>
    implements _$$WritingConfigImplCopyWith<$Res> {
  __$$WritingConfigImplCopyWithImpl(
      _$WritingConfigImpl _value, $Res Function(_$WritingConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of WritingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? model = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? topP = null,
  }) {
    return _then(_$WritingConfigImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WritingConfigImpl implements _WritingConfig {
  const _$WritingConfigImpl(
      {this.provider = 'siliconflow',
      this.model = 'Pro',
      this.temperature = 0.8,
      this.maxTokens = 500,
      this.topP = 0.9});

  factory _$WritingConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WritingConfigImplFromJson(json);

  @override
  @JsonKey()
  final String provider;
  @override
  @JsonKey()
  final String model;
  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey()
  final int maxTokens;
  @override
  @JsonKey()
  final double topP;

  @override
  String toString() {
    return 'WritingConfig(provider: $provider, model: $model, temperature: $temperature, maxTokens: $maxTokens, topP: $topP)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WritingConfigImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.topP, topP) || other.topP == topP));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, provider, model, temperature, maxTokens, topP);

  /// Create a copy of WritingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WritingConfigImplCopyWith<_$WritingConfigImpl> get copyWith =>
      __$$WritingConfigImplCopyWithImpl<_$WritingConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WritingConfigImplToJson(
      this,
    );
  }
}

abstract class _WritingConfig implements WritingConfig {
  const factory _WritingConfig(
      {final String provider,
      final String model,
      final double temperature,
      final int maxTokens,
      final double topP}) = _$WritingConfigImpl;

  factory _WritingConfig.fromJson(Map<String, dynamic> json) =
      _$WritingConfigImpl.fromJson;

  @override
  String get provider;
  @override
  String get model;
  @override
  double get temperature;
  @override
  int get maxTokens;
  @override
  double get topP;

  /// Create a copy of WritingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WritingConfigImplCopyWith<_$WritingConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIGenerateResponse _$AIGenerateResponseFromJson(Map<String, dynamic> json) {
  return _AIGenerateResponse.fromJson(json);
}

/// @nodoc
mixin _$AIGenerateResponse {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AIGenerateResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIGenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIGenerateResponseCopyWith<AIGenerateResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIGenerateResponseCopyWith<$Res> {
  factory $AIGenerateResponseCopyWith(
          AIGenerateResponse value, $Res Function(AIGenerateResponse) then) =
      _$AIGenerateResponseCopyWithImpl<$Res, AIGenerateResponse>;
  @useResult
  $Res call({String id, String text, DateTime createdAt});
}

/// @nodoc
class _$AIGenerateResponseCopyWithImpl<$Res, $Val extends AIGenerateResponse>
    implements $AIGenerateResponseCopyWith<$Res> {
  _$AIGenerateResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIGenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIGenerateResponseImplCopyWith<$Res>
    implements $AIGenerateResponseCopyWith<$Res> {
  factory _$$AIGenerateResponseImplCopyWith(_$AIGenerateResponseImpl value,
          $Res Function(_$AIGenerateResponseImpl) then) =
      __$$AIGenerateResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, DateTime createdAt});
}

/// @nodoc
class __$$AIGenerateResponseImplCopyWithImpl<$Res>
    extends _$AIGenerateResponseCopyWithImpl<$Res, _$AIGenerateResponseImpl>
    implements _$$AIGenerateResponseImplCopyWith<$Res> {
  __$$AIGenerateResponseImplCopyWithImpl(_$AIGenerateResponseImpl _value,
      $Res Function(_$AIGenerateResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIGenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? createdAt = null,
  }) {
    return _then(_$AIGenerateResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIGenerateResponseImpl implements _AIGenerateResponse {
  const _$AIGenerateResponseImpl(
      {required this.id, required this.text, required this.createdAt});

  factory _$AIGenerateResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIGenerateResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AIGenerateResponse(id: $id, text: $text, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIGenerateResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, createdAt);

  /// Create a copy of AIGenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIGenerateResponseImplCopyWith<_$AIGenerateResponseImpl> get copyWith =>
      __$$AIGenerateResponseImplCopyWithImpl<_$AIGenerateResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIGenerateResponseImplToJson(
      this,
    );
  }
}

abstract class _AIGenerateResponse implements AIGenerateResponse {
  const factory _AIGenerateResponse(
      {required final String id,
      required final String text,
      required final DateTime createdAt}) = _$AIGenerateResponseImpl;

  factory _AIGenerateResponse.fromJson(Map<String, dynamic> json) =
      _$AIGenerateResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  DateTime get createdAt;

  /// Create a copy of AIGenerateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIGenerateResponseImplCopyWith<_$AIGenerateResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
