// Package: writing domain models
// ContinueChapter model: domain representation of a continuation chapter.
// Re-exports the existing ContinueChapter from lib/models/chapter.dart.

export '../../../../../models/chapter.dart' show ContinueChapter;

/// Writing request domain model
class WriteRequest {
  final int baseChapterId;
  final String? modifiedContent;
  final int targetWordCount;

  const WriteRequest({
    required this.baseChapterId,
    this.modifiedContent,
    this.targetWordCount = 2000,
  });
}

/// Precheck result domain model
class PrecheckResultModel {
  final bool isPass;
  final Map<String, dynamic> preMergedGraph;
  final String redLines;
  final String forbiddenRules;
  final String foreshadowList;
  final String conflictWarning;
  final String possiblePlotDirections;
  final String complianceReport;

  const PrecheckResultModel({
    required this.isPass,
    required this.preMergedGraph,
    required this.redLines,
    required this.forbiddenRules,
    required this.foreshadowList,
    required this.conflictWarning,
    required this.possiblePlotDirections,
    required this.complianceReport,
  });
}

/// Quality evaluation result domain model
class QualityResultModel {
  final int totalScore;
  final int characterConsistencyScore;
  final int settingComplianceScore;
  final int plotCohesionScore;
  final int styleMatchScore;
  final int contentQualityScore;
  final String report;
  final bool isPassed;

  const QualityResultModel({
    required this.totalScore,
    required this.characterConsistencyScore,
    required this.settingComplianceScore,
    required this.plotCohesionScore,
    required this.styleMatchScore,
    required this.contentQualityScore,
    required this.report,
    required this.isPassed,
  });
}
