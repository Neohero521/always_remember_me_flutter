import 'package:uuid/uuid.dart';
import '../models/chapter.dart';
import '../repositories/chapter_repository.dart';

// ─── Chapter Regex Presets ───────────────────────────────────────────────

/// 11 preset chapter detection patterns
enum ChapterRegexPreset {
  standard('标准章节', r'^\s*第\s*[0-9零一二三四五六七八九十百千〇]+\s*[章节回部]'),
  parens('括号序号', r'^\s*.*（[0-9零一二三四五六七八九十百千〇]+）'),
  englishParens('英文括号', r'^\s*.*\([0-9零一二三四五六七八九十百千〇]+\)'),
  section('标准节', r'^\s*第\s*[0-9零一二三四五六七八九十百千〇]+\s*节'),
  volumeChapter('卷+章', r'^\s*卷\s*[0-9零一二三四五六七八九十百千〇]+\s*第\s*[0-9零一二三四五六七八九十百千〇]+\s*章'),
  englishChapter('English Chapter', r'^\s*Chapter\s*[0-9]+\s*'),
  dialogue('标准话', r'^\s*第\s*[0-9零一二三四五六七八九十百千〇]+\s*话'),
  commaNum('顿号序号', r'^\s*[0-9零一二三四五六七八九十百千〇]+、'),
  bracketNum('方括号', r'^\s*【\s*[0-9零一二三四五六七八九十百千〇]+\s*】'),
  dotNum('圆点序号', r'^\s*[0-9]+\.\s*'),
  chineseNumSpace('中文序号空格', r'^\s*[零一二三四五六七八九十百千〇]+\s+.*'),
  ;

  final String label;
  final String pattern;
  const ChapterRegexPreset(this.label, this.pattern);
}

class GetChaptersUseCase {
  final ChapterRepository _repository;
  GetChaptersUseCase(this._repository);

  Future<List<Chapter>> call(String novelId) =>
      _repository.getChaptersByNovel(novelId);

  Stream<List<Chapter>> watch(String novelId) =>
      _repository.watchChaptersByNovel(novelId);

  Future<Chapter?> getById(String id) => _repository.getChapterById(id);
}

class SaveChapterUseCase {
  final ChapterRepository _repository;
  SaveChapterUseCase(this._repository);

  Future<Chapter> create(Chapter chapter) => _repository.createChapter(chapter);

  Future<void> update(Chapter chapter) => _repository.updateChapter(chapter);
}

class DeleteChapterUseCase {
  final ChapterRepository _repository;
  DeleteChapterUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteChapter(id);
}

class AutoChapterizeUseCase {
  final ChapterRepository _repository;
  final Uuid _uuid = const Uuid();

  AutoChapterizeUseCase(this._repository);

  /// Auto-split content into chapters using the given preset or custom regex.
  /// Returns (chapters, detectedTitles) where detectedTitles are matched chapter
  /// titles for UI preview.
  Future<({List<Chapter> chapters, List<String> detectedTitles})> call(
    String content,
    String novelId, {
    ChapterRegexPreset? preset,
    String? customRegex,
  }) async {
    final chapters = <Chapter>[];
    final detectedTitles = <String>[];
    int currentChapterNumber = 1;

    // Determine the regex pattern
    String patternStr;
    if (customRegex != null && customRegex.isNotEmpty) {
      patternStr = customRegex;
    } else if (preset != null) {
      patternStr = preset.pattern;
    } else {
      // Default: standard preset
      patternStr = ChapterRegexPreset.standard.pattern;
    }

    final chapterPattern = RegExp(patternStr, multiLine: true);
    final matches = chapterPattern.allMatches(content).toList();

    if (matches.isNotEmpty) {
      int start = 0;
      for (final match in matches) {
        final chapterTitle = content.substring(match.start, match.end).trim();
        final end = match.start;

        if (start < end) {
          final chapterContent = content.substring(start, end).trim();
          if (chapterContent.isNotEmpty) {
            chapters.add(Chapter(
              id: _uuid.v4(),
              novelId: novelId,
              number: currentChapterNumber,
              title: chapterTitle,
              content: chapterContent,
              wordCount: chapterContent.length,
              createdAt: DateTime.now(),
            ));
            detectedTitles.add(chapterTitle);
            currentChapterNumber++;
          }
        }
        start = match.end;
      }

      // Handle last chapter
      final lastContent = content.substring(start).trim();
      if (lastContent.isNotEmpty) {
        chapters.add(Chapter(
          id: _uuid.v4(),
          novelId: novelId,
          number: currentChapterNumber,
          title: '尾声',
          content: lastContent,
          wordCount: lastContent.length,
          createdAt: DateTime.now(),
        ));
      }
    } else {
      // No chapter markers found — split by fixed-size blocks
      const blockSize = 5000; // ~2500 chars per block as rough chapter
      final paragraphs = content.split(RegExp(r'\n\n+'));
      final buffer = StringBuffer();

      for (final para in paragraphs) {
        buffer.write(para.trim());
        buffer.write('\n\n');
        if (buffer.length >= blockSize) {
          final text = buffer.toString().trim();
          chapters.add(Chapter(
            id: _uuid.v4(),
            novelId: novelId,
            number: currentChapterNumber,
            title: '第$currentChapterNumber章',
            content: text,
            wordCount: text.length,
            createdAt: DateTime.now(),
          ));
          detectedTitles.add('第$currentChapterNumber章');
          currentChapterNumber++;
          buffer.clear();
        }
      }

      // Handle remaining content
      if (buffer.isNotEmpty) {
        final text = buffer.toString().trim();
        chapters.add(Chapter(
          id: _uuid.v4(),
          novelId: novelId,
          number: currentChapterNumber,
          title: '第$currentChapterNumber章',
          content: text,
          wordCount: text.length,
          createdAt: DateTime.now(),
        ));
        detectedTitles.add('第$currentChapterNumber章');
      }
    }

    return (chapters: chapters, detectedTitles: detectedTitles);
  }
}
