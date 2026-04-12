import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/di/injection.dart';

const _storage = FlutterSecureStorage();

// ============================================================
// SillyTavern-style API Providers
// Reference: https://github.com/SillyTavern/SillyTavern
// ============================================================

/// Chat Completion API providers (OpenAI-style)
enum ChatCompletionProvider {
  openai('OpenAI', 'https://api.openai.com', '/v1/chat/completions', ['gpt-4o', 'gpt-4-turbo', 'gpt-4', 'gpt-3.5-turbo']),
  openaiLegacy('OpenAI Legacy', 'https://api.openai.com', '/v1/chat/completions', ['gpt-3.5-turbo-0301', 'gpt-4-0314']),
  azureOpenAI('Azure OpenAI', '', '/chat/completions', ['gpt-35-turbo', 'gpt-4']),
  claude('Claude', 'https://api.anthropic.com', '/v1/messages', ['claude-3-5-sonnet-20241022', 'claude-3-opus-20240229', 'claude-3-haiku-20240307']),
  openrouter('OpenRouter', 'https://openrouter.ai', '/api/v1/chat/completions', ['openrouter/auto']),
  ai21('AI21', 'https://api.ai21.com', '/v1/chat', ['jamba-1.5-large', 'jamba-1.5-mini']),
  vertexai('Google VertexAI', 'https://{region}-aiplatform.googleapis.com', '/v1/publishers/google/models/{model}:streamGenerateContent', ['gemini-1.5-pro', 'gemini-1.5-flash']),
  mistralai('MistralAI', 'https://api.mistral.ai', '/v1/chat/completions', ['mistral-large-latest', 'mistral-small-latest']),
  cohere('Cohere', 'https://api.cohere.ai', '/v1/chat', ['command-r-plus', 'command-r']),
  perplexity('Perplexity', 'https://api.perplexity.ai', '/chat/completions', ['sonar', 'sonar-pro', 'sonar-reasoning']),
  groq('Groq', 'https://api.groq.com', '/openai/v1/chat/completions', ['llama-3.1-70b-versatile', 'mixtral-8x7b-32768']),
  deepseek('DeepSeek', 'https://api.deepseek.com', '/v1/chat/completions', ['deepseek-chat', 'deepseek-coder']),
  xai('xAI', 'https://api.x.ai', '/v1/chat/completions', ['grok-2-1212', 'grok-beta']),
  moonshot('Moonshot', 'https://api.moonshot.cn', '/v1/chat/completions', ['moonshot-v1-8k', 'moonshot-v1-32k']),
  fireworks('Fireworks', 'https://api.fireworks.ai', '/v1/chat/completions', ['accounts/fireworks/models/llama-v3-70b-instruct']),
  siliconflow('SiliconFlow', 'https://api.siliconflow.cn', '/v1/chat/completions', ['Pro', 'Turbo']),
  zai('Zai', 'https://api.zai.io', '/v1/chat/completions', ['zai-contextual-completion']),
  custom('Custom (OpenAI)', '', '/v1/chat/completions', []),
  sillytavernAPI('SillyTavern API', 'https://api.sillytaverns.com', '/v1/chat/completions', ['gemini-2.5-flash', 'gemini-2.5-pro', 'gpt-5.1', 'deepseek/deepseek-v3.2']),
  // SillyTavern 完整Provider列表
  makersuite('Google AI Studio', 'https://generativelanguage.googleapis.com', '/v1/models', ['gemini-1.5-pro', 'gemini-1.5-flash']),
  electronhub('ElectronHub', 'https://playground.electronhub.ai', '/v1/chat/completions', ['electronhub/default']),
  chutes('Chutes', 'https://api.chutes.ai', '/v1/chat/completions', ['chutes/mistral', 'chutes/codellama']),
  nanogpt('NanoGPT', 'https://api.nanogpt.ai', '/v1/chat/completions', ['nanogpt/gpt-3.5-turbo']),
  aimlapi('AIMLAPI', 'https://api.aimlapi.com', '/v1/chat/completions', ['gpt-4', 'gpt-3.5-turbo']),
  pollinations('Pollinations', 'https://api.pollinations.ai', '/v1/chat/completions', ['openai/gpt-3.5-turbo', 'openai/gpt-4']),
  cometapi('CometAPI', 'https://api.cometapi.com', '/v1/chat/completions', ['llama-3.1-70b', 'mistral-7b']),
  single('Single', '', '/v1/chat/completions', []);

  final String displayName;
  final String defaultBaseUrl;
  final String endpoint;
  final List<String> defaultModels;

  const ChatCompletionProvider(
      this.displayName, this.defaultBaseUrl, this.endpoint, this.defaultModels);
}

