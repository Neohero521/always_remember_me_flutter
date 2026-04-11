// Package: reader domain usecases
// GetReaderConfigUseCase: retrieves the current reader configuration.

import '../models/reader_config.dart';
import '../repositories/i_reader_repository.dart';

/// Use case for retrieving the current reader configuration.
class GetReaderConfigUseCase {
  final IReaderRepository _repository;

  GetReaderConfigUseCase(this._repository);

  /// Returns the current reader configuration.
  ReaderConfig call() {
    return _repository.getReaderConfig();
  }
}
