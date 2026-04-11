// Package: writing domain use cases
// EvaluateQualityUseCase: evaluates the quality of generated continuation content.

import '../models/continue_chapter.dart';
import '../repositories/i_writing_repository.dart';

/// Use case for evaluating the quality of continuation content.
///
/// This use case retrieves the quality evaluation result from the repository,
/// which performs the actual AI-powered quality assessment.
class EvaluateQualityUseCase {
  final IWritingRepository _repository;

  EvaluateQualityUseCase(this._repository);

  /// Get the latest quality evaluation result.
  ///
  /// Returns the quality result if available, or null if no evaluation was performed.
  QualityResultModel? call() {
    return _repository.qualityResult;
  }

  /// Check if quality result should be shown.
  bool shouldShowQualityResult() {
    return _repository.qualityResultShow;
  }
}
