import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// 浏览器User-Agent，用于绕过Cloudflare等WAF的检测
const _browserUserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

class ApiConfigScreen extends StatefulWidget {
  const ApiConfigScreen({super.key});

  @override
  State<ApiConfigScreen> createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  final _apiUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();

  bool _isLoading = true;
  bool _isTesting = false;
  String? _testResult;
  bool? _testSuccess;
  List<String> _availableModels = [];
  bool _isLoadingModels = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiUrlController.text = prefs.getString('api_url') ?? 'https://api.sillytaverns.com/v1';
      _apiKeyController.text = prefs.getString('api_key') ?? '';
      _modelController.text = prefs.getString('api_model') ?? 'gemini-2.5-flash';
      _isLoading = false;
    });
  }

  Future<void> _saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', _apiUrlController.text.trim());
    await prefs.setString('api_key', _apiKeyController.text.trim());
    await prefs.setString('api_model', _modelController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ 已保存'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _testConnection() async {
    final apiUrl = _apiUrlController.text.trim();
    final apiKey = _apiKeyController.text.trim();
    final model = _modelController.text.trim();

    if (apiUrl.isEmpty) {
      setState(() { _testResult = '请填写API地址'; _testSuccess = false; });
      return;
    }
    if (apiKey.isEmpty) {
      setState(() { _testResult = '请填写API Key'; _testSuccess = false; });
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = null;
    });

    try {
      // 构建endpoint
      String endpoint = apiUrl.replaceAll(RegExp(r'/$'), '');
      if (!endpoint.endsWith('/v1/chat/completions')) {
        endpoint = '$endpoint/v1/chat/completions';
      }

      final uri = Uri.parse(endpoint);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'User-Agent': _browserUserAgent,
        },
        body: jsonEncode({
          'model': model.isEmpty ? 'gpt-3.5-turbo' : model,
          'messages': [{'role': 'user', 'content': 'say hi'}],
          'max_tokens': 20,
        }),
      ).timeout(const Duration(seconds: 30));

      setState(() {
        _isTesting = false;
        if (response.statusCode == 200) {
          _testSuccess = true;
          _testResult = '✅ 连接成功!';
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          _testSuccess = false;
          _testResult = '❌ 认证失败: API Key无效';
        } else if (response.statusCode == 404) {
          _testSuccess = false;
          _testResult = '❌ 端点不存在(404)';
        } else {
          _testSuccess = false;
          _testResult = '❌ HTTP ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _testResult = '❌ $e';
      });
    }
  }

  Future<void> _fetchModels() async {
    final apiUrl = _apiUrlController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (apiUrl.isEmpty || apiKey.isEmpty) {
      setState(() => _testResult = '请先填写API地址和Key');
      return;
    }

    setState(() {
      _isLoadingModels = true;
      _availableModels = [];
    });

    try {
      // 猜测模型端点
      String base = apiUrl.replaceAll(RegExp(r'/$'), '');
      base = base.replaceAll(RegExp(r'/v\d+$'), '');

      final endpoints = [
        '$base/v1/models',
        '$base/models',
        '$base/api/v1/models',
      ];

      for (final endpoint in endpoints) {
        try {
          final uri = Uri.parse(endpoint);
          var response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'User-Agent': _browserUserAgent,
            },
          ).timeout(const Duration(seconds: 15));

          // 如果Bearer失败，尝试X-API-Key
          if (response.statusCode == 401 || response.statusCode == 403) {
            response = await http.get(
              uri,
              headers: {
                'X-API-Key': apiKey,
                'User-Agent': _browserUserAgent,
              },
            ).timeout(const Duration(seconds: 15));
          }

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final models = _parseModels(data);
            if (models.isNotEmpty) {
              setState(() {
                _availableModels = models;
                _isLoadingModels = false;
                if (_modelController.text.isEmpty && models.isNotEmpty) {
                  _modelController.text = models.first;
                }
              });
              return;
            }
          }
        } catch (_) {
          continue;
        }
      }

      setState(() {
        _testResult = '无法获取模型列表';
        _isLoadingModels = false;
      });
    } catch (e) {
      setState(() {
        _testResult = '获取模型失败: $e';
        _isLoadingModels = false;
      });
    }
  }

  List<String> _parseModels(Map<String, dynamic> data) {
    // OpenAI格式
    if (data.containsKey('data') && data['data'] is List) {
      return (data['data'] as List)
          .map((m) => m['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }
    // MiniMax格式
    if (data.containsKey('models') && data['models'] is List) {
      return (data['models'] as List)
          .map((m) => m['model_id']?.toString() ?? m['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }
    return [];
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API设置'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveConfig),
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
                    controller: _apiUrlController,
                    decoration: const InputDecoration(
                      labelText: 'API地址',
                      hintText: 'https://api.sillytaverns.com/v1',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    onChanged: (_) => setState(() {}),
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
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // 模型
                  TextField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: '模型',
                      hintText: 'gemini-2.5-flash',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.smart_toy),
                      suffixIcon: IconButton(
                        icon: _isLoadingModels
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.refresh),
                        onPressed: _isLoadingModels ? null : _fetchModels,
                        tooltip: '获取模型列表',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 模型列表
                  if (_availableModels.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableModels.take(10).map((model) {
                        return ActionChip(
                          label: Text(model, style: const TextStyle(fontSize: 12)),
                          onPressed: () {
                            setState(() => _modelController.text = model);
                          },
                        );
                      }).toList(),
                    ),
                    if (_availableModels.length > 10)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('还有 ${_availableModels.length - 10} 个模型...',
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // 测试连接按钮
                  ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testConnection,
                    icon: _isTesting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow),
                    label: Text(_isTesting ? '测试中...' : '测试连接'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  ),

                  // 测试结果
                  if (_testResult != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_testSuccess ?? false) ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: (_testSuccess ?? false) ? Colors.green : Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (_testSuccess ?? false) ? Icons.check_circle : Icons.error,
                            color: (_testSuccess ?? false) ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _testResult!,
                              style: TextStyle(
                                color: (_testSuccess ?? false) ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
