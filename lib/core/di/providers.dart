import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/novel_provider.dart';
import '../../services/storage_service.dart';
import '../../services/novel_api_service.dart';
import '../../services/chapter_service.dart';
import '../../models/novel_book.dart';
import '../../models/chapter.dart';

/// v5.0 Core Providers - Clean Architecture entry point
/// These wrap existing v4 services for the new Riverpod architecture

// ─── Storage ────────────────────────────────────────────────

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

// ─── Services ───────────────────────────────────────────────

final chapterServiceProvider = Provider<ChapterService>((ref) {
  return ChapterService();
});

// ─── API Service (lazy initialized) ─────────────────────────

final apiServiceProvider = Provider<NovelApiService?>((ref) {
  return null; // Initialized by NovelNotifier when config is available
});

// ─── Legacy Provider Bridge ──────────────────────────────────
/// Bridge to the existing NovelProvider for backward compatibility
/// Phase 1: All features use this. Phase 2+: split into feature providers.
final novelProviderBridgeProvider = Provider<NovelNotifierBridge>((ref) {
  throw UnimplementedError(
    'novelProviderBridgeProvider must be overridden at app startup',
  );
});

/// NovelNotifierBridge - wraps the existing NovelProvider functionality
/// as a Riverpod-compatible interface while keeping the existing
/// business logic unchanged (massive migration = risky).
///
/// This provider is initialized in main.dart with the actual
/// NovelProvider instance.
class NovelNotifierBridge {
  final NovelProvider _provider;

  NovelNotifierBridge(this._provider);

  NovelProvider get raw => _provider;
}

// ─── Re-export models for convenience ───────────────────────
typedef NovelBookModel = NovelBook;
typedef ChapterModel = Chapter;
typedef ContinueChapterModel = ContinueChapter;
