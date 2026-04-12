import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

/// API配置状态
class ApiConfig {
  final String name;
  final String baseUrl;
  final String apiKey;
  final String model;
  final double temperature;
  final int maxTokens;

  const ApiConfig({
    this.name = '默认配置',
    this.baseUrl = '',
    this.apiKey = '',
    this.model = 'gpt-3.5-turbo',
    this.temperature = 0.7,
    this.maxTokens = 4000,
  });

  ApiConfig copyWith({
    String? name,
    String? baseUrl,
    String? apiKey,
    String? model,
    double? temperature,
    int? maxTokens,
  }) {
    return ApiConfig(
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'baseUrl': baseUrl,
    'apiKey': apiKey,
    'model': model,
    'temperature': temperature,
    'maxTokens': maxTokens,
  };

  factory ApiConfig.fromJson(Map<String, dynamic> json) {
    return ApiConfig(
      name: json['name'] ?? '默认配置',
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      model: json['model'] ?? 'gpt-3.5-turbo',
      temperature: (json['temperature'] ?? 0.7).toDouble(),
      maxTokens: json['maxTokens'] ?? 4000,
    );
  }
}

/// API配置Provider
final apiConfigProvider = StateNotifierProvider<ApiConfigNotifier, ApiConfig>((ref) {
  return ApiConfigNotifier();
});

class ApiConfigNotifier extends StateNotifier<ApiConfig> {
  ApiConfigNotifier() : super(const ApiConfig());

  void updateBaseUrl(String url) => state = state.copyWith(baseUrl: url);
  void updateApiKey(String key) => state = state.copyWith(apiKey: key);
  void updateModel(String model) => state = state.copyWith(model: model);
  void updateTemperature(double temp) => state = state.copyWith(temperature: temp);
  void updateMaxTokens(int tokens) => state = state.copyWith(maxTokens: tokens);

  Future<void> loadFromStorage() async {
    final data = await _storage.read(key: 'api_config');
    if (data != null) {
      try {
        state = ApiConfig.fromJson(jsonDecode(data));
      } catch (_) {}
    }
  }

  Future<void> saveToStorage() async {
    await _storage.write(key: 'api_config', value: jsonEncode(state.toJson()));
  }
}

/// 测试连接结果
class ConnectionTestResult {
  final bool success;
  final String message;
  final String? response;

  const ConnectionTestResult({required this.success, required this.message, this.response});
}

/// API服务
class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
  ));

  /// 测试API连接
  static Future<ConnectionTestResult> testConnection({
    required String baseUrl,
    required String apiKey,
    required String model,
  }) async {
    if (baseUrl.isEmpty) {
      return const ConnectionTestResult(success: false, message: '请填写API地址');
    }
    if (apiKey.isEmpty) {
      return const ConnectionTestResult(success: false, message: '请填写API Key');
    }

    // 确保URL格式正确
    String endpoint = baseUrl.trim();
    if (!endpoint.endsWith('/v1/chat/completions')) {
      endpoint = endpoint.replaceAll(RegExp(r'/$'), '');
      endpoint = '$endpoint/v1/chat/completions';
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'model': model.isNotEmpty ? model : 'gpt-3.5-turbo',
          'messages': [{'role': 'user', 'content': 'say hi'}],
          'max_tokens': 20,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
      );

      if (response.statusCode == 200) {
        final content = response.data['choices']?[0]?['message']?['content'] ?? '成功';
        return ConnectionTestResult(
          success: true,
          message: '连接成功',
          response: content.toString(),
        );
      }

      return ConnectionTestResult(
        success: false,
        message: '响应异常: ${response.statusCode}',
      );
    } on DioException catch (e) {
      return ConnectionTestResult(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return ConnectionTestResult(
        success: false,
        message: '未知错误: $e',
      );
    }
  }

  static String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络或API地址';
      case DioExceptionType.connectionError:
        return '无法连接到服务器，请检查API地址';
      case DioExceptionType.receiveTimeout:
        return '响应超时，请稍后重试';
      default:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return '认证失败，API Key无效或无权限';
        }
        if (statusCode == 404) {
          return 'API端点不存在';
        }
        if (statusCode == 429) {
          return '请求过于频繁，请稍后重试';
        }
        if (statusCode != null && statusCode >= 500) {
          return '服务器错误 ($statusCode)';
        }
        return e.message ?? '请求失败';
    }
  }

  /// 发送写作请求
  static Stream<String> generateText({
    required String baseUrl,
    required String apiKey,
    required String model,
    required String prompt,
    double temperature = 0.7,
    int maxTokens = 4000,
  }) async* {
    String endpoint = baseUrl.trim();
    if (!endpoint.endsWith('/v1/chat/completions')) {
      endpoint = endpoint.replaceAll(RegExp(r'/$'), '');
      endpoint = '$endpoint/v1/chat/completions';
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'model': model,
          'messages': [{'role': 'user', 'content': prompt}],
          'temperature': temperature,
          'max_tokens': maxTokens,
          'stream': true,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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
    } catch (e) {
      yield '错误: $_handleDioError(e as DioException)';
    }
  }
}

/// 设置页面
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();

  bool _isLoading = false;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    await ref.read(apiConfigProvider.notifier).loadFromStorage();
    final config = ref.read(apiConfigProvider);
    _baseUrlController.text = config.baseUrl;
    _apiKeyController.text = config.apiKey;
    _modelController.text = config.model;
    setState(() => _isLoading = false);
  }

  Future<void> _saveConfig() async {
    final notifier = ref.read(apiConfigProvider.notifier);
    notifier.updateBaseUrl(_baseUrlController.text);
    notifier.updateApiKey(_apiKeyController.text);
    notifier.updateModel(_modelController.text);
    await notifier.saveToStorage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('配置已保存'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final result = await ApiService.testConnection(
      baseUrl: _baseUrlController.text,
      apiKey: _apiKeyController.text,
      model: _modelController.text,
    );

    setState(() {
      _isTesting = false;
      _testResult = result.message;
      _testSuccess = result.success;
    });
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API配置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfig,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // API地址
                  TextField(
                    controller: _baseUrlController,
                    decoration: const InputDecoration(
                      labelText: 'API地址',
                      hintText: 'https://api.openai.com/v1',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // API Key
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      hintText: 'sk-...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  // 模型
                  TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: '模型',
                      hintText: 'gpt-3.5-turbo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.smart_toy),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 测试连接按钮
                  ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testConnection,
                    icon: _isTesting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(_isTesting ? '测试中...' : '测试连接'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 测试结果
                  if (_testResult != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _testSuccess
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _testSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _testSuccess ? Icons.check_circle : Icons.error,
                            color: _testSuccess ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _testResult!,
                              style: TextStyle(
                                color: _testSuccess ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),

                  // 快速模板
                  const Text(
                    '快速模板',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTemplateChip('OpenAI', 'https://api.openai.com/v1', 'gpt-3.5-turbo'),
                      _buildTemplateChip('SiliconFlow', 'https://api.siliconflow.cn/v1', 'Pro'),
                      _buildTemplateChip('SillyTavern', 'https://api.sillytaverns.com/v1', 'gemini-2.5-flash'),
                      _buildTemplateChip('DeepSeek', 'https://api.deepseek.com/v1', 'deepseek-chat'),
                      _buildTemplateChip('Groq', 'https://api.groq.com/openai/v1', 'llama-3.1-70b-versatile'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTemplateChip(String name, String url, String model) {
    return ActionChip(
      label: Text(name),
      onPressed: () {
        setState(() {
          _baseUrlController.text = url;
          _modelController.text = model;
        });
      },
    );
  }
}
