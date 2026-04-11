// Package: writing domain use cases
// GenerateWriteUseCase: generates continuation content from a base chapter.

import '../repositories/i_writing_repository.dart';

/// Use case for generating continuation content.
///
/// This use case handles the AI-powered continuation writing process,
/// delegating to the repository which composes NovelProvider under the hood.
class GenerateWriteUseCase {
  final IWritingRepository _repository;

  GenerateWriteUseCase(this._repository);

  /// Generate continuation content from the currently selected base chapter.
  ///
  /// Returns the generated continuation text, or null if generation failed.
  Future<String?> call({String? modifiedContent}) async {
    return _repository.generateWrite(modifiedContent: modifiedContent);
  }

  /// Continue writing from a chain chapter.
  ///
  /// [targetChainId] is the ID of the chain chapter to continue from.
  /// Returns the generated continuation text, or null if generation failed.
  Future<String?> continueFromChain(int targetChainId) async {
    return _repository.continueFromChain(targetChainId);
  }
}
