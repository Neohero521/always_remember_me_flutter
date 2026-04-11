import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/novel_provider.dart';
import '../theme/v4_colors.dart';

/// AppDrawer v5.0 - Drawer with GoRouter navigation
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final currentBook = provider.currentBookId != null
        ? provider.bookshelf.cast<dynamic>().firstWhere(
            (b) => b.id == provider.currentBookId,
            orElse: () => null,
          )
        : null;
    final hasNovel = provider.chapters.isNotEmpty;

    return Drawer(
      width: 280,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(
              bookTitle: currentBook?.title,
              hasNovel: hasNovel,
            ),
            const Divider(height: 1, color: V4Colors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerMenuItem(
                    emoji: '📖',
                    label: '章节管理',
                    subtitle: '图谱生成、批量生成、章节状态',
                    onTap: () => _navigateTo(context, '/chapters'),
                  ),
                  _DrawerMenuItem(
                    emoji: '🌲',
                    label: '全局图谱',
                    subtitle: '合并后的完整知识图谱',
                    onTap: () => _navigateTo(context, '/graph'),
                  ),
                  _DrawerMenuItem(
                    emoji: '📤',
                    label: '导入/导出图谱',
                    subtitle: 'JSON 格式管理',
                    onTap: () => _navigateTo(context, '/graph-import-export'),
                  ),
                  _DrawerMenuItem(
                    emoji: '⚙️',
                    label: '续写参数',
                    subtitle: '前置校验开关等',
                    onTap: () => _navigateTo(context, '/write-settings'),
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16, color: V4Colors.divider),
                  _DrawerMenuItem(
                    emoji: '📱',
                    label: '设置',
                    subtitle: '阅读器、主题、关于',
                    onTap: () => _navigateTo(context, '/settings'),
                  ),
                  _DrawerMenuItem(
                    emoji: 'ℹ️',
                    label: '关于',
                    subtitle: '版本信息',
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: V4Colors.divider, width: 1),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    'Always Remember Me',
                    style: TextStyle(
                      fontSize: 12,
                      color: V4Colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Spacer(),
                  Text(
                    'v5.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: V4Colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🐋 ', style: TextStyle(fontSize: 24)),
            Text('Always Remember Me'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本 5.0.0'),
            SizedBox(height: 8),
            Text(
              '一个可爱的小说续写工具，支持知识图谱、AI续写、批量操作等功能。',
              style: TextStyle(fontSize: 13, color: V4Colors.textSecondary),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final String? bookTitle;
  final bool hasNovel;

  const _DrawerHeader({this.bookTitle, required this.hasNovel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: V4Colors.drawerHeaderGradient,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🐋', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          const Text(
            'Always Remember Me',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          if (bookTitle != null)
            Text(
              '当前：《$bookTitle》',
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            const Text(
              '✨ 还没有选中书籍',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.emoji,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: V4Colors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: V4Colors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: V4Colors.textSecondary),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: V4Colors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
