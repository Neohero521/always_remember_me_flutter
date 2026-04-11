// Package: bookshelf domain use cases
// SelectBookUseCase: switches the active book in the bookshelf.

import '../repositories/i_novel_repository.dart';

/// Use case for selecting/activating a book from the bookshelf.
class SelectBookUseCase {
  final INovelRepository _repository;

  SelectBookUseCase(this._repository);

  /// Select a book by ID and load its data into memory.
  ///
  /// Returns true if the book was found and loaded successfully.
  /// Returns false if the book has no data (e.g., import failed).
  Future<bool> call(String bookId) {
    return _repository.selectBook(bookId);
  }
}
