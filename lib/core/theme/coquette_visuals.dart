import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mony_tokens.dart';

/// Semantic colors and details reserved for the Coquette Bloom identity.
@immutable
class CoquetteThemeColors extends ThemeExtension<CoquetteThemeColors> {
  const CoquetteThemeColors({
    required this.blush,
    required this.rose,
    required this.dustyRose,
    required this.lavender,
    required this.cream,
    required this.ivory,
    required this.berry,
    required this.cocoa,
    required this.mauve,
    required this.champagne,
    required this.income,
    required this.expense,
  });

  final Color blush;
  final Color rose;
  final Color dustyRose;
  final Color lavender;
  final Color cream;
  final Color ivory;
  final Color berry;
  final Color cocoa;
  final Color mauve;
  final Color champagne;
  final Color income;
  final Color expense;

  static const defaults = CoquetteThemeColors(
    blush: Color(0xFFF2B8C6),
    rose: Color(0xFFE99AAF),
    dustyRose: Color(0xFFC87996),
    lavender: Color(0xFFC8B6E8),
    cream: Color(0xFFFFF5EE),
    ivory: Color(0xFFFFF9F5),
    berry: Color(0xFFA74770),
    cocoa: Color(0xFF493542),
    mauve: Color(0xFF8F7188),
    champagne: Color(0xFFD8B98A),
    income: Color(0xFF557A68),
    expense: Color(0xFFA74770),
  );

  static CoquetteThemeColors? maybeOf(BuildContext context) =>
      Theme.of(context).extension<CoquetteThemeColors>();

  @override
  CoquetteThemeColors copyWith({
    Color? blush,
    Color? rose,
    Color? dustyRose,
    Color? lavender,
    Color? cream,
    Color? ivory,
    Color? berry,
    Color? cocoa,
    Color? mauve,
    Color? champagne,
    Color? income,
    Color? expense,
  }) => CoquetteThemeColors(
    blush: blush ?? this.blush,
    rose: rose ?? this.rose,
    dustyRose: dustyRose ?? this.dustyRose,
    lavender: lavender ?? this.lavender,
    cream: cream ?? this.cream,
    ivory: ivory ?? this.ivory,
    berry: berry ?? this.berry,
    cocoa: cocoa ?? this.cocoa,
    mauve: mauve ?? this.mauve,
    champagne: champagne ?? this.champagne,
    income: income ?? this.income,
    expense: expense ?? this.expense,
  );

