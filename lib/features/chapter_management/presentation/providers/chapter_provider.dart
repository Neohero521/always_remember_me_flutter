// Package: chapter_management presentation providers
// ChapterProvider: presentation-layer state holder that COMPOSES NovelProvider.

import 'package:flutter/foundation.dart';

import '../../../../providers/novel_provider.dart';
import '../../domain/models/chapter.dart';
import '../../domain/repositories/i_chapter_repository.dart';
import '../../domain/usecases/delete_chapters_usecase.dart';
import '../../domain/usecases/get_chapters_usecase.dart';
import '../../data/datasources/local_chapter_datasource.dart';
import '../../data/repositories/chapter_repository_impl.dart';

/// ChapterProvider: presentation-layer provider that composes NovelProvider.
/// This provider provides a Clean-Architecture-aligned interface on top of NovelProvider.
class ChapterProvider extends ChangeNotifier {
  late final IChapterRepository _repository;
  late final GetChaptersUseCase _getChaptersUseCase;
  late final DeleteChaptersUseCase _deleteChaptersUseCase;

  ChapterProvider({required NovelProvider novelProvider}) {
    final datasource = LocalChapterDatasource(novelProvider: novelProvider);
    _repository = ChapterRepositoryImpl(datasource: datasource);
    _getChaptersUseCase = GetChaptersUseCase(_repository);
    _deleteChaptersUseCase = DeleteChaptersUseCase(_repository);
  }

  /// Get all chapters.
  List<Chapter> get chapters => _getChaptersUseCase.execute();

  /// Delete chapters by IDs.
  Future<void> deleteChapters(List<int> ids) async {
    await _deleteChaptersUseCase.execute(ids);
    notifyListeners();
  }

  /// Get chapter by ID.
  Chapter? getChapterById(int id) {
    return _repository.getChapterById(id);
  }
}