/// Text Completion API providers (KoboldAI-style)
enum TextCompletionProvider {
  koboldcpp('KoboldCPP', 'http://localhost:5000', '/api/v1/generate', []),
  oobabooga('oobabooga', 'http://localhost:5000', '/v1/generate', []),
  mancer('Mancer', 'https://neuro.mancer.tech', '/v1/generate', ['mytholite']),
  vllm('vLLM', 'http://localhost:5000', '/v1/completions', []),
  aphrodite('Aphrodite', 'http://localhost:5000', '/v1/completions', []),
  tabby('Tabby', 'http://localhost:5000', '/v1/completions', []),
  togetherai('TogetherAI', 'https://api.together.xyz', '/v1/completions', ['Gryphe/MythoMax-L2-13b']),
  llamacpp('Llama.cpp', 'http://localhost:5000', '/v1/completions', []),
  ollama('Ollama', 'http://localhost:11434', '/api/generate', ['llama3', 'mistral', 'codellama']),
  infermaticai('InfermaticAI', 'https://api.totalgpt.ai', '/v1/completions', []),
  dreamgen('DreamGen', 'https://dreamgen.com', '/v1/completions', ['lucid-v1-extra-large/text']),
  featherless('Featherless', 'https://api.featherless.ai/v1', '/completions', []),
  huggingface('HuggingFace', 'https://api-inference.huggingface.co', '/v1/completions', []),
  generic('Generic', '', '/v1/completions', []);

  final String displayName;
  final String defaultBaseUrl;
  final String endpoint;
  final List<String> defaultModels;

  const TextCompletionProvider(
      this.displayName, this.defaultBaseUrl, this.endpoint, this.defaultModels);
}

// ============================================================
// Connection Mode
// ============================================================
enum ConnectionMode { chatCompletion, textCompletion }

// ============================================================
// Prompt Post-Processing (SillyTavern-style)
// Reference: https://docs.sillytavern.app/usage/api-connections/openai/
// ============================================================
enum PromptConverter {
  none('None', 'No processing'),
  merge('Merge', 'Merge consecutive same-role messages'),
  semiStrict('Semi-strict', 'Merge roles + one optional system message'),
  strict('Strict', 'Semi-strict + user message must be first'),
  singleUserMessage('Single User', 'Merge all into single user message');

  final String displayName;
  final String description;
  const PromptConverter(this.displayName, this.description);
}


// ============================================================
// Connection Profile
// ============================================================
class ConnectionProfile {
  final String id;
  final String name;
  final ConnectionMode mode;
  final ChatCompletionProvider? chatProvider;
  final TextCompletionProvider? textProvider;
  final String baseUrl;
  final String apiKey;
  final String model;
  final Map<String, dynamic> options;

  ConnectionProfile({
    required this.id,
    required this.name,
    required this.mode,
    this.chatProvider,
    this.textProvider,
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    this.options = const {},
  });

  ConnectionProfile copyWith({
    String? id,
    String? name,
    ConnectionMode? mode,
    ChatCompletionProvider? chatProvider,
    TextCompletionProvider? textProvider,
    String? baseUrl,
    String? apiKey,
    String? model,
    Map<String, dynamic>? options,
  }) {
    return ConnectionProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      mode: mode ?? this.mode,
      chatProvider: chatProvider ?? this.chatProvider,
      textProvider: textProvider ?? this.textProvider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mode': mode.name,
        'chatProvider': chatProvider?.name,
        'textProvider': textProvider?.name,
        'baseUrl': baseUrl,
        'apiKey': apiKey,
        'model': model,
        'options': options,
      };

  factory ConnectionProfile.fromJson(Map<String, dynamic> json) {
    return ConnectionProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      mode: ConnectionMode.values.byName(json['mode'] as String),
      chatProvider: json['chatProvider'] != null
          ? ChatCompletionProvider.values.byName(json['chatProvider'] as String)
          : null,
      textProvider: json['textProvider'] != null
          ? TextCompletionProvider.values.byName(json['textProvider'] as String)
          : null,
      baseUrl: json['baseUrl'] as String,
      apiKey: json['apiKey'] as String,
      model: json['model'] as String,
      options: Map<String, dynamic>.from(json['options'] ?? {}),
    );
  }
}

// ============================================================
// Settings Screen
// ============================================================
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

