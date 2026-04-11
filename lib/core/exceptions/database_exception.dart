import 'app_exception.dart';

/// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ReadException extends DatabaseException {
  const ReadException({super.originalError})
      : super(message: '数据读取失败');
}

class WriteException extends DatabaseException {
  const WriteException({super.originalError})
      : super(message: '数据写入失败');
}

class NotFoundException extends DatabaseException {
  const NotFoundException({super.originalError})
      : super(message: '记录不存在');
}
