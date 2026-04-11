import 'app_exception.dart';

/// 校验异常
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class EmptyInputException extends ValidationException {
  const EmptyInputException({super.originalError})
      : super(message: '输入内容为空');
}

class InvalidFormatException extends ValidationException {
  const InvalidFormatException({super.originalError})
      : super(message: '格式错误');
}

class OutOfRangeException extends ValidationException {
  const OutOfRangeException({super.originalError})
      : super(message: '数值超出范围');
}
