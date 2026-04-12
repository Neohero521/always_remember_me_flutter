import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import '../../domain/models/chapter_graph.dart';
import '../../../../app/theme/app_theme.dart';

class GraphViewScreen extends StatefulWidget {
  final ChapterGraph graph;
  final GraphType graphType;

  const GraphViewScreen({
    super.key,
    required this.graph,
    required this.graphType,
  });

  @override
  State<GraphViewScreen> createState() => _GraphViewScreenState();
}

class _GraphViewScreenState extends State<GraphViewScreen>
    with SingleTickerProviderStateMixin {
  late Graph graph;
  late Algorithm algorithm;
  late AnimationController _nodeAnimController;
  late Animation<double> _nodeAnim;

  // 节点悬停/选中状态
  String? _selectedNodeId;

  @override
  void initState() {
    super.initState();
    _nodeAnimController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _nodeAnim = CurvedAnimation(
      parent: _nodeAnimController,
      curve: Curves.easeOutBack,
    );
    _buildGraph();
    _nodeAnimController.forward();
  }

  @override
  void dispose() {
    _nodeAnimController.dispose();
    super.dispose();
  }

  void _buildGraph() {
    final data = GraphData.fromJson(jsonDecode(widget.graph.data));
    graph = Graph();
    graph.isTree = widget.graphType == GraphType.plotTimeline;

    final nodeMap = <String, Node>{};

    for (final node in data.nodes) {
      final graphNode = Node.Id(node.id);
      nodeMap[node.id] = graphNode;
      graph.addNode(graphNode);
    }

    for (final edge in data.edges) {
      final fromNode = nodeMap[edge.from];
      final toNode = nodeMap[edge.to];
      if (fromNode != null && toNode != null) {
        graph.addEdge(fromNode, toNode, paint: _getEdgePaint(edge));
      }
    }

    switch (widget.graphType) {
      case GraphType.characterRelationship:
        algorithm = FruchtermanReingoldAlgorithm(
          FruchtermanReingoldConfiguration(iterations: 100, repulsionRate: 0.2, attractionRate: 0.15),
        );
        break;
      case GraphType.plotTimeline:
        algorithm = FruchtermanReingoldAlgorithm(
          FruchtermanReingoldConfiguration(iterations: 500, repulsionRate: 0.3, attractionRate: 0.1),
        );
        break;
      case GraphType.locationMap:
        algorithm = FruchtermanReingoldAlgorithm(
          FruchtermanReingoldConfiguration(iterations: 200, repulsionRate: 0.4, attractionRate: 0.1),
        );
        break;
      case GraphType.emotionAnalysis:
        algorithm = FruchtermanReingoldAlgorithm(
          FruchtermanReingoldConfiguration(iterations: 300, repulsionRate: 0.25, attractionRate: 0.2),
        );
        break;
    }
  }

  Paint _getEdgePaint(GraphEdge edge) {
    final weight = edge.weight;
    if (weight > 5) return Paint()..color = AppColors.error.withOpacity(0.7);
    if (weight > 2) return Paint()..color = AppColors.warning.withOpacity(0.7);
    return Paint()..color = AppColors.divider;
  }

  Color _getNodeColor(String? type) {
    switch (type) {
      case 'character': return AppColors.nodeCharacter;
      case 'location': return AppColors.nodeLocation;
      case 'event': return AppColors.nodeEvent;
      case 'emotion': return AppColors.nodeEmotion;
      default: return AppColors.primaryIndigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getGraphTitle()),
        titleTextStyle: AppTypography.titleMedium,
      ),
      body: Column(
        children: [
          _buildLegend(),
          Expanded(
            child: AnimatedBuilder(
              animation: _nodeAnim,
              builder: (context, child) {
                return InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(200),
                  minScale: 0.3,
                  maxScale: 3.0,
                  child: GraphView(
                    graph: graph,
                    algorithm: algorithm,
                    paint: Paint()
                      ..color = AppColors.divider
                      ..strokeWidth = 1.5
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final nodeId = node.key!.value as String;
                      final graphData = GraphData.fromJson(jsonDecode(widget.graph.data));
                      final graphNode = graphData.nodes.firstWhere(
                        (n) => n.id == nodeId,
                        orElse: () => GraphNode(id: nodeId, label: nodeId, type: ''),
                      );
                      return Transform.scale(
                        scale: _nodeAnim.value,
                        child: _buildNodeWidget(graphNode),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getGraphTitle() {
    switch (widget.graphType) {
      case GraphType.characterRelationship: return '人物关系图';
      case GraphType.plotTimeline: return '情节时间线';
      case GraphType.locationMap: return '地点地图';
      case GraphType.emotionAnalysis: return '情感分析图';
    }
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(AppColors.nodeCharacter, '人物'),
          const SizedBox(width: 20),
          _legendItem(AppColors.nodeLocation, '地点'),
          const SizedBox(width: 20),
          _legendItem(AppColors.nodeEvent, '事件'),
          const SizedBox(width: 20),
          _legendItem(AppColors.nodeEmotion, '情感'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14, height: 14,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTypography.labelMedium),
      ],
    );
  }

  Widget _buildNodeWidget(GraphNode node) {
    final color = _getNodeColor(node.type ?? '');
    final isSelected = _selectedNodeId == node.id;

    return GestureDetector(
      onTap: () => _showNodeDetail(node),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        transform: Matrix4.identity()..scale(isSelected ? 1.15 : 1.0),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.35)
              : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.4),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? color : Colors.black).withOpacity(isSelected ? 0.2 : 0.08),
              blurRadius: isSelected ? 12 : 6,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (node.type != null && node.type!.isNotEmpty) ...[
              Icon(
                _getNodeIcon(node.type!),
                size: 12,
                color: color,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              node.label ?? node.id,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNodeIcon(String type) {
    switch (type) {
      case 'character': return Icons.person_outline;
      case 'location': return Icons.place_outlined;
      case 'event': return Icons.flash_on_outlined;
      case 'emotion': return Icons.mood_outlined;
      default: return Icons.circle;
    }
  }

  void _showNodeDetail(GraphNode node) {
    setState(() => _selectedNodeId = node.id);
    final color = _getNodeColor(node.type ?? '');

    showDialog(
      context: context,
      builder: (ctx) => ScaleTransition(
        scale: CurvedAnimation(
          parent: _nodeAnimController,
          curve: Curves.elasticOut,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(_getNodeIcon(node.type ?? ''), color: color, size: 26),
              ),
              const SizedBox(height: 16),
              Text(
                node.label ?? node.id,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (node.type != null && node.type!.isNotEmpty) ...[
                const SizedBox(height: 8),
                MiaobiBadge(label: node.type!, color: color),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('关闭'),
            ),
          ],
        ),
      ),
    );
  }
}
