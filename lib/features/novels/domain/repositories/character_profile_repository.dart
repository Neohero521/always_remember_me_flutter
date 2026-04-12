import '../models/character_profile.dart';

abstract class CharacterProfileRepository {
  Future<List<CharacterProfile>> getByNovel(String novelId);
  Future<CharacterProfile?> getById(String id);
  Future<void> create(CharacterProfile profile);
  Future<void> update(CharacterProfile profile);
  Future<void> delete(String id);
}

abstract class WorldSettingRepository {
  Future<List<NovelWorldSetting>> getByNovel(String novelId);
  Future<NovelWorldSetting?> getById(String id);
  Future<void> create(NovelWorldSetting setting);
  Future<void> update(NovelWorldSetting setting);
  Future<void> delete(String id);
}
