import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/novel_provider.dart';
import '../theme/game_console_theme.dart';

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
      showPixelSnackBar(context, '⚠️ 请先获取并选择模型', isError: true);
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
    showPixelSnackBar(context, '✅ 设置已保存');
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

  static const String _browserUserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';

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
      backgroundColor: GameColors.bg,
      appBar: AppBar(
        backgroundColor: GameColors.bg2,
        elevation: 0,
        title: const Text(
          '⚙️ 设置',
          style: TextStyle(
            color: GameColors.textLight,
            fontFamily: 'monospace',
            fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: GameColors.textLight),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // API配置卡片
          _buildPixelSectionCard(
            title: '🔑 API 配置',
            children: [
              _buildPixelTextField(
                controller: _apiUrlController,
                label: 'API 地址',
                hint: 'https://api.openai.com/v1',
                helperText: 'AI 接口的 base URL',
              ),
              const SizedBox(height: 12),
              _buildPixelTextField(
                controller: _apiKeyController,
                label: 'API Key',
                hint: '输入你的 API Key',
                helperText: '用于调用 AI 续写服务',
                isPassword: true,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isLoadingModels ? null : _fetchModels,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: GameColors.buttonDecoration(
                    color: _isLoadingModels ? GameColors.bg3 : GameColors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoadingModels)
                        const SizedBox(
                          width: 14, height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GameColors.textLight,
                          ),
                        )
                      else
                        const Text('📋', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(
                        _isLoadingModels ? '加载中...' : '获取模型列表',
                        style: const TextStyle(
                          color: GameColors.textLight,
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedModel != null
                      ? GameColors.blue.withOpacity(0.15)
                      : GameColors.bg3,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _selectedModel != null
                        ? GameColors.blue
                        : GameColors.borderLight,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedModel != null ? '🤖' : 'ℹ️',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedModel != null
                            ? '当前模型：$_selectedModel'
                            : '未选择模型',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _selectedModel != null
                              ? GameColors.blueBright
                              : GameColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_modelsError != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GameColors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: GameColors.red, width: 1),
                  ),
                  child: Text(
                    _modelsError!,
                    style: const TextStyle(color: GameColors.red, fontSize: 11),
                  ),
                ),
              ],
              if (_availableModels.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  '📋 选择模型',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GameColors.textLight,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                ..._availableModels.map((model) => _buildModelOptionPixel(
                  id: model['id']!,
                  name: model['name']!,
                  desc: model['desc'] ?? '',
                )),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // 续写设置卡片
          _buildPixelSectionCard(
            title: '✏️ 续写设置',
            children: [
              _buildPixelTextField(
                controller: _wordCountController,
                label: '续写字数',
                hint: '2000',
                helperText: '每次续写的目标字数',
              ),
              const SizedBox(height: 12),
              _buildPixelSwitchTile(
                title: '质量校验',
                subtitle: '续写后进行质量评估',
                value: _enableQualityCheck,
                onChanged: (v) => setState(() => _enableQualityCheck = v),
              ),
              Container(
                height: 1,
                color: GameColors.borderDark,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              _buildPixelSwitchTile(
                title: '自动生成图谱',
                subtitle: '续写完成后自动更新知识图谱',
                value: _autoUpdateGraphAfterWrite,
                onChanged: (v) => setState(() => _autoUpdateGraphAfterWrite = v),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 保存按钮
          GestureDetector(
            onTap: _saveSettings,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: GameColors.buttonDecoration(color: GameColors.green),
              child: const Center(
                child: Text(
                  '💾 保存配置',
                  style: TextStyle(
                    color: GameColors.textLight,
                    fontFamily: 'monospace',
                    fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 关于卡片
          _buildPixelSectionCard(
            title: 'ℹ️ 关于',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Text('🐋', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Always Remember Me',
                            style: TextStyle(
                              color: GameColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                          const Text(
                            '版本 1.0.0 · 小说续写辅助工具',
                            style: TextStyle(
                              color: GameColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('›', style: TextStyle(
                      color: GameColors.textMuted,
                      fontSize: 20,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPixelSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: GameColors.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: GameColors.textLight,
              fontFamily: 'monospace',
              fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPixelTextField({
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
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: GameColors.textMuted,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: GameColors.inputDecoration(),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(
              color: GameColors.textLight,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            cursorColor: GameColors.blueBright,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: GameColors.textMuted, fontSize: 12),
              filled: true,
              fillColor: GameColors.bg3,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          helperText,
          style: const TextStyle(
            fontSize: 10,
            color: GameColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildPixelSwitchTile({
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GameColors.textLight,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: GameColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 44,
              height: 26,
              decoration: BoxDecoration(
                color: value ? GameColors.green : GameColors.bg3,
                border: Border.all(
                  color: value ? GameColors.green : GameColors.borderLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  if (value) const BoxShadow(color: GameColors.green, offset: Offset(-1, -1)),
                  const BoxShadow(color: GameColors.shadowColor, offset: Offset(1, 1)),
                ],
              ),
              child: Center(
                child: Text(
                  value ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: GameColors.textLight,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelOptionPixel({
    required String id,
    required String name,
    required String desc,
  }) {
    final isSelected = _selectedModel == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? GameColors.blue.withOpacity(0.15)
              : GameColors.bg3,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? GameColors.blueBright : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              isSelected ? '✅' : '⬜',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? GameColors.blueBright : GameColors.textLight,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (desc.isNotEmpty)
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 10,
                        color: GameColors.textMuted,
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
}
