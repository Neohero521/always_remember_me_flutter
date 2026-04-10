import 'chapter.dart';
import 'knowledge_graph.dart';

/// App 全局设置（对应 Always_remember_me 的 defaultSettings）
class AppSettings {
  String chapterRegex;
  String sendTemplate;
  int sendDelay;
  bool exampleSetting;
  List<Chapter> chapterList;
  Map<int, NovelKnowledgeGraph> chapterGraphMap;
  NovelKnowledgeGraph? mergedGraph;
  List<ContinueChapter> continueWriteChain;
  int continueChapterIdCounter;
  bool enableQualityCheck;
  PrecheckResult? precheckReport;
  String selectedBaseChapterId;
  String writeContentPreview;
  bool graphValidateResultShow;
  bool qualityResultShow;
  String precheckStatus;
  String precheckReportText;

  // API 配置
  String apiBaseUrl;
  String apiKey;
  String selectedModel;
  int writeWordCount;
  bool enableAutoParentPreset;

  AppSettings({
    this.chapterRegex = r'^\s*第\s*[0-9零一二三四五六七八九十百千]+\s*章.*$',
    this.sendTemplate = '/sendas name={{char}} {{pipe}}',
    this.sendDelay = 100,
    this.exampleSetting = false,
    this.chapterList = const [],
    this.chapterGraphMap = const {},
    this.mergedGraph,
    this.continueWriteChain = const [],
    this.continueChapterIdCounter = 1,
    this.enableQualityCheck = true,
    this.precheckReport,
    this.selectedBaseChapterId = '',
    this.writeContentPreview = '',
    this.graphValidateResultShow = false,
    this.qualityResultShow = false,
    this.precheckStatus = '未执行',
    this.precheckReportText = '',
    this.apiBaseUrl = '',
    this.apiKey = '',
    this.selectedModel = '',
    this.writeWordCount = 2000,
    this.enableAutoParentPreset = true,
  });

  Map<String, dynamic> toJson() => {
    'chapterRegex': chapterRegex,
    'sendTemplate': sendTemplate,
    'sendDelay': sendDelay,
    'exampleSetting': exampleSetting,
    'chapterList': chapterList.map((e) => e.toJson()).toList(),
    // chapterGraphMap 需要特殊处理
    'continueWriteChain': continueWriteChain.map((e) => e.toJson()).toList(),
    'continueChapterIdCounter': continueChapterIdCounter,
    'enableQualityCheck': enableQualityCheck,
    'selectedBaseChapterId': selectedBaseChapterId,
    'writeContentPreview': writeContentPreview,
    'graphValidateResultShow': graphValidateResultShow,
    'qualityResultShow': qualityResultShow,
    'precheckStatus': precheckStatus,
    'precheckReportText': precheckReportText,
    'apiBaseUrl': apiBaseUrl,
    'apiKey': apiKey,
    'selectedModel': selectedModel,
    'writeWordCount': writeWordCount,
    'enableAutoParentPreset': enableAutoParentPreset,
  };
}
