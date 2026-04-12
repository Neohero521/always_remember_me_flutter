import '../models/chapter_graph.dart';
import '../models/chapter_knowledge_graph.dart';

abstract class GraphRepository {
  Future<ChapterGraph?> getGraphByChapter(String chapterId);
  Future<ChapterGraph> createGraph(ChapterGraph graph);
  Future<void> updateGraph(ChapterGraph graph);
  Future<void> deleteGraph(String id);
  Future<ChapterGraph> generateGraph(String chapterId, String content, GraphType type);
  Future<GraphData> mergeGraphs(List<ChapterGraph> graphs);

  // Advanced graph (F3)
  Future<ChapterKnowledgeGraph?> getAdvancedGraph(String chapterId);
  Future<void> saveAdvancedGraph(ChapterKnowledgeGraph graph);
  Future<void> deleteAdvancedGraph(String chapterId);
  Future<List<ChapterKnowledgeGraph>> getAdvancedGraphsForNovel(String novelId);

  // Merge (F4)
  Future<ChapterKnowledgeGraph> batchMerge(
    List<ChapterKnowledgeGraph> graphs,
    int batchSize,
  );
  Future<MergedKnowledgeGraph> mergeAll(
    List<ChapterKnowledgeGraph> batchedGraphs,
    String novelId,
  );

  // F8: Graph Import/Export
  Future<String> exportAllGraphs(String novelId);
  Future<void> importGraphs(String novelId, String json);
}