  @override
  CoquetteThemeColors lerp(
    ThemeExtension<CoquetteThemeColors>? other,
    double t,
  ) {
    if (other is! CoquetteThemeColors) return this;
    return CoquetteThemeColors(
      blush: Color.lerp(blush, other.blush, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
      dustyRose: Color.lerp(dustyRose, other.dustyRose, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      cream: Color.lerp(cream, other.cream, t)!,
      ivory: Color.lerp(ivory, other.ivory, t)!,
      berry: Color.lerp(berry, other.berry, t)!,
      cocoa: Color.lerp(cocoa, other.cocoa, t)!,
      mauve: Color.lerp(mauve, other.mauve, t)!,
      champagne: Color.lerp(champagne, other.champagne, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
    );
  }
}

enum CoquetteSurfaceVariant {
  petal,
  scalloped,
  ribbon,
  pearl,
  incomePearl,
  expensePearl,
  floating,
  editorial,
}

/// Purposeful surface vocabulary used by Coquette Bloom screens.
class CoquetteSurface extends StatelessWidget {
  const CoquetteSurface({
    required this.child,
    this.variant = CoquetteSurfaceVariant.pearl,
    this.padding = const EdgeInsets.all(MonySpace.x4),
    this.margin = const EdgeInsets.all(4),
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final CoquetteSurfaceVariant variant;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = CoquetteThemeColors.maybeOf(context);
    if (colors == null) {
      return Card(
        margin: margin,
        child: Padding(padding: padding, child: child),
      );
    }
    final surface = CustomPaint(
      painter: CoquetteSurfacePainter(
        colors: colors,
        variant: variant,
        dark: Theme.of(context).brightness == Brightness.dark,
      ),
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
                customBorder: const CoquettePetalBorder(),
                onTap: onTap,
                child: surface,
              ),
      ),
    );
  }
}

class CoquetteSurfacePainter extends CustomPainter {
  const CoquetteSurfacePainter({
    required this.colors,
    required this.variant,
    required this.dark,
  });

  final CoquetteThemeColors colors;
  final CoquetteSurfaceVariant variant;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = dark ? const Color(0xFF302631) : colors.ivory;
    final path = _petalPath(rect);
    switch (variant) {
      case CoquetteSurfaceVariant.petal:
        canvas.drawPath(
          path,
          Paint()..color = dark ? const Color(0xFF493542) : colors.cream,
        );
        _stroke(path, colors.dustyRose.withValues(alpha: .64), 1.15, canvas);
        _flowerCorner(
          canvas,
          Offset(rect.right - 23, rect.top + 22),
          colors.rose,
        );
      case CoquetteSurfaceVariant.scalloped:
        canvas.drawPath(
          path,
          Paint()..color = dark ? const Color(0xFF302631) : colors.ivory,
        );
        _scallopedFrame(canvas, rect, colors.dustyRose.withValues(alpha: .76));
        _pearl(
          canvas,
          Offset(rect.right - 14, rect.top + 14),
          colors.champagne,
        );
      case CoquetteSurfaceVariant.ribbon:
        canvas.drawPath(
          path,
          Paint()..color = dark ? const Color(0xFF342B36) : colors.cream,
        );
        _ribbon(canvas, rect);
        _stroke(
          Path()
            ..moveTo(rect.left + 18, rect.top + 1)
            ..lineTo(rect.right - 23, rect.top + 1),
          colors.champagne.withValues(alpha: .8),
          .8,
          canvas,
        );
      case CoquetteSurfaceVariant.pearl:
      case CoquetteSurfaceVariant.incomePearl:
      case CoquetteSurfaceVariant.expensePearl:
        final fill = dark ? base : colors.ivory;
        canvas.drawPath(path, Paint()..color = fill);
        final outline = variant == CoquetteSurfaceVariant.incomePearl
            ? colors.income
            : variant == CoquetteSurfaceVariant.expensePearl
            ? colors.expense
            : colors.mauve.withValues(alpha: .65);
        _stroke(path, outline.withValues(alpha: .62), 1.0, canvas);
        _pearl(canvas, Offset(rect.left + 15, rect.top + 13), colors.champagne);
        _pearl(canvas, Offset(rect.right - 15, rect.bottom - 13), colors.blush);
        if (variant != CoquetteSurfaceVariant.pearl) {
          final accent = Path()
            ..moveTo(rect.left + 2, rect.top + 18)
            ..cubicTo(
              rect.left - 1,
              rect.center.dy,
              rect.left + 3,
              rect.bottom - 18,
              rect.left + 1,
              rect.bottom - 7,
            );
          _stroke(accent, outline, 2.4, canvas);
        }
      case CoquetteSurfaceVariant.floating:
        canvas.drawPath(
          path,
          Paint()
            ..color = dark ? const Color(0xFF392F3B) : colors.cream
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        canvas.drawPath(
          path,
          Paint()
            ..color = dark ? const Color(0xFF463849) : const Color(0xFFFDF5FA),
        );
        _pearl(canvas, Offset(rect.right - 18, rect.top + 16), colors.ivory);
      case CoquetteSurfaceVariant.editorial:
        _ribbon(canvas, rect, subtle: true);
        final flourish = Path()
          ..moveTo(rect.left + 8, rect.bottom - 3)
          ..cubicTo(
            rect.left + rect.width * .28,
            rect.bottom - 1,
            rect.left + rect.width * .48,
            rect.bottom - 5,
            rect.left + rect.width * .68,
            rect.bottom - 2,
          );
        _stroke(flourish, colors.dustyRose.withValues(alpha: .65), 1.5, canvas);
        _flowerCorner(
          canvas,
          Offset(rect.right - 17, rect.top + 17),
          colors.lavender,
        );
    }
  }

  Path _petalPath(Rect r) => Path()
    ..moveTo(r.left + 15, r.top + 1)
    ..cubicTo(r.left + 5, r.top - 1, r.left, r.top + 8, r.left + 1, r.top + 20)
    ..lineTo(r.left + 1, r.bottom - 18)
    ..cubicTo(
      r.left - 1,
      r.bottom - 5,
      r.left + 9,
      r.bottom + 1,
      r.left + 22,
      r.bottom - 1,
    )
    ..lineTo(r.right - 23, r.bottom - 1)
    ..cubicTo(
      r.right - 7,
      r.bottom + 1,
      r.right + 1,
      r.bottom - 8,
      r.right - 1,
      r.bottom - 22,
    )
    ..lineTo(r.right - 1, r.top + 20)
    ..cubicTo(
      r.right + 1,
      r.top + 6,
      r.right - 9,
      r.top - 1,
      r.right - 23,
      r.top + 1,
    )
    ..close();

  void _scallopedFrame(Canvas canvas, Rect r, Color color) {
    final path = Path()..moveTo(r.left + 8, r.top + 2);
    const scallops = 18;
    final span = (r.width - 16) / scallops;
    for (var i = 0; i < scallops; i++) {
      final x = r.left + 8 + span * i;
      path.quadraticBezierTo(x + span / 2, r.top - 1.4, x + span, r.top + 2);
    }
    path
      ..lineTo(r.right - 2, r.bottom - 15)
      ..quadraticBezierTo(r.right - 2, r.bottom - 2, r.right - 15, r.bottom - 2)
      ..lineTo(r.left + 16, r.bottom - 2)
      ..quadraticBezierTo(r.left + 2, r.bottom - 2, r.left + 2, r.bottom - 16)
      ..lineTo(r.left + 2, r.top + 14)
      ..quadraticBezierTo(r.left + 2, r.top + 2, r.left + 8, r.top + 2);
    _stroke(path, color, 1.05, canvas);
  }

  void _ribbon(Canvas canvas, Rect rect, {bool subtle = false}) {
    final width = subtle ? 2.0 : 8.0;
    final ribbon = Path()
      ..moveTo(rect.left + 1, rect.top + 13)
      ..cubicTo(
        rect.left + width,
        rect.top + 22,
        rect.left,
        rect.center.dy,
        rect.left + width,
        rect.bottom - 13,
      );
    _stroke(
      ribbon,
      colors.rose.withValues(alpha: subtle ? .62 : .95),
      width,
      canvas,
    );
    if (!subtle) {
      final thread = Path()
        ..moveTo(rect.left + width + 3, rect.top + 15)
        ..lineTo(rect.left + width + 3, rect.bottom - 15);
      _stroke(thread, colors.champagne.withValues(alpha: .68), .7, canvas);
    }
  }

  void _flowerCorner(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color.withValues(alpha: .62);
    for (var petal = 0; petal < 4; petal++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(petal * math.pi / 2);
      canvas.drawOval(const Rect.fromLTWH(-2.5, -8, 5, 8), paint);
      canvas.restore();
    }
    canvas.drawCircle(center, 1.8, Paint()..color = colors.champagne);
  }

  void _pearl(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.4),
    );
    canvas.drawCircle(
      center.translate(-.8, -.8),
      1.1,
      Paint()..color = colors.ivory,
    );
  }

