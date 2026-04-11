// Package: settings domain models
// AppConfig: immutable value object representing application configuration.

import 'package:equatable/equatable.dart';

/// Application configuration entity.
///
/// This represents the subset of app settings that are managed
/// through the Settings feature (API config + write preferences).
class AppConfig extends Equatable {
  final String apiBaseUrl;
  final String apiKey;
  final String selectedModel;
  final int writeWordCount;
  final bool enableQualityCheck;
  final bool autoUpdateGraphAfterWrite;

  const AppConfig({
    this.apiBaseUrl = '',
    this.apiKey = '',
    this.selectedModel = '',
    this.writeWordCount = 2000,
    this.enableQualityCheck = true,
    this.autoUpdateGraphAfterWrite = true,
  });

  /// Returns a copy of this config with the given fields replaced.
  AppConfig copyWith({
    String? apiBaseUrl,
    String? apiKey,
    String? selectedModel,
    int? writeWordCount,
    bool? enableQualityCheck,
    bool? autoUpdateGraphAfterWrite,
  }) {
    return AppConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiKey: apiKey ?? this.apiKey,
      selectedModel: selectedModel ?? this.selectedModel,
      writeWordCount: writeWordCount ?? this.writeWordCount,
      enableQualityCheck: enableQualityCheck ?? this.enableQualityCheck,
      autoUpdateGraphAfterWrite:
          autoUpdateGraphAfterWrite ?? this.autoUpdateGraphAfterWrite,
    );
  }

  @override
  List<Object?> get props => [
        apiBaseUrl,
        apiKey,
        selectedModel,
        writeWordCount,
        enableQualityCheck,
        autoUpdateGraphAfterWrite,
      ];
}
