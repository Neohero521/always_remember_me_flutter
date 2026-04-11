// Package: graph domain use cases
// GenerateSingleGraphUseCase: generates a knowledge graph for a single chapter.

import '../repositories/i_graph_repository.dart';

/// Use case for generating a knowledge graph for a single chapter.
class GenerateSingleGraphUseCase {
  final IGraphRepository _repository;

  GenerateSingleGraphUseCase(this._repository);

  /// Generate a graph for the chapter with the given [chapterId].
  /// Throws if API service is unavailable or generation fails.
  Future<void> call(int chapterId) async {
    return _repository.generateGraphForChapter(chapterId);
  }
}
