// Package: graph domain models
// Re-exports the existing knowledge graph models from lib/models/knowledge_graph.dart.

export '../../../../models/knowledge_graph.dart'
    show
        NovelKnowledgeGraph,
        MergedKnowledgeGraph,
        BaseChapterInfo,
        CharacterInfo,
        WorldSetting,
        PlotLine,
        WritingStyle,
        RelationshipEdge,
        ChangeAndDependInfo,
        GlobalBaseInfo,
        MergedCharacterInfo,
        MergedWorldSetting,
        FullPlotTimeline,
        GlobalWritingStyle,
        ReverseDependencyNode,
        ReverseAnalysisAssessment;

/// 图谱生成/合并状态
enum GraphStatus {
  idle,
  generating,
  merging,
  completed,
  error,
}

/// 图谱合规性校验结果
class GraphComplianceResult {
  final bool passed;
  final String message;

  const GraphComplianceResult({required this.passed, required this.message});
}

/// 单章节图谱状态摘要
class ChapterGraphStatus {
  final int totalCount;
  final int hasGraphCount;
  final int noGraphCount;
  final List<String> noGraphTitles;

  const ChapterGraphStatus({
    required this.totalCount,
    required this.hasGraphCount,
    required this.noGraphCount,
    required this.noGraphTitles,
  });
}