enum _ConnectionBannerState { idle, testing, success, error, warning }

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List<ConnectionProfile> _profiles = [];
  ConnectionProfile? _activeProfile;
  bool _isLoading = true;
  bool _isEditing = false;
  int? _editingIndex;

  final _nameController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();

  // Connection banner state
  _ConnectionBannerState _bannerState = _ConnectionBannerState.idle;
  String _bannerMessage = '';

  // Options
  double _temperature = 0.8;
  int _maxTokens = 4000;
  double _topP = 0.9;
  double _topK = 40;
  double _frequencyPenalty = 0.0;
  double _presencePenalty = 0.0;
  double _repetitionPenalty = 1.0;
  int _contextLength = 4096;
  bool _streaming = true;
  PromptConverter _promptConverter = PromptConverter.none;
  bool _bypassApiStatusCheck = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  // ============================================================
  // Profile Management
  // ============================================================
  Future<void> _loadProfiles() async {
    try {
      final profilesJson = await _storage.read(key: 'ai_profiles_json');
      final activeId = await _storage.read(key: 'ai_active_profile_id');

      if (profilesJson != null && profilesJson.isNotEmpty) {
        final List<dynamic> decoded = Uri.splitQueryString(profilesJson).entries
            .map((e) => e.key)
            .toList();
        _profiles = [];
      }

      if (_profiles.isEmpty) {
        _profiles = [
          ConnectionProfile(
            id: const Uuid().v4(),
            name: 'SiliconFlow 默认',
            mode: ConnectionMode.chatCompletion,
            chatProvider: ChatCompletionProvider.siliconflow,
            baseUrl: 'https://api.siliconflow.cn',
            apiKey: '',
            model: 'Pro',
            options: {'temperature': 0.8, 'maxTokens': 4000},
          ),
        ];
        await _saveProfiles();
      }

      _activeProfile = _profiles.firstWhere(
        (p) => p.id == activeId,
        orElse: () => _profiles.first,
      );

      _loadProfileToForm(_activeProfile!);
    } catch (e) {
      _profiles = [];
    }

    setState(() => _isLoading = false);
  }

  void _loadProfileToForm(ConnectionProfile profile) {
    _nameController.text = profile.name;
    _baseUrlController.text = profile.baseUrl;
    _apiKeyController.text = profile.apiKey;
    _modelController.text = profile.model;
    _temperature = (profile.options['temperature'] as num?)?.toDouble() ?? 0.8;
    _maxTokens = (profile.options['maxTokens'] as num?)?.toInt() ?? 4000;
    _topP = (profile.options['topP'] as num?)?.toDouble() ?? 0.9;
    _topK = (profile.options['topK'] as num?)?.toDouble() ?? 40;
    _frequencyPenalty = (profile.options['frequencyPenalty'] as num?)?.toDouble() ?? 0.0;
    _presencePenalty = (profile.options['presencePenalty'] as num?)?.toDouble() ?? 0.0;
    _repetitionPenalty = (profile.options['repetitionPenalty'] as num?)?.toDouble() ?? 1.0;
    _contextLength = (profile.options['contextLength'] as num?)?.toInt() ?? 4096;
    _streaming = profile.options['streaming'] as bool? ?? true;
    _promptConverter = PromptConverter.values.firstWhere(
      (p) => p.name == profile.options['promptConverter'],
      orElse: () => PromptConverter.none,
    );
    _bypassApiStatusCheck = profile.options['bypassApiStatusCheck'] as bool? ?? false;
    _customIncludeBody = profile.options['customIncludeBody'] as String? ?? '';
    _customExcludeBody = profile.options['customExcludeBody'] as String? ?? '';
    _customIncludeHeaders = profile.options['customIncludeHeaders'] as String? ?? '';
  }

  ConnectionProfile _formToProfile({ConnectionProfile? original}) {
    // Chat Mode检测 - 包括自定义URL（不含localhost和已知text provider）
    final url = _baseUrlController.text.toLowerCase();
    final isChatMode = url.contains('openai') ||
        url.contains('anthropic') ||
        url.contains('siliconflow') ||
        url.contains('moonshot') ||
        url.contains('deepseek') ||
        url.contains('groq') ||
        url.contains('mistral') ||
        url.contains('llamastudio') ||
        url.contains('localai') ||
        url.contains('lmstudio') ||
        url.contains('sillytavern') ||
        // 自定义URL如果包含/v1/chat认为是chat模式
        url.contains('/v1/chat') ||
        // 不包含localhost和已知text provider关键词的认为是chat
        (!url.contains('localhost') && !url.contains('kobold') && !url.contains('oobabooga') && !url.contains('ollama') && !url.contains('vllm') && !url.contains('text'));

    ChatCompletionProvider? chatProv;
    TextCompletionProvider? textProv;

    if (isChatMode) {
      chatProv = ChatCompletionProvider.values.firstWhere(
        (p) => url.contains(p.displayName.toLowerCase().replaceAll(' ', '')),
        orElse: () => ChatCompletionProvider.custom,
      );
    } else {
      textProv = TextCompletionProvider.values.firstWhere(
        (p) => url.contains(p.displayName.toLowerCase()),
        orElse: () => TextCompletionProvider.generic,
      );
    }

    return ConnectionProfile(
      id: original?.id ?? const Uuid().v4(),
      name: _nameController.text.isEmpty ? '未命名' : _nameController.text,
      mode: isChatMode ? ConnectionMode.chatCompletion : ConnectionMode.textCompletion,
      chatProvider: chatProv,
      textProvider: textProv,
      baseUrl: _baseUrlController.text,
      apiKey: _apiKeyController.text,
      model: _modelController.text,
      options: {
        'temperature': _temperature,
        'maxTokens': _maxTokens,
        'topP': _topP,
        'topK': _topK,
        'frequencyPenalty': _frequencyPenalty,
        'presencePenalty': _presencePenalty,
        'repetitionPenalty': _repetitionPenalty,
        'contextLength': _contextLength,
        'streaming': _streaming,
        'promptConverter': _promptConverter.name,
        'bypassApiStatusCheck': _bypassApiStatusCheck,
        // Custom API 高级选项
        'customIncludeBody': _customIncludeBody,
        'customExcludeBody': _customExcludeBody,
        'customIncludeHeaders': _customIncludeHeaders,
      },
    );
  }

  // Custom API 高级选项
  String _customIncludeBody = '';
  String _customExcludeBody = '';
  String _customIncludeHeaders = '';

  Future<void> _saveProfiles() async {
    final ids = _profiles.map((p) => p.id).join(',');
    await _storage.write(key: 'ai_profiles_ids', value: ids);
    for (final profile in _profiles) {
      await _storage.write(key: 'ai_profile_${profile.id}', value: _encodeProfile(profile));
    }
  }

  String _encodeProfile(ConnectionProfile profile) {
    return Uri.encodeComponent(profile.toJson().toString());
  }

  Future<void> _saveCurrentProfile() async {
    final profile = _formToProfile(original: _activeProfile);

    if (_editingIndex != null && _editingIndex! < _profiles.length) {
      _profiles[_editingIndex!] = profile;
    } else {
      if (_profiles.isEmpty) {
        _profiles.add(profile);
      } else {
        _profiles[0] = profile;
      }
    }

    _activeProfile = profile;
    await _saveProfiles();
    await _storage.write(key: 'ai_active_profile_id', value: profile.id);
    await _saveProfileSettings(profile);

    // 重新初始化AI仓库以应用新设置
    await reinitAIRepository();

    setState(() => _isEditing = false);
    if (mounted) {
      _showSnackBar('设置已保存', Colors.green);
    }
  }

  Future<void> _saveProfileSettings(ConnectionProfile profile) async {
    await _storage.write(key: 'ai_provider', value: profile.chatProvider?.name ?? profile.textProvider?.name ?? 'custom');
    await _storage.write(key: 'ai_base_url', value: profile.baseUrl);
    await _storage.write(key: 'ai_api_key', value: profile.apiKey);
    await _storage.write(key: 'ai_model', value: profile.model);
    await _storage.write(key: 'ai_temperature', value: _temperature.toString());
    await _storage.write(key: 'ai_max_tokens', value: _maxTokens.toString());
    await _storage.write(key: 'ai_top_p', value: _topP.toString());
    await _storage.write(key: 'ai_top_k', value: _topK.toString());
  }

  void _onProviderChanged(ChatCompletionProvider provider) {
    setState(() {
      _baseUrlController.text = provider.defaultBaseUrl;
      if (provider.defaultModels.isNotEmpty) {
        _modelController.text = provider.defaultModels.first;
      }
    });
  }

  // ============================================================
  // Test Connection (SillyTavern-style)
  // ============================================================
  List<String> _availableModels = [];
  bool _isLoadingModels = false;

  Future<void> _testConnection() async {
    if (_baseUrlController.text.isEmpty || _apiKeyController.text.isEmpty) {
      _showSnackBar('请填写 API 地址和 Key', Colors.orange);
      return;
    }

    _showLoadingDialog('正在测试连接...');

    try {
      final profile = _formToProfile();
      final result = await _makeTestRequest(profile);

      if (mounted) {
        Navigator.pop(context);
        _showBanner('✓ 连接成功！AI回复: $result', _ConnectionBannerState.success);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showError(e);
      }
    }
  }



  /// 获取支持的模型列表 (SillyTavern-style /v1/models API)
  Future<void> _fetchAvailableModels() async {
    var baseUrl = _baseUrlController.text.trim().replaceAll(RegExp(r'/$'), '');
    var apiKey = _apiKeyController.text.trim();

    if (baseUrl.isEmpty) {
      _showSnackBar('请先填写 API 地址', Colors.orange);
      return;
    }

    setState(() => _isLoadingModels = true);

    // LM Studio 等本地API不需要真实key
    final effectiveApiKey = apiKey.isEmpty ? 'lm-studio' : apiKey;

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ));

      List<String> models = [];

      // 尝试多种模型列表端点
      final modelEndpoints = [
        '$baseUrl/v1/models',
        '$baseUrl/models',
        '$baseUrl/api/tags',  // Ollama 格式
      ];

      for (final endpoint in modelEndpoints) {
        try {
          final response = await dio.get(
            endpoint,
            options: Options(headers: {'Authorization': 'Bearer $effectiveApiKey'}),
          );

          if (response.data != null) {
            // OpenAI format: { "data": [{ "id": "model-1" }, ...] }
            if (response.data['data'] is List) {
              final data = response.data['data'];
              models = data.map((m) => m['id']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
              if (models.isNotEmpty) break;
            }
            // Ollama format: { "models": [{ "name": "llama3", ... }] }
            else if (response.data['models'] is List) {
              final data = response.data['models'];
              models = data.map((m) => m['name']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
              if (models.isNotEmpty) break;
            }
            // LM Studio 格式: { "data": [{ "id": "..." }] }
            else if (response.data is List) {
              models = response.data.map((m) => m['id']?.toString() ?? m['name']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
              if (models.isNotEmpty) break;
            }
          }
        } catch (e) {
          // 尝试下一个端点
          continue;
        }
      }

      if (mounted) {
        setState(() {
          _availableModels = models;
          _isLoadingModels = false;
        });

        if (models.isEmpty) {
          _showSnackBar('未找到模型，请手动输入模型名称', Colors.orange);
        } else {
          _showSnackBar('获取到 ${models.length} 个模型', Colors.green);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingModels = false);
        _showSnackBar('获取模型列表失败，请手动输入', Colors.orange);
      }
    }
  }

  // ============================================================
  // SillyTavern-style API Request Methods
  // ============================================================

  /// 发送测试请求 (SillyTavern完全复刻)
  Future<String> _makeTestRequest(ConnectionProfile profile) async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ));

    // 统一的测试prompt
    const prompt = 'say hi';

    // 根据Provider发送请求
    if (profile.chatProvider != null) {
      return await _makeChatCompletionRequest(dio, profile, prompt);
    } else if (profile.textProvider != null) {
      return await _makeTextCompletionRequest(dio, profile, prompt);
    }

    throw Exception('未配置任何API Provider');
  }

  /// 聊天补全API请求 (SillyTavern风格)
  Future<String> _makeChatCompletionRequest(Dio dio, ConnectionProfile profile, String prompt) async {
    final baseUrl = profile.baseUrl.trim().replaceAll(RegExp(r'/$'), '');
    final apiKey = profile.apiKey.trim();
    final model = profile.model.trim();

    // 构建请求头
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    // 构建请求体
    final body = <String, dynamic>{
      'model': model.isNotEmpty ? model : 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 50,
      'temperature': 0.5,
    };

    // 根据Provider确定端点
    String endpoint;
    switch (profile.chatProvider!) {
      case ChatCompletionProvider.openai:
      case ChatCompletionProvider.openaiLegacy:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.siliconflow:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.groq:
        endpoint = '$baseUrl/openai/v1/chat/completions';
        break;
      case ChatCompletionProvider.deepseek:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.moonshot:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.fireworks:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.openrouter:
        endpoint = '$baseUrl/api/v1/chat/completions';
        break;
      case ChatCompletionProvider.claude:
        // Claude 专用格式
        headers['x-api-key'] = apiKey;
        headers['anthropic-version'] = '2023-06-01';
        body.remove('model');
        body['model'] = model.isNotEmpty ? model : 'claude-3-haiku-20240307';
        endpoint = '$baseUrl/v1/messages';
        final response = await dio.post(
          endpoint,
          data: body,
          options: Options(headers: headers),
        );
        return response.data['content'][0]['text'] ?? '成功';

      case ChatCompletionProvider.mistralai:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.azureOpenAI:
        endpoint = '$baseUrl/chat/completions?api-version=2023-05-15';
        headers.remove('Authorization');
        headers['api-key'] = apiKey;
        break;
      case ChatCompletionProvider.xai:
        endpoint = '$baseUrl/v1/chat/completions';
        break;
      case ChatCompletionProvider.perplexity:
        endpoint = '$baseUrl/chat/completions';
        break;
      case ChatCompletionProvider.vertexai:
        throw Exception('VertexAI 需要额外配置，请使用其他Provider');
      case ChatCompletionProvider.ai21:
      case ChatCompletionProvider.cohere:
      case ChatCompletionProvider.zai:
      case ChatCompletionProvider.sillytavernAPI:
      case ChatCompletionProvider.makersuite:
      case ChatCompletionProvider.electronhub:
      case ChatCompletionProvider.chutes:
      case ChatCompletionProvider.nanogpt:
      case ChatCompletionProvider.aimlapi:
      case ChatCompletionProvider.pollinations:
      case ChatCompletionProvider.cometapi:
      case ChatCompletionProvider.single:
        // 自定义或Generic格式
        if (baseUrl.isNotEmpty) {
          endpoint = baseUrl.endsWith('/v1/chat/completions')
              ? baseUrl
              : baseUrl.endsWith('/chat/completions')
                  ? baseUrl
                  : '$baseUrl/v1/chat/completions';
        } else {
          throw Exception('请填写API地址');
        }
        break;
      case ChatCompletionProvider.custom:
        // Custom 完全自定义
        endpoint = baseUrl.isNotEmpty ? baseUrl : throw Exception('请填写API地址');
        break;
    }

    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );

      // 解析OpenAI格式响应
      if (response.data['choices'] != null && response.data['choices'].isNotEmpty) {
        return response.data['choices'][0]['message']['content'] ?? '成功';
      }
      throw Exception('响应格式错误');
    } on DioException catch (e) {
      // 如果是 401/403 且有apiKey，可能是key问题
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception('API Key无效或无权限');
      }
      // 如果是404，可能是端点问题
      if (e.response?.statusCode == 404) {
        throw Exception('API端点不存在: $endpoint');
      }
      rethrow;
    }
  }

  /// 文本补全API请求 (SillyTavern风格)
  Future<String> _makeTextCompletionRequest(Dio dio, ConnectionProfile profile, String prompt) async {
    final baseUrl = profile.baseUrl.trim().replaceAll(RegExp(r'/$'), '');
    final apiKey = profile.apiKey.trim();
    final model = profile.model.trim();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    String endpoint;
    dynamic body;

    switch (profile.textProvider!) {
      case TextCompletionProvider.ollama:
        endpoint = '$baseUrl/api/generate';
        body = {
          'model': model.isNotEmpty ? model : 'llama3',
          'prompt': prompt,
          'stream': false,
        };
        headers.remove('Authorization');
        final response = await dio.post(endpoint, data: body, options: Options(headers: headers));
        return response.data['response'] ?? '成功';

      case TextCompletionProvider.koboldcpp:
      case TextCompletionProvider.oobabooga:
      case TextCompletionProvider.vllm:
      case TextCompletionProvider.aphrodite:
      case TextCompletionProvider.tabby:
      case TextCompletionProvider.llamacpp:
      case TextCompletionProvider.generic:
        endpoint = '$baseUrl/v1/completions';
        body = {
          'model': model.isNotEmpty ? model : 'gpt-2',
          'prompt': prompt,
          'max_tokens': 50,
          'temperature': 0.5,
        };
        break;

      case TextCompletionProvider.togetherai:
        endpoint = '$baseUrl/v1/completions';
        body = {
          'model': model.isNotEmpty ? model : 'Gryphe/MythoMax-L2-13b',
          'prompt': prompt,
          'max_tokens': 50,
        };
        break;

      case TextCompletionProvider.mancer:
      case TextCompletionProvider.infermaticai:
      case TextCompletionProvider.dreamgen:
      case TextCompletionProvider.featherless:
      case TextCompletionProvider.huggingface:
        endpoint = baseUrl.endsWith('/v1/completions') ? baseUrl : '$baseUrl/v1/completions';
        body = {
          'model': model,
          'prompt': prompt,
          'max_tokens': 50,
        };
        break;
    }

    final response = await dio.post(endpoint, data: body, options: Options(headers: headers));

    if (response.data['choices'] != null && response.data['choices'].isNotEmpty) {
      return response.data['choices'][0]['text'] ?? '成功';
    }
    throw Exception('响应格式错误');
    // Text Completion APIs
    if (profile.textProvider != null) {
      switch (profile.textProvider!) {
        case TextCompletionProvider.koboldcpp:
        case TextCompletionProvider.oobabooga:
        case TextCompletionProvider.vllm:
        case TextCompletionProvider.aphrodite:
        case TextCompletionProvider.tabby:
        case TextCompletionProvider.llamacpp:
        case TextCompletionProvider.generic:
          final response = await dio.post(
            profile.baseUrl + (profile.textProvider?.endpoint ?? '/v1/completions'),
            data: {
              'prompt': prompt,
              'max_length': 50,
              'temperature': 0.5,
            },
            options: Options(headers: {'Authorization': 'Bearer ${profile.apiKey}'}),
          );
          return response.data['choices'][0]['text'] ?? '成功';

        case TextCompletionProvider.ollama:
          final response = await dio.post(
            '${profile.baseUrl}/api/generate',
            data: {
              'model': profile.model.isEmpty ? 'llama3' : profile.model,
              'prompt': prompt,
              'stream': false,
            },
          );
          return response.data['response'] ?? '成功';

        case TextCompletionProvider.togetherai:
          final response = await dio.post(
            '${profile.baseUrl}/v1/completions',
            data: {
              'model': profile.model.isEmpty ? 'Gryphe/MythoMax-L2-13b' : profile.model,
              'prompt': prompt,
              'max_tokens': 50,
            },
            options: Options(headers: {'Authorization': 'Bearer ${profile.apiKey}'}),
          );
          return response.data['choices'][0]['text'] ?? '成功';

        case TextCompletionProvider.mancer:
        case TextCompletionProvider.infermaticai:
        case TextCompletionProvider.dreamgen:
        case TextCompletionProvider.featherless:
        case TextCompletionProvider.huggingface:
          throw Exception('该Provider请使用专属配置');
      }
    }

    throw Exception('未知的API类型');
  }

  void _showError(dynamic e) {
    String msg = '连接失败';
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          msg = '连接超时，请检查网络';
          break;
        case DioExceptionType.receiveTimeout:
          msg = '响应超时，请稍后重试';
          break;
        default:
          if (e.response?.statusCode == 401) msg = 'API Key无效';
          else if (e.response?.statusCode == 403) msg = '访问被拒绝';
          else if (e.response?.statusCode == 429) msg = '请求过于频繁';
          else if (e.response?.statusCode == 404) msg = 'API地址错误';
          else msg = '${e.response?.statusCode ?? "网络"}错误';
      }
    }
    _showBanner('$msg: ${e.toString()}', _ConnectionBannerState.error);
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Text(message),
        ]),
      ),
    );
  }

  void _showBanner(String message, _ConnectionBannerState state) {
    setState(() {
      _bannerMessage = message;
      _bannerState = state;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _bannerState == state) {
        setState(() => _bannerState = _ConnectionBannerState.idle);
      }
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Widget _buildConnectionBanner() {
    if (_bannerState == _ConnectionBannerState.idle) {
      return const SizedBox.shrink();
    }
    Color bgColor;
    Color textColor;
    IconData icon;
    switch (_bannerState) {
      case _ConnectionBannerState.testing:
        bgColor = AppColors.primaryIndigo.withOpacity(0.1);
        textColor = AppColors.primaryIndigo;
        icon = Icons.sync;
        break;
      case _ConnectionBannerState.success:
        bgColor = AppColors.success.withOpacity(0.12);
        textColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case _ConnectionBannerState.error:
        bgColor = AppColors.error.withOpacity(0.12);
        textColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case _ConnectionBannerState.warning:
        bgColor = AppColors.warning.withOpacity(0.12);
        textColor = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      case _ConnectionBannerState.idle:
        return const SizedBox.shrink();
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: textColor.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _bannerMessage,
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: textColor.withOpacity(0.5), size: 16),
            onPressed: () => setState(() => _bannerState = _ConnectionBannerState.idle),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 连接设置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testConnection,
            tooltip: '测试连接',
          ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildConnectionBanner(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.03, 0), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ));
              },
              child: _isEditing
                  ? KeyedSubtree(key: const ValueKey('edit'), child: _buildEditMode())
                  : KeyedSubtree(key: const ValueKey('view'), child: _buildViewMode()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    final profile = _activeProfile ?? _profiles.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatusCard(profile),
        const SizedBox(height: 16),
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildStatusCard(ConnectionProfile profile) {
    final isConfigured = profile.apiKey.isNotEmpty;
    final statusColor = isConfigured ? AppColors.success : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderLg,
        boxShadow: AppShadows.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isConfigured ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                color: statusColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(profile.name, style: AppTypography.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${profile.mode == ConnectionMode.chatCompletion ? "Chat" : "Text"} • ${profile.chatProvider?.displayName ?? profile.textProvider?.displayName ?? "Unknown"}',
                  style: AppTypography.bodyMedium,
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Text(
                isConfigured ? '已配置' : '未配置',
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
          if (isConfigured) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),
            _buildInfoRow('地址', profile.baseUrl),
            _buildInfoRow('模型', profile.model),
            _buildInfoRow('Temperature', '${profile.options['temperature'] ?? 0.8}'),
            _buildInfoRow('Max Tokens', '${profile.options['maxTokens'] ?? 4000}'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 100, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
        Expanded(child: Text(value, style: const TextStyle(fontFamily: 'monospace'))),
      ]),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _testConnection,
          icon: const Icon(Icons.play_arrow),
          label: const Text('测试连接'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(() => _isEditing = true),
          icon: const Icon(Icons.settings),
          label: const Text('编辑配置'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Provider selector (SillyTavern style)
        _buildSectionTitle('AI 提供商 (Chat Completion)'),
        _buildChatProviderSelector(),
        const SizedBox(height: 24),

        // Basic config
        _buildSectionTitle('基本配置'),
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: '配置名称', hintText: '例如：我的OpenAI')),
        const SizedBox(height: 12),
        TextField(controller: _baseUrlController, decoration: const InputDecoration(labelText: 'API 地址', hintText: 'https://api.example.com')),
        const SizedBox(height: 12),
        TextField(controller: _apiKeyController, decoration: const InputDecoration(labelText: 'API Key', hintText: 'sk-...'), obscureText: true),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _modelController, decoration: const InputDecoration(labelText: '模型', hintText: 'gpt-3.5-turbo'))),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isLoadingModels ? null : _fetchAvailableModels,
            icon: _isLoadingModels
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            tooltip: '从API获取模型列表',
          ),
        ]),
        // 模型列表 (如果有)
        if (_availableModels.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableModels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final model = _availableModels[index];
                final isSelected = _modelController.text == model;
                return FilterChip(
                  label: Text(model, style: const TextStyle(fontSize: 11)),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _modelController.text = model),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Generation params (SillyTavern style)
        _buildSectionTitle('生成参数'),
        _buildSliderOption('Temperature', _temperature, 0.0, 2.0, (v) => setState(() => _temperature = v)),
        _buildSliderOption('Max Tokens', _maxTokens.toDouble(), 100, 8000, (v) => setState(() => _maxTokens = v.toInt()), divisions: 79, isInt: true),
        _buildSliderOption('Top P', _topP, 0.0, 1.0, (v) => setState(() => _topP = v)),
        _buildSliderOption('Top K', _topK, 0.0, 100, (v) => setState(() => _topK = v), divisions: 100, isInt: true),
        _buildSliderOption('Frequency Penalty', _frequencyPenalty, -2.0, 2.0, (v) => setState(() => _frequencyPenalty = v)),
        _buildSliderOption('Presence Penalty', _presencePenalty, -2.0, 2.0, (v) => setState(() => _presencePenalty = v)),
        _buildSliderOption('Repetition Penalty', _repetitionPenalty, 1.0, 2.0, (v) => setState(() => _repetitionPenalty = v)),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('流式输出 (Streaming)'),
          value: _streaming,
          onChanged: (v) => setState(() => _streaming = v),
        ),
        const SizedBox(height: 16),

        // Prompt Post-Processing (SillyTavern-style)
        _buildSectionTitle('Prompt后处理'),
        const Text('控制发送给API的prompt格式', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PromptConverter.values.map((converter) {
            final isSelected = _promptConverter == converter;
            return ChoiceChip(
              label: Text(converter.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _promptConverter = converter);
              },
              tooltip: converter.description,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Bypass API状态检查'),
          subtitle: const Text('当API正常但显示警告时启用', style: TextStyle(fontSize: 11)),
          value: _bypassApiStatusCheck,
          onChanged: (v) => setState(() => _bypassApiStatusCheck = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 16),

        // Custom API 高级选项 (SillyTavern style)
        if (_activeProfile?.chatProvider == ChatCompletionProvider.custom ||
            _activeProfile?.chatProvider == ChatCompletionProvider.sillytavernAPI) ...[
          _buildSectionTitle('Custom API 高级选项'),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Include Body',
              hintText: '例如: usage, model',
              isDense: true,
            ),
            controller: TextEditingController(text: _customIncludeBody),
            onChanged: (v) => _customIncludeBody = v,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Exclude Body',
              hintText: '例如: id, created',
              isDense: true,
            ),
            controller: TextEditingController(text: _customExcludeBody),
            onChanged: (v) => _customExcludeBody = v,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Custom Headers (JSON)',
              hintText: '例如: {"X-Custom-Key": "value"}',
              isDense: true,
            ),
            controller: TextEditingController(text: _customIncludeHeaders),
            onChanged: (v) => _customIncludeHeaders = v,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 24),

        // Actions
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () {_loadProfileToForm(_activeProfile!); setState(() => _isEditing = false);}, child: const Text('取消'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: _saveCurrentProfile, child: const Text('保存'))),
        ]),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: _testConnection, icon: const Icon(Icons.play_arrow), label: const Text('测试连接')),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChatProviderSelector() {
    // Popular providers first
    final popular = [
      ChatCompletionProvider.siliconflow,
      ChatCompletionProvider.openai,
      ChatCompletionProvider.deepseek,
      ChatCompletionProvider.groq,
      ChatCompletionProvider.claude,
      ChatCompletionProvider.moonshot,
      ChatCompletionProvider.mistralai,
      ChatCompletionProvider.openrouter,
    ];
    final others = ChatCompletionProvider.values
        .where((p) => !popular.contains(p))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Popular providers as cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [...popular, ...others].map((provider) {
            final isSelected = _activeProfile?.chatProvider == provider;
            return GestureDetector(
              onTap: () => _onProviderChanged(provider),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryIndigo.withOpacity(0.12)
                      : AppColors.cardWhite,
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryIndigo : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    provider.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.primaryIndigo : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSliderOption(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    int? divisions,
    bool isInt = false,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label),
        Text(isInt ? value.toInt().toString() : value.toStringAsFixed(2), style: TextStyle(color: Colors.grey[600])),
      ]),
      Slider(value: value.clamp(min, max), min: min, max: max, divisions: divisions, onChanged: onChanged),
    ]);
  }
}
