import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../domain/models/character_profile.dart';

class CharacterProfileLocalDatasource {
  final AppDatabase _db;
  CharacterProfileLocalDatasource(this._db);

  Future<List<CharacterProfile>> getByNovel(String novelId) async {
    final entities = await _db.getCharacterProfilesByNovel(novelId);
    return entities.map(_entityToModel).toList();
  }

  Future<CharacterProfile?> getById(String id) async {
    final entity = await _db.getCharacterProfileById(id);
    return entity != null ? _entityToModel(entity) : null;
  }

  Future<void> insert(CharacterProfile profile) => _db.insertCharacterProfile(
        CharacterProfilesCompanion(
          id: Value(profile.id),
          novelId: Value(profile.novelId),
          name: Value(profile.name),
          alias: Value(profile.alias),
          personality: Value(profile.personality),
          redLines: Value(jsonEncode(profile.redLines)),
          backstories: Value(jsonEncode(profile.backstories)),
        ),
      );

  Future<void> update(CharacterProfile profile) => _db.updateCharacterProfile(
        CharacterProfilesCompanion(
          id: Value(profile.id),
          novelId: Value(profile.novelId),
          name: Value(profile.name),
          alias: Value(profile.alias),
          personality: Value(profile.personality),
          redLines: Value(jsonEncode(profile.redLines)),
          backstories: Value(jsonEncode(profile.backstories)),
        ),
      );

  Future<void> delete(String id) => _db.deleteCharacterProfile(id);

  CharacterProfile _entityToModel(CharacterProfileEntity entity) {
    return CharacterProfile(
      id: entity.id,
      novelId: entity.novelId,
      name: entity.name,
      alias: entity.alias,
      personality: entity.personality,
      redLines: _decodeJsonList(entity.redLines),
      backstories: _decodeJsonList(entity.backstories),
    );
  }

  List<String> _decodeJsonList(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}

class WorldSettingLocalDatasource {
  final AppDatabase _db;
  WorldSettingLocalDatasource(this._db);

  Future<List<NovelWorldSetting>> getByNovel(String novelId) async {
    final entities = await _db.getWorldSettingsByNovel(novelId);
    return entities.map(_entityToModel).toList();
  }

  Future<NovelWorldSetting?> getById(String id) async {
    final entity = await _db.getWorldSettingById(id);
    return entity != null ? _entityToModel(entity) : null;
  }

  Future<void> insert(NovelWorldSetting setting) => _db.insertWorldSetting(
        NovelWorldSettingsCompanion(
          id: Value(setting.id),
          novelId: Value(setting.novelId),
          era: Value(setting.era),
          geography: Value(setting.geography),
          powerSystem: Value(setting.powerSystem),
          society: Value(setting.society),
          forbiddenRules: Value(jsonEncode(setting.forbiddenRules)),
          foreshadows: Value(jsonEncode(setting.foreshadows.map((f) => f.toJson()).toList())),
        ),
      );

  Future<void> update(NovelWorldSetting setting) => _db.updateWorldSetting(
        NovelWorldSettingsCompanion(
          id: Value(setting.id),
          novelId: Value(setting.novelId),
          era: Value(setting.era),
          geography: Value(setting.geography),
          powerSystem: Value(setting.powerSystem),
          society: Value(setting.society),
          forbiddenRules: Value(jsonEncode(setting.forbiddenRules)),
          foreshadows: Value(jsonEncode(setting.foreshadows.map((f) => f.toJson()).toList())),
        ),
      );

  Future<void> delete(String id) => _db.deleteWorldSetting(id);

  NovelWorldSetting _entityToModel(NovelWorldSettingEntity entity) {
    return NovelWorldSetting(
      id: entity.id,
      novelId: entity.novelId,
      era: entity.era,
      geography: entity.geography,
      powerSystem: entity.powerSystem,
      society: entity.society,
      forbiddenRules: _decodeJsonList(entity.forbiddenRules),
      foreshadows: _decodeForeshadows(entity.foreshadows),
    );
  }

  List<String> _decodeJsonList(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  List<Foreshadow> _decodeForeshadows(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => Foreshadow.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
