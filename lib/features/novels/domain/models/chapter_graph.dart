import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_graph.freezed.dart';
part 'chapter_graph.g.dart';

/// Graph types for chapter analysis
enum GraphType {
  characterRelationship,
  plotTimeline,
  locationMap,
  emotionAnalysis,
}

@freezed
class ChapterGraph with _$ChapterGraph {
  const factory ChapterGraph({
    required String id,
    required String chapterId,
    @Default('characterRelationship') String type,
    @Default('{}') String data,
    required DateTime createdAt,
  }) = _ChapterGraph;

  factory ChapterGraph.fromJson(Map<String, dynamic> json) => _$ChapterGraphFromJson(json);
}

/// Graph node structure
@freezed
class GraphNode with _$GraphNode {
  const factory GraphNode({
    required String id,
    required String label,
    @Default('node') String type,
    Map<String, dynamic>? properties,
  }) = _GraphNode;

  factory GraphNode.fromJson(Map<String, dynamic> json) => _$GraphNodeFromJson(json);
}

/// Graph edge structure
@freezed
class GraphEdge with _$GraphEdge {
  const factory GraphEdge({
    required String from,
    required String to,
    String? label,
    @Default(1.0) double weight,
  }) = _GraphEdge;

  factory GraphEdge.fromJson(Map<String, dynamic> json) => _$GraphEdgeFromJson(json);
}

/// Complete graph data structure
@freezed
class GraphData with _$GraphData {
  const factory GraphData({
    @Default([]) List<GraphNode> nodes,
    @Default([]) List<GraphEdge> edges,
  }) = _GraphData;

  factory GraphData.fromJson(Map<String, dynamic> json) => _$GraphDataFromJson(json);
}
