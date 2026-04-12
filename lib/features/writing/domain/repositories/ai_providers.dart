import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../features/novels/domain/models/writing_config.dart';
import 'ai_repository.dart';

/// SiliconFlow API implementation
class SiliconFlowAIRepository implements AIRepository {
  final Dio dio;
  final String apiKey;
  final String baseUrl;

  SiliconFlowAIRepository({
    required this.dio,
    required this.apiKey,
    this.baseUrl = 'https://api.siliconflow.cn',
  });

  @override
  Future<AIGenerateResponse> generateText({
    required String prompt,
    required WritingConfig config,
  }) async {
    final response = await dio.post(
      '$baseUrl/v1/chat/completions',
      data: {
        'model': config.model,
        'messages': [{'role': 'user', 'content': prompt}],
        'temperature': config.temperature,
        'max_tokens': config.maxTokens,
        'top_p': config.topP,
      },
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );

    final text = response.data['choices'][0]['message']['content'];
    return AIGenerateResponse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );
  }

  @override
  Stream<String> streamGenerate({
    required String prompt,
    required WritingConfig config,
  }) async* {
    final response = await dio.post<ResponseBody>(
      '$baseUrl/v1/chat/completions',
      data: {
        'model': config.model,
        'messages': [{'role': 'user', 'content': prompt}],
        'stream': true,
        'temperature': config.temperature,
        'max_tokens': config.maxTokens,
        'top_p': config.topP,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'text/event-stream',
        },
        responseType: ResponseType.stream,
      ),
    );

    final stream = response.data!.stream as Stream<List<int>>;
    await for (final chunk in stream) {
      for (final line in utf8.decode(chunk).split('\n')) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') return;
          try {
            final json = jsonDecode(data);
            final content = json['choices']?[0]?['delta']?['content'];
            if (content != null && content.toString().isNotEmpty) {
              yield content.toString();
            }
          } catch (_) {}
        }
      }
    }
  }

  @override
  Future<List<CharacterAnalysis>> analyzeCharacters(String content) async {
    final characters = <CharacterAnalysis>[];
    final nameCounts = <String, int>{};

    final regex = RegExp(r'[\u4e00-\u9fa5]{2,4}(?:氏|公|侯|王|帝|皇)');
    for (final match in regex.allMatches(content)) {
      final name = match.group(0) ?? '';
      nameCounts[name] = (nameCounts[name] ?? 0) + 1;
    }

    var id = 0;
    for (final entry in nameCounts.entries) {
      if (entry.value > 2) {
        characters.add(CharacterAnalysis(
          id: (id++).toString(),
          name: entry.key,
          appearanceCount: entry.value,
          importanceScore: (entry.value / content.length) * 100,
        ));
      }
    }
    return characters;
  }

  @override
  String buildPrompt({
    required String context,
    required String characters,
    required String relationships,
    required int maxWords,
  }) {
    return '''
基于以下信息，续写小说内容：

【故事背景】
$context

【人物关系】
${characters.isNotEmpty ? characters : '暂无主要人物'}

【关键关系】
${relationships.isNotEmpty ? relationships : '暂无关键关系'}

【续写要求】
1. 保持原有风格和人物性格
2. 情节发展符合逻辑
3. 字数控制在$maxWords字以内
''';
  }

  @override
  Future<String> generateStructuredText({
    required String prompt,
    required Map<String, dynamic> schema,
  }) async {
    final response = await dio.post(
      '$baseUrl/v1/chat/completions',
      data: {
        'model': 'deepseek-ai/DeepSeek-V3-0324',
        'messages': [
          {
            'role': 'system',
            'content': '你是一个严格的JSON生成器。请直接输出JSON，不要包含任何额外文字或markdown格式。'
          },
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object', 'schema': schema},
        'temperature': 0.3,
        'max_tokens': 8192,
      },
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );

    final text = response.data['choices'][0]['message']['content'];
    return text ?? '{}';
  }
}

/// OpenAI API implementation
class OpenAIRepository implements AIRepository {
  final Dio dio;
  final String apiKey;

  OpenAIRepository({required this.dio, required this.apiKey});

  @override
  Future<AIGenerateResponse> generateText({
    required String prompt,
    required WritingConfig config,
  }) async {
    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': config.model,
        'messages': [{'role': 'user', 'content': prompt}],
        'temperature': config.temperature,
        'max_tokens': config.maxTokens,
        'top_p': config.topP,
      },
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );

    final text = response.data['choices'][0]['message']['content'];
    return AIGenerateResponse(
      id: response.data['id'],
      text: text,
      createdAt: DateTime.now(),
    );
  }

  @override
  Stream<String> streamGenerate({
    required String prompt,
    required WritingConfig config,
  }) async* {
    final response = await dio.post<ResponseBody>(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': config.model,
        'messages': [{'role': 'user', 'content': prompt}],
        'stream': true,
        'temperature': config.temperature,
        'max_tokens': config.maxTokens,
        'top_p': config.topP,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'text/event-stream',
        },
        responseType: ResponseType.stream,
      ),
    );

    final stream = response.data!.stream as Stream<List<int>>;
    await for (final chunk in stream) {
      for (final line in utf8.decode(chunk).split('\n')) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') return;
          try {
            final json = jsonDecode(data);
            final content = json['choices']?[0]?['delta']?['content'];
            if (content != null && content.toString().isNotEmpty) {
              yield content.toString();
            }
          } catch (_) {}
        }
      }
    }
  }

  @override
  Future<List<CharacterAnalysis>> analyzeCharacters(String content) async {
    return [];
  }

  @override
  String buildPrompt({
    required String context,
    required String characters,
    required String relationships,
    required int maxWords,
  }) {
    return '''
Based on the following information, continue the novel:

【Story Background】
$context

【Characters】
${characters.isNotEmpty ? characters : 'No main characters'}

【Key Relationships】
${relationships.isNotEmpty ? relationships : 'No key relationships'}

【Requirements】
1. Maintain original style and character personalities
2. Plot development should be logical
3. Limit to $maxWords words
''';
  }

  @override
  Future<String> generateStructuredText({
    required String prompt,
    required Map<String, dynamic> schema,
  }) async {
    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': 'gpt-4o',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a strict JSON generator. Output only valid JSON, no additional text or markdown formatting.'
          },
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object', 'schema': schema},
        'temperature': 0.3,
        'max_tokens': 8192,
      },
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
    );

    final text = response.data['choices'][0]['message']['content'];
    return text ?? '{}';
  }
}
