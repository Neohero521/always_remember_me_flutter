// Package: writing data repositories
// WritingRepositoryImpl: concrete implementation of IWritingRepository.
// Uses NovelProvider for state management and AI services.
//
// IMPORTANT: This repository does NOT manage its own state.
// It delegates all state mutations to the provided NovelProvider instance,
// which is the single source of truth.

import '../../../../providers/novel_provider.dart';
import '../../domain/models/continue_chapter.dart';
import '../../domain/repositories/i_writing_repository.dart';

/// Concrete implementation of [IWritingRepository].
///
/// This repository bridges the domain layer with the data layer:
/// - Uses [NovelProvider] (injected) for all state mutations
/// - Uses NovelProvider's built-in AI service (NovelApiService) for API calls
///
/// IMPORTANT: This repository does NOT manage its own state.
/// It delegates all state mutations to the provided NovelProvider instance,
/// which is the single source of truth for the application's novel state.
class WritingRepositoryImpl implements IWritingRepository {
  final NovelProvider _novelProvider;

  WritingRepositoryImpl({required NovelProvider novelProvider})
      : _novelProvider = novelProvider;

  // ─── IWritingRepository implementation ──────────────────────────

  @override
  String? get selectedBaseChapterId => _novelProvider.selectedBaseChapterId;

  @override
  String? get writePreview => _novelProvider.writePreview;

  @override
  PrecheckResultModel? get precheckResult {
    final result = _novelProvider.precheckResult;
    if (result == null) return null;
    return PrecheckResultModel(
      isPass: result.isPass,
      preMergedGraph: result.preMergedGraph,
      redLines: result.redLines,
      forbiddenRules: result.forbiddenRules,
      foreshadowList: result.foreshadowList,
      conflictWarning: result.conflictWarning,
      possiblePlotDirections: result.possiblePlotDirections,
      complianceReport: result.complianceReport,
    );
  }

  @override
  QualityResultModel? get qualityResult {
    final result = _novelProvider.qualityResult;
    if (result == null) return null;
    return QualityResultModel(
      totalScore: result.totalScore,
      characterConsistencyScore: result.characterConsistencyScore,
      settingComplianceScore: result.settingComplianceScore,
      plotCohesionScore: result.plotCohesionScore,
      styleMatchScore: result.styleMatchScore,
      contentQualityScore: result.contentQualityScore,
      report: result.report,
      isPassed: result.isPassed,
    );
  }

  @override
  bool get qualityResultShow => _novelProvider.qualityResultShow;

  @override
  bool get isGeneratingWrite => _novelProvider.isGeneratingWrite;

  @override
  String get writeProgressText => _novelProvider.writeProgressText;

  @override
  List<ContinueChapter> get continueChain => _novelProvider.continueChain;

  @override
  Future<PrecheckResultModel?> runPrecheck(
    int baseChapterId, {
    String? modifiedContent,
  }) async {
    final result = await _novelProvider.runPrecheck(
      baseChapterId,
      modifiedContent: modifiedContent,
    );
    if (result == null) return null;
    return PrecheckResultModel(
      isPass: result.isPass,
      preMergedGraph: result.preMergedGraph,
      redLines: result.redLines,
      forbiddenRules: result.forbiddenRules,
      foreshadowList: result.foreshadowList,
      conflictWarning: result.conflictWarning,
      possiblePlotDirections: result.possiblePlotDirections,
      complianceReport: result.complianceReport,
    );
  }

  @override
  Future<String?> generateWrite({String? modifiedContent}) async {
    return _novelProvider.generateWrite(modifiedContent: modifiedContent);
  }

  @override
  Future<String?> continueFromChain(int targetChainId) async {
    return _novelProvider.continueFromChain(targetChainId);
  }

  @override
  void selectBaseChapter(String chapterId) {
    _novelProvider.selectBaseChapter(chapterId);
  }

  @override
  void stopWrite() {
    _novelProvider.stopWrite();
  }

  @override
  void clearWritePreview() {
    _novelProvider.clearWritePreview();
  }

  @override
  void removeContinueChapter(int chainId) {
    _novelProvider.removeContinueChapter(chainId);
  }

  @override
  void clearContinueChain() {
    _novelProvider.clearContinueChain();
  }
}
