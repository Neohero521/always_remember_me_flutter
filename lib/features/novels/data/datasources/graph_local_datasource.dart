import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

class GraphLocalDatasource {
  final AppDatabase _db;
  GraphLocalDatasource(this._db);

  Future<ChapterGraphEntity?> getByChapter(String chapterId) =>
      _db.getGraphByChapter(chapterId);

  Future<void> insert(ChapterGraphEntity graph) => _db.insertGraph(ChapterGraphsCompanion(
        id: Value(graph.id),
        chapterId: Value(graph.chapterId),
        type: Value(graph.type),
        data: Value(graph.data),
        createdAt: Value(graph.createdAt),
      ));

  Future<void> update(ChapterGraphEntity graph) => _db.updateGraph(ChapterGraphsCompanion(
        id: Value(graph.id),
        chapterId: Value(graph.chapterId),
        type: Value(graph.type),
        data: Value(graph.data),
        createdAt: Value(graph.createdAt),
      ));

  Future<void> delete(String id) => _db.deleteGraph(id);
}
