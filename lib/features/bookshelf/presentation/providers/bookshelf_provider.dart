import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/novel_book.dart';
import '../../../../services/storage_service.dart';

/// v5.0 Bookshelf State
class BookshelfState {
  final List<NovelBook> books;
  final String? currentBookId;
  final bool isLoading;
  final String? error;

  const BookshelfState({
    this.books = const [],
    this.currentBookId,
    this.isLoading = false,
    this.error,
  });

  BookshelfState copyWith({
    List<NovelBook>? books,
    String? currentBookId,
    bool? isLoading,
    String? error,
  }) {
    return BookshelfState(
      books: books ?? this.books,
      currentBookId: currentBookId ?? this.currentBookId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  NovelBook? get currentBook {
    if (currentBookId == null) return null;
    try {
      return books.firstWhere((b) => b.id == currentBookId);
    } catch (_) {
      return null;
    }
  }
}

/// v5.0 Bookshelf Notifier
class BookshelfNotifier extends StateNotifier<BookshelfState> {
  final StorageService _storage;

  BookshelfNotifier({required StorageService storage})
      : _storage = storage,
        super(const BookshelfState());

  Future<void> loadBookshelf() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final books = await _storage.loadBookshelf();
      String? currentId = state.currentBookId;
      if (currentId == null && books.isNotEmpty) {
        currentId = books.first.id;
      }
      state = state.copyWith(
        books: books,
        currentBookId: currentId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '书架加载失败: $e');
    }
  }

  Future<void> selectBook(String bookId) async {
    state = state.copyWith(currentBookId: bookId);
  }

  Future<void> addBook(NovelBook book) async {
    final newBooks = [...state.books, book];
    state = state.copyWith(books: newBooks, currentBookId: book.id);
    await _storage.saveBookshelf(newBooks);
  }

  Future<void> removeBook(String bookId) async {
    final newBooks = state.books.where((b) => b.id != bookId).toList();
    String? newCurrentId = state.currentBookId;
    if (state.currentBookId == bookId) {
      newCurrentId = newBooks.isNotEmpty ? newBooks.first.id : null;
    }
    state = state.copyWith(books: newBooks, currentBookId: newCurrentId);
    await _storage.saveBookshelf(newBooks);
    await _storage.deleteBookData(bookId);
  }

  Future<void> updateBookMeta(String bookId, {
    int? chapterCount,
    int? lastReadChapterId,
    double? readProgress,
    DateTime? lastReadAt,
  }) async {
    final idx = state.books.indexWhere((b) => b.id == bookId);
    if (idx < 0) return;

    final book = state.books[idx];
    final updated = book.copyWithMeta(
      chapterCount: chapterCount,
      lastReadChapterId: lastReadChapterId,
      readProgress: readProgress,
      lastReadAt: lastReadAt,
    );

    final newBooks = [...state.books];
    newBooks[idx] = updated;
    state = state.copyWith(books: newBooks);
    await _storage.saveBookshelf(newBooks);
  }
}

final bookshelfProvider = StateNotifierProvider<BookshelfNotifier, BookshelfState>((ref) {
  return BookshelfNotifier(storage: StorageService());
});
