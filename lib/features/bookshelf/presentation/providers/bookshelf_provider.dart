// Package: bookshelf presentation providers
// BookshelfProvider: presentation-layer state holder that COMPOSES NovelProvider.
// This provider does NOT replace NovelProvider — it wraps and delegates to it,
// following the composition-over-inheritance principle.
//
// Existing code using NovelProvider directly continues to work unchanged.
// This provider provides a Clean-Architecture-aligned interface on top of it.

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../providers/novel_provider.dart';
import '../../domain/models/novel_book.dart';
import '../../domain/repositories/i_novel_repository.dart';
import '../../domain/usecases/add_book_usecase.dart';
import '../../domain/usecases/delete_book_usecase.dart';
import '../../domain/usecases/get_bookshelf_usecase.dart';
import '../../domain/usecases/select_book_usecase.dart';
import '../../data/datasources/local_bookshelf_datasource.dart';
import '../../data/repositories/bookshelf_repository_impl.dart';

/// Bookshelf presentation provider.
///
/// This provider composes the existing [NovelProvider] (the single source of truth)
/// with Clean Architecture use cases. All actual state lives in [NovelProvider];
/// this class merely provides a cleaner, use-case-driven interface on top.
///
/// Usage example:
/// ```dart
/// // In a widget that needs bookshelf operations:
/// final bookshelf = context.read<BookshelfProvider>();
/// await bookshelf.addBook(rawFileName: 'mynovel.txt', novelText: text);
/// ```
///
/// Note: The existing [BookshelfScreen] continues to use [NovelProvider] directly.
/// This provider is available for new code that prefers the Clean Architecture style.
class BookshelfProvider extends ChangeNotifier {
  late final INovelRepository _repository;
  late final AddBookUseCase _addBookUseCase;
  late final DeleteBookUseCase _deleteBookUseCase;
  late final GetBookshelfUseCase _getBookshelfUseCase;
  late final SelectBookUseCase _selectBookUseCase;

  BookshelfProvider({
    required NovelProvider novelProvider,
    LocalBookshelfDatasource? datasource,
  }) {
    final ds = datasource ?? LocalBookshelfDatasource();
    _repository = BookshelfRepositoryImpl(
      datasource: ds,
      novelProvider: novelProvider,
    );
    _addBookUseCase = AddBookUseCase(_repository);
    _deleteBookUseCase = DeleteBookUseCase(_repository);
    _getBookshelfUseCase = GetBookshelfUseCase(_repository);
    _selectBookUseCase = SelectBookUseCase(_repository);
  }

  // ─── Proxy getters from NovelProvider (read-through) ──────────

  /// All books in the bookshelf.
  List<NovelBook> get books => _getBookshelfUseCase();

  /// Currently active book ID, if any.
  String? get currentBookId => _getBookshelfUseCase.getCurrentBookId();

  /// Currently active book object, if any.
  NovelBook? get currentBook {
    final id = currentBookId;
    if (id == null) return null;
    return _getBookshelfUseCase.getBookById(id);
  }

  // ─── Use case methods ──────────────────────────────────────────

  /// Import and add a new book to the bookshelf.
  ///
  /// See [AddBookUseCase] for parameters.
  Future<NovelBook> addBook({
    required String rawFileName,
    required String novelText,
    String? customTitle,
    String? customRegex,
    int? wordCount,
  }) {
    return _addBookUseCase(
      rawFileName: rawFileName,
      novelText: novelText,
      customTitle: customTitle,
      customRegex: customRegex,
      wordCount: wordCount,
    );
  }

  /// Delete a book from the bookshelf by ID.
  Future<void> deleteBook(String bookId) {
    return _deleteBookUseCase(bookId);
  }

  /// Select a book and load its data into memory.
  /// Returns true if the book was found and loaded.
  Future<bool> selectBook(String bookId) {
    return _selectBookUseCase(bookId);
  }

  /// Get a specific book by ID, or null if not found.
  NovelBook? getBookById(String bookId) {
    return _getBookshelfUseCase.getBookById(bookId);
  }

  /// Check if a specific book exists in the bookshelf.
  bool bookExists(String bookId) {
    return _getBookshelfUseCase.bookExists(bookId);
  }

  // ─── Refresh notification ─────────────────────────────────────
  //
  // Since actual state lives in NovelProvider, we do NOT manage our own
  // notifyListeners. Callers should listen to NovelProvider instead,
  // or use the BookshelfScreen which already does this.
  //
  // This provider is effectively stateless — it just forwards calls.
  // It exists to provide the Clean Architecture interface layer.
}
