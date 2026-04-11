// Package: bookshelf domain use cases
// DeleteBookUseCase: removes a book from the bookshelf.

import '../repositories/i_novel_repository.dart';

/// Use case for deleting a book from the bookshelf.
class DeleteBookUseCase {
  final INovelRepository _repository;

  DeleteBookUseCase(this._repository);

  /// Delete a book by its ID.
  /// This will also delete all associated data (chapters, graphs, etc.).
  Future<void> call(String bookId) {
    return _repository.deleteBook(bookId);
  }
}
