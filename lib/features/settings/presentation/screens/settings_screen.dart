import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection.dart';

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
  String? _selectedModel;
  List<Map<String, String>> _availableModels = [];
  bool _isLoadingModels = false;
  String? _modelsError;
  bool _isLoading = true;

  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    // 从 FlutterSecureStorage 读取（与 injection.dart 保持一致）
    _apiUrlController.text = await _secureStorage.read(key: 'ai_base_url') ?? 'https://api.siliconflow.cn';
    _apiKeyController.text = await _secureStorage.read(key: 'ai_api_key') ?? '';
    // 也兼容旧 SharedPreferences key
    final prefs = await SharedPreferences.getInstance();
    _selectedModel = prefs.getString('api_model');
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    // 写入 FlutterSecureStorage（与 injection.dart 读取的 key 一致）
    await _secureStorage.write(key: 'ai_base_url', value: _apiUrlController.text.trim());
    await _secureStorage.write(key: 'ai_api_key', value: _apiKeyController.text.trim());
    await _secureStorage.write(key: 'ai_provider', value: _isCustomUrl(_apiUrlController.text) ? 'custom' : 'siliconflow');

    // 保留旧 key 兼容
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', _apiUrlController.text.trim());
    await prefs.setString('api_key', _apiKeyController.text.trim());
    if (_selectedModel != null) {
      await prefs.setString('api_model', _selectedModel!);
    }

    // 重新初始化 AI Repository
    await reinitAIRepository();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ 配置已保存'), backgroundColor: Colors.green),
      );
    }
  }

  bool _isCustomUrl(String url) {
    return !url.contains('siliconflow.cn') && !url.contains('openai.com');
  }

  Future<void> _fetchModels() async {
    final apiUrl = _apiUrlController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (apiUrl.isEmpty || apiKey.isEmpty) {
      setState(() => _modelsError = '请先填写API地址和Key');
      return;
    }

    setState(() {
      _isLoadingModels = true;
      _modelsError = null;
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

      Exception? lastError;
      for (final endpoint in endpoints) {
        // 尝试Bearer token认证
        try {
          final response = await _makeRequest(endpoint, apiKey);
          final models = _parseModels(response);
          if (models.isNotEmpty) {
            setState(() {
              _availableModels = models;
              _isLoadingModels = false;
              if (_selectedModel == null && models.isNotEmpty) {
                _selectedModel = models.first['id'];
              }
            });
            return;
          }
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
        }

        // 尝试X-API-Key认证
        try {
          final response = await _makeRequestAlt(endpoint, apiKey);
          final models = _parseModels(response);
          if (models.isNotEmpty) {
            setState(() {
              _availableModels = models;
              _isLoadingModels = false;
              if (_selectedModel == null && models.isNotEmpty) {
                _selectedModel = models.first['id'];
              }
            });
            return;
          }
        } catch (_) {
          continue;
        }
      }

      throw lastError ?? Exception('无法获取模型列表');
    } catch (e) {
      setState(() {
        _modelsError = '获取失败: $e';
        _isLoadingModels = false;
      });
    }
  }

  Future<Map<String, dynamic>> _makeRequest(String url, String apiKey) async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'User-Agent': _browserUserAgent,
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) throw Exception('认证失败: API Key无效');
    if (response.statusCode == 403) throw Exception('访问被拒绝(403)');
    if (response.statusCode == 404) throw Exception('接口不存在(404)');
    if (response.statusCode != 200) throw Exception('请求失败(${response.statusCode})');

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _makeRequestAlt(String url, String apiKey) async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
        'User-Agent': _browserUserAgent,
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) throw Exception('认证失败: API Key无效');
    if (response.statusCode == 403) throw Exception('访问被拒绝(403)');
    if (response.statusCode == 404) throw Exception('接口不存在(404)');
    if (response.statusCode != 200) throw Exception('请求失败(${response.statusCode})');

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  List<Map<String, String>> _parseModels(Map<String, dynamic> data) {
    // OpenAI格式
    if (data.containsKey('data') && data['data'] is List) {
      return (data['data'] as List).map<Map<String, String>>((m) {
        final id = m['id']?.toString() ?? '';
        final ownedBy = m['owned_by']?.toString() ?? '';
        return {
          'id': id,
          'name': _formatModelName(id),
          'desc': ownedBy.isNotEmpty ? '由 $ownedBy 提供' : id,
        };
      }).toList();
    }
    // MiniMax格式
    if (data.containsKey('models') && data['models'] is List) {
      return (data['models'] as List).map<Map<String, String>>((m) {
        final id = m['model_id']?.toString() ?? m['id']?.toString() ?? '';
        return {
          'id': id,
          'name': _formatModelName(id),
          'desc': m['description']?.toString() ?? '',
        };
      }).toList();
    }
    return [];
  }

  String _formatModelName(String id) {
    if (id.contains('gpt-4')) return '🤖 $id';
    if (id.contains('gpt-3.5')) return '📝 $id';
    if (id.contains('claude')) return '💎 ${id.replaceAll('-', ' ')}';
    if (id.contains('deepseek')) return '🔭 $id';
    if (id.contains('gemini')) return '✨ $id';
    if (id.contains('minimax')) return '🦈 $id';
    return '🤖 $id';
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // 暖色调背景
      appBar: AppBar(
        title: const Text('API设置'),
        backgroundColor: const Color(0xFF6B5B4F),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // API配置卡片
                _buildSectionCard(
                  title: '🔑 API 配置',
                  icon: Icons.key,
                  children: [
                    _buildTextField(
                      controller: _apiUrlController,
                      label: 'API 地址',
                      hint: 'https://api.sillytaverns.com/v1',
                      helperText: 'AI接口的base URL',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _apiKeyController,
                      label: 'API Key',
                      hint: '输入你的API Key',
                      helperText: '用于调用AI服务',
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    // 获取模型列表按钮
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoadingModels ? null : _fetchModels,
                        icon: _isLoadingModels
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.list),
                        label: Text(_isLoadingModels ? '加载中...' : '获取模型列表'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6B5B4F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // 当前选中模型显示
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedModel != null
                            ? const Color(0xFF6B5B4F).withOpacity(0.08)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedModel != null
                              ? const Color(0xFF6B5B4F).withOpacity(0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedModel != null ? Icons.auto_awesome : Icons.info_outline,
                            size: 16,
                            color: _selectedModel != null ? const Color(0xFF6B5B4F) : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedModel != null ? '当前模型：$_selectedModel' : '未选择模型',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _selectedModel != null ? const Color(0xFF6B5B4F) : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 错误信息
                    if (_modelsError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _modelsError!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],

                    // 模型选择列表
                    if (_availableModels.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        '选择模型',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      ..._availableModels.map((model) => _buildModelOption(
                        id: model['id']!,
                        name: model['name']!,
                        desc: model['desc'] ?? '',
                      )),
                    ],

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B5B4F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('保存配置'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildModelOption({required String id, required String name, required String desc}) {
    final isSelected = _selectedModel == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B5B4F).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B5B4F) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF6B5B4F) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF6B5B4F) : Colors.black87,
                    ),
                  ),
                  if (desc.isNotEmpty)
                    Text(
                      desc,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6B5B4F), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String helperText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            helperStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            filled: true,
            fillColor: const Color(0xFFF5F0E8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6B5B4F), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
