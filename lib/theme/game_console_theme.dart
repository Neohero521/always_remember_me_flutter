import 'package:flutter/material.dart';

/// 像素游戏风配色（GBA/SP 风格）
class GameColors {
  // === 主背景 ===
  static const Color bg = Color(0xFF1a1c2c);       // 深蓝黑（主背景）
  static const Color bg2 = Color(0xFF333c57);        // 灰蓝（次级卡片/面板）
  static const Color bg3 = Color(0xFF262b44);        // 中等深度背景（输入框/凹陷区域）

  // === 主色调 ===
  static const Color blue = Color(0xFF41a6f6);       // 像素蓝（主要按钮/链接）
  static const Color blueLight = Color(0xFF5fcde4);  // 浅蓝（hover/次要强调）
  static const Color blueBright = Color(0xFF73eff7);  // 亮青（高亮/选中状态）

  // === 强调色 ===
  static const Color orange = Color(0xFFf77622);      // 橙色（警告/重要操作）
  static const Color red = Color(0xFFff0044);        // 像素红（错误/危险）
  static const Color redDark = Color(0xFFb13f42);    // 暗红

  // === 文字色 ===
  static const Color textLight = Color(0xFFd4f0f8);   // 亮白（主要文字）
  static const Color textMuted = Color(0xFF94b0c2);  // 灰蓝白（次要文字）

  // === 语义色 ===
  static const Color green = Color(0xFF38b764);      // 像素绿
  static const Color yellow = Color(0xFFfeae34);     // 像素黄
  static const Color pink = Color(0xFFff77a8);       // 像素粉

  // === 边框/装饰 ===
  static const Color borderLight = Color(0xFF566c86); // 像素边框（亮边）
  static const Color borderDark = Color(0xFF0d0e14);  // 像素边框（暗边，3D 效果用）
  static const Color shadowColor = Color(0xFF0d0e14);  // 阴影色

  /// 像素风格 Card 装饰
  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
    color: color ?? bg2,
    border: Border.all(color: borderLight, width: 2),
    borderRadius: BorderRadius.circular(4),
    boxShadow: const [
      BoxShadow(color: borderLight, offset: Offset(-2, -2)),  // 亮边（3D 凸起）
      BoxShadow(color: shadowColor, offset: Offset(2, 2)),   // 暗边
    ],
  );

  /// 像素风格按钮装饰（默认蓝色凸起）
  static BoxDecoration buttonDecoration({
    Color color = blue,
    bool pressed = false,
  }) {
    final bgColor = pressed ? Color(color.value - 0x00202020) : color;
    return BoxDecoration(
      color: bgColor,
      border: Border.all(color: borderLight, width: 3),
      boxShadow: pressed
          ? [
              const BoxShadow(color: shadowColor, offset: Offset(-2, -2)),
              const BoxShadow(color: borderLight, offset: Offset(2, 2)),
            ]
          : [
              const BoxShadow(color: borderLight, offset: Offset(-2, -2)),
              const BoxShadow(color: shadowColor, offset: Offset(2, 2)),
            ],
    );
  }

  /// 像素风格对话框装饰
  static BoxDecoration dialogDecoration() => BoxDecoration(
    color: bg2,
    border: Border.all(color: borderLight, width: 3),
    borderRadius: BorderRadius.circular(4),
    boxShadow: const [
      BoxShadow(color: borderLight, offset: Offset(-3, -3)),
      BoxShadow(color: shadowColor, offset: Offset(3, 3)),
    ],
  );

  /// 像素风格输入框装饰
  static BoxDecoration inputDecoration({bool focused = false}) => BoxDecoration(
    color: bg3,
    border: Border.all(
      color: focused ? blueBright : borderLight,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(4),
  );
}

/// 像素风格按钮 Widget
class PixelButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;

  const PixelButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = GameColors.blue,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: Container(
        padding: widget.padding,
        decoration: GameColors.buttonDecoration(
          color: enabled ? widget.color : GameColors.bg3,
          pressed: _pressed,
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: enabled ? GameColors.textLight : GameColors.textMuted,
            fontFamily: 'monospace',
            fontFamilyFallback: const ['Noto Sans SC', 'PingFang SC', 'sans-serif'],
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// 像素风格 SnackBar
void showPixelSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? GameColors.redDark : GameColors.bg2,
      content: Row(
        children: [
          if (isError)
            const Text('❌ ', style: TextStyle(fontSize: 16))
          else
            const Text('✅ ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: GameColors.textLight,
                fontFamily: 'monospace',
                fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const Border(
        bottom: BorderSide(color: GameColors.borderLight, width: 2),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
