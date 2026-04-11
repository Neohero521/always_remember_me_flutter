// Package: bookshelf domain use cases
// AddBookUseCase: imports a new book into the bookshelf.

import '../repositories/i_novel_repository.dart';
import '../models/novel_book.dart';

/// Use case for importing/adding a new book to the bookshelf.
class AddBookUseCase {
  final INovelRepository _repository;

  AddBookUseCase(this._repository);

  /// Import a new novel book.
  ///
  /// [rawFileName] - Original filename of the imported file.
  /// [novelText] - Full text content of the novel.
  /// [customTitle] - Optional custom title override.
  /// [customRegex] - Optional custom chapter-splitting regex.
  /// [wordCount] - Optional fixed word count per chapter.
  ///
  /// Returns the newly created [NovelBook].
  Future<NovelBook> call({
    required String rawFileName,
    required String novelText,
    String? customTitle,
    String? customRegex,
    int? wordCount,
  }) {
    return _repository.addBook(
      rawFileName: rawFileName,
      novelText: novelText,
      customTitle: customTitle,
      customRegex: customRegex,
      wordCount: wordCount,
    );
  }
}
