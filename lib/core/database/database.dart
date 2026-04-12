import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ─── Tables ──────────────────────────────────────────────────

@DataClassName('NovelEntity')
class Novels extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  TextColumn get cover => text().nullable()();
  TextColumn get introduction => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChapterEntity')
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text()();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get graphId => text().nullable()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChapterGraphEntity')
class ChapterGraphs extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get type => text().withDefault(const Constant('characterRelationship'))();
  TextColumn get data => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// F3: Advanced Knowledge Graphs table
@DataClassName('AdvancedGraphEntity')
class AdvancedGraphs extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get graphJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// F7: Character Profiles table
@DataClassName('CharacterProfileEntity')
class CharacterProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text()();
  TextColumn get name => text()();
  TextColumn get alias => text().withDefault(const Constant(''))();
  TextColumn get personality => text().withDefault(const Constant(''))();
  TextColumn get redLines => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get backstories => text().withDefault(const Constant('[]'))(); // JSON array

  @override
  Set<Column> get primaryKey => {id};
}

// F7: Novel World Settings table
@DataClassName('NovelWorldSettingEntity')
class NovelWorldSettings extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text()();
  TextColumn get era => text().withDefault(const Constant(''))();
  TextColumn get geography => text().withDefault(const Constant(''))();
  TextColumn get powerSystem => text().withDefault(const Constant(''))();
  TextColumn get society => text().withDefault(const Constant(''))();
  TextColumn get forbiddenRules => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get foreshadows => text().withDefault(const Constant('[]'))(); // JSON array

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Database ─────────────────────────────────────────────────

@DriftDatabase(
  tables: [Novels, Chapters, ChapterGraphs, AdvancedGraphs, CharacterProfiles, NovelWorldSettings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2 && to >= 2) {
        await m.createTable(advancedGraphs);
      }
      if (from < 3 && to >= 3) {
        await m.createTable(characterProfiles);
        await m.createTable(novelWorldSettings);
      }
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(name: 'miaobi_db');

  // Novel operations
  Future<List<NovelEntity>> getAllNovels() => select(novels).get();

  Stream<List<NovelEntity>> watchAllNovels() =>
      (select(novels)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();

  Future<NovelEntity?> getNovelById(String id) =>
      (select(novels)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertNovel(NovelsCompanion novel) => into(novels).insert(novel);

  Future<bool> updateNovel(NovelsCompanion novel) => update(novels).replace(novel);

  Future<int> deleteNovel(String id) =>
      (delete(novels)..where((t) => t.id.equals(id))).go();

  // Chapter operations
  Future<List<ChapterEntity>> getChaptersByNovel(String novelId) =>
      (select(chapters)
            ..where((t) => t.novelId.equals(novelId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .get();

  Stream<List<ChapterEntity>> watchChaptersByNovel(String novelId) =>
      (select(chapters)
            ..where((t) => t.novelId.equals(novelId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .watch();

  Future<ChapterEntity?> getChapterById(String id) =>
      (select(chapters)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertChapter(ChaptersCompanion chapter) => into(chapters).insert(chapter);

  Future<bool> updateChapter(ChaptersCompanion chapter) => update(chapters).replace(chapter);

  Future<int> deleteChapter(String id) =>
      (delete(chapters)..where((t) => t.id.equals(id))).go();

  Future<int> deleteChaptersByNovel(String novelId) =>
      (delete(chapters)..where((t) => t.novelId.equals(novelId))).go();

  // ChapterGraph operations
  Future<ChapterGraphEntity?> getGraphByChapter(String chapterId) =>
      (select(chapterGraphs)..where((t) => t.chapterId.equals(chapterId)))
          .getSingleOrNull();

  Future<int> insertGraph(ChapterGraphsCompanion graph) =>
      into(chapterGraphs).insert(graph);

  Future<bool> updateGraph(ChapterGraphsCompanion graph) =>
      update(chapterGraphs).replace(graph);

  Future<int> deleteGraph(String id) =>
      (delete(chapterGraphs)..where((t) => t.id.equals(id))).go();

  Future<int> deleteGraphByChapter(String chapterId) =>
      (delete(chapterGraphs)..where((t) => t.chapterId.equals(chapterId))).go();

  // Advanced graph operations (F3)
  Future<AdvancedGraphEntity?> getAdvancedGraphByChapter(String chapterId) =>
      (select(advancedGraphs)..where((t) => t.chapterId.equals(chapterId)))
          .getSingleOrNull();

  Future<int> insertAdvancedGraph(AdvancedGraphsCompanion graph) =>
      into(advancedGraphs).insert(graph);

  Future<int> updateAdvancedGraph(AdvancedGraphsCompanion graph) =>
      (update(advancedGraphs)..where((t) => t.chapterId.equals(graph.chapterId.value)))
          .write(graph);

  Future<int> insertOrUpdateAdvancedGraph(AdvancedGraphsCompanion graph) async {
    final existing = await getAdvancedGraphByChapter(graph.chapterId.value);
    if (existing != null) {
      return updateAdvancedGraph(graph);
    } else {
      return insertAdvancedGraph(graph);
    }
  }

  Future<int> deleteAdvancedGraphByChapter(String chapterId) =>
      (delete(advancedGraphs)..where((t) => t.chapterId.equals(chapterId))).go();

  // ─── Character Profile operations (F7) ───────────────────────
  Future<List<CharacterProfileEntity>> getCharacterProfilesByNovel(String novelId) =>
      (select(characterProfiles)..where((t) => t.novelId.equals(novelId))).get();

  Future<CharacterProfileEntity?> getCharacterProfileById(String id) =>
      (select(characterProfiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertCharacterProfile(CharacterProfilesCompanion profile) =>
      into(characterProfiles).insert(profile);

  Future<bool> updateCharacterProfile(CharacterProfilesCompanion profile) =>
      update(characterProfiles).replace(profile);

  Future<int> deleteCharacterProfile(String id) =>
      (delete(characterProfiles)..where((t) => t.id.equals(id))).go();

  Future<int> deleteCharacterProfilesByNovel(String novelId) =>
      (delete(characterProfiles)..where((t) => t.novelId.equals(novelId))).go();

  // ─── Novel World Setting operations (F7) ─────────────────────
  Future<List<NovelWorldSettingEntity>> getWorldSettingsByNovel(String novelId) =>
      (select(novelWorldSettings)..where((t) => t.novelId.equals(novelId))).get();

  Future<NovelWorldSettingEntity?> getWorldSettingById(String id) =>
      (select(novelWorldSettings)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertWorldSetting(NovelWorldSettingsCompanion setting) =>
      into(novelWorldSettings).insert(setting);

  Future<bool> updateWorldSetting(NovelWorldSettingsCompanion setting) =>
      update(novelWorldSettings).replace(setting);

  Future<int> deleteWorldSetting(String id) =>
      (delete(novelWorldSettings)..where((t) => t.id.equals(id))).go();

  Future<int> deleteWorldSettingsByNovel(String novelId) =>
      (delete(novelWorldSettings)..where((t) => t.novelId.equals(novelId))).go();

  // Cascade delete
  Future<void> deleteNovelWithRelated(String novelId) async {
    await transaction(() async {
      // Delete chapters first
      final chapterList = await getChaptersByNovel(novelId);
      for (final chapter in chapterList) {
        await deleteGraphByChapter(chapter.id);
      }
      await deleteChaptersByNovel(novelId);
      await deleteNovel(novelId);
    });
  }
}
