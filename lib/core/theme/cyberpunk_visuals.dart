import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mony_tokens.dart';

@immutable
class CyberpunkTokens extends ThemeExtension<CyberpunkTokens> {
  const CyberpunkTokens({
    required this.voidBlack,
    required this.deepNight,
    required this.panel,
    required this.elevatedPanel,
    required this.cyan,
    required this.blue,
    required this.magenta,
    required this.purple,
    required this.lime,
    required this.amber,
    required this.text,
    required this.mutedText,
    required this.steel,
    required this.success,
    required this.expense,
    required this.warning,
  });

  final Color voidBlack;
  final Color deepNight;
  final Color panel;
  final Color elevatedPanel;
  final Color cyan;
  final Color blue;
  final Color magenta;
  final Color purple;
  final Color lime;
  final Color amber;
  final Color text;
  final Color mutedText;
  final Color steel;
  final Color success;
  final Color expense;
  final Color warning;

  static const defaults = CyberpunkTokens(
    voidBlack: Color(0xFF0A0A12),
    deepNight: Color(0xFF10131D),
    panel: Color(0xFF151A26),
    elevatedPanel: Color(0xFF1B2233),
    cyan: Color(0xFF00E5FF),
    blue: Color(0xFF3A86FF),
    magenta: Color(0xFFFF2DA6),
    purple: Color(0xFF9D4EDD),
    lime: Color(0xFFB8FF3D),
    amber: Color(0xFFFFC857),
    text: Color(0xFFEAF7FF),
    mutedText: Color(0xFFB3C1D6),
    steel: Color(0xFF7F8CA3),
    success: Color(0xFFB8FF3D),
    expense: Color(0xFFFF2DA6),
    warning: Color(0xFFFFC857),
  );

  static CyberpunkTokens? maybeOf(BuildContext context) =>
      Theme.of(context).extension<CyberpunkTokens>();

  @override
  CyberpunkTokens copyWith({
    Color? voidBlack,
    Color? deepNight,
    Color? panel,
    Color? elevatedPanel,
    Color? cyan,
    Color? blue,
    Color? magenta,
    Color? purple,
    Color? lime,
    Color? amber,
    Color? text,
    Color? mutedText,
    Color? steel,
    Color? success,
    Color? expense,
    Color? warning,
  }) => CyberpunkTokens(
    voidBlack: voidBlack ?? this.voidBlack,
    deepNight: deepNight ?? this.deepNight,
    panel: panel ?? this.panel,
    elevatedPanel: elevatedPanel ?? this.elevatedPanel,
    cyan: cyan ?? this.cyan,
    blue: blue ?? this.blue,
    magenta: magenta ?? this.magenta,
    purple: purple ?? this.purple,
    lime: lime ?? this.lime,
    amber: amber ?? this.amber,
    text: text ?? this.text,
    mutedText: mutedText ?? this.mutedText,
    steel: steel ?? this.steel,
    success: success ?? this.success,
    expense: expense ?? this.expense,
    warning: warning ?? this.warning,
  );

