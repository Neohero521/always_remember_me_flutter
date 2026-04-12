import 'package:flutter/material.dart';

/// 妙笔 (Miaobi) Design System
/// 现代中式书卷风 — 深靛蓝主色 + 象牙白底色 + 珊瑚橙强调
class AppColors {
  // ========== 颜色系统 ==========
  /// 主色：深靛蓝（写作/书卷气质）
  static const Color primaryIndigo = Color(0xFF3D5A80);
  static const Color primaryLight = Color(0xFF6B93C1);
  static const Color primaryDark = Color(0xFF2C4266);

  /// 强调色：珊瑚橙（FAB/重要操作/AI功能）
  static const Color accentCoral = Color(0xFFEE6C4D);
  static const Color accentCoralLight = Color(0xFFF4A08A);

  /// 页面底色：象牙白
  static const Color surfaceIvory = Color(0xFFFAF8F5);

  /// 卡片/浮层底色
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// 文字
  static const Color textPrimary = Color(0xFF1D3557);
  static const Color textSecondary = Color(0xFF6B7B8C);
  static const Color textTertiary = Color(0xFF9AABB8);

  /// 分割线
  static const Color divider = Color(0xFFE8E4DF);

  /// 书写区背景（米色书页感）
  static const Color writingAreaBg = Color(0xFFFDF9F3);

  /// 语义色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFE57373);

  /// AI 功能色
  static const Color aiPurple = Color(0xFF9C6FE4);
  static const Color aiPurpleLight = Color(0xFFE8DEF8);

  /// 图谱节点色
  static const Color nodeCharacter = Color(0xFF6B93C1);
  static const Color nodeLocation = Color(0xFF81C784);
  static const Color nodeEvent = Color(0xFFE57373);
  static const Color nodeEmotion = Color(0xFFBA68C8);
}

/// 圆角系统
class AppRadius {
  static const double sm = 6.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;

  // 快速访问 BorderRadius
  static BorderRadius borderSm = BorderRadius.circular(sm);
  static BorderRadius borderMd = BorderRadius.circular(md);
  static BorderRadius borderLg = BorderRadius.circular(lg);
  static BorderRadius borderXl = BorderRadius.circular(xl);
}

/// 阴影系统
class AppShadows {
  /// 轻阴影：普通卡片/列表项
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
  ];

  /// 中阴影：FAB/弹层
  static List<BoxShadow> elevatedShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 6)),
  ];

  /// 重阴影：Modal / BottomSheet
  static List<BoxShadow> modalShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 24, offset: const Offset(0, 12)),
  ];
}

/// 间距系统
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Typography 层级
class AppTypography {
  static TextStyle displayLarge = const TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, height: 1.3,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
  static TextStyle titleLarge = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4,
    color: AppColors.textPrimary,
  );
  static TextStyle titleMedium = const TextStyle(
    fontSize: 17, fontWeight: FontWeight.w600, height: 1.4,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.8,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
    color: AppColors.textSecondary,
  );
  static TextStyle labelMedium = const TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.4,
    color: AppColors.textSecondary,
  );
  static TextStyle caption = const TextStyle(
    fontSize: 11, fontWeight: FontWeight.w400, height: 1.4,
    color: AppColors.textTertiary,
  );
}

/// ============================================================
/// AppTheme — 全局 ThemeData
/// ============================================================
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.surfaceIvory,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryIndigo,
          onPrimary: Colors.white,
          secondary: AppColors.accentCoral,
          onSecondary: Colors.white,
          tertiary: AppColors.aiPurple,
          surface: AppColors.cardWhite,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          outline: AppColors.divider,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          backgroundColor: AppColors.surfaceIvory,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryIndigo),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderLg,
          ),
          margin: EdgeInsets.zero,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.accentCoral,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardWhite,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderMd,
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderMd,
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderMd,
            borderSide: const BorderSide(color: AppColors.primaryIndigo, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(color: AppColors.textTertiary),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryIndigo,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
            ),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentCoral,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
            ),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryIndigo,
            side: const BorderSide(color: AppColors.primaryIndigo),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
            ),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryIndigo,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceIvory,
          selectedColor: AppColors.primaryIndigo.withOpacity(0.15),
          labelStyle: AppTypography.labelMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          side: const BorderSide(color: AppColors.divider),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          titleTextStyle: AppTypography.titleLarge,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primaryIndigo,
          inactiveTrackColor: AppColors.primaryIndigo.withOpacity(0.2),
          thumbColor: AppColors.primaryIndigo,
          overlayColor: AppColors.primaryIndigo.withOpacity(0.12),
          trackHeight: 4,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryIndigo;
            }
            return AppColors.textTertiary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryIndigo.withOpacity(0.3);
            }
            return AppColors.divider;
          }),
        ),
      );
}

/// ============================================================
/// 通用 UI 组件库
/// ============================================================

/// 统一样式卡片
class MiaobiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool showShadow;

  const MiaobiCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderLg,
        boxShadow: showShadow ? AppShadows.cardShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderLg,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 空状态组件
class MiaobiEmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MiaobiEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<MiaobiEmptyState> createState() => _MiaobiEmptyStateState();
}

class _MiaobiEmptyStateState extends State<MiaobiEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 48,
                  color: AppColors.primaryIndigo.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle!,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (widget.actionLabel != null && widget.onAction != null) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: widget.onAction,
                    child: Text(widget.actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 骨架屏 Shimmer 效果
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppRadius.borderSm,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFECEEF0),
                Color(0xFFF8F8F8),
                Color(0xFFECEEF0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 卡片骨架屏
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderLg,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          ShimmerLoading(width: 60, height: 80, borderRadius: AppRadius.borderMd),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 140, height: 18, borderRadius: AppRadius.borderSm),
                const SizedBox(height: 8),
                ShimmerLoading(width: 80, height: 12, borderRadius: AppRadius.borderSm),
                const SizedBox(height: 8),
                ShimmerLoading(width: double.infinity, height: 12, borderRadius: AppRadius.borderSm),
                const SizedBox(height: 4),
                ShimmerLoading(width: 200, height: 12, borderRadius: AppRadius.borderSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// AI 结果区容器
class AiResultContainer extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final VoidCallback? onAccept;
  final VoidCallback? onDiscard;

  const AiResultContainer({
    super.key,
    required this.child,
    required this.isExpanded,
    this.onAccept,
    this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? 200 : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isExpanded ? 1.0 : 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.aiPurpleLight.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            border: Border.all(
              color: AppColors.aiPurple.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.aiPurple, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'AI 续写结果',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.aiPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (onAccept != null)
                        FilledButton(
                          onPressed: onAccept,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accentCoral,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          child: const Text('采纳'),
                        ),
                      const SizedBox(width: 8),
                      if (onDiscard != null)
                        TextButton(
                          onPressed: onDiscard,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text('丢弃'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: SingleChildScrollView(child: child)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 状态徽章
class MiaobiBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const MiaobiBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color?.withOpacity(0.12) ?? AppColors.primaryIndigo.withOpacity(0.1);
    final textColor = color ?? AppColors.primaryIndigo;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// 路由过渡动画
/// ============================================================

/// 页面右滑过渡
PageRouteBuilder slideRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );

/// 页面缩放过渡（详情→图谱）
PageRouteBuilder scaleRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
