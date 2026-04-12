import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API配置状态
class ApiConfigState {
  final String chatCompletionSource;
  final String customUrl;
  final String customModel;
  final String customIncludeBody;
  final String customExcludeBody;
  final String customIncludeHeaders;
  final bool bypassStatusCheck;
  final int promptConverter; // 0-4 对应 PromptConverter枚举
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const ApiConfigState({
    this.chatCompletionSource = 'openai',
    this.customUrl = '',
    this.customModel = '',
    this.customIncludeBody = '',
    this.customExcludeBody = '',
    this.customIncludeHeaders = '',
    this.bypassStatusCheck = false,
    this.promptConverter = 0,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  ApiConfigState copyWith({
    String? chatCompletionSource,
    String? customUrl,
    String? customModel,
    String? customIncludeBody,
    String? customExcludeBody,
    String? customIncludeHeaders,
    bool? bypassStatusCheck,
    int? promptConverter,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return ApiConfigState(
      chatCompletionSource: chatCompletionSource ?? this.chatCompletionSource,
      customUrl: customUrl ?? this.customUrl,
      customModel: customModel ?? this.customModel,
      customIncludeBody: customIncludeBody ?? this.customIncludeBody,
      customExcludeBody: customExcludeBody ?? this.customExcludeBody,
      customIncludeHeaders: customIncludeHeaders ?? this.customIncludeHeaders,
      bypassStatusCheck: bypassStatusCheck ?? this.bypassStatusCheck,
      promptConverter: promptConverter ?? this.promptConverter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// API配置状态管理器
class ApiConfigNotifier extends StateNotifier<ApiConfigState> {
  ApiConfigNotifier() : super(const ApiConfigState());

  /// 更新聊天补全来源
  void setChatCompletionSource(String source) {
    state = state.copyWith(chatCompletionSource: source);
  }

  /// 更新自定义URL
  void setCustomUrl(String url) {
    state = state.copyWith(customUrl: url);
  }

  /// 更新自定义模型
  void setCustomModel(String model) {
    state = state.copyWith(customModel: model);
  }

  /// 更新Include Body
  void setCustomIncludeBody(String value) {
    state = state.copyWith(customIncludeBody: value);
  }

  /// 更新Exclude Body
  void setCustomExcludeBody(String value) {
    state = state.copyWith(customExcludeBody: value);
  }

  /// 更新Custom Headers
  void setCustomIncludeHeaders(String value) {
    state = state.copyWith(customIncludeHeaders: value);
  }

  /// 更新Bypass设置
  void setBypassStatusCheck(bool value) {
    state = state.copyWith(bypassStatusCheck: value);
  }

  /// 更新Prompt转换器
  void setPromptConverter(int index) {
    state = state.copyWith(promptConverter: index);
  }

  /// 设置加载状态
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// 设置错误
  void setError(String? error) {
    state = state.copyWith(error: error, successMessage: null);
  }

  /// 设置成功消息
  void setSuccess(String? message) {
    state = state.copyWith(successMessage: message, error: null);
  }

  /// 清除消息
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }

  /// 重置状态
  void reset() {
    state = const ApiConfigState();
  }
}

/// API配置Provider
final apiConfigProvider = StateNotifierProvider<ApiConfigNotifier, ApiConfigState>((ref) {
  return ApiConfigNotifier();
});

/// 当前选中的聊天补全来源
final selectedChatSourceProvider = Provider<String>((ref) {
  return ref.watch(apiConfigProvider).chatCompletionSource;
});

/// 是否正在加载
final isApiConfigLoadingProvider = Provider<bool>((ref) {
  return ref.watch(apiConfigProvider).isLoading;
});
