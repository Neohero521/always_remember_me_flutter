// Package: bookshelf data datasources
// LocalBookshelfDatasource: Hive-based local storage for bookshelf data.
// Delegates to the existing StorageService (singleton) rather than
// duplicating Hive box management.

import '../../../../services/storage_service.dart';
import '../../domain/models/novel_book.dart';

/// Local data source for bookshelf operations.
/// Wraps the existing StorageService which handles all Hive I/O.
/// This datasource is responsible for serializing/deserializing
/// bookshelf entities to/from Hive storage.
class LocalBookshelfDatasource {
  final StorageService _storage;

  LocalBookshelfDatasource({StorageService? storage})
      : _storage = storage ?? StorageService();

  /// Load all books from the bookshelf metadata in Hive.
  Future<List<NovelBook>> loadBookshelf() async {
    return _storage.loadBookshelf();
  }

  /// Persist the full bookshelf metadata list to Hive.
  Future<void> saveBookshelf(List<NovelBook> books) async {
    await _storage.saveBookshelf(books);
  }

  /// Load a specific book's full data from Hive.
  /// Returns null if the book has no data stored.
  Future<NovelPersistData?> loadBookData(String bookId) async {
    return _storage.loadNovelDataForBook(bookId);
  }

  /// Save a specific book's data to Hive.
  Future<void> saveBookData(String bookId, NovelPersistData data) async {
    await _storage.saveNovelDataForBook(bookId, data);
  }

  /// Delete all data associated with a specific book from Hive.
  Future<void> deleteBookData(String bookId) async {
    await _storage.deleteBookData(bookId);
  }

  /// Clear all novel data from Hive.
  /// WARNING: This deletes all books and their data!
  Future<void> clearAllData() async {
    await _storage.clearNovelData();
  }
}
