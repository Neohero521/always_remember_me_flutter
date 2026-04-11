// Package: settings data repositories
// ConfigRepositoryImpl: concrete implementation of IConfigRepository.
// Bridges the domain layer with SecureConfigDatasource and NovelProvider.

import '../../../../providers/novel_provider.dart';
import '../../domain/models/app_config.dart';
import '../../domain/repositories/i_config_repository.dart';
import '../datasources/secure_config_datasource.dart';

/// Concrete implementation of [IConfigRepository].
///
/// This repository bridges the domain layer with the data layer:
/// - Uses [SecureConfigDatasource] for secure persistence (flutter_secure_storage)
/// - Uses [NovelProvider] (injected) for in-memory state synchronization
///
/// The actual state lives in [NovelProvider]; this repository ensures
/// changes are persisted to secure storage and reflected in the provider.
class ConfigRepositoryImpl implements IConfigRepository {
  final SecureConfigDatasource _datasource;
  final NovelProvider _novelProvider;

  ConfigRepositoryImpl({
    required SecureConfigDatasource datasource,
    required NovelProvider novelProvider,
  })  : _datasource = datasource,
        _novelProvider = novelProvider;

  @override
  Future<AppConfig> getConfig() async {
    return AppConfig(
      apiBaseUrl: _novelProvider.apiBaseUrl,
      apiKey: _novelProvider.apiKey,
      selectedModel: _novelProvider.selectedModel,
      writeWordCount: _novelProvider.writeWordCount,
      enableQualityCheck: _novelProvider.enableQualityCheck,
      autoUpdateGraphAfterWrite: _novelProvider.autoUpdateGraphAfterWrite,
    );
  }

  @override
  Future<void> updateConfig(AppConfig config) async {
    // Persist to secure storage
    await _datasource.saveConfig(config);

    // Sync to NovelProvider in-memory state
    await _novelProvider.updateConfig(
      apiBaseUrl: config.apiBaseUrl,
      apiKey: config.apiKey,
      selectedModel: config.selectedModel,
      writeWordCount: config.writeWordCount,
      enableQualityCheck: config.enableQualityCheck,
      autoUpdateGraphAfterWrite: config.autoUpdateGraphAfterWrite,
    );
  }
}
