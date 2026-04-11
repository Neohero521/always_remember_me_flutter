// Package: bookshelf domain repository interface
// Abstract interface for novel/bookshelf operations.
// Concrete implementation lives in the data layer.

import '../models/novel_book.dart';

/// Abstract repository interface for bookshelf operations.
/// This defines the contract that the data layer must fulfill,
/// enabling dependency inversion in the domain layer.
abstract class INovelRepository {
  /// Get all books in the bookshelf.
  List<NovelBook> getBookshelf();

  /// Get the currently selected book ID, if any.
  String? getCurrentBookId();

  /// Select a book by ID and load its data into memory.
  /// Returns true if the book was found and loaded successfully.
  Future<bool> selectBook(String bookId);

  /// Import a new book from raw novel text.
  /// Returns the newly created [NovelBook].
  Future<NovelBook> addBook({
    required String rawFileName,
    required String novelText,
    String? customTitle,
    String? customRegex,
    int? wordCount,
  });

  /// Delete a book from the bookshelf by ID.
  Future<void> deleteBook(String bookId);

  /// Check if a specific book exists in the bookshelf.
  bool bookExists(String bookId);

  /// Get a specific book by ID, or null if not found.
  NovelBook? getBookById(String bookId);
}
