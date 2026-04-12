import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/novel.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/chapter_knowledge_graph.dart';
import '../../domain/models/character_profile.dart';
import '../../domain/repositories/novel_repository.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../domain/repositories/graph_repository.dart';
import '../../domain/repositories/character_profile_repository.dart';
import '../../domain/usecases/novel_usecases.dart';
import '../../domain/usecases/chapter_usecases.dart';
import '../../domain/usecases/graph_usecases.dart' hide GetGraphUseCase, GenerateGraphUseCase, MergeGraphsUseCase;
import '../../domain/usecases/graph_generator.dart';
import '../../../writing/domain/repositories/ai_repository.dart';
import '../../../writing/domain/usecases/writing_usecases.dart';
import '../../../../core/di/injection.dart';

// Repositories
final novelRepositoryProvider = Provider<NovelRepository>((ref) {
  return getIt<NovelRepository>();
});

final chapterRepositoryProvider = Provider<ChapterRepository>((ref) {
  return getIt<ChapterRepository>();
});

final graphRepositoryProvider = Provider<GraphRepository>((ref) {
  return getIt<GraphRepository>();
});

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return getIt<AIRepository>();
});

// Use Cases
final getNovelsUseCaseProvider = Provider((ref) {
  return GetNovelsUseCase(ref.read(novelRepositoryProvider));
});
final createNovelUseCaseProvider = Provider((ref) {
  return CreateNovelUseCase(ref.read(novelRepositoryProvider));
});
final updateNovelUseCaseProvider = Provider((ref) {
  return UpdateNovelUseCase(ref.read(novelRepositoryProvider));
});
final deleteNovelUseCaseProvider = Provider((ref) {
  return DeleteNovelUseCase(ref.read(novelRepositoryProvider));
});
final importNovelUseCaseProvider = Provider((ref) {
  return ImportNovelUseCase(ref.read(novelRepositoryProvider));
});

final getChaptersUseCaseProvider = Provider((ref) {
  return GetChaptersUseCase(ref.read(chapterRepositoryProvider));
});
final saveChapterUseCaseProvider = Provider((ref) {
  return SaveChapterUseCase(ref.read(chapterRepositoryProvider));
});
final deleteChapterUseCaseProvider = Provider((ref) {
  return DeleteChapterUseCase(ref.read(chapterRepositoryProvider));
});
final autoChapterizeUseCaseProvider = Provider((ref) {
  return AutoChapterizeUseCase(ref.read(chapterRepositoryProvider));
});

final getGraphUseCaseProvider = Provider((ref) {
  return GetGraphUseCase(ref.read(graphRepositoryProvider));
});
final generateGraphUseCaseProvider = Provider((ref) {
  return GenerateGraphUseCase(
    ref.read(graphRepositoryProvider),
    ref.read(aiRepositoryProvider),
  );
});
final mergeGraphsUseCaseProvider = Provider((ref) {
  return MergeGraphsUseCase(ref.read(graphRepositoryProvider));
});

final generateContinuationUseCaseProvider = Provider((ref) {
  return GenerateContinuationUseCase(ref.read(aiRepositoryProvider));
});

// F3: Advanced graph generator
final advancedGraphGeneratorProvider = Provider((ref) {
  return AdvancedGraphGenerator(
    ref.read(graphRepositoryProvider),
    ref.read(aiRepositoryProvider),
  );
});

// F4: Graph merge use cases
final batchMergeGraphsUseCaseProvider = Provider((ref) {
  return BatchMergeGraphsUseCase(
    ref.read(graphRepositoryProvider),
    ref.read(aiRepositoryProvider),
  );
});

final mergeAllGraphsUseCaseProvider = Provider((ref) {
  return MergeAllGraphsUseCase(ref.read(graphRepositoryProvider));
});

// F5: Pre-Write Validation Use Case
final preWriteValidationUseCaseProvider = Provider((ref) {
  return PreWriteValidationUseCase(
    ref.read(aiRepositoryProvider),
    ref.read(graphRepositoryProvider),
  );
});

// F6: Quality Evaluation Use Case
final qualityEvaluateUseCaseProvider = Provider((ref) {
  return QualityEvaluateUseCase(ref.read(aiRepositoryProvider));
});

// F7: Character Profile & World Setting Repositories
final characterProfileRepositoryProvider = Provider<CharacterProfileRepository>((ref) {
  return getIt<CharacterProfileRepository>();
});

final worldSettingRepositoryProvider = Provider<WorldSettingRepository>((ref) {
  return getIt<WorldSettingRepository>();
});

// State Notifiers
class NovelListNotifier extends StateNotifier<AsyncValue<List<Novel>>> {
  final GetNovelsUseCase _getNovels;
  final DeleteNovelUseCase _deleteNovel;

  NovelListNotifier(this._getNovels, this._deleteNovel)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final novels = await _getNovels();
      state = AsyncValue.data(novels);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    await _deleteNovel(id);
    await load();
  }
}

final novelListProvider =
    StateNotifierProvider<NovelListNotifier, AsyncValue<List<Novel>>>((ref) {
  return NovelListNotifier(
    ref.read(getNovelsUseCaseProvider),
    ref.read(deleteNovelUseCaseProvider),
  );
});

final selectedNovelProvider = StateProvider<Novel?>((ref) => null);

class ChapterListNotifier extends StateNotifier<AsyncValue<List<Chapter>>> {
  final GetChaptersUseCase _getChapters;
  final SaveChapterUseCase _saveChapter;
  final DeleteChapterUseCase _deleteChapter;
  final AutoChapterizeUseCase _autoChapterize;
  final String novelId;

  ChapterListNotifier(
    this._getChapters,
    this._saveChapter,
    this._deleteChapter,
    this._autoChapterize,
    this.novelId,
  ) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final chapters = await _getChapters(novelId);
      state = AsyncValue.data(chapters);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Chapter?> create(Chapter chapter) async {
    final created = await _saveChapter.create(chapter);
    await load();
    return created;
  }

  Future<void> update(Chapter chapter) async {
    await _saveChapter.update(chapter);
    await load();
  }

  Future<void> delete(String id) async {
    await _deleteChapter(id);
    await load();
  }

  Future<void> autoChapterize(
    String content, {
    ChapterRegexPreset? preset,
    String? customRegex,
  }) async {
    final result = await _autoChapterize(
      content,
      novelId,
      preset: preset,
      customRegex: customRegex,
    );
    for (final chapter in result.chapters) {
      await _saveChapter.create(chapter);
    }
    await load();
  }

  /// Preview chapter split without saving
  Future<({List<Chapter> chapters, List<String> detectedTitles})> previewChapterize(
    String content, {
    ChapterRegexPreset? preset,
    String? customRegex,
  }) {
    return _autoChapterize(
      content,
      novelId,
      preset: preset,
      customRegex: customRegex,
    );
  }
}

final chapterListProvider = StateNotifierProvider.family<ChapterListNotifier,
    AsyncValue<List<Chapter>>, String>((ref, novelId) {
  return ChapterListNotifier(
    ref.read(getChaptersUseCaseProvider),
    ref.read(saveChapterUseCaseProvider),
    ref.read(deleteChapterUseCaseProvider),
    ref.read(autoChapterizeUseCaseProvider),
    novelId,
  );
});

final selectedChapterProvider = StateProvider<Chapter?>((ref) => null);
