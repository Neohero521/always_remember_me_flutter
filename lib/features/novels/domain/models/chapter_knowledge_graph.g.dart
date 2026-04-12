// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_knowledge_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterKnowledgeGraphImpl _$$ChapterKnowledgeGraphImplFromJson(
        Map<String, dynamic> json) =>
    _$ChapterKnowledgeGraphImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      version: json['version'] as String? ?? kKnowledgeGraphVersion,
      basicInfo:
          BasicChapterInfo.fromJson(json['basicInfo'] as Map<String, dynamic>),
      characters: (json['characters'] as List<dynamic>?)
              ?.map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      worldSetting: json['worldSetting'] == null
          ? const WorldSetting()
          : WorldSetting.fromJson(json['worldSetting'] as Map<String, dynamic>),
      mainPlot: PlotLine.fromJson(json['mainPlot'] as Map<String, dynamic>),
      subplots: (json['subplots'] as List<dynamic>?)
              ?.map((e) => PlotLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      writingStyle:
          WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
      relations: (json['relations'] as List<dynamic>?)
              ?.map((e) => EntityRelation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      changeInfo:
          GraphChange.fromJson(json['changeInfo'] as Map<String, dynamic>),
      reverseAnalysis: ReverseAnalysis.fromJson(
          json['reverseAnalysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChapterKnowledgeGraphImplToJson(
        _$ChapterKnowledgeGraphImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'version': instance.version,
      'basicInfo': instance.basicInfo,
      'characters': instance.characters,
      'worldSetting': instance.worldSetting,
      'mainPlot': instance.mainPlot,
      'subplots': instance.subplots,
      'writingStyle': instance.writingStyle,
      'relations': instance.relations,
      'changeInfo': instance.changeInfo,
      'reverseAnalysis': instance.reverseAnalysis,
    };

_$BasicChapterInfoImpl _$$BasicChapterInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$BasicChapterInfoImpl(
      chapterNumber: json['chapterNumber'] as String,
      chapterVersion: json['chapterVersion'] as String,
      chapterNodeId: json['chapterNodeId'] as String,
      chapterWordCount: (json['chapterWordCount'] as num).toInt(),
      narrativeTimelineNodes: (json['narrativeTimelineNodes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      summary: json['summary'] as String?,
      keyEvents: json['keyEvents'] as String?,
    );

Map<String, dynamic> _$$BasicChapterInfoImplToJson(
        _$BasicChapterInfoImpl instance) =>
    <String, dynamic>{
      'chapterNumber': instance.chapterNumber,
      'chapterVersion': instance.chapterVersion,
      'chapterNodeId': instance.chapterNodeId,
      'chapterWordCount': instance.chapterWordCount,
      'narrativeTimelineNodes': instance.narrativeTimelineNodes,
      'summary': instance.summary,
      'keyEvents': instance.keyEvents,
    };

_$CharacterInfoImpl _$$CharacterInfoImplFromJson(Map<String, dynamic> json) =>
    _$CharacterInfoImpl(
      uniqueId: json['uniqueId'] as String,
      name: json['name'] as String,
      alias: json['alias'] as String? ?? '',
      personalityTraits: json['personalityTraits'] as String? ?? '',
      identityBackground: json['identityBackground'] as String? ?? '',
      coreBehaviorMotive: json['coreBehaviorMotive'] as String? ?? '',
      relationshipChanges: json['relationshipChanges'] as String? ?? '',
      characterArcChange: json['characterArcChange'] as String? ?? '',
      dialogueStyles: (json['dialogueStyles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      appearanceCount: (json['appearanceCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CharacterInfoImplToJson(_$CharacterInfoImpl instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'name': instance.name,
      'alias': instance.alias,
      'personalityTraits': instance.personalityTraits,
      'identityBackground': instance.identityBackground,
      'coreBehaviorMotive': instance.coreBehaviorMotive,
      'relationshipChanges': instance.relationshipChanges,
      'characterArcChange': instance.characterArcChange,
      'dialogueStyles': instance.dialogueStyles,
      'appearanceCount': instance.appearanceCount,
    };

_$WorldSettingImpl _$$WorldSettingImplFromJson(Map<String, dynamic> json) =>
    _$WorldSettingImpl(
      eraBackground: json['eraBackground'] as String? ?? '',
      geographyRegions: (json['geographyRegions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      powerSystem: json['powerSystem'] as String? ?? '',
      socialStructure: json['socialStructure'] as String? ?? '',
      itemsAndCreatures: (json['itemsAndCreatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hiddenForeshadows: (json['hiddenForeshadows'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customSettings:
          json['customSettings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WorldSettingImplToJson(_$WorldSettingImpl instance) =>
    <String, dynamic>{
      'eraBackground': instance.eraBackground,
      'geographyRegions': instance.geographyRegions,
      'powerSystem': instance.powerSystem,
      'socialStructure': instance.socialStructure,
      'itemsAndCreatures': instance.itemsAndCreatures,
      'hiddenForeshadows': instance.hiddenForeshadows,
      'customSettings': instance.customSettings,
    };

_$PlotLineImpl _$$PlotLineImplFromJson(Map<String, dynamic> json) =>
    _$PlotLineImpl(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      keyEvents: (json['keyEvents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type: json['type'] as String? ?? 'main',
      conflictProgress: json['conflictProgress'] as String? ?? '',
      unresolvedForeshadows: (json['unresolvedForeshadows'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PlotLineImplToJson(_$PlotLineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'keyEvents': instance.keyEvents,
      'type': instance.type,
      'conflictProgress': instance.conflictProgress,
      'unresolvedForeshadows': instance.unresolvedForeshadows,
    };

_$WritingStyleImpl _$$WritingStyleImplFromJson(Map<String, dynamic> json) =>
    _$WritingStyleImpl(
      narrativePerspective: json['narrativePerspective'] as String? ?? '第三人称',
      languageStyle: json['languageStyle'] as String? ?? '',
      dialogueFeatures: (json['dialogueFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rhetoricalDevices: (json['rhetoricalDevices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pacingRhythm: json['pacingRhythm'] as String? ?? '',
      emotionalTone: json['emotionalTone'] as String? ?? '',
    );

Map<String, dynamic> _$$WritingStyleImplToJson(_$WritingStyleImpl instance) =>
    <String, dynamic>{
      'narrativePerspective': instance.narrativePerspective,
      'languageStyle': instance.languageStyle,
      'dialogueFeatures': instance.dialogueFeatures,
      'rhetoricalDevices': instance.rhetoricalDevices,
      'pacingRhythm': instance.pacingRhythm,
      'emotionalTone': instance.emotionalTone,
    };

_$EntityRelationImpl _$$EntityRelationImplFromJson(Map<String, dynamic> json) =>
    _$EntityRelationImpl(
      entityA: json['entityA'] as String,
      relation: json['relation'] as String,
      entityB: json['entityB'] as String,
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$EntityRelationImplToJson(
        _$EntityRelationImpl instance) =>
    <String, dynamic>{
      'entityA': instance.entityA,
      'relation': instance.relation,
      'entityB': instance.entityB,
      'properties': instance.properties,
    };

_$GraphChangeImpl _$$GraphChangeImplFromJson(Map<String, dynamic> json) =>
    _$GraphChangeImpl(
      globalChanges: (json['globalChanges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      prerequisiteChapterDependencies:
          (json['prerequisiteChapterDependencies'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      impactOnFutureChapters: (json['impactOnFutureChapters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      conflictWarnings: (json['conflictWarnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GraphChangeImplToJson(_$GraphChangeImpl instance) =>
    <String, dynamic>{
      'globalChanges': instance.globalChanges,
      'prerequisiteChapterDependencies':
          instance.prerequisiteChapterDependencies,
      'impactOnFutureChapters': instance.impactOnFutureChapters,
      'conflictWarnings': instance.conflictWarnings,
    };

_$ReverseAnalysisImpl _$$ReverseAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$ReverseAnalysisImpl(
      aiInsights: json['aiInsights'] as String? ?? '',
      callbackForeshadows: (json['callbackForeshadows'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      qualityAssessment:
          json['qualityAssessment'] as Map<String, dynamic>? ?? const {},
      narrativeGaps: json['narrativeGaps'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ReverseAnalysisImplToJson(
        _$ReverseAnalysisImpl instance) =>
    <String, dynamic>{
      'aiInsights': instance.aiInsights,
      'callbackForeshadows': instance.callbackForeshadows,
      'qualityAssessment': instance.qualityAssessment,
      'narrativeGaps': instance.narrativeGaps,
    };

_$MergedKnowledgeGraphImpl _$$MergedKnowledgeGraphImplFromJson(
        Map<String, dynamic> json) =>
    _$MergedKnowledgeGraphImpl(
      id: json['id'] as String,
      novelId: json['novelId'] as String,
      version: json['version'] as String? ?? kKnowledgeGraphVersion,
      globalBasicInfo: GlobalBasicInfo.fromJson(
          json['globalBasicInfo'] as Map<String, dynamic>),
      characterPool: (json['characterPool'] as List<dynamic>?)
              ?.map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      worldSettingPool: json['worldSettingPool'] == null
          ? const WorldSettingPool()
          : WorldSettingPool.fromJson(
              json['worldSettingPool'] as Map<String, dynamic>),
      fullPlotTimeline: FullPlotTimeline.fromJson(
          json['fullPlotTimeline'] as Map<String, dynamic>),
      writingStyleGuide: WritingStyleGuide.fromJson(
          json['writingStyleGuide'] as Map<String, dynamic>),
      entityNetwork: (json['entityNetwork'] as List<dynamic>?)
              ?.map((e) => EntityRelation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reverseDepMap: (json['reverseDepMap'] as List<dynamic>?)
              ?.map(
                  (e) => ReverseDependency.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reverseAnalysis: ReverseAnalysis.fromJson(
          json['reverseAnalysis'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MergedKnowledgeGraphImplToJson(
        _$MergedKnowledgeGraphImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novelId': instance.novelId,
      'version': instance.version,
      'globalBasicInfo': instance.globalBasicInfo,
      'characterPool': instance.characterPool,
      'worldSettingPool': instance.worldSettingPool,
      'fullPlotTimeline': instance.fullPlotTimeline,
      'writingStyleGuide': instance.writingStyleGuide,
      'entityNetwork': instance.entityNetwork,
      'reverseDepMap': instance.reverseDepMap,
      'reverseAnalysis': instance.reverseAnalysis,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$GlobalBasicInfoImpl _$$GlobalBasicInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$GlobalBasicInfoImpl(
      novelName: json['novelName'] as String,
      totalChapterCount: (json['totalChapterCount'] as num).toInt(),
      version: json['version'] as String,
      totalWordCount: (json['totalWordCount'] as num?)?.toInt(),
      novelGenre: json['novelGenre'] as String?,
    );

Map<String, dynamic> _$$GlobalBasicInfoImplToJson(
        _$GlobalBasicInfoImpl instance) =>
    <String, dynamic>{
      'novelName': instance.novelName,
      'totalChapterCount': instance.totalChapterCount,
      'version': instance.version,
      'totalWordCount': instance.totalWordCount,
      'novelGenre': instance.novelGenre,
    };

_$WorldSettingPoolImpl _$$WorldSettingPoolImplFromJson(
        Map<String, dynamic> json) =>
    _$WorldSettingPoolImpl(
      allEras: (json['allEras'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allGeography: (json['allGeography'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allPowerSystems: (json['allPowerSystems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allSocialStructures: (json['allSocialStructures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allItemsAndCreatures: (json['allItemsAndCreatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allForeshadows: (json['allForeshadows'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorldSettingPoolImplToJson(
        _$WorldSettingPoolImpl instance) =>
    <String, dynamic>{
      'allEras': instance.allEras,
      'allGeography': instance.allGeography,
      'allPowerSystems': instance.allPowerSystems,
      'allSocialStructures': instance.allSocialStructures,
      'allItemsAndCreatures': instance.allItemsAndCreatures,
      'allForeshadows': instance.allForeshadows,
    };

_$FullPlotTimelineImpl _$$FullPlotTimelineImplFromJson(
        Map<String, dynamic> json) =>
    _$FullPlotTimelineImpl(
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => TimelineNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      edges: (json['edges'] as List<dynamic>?)
              ?.map((e) => TimelineEdge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FullPlotTimelineImplToJson(
        _$FullPlotTimelineImpl instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'edges': instance.edges,
    };

_$TimelineNodeImpl _$$TimelineNodeImplFromJson(Map<String, dynamic> json) =>
    _$TimelineNodeImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      event: json['event'] as String,
      timeline: json['timeline'] as String? ?? '',
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TimelineNodeImplToJson(_$TimelineNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'event': instance.event,
      'timeline': instance.timeline,
      'properties': instance.properties,
    };

_$TimelineEdgeImpl _$$TimelineEdgeImplFromJson(Map<String, dynamic> json) =>
    _$TimelineEdgeImpl(
      from: json['from'] as String,
      to: json['to'] as String,
      label: json['label'] as String? ?? '',
    );

Map<String, dynamic> _$$TimelineEdgeImplToJson(_$TimelineEdgeImpl instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'label': instance.label,
    };

_$WritingStyleGuideImpl _$$WritingStyleGuideImplFromJson(
        Map<String, dynamic> json) =>
    _$WritingStyleGuideImpl(
      dominantStyle:
          WritingStyle.fromJson(json['dominantStyle'] as Map<String, dynamic>),
      chapterStyles: (json['chapterStyles'] as List<dynamic>?)
              ?.map((e) => WritingStyle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      styleEvolution:
          json['styleEvolution'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WritingStyleGuideImplToJson(
        _$WritingStyleGuideImpl instance) =>
    <String, dynamic>{
      'dominantStyle': instance.dominantStyle,
      'chapterStyles': instance.chapterStyles,
      'styleEvolution': instance.styleEvolution,
    };

_$ReverseDependencyImpl _$$ReverseDependencyImplFromJson(
        Map<String, dynamic> json) =>
    _$ReverseDependencyImpl(
      chapterId: json['chapterId'] as String,
      dependsOn: (json['dependsOn'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      affectsChapters: (json['affectsChapters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReverseDependencyImplToJson(
        _$ReverseDependencyImpl instance) =>
    <String, dynamic>{
      'chapterId': instance.chapterId,
      'dependsOn': instance.dependsOn,
      'affectsChapters': instance.affectsChapters,
    };
