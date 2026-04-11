// Package: settings presentation providers
// SettingsProvider: presentation-layer state holder that composes NovelProvider.
// Clean Architecture aligned interface for the Settings feature.

import 'package:flutter/foundation.dart';

import '../../../../providers/novel_provider.dart';
import '../../domain/models/app_config.dart';
import '../../domain/repositories/i_config_repository.dart';
import '../../domain/usecases/get_config_usecase.dart';
import '../../domain/usecases/update_config_usecase.dart';
import '../../data/datasources/secure_config_datasource.dart';
import '../../data/repositories/config_repository_impl.dart';

/// Settings presentation provider.
///
/// This provider composes the existing [NovelProvider] (the single source of truth)
/// with Clean Architecture use cases for the Settings feature.
///
/// [NovelProvider] is NOT modified — this class wraps and delegates to it,
/// following the composition-over-inheritance principle.
///
/// Usage example:
/// ```dart
/// // In a widget:
/// final settings = context.read<SettingsProvider>();
/// await settings.updateConfig(config);
/// ```
class SettingsProvider extends ChangeNotifier {
  late final IConfigRepository _repository;
  late final GetConfigUseCase _getConfigUseCase;
  late final UpdateConfigUseCase _updateConfigUseCase;

  SettingsProvider({
    required NovelProvider novelProvider,
    SecureConfigDatasource? datasource,
  }) {
    final ds = datasource ?? SecureConfigDatasource();
    _repository = ConfigRepositoryImpl(
      datasource: ds,
      novelProvider: novelProvider,
    );
    _getConfigUseCase = GetConfigUseCase(_repository);
    _updateConfigUseCase = UpdateConfigUseCase(_repository);
  }

  // ─── Use case methods ──────────────────────────────────────────

  /// Get the current [AppConfig].
  /// Reads live from [NovelProvider] via the repository.
  Future<AppConfig> getConfig() {
    return _getConfigUseCase();
  }

  /// Update the app configuration.
  /// Persists to secure storage and syncs to [NovelProvider].
  Future<void> updateConfig(AppConfig config) {
    return _updateConfigUseCase(config);
  }
}
