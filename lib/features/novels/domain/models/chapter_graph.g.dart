// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterGraphImpl _$$ChapterGraphImplFromJson(Map<String, dynamic> json) =>
    _$ChapterGraphImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      type: json['type'] as String? ?? 'characterRelationship',
      data: json['data'] as String? ?? '{}',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChapterGraphImplToJson(_$ChapterGraphImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'type': instance.type,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$GraphNodeImpl _$$GraphNodeImplFromJson(Map<String, dynamic> json) =>
    _$GraphNodeImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String? ?? 'node',
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GraphNodeImplToJson(_$GraphNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'properties': instance.properties,
    };

_$GraphEdgeImpl _$$GraphEdgeImplFromJson(Map<String, dynamic> json) =>
    _$GraphEdgeImpl(
      from: json['from'] as String,
      to: json['to'] as String,
      label: json['label'] as String?,
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$GraphEdgeImplToJson(_$GraphEdgeImpl instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'label': instance.label,
      'weight': instance.weight,
    };

_$GraphDataImpl _$$GraphDataImplFromJson(Map<String, dynamic> json) =>
    _$GraphDataImpl(
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => GraphNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      edges: (json['edges'] as List<dynamic>?)
              ?.map((e) => GraphEdge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GraphDataImplToJson(_$GraphDataImpl instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'edges': instance.edges,
    };
