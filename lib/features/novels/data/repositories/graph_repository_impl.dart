import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/chapter_graph.dart';
import '../../domain/models/chapter_knowledge_graph.dart';
import '../../domain/repositories/graph_repository.dart';
import '../datasources/graph_local_datasource.dart';

class GraphRepositoryImpl implements GraphRepository {
  final AppDatabase _db;
  final GraphLocalDatasource _datasource;
  final Uuid _uuid = const Uuid();

  GraphRepositoryImpl(this._db, this._datasource);

  @override
  Future<ChapterGraph?> getGraphByChapter(String chapterId) async {
    final entity = await _datasource.getByChapter(chapterId);
    return entity != null ? _entityToModel(entity) : null;
  }

  @override
  Future<ChapterGraph> createGraph(ChapterGraph graph) async {
    await _datasource.insert(_modelToEntity(graph));
    return graph;
  }

  @override
  Future<void> updateGraph(ChapterGraph graph) async {
    await _datasource.update(_modelToEntity(graph));
  }

  @override
  Future<void> deleteGraph(String id) => _datasource.delete(id);

  @override
  Future<ChapterGraph> generateGraph(
    String chapterId,
    String content,
    GraphType type,
  ) async {
    throw UnimplementedError('Use GenerateGraphUseCase instead');
  }

  @override
  Future<GraphData> mergeGraphs(List<ChapterGraph> graphs) async {
    if (graphs.isEmpty) return const GraphData();

    final allNodes = <String, GraphNode>{};
    final allEdges = <String, GraphEdge>{};

    for (final graph in graphs) {
      final data = GraphData.fromJson(jsonDecode(graph.data));

      for (final node in data.nodes) {
        if (!allNodes.containsKey(node.id)) {
          allNodes[node.id] = node;
        } else {
          final existing = allNodes[node.id]!;
          final mergedProps = Map<String, dynamic>.from(existing.properties ?? {});
          if (node.properties != null && existing.properties != null) {
            for (final entry in node.properties!.entries) {
              if (mergedProps.containsKey(entry.key)) {
                if (entry.value is int) {
                  mergedProps[entry.key] = (mergedProps[entry.key] as int) + (entry.value as int);
                } else if (entry.value is double) {
                  mergedProps[entry.key] = (mergedProps[entry.key] as double) + (entry.value as double);
                }
              } else {
                mergedProps[entry.key] = entry.value;
              }
            }
          }
          allNodes[node.id] = GraphNode(
            id: existing.id,
            label: existing.label,
            type: existing.type,
            properties: mergedProps,
          );
        }
      }

      for (final edge in data.edges) {
        final edgeId = '${edge.from}-${edge.to}';
        if (!allEdges.containsKey(edgeId)) {
          allEdges[edgeId] = edge;
        } else {
          final existing = allEdges[edgeId]!;
          allEdges[edgeId] = GraphEdge(
            from: existing.from,
            to: existing.to,
            label: existing.label,
            weight: existing.weight + edge.weight,
          );
        }
      }
    }

    return GraphData(
      nodes: allNodes.values.toList(),
      edges: allEdges.values.toList(),
    );
  }

  // ─── F3: Advanced Graph ───────────────────────────────────────

  @override
  Future<ChapterKnowledgeGraph?> getAdvancedGraph(String chapterId) async {
    final entity = await _db.getAdvancedGraphByChapter(chapterId);
    if (entity == null) return null;
    return ChapterKnowledgeGraph.fromJson(jsonDecode(entity.graphJson));
  }

