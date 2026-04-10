import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/novel_provider.dart';

// 打字机主题色（与妙笔一致）
class _AppColors {
  static const Color cream = Color(0xFFF5F0E8);
  static const Color paper = Color(0xFFFAF7F2);
  static const Color ink = Color(0xFF2C2416);
  static const Color faded = Color(0xFF7A6F5D);
  static const Color primary = Color(0xFF8B6914);
  static const Color gold = Color(0xFFB8860B);
  static const Color accent = Color(0xFFF5A623);
  static const Color caiyunPrimary = Color(0xFF8B6914);
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _apiUrlController = TextEditingController();
  final _wordCountController = TextEditingController();
  bool _isLoadingModels = false;
  String? _modelsError;
  List<Map<String, String>> _availableModels = [];
  String? _selectedModel;
  bool _enableQualityCheck = true;
  bool _autoUpdateGraphAfterWrite = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NovelProvider>(context, listen: false);
      _apiKeyController.text = provider.apiKey;
      _apiUrlController.text = provider.apiBaseUrl;
      _wordCountController.text = provider.writeWordCount.toString();
      setState(() {
        _selectedModel = provider.selectedModel;
        _enableQualityCheck = provider.enableQualityCheck;
        _autoUpdateGraphAfterWrite = provider.autoUpdateGraphAfterWrite;
      });
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _apiUrlController.dispose();
    _wordCountController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final modelToSave = _selectedModel?.isNotEmpty == true
        ? _selectedModel!
        : _apiUrlController.text.trim();

