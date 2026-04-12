import '../../../../features/novels/domain/models/writing_config.dart';

abstract class AIRepository {
  /// Generate text continuation
  Future<AIGenerateResponse> generateText({
    required String prompt,
    required WritingConfig config,
  });

  /// Stream generated text token by token
  Stream<String> streamGenerate({
    required String prompt,
    required WritingConfig config,
  });

  /// Analyze characters in content
  Future<List<CharacterAnalysis>> analyzeCharacters(String content);

  /// Build continuation prompt
  String buildPrompt({
    required String context,
    required String characters,
    required String relationships,
    required int maxWords,
  });

  /// Generate structured JSON output using a JSON schema.
  /// Throws if the model does not support structured output.
  Future<String> generateStructuredText({
    required String prompt,
    required Map<String, dynamic> schema,
  });
}

class CharacterAnalysis {
  final String id;
  final String name;
  final int appearanceCount;
  final double importanceScore;

  CharacterAnalysis({
    required this.id,
    required this.name,
    required this.appearanceCount,
    required this.importanceScore,
  });
}
