import 'package:flutter/material.dart';

/// ============================================================
/// 像素可爱风 — Pastel Macaron + Pixel Art
/// ============================================================
class CutePixelColors {
  // === 背景色系 ===
  static const Color bg = Color(0xFFF8F5FF);          // 淡紫白（主背景）
  static const Color bg2 = Color(0xFFEEE6FF);         // 浅薰衣草（卡片）
  static const Color bg3 = Color(0xFFE0D4FF);         // 稍深薰衣草（输入框）
  static const Color bgCard = Color(0xFFFFF8FE);      // 奶白色（卡片背景）

  // === 主色调 — 马卡龙色系 ===
  static const Color pink = Color(0xFFFFB5D9);       // 马卡龙粉
  static const Color pinkDark = Color(0xFFFF8EC4);    // 深粉（按钮按下）
  static const Color mint = Color(0xFF98E4C9);        // 薄荷绿
  static const Color mintDark = Color(0xFF6DD4B0);    // 深薄荷
  static const Color yellow = Color(0xFFFFE5A0);      // 奶黄
  static const Color lavender = Color(0xFFB8A5FF);    // 薰衣草紫

  // === 旧代码兼容别名 ===
  static const Color blue = Color(0xFFB8A5FF);         // lavender 替代
  static const Color blueBright = Color(0xFFD4BCFF);  // 亮紫
  static const Color blueLight = Color(0xFFB8A5FF);    // lavender 别名
  static const Color orange = Color(0xFFFFCBA4);       // 蜜桃/橙色
  static const Color red = Color(0xFFFF8A80);         // 珊瑚红
  static const Color redDark = Color(0xFFFF6B6B);     // 深红
  static const Color green = Color(0xFF98E4C9);       // mint 别名

  // === 强调色 ===
  static const Color coral = Color(0xFFFF8A80);        // 珊瑚红
  static const Color sky = Color(0xFFA8D8FF);         // 天空蓝
  static const Color peach = Color(0xFFFFCBA4);       // 蜜桃色

  // === 文字色 ===
  static const Color text = Color(0xFF5D4E6D);        // 深紫灰（主文字）
  static const Color textLight = Color(0xFF5D4E6D);   // textLight 兼容旧代码
  static const Color textMuted = Color(0xFF9B8AAE);   // 浅紫灰（次要文字）

  // === 边框/装饰 — 像素风格但柔和 ===
  static const Color borderLight = Color(0xFFFFFFFF); // 白色亮边
  static const Color borderDark = Color(0xFFD4C5E8);   // 紫色暗边
  static const Color shadowColor = Color(0xFFD4C5E8);  // 阴影色

  // === 语义色 ===
  static const Color success = mint;
  static const Color warning = yellow;
  static const Color error = coral;
  static const Color info = sky;

  // ============================================================
  // 装饰器
  // ============================================================

  /// 像素风卡片（圆角 + 柔和3D效果）
  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
    color: color ?? bgCard,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderDark, width: 2),
    boxShadow: const [
      BoxShadow(color: borderLight, offset: Offset(-3, -3)),  // 左上亮边
      BoxShadow(color: shadowColor, offset: Offset(3, 3)),    // 右下暗边
    ],
  );

  /// 像素风按钮
  static BoxDecoration buttonDecoration({
    Color color = pink,
    bool pressed = false,
  }) {
    return BoxDecoration(
      color: pressed ? color.withOpacity(0.8) : color,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderDark, width: 2),
      boxShadow: pressed
          ? []
          : [
              const BoxShadow(color: borderLight, offset: Offset(-2, -2)),
              BoxShadow(color: shadowColor.withOpacity(0.5), offset: const Offset(2, 2)),
            ],
    );
  }

  /// 像素风对话框
  static BoxDecoration dialogDecoration() => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderDark, width: 3),
    boxShadow: const [
      BoxShadow(color: borderLight, offset: Offset(-4, -4)),
      BoxShadow(color: shadowColor, offset: Offset(4, 4)),
    ],
  );

  /// 像素风输入框
  static BoxDecoration inputDecoration({bool focused = false}) => BoxDecoration(
    color: bg3,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: focused ? lavender : borderDark,
      width: 2,
    ),
  );

  /// 进度条（像素方块风格）
  static BoxDecoration progressBlock({bool filled = false}) => BoxDecoration(
    color: filled ? pink : bg3,
    borderRadius: BorderRadius.circular(2),
    border: Border.all(color: filled ? pinkDark : borderDark, width: 1),
  );
}

