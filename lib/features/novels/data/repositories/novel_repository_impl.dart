import 'package:uuid/uuid.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/novel.dart';
import '../../domain/repositories/novel_repository.dart';
import '../datasources/novel_local_datasource.dart';

class NovelRepositoryImpl implements NovelRepository {
  final NovelLocalDatasource _datasource;
  final Uuid _uuid = const Uuid();

  NovelRepositoryImpl(this._datasource);

  @override
  Future<List<Novel>> getNovels({int page = 1, int pageSize = 20}) async {
    final entities = await _datasource.getNovels();
    return entities.map(_entityToModel).toList();
  }

  @override
  Stream<List<Novel>> watchNovels() {
    return _datasource.watchNovels().map(
          (entities) => entities.map(_entityToModel).toList(),
        );
  }

  @override
  Future<Novel?> getNovelById(String id) async {
    final entity = await _datasource.getById(id);
    return entity != null ? _entityToModel(entity) : null;
  }

  @override
  Future<Novel> createNovel({
    required String title,
    String? author,
    String? introduction,
  }) async {
    final now = DateTime.now();
    final model = Novel(
      id: _uuid.v4(),
      title: title,
      author: author ?? '',
      introduction: introduction ?? '',
      createdAt: now,
      updatedAt: now,
    );
    await _datasource.insert(_modelToEntity(model));
    return model;
  }

  @override
  Future<void> updateNovel(Novel model) async {
    final entity = _modelToEntity(model.copyWith(updatedAt: DateTime.now()));
    await _datasource.update(entity);
  }

  @override
  Future<void> deleteNovel(String id) => _datasource.delete(id);

  @override
  Future<Novel> importNovel({
    required String title,
    String? author,
    String? introduction,
    String? content,
  }) async {
    return createNovel(
      title: title,
      author: author,
      introduction: introduction,
    );
  }

  NovelEntity _modelToEntity(Novel model) {
    return NovelEntity(
      id: model.id,
      title: model.title,
      author: model.author,
      cover: model.cover,
      introduction: model.introduction,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  Novel _entityToModel(NovelEntity entity) {
    return Novel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      cover: entity.cover,
      introduction: entity.introduction,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
