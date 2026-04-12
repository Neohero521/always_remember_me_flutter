import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();
final _dio = Dio();

class ApiConfigScreen extends StatefulWidget {
  const ApiConfigScreen({super.key});

  @override
  State<ApiConfigScreen> createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  final _urlController = TextEditingController();
  final _keyController = TextEditingController();
  final _modelController = TextEditingController();
  
  bool _loading = false;
  bool _testing = false;
  String? _result;
  bool? _success;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _loading = true);
    _urlController.text = await _storage.read(key: 'api_url') ?? '';
    _keyController.text = await _storage.read(key: 'api_key') ?? '';
    _modelController.text = await _storage.read(key: 'api_model') ?? 'gpt-3.5-turbo';
    setState(() => _loading = false);
  }

  Future<void> _saveConfig() async {
    await _storage.write(key: 'api_url', value: _urlController.text);
    await _storage.write(key: 'api_key', value: _keyController.text);
    await _storage.write(key: 'api_model', value: _modelController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _testApi() async {
    final url = _urlController.text.trim();
    final key = _keyController.text.trim();
    final model = _modelController.text.trim();

    if (url.isEmpty) {
      setState(() { _result = '请填写API地址'; _success = false; });
      return;
    }
    if (key.isEmpty) {
      setState(() { _result = '请填写API Key'; _success = false; });
      return;
    }

    setState(() { _testing = true; _result = null; });

    try {
      // 构建完整URL
      String endpoint = url.replaceAll(RegExp(r'/$'), '');
      if (!endpoint.endsWith('/v1/chat/completions')) {
        endpoint = '$endpoint/v1/chat/completions';
      }

      final response = await _dio.post(
        endpoint,
        data: {
          'model': model.isEmpty ? 'gpt-3.5-turbo' : model,
          'messages': [{'role': 'user', 'content': 'say hi'}],
          'max_tokens': 20,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      setState(() {
        _testing = false;
        if (response.statusCode == 200) {
          _success = true;
          _result = '连接成功!';
        } else {
          _success = false;
          _result = 'HTTP ${response.statusCode}';
        }
      });
    } on DioException catch (e) {
      setState(() {
        _testing = false;
        _success = false;
        _result = _getDioError(e);
      });
    } catch (e) {
      setState(() {
        _testing = false;
        _success = false;
        _result = e.toString();
      });
    }
  }

  String _getDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 403) return '认证失败 - Key无效';
    if (status == 404) return '端点不存在 (404)';
    if (status == 429) return '请求太频繁';
    if (status != null && status >= 500) return '服务器错误 ($status)';
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.connectionError:
        return '无法连接服务器';
      case DioExceptionType.receiveTimeout:
        return '响应超时';
      default:
        return e.message ?? '未知错误';
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'API地址',
                      hintText: 'https://api.sillytaverns.com/v1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: '模型',
                      hintText: 'gemini-2.5-flash',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _testing ? null : _testApi,
                    child: _testing
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('测试连接'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_success ?? false) ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: (_success ?? false) ? Colors.green : Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (_success ?? false) ? Icons.check_circle : Icons.error,
                            color: (_success ?? false) ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _result!,
                              style: TextStyle(
                                color: (_success ?? false) ? Colors.green.shade700 : Colors.red.shade700,
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
