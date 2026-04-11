import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/novel_provider.dart';
import '../theme/game_console_theme.dart';
import 'router.dart';

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
            // Header 区域 — 渐变背景
            _DrawerHeader(
              bookTitle: currentBook?.title,
              hasNovel: hasNovel,
            ),
            const Divider(height: 1, color: CutePixelColors.borderDark),
            // 主导航菜单
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.auto_stories,
                    emoji: '✍️',
                    label: '续写',
                    subtitle: 'AI 续写核心',
                    onTap: () => _navigateTo(context, AppRoutes.home),
                  ),
                  _DrawerItem(
                    icon: Icons.library_books,
                    emoji: '📚',
                    label: '我的书架',
                    subtitle: '${provider.bookshelf.length} 本书',
                    onTap: () => _navigateTo(context, AppRoutes.bookshelf),
                  ),
                  _DrawerItem(
                    icon: Icons.list_alt,
                    emoji: '📖',
                    label: '章节管理',
                    subtitle: hasNovel ? '${provider.chapters.length} 章节' : '暂无章节',
                    onTap: () => _navigateTo(context, AppRoutes.chapters),
                  ),
                  const Divider(height: 1, color: CutePixelColors.borderDark),
                  _DrawerItem(
                    icon: Icons.account_tree,
                    emoji: '🌲',
                    label: '全局图谱',
                    subtitle: '查看/导出/导入',
                    onTap: () => _navigateTo(context, AppRoutes.graph),
                  ),
                  _DrawerItem(
                    icon: Icons.file_upload,
                    emoji: '📥',
                    label: '导入小说',
                    subtitle: '从 TXT 导入',
                    onTap: () => _navigateTo(context, AppRoutes.import),
                  ),
                  const Divider(height: 1, color: CutePixelColors.borderDark),
                  _DrawerItem(
                    icon: Icons.settings,
                    emoji: '⚙️',
                    label: '设置',
                    subtitle: '续写参数、主题',
                    onTap: () => _navigateTo(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),
            // 底部版本信息
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: CutePixelColors.borderDark, width: 1),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    'Always Remember Me',
                    style: TextStyle(
                      fontSize: 12,
                      color: CutePixelColors.textMuted,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Spacer(),
                  Text(
                    'v3.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: CutePixelColors.textMuted,
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
    // 关闭 Drawer
    Navigator.of(context).pop();
    // 如果已经在目标页面，不重复跳转
    if (route == AppRoutes.home && ModalRoute.of(context)?.settings.name == '/') {
      return;
    }
    Navigator.of(context).pushNamed(route);
  }
}

class _DrawerHeader extends StatelessWidget {
  final String? bookTitle;
  final bool hasNovel;

  const _DrawerHeader({this.bookTitle, required this.hasNovel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CutePixelColors.lavender,
            CutePixelColors.pinkDark,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🐋',
            style: TextStyle(fontSize: 40),
          ),
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
          if (bookTitle != null) ...[
            Text(
              '当前: 《$bookTitle》',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (hasNovel)
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushNamed(AppRoutes.bookshelf);
                  },
                  child: const Text(
                    '👆 点击切换书籍',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            else
              const Text(
                '📥 还没有书籍，请导入',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ] else ...[
            const Text(
              '✨ 还没有选中书籍',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
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
          color: CutePixelColors.bg3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: CutePixelColors.text,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: CutePixelColors.textMuted,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: CutePixelColors.textMuted,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
