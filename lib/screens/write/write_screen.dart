import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../theme/game_console_theme.dart';
import '../../app/router.dart';
import '../../app/drawer_menu.dart';
import 'write_tab.dart';
import 'chain_tab.dart';
import 'graph_status_tab.dart';
import 'widgets/status_card.dart';
import 'widgets/quick_actions.dart';

/// WriteScreen — v3.0 单主屏
/// 内部 TabBar: [续写 / 链条 / 图谱状态]
/// 整合原 HomeScreen 状态卡片和快捷入口
class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final currentBook = provider.currentBookId != null
        ? provider.bookshelf.cast<dynamic>().firstWhere(
            (b) => b.id == provider.currentBookId,
            orElse: () => null,
          )
        : null;
    final bookTitle = currentBook?.title ?? '请选择书籍';

    return Scaffold(
      backgroundColor: CutePixelColors.bg,
      // ── 自定义 AppBar ───────────────────────────────
      appBar: AppBar(
        backgroundColor: CutePixelColors.bg2,
        foregroundColor: CutePixelColors.text,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Text('☰', style: TextStyle(fontSize: 22)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.bookshelf),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  bookTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (provider.chapters.isNotEmpty) ...[
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18, color: CutePixelColors.textMuted),
              ],
            ],
          ),
        ),
        actions: [
          // 阅读按钮
          if (provider.chapters.isNotEmpty)
            IconButton(
              icon: const Text('📖', style: TextStyle(fontSize: 18)),
              tooltip: '阅读小说',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.reader),
            ),
          // 加载指示器
          if (provider.isGeneratingWrite)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          // 设置菜单
          PopupMenuButton<String>(
            icon: const Text('⋮', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            onSelected: (v) {
              if (v == 'settings') Navigator.pushNamed(context, AppRoutes.settings);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(children: [
                  Icon(Icons.settings, size: 18),
                  SizedBox(width: 8),
                  Text('⚙️ 设置'),
                ]),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: CutePixelColors.lavender,
          unselectedLabelColor: CutePixelColors.textMuted,
          indicatorColor: CutePixelColors.lavender,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: '✍️ 续写'),
            Tab(text: '🔗 链条'),
            Tab(text: '🌲 图谱状态'),
          ],
        ),
      ),
      // ── Drawer ─────────────────────────────────────
      drawer: const AppDrawer(),
      // ── Body ──────────────────────────────────────
      body: Column(
        children: [
          // 状态概览卡片
          StatusOverviewCard(
            onChaptersTap: () => Navigator.pushNamed(context, AppRoutes.chapters),
            onGraphsTap: () {
              _tabController.animateTo(2);
            },
            onChainTap: () {
              _tabController.animateTo(1);
            },
            onMergedGraphTap: () => Navigator.pushNamed(context, AppRoutes.graph),
          ),
          // 快捷操作区
          QuickActionsGrid(
            onImportTap: () => Navigator.pushNamed(context, AppRoutes.import),
            onQuickWriteTap: () {
              _tabController.animateTo(0);
            },
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                WriteTab(),
                ChainTab(),
                GraphStatusTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
