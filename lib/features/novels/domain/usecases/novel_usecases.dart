import '../models/novel.dart';
import '../repositories/novel_repository.dart';

class GetNovelsUseCase {
  final NovelRepository _repository;
  GetNovelsUseCase(this._repository);

  Future<List<Novel>> call({int page = 1, int pageSize = 20}) =>
      _repository.getNovels(page: page, pageSize: pageSize);

  Stream<List<Novel>> watch() => _repository.watchNovels();

  Future<Novel?> getById(String id) => _repository.getNovelById(id);
}

class CreateNovelUseCase {
  final NovelRepository _repository;
  CreateNovelUseCase(this._repository);

  Future<Novel> call({
    required String title,
    String? author,
    String? introduction,
  }) =>
      _repository.createNovel(
        title: title,
        author: author,
        introduction: introduction,
      );
}

class UpdateNovelUseCase {
  final NovelRepository _repository;
  UpdateNovelUseCase(this._repository);

  Future<void> call(Novel novel) => _repository.updateNovel(novel);
}

class DeleteNovelUseCase {
  final NovelRepository _repository;
  DeleteNovelUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteNovel(id);
}

class ImportNovelUseCase {
  final NovelRepository _repository;
  ImportNovelUseCase(this._repository);

  Future<Novel> call({
    required String title,
    String? author,
    String? introduction,
    String? content,
  }) =>
      _repository.importNovel(
        title: title,
        author: author,
        introduction: introduction,
        content: content,
      );
}
