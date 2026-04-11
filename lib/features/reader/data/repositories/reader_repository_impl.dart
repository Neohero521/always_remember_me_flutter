// Package: reader data repositories
// ReaderRepositoryImpl: concrete implementation of IReaderRepository.
// Composes NovelProvider (for in-memory state) with LocalReaderDatasource
// (for SharedPreferences scroll position persistence).

import '../../../../providers/novel_provider.dart';
import '../../domain/models/reader_config.dart';
import '../../domain/repositories/i_reader_repository.dart';
import '../datasources/local_reader_datasource.dart';

/// Concrete implementation of [IReaderRepository].
///
/// Bridges the domain layer with the data layer:
/// - Uses [LocalReaderDatasource] for SharedPreferences persistence
/// - Uses [NovelProvider] for in-memory state (the single source of truth)
class ReaderRepositoryImpl implements IReaderRepository {
  final LocalReaderDatasource _datasource;
  final NovelProvider _novelProvider;

  ReaderRepositoryImpl({
    required LocalReaderDatasource datasource,
    required NovelProvider novelProvider,
  })  : _datasource = datasource,
        _novelProvider = novelProvider;

  @override
  ReaderConfig getReaderConfig() {
    return ReaderConfig(
      fontSize: _novelProvider.readerFontSize,
      currentChapterId: _novelProvider.currentChapterId,
    );
  }

  @override
  Future<void> updateFontSize(int fontSize) async {
    await _novelProvider.updateReaderState(fontSize: fontSize);
  }

  @override
  Future<void> updateCurrentChapterId(int chapterId) async {
    await _novelProvider.updateReaderState(chapterId: chapterId);
  }

  @override
  Future<void> persistScrollPosition(
      String bookId, int chapterId, double fraction) async {
    await _datasource.setScrollFraction(bookId, chapterId, fraction);
  }

  @override
  Future<double> loadScrollFraction(String bookId, int chapterId) async {
    return _datasource.getScrollFraction(bookId, chapterId);
  }
}
