import 'package:hive/hive.dart';
import 'knowledge_graph.dart';

part 'chapter.g.dart';

/// 单章节数据模型
/// TypeId: 10
@HiveType(typeId: 10)
class Chapter extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  bool hasGraph;

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    this.hasGraph = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'hasGraph': hasGraph,
  };

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    hasGraph: json['hasGraph'] as bool? ?? false,
  );

  Chapter copyWith({int? id, String? title, String? content, bool? hasGraph}) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      hasGraph: hasGraph ?? this.hasGraph,
    );
  }
}

/// 续写章节（基于某个基准章节续写的结果）
/// TypeId: 11
@HiveType(typeId: 11)
class ContinueChapter extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final int baseChapterId;

  ContinueChapter({
    required this.id,
    required this.title,
    required this.content,
    required this.baseChapterId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'baseChapterId': baseChapterId,
  };

  factory ContinueChapter.fromJson(Map<String, dynamic> json) => ContinueChapter(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    baseChapterId: json['baseChapterId'] as int,
  );

  ContinueChapter copyWith({int? id, String? title, String? content, int? baseChapterId}) {
    return ContinueChapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      baseChapterId: baseChapterId ?? this.baseChapterId,
    );
  }
}

/// 预设章节分割正则
class ChapterRegexPreset {
  final String name;
  final String regex;

  const ChapterRegexPreset({required this.name, required this.regex});
}

/// 预设列表（来自 Always_remember_me 扩展）
const presetChapterRegexList = [
  ChapterRegexPreset(name: '标准章节', regex: r'^\s*第\s*[0-9零一二三四五六七八九十百千]+\s*章.*$'),
  ChapterRegexPreset(name: '括号序号', regex: r'^\s*.*\（[0-9零一二三四五六七八九十百千]+\）.*$'),
  ChapterRegexPreset(name: '英文括号序号', regex: r'^\s*.*\([0-9零一二三四五六七八九十百千]+\).*$'),
  ChapterRegexPreset(name: '标准节', regex: r'^\s*第\s*[0-9零一二三四五六七八九十百千]+\s*节.*$'),
  ChapterRegexPreset(name: '卷+章', regex: r'^\s*卷\s*[0-9零一二三四五六七八九十百千]+\s*第\s*[0-9零一二三四五六七八九十百千]+\s*章.*$'),
  ChapterRegexPreset(name: '英文Chapter', regex: r'^\s*Chapter\s*[0-9]+\s*.*$'),
  ChapterRegexPreset(name: '标准话', regex: r'^\s*第\s*[0-9零一二三四五六七八九十百千]+\s*话.*$'),
  ChapterRegexPreset(name: '顿号序号', regex: r'^\s*[0-9零一二三四五六七八九十百千]+、.*$'),
  ChapterRegexPreset(name: '方括号序号', regex: r'^\s*【\s*[0-9零一二三四五六七八九十百千]+\s*】.*$'),
  ChapterRegexPreset(name: '圆点序号', regex: r'^\s*[0-9]+\.\s*.*$'),
  ChapterRegexPreset(name: '中文序号空格', regex: r'^\s*[零一二三四五六七八九十百千]+\s+.*$'),
];

/// 分割结果（含匹配数，用于自动选择最优正则）
class RegexMatchResult {
  final ChapterRegexPreset preset;
  final int count;

  RegexMatchResult({required this.preset, required this.count});
}
