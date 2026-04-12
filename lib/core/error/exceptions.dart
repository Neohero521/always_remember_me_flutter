/// Base exception for database operations
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}

/// Base exception for cache operations
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

/// Base exception for network operations
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  
  const NetworkException(this.message, {this.statusCode});
  
  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}

/// AI service exception
class AIServiceException implements Exception {
  final String message;
  final int? statusCode;
  
  const AIServiceException(this.message, {this.statusCode});
  
  @override
  String toString() => 'AIServiceException: $message (status: $statusCode)';
}

/// File operation exception
class FileException implements Exception {
  final String message;
  const FileException(this.message);
  
  @override
  String toString() => 'FileException: $message';
}
