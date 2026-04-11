// Package: reader domain repositories
// IReaderRepository: abstract interface for reader operations.

import '../models/reader_config.dart';

/// Abstract repository interface for reader operations.
/// Uses dependency inversion: the domain layer defines the contract,
/// the data layer implements it.
abstract class IReaderRepository {
  /// Get the current reader configuration.
  ReaderConfig getReaderConfig();

  /// Update the reader font size.
  Future<void> updateFontSize(int fontSize);

  /// Update the current chapter ID.
  Future<void> updateCurrentChapterId(int chapterId);

  /// Persist and update the current chapter scroll position.
  Future<void> persistScrollPosition(
      String bookId, int chapterId, double fraction);

  /// Load the saved scroll position fraction for a chapter.
  Future<double> loadScrollFraction(String bookId, int chapterId);
}
