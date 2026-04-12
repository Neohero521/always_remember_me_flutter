import 'package:equatable/equatable.dart';

/// Base failure class for domain layer error handling
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Database operation failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Cache operation failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network operation failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// AI service failures
class AIServiceFailure extends Failure {
  const AIServiceFailure(super.message);
}

/// File operation failures
class FileFailure extends Failure {
  const FileFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
