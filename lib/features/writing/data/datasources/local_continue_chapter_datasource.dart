// Package: writing data datasources
// LocalContinueChapterDatasource: local data source for continue chapter operations.
// Delegates to NovelProvider which manages all the actual data persistence via Hive.

import '../../../../models/chapter.dart';

/// Local data source for continue chapter operations.
///
/// This datasource wraps NovelProvider for continue chain operations.
/// NovelProvider handles all Hive persistence internally.
class LocalContinueChapterDatasource {
  /// Get all continue chapters from the chain.
  List<ContinueChapter> getContinueChain() {
    // This method is a placeholder for direct Hive access if needed.
    // Currently, continue chain is managed by NovelProvider.
    return [];
  }
}
