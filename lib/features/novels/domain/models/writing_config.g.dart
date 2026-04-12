// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WritingConfigImpl _$$WritingConfigImplFromJson(Map<String, dynamic> json) =>
    _$WritingConfigImpl(
      provider: json['provider'] as String? ?? 'siliconflow',
      model: json['model'] as String? ?? 'Pro',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 500,
      topP: (json['topP'] as num?)?.toDouble() ?? 0.9,
    );

Map<String, dynamic> _$$WritingConfigImplToJson(_$WritingConfigImpl instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'model': instance.model,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'topP': instance.topP,
    };

_$AIGenerateResponseImpl _$$AIGenerateResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AIGenerateResponseImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AIGenerateResponseImplToJson(
        _$AIGenerateResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
    };
