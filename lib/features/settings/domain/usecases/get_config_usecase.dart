// Package: settings domain usecases
// GetConfigUseCase: retrieves the current app configuration.

import '../repositories/i_config_repository.dart';
import '../models/app_config.dart';

/// Use case for retrieving the current app configuration.
class GetConfigUseCase {
  final IConfigRepository _repository;

  GetConfigUseCase(this._repository);

  /// Returns the current [AppConfig].
  Future<AppConfig> call() {
    return _repository.getConfig();
  }
}
