import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

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
    final url = await _storage.read(key: 'api_url');
    final key = await _storage.read(key: 'api_key');
    final model = await _storage.read(key: 'api_model');
    
    setState(() {
      _urlController.text = url ?? '';
      _keyController.text = key ?? '';
      _modelController.text = model ?? 'gpt-3.5-turbo';
      _loading = false;
    });
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
      setState(() {
        _result = '请填写API地址';
        _success = false;
      });
      return;
    }

    if (key.isEmpty) {
      setState(() {
        _result = '请填写API Key';
        _success = false;
      });
      return;
    }

    setState(() {
      _testing = true;
      _result = null;
    });

    try {
      // 构建完整URL
      String endpoint = url;
      if (!endpoint.endsWith('/v1/chat/completions')) {
        endpoint = endpoint.replaceAll(RegExp(r'/$'), '');
        endpoint = '$endpoint/v1/chat/completions';
      }

      // 发送HTTP请求
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(Uri.parse(endpoint));
      
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization', 'Bearer $key');
      
      final body = jsonEncode({
        'model': model.isEmpty ? 'gpt-3.5-turbo' : model,
        'messages': [
          {'role': 'user', 'content': 'say hi'}
        ],
        'max_tokens': 20,
      });
      
      request.write(body);
      
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      
      final responseBody = await response.transform(utf8.decoder).join();
      
      setState(() {
        _testing = false;
        if (response.statusCode == 200) {
          _success = true;
          _result = '连接成功';
        } else {
          _success = false;
          _result = 'HTTP ${response.statusCode}: $responseBody';
        }
      });
      
    } catch (e) {
      setState(() {
        _testing = false;
        _success = false;
        _result = e.toString();
      });
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
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfig,
          ),
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
                      hintText: 'https://api.openai.com/v1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      hintText: 'sk-...',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: '模型',
                      hintText: 'gpt-3.5-turbo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _testing ? null : _testApi,
                    child: _testing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('测试连接'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_success ?? false)
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (_success ?? false)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (_success ?? false)
                                ? Icons.check_circle
                                : Icons.error,
                            color: (_success ?? false)
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _result!,
                              style: TextStyle(
                                color: (_success ?? false)
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
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
