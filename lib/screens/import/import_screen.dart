import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/novel_provider.dart';
import '../../theme/game_console_theme.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  String? _fileContent;
  String? _fileName;
  final _titleController = TextEditingController();
  final _customRegexController = TextEditingController();
  final _wordCountController = TextEditingController(text: '3000');
  bool _isLoading = false;
  String _statusText = '';

  @override
  void dispose() {
    _customRegexController.dispose();
    _wordCountController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        setState(() {
          _fileName = result.files.single.name;
          _fileContent = content;
          _statusText = '已选择: $_fileName (${content.length} 字)';
          _titleController.text = _fileName?.replaceAll(RegExp(r'\.txt$', caseSensitive: false), '') ?? '';
        });
      }
    } catch (e) {
      setState(() => _statusText = '文件读取失败: $e');
    }
  }

  void _parseWithCustomRegex() {
    if (_fileContent == null) return;
    final provider = context.read<NovelProvider>();
    provider.parseChapters(_fileContent!, customRegex: _customRegexController.text);
    setState(() => _statusText = '已解析 ${provider.chapters.length} 个章节');
  }

  void _parseAutoRegex() {
    if (_fileContent == null) return;
    final provider = context.read<NovelProvider>();
    provider.parseChapters(_fileContent!);
    setState(() => _statusText = '已解析 ${provider.chapters.length} 个章节');
  }

  void _parseByWordCount() {
    if (_fileContent == null) return;
    final wordCount = int.tryParse(_wordCountController.text) ?? 3000;
    final provider = context.read<NovelProvider>();
    provider.parseChaptersByWordCount(_fileContent!, wordCount);
    setState(() => _statusText = '已按字数拆分为 ${provider.chapters.length} 个章节');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('小说导入'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 文件选择区
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('步骤1：选择 TXT 文件', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_open),
                    label: const Text('选择小说文件'),
                  ),
                  if (_fileName != null) ...[
                    const SizedBox(height: 8),
                    Text(_statusText, style: TextStyle(color: Colors.green.shade700)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 解析方式
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('步骤2：解析章节', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  // 自动匹配
                  ListTile(
                    leading: const Icon(Icons.auto_fix_high, color: Colors.blue),
                    title: const Text('自动匹配最优正则'),
                    subtitle: Text(provider.sortedRegexList.isEmpty
                        ? '选择文件后自动匹配'
                        : '最优：${provider.sortedRegexList.first.preset.name} (${provider.sortedRegexList.first.count}章节)'),
                    trailing: ElevatedButton(
                      onPressed: _fileContent != null ? _parseAutoRegex : null,
                      child: const Text('解析'),
                    ),
                  ),

                  const Divider(),

                  // 自定义正则
                  TextField(
                    controller: _customRegexController,
                    decoration: const InputDecoration(
                      labelText: '自定义正则（可选）',
                      hintText: r'^\s*第\s*[0-9零一二三四五六七八九十百千]+\s*章.*$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _fileContent != null ? _parseWithCustomRegex : null,
                      child: const Text('用自定义正则解析'),
                    ),
                  ),

                  const Divider(),

                  // 按字数拆分
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _wordCountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '单章字数',
                            hintText: '3000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _fileContent != null ? _parseByWordCount : null,
                        child: const Text('按字数拆分'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 解析结果预览
          if (provider.chapters.isNotEmpty) ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '已解析 ${provider.chapters.length} 个章节',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
                        ),
                        CutePixelButton(
                          label: '保存到书架',
                          emoji: '💾',
                          color: CutePixelColors.mint,
                          fontSize: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          onPressed: () async {
                            final fileName = _fileName ?? '未命名';
                            final title = _titleController.text.trim().isNotEmpty
                                ? _titleController.text.trim()
                                : null;
                            final regex = _customRegexController.text.trim();
                            final wordCount = int.tryParse(_wordCountController.text);
                            try {
                              await context.read<NovelProvider>().importBook(
                                rawFileName: fileName,
                                novelText: _fileContent!,
                                customTitle: title,
                                customRegex: regex.isNotEmpty ? regex : null,
                                wordCount: wordCount,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('保存失败: $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...provider.chapters.take(5).map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${c.title}', style: TextStyle(color: Colors.grey.shade700)),
                    )),
                    if (provider.chapters.length > 5)
                      Text('... 还有 ${provider.chapters.length - 5} 个章节', style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 正则匹配说明
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('支持的正则格式', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '标准章节（第X章）、括号序号（X）、英文Chapter、'
                    '标准话（第X话）、顿号序号（X、）、方括号序号（【X】）等',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
