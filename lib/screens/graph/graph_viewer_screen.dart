import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';

/// 知识图谱详情页 — 查看完整合并图谱
class GraphViewerScreen extends StatelessWidget {
  const GraphViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final graph = provider.mergedGraph;

    return Scaffold(
      appBar: AppBar(
        title: const Text('全局知识图谱'),
        backgroundColor: Colors.purple.shade50,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: '校验图谱合规性',
            onPressed: () {
              provider.validateGraphCompliance();
              _showComplianceResult(context, provider);
            },
          ),
          if (graph != null) ...[
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: '复制图谱JSON',
              onPressed: () {
                final json = const JsonEncoder.withIndent('  ').convert(graph);
                Clipboard.setData(ClipboardData(text: json));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('图谱JSON已复制到剪贴板')),
                );
              },
            ),
          ],
        ],
      ),
      body: graph == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_tree, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    '尚未生成全局图谱',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '请先在首页生成并合并图谱',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 全局基础信息
                _GraphSection(
                  title: '全局基础信息',
                  icon: Icons.info_outline,
                  color: Colors.blue,
                  data: _getField(graph, '全局基础信息'),
                ),
                const SizedBox(height: 12),

                // 人物信息库
                _GraphSection(
                  title: '人物信息库',
                  icon: Icons.people_outline,
                  color: Colors.orange,
                  data: _getField(graph, '人物信息库'),
                  isList: true,
                ),
                const SizedBox(height: 12),

                // 世界观设定库
                _GraphSection(
                  title: '世界观设定库',
                  icon: Icons.public_outlined,
                  color: Colors.green,
                  data: _getField(graph, '世界观设定库'),
                ),
                const SizedBox(height: 12),

                // 全剧情时间线
                _GraphSection(
                  title: '全剧情时间线',
                  icon: Icons.timeline_outlined,
                  color: Colors.red,
                  data: _getField(graph, '全剧情时间线'),
                ),
                const SizedBox(height: 12),

                // 全局文风标准
                _GraphSection(
                  title: '全局文风标准',
                  icon: Icons.brush_outlined,
                  color: Colors.purple,
                  data: _getField(graph, '全局文风标准'),
                ),
                const SizedBox(height: 12),

                // 全量实体关系网络
                _GraphSection(
                  title: '全量实体关系网络',
                  icon: Icons.hub_outlined,
                  color: Colors.teal,
                  data: _getField(graph, '全量实体关系网络'),
                  isList: true,
                ),
                const SizedBox(height: 12),

                // 反向依赖图谱
                _GraphSection(
                  title: '反向依赖图谱',
                  icon: Icons.account_tree_outlined,
                  color: Colors.amber.shade700,
                  data: _getField(graph, '反向依赖图谱'),
                  isList: true,
                ),
                const SizedBox(height: 12),

                // 逆向分析与质量评估
                _GraphSection(
                  title: '逆向分析与质量评估',
                  icon: Icons.assessment_outlined,
                  color: Colors.indigo,
                  data: _getField(graph, '逆向分析与质量评估'),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  dynamic _getField(Map<String, dynamic> graph, String key) {
    return graph[key];
  }

  void _showComplianceResult(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              provider.graphCompliancePass == true
                  ? Icons.check_circle
                  : Icons.warning,
              color: provider.graphCompliancePass == true
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
            const Text('图谱合规性校验'),
          ],
        ),
        content: SelectableText(
          provider.graphComplianceResult ?? '尚未校验',
          style: const TextStyle(fontSize: 14, height: 1.5),
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

/// 图谱字段展示区块
class _GraphSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final dynamic data;
  final bool isList;

  const _GraphSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.data,
    this.isList = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = _formatData(data);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 18,
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SelectableText(
              displayText.isEmpty ? '暂无' : displayText,
              style: TextStyle(
                fontSize: 13,
                color: displayText.isEmpty ? Colors.grey : Colors.grey.shade800,
                height: 1.6,
                fontFamily: displayText.length < 500 ? null : 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatData(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is List) {
      if (data.isEmpty) return '暂无';
      return data.map((e) => _formatItem(e)).join('\n\n');
    }
    if (data is Map) {
      if (data.isEmpty) return '暂无';
      return data.entries
          .where((e) => e.value != null && e.value.toString().isNotEmpty)
          .map((e) => '• ${e.key}：${_formatItem(e.value)}')
          .join('\n');
    }
    return data.toString();
  }

  String _formatItem(dynamic item) {
    if (item == null) return '';
    if (item is String) return item;
    if (item is Map) {
      return item.entries
          .where((e) => e.value != null && e.value.toString().isNotEmpty)
          .map((e) => '${e.key}: ${_formatItem(e.value)}')
          .join('；');
    }
    return item.toString();
  }
}
