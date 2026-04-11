// Package: chapter_management domain usecases
// GetChaptersUseCase: retrieves all chapters.

import '../models/chapter.dart';
import '../repositories/i_chapter_repository.dart';

/// Use case for getting all chapters.
class GetChaptersUseCase {
  final IChapterRepository _repository;

  GetChaptersUseCase(this._repository);

  /// Execute the use case.
  List<Chapter> execute() {
    return _repository.getChapters();
  }
}
