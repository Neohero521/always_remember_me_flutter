import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API拦截器提供者
final dioInterceptorsProvider = Provider<List<Interceptor>>((ref) {
  return [
    AuthInterceptor(),
    ResponseInterceptor(),
    LogInterceptor(),
  ];
});

/// 认证拦截器 - 根据配置添加认证头
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从配置获取API Key并添加认证头
    // 具体实现在使用时通过options.extra传递配置
    super.onRequest(options, handler);
  }
}

/// 响应拦截器 - 统一错误处理
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      // 成功响应
      super.onResponse(response, handler);
    } else {
      // 处理错误状态码
      final error = _handleErrorStatus(response.statusCode, response.data);
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: error,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 统一错误处理
    final message = _convertDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        message: message,
      ),
    );
  }

  String _handleErrorStatus(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return 'API Key无效或已过期';
      case 403:
        return '无权限访问';
      case 404:
        return 'API端点不存在';
      case 429:
        return '请求过于频繁，请稍后重试';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务暂不可用';
      default:
        return '请求失败: $statusCode';
    }
  }

  String _convertDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络';
      case DioExceptionType.sendTimeout:
        return '发送请求超时';
      case DioExceptionType.receiveTimeout:
        return '响应超时，请稍后重试';
      case DioExceptionType.badCertificate:
        return '证书无效';
      case DioExceptionType.badResponse:
        return _handleErrorStatus(e.response?.statusCode, e.response?.data);
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络';
      case DioExceptionType.unknown:
        return e.message ?? '未知错误';
    }
  }
}

/// 代理配置模型
class ProxyConfig {
  final bool enabled;
  final String url;
  final List<String> bypass;

  const ProxyConfig({
    this.enabled = false,
    this.url = '',
    this.bypass = const [],
  });

  ProxyConfig copyWith({
    bool? enabled,
    String? url,
    List<String>? bypass,
  }) {
    return ProxyConfig(
      enabled: enabled ?? this.enabled,
      url: url ?? this.url,
      bypass: bypass ?? this.bypass,
    );
  }
}

/// 全局代理配置提供者
final proxyConfigProvider = StateProvider<ProxyConfig>((ref) {
  return const ProxyConfig();
});
