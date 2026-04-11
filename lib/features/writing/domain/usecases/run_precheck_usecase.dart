// Package: writing domain use cases
// RunPrecheckUseCase: runs pre-check validation before continuation writing.

import '../models/continue_chapter.dart';
import '../repositories/i_writing_repository.dart';

/// Use case for running pre-check validation before writing.
///
/// This use case performs a compliance check on the selected base chapter
/// to ensure the continuation will respect character settings, world rules,
/// and plot continuity.
class RunPrecheckUseCase {
  final IWritingRepository _repository;

  RunPrecheckUseCase(this._repository);

  /// Run precheck on the selected base chapter.
  ///
  /// [baseChapterId] is the chapter ID to precheck.
  /// [modifiedContent] is optional modified chapter content.
  ///
  /// Returns the precheck result if successful, or null if failed.
  Future<PrecheckResultModel?> call({
    required int baseChapterId,
    String? modifiedContent,
  }) async {
    return _repository.runPrecheck(baseChapterId, modifiedContent: modifiedContent);
  }
}
