// Package: reader data datasources
// LocalReaderDatasource: SharedPreferences-based local storage for reader state.

import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for reader operations.
/// Persists reader scroll position via SharedPreferences.
class LocalReaderDatasource {
  static const _fontSizeKey = 'readerFontSize';
  static const _currentChapterIdKey = 'currentChapterId';
  static const _scrollPrefix = 'reader_scroll_';

  /// Get the stored font size, defaults to 16.
  Future<int> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontSizeKey) ?? 16;
  }

  /// Persist the font size.
  Future<void> setFontSize(int fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSizeKey, fontSize);
  }

  /// Get the stored current chapter ID.
  Future<int?> getCurrentChapterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentChapterIdKey);
  }

  /// Persist the current chapter ID.
  Future<void> setCurrentChapterId(int chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentChapterIdKey, chapterId);
  }

  /// Persist scroll position as a fraction [0.0, 1.0].
  Future<void> setScrollFraction(
      String bookId, int chapterId, double fraction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_scrollPrefix${bookId}_$chapterId', fraction);
  }

  /// Load the saved scroll fraction for a chapter.
  Future<double> getScrollFraction(String bookId, int chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$_scrollPrefix${bookId}_$chapterId') ?? 0.0;
  }
}
