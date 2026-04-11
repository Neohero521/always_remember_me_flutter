// Package: reader presentation providers
// ReaderProvider: presentation-layer state holder that COMPOSES NovelProvider.
// Follows the composition-over-inheritance principle.
//
// Existing code using NovelProvider directly continues to work unchanged.
// This provider provides a Clean-Architecture-aligned interface on top of it.

// Re-export Chapter for convenience in the presentation layer.
export '../../../../models/chapter.dart' show Chapter;

import 'package:flutter/foundation.dart';
import '../../../../providers/novel_provider.dart';
import '../../domain/models/reader_config.dart';
import '../../domain/repositories/i_reader_repository.dart';
import '../../domain/usecases/get_reader_config_usecase.dart';
import '../../data/datasources/local_reader_datasource.dart';
import '../../data/repositories/reader_repository_impl.dart';

/// Reader presentation provider.
///
/// This provider composes the existing [NovelProvider] (the single source of truth)
/// with Clean Architecture use cases. All actual state lives in [NovelProvider];
/// this class merely provides a cleaner, use-case-driven interface on top.
///
/// The [ReaderScreen] currently uses [NovelProvider] directly.
/// This provider is available for new code that prefers the Clean Architecture style.
class ReaderProvider extends ChangeNotifier {
  late final IReaderRepository _repository;
  late final GetReaderConfigUseCase _getReaderConfigUseCase;

  ReaderProvider({
    required NovelProvider novelProvider,
    LocalReaderDatasource? datasource,
  }) {
    final ds = datasource ?? LocalReaderDatasource();
    _repository = ReaderRepositoryImpl(
      datasource: ds,
      novelProvider: novelProvider,
    );
    _getReaderConfigUseCase = GetReaderConfigUseCase(_repository);
  }

  // ─── Proxy getters from NovelProvider (read-through) ──────────

  /// Current reader configuration (font size + current chapter).
  ReaderConfig get config => _getReaderConfigUseCase();

  /// Current font size.
  int get fontSize => _repository.getReaderConfig().fontSize;

  /// Currently active chapter ID, if any.
  int? get currentChapterId => _repository.getReaderConfig().currentChapterId;

  // ─── Delegated methods ────────────────────────────────────────

  /// Update the reader font size (12-28).
  Future<void> updateFontSize(int fontSize) async {
    await _repository.updateFontSize(fontSize);
    notifyListeners();
  }

  /// Update the current chapter ID.
  Future<void> updateCurrentChapterId(int chapterId) async {
    await _repository.updateCurrentChapterId(chapterId);
    notifyListeners();
  }

  /// Update both font size and chapter at once.
  Future<void> updateReaderState({int? fontSize, int? chapterId}) async {
    if (fontSize != null) {
      await _repository.updateFontSize(fontSize);
    }
    if (chapterId != null) {
      await _repository.updateCurrentChapterId(chapterId);
    }
    notifyListeners();
  }

  /// Persist scroll position as a fraction [0.0, 1.0].
  Future<void> persistScrollPosition(
      String bookId, int chapterId, double fraction) async {
    await _repository.persistScrollPosition(bookId, chapterId, fraction);
  }

  /// Load the saved scroll position fraction.
  Future<double> loadScrollFraction(String bookId, int chapterId) async {
    return _repository.loadScrollFraction(bookId, chapterId);
  }
}
