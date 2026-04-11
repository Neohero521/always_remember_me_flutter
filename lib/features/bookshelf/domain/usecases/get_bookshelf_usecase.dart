// Package: bookshelf domain use cases
// GetBookshelfUseCase: retrieves the current bookshelf state.

import '../repositories/i_novel_repository.dart';
import '../models/novel_book.dart';

/// Use case for retrieving the full bookshelf.
class GetBookshelfUseCase {
  final INovelRepository _repository;

  GetBookshelfUseCase(this._repository);

  /// Returns all books in the bookshelf.
  List<NovelBook> call() {
    return _repository.getBookshelf();
  }

  /// Returns the currently selected book ID, if any.
  String? getCurrentBookId() {
    return _repository.getCurrentBookId();
  }

  /// Returns a specific book by ID, or null if not found.
  NovelBook? getBookById(String bookId) {
    return _repository.getBookById(bookId);
  }

  /// Check if a specific book exists.
  bool bookExists(String bookId) {
    return _repository.bookExists(bookId);
  }
}