    if (modelToSave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ 请先获取并选择模型'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = Provider.of<NovelProvider>(context, listen: false);
    await provider.updateConfig(
      apiBaseUrl: _apiUrlController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      selectedModel: modelToSave,
      writeWordCount: int.tryParse(_wordCountController.text) ?? 2000,
      enableQualityCheck: _enableQualityCheck,
      autoUpdateGraphAfterWrite: _autoUpdateGraphAfterWrite,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 设置已保存'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _fetchModels() async {
    final apiKey = _apiKeyController.text.trim();
    final apiUrl = _apiUrlController.text.trim();

    if (apiKey.isEmpty || apiUrl.isEmpty) {
      setState(() => _modelsError = '请先填写 API 地址和 Key');
      return;
    }

    setState(() {
      _isLoadingModels = true;
      _modelsError = null;
      _availableModels = [];
    });

    try {
      final endpoints = _guessModelEndpoints(apiUrl);

      Exception? lastError;
      for (final endpoint in endpoints) {
        // Bearer token 认证
        try {
          final response = await _makeRequest(url: endpoint, apiKey: apiKey);
          if (response['error'] != null) {
            throw Exception(response['error']['message'] ?? '未知错误');
          }
          final models = response['data'] as List?;
          if (models != null && models.isNotEmpty) {
            final modelList = models.map<Map<String, String>>((m) {
              final id = m['id']?.toString() ?? '';
              final ownedBy = m['owned_by']?.toString() ?? '';
              return {
                'id': id,
                'name': _formatModelName(id),
                'desc': ownedBy.isNotEmpty ? '由 $ownedBy 提供' : id,
              };
            }).toList();
            setState(() {
              _availableModels = modelList;
              _isLoadingModels = false;
              if (_selectedModel == null && modelList.isNotEmpty) {
                _selectedModel = modelList.first['id'];
              }
            });
            return;
          }
          final modelList2 = _parseOtherFormats(response);
          if (modelList2.isNotEmpty) {
            setState(() {
              _availableModels = modelList2;
              _isLoadingModels = false;
              if (_selectedModel == null && modelList2.isNotEmpty) {
                _selectedModel = modelList2.first['id'];
              }
            });
            return;
          }
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
        }

        // X-API-Key 认证
        try {
          final response = await _makeRequestAlt(url: endpoint, apiKey: apiKey);
          if (response['error'] != null) {
            throw Exception(response['error']['message'] ?? '未知错误');
          }
          final models = response['data'] as List?;
          if (models != null && models.isNotEmpty) {
            final modelList = models.map<Map<String, String>>((m) {
              final id = m['id']?.toString() ?? '';
              final ownedBy = m['owned_by']?.toString() ?? '';
              return {
                'id': id,
                'name': _formatModelName(id),
                'desc': ownedBy.isNotEmpty ? '由 $ownedBy 提供' : id,
              };
            }).toList();
            setState(() {
              _availableModels = modelList;
              _isLoadingModels = false;
              if (_selectedModel == null && modelList.isNotEmpty) {
                _selectedModel = modelList.first['id'];
              }
            });
            return;
          }
          final modelList2 = _parseOtherFormats(response);
          if (modelList2.isNotEmpty) {
            setState(() {
              _availableModels = modelList2;
              _isLoadingModels = false;
              if (_selectedModel == null && modelList2.isNotEmpty) {
                _selectedModel = modelList2.first['id'];
              }
            });
            return;
          }
        } catch (e) {
          continue;
        }
      }

      throw lastError ?? Exception('无法获取模型列表，请检查 API 地址是否正确');
    } catch (e) {
      setState(() {
        _modelsError = '获取模型列表失败: $e';
        _isLoadingModels = false;
      });
    }
  }

  static const String _browserUserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  Future<Map<String, dynamic>> _makeRequest({
    required String url,
    required String apiKey,
    String method = 'GET',
  }) async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': _browserUserAgent,
      },
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('请求超时，请检查网络连接'),
    );

    if (response.statusCode == 401) {
      throw Exception('认证失败: API Key 无效');
    } else if (response.statusCode == 403) {
      throw Exception('访问被拒绝(403): 请检查 API Key 是否有访问权限');
    } else if (response.statusCode == 404) {
      throw Exception('接口不存在(404): API地址可能不正确');
    } else if (response.statusCode != 200) {
      throw Exception('请求失败 (${response.statusCode}): ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _makeRequestAlt({
    required String url,
    required String apiKey,
    String method = 'GET',
  }) async {
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': _browserUserAgent,
      },
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('请求超时，请检查网络连接'),
    );

    if (response.statusCode == 401) {
      throw Exception('认证失败: API Key 无效');
    } else if (response.statusCode == 403) {
      throw Exception('访问被拒绝(403): 请检查 API Key 是否有访问权限');
    } else if (response.statusCode == 404) {
      throw Exception('接口不存在(404): API地址可能不正确');
    } else if (response.statusCode != 200) {
      throw Exception('请求失败 (${response.statusCode}): ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  List<String> _guessModelEndpoints(String apiUrl) {
    var base = apiUrl.endsWith('/') ? apiUrl.substring(0, apiUrl.length - 1) : apiUrl;
    final v1Match = RegExp(r'/v\d+$').firstMatch(base);
    if (v1Match != null) {
      base = base.substring(0, v1Match.start);
    }
    return [
      '$base/v1/models',
      '$base/models',
      '$base/api/v1/models',
      '$base/v2/models',
    ];
  }

  List<Map<String, String>> _parseOtherFormats(Map<String, dynamic> response) {
    if (response.containsKey('models')) {
      final models = response['models'] as List? ?? [];
      return models.map<Map<String, String>>((m) {
        final id = m['model_id']?.toString() ?? m['id']?.toString() ?? '';
        return {
          'id': id,
          'name': _formatModelName(id),
          'desc': m['description']?.toString() ?? id,
        };
      }).toList();
    }
    if (response.containsKey('data') && response['data'] is List) {
      return (response['data'] as List).map<Map<String, String>>((m) {
        final id = m['id']?.toString() ?? m['model']?.toString() ?? '';
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
    if (id.contains('minimax')) return '🦈 $id';
    if (id.contains('deepseek')) return '🔭 $id';
    if (id.contains('gemini')) return '✨ $id';
    return '🤖 $id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.cream,
      appBar: AppBar(
        backgroundColor: _AppColors.cream,
        elevation: 0,
        title: const Text(
          '⚙️ 设置',
          style: TextStyle(color: _AppColors.ink),
        ),
        iconTheme: const IconThemeData(color: _AppColors.ink),
      ),
      body: ListView(
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
                hint: 'https://api.openai.com/v1',
                helperText: 'AI 接口的 base URL',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _apiKeyController,
                label: 'API Key',
                hint: '输入你的 API Key',
                helperText: '用于调用 AI 续写服务',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoadingModels ? null : _fetchModels,
                  icon: _isLoadingModels
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.list),
                  label: Text(_isLoadingModels ? '加载中...' : '获取模型列表'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _AppColors.caiyunPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedModel != null
                      ? _AppColors.caiyunPrimary.withOpacity(0.08)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _selectedModel != null
                        ? _AppColors.caiyunPrimary.withOpacity(0.3)
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedModel != null ? Icons.auto_awesome : Icons.info_outline,
                      size: 16,
                      color: _selectedModel != null ? _AppColors.caiyunPrimary : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedModel != null ? '当前模型：$_selectedModel' : '未选择模型',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _selectedModel != null ? _AppColors.caiyunPrimary : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (_modelsError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _modelsError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
              if (_availableModels.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  '选择模型',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                ..._availableModels.map((model) => _buildModelOption(
                  id: model['id']!,
                  name: model['name']!,
                  desc: model['desc'] ?? '',
                )),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // 续写设置卡片
          _buildSectionCard(
            title: '✏️ 续写设置',
            icon: Icons.edit,
            children: [
              _buildTextField(
                controller: _wordCountController,
                label: '续写字数',
                hint: '2000',
                helperText: '每次续写的目标字数',
                isPassword: false,
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                title: '质量校验',
                subtitle: '续写后进行质量评估',
                value: _enableQualityCheck,
                onChanged: (v) => setState(() => _enableQualityCheck = v),
              ),
              const Divider(),
              _buildSwitchTile(
                title: '自动生成图谱',
                subtitle: '续写完成后自动更新知识图谱',
                value: _autoUpdateGraphAfterWrite,
                onChanged: (v) => setState(() => _autoUpdateGraphAfterWrite = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 保存按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppColors.caiyunPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('保存配置'),
            ),
          ),

          const SizedBox(height: 16),

          // 关于卡片
          _buildSectionCard(
            title: 'ℹ️ 关于',
            icon: Icons.info_outline,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Always Remember Me'),
                subtitle: const Text('版本 1.0.0'),
                trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ),
              const Divider(),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('基于妙笔 Flutter 重构'),
                subtitle: Text('小说续写工具'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelOption({
    required String id,
    required String name,
    required String desc,
  }) {
    final isSelected = _selectedModel == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? _AppColors.caiyunPrimary.withOpacity(0.1)
              : _AppColors.cream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _AppColors.caiyunPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? _AppColors.caiyunPrimary : Colors.grey,
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
                      color: isSelected ? _AppColors.caiyunPrimary : _AppColors.ink,
                    ),
                  ),
                  if (desc.isNotEmpty)
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
              Icon(icon, color: _AppColors.caiyunPrimary, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.ink,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: _AppColors.cream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          helperText,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _AppColors.caiyunPrimary,
          ),
        ],
      ),
    );
  }
}
