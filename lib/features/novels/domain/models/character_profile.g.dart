// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterProfileImpl _$$CharacterProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$CharacterProfileImpl(
      id: json['id'] as String,
      novelId: json['novelId'] as String,
      name: json['name'] as String,
      alias: json['alias'] as String? ?? '',
      personality: json['personality'] as String? ?? '',
      redLines: (json['redLines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      backstories: (json['backstories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CharacterProfileImplToJson(
        _$CharacterProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novelId': instance.novelId,
      'name': instance.name,
      'alias': instance.alias,
      'personality': instance.personality,
      'redLines': instance.redLines,
      'backstories': instance.backstories,
    };

_$NovelWorldSettingImpl _$$NovelWorldSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$NovelWorldSettingImpl(
      id: json['id'] as String,
      novelId: json['novelId'] as String,
      era: json['era'] as String? ?? '',
      geography: json['geography'] as String? ?? '',
      powerSystem: json['powerSystem'] as String? ?? '',
      society: json['society'] as String? ?? '',
      forbiddenRules: (json['forbiddenRules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      foreshadows: (json['foreshadows'] as List<dynamic>?)
              ?.map((e) => Foreshadow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NovelWorldSettingImplToJson(
        _$NovelWorldSettingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novelId': instance.novelId,
      'era': instance.era,
      'geography': instance.geography,
      'powerSystem': instance.powerSystem,
      'society': instance.society,
      'forbiddenRules': instance.forbiddenRules,
      'foreshadows': instance.foreshadows,
    };

_$ForeshadowImpl _$$ForeshadowImplFromJson(Map<String, dynamic> json) =>
    _$ForeshadowImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      setupChapterId: json['setupChapterId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isResolved: json['isResolved'] as bool? ?? false,
      payoffChapterId: json['payoffChapterId'] as String? ?? '',
    );

Map<String, dynamic> _$$ForeshadowImplToJson(_$ForeshadowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'setupChapterId': instance.setupChapterId,
      'description': instance.description,
      'isResolved': instance.isResolved,
      'payoffChapterId': instance.payoffChapterId,
    };
