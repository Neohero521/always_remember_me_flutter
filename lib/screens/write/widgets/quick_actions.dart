import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/novel_provider.dart';
import '../../../theme/game_console_theme.dart';

/// 快捷操作区 — 整合自 HomeScreen QuickActionCard
class QuickActionsGrid extends StatelessWidget {
  final VoidCallback? onImportTap;
  final VoidCallback? onQuickWriteTap;
  final VoidCallback? onGenerateGraphTap;
  final VoidCallback? onViewGraphTap;

  const QuickActionsGrid({
    super.key,
    this.onImportTap,
    this.onQuickWriteTap,
    this.onGenerateGraphTap,
    this.onViewGraphTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final hasNovel = provider.chapters.isNotEmpty;
    final canMerge = hasNovel &&
        provider.chapterGraphMap.length >= provider.chapters.length &&
        provider.chapterGraphMap.isNotEmpty;
    final hasMergedGraph = provider.mergedGraph != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              emoji: '📥',
              label: '导入小说',
              color: CutePixelColors.lavender,
              onTap: onImportTap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              emoji: '🚀',
              label: '一键续写',
              color: CutePixelColors.orange,
              enabled: hasNovel,
              onTap: hasNovel ? onQuickWriteTap : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool enabled;

  const _QuickActionButton({
    required this.emoji,
    required this.label,
    required this.color,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 48,
        decoration: CutePixelColors.buttonDecoration(
          color: enabled ? color : CutePixelColors.bg3,
          pressed: false,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: enabled ? CutePixelColors.text : CutePixelColors.textMuted,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
