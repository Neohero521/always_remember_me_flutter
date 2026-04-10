import '../models/chapter.dart';

/// 章节分割服务
class ChapterService {
  /// 移除 BOM 头
  static String removeBOM(String text) {
    if (text.isEmpty) return text;
    if (text.codeUnitAt(0) == 0xFEFF || text.codeUnitAt(0) == 0xFFFE) {
      return text.substring(1);
    }
    return text;
  }

  /// 统一换行符
  static String normalizeLineEndings(String text) {
    return text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }

  /// 按正则拆分小说章节
  static List<Chapter> splitByRegex(String novelText, String regexSource) {
    try {
      final cleanText = normalizeLineEndings(removeBOM(novelText));
      if (cleanText.trim().isEmpty) return [];

      final chapterRegex = RegExp(regexSource, multiLine: true);
      final matches = chapterRegex.allMatches(cleanText).toList();

      final chapters = <Chapter>[];
      if (matches.isEmpty) {
        // 没匹配到任何章节标题，当作全文处理
        return [Chapter(id: 0, title: '全文', content: cleanText.trim())];
      }

      for (int i = 0; i < matches.length; i++) {
        final start = matches[i].end;
        final end = i < matches.length - 1 ? matches[i + 1].start : cleanText.length;
        final title = matches[i].group(0)?.trim() ?? '';
        final content = cleanText.substring(start, end).trim();
        if (content.isNotEmpty) {
          chapters.add(Chapter(id: i, title: title, content: content));
        }
      }

      return chapters;
    } catch (e) {
      return [];
    }
  }

  /// 按字数拆分章节（每章指定字数）
  static List<Chapter> splitByWordCount(String novelText, int wordCount) {
    try {
      final cleanText = normalizeLineEndings(removeBOM(novelText)).trim();
      if (cleanText.isEmpty) return [];

      final chapters = <Chapter>[];
      int currentIndex = 0;
      int chapterId = 0;

      while (currentIndex < cleanText.length) {
        int endIndex = currentIndex + wordCount;

        // 非末尾章节自动找最近换行符，避免拆分句子
        if (endIndex < cleanText.length) {
          final nextLineIndex = cleanText.indexOf('\n', endIndex);
          if (nextLineIndex != -1 && nextLineIndex - endIndex < 200) {
            endIndex = nextLineIndex + 1;
          }
        }

        final content = cleanText.substring(currentIndex, endIndex).trim();
        if (content.isNotEmpty) {
          chapters.add(Chapter(
            id: chapterId,
            title: '第${chapterId + 1}章（字数拆分）',
            content: content,
          ));
          chapterId++;
        }
        currentIndex = endIndex;
      }

      return chapters;
    } catch (e) {
      return [];
    }
  }

  /// 自动匹配最优正则（按章节数从多到少排序）
  static List<RegexMatchResult> getSortedRegexList(String novelText) {
    final cleanText = normalizeLineEndings(removeBOM(novelText));
    final results = <RegexMatchResult>[];

    for (final preset in presetChapterRegexList) {
      try {
        final regex = RegExp(preset.regex, multiLine: true);
        final matches = regex.allMatches(cleanText).toList();
        results.add(RegexMatchResult(preset: preset, count: matches.length));
      } catch (_) {
        results.add(RegexMatchResult(preset: preset, count: 0));
      }
    }

    // 按章节数降序排序，0章节的排最后
    results.sort((a, b) => b.count - a.count);
    return results;
  }
}
