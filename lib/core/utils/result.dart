/// Result type for v5.0 - Either-style error handling without exceptions
/// Uses freezed but we implement it manually to avoid build complexity for now
sealed class Result<E, T> {
  const Result();
}

class Success<E, T> extends Result<E, T> {
  final T data;
  const Success(this.data);
}

class Failure<E, T> extends Result<E, T> {
  final E error;
  const Failure(this.error);
}

/// Shorthand for AppException-based results
typedef AppResult<T> = Result<dynamic, T>;

extension ResultExtension<E, T> on Result<E, T> {
  bool get isSuccess => this is Success<E, T>;
  bool get isFailure => this is Failure<E, T>;

  T? get dataOrNull => this is Success<E, T> ? (this as Success<E, T>).data : null;
  E? get errorOrNull => this is Failure<E, T> ? (this as Failure<E, T>).error : null;

  R fold<R>(R Function(T data) onSuccess, R Function(E error) onFailure) {
    return switch (this) {
      Success<E, T>(:final data) => onSuccess(data),
      Failure<E, T>(:final error) => onFailure(error),
    };
  }
}