  @override
  Future<void> saveAdvancedGraph(ChapterKnowledgeGraph graph) async {
    await _db.insertOrUpdateAdvancedGraph(AdvancedGraphsCompanion(
      id: Value(graph.id),
      chapterId: Value(graph.chapterId),
      graphJson: Value(jsonEncode(graph.toJson())),
      createdAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> deleteAdvancedGraph(String chapterId) async {
    await _db.deleteAdvancedGraphByChapter(chapterId);
  }

  @override
  Future<List<ChapterKnowledgeGraph>> getAdvancedGraphsForNovel(
    String novelId,
  ) async {
    final chapters = await _db.getChaptersByNovel(novelId);
    final graphs = <ChapterKnowledgeGraph>[];
    for (final chapter in chapters) {
      final entity = await _db.getAdvancedGraphByChapter(chapter.id);
      if (entity != null) {
        graphs.add(ChapterKnowledgeGraph.fromJson(jsonDecode(entity.graphJson)));
      }
    }
    return graphs;
  }

  // ─── F4: Graph Merge ─────────────────────────────────────────

  @override
  Future<ChapterKnowledgeGraph> batchMerge(
    List<ChapterKnowledgeGraph> graphs,
    int batchSize,
  ) async {
    // Simple merge: deduplicate characters and merge all world settings
    // In a full implementation, this would call the AI for smarter merging
    if (graphs.isEmpty) {
      throw Exception('batchMerge requires non-empty graphs');
    }

    final allCharacters = <String, CharacterInfo>{};
    final allForeshadows = <String>{};
    final allWorldSettings = <String>{};
    final allRelations = <EntityRelation>[];
    final allGlobalChanges = <String>[];

    for (final graph in graphs) {
      for (final char in graph.characters) {
        allCharacters[char.uniqueId] = char;
      }
      for (final rel in graph.relations) {
        if (!allRelations.any((r) =>
            r.entityA == rel.entityA &&
            r.entityB == rel.entityB &&
            r.relation == rel.relation)) {
          allRelations.add(rel);
        }
      }
      allForeshadows.addAll(graph.worldSetting.hiddenForeshadows);
      allGlobalChanges.addAll(graph.changeInfo.globalChanges);
    }

    final merged = ChapterKnowledgeGraph(
      id: _uuid.v4(),
      chapterId: 'batch-${graphs.map((g) => g.chapterId).join('-')}',
      version: kKnowledgeGraphVersion,
      basicInfo: graphs.first.basicInfo,
      characters: allCharacters.values.toList(),
      worldSetting: WorldSetting(
        hiddenForeshadows: allForeshadows.toList(),
      ),
      mainPlot: graphs.first.mainPlot,
      writingStyle: graphs.first.writingStyle,
      relations: allRelations,
      changeInfo: GraphChange(globalChanges: allGlobalChanges),
      reverseAnalysis: graphs.first.reverseAnalysis,
    );

    return merged;
  }

  @override
  Future<MergedKnowledgeGraph> mergeAll(
    List<ChapterKnowledgeGraph> batchedGraphs,
    String novelId,
  ) async {
    // Build global merged graph from all batch results
    final allCharacters = <String, CharacterInfo>{};
    final allForeshadows = <String>[];
    final allEras = <String>{};
    final allGeography = <String>{};
    final allPowerSystems = <String>{};
    final allRelations = <EntityRelation>[];
    final reverseDeps = <ReverseDependency>[];

    for (final batch in batchedGraphs) {
      for (final char in batch.characters) {
        allCharacters[char.uniqueId] = char;
      }
      allForeshadows.addAll(batch.worldSetting.hiddenForeshadows);
      if (batch.worldSetting.eraBackground.isNotEmpty) {
        allEras.add(batch.worldSetting.eraBackground);
      }
      allGeography.addAll(batch.worldSetting.geographyRegions);
      if (batch.worldSetting.powerSystem.isNotEmpty) {
        allPowerSystems.add(batch.worldSetting.powerSystem);
      }
      for (final rel in batch.relations) {
        if (!allRelations.any((r) =>
            r.entityA == rel.entityA &&
            r.entityB == rel.entityB &&
            r.relation == rel.relation)) {
          allRelations.add(rel);
        }
      }
      reverseDeps.add(ReverseDependency(
        chapterId: batch.chapterId,
        dependsOn: batch.changeInfo.prerequisiteChapterDependencies,
        affectsChapters: batch.changeInfo.impactOnFutureChapters,
      ));
    }

    return MergedKnowledgeGraph(
      id: _uuid.v4(),
      novelId: novelId,
      version: kKnowledgeGraphVersion,
      globalBasicInfo: GlobalBasicInfo(
        novelName: '',
        totalChapterCount: batchedGraphs.length,
        version: kKnowledgeGraphVersion,
      ),
      characterPool: allCharacters.values.toList(),
      worldSettingPool: WorldSettingPool(
        allEras: allEras.toList(),
        allGeography: allGeography.toList(),
        allPowerSystems: allPowerSystems.toList(),
        allForeshadows: allForeshadows,
      ),
      fullPlotTimeline: const FullPlotTimeline(nodes: [], edges: []),
      writingStyleGuide: WritingStyleGuide(
        dominantStyle: batchedGraphs.isNotEmpty
            ? batchedGraphs.first.writingStyle
            : const WritingStyle(),
      ),
      entityNetwork: allRelations,
      reverseDepMap: reverseDeps,
      reverseAnalysis: batchedGraphs.isNotEmpty
          ? batchedGraphs.first.reverseAnalysis
          : const ReverseAnalysis(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // ─── F8: Graph Export / Import ───────────────────────────────

  @override
  Future<String> exportAllGraphs(String novelId) async {
    final graphs = await getAdvancedGraphsForNovel(novelId);
    final merged = graphs.isNotEmpty ? await mergeAll(graphs, novelId) : null;

    final exportData = {
      'version': kKnowledgeGraphVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'novelId': novelId,
      'chapterGraphs': graphs.map((g) => g.toJson()).toList(),
      if (merged != null) 'mergedGraph': merged.toJson(),
    };

    return jsonEncode(exportData);
  }

  @override
  Future<void> importGraphs(String novelId, String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final chapterGraphsJson = data['chapterGraphs'] as List<dynamic>?;
    final mergedGraphJson = data['mergedGraph'] as Map<String, dynamic>?;

    if (chapterGraphsJson != null) {
      for (final graphJson in chapterGraphsJson) {
        final graph = ChapterKnowledgeGraph.fromJson(graphJson as Map<String, dynamic>);
        // Create a new graph with a fresh ID but same chapterId for linking
        final importedGraph = graph.copyWith(id: _uuid.v4());
        await saveAdvancedGraph(importedGraph);
      }
    }

    // Store merged graph if present (currently just save it - no separate merged table)
    // The merged data can be re-computed from imported chapter graphs
  }

  // ─── Helpers ─────────────────────────────────────────────────

  ChapterGraphEntity _modelToEntity(ChapterGraph model) {
    return ChapterGraphEntity(
      id: model.id,
      chapterId: model.chapterId,
      type: model.type,
      data: model.data,
      createdAt: model.createdAt,
    );
  }

  ChapterGraph _entityToModel(ChapterGraphEntity entity) {
    return ChapterGraph(
      id: entity.id,
      chapterId: entity.chapterId,
      type: entity.type,
      data: entity.data,
      createdAt: entity.createdAt,
    );
  }
}
