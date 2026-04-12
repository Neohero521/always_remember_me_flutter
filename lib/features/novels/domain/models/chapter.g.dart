// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterImpl _$$ChapterImplFromJson(Map<String, dynamic> json) =>
    _$ChapterImpl(
      id: json['id'] as String,
      novelId: json['novelId'] as String,
      number: (json['number'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      graphId: json['graphId'] as String?,
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChapterImplToJson(_$ChapterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novelId': instance.novelId,
      'number': instance.number,
      'title': instance.title,
      'content': instance.content,
      'graphId': instance.graphId,
      'wordCount': instance.wordCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
