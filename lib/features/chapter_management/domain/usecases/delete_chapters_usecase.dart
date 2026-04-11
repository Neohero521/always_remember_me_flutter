// Package: chapter_management domain usecases
// DeleteChaptersUseCase: deletes chapters by IDs.

import '../repositories/i_chapter_repository.dart';

/// Use case for deleting chapters.
class DeleteChaptersUseCase {
  final IChapterRepository _repository;

  DeleteChaptersUseCase(this._repository);

  /// Execute the use case.
  /// [ids] is the list of chapter IDs to delete.
  Future<void> execute(List<int> ids) async {
    await _repository.deleteChapters(ids);
  }
}
