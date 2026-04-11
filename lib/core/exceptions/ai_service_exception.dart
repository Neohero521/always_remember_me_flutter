import 'app_exception.dart';

/// AI Service exceptions
class AIServiceException extends AppException {
  const AIServiceException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class RateLimitException extends AIServiceException {
  const RateLimitException({super.originalError})
      : super(message: 'API 请求过于频繁，请稍后重试');
}

class QuotaException extends AIServiceException {
  const QuotaException({super.originalError})
      : super(message: 'API 额度不足');
}

class GenerationException extends AIServiceException {
  const GenerationException({super.originalError})
      : super(message: '内容生成失败，请重试');
}
