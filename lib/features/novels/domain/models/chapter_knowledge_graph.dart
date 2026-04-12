import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_knowledge_graph.freezed.dart';
part 'chapter_knowledge_graph.g.dart';

// ─── Version marker ────────────────────────────────────────────
const String kKnowledgeGraphVersion = '1.0';

// ═══════════════════════════════════════════════════════════════
//   Single Chapter Knowledge Graph
// ═══════════════════════════════════════════════════════════════

@freezed
class ChapterKnowledgeGraph with _$ChapterKnowledgeGraph {
  const ChapterKnowledgeGraph._();

  const factory ChapterKnowledgeGraph({
    required String id,
    required String chapterId,
    @Default(kKnowledgeGraphVersion) String version,
    required BasicChapterInfo basicInfo,
    @Default([]) List<CharacterInfo> characters,
    @Default(WorldSetting()) WorldSetting worldSetting,
    required PlotLine mainPlot,
    @Default([]) List<PlotLine> subplots,
    required WritingStyle writingStyle,
    @Default([]) List<EntityRelation> relations,
    required GraphChange changeInfo,
    required ReverseAnalysis reverseAnalysis,
  }) = _ChapterKnowledgeGraph;

  factory ChapterKnowledgeGraph.fromJson(Map<String, dynamic> json) =>
      _$ChapterKnowledgeGraphFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 1: Basic Chapter Info
// ─────────────────────────────────────────────────────────────

@freezed
class BasicChapterInfo with _$BasicChapterInfo {
  const factory BasicChapterInfo({
    required String chapterNumber,
    required String chapterVersion,
    required String chapterNodeId,
    required int chapterWordCount,
    required List<String> narrativeTimelineNodes,
    String? summary,
    String? keyEvents,
  }) = _BasicChapterInfo;

  factory BasicChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$BasicChapterInfoFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 2: Character Info
// ─────────────────────────────────────────────────────────────

@freezed
class CharacterInfo with _$CharacterInfo {
  const factory CharacterInfo({
    required String uniqueId,
    required String name,
    @Default('') String alias,
    @Default('') String personalityTraits,
    @Default('') String identityBackground,
    @Default('') String coreBehaviorMotive,
    @Default('') String relationshipChanges,
    @Default('') String characterArcChange,
    @Default([]) List<String> dialogueStyles,
    @Default(0) int appearanceCount,
  }) = _CharacterInfo;

  factory CharacterInfo.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 3: World Setting
// ─────────────────────────────────────────────────────────────

@freezed
class WorldSetting with _$WorldSetting {
  const factory WorldSetting({
    @Default('') String eraBackground,
    @Default([]) List<String> geographyRegions,
    @Default('') String powerSystem,
    @Default('') String socialStructure,
    @Default([]) List<String> itemsAndCreatures,
    @Default([]) List<String> hiddenForeshadows,
    @Default({}) Map<String, dynamic> customSettings,
  }) = _WorldSetting;

  factory WorldSetting.fromJson(Map<String, dynamic> json) =>
      _$WorldSettingFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 4: Plot Line
// ─────────────────────────────────────────────────────────────

@freezed
class PlotLine with _$PlotLine {
  const factory PlotLine({
    required String id,
    @Default('') String description,
    @Default([]) List<String> keyEvents,
    @Default('main') String type, // 'main' | 'subplot'
    @Default('') String conflictProgress,
    @Default([]) List<String> unresolvedForeshadows,
  }) = _PlotLine;

  factory PlotLine.fromJson(Map<String, dynamic> json) =>
      _$PlotLineFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 5: Writing Style
// ─────────────────────────────────────────────────────────────

@freezed
class WritingStyle with _$WritingStyle {
  const factory WritingStyle({
    @Default('第三人称') String narrativePerspective,
    @Default('') String languageStyle,
    @Default([]) List<String> dialogueFeatures,
    @Default([]) List<String> rhetoricalDevices,
    @Default('') String pacingRhythm,
    @Default('') String emotionalTone,
  }) = _WritingStyle;

  factory WritingStyle.fromJson(Map<String, dynamic> json) =>
      _$WritingStyleFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 6: Entity Relations (Triplets)
// ─────────────────────────────────────────────────────────────

@freezed
class EntityRelation with _$EntityRelation {
  const factory EntityRelation({
    required String entityA,
    required String relation,
    required String entityB,
    @Default({}) Map<String, dynamic> properties,
  }) = _EntityRelation;

  factory EntityRelation.fromJson(Map<String, dynamic> json) =>
      _$EntityRelationFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 7: Graph Change
// ─────────────────────────────────────────────────────────────

@freezed
class GraphChange with _$GraphChange {
  const factory GraphChange({
    @Default([]) List<String> globalChanges,
    @Default([]) List<String> prerequisiteChapterDependencies,
    @Default([]) List<String> impactOnFutureChapters,
    @Default([]) List<String> conflictWarnings,
  }) = _GraphChange;

