import '../models/novel.dart';

abstract class NovelRepository {
  Future<List<Novel>> getNovels({int page = 1, int pageSize = 20});
  Stream<List<Novel>> watchNovels();
  Future<Novel?> getNovelById(String id);
  Future<Novel> createNovel({required String title, String? author, String? introduction});
  Future<void> updateNovel(Novel novel);
  Future<void> deleteNovel(String id);
  Future<Novel> importNovel({
    required String title,
    String? author,
    String? introduction,
    String? content,
  });
}