  @override
  CyberpunkTokens lerp(ThemeExtension<CyberpunkTokens>? other, double t) {
    if (other is! CyberpunkTokens) return this;
    return CyberpunkTokens(
      voidBlack: Color.lerp(voidBlack, other.voidBlack, t)!,
      deepNight: Color.lerp(deepNight, other.deepNight, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      elevatedPanel: Color.lerp(elevatedPanel, other.elevatedPanel, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      magenta: Color.lerp(magenta, other.magenta, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      lime: Color.lerp(lime, other.lime, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      text: Color.lerp(text, other.text, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      steel: Color.lerp(steel, other.steel, t)!,
      success: Color.lerp(success, other.success, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

enum CyberSurfaceVariant { hud, neonFrame, glass, dataBlock, signal, openGrid }

class CyberSurface extends StatelessWidget {
  const CyberSurface({
    required this.child,
    this.variant = CyberSurfaceVariant.neonFrame,
    this.padding = const EdgeInsets.all(MonySpace.x4),
    this.margin = const EdgeInsets.all(4),
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final CyberSurfaceVariant variant;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = CyberpunkTokens.maybeOf(context) ?? CyberpunkTokens.defaults;
    final surface = CustomPaint(
      painter: CyberSurfacePainter(tokens: tokens, variant: variant),
      child: Padding(padding: padding, child: child),
    );
    return Semantics(
      label: semanticLabel,
      container: semanticLabel != null,
      child: Padding(
        padding: margin,
        child: onTap == null
            ? surface
            : InkWell(
                customBorder: const HudPanelBorder(),
                onTap: onTap,
                child: surface,
              ),
      ),
    );
  }
}

class CyberSurfacePainter extends CustomPainter {
  const CyberSurfacePainter({required this.tokens, required this.variant});

  final CyberpunkTokens tokens;
  final CyberSurfaceVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final path = _hudPath(rect.deflate(1));
    final base = switch (variant) {
      CyberSurfaceVariant.hud => tokens.panel,
      CyberSurfaceVariant.neonFrame => tokens.deepNight,
      CyberSurfaceVariant.glass => tokens.panel.withValues(alpha: .94),
      CyberSurfaceVariant.dataBlock => tokens.elevatedPanel,
      CyberSurfaceVariant.signal => tokens.panel,
      CyberSurfaceVariant.openGrid => tokens.deepNight,
    };
    canvas.drawPath(path, Paint()..color = base);

    switch (variant) {
      case CyberSurfaceVariant.hud:
        final glowPath = _hudPath(rect.deflate(4));
        canvas.drawPath(
          glowPath,
          Paint()
            ..color = tokens.cyan.withValues(alpha: .17)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
        _stroke(path, tokens.cyan.withValues(alpha: .9), 1.15, canvas);
        _cornerBrackets(canvas, rect.deflate(5), tokens.cyan, 17, 2);
      case CyberSurfaceVariant.neonFrame:
        _stroke(path, tokens.steel.withValues(alpha: .48), .8, canvas);
        _cornerBrackets(canvas, rect.deflate(4), tokens.cyan, 13, 1.5);
        _stroke(
          _bottomSignal(rect, 0.72),
          tokens.magenta.withValues(alpha: .85),
          1.4,
          canvas,
        );
      case CyberSurfaceVariant.glass:
        _stroke(path, tokens.steel.withValues(alpha: .55), .8, canvas);
        _stroke(
          _topSignal(rect, .42),
          tokens.cyan.withValues(alpha: .72),
          1.1,
          canvas,
        );
      case CyberSurfaceVariant.dataBlock:
        _stroke(path, tokens.steel.withValues(alpha: .42), .7, canvas);
        final leftRail = Path()
          ..moveTo(rect.left + 5, rect.top + 12)
          ..lineTo(rect.left + 5, rect.bottom - 12);
        _stroke(leftRail, tokens.blue.withValues(alpha: .9), 1.7, canvas);
        canvas.drawRect(
          Rect.fromLTWH(rect.left + 4, rect.top + 12, 3, 3),
          Paint()..color = tokens.cyan,
        );
      case CyberSurfaceVariant.signal:
        _stroke(path, tokens.steel.withValues(alpha: .52), .8, canvas);
        _stroke(_bottomSignal(rect, .68), tokens.cyan, 1.6, canvas);
        _stroke(_topSignal(rect, .26), tokens.magenta, .9, canvas);
      case CyberSurfaceVariant.openGrid:
        _drawGrid(canvas, rect);
        _cornerBrackets(canvas, rect.deflate(2), tokens.blue, 10, 1.2);
    }
  }

  void _drawGrid(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = tokens.blue.withValues(alpha: .12)
      ..strokeWidth = .6;
    const spacing = 18.0;
    for (var x = rect.left + spacing; x < rect.right; x += spacing) {
      canvas.drawLine(
        Offset(x, rect.top + 2),
        Offset(x, rect.bottom - 2),
        paint,
      );
    }
    for (var y = rect.top + spacing; y < rect.bottom; y += spacing) {
      canvas.drawLine(
        Offset(rect.left + 2, y),
        Offset(rect.right - 2, y),
        paint,
      );
    }
  }

  void _cornerBrackets(
    Canvas canvas,
    Rect rect,
    Color color,
    double length,
    double width,
  ) {
    final paths = [
      Path()
        ..moveTo(rect.left + length, rect.top)
        ..lineTo(rect.left + 4, rect.top)
        ..lineTo(rect.left, rect.top + 4)
        ..lineTo(rect.left, rect.top + length),
      Path()
        ..moveTo(rect.right - length, rect.top)
        ..lineTo(rect.right - 4, rect.top)
        ..lineTo(rect.right, rect.top + 4)
        ..lineTo(rect.right, rect.top + length),
      Path()
        ..moveTo(rect.left, rect.bottom - length)
        ..lineTo(rect.left, rect.bottom - 4)
        ..lineTo(rect.left + 4, rect.bottom)
        ..lineTo(rect.left + length, rect.bottom),
      Path()
        ..moveTo(rect.right - length, rect.bottom)
        ..lineTo(rect.right - 4, rect.bottom)
        ..lineTo(rect.right, rect.bottom - 4)
        ..lineTo(rect.right, rect.bottom - length),
    ];
    for (var index = 0; index < paths.length; index++) {
      _stroke(
        paths[index],
        index.isOdd ? tokens.magenta.withValues(alpha: .82) : color,
        width,
        canvas,
      );
    }
  }

  Path _topSignal(Rect rect, double fraction) => Path()
    ..moveTo(rect.left + 12, rect.top + 2)
    ..lineTo(rect.left + math.max(14, rect.width * fraction), rect.top + 2);

  Path _bottomSignal(Rect rect, double fraction) => Path()
    ..moveTo(rect.left + 12, rect.bottom - 2)
    ..lineTo(rect.left + math.max(14, rect.width * fraction), rect.bottom - 2);

  void _stroke(Path path, Color color, double width, Canvas canvas) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(covariant CyberSurfacePainter oldDelegate) =>
      tokens != oldDelegate.tokens || variant != oldDelegate.variant;
}

Path _hudPath(Rect rect) {
  final cut = math.min(14.0, math.min(rect.width, rect.height) * .18);
  return Path()
    ..moveTo(rect.left + cut, rect.top)
    ..lineTo(rect.right - cut, rect.top)
    ..lineTo(rect.right, rect.top + cut)
    ..lineTo(rect.right, rect.bottom - cut)
    ..lineTo(rect.right - cut, rect.bottom)
    ..lineTo(rect.left + cut, rect.bottom)
    ..lineTo(rect.left, rect.bottom - cut)
    ..lineTo(rect.left, rect.top + cut)
    ..close();
}

class HudPanelBorder extends OutlinedBorder {
  const HudPanelBorder({
    super.side = const BorderSide(color: Color(0xFF00E5FF), width: 1),
  });

  Path _path(Rect rect) => _hudPath(rect.deflate(side.width / 2));

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      HudPanelBorder(side: side ?? this.side);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _path(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _hudPath(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
      _path(rect),
      Paint()
        ..color = side.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => HudPanelBorder(side: side.scale(t));
}

class CyberBackdrop extends StatelessWidget {
  const CyberBackdrop({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(
        painter: _CyberBackdropPainter(
          CyberpunkTokens.maybeOf(context) ?? CyberpunkTokens.defaults,
        ),
      ),
      child,
    ],
  );
}

class _CyberBackdropPainter extends CustomPainter {
  const _CyberBackdropPainter(this.tokens);
  final CyberpunkTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tokens.voidBlack, tokens.deepNight, tokens.voidBlack],
        ).createShader(rect),
    );
    final grid = Paint()
      ..color = tokens.blue.withValues(alpha: .07)
      ..strokeWidth = .6;
    const spacing = 36.0;
    for (var x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(covariant _CyberBackdropPainter oldDelegate) =>
      tokens != oldDelegate.tokens;
}

class CyberNavigationItem {
  const CyberNavigationItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class CyberBottomNavigationBar extends StatelessWidget {
  const CyberBottomNavigationBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<CyberNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = CyberpunkTokens.maybeOf(context) ?? CyberpunkTokens.defaults;
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: ShapeDecoration(
        color: tokens.panel,
        shape: HudPanelBorder(
          side: BorderSide(color: tokens.steel.withValues(alpha: .75)),
        ),
        shadows: [
          BoxShadow(
            color: tokens.cyan.withValues(alpha: .12),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++)
            Expanded(
              child: Semantics(
                button: true,
                selected: selectedIndex == index,
                label: items[index].label,
                child: Tooltip(
                  message: items[index].label,
                  child: InkWell(
                    customBorder: const HudPanelBorder(),
                    onTap: () => onSelected(index),
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 38,
                            height: 31,
                            decoration: selectedIndex == index
                                ? ShapeDecoration(
                                    color: tokens.cyan.withValues(alpha: .14),
                                    shape: HudPanelBorder(
                                      side: BorderSide(
                                        color: tokens.cyan.withValues(
                                          alpha: .78,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  )
                                : const ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: HudPanelBorder(
                                      side: BorderSide.none,
                                    ),
                                  ),
                            child: Icon(
                              items[index].icon,
                              size: 20,
                              color: selectedIndex == index
                                  ? tokens.cyan
                                  : tokens.mutedText,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: selectedIndex == index ? 24 : 9,
                            height: 2,
                            color: selectedIndex == index
                                ? tokens.magenta
                                : tokens.steel.withValues(alpha: .4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
