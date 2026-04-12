import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/chapter_graph.dart';
import '../models/chapter_knowledge_graph.dart';
import '../repositories/graph_repository.dart';
import '../../../writing/domain/repositories/ai_repository.dart';

class GetGraphUseCase {
  final GraphRepository _repository;
  GetGraphUseCase(this._repository);

  Future<ChapterGraph?> call(String chapterId) =>
      _repository.getGraphByChapter(chapterId);
}

class GenerateGraphUseCase {
  final GraphRepository _repository;
  final AIRepository _aiRepository;
  final Uuid _uuid = const Uuid();

  GenerateGraphUseCase(this._repository, this._aiRepository);

  Future<ChapterGraph> call(String chapterId, String content, GraphType type) async {
    // Analyze characters first
    final characters = await _aiRepository.analyzeCharacters(content);

    GraphData graphData;

    switch (type) {
      case GraphType.characterRelationship:
        graphData = await _generateCharacterRelationship(content, characters);
        break;
      case GraphType.plotTimeline:
        graphData = _generatePlotTimeline(content);
        break;
      case GraphType.locationMap:
        graphData = _generateLocationMap(content);
        break;
      case GraphType.emotionAnalysis:
        graphData = _generateEmotionAnalysis(content);
        break;
    }

    final graph = ChapterGraph(
      id: _uuid.v4(),
      chapterId: chapterId,
      type: type.name,
      data: jsonEncode(graphData.toJson()),
      createdAt: DateTime.now(),
    );

    return _repository.createGraph(graph);
  }

  Future<GraphData> _generateCharacterRelationship(
    String content,
    List<CharacterAnalysis> characters,
  ) async {
    final nodes = characters.map((c) => GraphNode(
          id: c.id,
          label: c.name,
          type: 'character',
          properties: {
            'appearance_count': c.appearanceCount,
            'importance_score': c.importanceScore,
          },
        )).toList();

    // Generate edges based on co-occurrence (simplified)
    final edges = <GraphEdge>[];
    for (var i = 0; i < characters.length - 1; i++) {
      for (var j = i + 1; j < characters.length; j++) {
        edges.add(GraphEdge(
          from: characters[i].id,
          to: characters[j].id,
          label: '同章节出现',
          weight: 0.5,
        ));
      }
    }

    return GraphData(nodes: nodes, edges: edges);
  }

  GraphData _generatePlotTimeline(String content) {
    // Simplified timeline based on time markers
    final nodes = <GraphNode>[];
    final edges = <GraphEdge>[];

    // Find time markers
    final timePatterns = [
      RegExp(r'(?:昨天|今天|明天|昨夜|今晨|翌日)'),
      RegExp(r'第[一二三四五六七八九十百千]+天'),
      RegExp(r'\d+年\d+月\d+日'),
    ];

    var timeId = 0;
    for (final pattern in timePatterns) {
      for (final match in pattern.allMatches(content)) {
        nodes.add(GraphNode(
          id: 'time_$timeId',
          label: match.group(0) ?? '',
          type: 'event',
        ));
        if (timeId > 0) {
          edges.add(GraphEdge(
            from: 'time_${timeId - 1}',
            to: 'time_$timeId',
            label: '时间推进',
          ));
        }
        timeId++;
      }
    }

    return GraphData(nodes: nodes, edges: edges);
  }

  GraphData _generateLocationMap(String content) {
    // Simplified location detection
    final nodes = <GraphNode>[];
    final locationNames = <String>{};
    final locationPattern = RegExp(r'[\u4e00-\u9fa5]+(?:城|镇|村|宫|殿|府|山|河|湖|海|岛|国)');

    for (final match in locationPattern.allMatches(content)) {
      locationNames.add(match.group(0) ?? '');
    }

    var id = 0;
    for (final loc in locationNames) {
      nodes.add(GraphNode(
        id: 'loc_$id',
        label: loc,
        type: 'location',
      ));
      id++;
    }

    return GraphData(nodes: nodes, edges: []);
  }

