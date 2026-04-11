// Package: settings domain usecases
// UpdateConfigUseCase: persists updated app configuration.

import '../repositories/i_config_repository.dart';
import '../models/app_config.dart';

/// Use case for updating the app configuration.
class UpdateConfigUseCase {
  final IConfigRepository _repository;

  UpdateConfigUseCase(this._repository);

  /// Persist the given [AppConfig] and return the updated config.
  Future<AppConfig> call(AppConfig config) async {
    await _repository.updateConfig(config);
    return config;
  }
}
