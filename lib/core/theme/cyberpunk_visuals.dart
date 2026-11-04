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
    final surface = ClipPath(
      clipper: const CyberPanelClipper(),
      child: CustomPaint(
        painter: CyberSurfacePainter(tokens: tokens, variant: variant),
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : Material(
                type: MaterialType.transparency,
                child: InkWell(
                  customBorder: const HudPanelBorder(side: BorderSide.none),
                  onTap: onTap,
                  child: Padding(padding: padding, child: child),
                ),
              ),
      ),
    );
    return Semantics(
      label: semanticLabel,
      container: semanticLabel != null,
      child: Padding(padding: margin, child: surface),
    );
  }
}

/// The one chamfered contour shared by panel fills, clipping, borders and
/// their integrated corner accents.
abstract final class CyberPanelGeometry {
  static const chamfer = 14.0;

  static Path path(Rect rect, {double inset = 0}) {
    final left = rect.left + inset;
    final top = rect.top + inset;
    final right = rect.right - inset;
    final bottom = rect.bottom - inset;
    if (right <= left || bottom <= top) return Path();
    final bounds = Rect.fromLTRB(left, top, right, bottom);
    final cut = math.min(chamfer, math.min(bounds.width, bounds.height) * .18);
    return Path()
      ..moveTo(bounds.left + cut, bounds.top)
      ..lineTo(bounds.right - cut, bounds.top)
      ..lineTo(bounds.right, bounds.top + cut)
      ..lineTo(bounds.right, bounds.bottom - cut)
      ..lineTo(bounds.right - cut, bounds.bottom)
      ..lineTo(bounds.left + cut, bounds.bottom)
      ..lineTo(bounds.left, bounds.bottom - cut)
      ..lineTo(bounds.left, bounds.top + cut)
      ..close();
  }
}

class CyberPanelClipper extends CustomClipper<Path> {
  const CyberPanelClipper();

  @override
  Path getClip(Size size) => CyberPanelGeometry.path(Offset.zero & size);

  @override
  bool shouldReclip(covariant CyberPanelClipper oldClipper) => false;
}

class CyberSurfacePainter extends CustomPainter {
  const CyberSurfacePainter({required this.tokens, required this.variant});

  final CyberpunkTokens tokens;
  final CyberSurfaceVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final silhouette = CyberPanelGeometry.path(rect);
    final path = CyberPanelGeometry.path(rect, inset: .6);
    if (silhouette.computeMetrics().isEmpty) return;
    canvas.save();
    canvas.clipPath(silhouette);
    final base = switch (variant) {
      CyberSurfaceVariant.hud => tokens.panel,
      CyberSurfaceVariant.neonFrame => tokens.deepNight,
      CyberSurfaceVariant.glass => tokens.panel.withValues(alpha: .94),
      CyberSurfaceVariant.dataBlock => tokens.elevatedPanel,
      CyberSurfaceVariant.signal => tokens.panel,
      CyberSurfaceVariant.openGrid => tokens.deepNight,
    };
    canvas.drawPath(silhouette, Paint()..color = base);

    switch (variant) {
      case CyberSurfaceVariant.hud:
        _stroke(path, tokens.cyan.withValues(alpha: .78), 1, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.cyan,
          tokens.magenta,
          1.6,
          canvas,
        );
      case CyberSurfaceVariant.neonFrame:
        _stroke(path, tokens.steel.withValues(alpha: .55), .9, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.cyan,
          tokens.magenta,
          1.2,
          canvas,
        );
      case CyberSurfaceVariant.glass:
        _stroke(path, tokens.steel.withValues(alpha: .58), .9, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.cyan,
          tokens.magenta,
          1,
          canvas,
        );
      case CyberSurfaceVariant.dataBlock:
        _stroke(path, tokens.steel.withValues(alpha: .5), .9, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.blue,
          tokens.magenta,
          1,
          canvas,
        );
        final inset = math.min(7.0, rect.width * .06);
        final railTop = math.min(12.0, rect.height * .24);
        final railBottom = math.max(railTop, rect.height - railTop);
        if (railBottom - railTop > 3) {
          final rail = Path()
            ..moveTo(rect.left + inset, rect.top + railTop)
            ..lineTo(rect.left + inset, rect.top + railBottom);
          _stroke(rail, tokens.blue.withValues(alpha: .85), 1.2, canvas);
          canvas.drawCircle(
            Offset(rect.left + inset, rect.top + railTop),
            1.5,
            Paint()..color = tokens.cyan,
          );
        }
      case CyberSurfaceVariant.signal:
        _stroke(path, tokens.steel.withValues(alpha: .55), .9, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.cyan,
          tokens.magenta,
          1.35,
          canvas,
        );
        final guideY = rect.top + rect.height * .16;
        final guideStart = rect.left + math.min(14.0, rect.width * .12);
        final guideEnd = rect.right - math.min(14.0, rect.width * .12);
        if (guideEnd > guideStart) {
          final guide = Path()
            ..moveTo(guideStart, guideY)
            ..lineTo(guideEnd, guideY);
          _stroke(guide, tokens.cyan.withValues(alpha: .24), .8, canvas);
        }
      case CyberSurfaceVariant.openGrid:
        _drawGrid(canvas, rect.deflate(2));
        _stroke(path, tokens.steel.withValues(alpha: .36), .8, canvas);
        _drawCornerAccents(
          path,
          rect.deflate(.6),
          tokens.blue,
          tokens.magenta,
          1,
          canvas,
        );
    }
    canvas.restore();
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

  void _drawCornerAccents(
    Path contour,
    Rect bounds,
    Color primary,
    Color secondary,
    double width,
    Canvas canvas,
  ) {
    final metrics = contour.computeMetrics().toList(growable: false);
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final cut = math.min(
      CyberPanelGeometry.chamfer,
      math.min(bounds.width, bounds.height) * .18,
    );
    final bevelLength = cut * math.sqrt2;
    final topEdge = math.max(0.0, bounds.width - cut * 2);
    final rightEdge = math.max(0.0, bounds.height - cut * 2);
    final cornerStarts = <double>[
      topEdge,
      topEdge + bevelLength + rightEdge,
      topEdge * 2 + bevelLength * 2 + rightEdge,
      topEdge * 2 + bevelLength * 3 + rightEdge * 2,
    ];
    final accentLength = bevelLength * .72;
    for (var index = 0; index < cornerStarts.length; index++) {
      final center = cornerStarts[index] + bevelLength / 2;
      final start = (center - accentLength / 2).clamp(0.0, metric.length);
      final end = (center + accentLength / 2).clamp(0.0, metric.length);
      if (end <= start) continue;
      _stroke(
        metric.extractPath(start, end),
        index.isEven ? primary : secondary,
        width,
        canvas,
      );
    }
  }

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

class HudPanelBorder extends OutlinedBorder {
  const HudPanelBorder({
    super.side = const BorderSide(color: Color(0xFF00E5FF), width: 1),
  });

  Path _path(Rect rect) => CyberPanelGeometry.path(rect, inset: side.width / 2);

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      HudPanelBorder(side: side ?? this.side);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      CyberPanelGeometry.path(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      CyberPanelGeometry.path(rect, inset: side.width);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width <= 0) return;
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