  GraphData _generateEmotionAnalysis(String content) {
    // Simplified emotion analysis
    final emotions = {
      '喜': RegExp(r'(?:笑|喜|高兴|开心|快乐|欢|愉悦)'),
      '怒': RegExp(r'(?:怒|气愤|愤怒|恼火|生气)'),
      '哀': RegExp(r'(?:哭|悲伤|难过|哀|痛苦|伤心)'),
      '惧': RegExp(r'(?:怕|恐惧|害怕|惊|恐怖)'),
    };

    final nodes = <GraphNode>[];
    var id = 0;

    for (final entry in emotions.entries) {
      final count = entry.value.allMatches(content).length;
      if (count > 0) {
        nodes.add(GraphNode(
          id: 'emotion_$id',
          label: '${entry.key}: $count',
          type: 'emotion',
          properties: {'count': count},
        ));
        id++;
      }
    }

    return GraphData(nodes: nodes, edges: []);
  }
}

class MergeGraphsUseCase {
  final GraphRepository _repository;
  MergeGraphsUseCase(this._repository);

  Future<GraphData> call(List<ChapterGraph> graphs) =>
      _repository.mergeGraphs(graphs);
}

// ═══════════════════════════════════════════════════════════════
//   Advanced Knowledge Graph Generator
// ═══════════════════════════════════════════════════════════════

class AdvancedGraphGenerator {
  final GraphRepository _repository;
  final AIRepository _aiRepository;
  final Uuid _uuid = const Uuid();

  AdvancedGraphGenerator(this._repository, this._aiRepository);

  /// Generate a full ChapterKnowledgeGraph for a single chapter using AI.
  Future<ChapterKnowledgeGraph> generateSingleChapterGraph({
    required String chapterId,
    required String chapterTitle,
    required String content,
    required int chapterNumber,
    int? totalWordCount,
  }) async {
    final prompt = _buildGraphPrompt(chapterTitle, content, chapterNumber);

    final jsonStr = await _aiRepository.generateStructuredText(
      prompt: prompt,
      schema: _graphJsonSchema,
    );

    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final graph = ChapterKnowledgeGraph.fromJson(json).copyWith(
      id: _uuid.v4(),
      chapterId: chapterId,
    );

    await _repository.saveAdvancedGraph(graph);
    return graph;
  }

  String _buildGraphPrompt(String chapterTitle, String content, int chapterNumber) {
    final excerpt = content.length > 2000 ? content.substring(0, 2000) : content;
    return '你是专业的网文分析助手。请分析以下章节，输出完整的知识图谱JSON。\n\n'
        '## 章节标题\n$chapterTitle\n\n'
        '## 章节内容（摘要，前2000字）\n$excerpt\n\n'
        '## 分析要求\n'
        '请严格输出8个模块的完整JSON：\n'
        '1. 基础章节信息：章节号、版本号、节点ID、字数、时间线节点\n'
        '2. 人物信息：每个人物的ID/姓名/别名/性格/背景/行为动机/关系变更/弧光\n'
        '3. 世界观设定：时代/地理/力量体系/社会结构/物品生物/伏笔\n'
        '4. 核心剧情线：主线描述/关键事件/支线/冲突进展/未回收伏笔\n'
        '5. 文风特点：叙事视角/语言风格/对话特点/修辞/节奏\n'
        '6. 实体关系网络：[人物A, 关系, 人物B] 三元组列表\n'
        '7. 变更与依赖：对全局变更/前置依赖/对后续影响/冲突预警\n'
        '8. 逆向分析洞察：AI深度分析\n\n'
        '## 输出格式\n严格JSON，禁止额外文字。';
  }

