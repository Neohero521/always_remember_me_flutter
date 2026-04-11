// Package: writing domain repository interface
// Abstract interface for writing/continuation operations.
// Concrete implementation lives in the data layer.

import '../models/continue_chapter.dart';

/// Abstract repository interface for writing operations.
/// This defines the contract that the data layer must fulfill,
/// enabling dependency inversion in the domain layer.
abstract class IWritingRepository {
  /// Run precheck for continuation from a given chapter.
  Future<PrecheckResultModel?> runPrecheck(int baseChapterId, {String? modifiedContent});

  /// Generate continuation content from a base chapter.
  Future<String?> generateWrite({String? modifiedContent});

  /// Continue writing from a chain chapter.
  Future<String?> continueFromChain(int targetChainId);

  /// Get the selected base chapter ID.
  String? get selectedBaseChapterId;

  /// Get the current write preview content.
  String? get writePreview;

  /// Get the precheck result.
  PrecheckResultModel? get precheckResult;

  /// Get the quality result.
  QualityResultModel? get qualityResult;

  /// Get the quality result show flag.
  bool get qualityResultShow;

  /// Get the is generating write flag.
  bool get isGeneratingWrite;

  /// Get the write progress text.
  String get writeProgressText;

  /// Get all continue chain chapters.
  List<ContinueChapter> get continueChain;

  /// Select a base chapter for writing.
  void selectBaseChapter(String chapterId);

  /// Stop the current write operation.
  void stopWrite();

  /// Clear the write preview.
  void clearWritePreview();

  /// Remove a chapter from the continue chain.
  void removeContinueChapter(int chainId);

  /// Clear the entire continue chain.
  void clearContinueChain();
}
