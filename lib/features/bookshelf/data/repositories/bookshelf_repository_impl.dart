// Package: bookshelf data repositories
// BookshelfRepositoryImpl: concrete implementation of INovelRepository.
// Uses LocalBookshelfDatasource (Hive) for persistence and
// NovelProvider for in-memory state management.

import 'package:flutter/foundation.dart';
import '../../../../providers/novel_provider.dart';
import '../../domain/repositories/i_novel_repository.dart';
import '../../domain/models/novel_book.dart';
import '../datasources/local_bookshelf_datasource.dart';

/// Concrete implementation of [INovelRepository].
///
/// This repository bridges the domain layer with the data layer:
/// - Uses [LocalBookshelfDatasource] for Hive persistence
/// - Uses [NovelProvider] (injected) for in-memory state mutations
///
/// IMPORTANT: This repository does NOT manage its own in-memory state.
/// It delegates all state mutations to the provided NovelProvider instance,
/// which is the single source of truth for the application's novel state.
class BookshelfRepositoryImpl implements INovelRepository {
  final LocalBookshelfDatasource _datasource;
  final NovelProvider _novelProvider;

  BookshelfRepositoryImpl({
    required LocalBookshelfDatasource datasource,
    required NovelProvider novelProvider,
  })  : _datasource = datasource,
        _novelProvider = novelProvider;

  // ─── INovelRepository implementation ──────────────────────────

  @override
  List<NovelBook> getBookshelf() {
    return _novelProvider.bookshelf;
  }

  @override
  String? getCurrentBookId() {
    return _novelProvider.currentBookId;
  }

  @override
  Future<bool> selectBook(String bookId) {
    return _novelProvider.selectBook(bookId);
  }

  @override
  Future<NovelBook> addBook({
    required String rawFileName,
    required String novelText,
    String? customTitle,
    String? customRegex,
    int? wordCount,
  }) async {
    await _novelProvider.importBook(
      rawFileName: rawFileName,
      novelText: novelText,
      customTitle: customTitle,
      customRegex: customRegex,
      wordCount: wordCount,
    );

    // After import, the new book should be the current book.
    // Find and return it from the updated bookshelf.
    final books = _novelProvider.bookshelf;
    final newBook = books.lastWhere(
      (b) => b.rawFileName == rawFileName,
      orElse: () => books.last,
    );
    return newBook;
  }

  @override
  Future<void> deleteBook(String bookId) {
    return _novelProvider.deleteBook(bookId);
  }

  @override
  bool bookExists(String bookId) {
    return _novelProvider.bookshelf.any((b) => b.id == bookId);
  }

  @override
  NovelBook? getBookById(String bookId) {
    try {
      return _novelProvider.bookshelf.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }
}