  static const Map<String, dynamic> _graphJsonSchema = {
    'name': 'ChapterKnowledgeGraph',
    'strict': true,
    'required': [
      'id', 'chapterId', 'version', 'basicInfo', 'characters',
      'worldSetting', 'mainPlot', 'subplots', 'writingStyle',
      'relations', 'changeInfo', 'reverseAnalysis',
    ],
    'properties': {
      'id': {'type': 'string'},
      'chapterId': {'type': 'string'},
      'version': {'type': 'string'},
      'basicInfo': {
        'required': [
          'chapterNumber', 'chapterVersion', 'chapterNodeId',
          'chapterWordCount', 'narrativeTimelineNodes',
        ],
        'properties': {
          'chapterNumber': {'type': 'string'},
          'chapterVersion': {'type': 'string'},
          'chapterNodeId': {'type': 'string'},
          'chapterWordCount': {'type': 'integer'},
          'narrativeTimelineNodes': {'type': 'array', 'items': {'type': 'string'}},
          'summary': {'type': 'string'},
          'keyEvents': {'type': 'string'},
        },
      },
      'characters': {
        'type': 'array',
        'items': {
          'required': [
            'uniqueId', 'name', 'alias', 'personalityTraits', 'identityBackground',
            'coreBehaviorMotive', 'relationshipChanges', 'characterArcChange',
          ],
          'properties': {
            'uniqueId': {'type': 'string'},
            'name': {'type': 'string'},
            'alias': {'type': 'string'},
            'personalityTraits': {'type': 'string'},
            'identityBackground': {'type': 'string'},
            'coreBehaviorMotive': {'type': 'string'},
            'relationshipChanges': {'type': 'string'},
            'characterArcChange': {'type': 'string'},
            'dialogueStyles': {'type': 'array', 'items': {'type': 'string'}},
            'appearanceCount': {'type': 'integer'},
          },
        },
      },
      'worldSetting': {
        'properties': {
          'eraBackground': {'type': 'string'},
          'geographyRegions': {'type': 'array', 'items': {'type': 'string'}},
          'powerSystem': {'type': 'string'},
          'socialStructure': {'type': 'string'},
          'itemsAndCreatures': {'type': 'array', 'items': {'type': 'string'}},
          'hiddenForeshadows': {'type': 'array', 'items': {'type': 'string'}},
        },
      },
      'mainPlot': {
        'required': [
          'id', 'description', 'keyEvents', 'type',
          'conflictProgress', 'unresolvedForeshadows',
        ],
        'properties': {
          'id': {'type': 'string'},
          'description': {'type': 'string'},
          'keyEvents': {'type': 'array', 'items': {'type': 'string'}},
          'type': {'type': 'string'},
          'conflictProgress': {'type': 'string'},
          'unresolvedForeshadows': {'type': 'array', 'items': {'type': 'string'}},
        },
      },
      'subplots': {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {
            'id': {'type': 'string'},
            'description': {'type': 'string'},
            'keyEvents': {'type': 'array', 'items': {'type': 'string'}},
            'type': {'type': 'string'},
            'conflictProgress': {'type': 'string'},
            'unresolvedForeshadows': {'type': 'array', 'items': {'type': 'string'}},
          },
        },
      },
      'writingStyle': {
        'required': [
          'narrativePerspective', 'languageStyle', 'dialogueFeatures',
          'rhetoricalDevices', 'pacingRhythm', 'emotionalTone',
        ],
        'properties': {
          'narrativePerspective': {'type': 'string'},
          'languageStyle': {'type': 'string'},
          'dialogueFeatures': {'type': 'array', 'items': {'type': 'string'}},
          'rhetoricalDevices': {'type': 'array', 'items': {'type': 'string'}},
          'pacingRhythm': {'type': 'string'},
          'emotionalTone': {'type': 'string'},
        },
      },
      'relations': {
        'type': 'array',
        'items': {
          'required': ['entityA', 'relation', 'entityB'],
          'properties': {
            'entityA': {'type': 'string'},
            'relation': {'type': 'string'},
            'entityB': {'type': 'string'},
            'properties': {'type': 'object'},
          },
        },
      },
      'changeInfo': {
        'required': [
          'globalChanges', 'prerequisiteChapterDependencies',
          'impactOnFutureChapters', 'conflictWarnings',
        ],
        'properties': {
          'globalChanges': {'type': 'array', 'items': {'type': 'string'}},
          'prerequisiteChapterDependencies': {'type': 'array', 'items': {'type': 'string'}},
          'impactOnFutureChapters': {'type': 'array', 'items': {'type': 'string'}},
          'conflictWarnings': {'type': 'array', 'items': {'type': 'string'}},
        },
      },
      'reverseAnalysis': {
        'required': ['aiInsights', 'callbackForeshadows', 'qualityAssessment', 'narrativeGaps'],
        'properties': {
          'aiInsights': {'type': 'string'},
          'callbackForeshadows': {'type': 'array', 'items': {'type': 'string'}},
          'qualityAssessment': {'type': 'object'},
          'narrativeGaps': {'type': 'object'},
        },
      },
    },
  };
}
