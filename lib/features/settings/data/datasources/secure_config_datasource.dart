// Package: settings data datasources
// SecureConfigDatasource: flutter_secure_storage-based local data source
// for persisting application configuration (API keys, model selection, etc.).

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/app_config.dart';

/// Local data source for secure app configuration storage.
/// Uses flutter_secure_storage (encrypted on Android) to persist
/// sensitive settings like API keys and endpoint URLs.
class SecureConfigDatasource {
  final FlutterSecureStorage _secureStorage;

  SecureConfigDatasource({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  // ─── Keys ────────────────────────────────────────────────────

  static const _keyApiBaseUrl = 'settings_apiBaseUrl';
  static const _keyApiKey = 'settings_apiKey';
  static const _keySelectedModel = 'settings_selectedModel';
  static const _keyWriteWordCount = 'settings_writeWordCount';
  static const _keyEnableQualityCheck = 'settings_enableQualityCheck';
  static const _keyAutoUpdateGraphAfterWrite =
      'settings_autoUpdateGraphAfterWrite';

  // ─── Load ────────────────────────────────────────────────────

  /// Load the full app configuration from secure storage.
  Future<AppConfig> loadConfig() async {
    final apiBaseUrl = await _secureStorage.read(key: _keyApiBaseUrl) ?? '';
    final apiKey = await _secureStorage.read(key: _keyApiKey) ?? '';
    final selectedModel =
        await _secureStorage.read(key: _keySelectedModel) ?? '';
    final writeWordCountStr =
        await _secureStorage.read(key: _keyWriteWordCount);
    final enableQualityCheckStr =
        await _secureStorage.read(key: _keyEnableQualityCheck);
    final autoUpdateGraphStr =
        await _secureStorage.read(key: _keyAutoUpdateGraphAfterWrite);

    return AppConfig(
      apiBaseUrl: apiBaseUrl,
      apiKey: apiKey,
      selectedModel: selectedModel,
      writeWordCount:
          writeWordCountStr != null ? int.tryParse(writeWordCountStr) ?? 2000 : 2000,
      enableQualityCheck:
          enableQualityCheckStr == null || enableQualityCheckStr == 'true',
      autoUpdateGraphAfterWrite:
          autoUpdateGraphStr == null || autoUpdateGraphStr == 'true',
    );
  }

  // ─── Save ────────────────────────────────────────────────────

  /// Persist the full app configuration to secure storage.
  Future<void> saveConfig(AppConfig config) async {
    await Future.wait([
      _secureStorage.write(key: _keyApiBaseUrl, value: config.apiBaseUrl),
      _secureStorage.write(key: _keyApiKey, value: config.apiKey),
      _secureStorage.write(key: _keySelectedModel, value: config.selectedModel),
      _secureStorage.write(
          key: _keyWriteWordCount, value: config.writeWordCount.toString()),
      _secureStorage.write(
          key: _keyEnableQualityCheck,
          value: config.enableQualityCheck.toString()),
      _secureStorage.write(
          key: _keyAutoUpdateGraphAfterWrite,
          value: config.autoUpdateGraphAfterWrite.toString()),
    ]);
  }
}
