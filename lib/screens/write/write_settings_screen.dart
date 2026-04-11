import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../theme/v4_colors.dart';

/// 续写参数设置页面（Drawer菜单入口）
class WriteSettingsScreen extends StatefulWidget {
  const WriteSettingsScreen({super.key});

  @override
  State<WriteSettingsScreen> createState() => _WriteSettingsScreenState();
}

class _WriteSettingsScreenState extends State<WriteSettingsScreen> {
  bool _enableRedLines = true;
  bool _enableForbiddenRules = true;
  bool _enableForeshadowCheck = true;
  int _retryCount = 1;
  double _qualityThreshold = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NovelProvider>(context, listen: false);
      setState(() {
        _enableRedLines = provider.enableQualityCheck;
        // Add other settings loading when available
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V4Colors.background,
      appBar: AppBar(
        title: const Text('⚙️ 续写参数', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 前置校验
          _SectionTitle(title: '前置校验'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('启用人设红线检查', style: TextStyle(fontSize: 15)),
                  subtitle: const Text('检查续写内容是否违反人物设定', style: TextStyle(fontSize: 12)),
                  value: _enableRedLines,
                  activeColor: V4Colors.primary,
                  onChanged: (v) => setState(() => _enableRedLines = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('启用禁区规则检查', style: TextStyle(fontSize: 15)),
                  subtitle: const Text('检查是否触碰到设定禁区', style: TextStyle(fontSize: 12)),
                  value: _enableForbiddenRules,
                  activeColor: V4Colors.primary,
                  onChanged: (v) => setState(() => _enableForbiddenRules = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('启用伏笔引用检查', style: TextStyle(fontSize: 15)),
                  subtitle: const Text('检查是否呼应之前埋下的伏笔', style: TextStyle(fontSize: 12)),
                  value: _enableForeshadowCheck,
                  activeColor: V4Colors.primary,
                  onChanged: (v) => setState(() => _enableForeshadowCheck = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 批量操作
          _SectionTitle(title: '批量操作'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('失败自动重试次数', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _RadioOption(
                        label: '关闭',
                        selected: _retryCount == 0,
                        onTap: () => setState(() => _retryCount = 0),
                      ),
                      const SizedBox(width: 16),
                      _RadioOption(
                        label: '1次',
                        selected: _retryCount == 1,
                        onTap: () => setState(() => _retryCount = 1),
                      ),
                      const SizedBox(width: 16),
                      _RadioOption(
                        label: '3次',
                        selected: _retryCount == 3,
                        onTap: () => setState(() => _retryCount = 3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 质量阈值
          _SectionTitle(title: '质量阈值'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('续写质量低于此值时标记失败', style: TextStyle(fontSize: 13, color: V4Colors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('50', style: TextStyle(fontSize: 12, color: V4Colors.textSecondary)),
                      Expanded(
                        child: Slider(
                          value: _qualityThreshold,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          activeColor: V4Colors.primary,
                          onChanged: (v) => setState(() => _qualityThreshold = v),
                        ),
                      ),
                      const Text('100', style: TextStyle(fontSize: 12, color: V4Colors.textSecondary)),
                    ],
                  ),
                  Center(
                    child: Text(
                      '当前：${_qualityThreshold.toInt()} 分',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: V4Colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 保存按钮
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: V4Colors.primary,
                foregroundColor: V4Colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('保存设置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _saveSettings() async {
    final provider = Provider.of<NovelProvider>(context, listen: false);
    await provider.updateConfig(
      enableQualityCheck: _enableRedLines,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ 设置已保存')),
      );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: V4Colors.textSecondary,
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? V4Colors.primary.withOpacity(0.1) : V4Colors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? V4Colors.primary : V4Colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? V4Colors.primary : V4Colors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
