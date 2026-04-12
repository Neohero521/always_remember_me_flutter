import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../database/database.dart';
import '../../features/novels/data/datasources/novel_local_datasource.dart';
import '../../features/novels/data/datasources/chapter_local_datasource.dart';
import '../../features/novels/data/datasources/graph_local_datasource.dart';
import '../../features/novels/data/datasources/character_profile_datasource.dart';
import '../../features/novels/data/repositories/novel_repository_impl.dart';
import '../../features/novels/data/repositories/chapter_repository_impl.dart';
import '../../features/novels/data/repositories/graph_repository_impl.dart';
import '../../features/novels/data/repositories/character_profile_repository_impl.dart';
import '../../features/novels/domain/repositories/novel_repository.dart';
import '../../features/novels/domain/repositories/chapter_repository.dart';
import '../../features/novels/domain/repositories/graph_repository.dart';
import '../../features/novels/domain/repositories/character_profile_repository.dart';
import '../../features/writing/domain/repositories/ai_repository.dart';
import '../../features/writing/domain/repositories/ai_providers.dart';

final getIt = GetIt.instance;
final _secureStorage = const FlutterSecureStorage();

Future<void> initDependencies() async {
  // Database
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  // Dio
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 120),
    sendTimeout: const Duration(seconds: 30),
  ));
  getIt.registerSingleton<Dio>(dio);

  // Read API Key from secure storage
  final apiKey = await _secureStorage.read(key: 'ai_api_key') ?? '';
  final baseUrl = await _secureStorage.read(key: 'ai_base_url') ?? 'https://api.siliconflow.cn';
  final provider = await _secureStorage.read(key: 'ai_provider') ?? 'siliconflow';

  // Data Sources
  getIt.registerLazySingleton(() => NovelLocalDatasource(getIt<AppDatabase>()));
  getIt.registerLazySingleton(() => ChapterLocalDatasource(getIt<AppDatabase>()));
  getIt.registerLazySingleton(() => GraphLocalDatasource(getIt<AppDatabase>()));

  // Repositories
  getIt.registerLazySingleton<NovelRepository>(
    () => NovelRepositoryImpl(getIt<NovelLocalDatasource>()),
  );
  getIt.registerLazySingleton<ChapterRepository>(
    () => ChapterRepositoryImpl(getIt<ChapterLocalDatasource>()),
  );
  getIt.registerLazySingleton<GraphRepository>(
    () => GraphRepositoryImpl(getIt<AppDatabase>(), getIt<GraphLocalDatasource>()),
  );

  // F7: Character Profile repositories
  getIt.registerLazySingleton<CharacterProfileLocalDatasource>(
    () => CharacterProfileLocalDatasource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<WorldSettingLocalDatasource>(
    () => WorldSettingLocalDatasource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<CharacterProfileRepository>(
    () => CharacterProfileRepositoryImpl(getIt<CharacterProfileLocalDatasource>()),
  );
  getIt.registerLazySingleton<WorldSettingRepository>(
    () => WorldSettingRepositoryImpl(getIt<WorldSettingLocalDatasource>()),
  );

  // AI Repository - 根据provider选择
  if (provider == 'openai') {
    getIt.registerLazySingleton<AIRepository>(
      () => OpenAIRepository(
        dio: getIt<Dio>(),
        apiKey: apiKey,
      ),
    );
  } else {
    // SiliconFlow or custom
    getIt.registerLazySingleton<AIRepository>(
      () => SiliconFlowAIRepository(
        dio: getIt<Dio>(),
        apiKey: apiKey,
        baseUrl: baseUrl,
      ),
    );
  }
}

/// 重新初始化AI Repository（当设置变更时调用）
Future<void> reinitAIRepository() async {
  await getIt.unregister<AIRepository>();

  final apiKey = await _secureStorage.read(key: 'ai_api_key') ?? '';
  final baseUrl = await _secureStorage.read(key: 'ai_base_url') ?? 'https://api.siliconflow.cn';
  final provider = await _secureStorage.read(key: 'ai_provider') ?? 'siliconflow';

  if (provider == 'openai') {
    getIt.registerLazySingleton<AIRepository>(
      () => OpenAIRepository(
        dio: getIt<Dio>(),
        apiKey: apiKey,
      ),
    );
  } else {
    getIt.registerLazySingleton<AIRepository>(
      () => SiliconFlowAIRepository(
        dio: getIt<Dio>(),
        apiKey: apiKey,
        baseUrl: baseUrl,
      ),
    );
  }
}
