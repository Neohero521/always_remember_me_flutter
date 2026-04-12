import '../../domain/models/character_profile.dart';
import '../../domain/repositories/character_profile_repository.dart';
import '../datasources/character_profile_datasource.dart';

class CharacterProfileRepositoryImpl implements CharacterProfileRepository {
  final CharacterProfileLocalDatasource _datasource;
  CharacterProfileRepositoryImpl(this._datasource);

  @override
  Future<List<CharacterProfile>> getByNovel(String novelId) =>
      _datasource.getByNovel(novelId);

  @override
  Future<CharacterProfile?> getById(String id) =>
      _datasource.getById(id);

  @override
  Future<void> create(CharacterProfile profile) =>
      _datasource.insert(profile);

  @override
  Future<void> update(CharacterProfile profile) =>
      _datasource.update(profile);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}

class WorldSettingRepositoryImpl implements WorldSettingRepository {
  final WorldSettingLocalDatasource _datasource;
  WorldSettingRepositoryImpl(this._datasource);

  @override
  Future<List<NovelWorldSetting>> getByNovel(String novelId) =>
      _datasource.getByNovel(novelId);

  @override
  Future<NovelWorldSetting?> getById(String id) =>
      _datasource.getById(id);

  @override
  Future<void> create(NovelWorldSetting setting) =>
      _datasource.insert(setting);

  @override
  Future<void> update(NovelWorldSetting setting) =>
      _datasource.update(setting);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
