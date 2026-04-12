// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NovelImpl _$$NovelImplFromJson(Map<String, dynamic> json) => _$NovelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String? ?? '',
      cover: json['cover'] as String?,
      introduction: json['introduction'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      wordCount: (json['wordCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NovelImplToJson(_$NovelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'cover': instance.cover,
      'introduction': instance.introduction,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'wordCount': instance.wordCount,
    };