  factory GraphChange.fromJson(Map<String, dynamic> json) =>
      _$GraphChangeFromJson(json);
}

// ─────────────────────────────────────────────────────────────
//   Module 8: Reverse Analysis
// ─────────────────────────────────────────────────────────────

@freezed
class ReverseAnalysis with _$ReverseAnalysis {
  const factory ReverseAnalysis({
    @Default('') String aiInsights,
    @Default([]) List<String> callbackForeshadows,
    @Default({}) Map<String, dynamic> qualityAssessment,
    @Default({}) Map<String, dynamic> narrativeGaps,
  }) = _ReverseAnalysis;

  factory ReverseAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ReverseAnalysisFromJson(json);
}

// ═══════════════════════════════════════════════════════════════
//   Merged Global Knowledge Graph
// ═══════════════════════════════════════════════════════════════

@freezed
class MergedKnowledgeGraph with _$MergedKnowledgeGraph {
  const MergedKnowledgeGraph._();

  const factory MergedKnowledgeGraph({
    required String id,
    required String novelId,
    @Default(kKnowledgeGraphVersion) String version,
    required GlobalBasicInfo globalBasicInfo,
    @Default([]) List<CharacterInfo> characterPool,
    @Default(WorldSettingPool()) WorldSettingPool worldSettingPool,
    required FullPlotTimeline fullPlotTimeline,
    required WritingStyleGuide writingStyleGuide,
    @Default([]) List<EntityRelation> entityNetwork,
    @Default([]) List<ReverseDependency> reverseDepMap,
    required ReverseAnalysis reverseAnalysis,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MergedKnowledgeGraph;

  factory MergedKnowledgeGraph.fromJson(Map<String, dynamic> json) =>
      _$MergedKnowledgeGraphFromJson(json);
}

@freezed
class GlobalBasicInfo with _$GlobalBasicInfo {
  const factory GlobalBasicInfo({
    required String novelName,
    required int totalChapterCount,
    required String version,
    int? totalWordCount,
    String? novelGenre,
  }) = _GlobalBasicInfo;

  factory GlobalBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$GlobalBasicInfoFromJson(json);
}

@freezed
class WorldSettingPool with _$WorldSettingPool {
  const factory WorldSettingPool({
    @Default([]) List<String> allEras,
    @Default([]) List<String> allGeography,
    @Default([]) List<String> allPowerSystems,
    @Default([]) List<String> allSocialStructures,
    @Default([]) List<String> allItemsAndCreatures,
    @Default([]) List<String> allForeshadows,
  }) = _WorldSettingPool;

  factory WorldSettingPool.fromJson(Map<String, dynamic> json) =>
      _$WorldSettingPoolFromJson(json);
}

@freezed
class FullPlotTimeline with _$FullPlotTimeline {
  const factory FullPlotTimeline({
    @Default([]) List<TimelineNode> nodes,
    @Default([]) List<TimelineEdge> edges,
  }) = _FullPlotTimeline;

  factory FullPlotTimeline.fromJson(Map<String, dynamic> json) =>
      _$FullPlotTimelineFromJson(json);
}

@freezed
class TimelineNode with _$TimelineNode {
  const factory TimelineNode({
    required String id,
    required String chapterId,
    required String event,
    @Default('') String timeline,
    @Default({}) Map<String, dynamic> properties,
  }) = _TimelineNode;

  factory TimelineNode.fromJson(Map<String, dynamic> json) =>
      _$TimelineNodeFromJson(json);
}

@freezed
class TimelineEdge with _$TimelineEdge {
  const factory TimelineEdge({
    required String from,
    required String to,
    @Default('') String label,
  }) = _TimelineEdge;

  factory TimelineEdge.fromJson(Map<String, dynamic> json) =>
      _$TimelineEdgeFromJson(json);
}

@freezed
class WritingStyleGuide with _$WritingStyleGuide {
  const factory WritingStyleGuide({
    required WritingStyle dominantStyle,
    @Default([]) List<WritingStyle> chapterStyles,
    @Default({}) Map<String, dynamic> styleEvolution,
  }) = _WritingStyleGuide;

  factory WritingStyleGuide.fromJson(Map<String, dynamic> json) =>
      _$WritingStyleGuideFromJson(json);
}

@freezed
class ReverseDependency with _$ReverseDependency {
  const factory ReverseDependency({
    required String chapterId,
    @Default([]) List<String> dependsOn,
    @Default([]) List<String> affectsChapters,
  }) = _ReverseDependency;

  factory ReverseDependency.fromJson(Map<String, dynamic> json) =>
      _$ReverseDependencyFromJson(json);
}
