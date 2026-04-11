// Package: settings domain repositories
// IConfigRepository: abstract interface for app configuration operations.

import '../models/app_config.dart';

/// Abstract repository interface for application configuration.
///
/// Defines the contract for loading and persisting app settings,
/// enabling dependency inversion in the domain layer.
abstract class IConfigRepository {
  /// Load the current app configuration.
  Future<AppConfig> getConfig();

  /// Persist the given app configuration.
  Future<void> updateConfig(AppConfig config);
}
