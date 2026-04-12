import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_config.freezed.dart';
part 'writing_config.g.dart';

@freezed
class WritingConfig with _$WritingConfig {
  const factory WritingConfig({
    @Default('siliconflow') String provider,
    @Default('Pro') String model,
    @Default(0.8) double temperature,
    @Default(500) int maxTokens,
    @Default(0.9) double topP,
  }) = _WritingConfig;

  factory WritingConfig.fromJson(Map<String, dynamic> json) => _$WritingConfigFromJson(json);
}

@freezed
class AIGenerateResponse with _$AIGenerateResponse {
  const factory AIGenerateResponse({
    required String id,
    required String text,
    required DateTime createdAt,
  }) = _AIGenerateResponse;

  factory AIGenerateResponse.fromJson(Map<String, dynamic> json) => _$AIGenerateResponseFromJson(json);
}