  void _stroke(Path path, Color color, double width, Canvas canvas) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CoquetteSurfacePainter oldDelegate) =>
      colors != oldDelegate.colors ||
      variant != oldDelegate.variant ||
      dark != oldDelegate.dark;
}

/// Soft asymmetric card silhouette for Material components.
class CoquettePetalBorder extends OutlinedBorder {
  const CoquettePetalBorder({
    super.side = const BorderSide(color: Color(0xFFC87996), width: 1),
  });

  Path _path(Rect r) => Path()
    ..moveTo(r.left + 18, r.top + 1)
    ..cubicTo(r.left + 6, r.top - 1, r.left, r.top + 8, r.left + 1, r.top + 21)
    ..lineTo(r.left + 1, r.bottom - 19)
    ..cubicTo(
      r.left - 1,
      r.bottom - 6,
      r.left + 9,
      r.bottom + 1,
      r.left + 22,
      r.bottom - 1,
    )
    ..lineTo(r.right - 21, r.bottom - 1)
    ..cubicTo(
      r.right - 7,
      r.bottom + 1,
      r.right + 1,
      r.bottom - 9,
      r.right - 1,
      r.bottom - 22,
    )
    ..lineTo(r.right - 1, r.top + 20)
    ..cubicTo(
      r.right + 1,
      r.top + 6,
      r.right - 9,
      r.top - 1,
      r.right - 22,
      r.top + 1,
    )
    ..close();

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      CoquettePetalBorder(side: side ?? this.side);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _path(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _path(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
      _path(rect.deflate(side.width / 2)),
      Paint()
        ..color = side.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => CoquettePetalBorder(side: side.scale(t));
}

class CoquettePearlInputBorder extends OutlineInputBorder {
  const CoquettePearlInputBorder({
    super.borderSide,
    super.borderRadius = const BorderRadius.all(Radius.circular(16)),
    super.gapPadding,
  });

  @override
  CoquettePearlInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) => CoquettePearlInputBorder(
    borderSide: borderSide ?? this.borderSide,
    borderRadius: borderRadius ?? this.borderRadius,
    gapPadding: gapPadding ?? this.gapPadding,
  );

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection? textDirection,
  }) {
    super.paint(
      canvas,
      rect,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );
    if (borderSide.style == BorderStyle.none) return;
    final pearlPaint = Paint()..color = borderSide.color.withValues(alpha: .72);
    canvas.drawCircle(Offset(rect.right - 13, rect.top + 1), 1.6, pearlPaint);
    canvas.drawCircle(
      Offset(rect.left + 13, rect.bottom - 1),
      1.35,
      pearlPaint,
    );
  }
}

