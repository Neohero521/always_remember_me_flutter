import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../theme/v4_colors.dart';

/// 图谱导入/导出页面（Drawer菜单入口）
class GraphImportExportScreen extends StatefulWidget {
  const GraphImportExportScreen({super.key});

  @override
  State<GraphImportExportScreen> createState() => _GraphImportExportScreenState();
}

class _GraphImportExportScreenState extends State<GraphImportExportScreen> {
  final _importController = TextEditingController();
  String _validationStatus = '未开始';
  bool _isValidJson = false;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V4Colors.background,
      appBar: AppBar(
        title: const Text('📤 导入/导出图谱', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 导出区域
          _SectionTitle(emoji: '📤', title: '导出'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '全局图谱 JSON',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '包含所有章节的人物、地点、事件节点',
                    style: TextStyle(fontSize: 12, color: V4Colors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyToClipboard(context),
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('📋 复制到剪贴板'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 导入区域
          _SectionTitle(emoji: '📥', title: '导入'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '粘贴图谱 JSON 数据：',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: V4Colors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: V4Colors.divider),
                    ),
                    child: TextField(
                      controller: _importController,
                      maxLines: 8,
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        hintText: '{"exportTime": "...", "chapterGraphMap": {...}}',
                        hintStyle: TextStyle(color: V4Colors.textHint, fontSize: 12),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onChanged: (_) => _validateJson(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 格式校验状态
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _validationStatus == '格式正确'
                          ? V4Colors.success.withOpacity(0.1)
                          : _validationStatus == '格式错误'
                              ? V4Colors.error.withOpacity(0.1)
                              : V4Colors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _validationStatus == '格式正确'
                              ? Icons.check_circle
                              : _validationStatus == '格式错误'
                                  ? Icons.error
                                  : Icons.info_outline,
                          size: 16,
                          color: _validationStatus == '格式正确'
                              ? V4Colors.success
                              : _validationStatus == '格式错误'
                                  ? V4Colors.error
                                  : V4Colors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '格式校验：$_validationStatus',
                          style: TextStyle(
                            fontSize: 13,
                            color: _validationStatus == '格式正确'
                                ? V4Colors.success
                                : _validationStatus == '格式错误'
                                    ? V4Colors.error
                                    : V4Colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isValidJson ? () => _importGraphs(context) : null,
                      icon: const Icon(Icons.file_upload),
                      label: const Text('📥 导入图谱'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: V4Colors.primary,
                        foregroundColor: V4Colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _validateJson() {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _validationStatus = '未开始';
        _isValidJson = false;
      });
      return;
    }
    try {
      //noinspection DartEval
      // Using simple validation - check if it starts with { or [
      if (text.startsWith('{') || text.startsWith('[')) {
        setState(() {
          _validationStatus = '格式正确';
          _isValidJson = true;
        });
      } else {
        setState(() {
          _validationStatus = '格式错误';
          _isValidJson = false;
        });
      }
    } catch (e) {
      setState(() {
        _validationStatus = '格式错误';
        _isValidJson = false;
      });
    }
  }

  void _copyToClipboard(BuildContext context) async {
    final provider = Provider.of<NovelProvider>(context, listen: false);
    final json = provider.exportChapterGraphsJson();
    
    if (json.isEmpty || json == '{}') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无图谱数据可导出')),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: json));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('图谱数据已复制到剪贴板')),
      );
    }
  }

  void _importGraphs(BuildContext context) {
    final text = _importController.text.trim();
    if (text.isEmpty) return;

    try {
      final provider = Provider.of<NovelProvider>(context, listen: false);
      provider.importChapterGraphsJson(text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ 图谱导入成功！')),
      );
      
      _importController.clear();
      setState(() {
        _validationStatus = '未开始';
        _isValidJson = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionTitle({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: V4Colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
