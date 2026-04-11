import 'app_exception.dart';

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ConnectionException extends NetworkException {
  const ConnectionException({super.originalError})
      : super(message: '网络连接失败，请检查网络设置');
}

class TimeoutException extends NetworkException {
  const TimeoutException({super.originalError})
      : super(message: '请求超时，请稍后重试');
}

class HttpException extends NetworkException {
  final int statusCode;

  const HttpException({
    required this.statusCode,
    required super.message,
    super.originalError,
  });
}