class CoquetteRibbonDivider extends StatelessWidget {
  const CoquetteRibbonDivider({this.height = 12, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors =
        CoquetteThemeColors.maybeOf(context) ?? CoquetteThemeColors.defaults;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CoquetteDividerPainter(colors)),
    );
  }
}

class _CoquetteDividerPainter extends CustomPainter {
  const _CoquetteDividerPainter(this.colors);
  final CoquetteThemeColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final ribbon = Path()
      ..moveTo(0, y)
      ..cubicTo(
        size.width * .28,
        y - 1.2,
        size.width * .66,
        y + .9,
        size.width,
        y - .1,
      );
    canvas.drawPath(
      ribbon,
      Paint()
        ..color = colors.dustyRose.withValues(alpha: .58)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(size.width * .82, y - .1),
      2,
      Paint()..color = colors.champagne,
    );
  }

  @override
  bool shouldRepaint(covariant _CoquetteDividerPainter oldDelegate) =>
      colors != oldDelegate.colors;
}

class CoquetteNavigationItem {
  const CoquetteNavigationItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Cream navigation with a delicate petal marker, distinct from Sumi-e.
class CoquetteBottomNavigationBar extends StatelessWidget {
  const CoquetteBottomNavigationBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<CoquetteNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors =
        CoquetteThemeColors.maybeOf(context) ?? CoquetteThemeColors.defaults;
    return Container(
      height: 70,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: colors.cream,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
          bottom: Radius.circular(14),
        ),
        border: Border.all(color: colors.dustyRose.withValues(alpha: .46)),
        boxShadow: [
          BoxShadow(
            color: colors.cocoa.withValues(alpha: .10),
            blurRadius: 16,
            offset: const Offset(0, -3),
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
                    onTap: () => onSelected(index),
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            items[index].icon,
                            size: 23,
                            color: selectedIndex == index
                                ? colors.berry
                                : colors.mauve,
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: selectedIndex == index ? 15 : 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? colors.rose
                                  : colors.champagne.withValues(alpha: .55),
                              borderRadius: BorderRadius.circular(4),
                            ),
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
