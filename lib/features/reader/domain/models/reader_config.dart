// Package: reader domain models
// ReaderConfig: immutable configuration state for the reader screen.

/// Immutable reader configuration.
class ReaderConfig {
  /// Current font size for reading (12-28).
  final int fontSize;

  /// Currently active chapter ID, if any.
  final int? currentChapterId;

  const ReaderConfig({
    required this.fontSize,
    this.currentChapterId,
  });

  /// Default reader config.
  factory ReaderConfig.defaults() => const ReaderConfig(
        fontSize: 16,
        currentChapterId: null,
      );

  /// Copy with modified fields.
  ReaderConfig copyWith({
    int? fontSize,
    int? currentChapterId,
  }) {
    return ReaderConfig(
      fontSize: fontSize ?? this.fontSize,
      currentChapterId: currentChapterId ?? this.currentChapterId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderConfig &&
          runtimeType == other.runtimeType &&
          fontSize == other.fontSize &&
          currentChapterId == other.currentChapterId;

  @override
  int get hashCode => fontSize.hashCode ^ currentChapterId.hashCode;
}