// ============================================================
/// 可爱像素按钮 Widget
// ============================================================
class CutePixelButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;
  final String? emoji;

  const CutePixelButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = CutePixelColors.pink,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.emoji,
  });

  @override
  State<CutePixelButton> createState() => _CutePixelButtonState();
}

class _CutePixelButtonState extends State<CutePixelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: _pressed
            ? (Matrix4.identity()..translate(2.0, 2.0))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        padding: widget.padding,
        decoration: CutePixelColors.buttonDecoration(
          color: enabled ? widget.color : CutePixelColors.bg3,
          pressed: _pressed,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.emoji != null) ...[
              Text(widget.emoji!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ],
            Text(
              widget.label,
              style: TextStyle(
                color: enabled ? CutePixelColors.text : CutePixelColors.textMuted,
                fontFamily: 'monospace',
                fontFamilyFallback: const ['Noto Sans SC', 'PingFang SC', 'sans-serif'],
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PixelButton 别名（兼容旧代码）
typedef PixelButton = CutePixelButton;

// ============================================================
/// 可爱像素进度条
// ============================================================
class CutePixelProgressBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final int blocks;
  final Color filledColor;
  final Color emptyColor;
  final double blockWidth;
  final double blockHeight;

  const CutePixelProgressBar({
    super.key,
    required this.progress,
    this.blocks = 8,
    this.filledColor = CutePixelColors.pink,
    this.emptyColor = CutePixelColors.bg3,
    this.blockWidth = 10,
    this.blockHeight = 14,
  });

  @override
  Widget build(BuildContext context) {
    final filled = (progress * blocks).ceil();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(blocks, (i) {
        final isFilled = i < filled;
        return Container(
          width: blockWidth,
          height: blockHeight,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: isFilled ? filledColor : emptyColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isFilled
                  ? filledColor.withOpacity(0.7)
                  : CutePixelColors.borderDark,
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}

// ============================================================
/// 像素可爱风 SnackBar
// ============================================================
void showCuteSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? CutePixelColors.coral : CutePixelColors.bg2,
      content: Row(
        children: [
          Text(
            isError ? '💔' : '💖',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isError ? Colors.white : CutePixelColors.text,
                fontFamily: 'monospace',
                fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isError ? CutePixelColors.error : CutePixelColors.borderDark,
          width: 2,
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

// ============================================================
/// 向后兼容 GameColors 静态类
// ============================================================
class GameColors {
  GameColors._();

  static const Color bg = CutePixelColors.bg;
  static const Color bg2 = CutePixelColors.bg2;
  static const Color bg3 = CutePixelColors.bg3;
  static const Color bgCard = CutePixelColors.bgCard;
  static const Color pink = CutePixelColors.pink;
  static const Color pinkDark = CutePixelColors.pinkDark;
  static const Color mint = CutePixelColors.mint;
  static const Color mintDark = CutePixelColors.mintDark;
  static const Color yellow = CutePixelColors.yellow;
  static const Color lavender = CutePixelColors.lavender;
  static const Color coral = CutePixelColors.coral;
  static const Color sky = CutePixelColors.sky;
  static const Color peach = CutePixelColors.peach;
  static const Color text = CutePixelColors.text;
  static const Color textLight = CutePixelColors.textLight;
  static const Color textMuted = CutePixelColors.textMuted;
  static const Color borderLight = CutePixelColors.borderLight;
  static const Color borderDark = CutePixelColors.borderDark;
  static const Color shadowColor = CutePixelColors.shadowColor;
  static const Color success = CutePixelColors.success;
  static const Color warning = CutePixelColors.warning;
  static const Color error = CutePixelColors.error;
  static const Color info = CutePixelColors.info;
  // 旧别名
  static const Color blue = CutePixelColors.blue;
  static const Color blueBright = CutePixelColors.blueBright;
  static const Color blueLight = CutePixelColors.blueLight;
  static const Color orange = CutePixelColors.orange;
  static const Color red = CutePixelColors.red;
  static const Color redDark = CutePixelColors.redDark;
  static const Color green = CutePixelColors.green;

  static BoxDecoration cardDecoration({Color? color}) => CutePixelColors.cardDecoration(color: color);
  static BoxDecoration buttonDecoration({Color color = CutePixelColors.pink, bool pressed = false}) => CutePixelColors.buttonDecoration(color: color, pressed: pressed);
  static BoxDecoration dialogDecoration() => CutePixelColors.dialogDecoration();
  static BoxDecoration inputDecoration({bool focused = false}) => CutePixelColors.inputDecoration(focused: focused);
}

void showPixelSnackBar(BuildContext context, String message, {bool isError = false}) {
  showCuteSnackBar(context, message, isError: isError);
}
