import 'package:uuid/uuid.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/chapter.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/chapter_local_datasource.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterLocalDatasource _datasource;
  final Uuid _uuid = const Uuid();

  ChapterRepositoryImpl(this._datasource);

  @override
  Future<List<Chapter>> getChaptersByNovel(String novelId) async {
    final entities = await _datasource.getByNovel(novelId);
    return entities.map(_entityToModel).toList();
  }

  @override
  Stream<List<Chapter>> watchChaptersByNovel(String novelId) {
    return _datasource.watch(novelId).map(
          (entities) => entities.map(_entityToModel).toList(),
        );
  }

  @override
  Future<Chapter?> getChapterById(String id) async {
    final entity = await _datasource.getById(id);
    return entity != null ? _entityToModel(entity) : null;
  }

  @override
  Future<Chapter> createChapter(Chapter chapter) async {
    final model = chapter.copyWith(id: chapter.id.isEmpty ? _uuid.v4() : chapter.id);
    await _datasource.insert(_modelToEntity(model));
    return model;
  }

  @override
  Future<void> updateChapter(Chapter chapter) async {
    await _datasource.update(_modelToEntity(chapter));
  }

  @override
  Future<void> deleteChapter(String id) => _datasource.delete(id);

  @override
  Future<void> deleteChaptersByNovel(String novelId) =>
      _datasource.deleteByNovel(novelId);

  @override
  Future<List<Chapter>> autoChapterize(String content, String novelId) async {
    return [];
  }

  ChapterEntity _modelToEntity(Chapter model) {
    return ChapterEntity(
      id: model.id,
      novelId: model.novelId,
      number: model.number,
      title: model.title,
      content: model.content,
      graphId: model.graphId,
      wordCount: model.wordCount,
      createdAt: model.createdAt,
    );
  }

  Chapter _entityToModel(ChapterEntity entity) {
    return Chapter(
      id: entity.id,
      novelId: entity.novelId,
      number: entity.number,
      title: entity.title,
      content: entity.content,
      graphId: entity.graphId,
      wordCount: entity.wordCount,
      createdAt: entity.createdAt,
    );
  }
}
