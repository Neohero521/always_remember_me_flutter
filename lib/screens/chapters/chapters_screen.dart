import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../reader/reader_screen.dart';

class ChaptersScreen extends StatefulWidget {
  const ChaptersScreen({super.key});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final Set<int> _selectedIds = {};
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectionMode
            ? '已选择 ${_selectedIds.length} 个章节'
            : '章节管理 (${provider.chapters.length})'),
        backgroundColor: Colors.green.shade50,
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectionMode = false;
                  _selectedIds.clear();
                }),
              )
            : null,
        actions: [
          if (_selectionMode) ...[
            TextButton.icon(
              icon: const Icon(Icons.select_all),
              label: const Text('全选'),
              onPressed: () => setState(() {
                _selectedIds.addAll(provider.chapters.map((c) => c.id));
              }),
            ),
            IconButton(
              icon: const Icon(Icons.account_tree),
              tooltip: '为所选章节生成图谱',
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () => _batchGenerateForSelected(provider),
            ),
          ] else ...[
            if (provider.isGeneratingGraph)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Center(child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
              )
            else
              IconButton(
                icon: const Icon(Icons.checklist),
                tooltip: '选择章节',
                onPressed: () => setState(() => _selectionMode = true),
              ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'generate_all') {
                  _confirmGenerateAll(context, provider);
                } else if (v == 'check_graph_status') {
                  _checkGraphStatus(provider);
                } else if (v == 'read') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReaderScreen()),
                  );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'read', child: Text('阅读小说')),
                const PopupMenuItem(value: 'generate_all', child: Text('批量生成全部图谱')),
                const PopupMenuItem(value: 'check_graph_status', child: Text('图谱状态检验')),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // 图谱进度条
          if (provider.isGeneratingGraph)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.green.shade50,
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    provider.graphProgressText,
                    style: const TextStyle(fontSize: 13, color: Colors.green),
                  )),
                  TextButton(
                    onPressed: provider.stopGraphGeneration,
                    child: const Text('停止', style: TextStyle(color: Colors.red, fontSize: 13)),
                  ),
                ],
              ),
            ),

          // 章节列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.chapters.length,
              itemBuilder: (context, index) {
                final chapter = provider.chapters[index];
                final hasGraph = provider.chapterGraphMap.containsKey(chapter.id);
                final isSelected = _selectedIds.contains(chapter.id);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                  color: isSelected ? Colors.green.shade50 : null,
                  child: ListTile(
                    leading: _selectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (v) {
                              setState(() {
                                if (v == true) {
                                  _selectedIds.add(chapter.id);
                                } else {
                                  _selectedIds.remove(chapter.id);
                                }
                              });
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReaderScreen(initialChapterId: chapter.id),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: hasGraph ? Colors.green.shade100 : Colors.grey.shade200,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: hasGraph ? Colors.green.shade700 : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    title: Text(
                      chapter.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${chapter.content.length} 字${hasGraph ? " · ✅ 图谱" : ""}',
                      style: TextStyle(fontSize: 12, color: hasGraph ? Colors.green.shade600 : Colors.grey),
                    ),
                    trailing: _selectionMode
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.menu_book, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(initialChapterId: chapter.id),
                                    ),
                                  );
                                },
                              ),
                              if (hasGraph)
                                const Icon(Icons.check_circle, color: Colors.green, size: 20)
                              else
                                IconButton(
                                  icon: const Icon(Icons.add_chart),
                                  onPressed: provider.isGeneratingGraph
                                      ? null
                                      : () => provider.generateGraphForChapter(chapter.id),
                                ),
                            ],
                          ),
                    onTap: _selectionMode
                        ? () {
                            setState(() {
                              if (_selectedIds.contains(chapter.id)) {
                                _selectedIds.remove(chapter.id);
                              } else {
                                _selectedIds.add(chapter.id);
                              }
                            });
                          }
                        : () => _showChapterDetail(context, provider, chapter.id),
                  ),
                );
              },
            ),
          ),

          // 底部状态栏
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '已生成 ${provider.chapterGraphMap.length}/${provider.chapters.length} 个图谱',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ),
                if (_selectionMode && _selectedIds.isNotEmpty)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.account_tree, size: 18),
                    label: Text('生成图谱 (${_selectedIds.length})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _batchGenerateForSelected(provider),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _batchGenerateForSelected(NovelProvider provider) async {
    if (_selectedIds.isEmpty) return;
    setState(() => _selectionMode = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始为 ${_selectedIds.length} 个章节生成图谱...')),
    );

    for (final id in _selectedIds.toList()) {
      if (!provider.chapterGraphMap.containsKey(id)) {
        await provider.generateGraphForChapter(id);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    _selectedIds.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('批量图谱生成完成！')),
      );
    }
  }

  void _checkGraphStatus(NovelProvider provider) {
    final result = provider.validateChapterGraphStatus();
    if (result['total'] == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先导入小说文件并解析章节')),
      );
      return;
    }

    final total = result['total'] as int;
    final hasGraph = result['hasGraph'] as int;
    final noGraph = result['noGraph'] as int;
    final noGraphTitles = result['noGraphTitles'] as List<String>;

    String message;
    if (noGraph == 0) {
      message = '图谱状态检验完成\n总章节数：$total\n已生成图谱：$hasGraph个\n未生成图谱：0个';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      message = '图谱状态检验完成\n总章节数：$total\n已生成图谱：$hasGraph个\n未生成图谱：$noGraph个\n\n未生成图谱的章节：\n${noGraphTitles.join('\n')}';
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('图谱状态检验'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    }
  }

  void _confirmGenerateAll(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('批量生成图谱'),
        content: Text('将为全部 ${provider.chapters.length} 个章节生成知识图谱？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.generateGraphsForAllChapters();
            },
            child: const Text('开始'),
          ),
        ],
      ),
    );
  }

  void _showChapterDetail(BuildContext context, NovelProvider provider, int chapterId) {
    final chapter = provider.getChapterById(chapterId);
    if (chapter == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final graph = provider.chapterGraphMap[chapterId];
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(chapter.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Text('${chapter.content.length} 字', style: TextStyle(color: Colors.grey.shade600)),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // 操作按钮
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.menu_book),
                                label: const Text('阅读'),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(initialChapterId: chapterId),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(graph != null ? Icons.refresh : Icons.add_chart),
                                label: Text(graph != null ? '重新生成' : '生成图谱'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () {
                                  provider.generateGraphForChapter(chapterId);
                                  Navigator.pop(ctx);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 章节内容
                        const Text('章节内容', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            chapter.content,
                            style: const TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 知识图谱
                        if (graph != null) ...[
                          const Text('知识图谱', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _GraphViewer(graph: graph),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// 图谱内容查看器（简洁折叠面板）
class _GraphViewer extends StatelessWidget {
  final Map<String, dynamic> graph;

  const _GraphViewer({required this.graph});

  @override
  Widget build(BuildContext context) {
    final entries = [
      if (graph['人物信息'] != null)
        _GraphEntry('人物信息', _summarizeList(graph['人物信息'])),
      if (graph['世界观设定'] != null)
        _GraphEntry('世界观设定', _summarizeMap(graph['世界观设定'])),
      if (graph['核心剧情线'] != null)
        _GraphEntry('核心剧情线', _summarizeMap(graph['核心剧情线'])),
      if (graph['文风特点'] != null)
        _GraphEntry('文风特点', _summarizeMap(graph['文风特点'])),
      if (graph['实体关系网络'] != null)
        _GraphEntry('实体关系', _summarizeList(graph['实体关系网络'])),
      if (graph['变更与依赖信息'] != null)
        _GraphEntry('变更与依赖', _summarizeMap(graph['变更与依赖信息'])),
      if (graph['逆向分析洞察'] != null)
        _GraphEntry('逆向洞察', graph['逆向分析洞察'].toString()),
    ];

    return Column(
      children: entries.map((e) => _GraphTile(entry: e)).toList(),
    );
  }

  String _summarizeList(dynamic list) {
    if (list is! List || list.isEmpty) return '暂无';
    return list.take(3).map((e) => e.toString().take(50)).join('\n');
  }

  String _summarizeMap(dynamic map) {
    if (map is! Map || map.isEmpty) return '暂无';
    return map.entries.take(3).map((e) => '${e.key}: ${e.value}'.take(50)).join('\n');
  }
}

class _GraphEntry {
  final String title;
  final String content;

  _GraphEntry(this.title, this.content);
}

class _GraphTile extends StatelessWidget {
  final _GraphEntry entry;

  const _GraphTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              entry.content.isEmpty ? '暂无' : entry.content,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringTake on String {
  String take(int n) => length > n ? '${substring(0, n)}...' : this;
}
