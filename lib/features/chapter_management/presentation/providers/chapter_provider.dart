import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/chapter.dart';
import '../../../../services/chapter_service.dart';

/// v5.0 Chapter Management State
class ChapterState {
  final List<Chapter> chapters;
  final int currentRegexIndex;
  final String lastParsedText;
  final List<RegexMatchResult> sortedRegexList;
  final String customRegex;
  final String currentAutoRegex;
  final String? selectedChapterId;
  final bool isParsing;
  final String? error;

  const ChapterState({
    this.chapters = const [],
    this.currentRegexIndex = 0,
    this.lastParsedText = '',
    this.sortedRegexList = const [],
    this.customRegex = '',
    this.currentAutoRegex = '',
    this.selectedChapterId,
    this.isParsing = false,
    this.error,
  });

  ChapterState copyWith({
    List<Chapter>? chapters,
    int? currentRegexIndex,
    String? lastParsedText,
    List<RegexMatchResult>? sortedRegexList,
    String? customRegex,
    String? currentAutoRegex,
    String? selectedChapterId,
    bool? isParsing,
    String? error,
  }) {
    return ChapterState(
      chapters: chapters ?? this.chapters,
      currentRegexIndex: currentRegexIndex ?? this.currentRegexIndex,
      lastParsedText: lastParsedText ?? this.lastParsedText,
      sortedRegexList: sortedRegexList ?? this.sortedRegexList,
      customRegex: customRegex ?? this.customRegex,
      currentAutoRegex: currentAutoRegex ?? this.currentAutoRegex,
      selectedChapterId: selectedChapterId ?? this.selectedChapterId,
      isParsing: isParsing ?? this.isParsing,
      error: error,
    );
  }

  Chapter? getChapterById(int id) {
    try {
      return chapters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// v5.0 Chapter Management Notifier
class ChapterNotifier extends StateNotifier<ChapterState> {
  final ChapterService _chapterService;

  ChapterNotifier({required ChapterService chapterService})
      : _chapterService = chapterService,
        super(const ChapterState());

  void parseChapters(String novelText, {String? customRegex}) {
    final text = ChapterService.removeBOM(novelText);
    String useRegex = '';

    if (customRegex != null && customRegex.isNotEmpty) {
      useRegex = customRegex;
    } else {
      if (state.lastParsedText != text) {
        final sortedList = ChapterService.getSortedRegexList(text);
        state = state.copyWith(
          lastParsedText: text,
          sortedRegexList: sortedList,
          currentRegexIndex: 0,
        );
      }
      if (state.sortedRegexList.isEmpty) {
        state = state.copyWith(isParsing: false, error: '未找到章节分割点');
        return;
      }
      final nextIndex = (state.currentRegexIndex + 1) % state.sortedRegexList.length;
      state = state.copyWith(currentRegexIndex: nextIndex);
      useRegex = state.sortedRegexList[nextIndex].preset.regex;
    }

    final chapters = ChapterService.splitByRegex(text, useRegex);
    state = state.copyWith(
      chapters: chapters,
      customRegex: customRegex ?? '',
      currentAutoRegex: useRegex,
      isParsing: false,
      error: null,
    );
  }

  void parseByWordCount(String novelText, int wordCount) {
    final text = ChapterService.removeBOM(novelText);
    final chapters = ChapterService.splitByWordCount(text, wordCount);
    state = state.copyWith(
      chapters: chapters,
      lastParsedText: '',
      isParsing: false,
    );
  }

  void selectChapter(String? chapterId) {
    state = state.copyWith(selectedChapterId: chapterId);
  }

  void updateChapterContent(int chapterId, String content) {
    final idx = state.chapters.indexWhere((c) => c.id == chapterId);
    if (idx < 0) return;
    final updated = state.chapters[idx].copyWith(content: content);
    final newChapters = [...state.chapters];
    newChapters[idx] = updated;
    state = state.copyWith(chapters: newChapters);
  }

  void markChapterHasGraph(int chapterId, bool hasGraph) {
    final idx = state.chapters.indexWhere((c) => c.id == chapterId);
    if (idx < 0) return;
    final updated = state.chapters[idx].copyWith(hasGraph: hasGraph);
    final newChapters = [...state.chapters];
    newChapters[idx] = updated;
    state = state.copyWith(chapters: newChapters);
  }

  void loadFromPersist({
    required List<Chapter> chapters,
    required String lastParsedText,
    required int currentRegexIndex,
    required String customRegex,
    required String currentAutoRegex,
  }) {
    state = state.copyWith(
      chapters: chapters,
      lastParsedText: lastParsedText,
      currentRegexIndex: currentRegexIndex,
      customRegex: customRegex,
      currentAutoRegex: currentAutoRegex,
    );
  }

  void clear() {
    state = const ChapterState();
  }
}

final chapterServiceProvider = Provider<ChapterService>((ref) => ChapterService());

final chapterProvider = StateNotifierProvider<ChapterNotifier, ChapterState>((ref) {
  return ChapterNotifier(chapterService: ref.watch(chapterServiceProvider));
});
