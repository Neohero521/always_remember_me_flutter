import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/novel_provider.dart';
import '../../../theme/game_console_theme.dart';

/// 状态概览卡片 — 整合自 HomeScreen
class StatusOverviewCard extends StatelessWidget {
  final VoidCallback? onChaptersTap;
  final VoidCallback? onGraphsTap;
  final VoidCallback? onChainTap;
  final VoidCallback? onMergedGraphTap;

  const StatusOverviewCard({
    super.key,
    this.onChaptersTap,
    this.onGraphsTap,
    this.onChainTap,
    this.onMergedGraphTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final hasNovel = provider.chapters.isNotEmpty;
    final graphCount = provider.chapterGraphMap.length;
    final chapterCount = provider.chapters.length;
    final chainCount = provider.continueChain.length;
    final hasMergedGraph = provider.mergedGraph != null;

    if (!hasNovel) {
      return _EmptyStatusCard();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: CutePixelColors.cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatusItem(
              emoji: '📖',
              label: '章节',
              value: '$chapterCount 章',
              onTap: onChaptersTap,
            ),
            _VerticalDivider(),
            _StatusItem(
              emoji: '🌲',
              label: '图谱',
              value: '$graphCount/$chapterCount',
              onTap: onGraphsTap,
              hasWarning: graphCount < chapterCount,
            ),
            _VerticalDivider(),
            _StatusItem(
              emoji: '✍️',
              label: '续写',
              value: '$chainCount 条',
              onTap: chainCount > 0 ? onChainTap : null,
            ),
            _VerticalDivider(),
            _StatusItem(
              emoji: hasMergedGraph ? '✅' : '⏳',
              label: '合并',
              value: hasMergedGraph ? '已合并' : '未合并',
              onTap: hasMergedGraph ? onMergedGraphTap : null,
              color: hasMergedGraph ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool hasWarning;
  final Color? color;

  const _StatusItem({
    required this.emoji,
    required this.label,
    required this.value,
    this.onTap,
    this.hasWarning = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                if (hasWarning)
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text('⚠️', style: TextStyle(fontSize: 10)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color ?? CutePixelColors.text,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: CutePixelColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: CutePixelColors.borderDark,
    );
  }
}

class _EmptyStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: CutePixelColors.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          '📭 还没有书籍，请从书架导入',
          style: TextStyle(
            color: CutePixelColors.textMuted,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
