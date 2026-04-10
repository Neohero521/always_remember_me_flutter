/// 单章节知识图谱（对应 graphJsonSchema，8个必填字段）
class NovelKnowledgeGraph {
  final BaseChapterInfo baseChapterInfo;
  final List<CharacterInfo> characters;
  final WorldSetting worldSetting;
  final PlotLine corePlotLine;
  final WritingStyle writingStyle;
  final List<RelationshipEdge> entityRelationships;
  final ChangeAndDependInfo changeAndDepend;
  final String reverseAnalysisInsights;

  NovelKnowledgeGraph({
    required this.baseChapterInfo,
    required this.characters,
    required this.worldSetting,
    required this.corePlotLine,
    required this.writingStyle,
    required this.entityRelationships,
    required this.changeAndDepend,
    required this.reverseAnalysisInsights,
  });

  factory NovelKnowledgeGraph.fromJson(Map<String, dynamic> json) {
    return NovelKnowledgeGraph(
      baseChapterInfo: BaseChapterInfo.fromJson(json['基础章节信息'] ?? {}),
      characters: (json['人物信息'] as List<dynamic>?)
          ?.map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      worldSetting: WorldSetting.fromJson(json['世界观设定'] ?? {}),
      corePlotLine: PlotLine.fromJson(json['核心剧情线'] ?? {}),
      writingStyle: WritingStyle.fromJson(json['文风特点'] ?? {}),
      entityRelationships: (json['实体关系网络'] as List<dynamic>?)
          ?.map((e) => RelationshipEdge.fromJson(e as List<dynamic>))
          .toList() ?? [],
      changeAndDepend: ChangeAndDependInfo.fromJson(json['变更与依赖信息'] ?? {}),
      reverseAnalysisInsights: json['逆向分析洞察'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '基础章节信息': baseChapterInfo.toJson(),
        '人物信息': characters.map((e) => e.toJson()).toList(),
        '世界观设定': worldSetting.toJson(),
        '核心剧情线': corePlotLine.toJson(),
        '文风特点': writingStyle.toJson(),
        '实体关系网络': entityRelationships.map((e) => e.toJson()).toList(),
        '变更与依赖信息': changeAndDepend.toJson(),
        '逆向分析洞察': reverseAnalysisInsights,
      };
}

class BaseChapterInfo {
  final String chapterNumber;
  final String chapterVersion;
  final String uniqueChapterId;
  final int wordCount;
  final String narrativeTimelineNode;

  BaseChapterInfo({
    required this.chapterNumber,
    this.chapterVersion = '1.0',
    required this.uniqueChapterId,
    required this.wordCount,
    required this.narrativeTimelineNode,
  });

  factory BaseChapterInfo.fromJson(Map<String, dynamic> json) => BaseChapterInfo(
        chapterNumber: json['章节号'] ?? '',
        chapterVersion: json['章节版本号'] ?? '1.0',
        uniqueChapterId: json['章节节点唯一标识'] ?? '',
        wordCount: json['本章字数'] ?? 0,
        narrativeTimelineNode: json['叙事时间线节点'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '章节号': chapterNumber,
        '章节版本号': chapterVersion,
        '章节节点唯一标识': uniqueChapterId,
        '本章字数': wordCount,
        '叙事时间线节点': narrativeTimelineNode,
      };
}

class CharacterInfo {
  final String uniqueId;
  final String name;
  final String alias;
  final String personalityUpdate;
  final String identityBackground;
  final String coreBehavior;
  final List<RelationshipChange> relationshipChanges;
  final String characterArcChange;

  CharacterInfo({
    required this.uniqueId,
    required this.name,
    required this.alias,
    required this.personalityUpdate,
    required this.identityBackground,
    required this.coreBehavior,
    required this.relationshipChanges,
    required this.characterArcChange,
  });

  factory CharacterInfo.fromJson(Map<String, dynamic> json) => CharacterInfo(
        uniqueId: json['唯一人物ID'] ?? '',
        name: json['姓名'] ?? '',
        alias: json['别名/称号'] ?? '',
        personalityUpdate: json['本章更新的性格特征'] ?? '',
        identityBackground: json['本章更新的身份/背景'] ?? '',
        coreBehavior: json['本章核心行为与动机'] ?? '',
        relationshipChanges: (json['本章人物关系变更'] as List<dynamic>?)
            ?.map((e) => RelationshipChange.fromJson(e as Map<String, dynamic>))
            .toList() ?? [],
        characterArcChange: json['本章人物弧光变化'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '唯一人物ID': uniqueId,
        '姓名': name,
        '别名/称号': alias,
        '本章更新的性格特征': personalityUpdate,
        '本章更新的身份/背景': identityBackground,
        '本章核心行为与动机': coreBehavior,
        '本章人物关系变更':
            relationshipChanges.map((e) => e.toJson()).toList(),
        '本章人物弧光变化': characterArcChange,
      };
}

class RelationshipChange {
  final String target;
  final String relationType;
  final double intensity;
  final String description;
  final String sourceTextLocation;

  RelationshipChange({
    required this.target,
    required this.relationType,
    required this.intensity,
    required this.description,
    required this.sourceTextLocation,
  });

  factory RelationshipChange.fromJson(Map<String, dynamic> json) =>
      RelationshipChange(
        target: json['关系对象'] ?? '',
        relationType: json['关系类型'] ?? '',
        intensity: (json['关系强度0-1'] ?? 0).toDouble(),
        description: json['关系描述'] ?? '',
        sourceTextLocation: json['对应原文位置'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '关系对象': target,
        '关系类型': relationType,
        '关系强度0-1': intensity,
        '关系描述': description,
        '对应原文位置': sourceTextLocation,
      };
}

class WorldSetting {
  final String eraBackground;
  final String geography;
  final String powerSystem;
  final String socialStructure;
  final String uniqueItems;
  final String hiddenSettings;
  final String sourceTextLocation;

  WorldSetting({
    required this.eraBackground,
    required this.geography,
    required this.powerSystem,
    required this.socialStructure,
    required this.uniqueItems,
    required this.hiddenSettings,
    required this.sourceTextLocation,
  });

  factory WorldSetting.fromJson(Map<String, dynamic> json) => WorldSetting(
        eraBackground: json['本章新增/变更的时代背景'] ?? '',
        geography: json['本章新增/变更的地理区域'] ?? '',
        powerSystem: json['本章新增/变更的力量体系/规则'] ?? '',
        socialStructure: json['本章新增/变更的社会结构'] ?? '',
        uniqueItems: json['本章新增/变更的独特物品/生物'] ?? '',
        hiddenSettings: json['本章新增的隐藏设定/伏笔'] ?? '',
        sourceTextLocation: json['对应原文位置'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '本章新增/变更的时代背景': eraBackground,
        '本章新增/变更的地理区域': geography,
        '本章新增/变更的力量体系/规则': powerSystem,
        '本章新增/变更的社会结构': socialStructure,
        '本章新增/变更的独特物品/生物': uniqueItems,
        '本章新增的隐藏设定/伏笔': hiddenSettings,
        '对应原文位置': sourceTextLocation,
      };
}

class PlotLine {
  final String mainPlotDescription;
  final List<PlotEvent> keyEvents;
  final String subPlot;
  final String coreConflictProgress;
  final String unrecycledForeshadow;

  PlotLine({
    required this.mainPlotDescription,
    required this.keyEvents,
    required this.subPlot,
    required this.coreConflictProgress,
    required this.unrecycledForeshadow,
  });

  factory PlotLine.fromJson(Map<String, dynamic> json) => PlotLine(
        mainPlotDescription: json['本章主线剧情描述'] ?? '',
        keyEvents: (json['本章关键事件列表'] as List<dynamic>?)
            ?.map((e) => PlotEvent.fromJson(e as Map<String, dynamic>))
            .toList() ?? [],
        subPlot: json['本章支线剧情'] ?? '',
        coreConflictProgress: json['本章核心冲突进展'] ?? '',
        unrecycledForeshadow: json['本章未回收伏笔'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '本章主线剧情描述': mainPlotDescription,
        '本章关键事件列表': keyEvents.map((e) => e.toJson()).toList(),
        '本章支线剧情': subPlot,
        '本章核心冲突进展': coreConflictProgress,
        '本章未回收伏笔': unrecycledForeshadow,
      };
}

class PlotEvent {
  final String eventId;
  final String eventName;
  final String participants;
  final String cause;
  final String consequence;
  final String mainPlotImpact;
  final String sourceTextLocation;

  PlotEvent({
    required this.eventId,
    required this.eventName,
    required this.participants,
    required this.cause,
    required this.consequence,
    required this.mainPlotImpact,
    required this.sourceTextLocation,
  });

  factory PlotEvent.fromJson(Map<String, dynamic> json) => PlotEvent(
        eventId: json['事件ID'] ?? '',
        eventName: json['事件名'] ?? '',
        participants: json['参与人物'] ?? '',
        cause: json['前因'] ?? '',
        consequence: json['后果'] ?? '',
        mainPlotImpact: json['对主线的影响'] ?? '',
        sourceTextLocation: json['对应原文位置'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '事件ID': eventId,
        '事件名': eventName,
        '参与人物': participants,
        '前因': cause,
        '后果': consequence,
        '对主线的影响': mainPlotImpact,
        '对应原文位置': sourceTextLocation,
      };
}

class WritingStyle {
  final String narrativePerspective;
  final String languageStyle;
  final String dialogueFeature;
  final String commonRhetoric;
  final String rhythmFeature;
  final String overallMatchDescription;

  WritingStyle({
    required this.narrativePerspective,
    required this.languageStyle,
    required this.dialogueFeature,
    required this.commonRhetoric,
    required this.rhythmFeature,
    required this.overallMatchDescription,
  });

  factory WritingStyle.fromJson(Map<String, dynamic> json) => WritingStyle(
        narrativePerspective: json['本章叙事视角'] ?? '',
        languageStyle: json['语言风格'] ?? '',
        dialogueFeature: json['对话特点'] ?? '',
        commonRhetoric: json['常用修辞'] ?? '',
        rhythmFeature: json['节奏特点'] ?? '',
        overallMatchDescription: json['与全文文风的匹配度说明'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '本章叙事视角': narrativePerspective,
        '语言风格': languageStyle,
        '对话特点': dialogueFeature,
        '常用修辞': commonRhetoric,
        '节奏特点': rhythmFeature,
        '与全文文风的匹配度说明': overallMatchDescription,
      };
}

class RelationshipEdge {
  final String entity1;
  final String relation;
  final String entity2;

  RelationshipEdge(
      {required this.entity1, required this.relation, required this.entity2});

  factory RelationshipEdge.fromJson(List<dynamic> json) => RelationshipEdge(
        entity1: json.isNotEmpty ? json[0].toString() : '',
        relation: json.length > 1 ? json[1].toString() : '',
        entity2: json.length > 2 ? json[2].toString() : '',
      );

  List<String> toJson() => [entity1, relation, entity2];
}

class ChangeAndDependInfo {
  final String globalChanges;
  final String preChapterDepend;
  final String futureImpactPrediction;
  final String potentialConflictWarning;

  ChangeAndDependInfo({
    required this.globalChanges,
    required this.preChapterDepend,
    required this.futureImpactPrediction,
    required this.potentialConflictWarning,
  });

  factory ChangeAndDependInfo.fromJson(Map<String, dynamic> json) =>
      ChangeAndDependInfo(
        globalChanges: json['本章对全局图谱的变更项'] ?? '',
        preChapterDepend: json['本章剧情依赖的前置章节'] ?? '',
        futureImpactPrediction:
            json['本章内容对后续剧情的影响预判'] ?? '',
        potentialConflictWarning:
            json['本章内容与前文的潜在冲突预警'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '本章对全局图谱的变更项': globalChanges,
        '本章剧情依赖的前置章节': preChapterDepend,
        '本章内容对后续剧情的影响预判': futureImpactPrediction,
        '本章内容与前文的潜在冲突预警': potentialConflictWarning,
      };
}

/// 全量合并图谱（对应 mergeGraphJsonSchema，8个必填字段）
class MergedKnowledgeGraph {
  final GlobalBaseInfo globalBaseInfo;
  final List<MergedCharacterInfo> characterDatabase;
  final MergedWorldSetting worldSettingDatabase;
  final FullPlotTimeline plotTimeline;
  final GlobalWritingStyle globalWritingStyle;
  final List<RelationshipEdge> fullEntityRelationships;
  final List<ReverseDependencyNode> reverseDependencyGraph;
  final ReverseAnalysisAssessment reverseAssessment;

  MergedKnowledgeGraph({
    required this.globalBaseInfo,
    required this.characterDatabase,
    required this.worldSettingDatabase,
    required this.plotTimeline,
    required this.globalWritingStyle,
    required this.fullEntityRelationships,
    required this.reverseDependencyGraph,
    required this.reverseAssessment,
  });

  factory MergedKnowledgeGraph.fromJson(Map<String, dynamic> json) {
    return MergedKnowledgeGraph(
      globalBaseInfo:
          GlobalBaseInfo.fromJson(json['全局基础信息'] ?? {}),
      characterDatabase: (json['人物信息库'] as List<dynamic>?)
              ?.map(
                  (e) => MergedCharacterInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      worldSettingDatabase:
          MergedWorldSetting.fromJson(json['世界观设定库'] ?? {}),
      plotTimeline: FullPlotTimeline.fromJson(json['全剧情时间线'] ?? {}),
      globalWritingStyle:
          GlobalWritingStyle.fromJson(json['全局文风标准'] ?? {}),
      fullEntityRelationships: (json['全量实体关系网络'] as List<dynamic>?)
              ?.map((e) => RelationshipEdge.fromJson(e as List<dynamic>))
              .toList() ??
          [],
      reverseDependencyGraph:
          (json['反向依赖图谱'] as List<dynamic>?)
              ?.map((e) =>
                  ReverseDependencyNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reverseAssessment:
          ReverseAnalysisAssessment.fromJson(json['逆向分析与质量评估'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        '全局基础信息': globalBaseInfo.toJson(),
        '人物信息库': characterDatabase.map((e) => e.toJson()).toList(),
        '世界观设定库': worldSettingDatabase.toJson(),
        '全剧情时间线': plotTimeline.toJson(),
        '全局文风标准': globalWritingStyle.toJson(),
        '全量实体关系网络':
            fullEntityRelationships.map((e) => e.toJson()).toList(),
        '反向依赖图谱': reverseDependencyGraph.map((e) => e.toJson()).toList(),
        '逆向分析与质量评估': reverseAssessment.toJson(),
      };
}

class GlobalBaseInfo {
  final String novelName;
  final int totalChapterCount;
  final String parsedTextRange;
  final String graphVersion;
  final String lastUpdateTime;

  GlobalBaseInfo({
    required this.novelName,
    required this.totalChapterCount,
    required this.parsedTextRange,
    required this.graphVersion,
    required this.lastUpdateTime,
  });

  factory GlobalBaseInfo.fromJson(Map<String, dynamic> json) =>
      GlobalBaseInfo(
        novelName: json['小说名称'] ?? '',
        totalChapterCount: json['总章节数'] ?? 0,
        parsedTextRange: json['已解析文本范围'] ?? '',
        graphVersion: json['全局图谱版本号'] ?? '',
        lastUpdateTime: json['最新更新时间'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '小说名称': novelName,
        '总章节数': totalChapterCount,
        '已解析文本范围': parsedTextRange,
        '全局图谱版本号': graphVersion,
        '最新更新时间': lastUpdateTime,
      };
}

class MergedCharacterInfo {
  final String uniqueId;
  final String name;
  final String allAlias;
  final String fullPersonality;
  final String fullIdentity;
  final String coreMotivation;
  final List<TimelineRelationship> timelineRelationships;
  final String fullCharacterArc;
  final String keyEventTimeline;

  MergedCharacterInfo({
    required this.uniqueId,
    required this.name,
    required this.allAlias,
    required this.fullPersonality,
    required this.fullIdentity,
    required this.coreMotivation,
    required this.timelineRelationships,
    required this.fullCharacterArc,
    required this.keyEventTimeline,
  });

  factory MergedCharacterInfo.fromJson(Map<String, dynamic> json) =>
      MergedCharacterInfo(
        uniqueId: json['唯一人物ID'] ?? '',
        name: json['姓名'] ?? '',
        allAlias: json['所有别名/称号'] ?? '',
        fullPersonality: json['全本最终性格特征'] ?? '',
        fullIdentity: json['完整身份/背景'] ?? '',
        coreMotivation: json['全本核心动机'] ?? '',
        timelineRelationships: (json['全时间线人物关系网'] as List<dynamic>?)
                ?.map((e) =>
                    TimelineRelationship.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        fullCharacterArc: json['完整人物弧光'] ?? '',
        keyEventTimeline: json['人物关键事件时间线'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '唯一人物ID': uniqueId,
        '姓名': name,
        '所有别名/称号': allAlias,
        '全本最终性格特征': fullPersonality,
        '完整身份/背景': fullIdentity,
        '全本核心动机': coreMotivation,
        '全时间线人物关系网':
            timelineRelationships.map((e) => e.toJson()).toList(),
        '完整人物弧光': fullCharacterArc,
        '人物关键事件时间线': keyEventTimeline,
      };
}

class TimelineRelationship {
  final String target;
  final String relationType;
  final double intensity;
  final String evolution;
  final String chapters;

  TimelineRelationship({
    required this.target,
    required this.relationType,
    required this.intensity,
    required this.evolution,
    required this.chapters,
  });

  factory TimelineRelationship.fromJson(Map<String, dynamic> json) =>
      TimelineRelationship(
        target: json['关系对象'] ?? '',
        relationType: json['关系类型'] ?? '',
        intensity: (json['关系强度'] ?? 0).toDouble(),
        evolution: json['关系演变过程'] ?? '',
        chapters: json['对应章节'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '关系对象': target,
        '关系类型': relationType,
        '关系强度': intensity,
        '关系演变过程': evolution,
        '对应章节': chapters,
      };
}

class MergedWorldSetting {
  final String eraBackground;
  final String geographyMap;
  final String powerSystem;
  final String socialStructure;
  final String coreItems;
  final List<ForeshadowRecord> allForeshadows;
  final List<SettingChangeRecord> changeHistory;

  MergedWorldSetting({
    required this.eraBackground,
    required this.geographyMap,
    required this.powerSystem,
    required this.socialStructure,
    required this.coreItems,
    required this.allForeshadows,
    required this.changeHistory,
  });

  factory MergedWorldSetting.fromJson(Map<String, dynamic> json) =>
      MergedWorldSetting(
        eraBackground: json['时代背景'] ?? '',
        geographyMap: json['核心地理区域与地图'] ?? '',
        powerSystem: json['完整力量体系/规则'] ?? '',
        socialStructure: json['社会结构'] ?? '',
        coreItems: json['核心独特物品/生物'] ?? '',
        allForeshadows: (json['全本所有隐藏设定/伏笔汇总'] as List<dynamic>?)
                ?.map((e) =>
                    ForeshadowRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        changeHistory: (json['设定变更历史记录'] as List<dynamic>?)
                ?.map((e) =>
                    SettingChangeRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        '时代背景': eraBackground,
        '核心地理区域与地图': geographyMap,
        '完整力量体系/规则': powerSystem,
        '社会结构': socialStructure,
        '核心独特物品/生物': coreItems,
        '全本所有隐藏设定/伏笔汇总':
            allForeshadows.map((e) => e.toJson()).toList(),
        '设定变更历史记录': changeHistory.map((e) => e.toJson()).toList(),
      };
}

class ForeshadowRecord {
  final String content;
  final String appearChapter;
  final String status;
  final String expectedRecycleChapter;

  ForeshadowRecord({
    required this.content,
    required this.appearChapter,
    required this.status,
    required this.expectedRecycleChapter,
  });

  factory ForeshadowRecord.fromJson(Map<String, dynamic> json) =>
      ForeshadowRecord(
        content: json['伏笔内容'] ?? '',
        appearChapter: json['出现章节'] ?? '',
        status: json['当前回收状态'] ?? '未回收',
        expectedRecycleChapter: json['预判回收节点'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '伏笔内容': content,
        '出现章节': appearChapter,
        '当前回收状态': status,
        '预判回收节点': expectedRecycleChapter,
      };
}

class SettingChangeRecord {
  final String changeChapter;
  final String changeContent;
  final String effectiveScope;

  SettingChangeRecord({
    required this.changeChapter,
    required this.changeContent,
    required this.effectiveScope,
  });

  factory SettingChangeRecord.fromJson(Map<String, dynamic> json) =>
      SettingChangeRecord(
        changeChapter: json['变更章节'] ?? '',
        changeContent: json['变更内容'] ?? '',
        effectiveScope: json['生效范围'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '变更章节': changeChapter,
        '变更内容': changeContent,
        '生效范围': effectiveScope,
      };
}

class FullPlotTimeline {
  final String mainPlotComplete;
  final List<KeyEventRecord> keyEventTimeline;
  final String subPlotSummary;
  final String coreConflictEvolution;
  final String plotNodeDependency;

  FullPlotTimeline({
    required this.mainPlotComplete,
    required this.keyEventTimeline,
    required this.subPlotSummary,
    required this.coreConflictEvolution,
    required this.plotNodeDependency,
  });

  factory FullPlotTimeline.fromJson(Map<String, dynamic> json) =>
      FullPlotTimeline(
        mainPlotComplete: json['主线剧情完整脉络'] ?? '',
        keyEventTimeline: (json['全本关键事件时序表'] as List<dynamic>?)
                ?.map(
                    (e) => KeyEventRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        subPlotSummary: json['支线剧情汇总与关联关系'] ?? '',
        coreConflictEvolution: json['全本核心冲突演变轨迹'] ?? '',
        plotNodeDependency: json['剧情节点依赖关系图'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '主线剧情完整脉络': mainPlotComplete,
        '全本关键事件时序表':
            keyEventTimeline.map((e) => e.toJson()).toList(),
        '支线剧情汇总与关联关系': subPlotSummary,
        '全本核心冲突演变轨迹': coreConflictEvolution,
        '剧情节点依赖关系图': plotNodeDependency,
      };
}

class KeyEventRecord {
  final String eventId;
  final String eventName;
  final String participants;
  final String happenChapter;
  final String causeEffect;
  final String mainPlotImpact;

  KeyEventRecord({
    required this.eventId,
    required this.eventName,
    required this.participants,
    required this.happenChapter,
    required this.causeEffect,
    required this.mainPlotImpact,
  });

  factory KeyEventRecord.fromJson(Map<String, dynamic> json) => KeyEventRecord(
        eventId: json['事件ID'] ?? '',
        eventName: json['事件名'] ?? '',
        participants: json['参与人物'] ?? '',
        happenChapter: json['发生章节'] ?? '',
        causeEffect: json['前因后果'] ?? '',
        mainPlotImpact: json['对主线的影响'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '事件ID': eventId,
        '事件名': eventName,
        '参与人物': participants,
        '发生章节': happenChapter,
        '前因后果': causeEffect,
        '对主线的影响': mainPlotImpact,
      };
}

class GlobalWritingStyle {
  final String fixedNarrativePerspective;
  final String coreLanguageStyle;
  final String dialogueWritingFeature;
  final String commonRhetoricAndSentence;
  final String overallRhythmPattern;
  final String sceneDescriptionHabit;

  GlobalWritingStyle({
    required this.fixedNarrativePerspective,
    required this.coreLanguageStyle,
    required this.dialogueWritingFeature,
    required this.commonRhetoricAndSentence,
    required this.overallRhythmPattern,
    required this.sceneDescriptionHabit,
  });

  factory GlobalWritingStyle.fromJson(Map<String, dynamic> json) =>
      GlobalWritingStyle(
        fixedNarrativePerspective: json['固定叙事视角'] ?? '',
        coreLanguageStyle: json['核心语言风格'] ?? '',
        dialogueWritingFeature: json['对话写作特点'] ?? '',
        commonRhetoricAndSentence: json['常用修辞与句式'] ?? '',
        overallRhythmPattern: json['整体节奏规律'] ?? '',
        sceneDescriptionHabit: json['场景描写习惯'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '固定叙事视角': fixedNarrativePerspective,
        '核心语言风格': coreLanguageStyle,
        '对话写作特点': dialogueWritingFeature,
        '常用修辞与句式': commonRhetoricAndSentence,
        '整体节奏规律': overallRhythmPattern,
        '场景描写习惯': sceneDescriptionHabit,
      };
}

class ReverseDependencyNode {
  final String chapterNodeId;
  final String activeCharacterState;
  final String activeSettingState;
  final String activePlotState;
  final List<String> dependentPreNodes;

  ReverseDependencyNode({
    required this.chapterNodeId,
    required this.activeCharacterState,
    required this.activeSettingState,
    required this.activePlotState,
    required this.dependentPreNodes,
  });

  factory ReverseDependencyNode.fromJson(Map<String, dynamic> json) =>
      ReverseDependencyNode(
        chapterNodeId: json['章节节点ID'] ?? '',
        activeCharacterState: json['生效人设状态'] ?? '',
        activeSettingState: json['生效设定状态'] ?? '',
        activePlotState: json['生效剧情状态'] ?? '',
        dependentPreNodes:
            (json['依赖的前置节点'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        '章节节点ID': chapterNodeId,
        '生效人设状态': activeCharacterState,
        '生效设定状态': activeSettingState,
        '生效剧情状态': activePlotState,
        '依赖的前置节点': dependentPreNodes,
      };
}

class ReverseAnalysisAssessment {
  final String hiddenInfoSummary;
  final String potentialConflictWarning;
  final String settingConsistencyResult;
  final String characterConsistencyAssessment;
  final String foreshadowIntegrityAssessment;
  final int logicalSelfConsistencyScore;

  ReverseAnalysisAssessment({
    required this.hiddenInfoSummary,
    required this.potentialConflictWarning,
    required this.settingConsistencyResult,
    required this.characterConsistencyAssessment,
    required this.foreshadowIntegrityAssessment,
    required this.logicalSelfConsistencyScore,
  });

  factory ReverseAnalysisAssessment.fromJson(Map<String, dynamic> json) =>
      ReverseAnalysisAssessment(
        hiddenInfoSummary: json['全本隐藏信息汇总'] ?? '',
        potentialConflictWarning: json['潜在剧情矛盾预警'] ?? '',
        settingConsistencyResult: json['设定一致性校验结果'] ?? '',
        characterConsistencyAssessment: json['人设连贯性评估'] ?? '',
        foreshadowIntegrityAssessment: json['伏笔完整性评估'] ?? '',
        logicalSelfConsistencyScore:
            json['全文本逻辑自洽性得分'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '全本隐藏信息汇总': hiddenInfoSummary,
        '潜在剧情矛盾预警': potentialConflictWarning,
        '设定一致性校验结果': settingConsistencyResult,
        '人设连贯性评估': characterConsistencyAssessment,
        '伏笔完整性评估': foreshadowIntegrityAssessment,
        '全文本逻辑自洽性得分': logicalSelfConsistencyScore,
      };
}

/// 续写前置校验结果
class PrecheckResult {
  final bool isPass;
  final Map<String, dynamic> preMergedGraph;
  final String redLines;
  final String forbiddenRules;
  final String foreshadowList;
  final String conflictWarning;
  final String possiblePlotDirections;
  final String complianceReport;

  PrecheckResult({
    required this.isPass,
    required this.preMergedGraph,
    required this.redLines,
    required this.forbiddenRules,
    required this.foreshadowList,
    required this.conflictWarning,
    required this.possiblePlotDirections,
    required this.complianceReport,
  });

  factory PrecheckResult.fromJson(Map<String, dynamic> json) => PrecheckResult(
        isPass: json['isPass'] ?? true,
        preMergedGraph: json['preMergedGraph'] is Map
            ? json['preMergedGraph'] as Map<String, dynamic>
            : {},
        redLines: json['人设红线清单'] ?? '',
        forbiddenRules: json['设定禁区清单'] ?? '',
        foreshadowList: json['可呼应伏笔清单'] ?? '',
        conflictWarning: json['潜在矛盾预警'] ?? '',
        possiblePlotDirections: json['可推进剧情方向'] ?? '',
        complianceReport: json['合规性报告'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'isPass': isPass,
        'preMergedGraph': preMergedGraph,
        '人设红线清单': redLines,
        '设定禁区清单': forbiddenRules,
        '可呼应伏笔清单': foreshadowList,
        '潜在矛盾预警': conflictWarning,
        '可推进剧情方向': possiblePlotDirections,
        '合规性报告': complianceReport,
      };
}

/// 质量评估结果
class QualityResult {
  final int totalScore;
  final int characterConsistencyScore;
  final int settingComplianceScore;
  final int plotCohesionScore;
  final int styleMatchScore;
  final int contentQualityScore;
  final String report;
  final bool isPassed;

  QualityResult({
    required this.totalScore,
    required this.characterConsistencyScore,
    required this.settingComplianceScore,
    required this.plotCohesionScore,
    required this.styleMatchScore,
    required this.contentQualityScore,
    required this.report,
    required this.isPassed,
  });

  factory QualityResult.fromJson(Map<String, dynamic> json) => QualityResult(
        totalScore: json['总分'] ?? 0,
        characterConsistencyScore: json['人设一致性得分'] ?? 0,
        settingComplianceScore: json['设定合规性得分'] ?? 0,
        plotCohesionScore: json['剧情衔接度得分'] ?? 0,
        styleMatchScore: json['文风匹配度得分'] ?? 0,
        contentQualityScore: json['内容质量得分'] ?? 0,
        report: json['评估报告'] ?? '',
        isPassed: json['是否合格'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        '总分': totalScore,
        '人设一致性得分': characterConsistencyScore,
        '设定合规性得分': settingComplianceScore,
        '剧情衔接度得分': plotCohesionScore,
        '文风匹配度得分': styleMatchScore,
        '内容质量得分': contentQualityScore,
        '评估报告': report,
        '是否合格': isPassed,
      };
}
