// Package: writing presentation providers
// WritingProvider: presentation-layer state holder that COMPOSES NovelProvider.
// This provider does NOT replace NovelProvider — it wraps and delegates to it,
// following the composition-over-inheritance principle.
//
// Existing code using NovelProvider directly continues to work unchanged.
// This provider provides a Clean-Architecture-aligned interface on top of it.

import 'package:flutter/foundation.dart';

import '../../../../providers/novel_provider.dart';
import '../../domain/models/continue_chapter.dart';
import '../../domain/repositories/i_writing_repository.dart';
import '../../domain/usecases/evaluate_quality_usecase.dart';
import '../../domain/usecases/generate_write_usecase.dart';
import '../../domain/usecases/run_precheck_usecase.dart';
import '../../data/datasources/local_continue_chapter_datasource.dart';
import '../../data/repositories/writing_repository_impl.dart';

/// Writing presentation provider.
///
/// This provider composes the existing [NovelProvider] (the single source of truth)
/// with Clean Architecture use cases. All actual state lives in [NovelProvider];
/// this class merely provides a cleaner, use-case-driven interface on top.
///
/// Usage example:
/// ```dart
/// // In a widget that needs writing operations:
/// final writing = context.read<WritingProvider>();
/// await writing.selectBaseChapter('5');
/// final result = await writing.generateWrite();
/// ```
///
/// Note: The existing writing-related screens continue to use [NovelProvider] directly.
/// This provider is available for new code that prefers the Clean Architecture style.
class WritingProvider extends ChangeNotifier {
  late final IWritingRepository _repository;
  late final GenerateWriteUseCase _generateWriteUseCase;
  late final EvaluateQualityUseCase _evaluateQualityUseCase;
  late final RunPrecheckUseCase _runPrecheckUseCase;

  WritingProvider({
    required NovelProvider novelProvider,
    LocalContinueChapterDatasource? datasource,
  }) {
    _repository = WritingRepositoryImpl(novelProvider: novelProvider);
    _generateWriteUseCase = GenerateWriteUseCase(_repository);
    _evaluateQualityUseCase = EvaluateQualityUseCase(_repository);
    _runPrecheckUseCase = RunPrecheckUseCase(_repository);
  }

  // ─── Proxy getters from NovelProvider (read-through) ──────────

  /// Currently selected base chapter ID for writing.
  String? get selectedBaseChapterId => _repository.selectedBaseChapterId;

  /// Current write preview content.
  String? get writePreview => _repository.writePreview;

  /// Latest precheck result.
  PrecheckResultModel? get precheckResult => _repository.precheckResult;

  /// Latest quality evaluation result.
  QualityResultModel? get qualityResult => _repository.qualityResult;

  /// Whether to show quality result.
  bool get qualityResultShow => _repository.qualityResultShow;

  /// Whether a write operation is in progress.
  bool get isGeneratingWrite => _repository.isGeneratingWrite;

  /// Current write progress text.
  String get writeProgressText => _repository.writeProgressText;

  /// All continue chain chapters.
  List<ContinueChapter> get continueChain => _repository.continueChain;

  // ─── Use case methods ──────────────────────────────────────────

  /// Select a base chapter for writing.
  void selectBaseChapter(String chapterId) {
    _repository.selectBaseChapter(chapterId);
    notifyListeners();
  }

  /// Generate continuation content from the selected base chapter.
  ///
  /// [modifiedContent] is optional modified chapter content to use instead of the original.
  /// Returns the generated continuation text, or null if generation failed.
  Future<String?> generateWrite({String? modifiedContent}) {
    return _generateWriteUseCase(modifiedContent: modifiedContent);
  }

  /// Continue writing from a chain chapter.
  ///
  /// [targetChainId] is the ID of the chain chapter to continue from.
  /// Returns the generated continuation text, or null if generation failed.
  Future<String?> continueFromChain(int targetChainId) {
    return _generateWriteUseCase.continueFromChain(targetChainId);
  }

  /// Run precheck validation on a base chapter.
  ///
  /// [baseChapterId] is the chapter ID to precheck.
  /// [modifiedContent] is optional modified chapter content.
  /// Returns the precheck result, or null if failed.
  Future<PrecheckResultModel?> runPrecheck({
    required int baseChapterId,
    String? modifiedContent,
  }) {
    return _runPrecheckUseCase(
      baseChapterId: baseChapterId,
      modifiedContent: modifiedContent,
    );
  }

  /// Get the quality evaluation result.
  QualityResultModel? getQualityResult() {
    return _evaluateQualityUseCase();
  }

  /// Check if quality result should be shown.
  bool shouldShowQualityResult() {
    return _evaluateQualityUseCase.shouldShowQualityResult();
  }

  /// Stop the current write operation.
  void stopWrite() {
    _repository.stopWrite();
    notifyListeners();
  }

  /// Clear the write preview.
  void clearWritePreview() {
    _repository.clearWritePreview();
    notifyListeners();
  }

  /// Remove a chapter from the continue chain.
  void removeContinueChapter(int chainId) {
    _repository.removeContinueChapter(chainId);
    notifyListeners();
  }

  /// Clear the entire continue chain.
  void clearContinueChain() {
    _repository.clearContinueChain();
    notifyListeners();
  }
}
