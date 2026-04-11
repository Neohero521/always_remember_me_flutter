// Package: bookshelf domain models
// Re-exports the existing NovelBook model from the app core.
// We intentionally do NOT duplicate the model — the domain layer
// references the existing entity defined in lib/models/novel_book.dart.

export '../../../../models/novel_book.dart' show NovelBook;
