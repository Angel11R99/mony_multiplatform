import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mony_tokens.dart';

/// Canonical ink, paper, seal, and accent colors for the Japanese visual theme.
@immutable
class SumiThemeColors extends ThemeExtension<SumiThemeColors> {
  const SumiThemeColors({
    required this.ink,
    required this.deepInk,
    required this.charcoal,
    required this.paper,
    required this.warmPaper,
    required this.vermilion,
    required this.deepVermilion,
    required this.gold,
    required this.bronze,
    required this.inkGray,
    required this.jade,
    required this.coral,
  });

  final Color ink;
  final Color deepInk;
  final Color charcoal;
  final Color paper;
  final Color warmPaper;
  final Color vermilion;
  final Color deepVermilion;
  final Color gold;
  final Color bronze;
  final Color inkGray;
  final Color jade;
  final Color coral;

  static const defaults = SumiThemeColors(
    ink: Color(0xFF151311),
    deepInk: Color(0xFF100F0D),
    charcoal: Color(0xFF29211C),
    paper: Color(0xFFF3E7D3),
    warmPaper: Color(0xFFE6D4BA),
    vermilion: Color(0xFFC23B2A),
    deepVermilion: Color(0xFF8F2C22),
    gold: Color(0xFFB5955D),
    bronze: Color(0xFF806443),
    inkGray: Color(0xFF756F67),
    jade: Color(0xFF72947A),
    coral: Color(0xFFD67B68),
  );

  static SumiThemeColors? maybeOf(BuildContext context) =>
      Theme.of(context).extension<SumiThemeColors>();

  @override
  SumiThemeColors copyWith({
    Color? ink,
    Color? deepInk,
    Color? charcoal,
    Color? paper,
    Color? warmPaper,
    Color? vermilion,
    Color? deepVermilion,
    Color? gold,
    Color? bronze,
    Color? inkGray,
    Color? jade,
    Color? coral,
  }) => SumiThemeColors(
    ink: ink ?? this.ink,
    deepInk: deepInk ?? this.deepInk,
    charcoal: charcoal ?? this.charcoal,
    paper: paper ?? this.paper,
    warmPaper: warmPaper ?? this.warmPaper,
    vermilion: vermilion ?? this.vermilion,
    deepVermilion: deepVermilion ?? this.deepVermilion,
    gold: gold ?? this.gold,
    bronze: bronze ?? this.bronze,
    inkGray: inkGray ?? this.inkGray,
    jade: jade ?? this.jade,
    coral: coral ?? this.coral,
  );

  @override
  SumiThemeColors lerp(ThemeExtension<SumiThemeColors>? other, double t) {
    if (other is! SumiThemeColors) return this;
    return SumiThemeColors(
      ink: Color.lerp(ink, other.ink, t)!,
      deepInk: Color.lerp(deepInk, other.deepInk, t)!,
      charcoal: Color.lerp(charcoal, other.charcoal, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      warmPaper: Color.lerp(warmPaper, other.warmPaper, t)!,
      vermilion: Color.lerp(vermilion, other.vermilion, t)!,
      deepVermilion: Color.lerp(deepVermilion, other.deepVermilion, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      bronze: Color.lerp(bronze, other.bronze, t)!,
      inkGray: Color.lerp(inkGray, other.inkGray, t)!,
      jade: Color.lerp(jade, other.jade, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
    );
  }
}

enum SumiSurfaceVariant {
  openFrame,
  inkBlock,
  inkWash,
  minimalJade,
  minimalVermilion,
  minimalInk,
}

/// Theme-aware surface language with deliberate, semantic brush treatments.
class SumiSurface extends StatelessWidget {
  const SumiSurface({
    required this.child,
    this.variant = SumiSurfaceVariant.openFrame,
    this.padding = const EdgeInsets.all(MonySpace.x4),
    this.margin = const EdgeInsets.all(4),
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final SumiSurfaceVariant variant;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = SumiThemeColors.maybeOf(context);
    if (palette == null) {
      final content = Padding(padding: padding, child: child);
      return Semantics(
        label: semanticLabel,
        container: semanticLabel != null,
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: margin,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, child: content),
        ),
      );
    }

    final colors = Theme.of(context).colorScheme;
    final isInk = variant == SumiSurfaceVariant.inkBlock;
    final isPaper = variant == SumiSurfaceVariant.inkWash;
    final background = switch (variant) {
      SumiSurfaceVariant.inkBlock => palette.deepInk,
      SumiSurfaceVariant.inkWash => palette.warmPaper,
      SumiSurfaceVariant.openFrame ||
      SumiSurfaceVariant.minimalJade ||
      SumiSurfaceVariant.minimalVermilion ||
      SumiSurfaceVariant.minimalInk => colors.surfaceContainerLow,
    };
    final contentTheme = isInk || isPaper
        ? Theme.of(context).copyWith(
            colorScheme: colors.copyWith(
              surface: background,
              onSurface: isInk ? palette.paper : palette.ink,
              onSurfaceVariant: isInk ? palette.warmPaper : palette.inkGray,
            ),
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: isInk ? palette.paper : palette.ink,
              displayColor: isInk ? palette.paper : palette.ink,
            ),
            iconTheme: IconThemeData(
              color: isInk ? palette.paper : palette.ink,
            ),
          )
        : Theme.of(context);

    final content = CustomPaint(
      painter: SumiSurfacePainter(
        variant: variant,
        colors: palette,
        background: background,
        highContrast: Theme.of(context).brightness == Brightness.dark,
      ),
      child: Padding(padding: padding, child: child),
    );
    return Semantics(
      label: semanticLabel,
      container: semanticLabel != null,
      child: Padding(
        padding: margin,
        child: Theme(
          data: contentTheme,
          child: onTap == null
              ? content
              : InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.zero,
                  child: content,
                ),
        ),
      ),
    );
  }
}

class SumiSurfacePainter extends CustomPainter {
  const SumiSurfacePainter({
    required this.variant,
    required this.colors,
    required this.background,
    required this.highContrast,
  });

  final SumiSurfaceVariant variant;
  final SumiThemeColors colors;
  final Color background;
  final bool highContrast;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    switch (variant) {
      case SumiSurfaceVariant.inkBlock:
        _paintInkBlock(canvas, rect);
      case SumiSurfaceVariant.inkWash:
        _paintWash(canvas, rect);
      case SumiSurfaceVariant.openFrame:
        canvas.drawRect(rect, Paint()..color = background);
        _paintOpenFrame(canvas, rect);
      case SumiSurfaceVariant.minimalJade:
      case SumiSurfaceVariant.minimalVermilion:
      case SumiSurfaceVariant.minimalInk:
        canvas.drawRect(rect, Paint()..color = background);
        _paintMinimal(canvas, rect);
    }
  }

  void _paintInkBlock(Canvas canvas, Rect rect) {
    final block = RRect.fromRectAndRadius(rect, const Radius.circular(3));
    canvas.drawRRect(block, Paint()..color = colors.deepInk);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left + 7,
          rect.top + 7,
          rect.width - 14,
          rect.height - 14,
        ),
        const Radius.circular(1),
      ),
      Paint()..color = colors.ink.withValues(alpha: .58),
    );

    final left = rect.left + 1;
    final stroke = Path()
      ..moveTo(left + 1, rect.top + 13)
      ..cubicTo(
        left + 7,
        rect.top + rect.height * .27,
        left + 2,
        rect.top + rect.height * .68,
        left + 8,
        rect.bottom - 15,
      )
      ..lineTo(left + 3, rect.bottom - 10)
      ..cubicTo(
        left - 1,
        rect.top + rect.height * .66,
        left + 4,
        rect.top + rect.height * .32,
        left - 1,
        rect.top + 13,
      )
      ..close();
    canvas.drawPath(stroke, Paint()..color = colors.vermilion);

    final goldLine = Path()
      ..moveTo(rect.left + rect.width * .23, rect.top + 1.5)
      ..lineTo(rect.left + rect.width * .72, rect.top + 1.5);
    _stroke(canvas, goldLine, colors.gold.withValues(alpha: .72), 1);

    final fiber = Path()
      ..moveTo(rect.left + 4, rect.top + rect.height * .22)
      ..lineTo(rect.left + 10, rect.top + rect.height * .38)
      ..moveTo(rect.left + 3, rect.top + rect.height * .62)
      ..lineTo(rect.left + 8, rect.top + rect.height * .73);
    _stroke(canvas, fiber, colors.coral.withValues(alpha: .44), .65);
  }

  void _paintOpenFrame(Canvas canvas, Rect rect) {
    final ink = highContrast ? colors.warmPaper : colors.inkGray;
    final left = Path()
      ..moveTo(rect.left + 1, rect.top + 8)
      ..cubicTo(
        rect.left + 2.5,
        rect.top + rect.height * .35,
        rect.left - .5,
        rect.top + rect.height * .7,
        rect.left + 1.5,
        rect.bottom - 8,
      );
    _stroke(canvas, left, ink.withValues(alpha: .92), 2.4);

    final top = Path()
      ..moveTo(rect.left + 10, rect.top + 1)
      ..lineTo(rect.left + rect.width * .68, rect.top + .5);
    _stroke(canvas, top, colors.bronze.withValues(alpha: .8), .8);

    final bottom = Path()
      ..moveTo(rect.left + rect.width * .56, rect.bottom - 1)
      ..cubicTo(
        rect.left + rect.width * .7,
        rect.bottom - 1.5,
        rect.left + rect.width * .86,
        rect.bottom + .5,
        rect.right - 9,
        rect.bottom - 1,
      );
    _stroke(canvas, bottom, ink.withValues(alpha: .62), 1.1);

    final corner = Path()
      ..moveTo(rect.right - 1, rect.top + 8)
      ..lineTo(rect.right - 1, rect.top + 24)
      ..moveTo(rect.right - 16, rect.top + 1)
      ..lineTo(rect.right - 1, rect.top + 1);
    _stroke(canvas, corner, colors.gold.withValues(alpha: .78), 1.35);
    _dryFibers(canvas, rect, ink);
  }

  void _paintWash(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = colors.warmPaper);
    final washRect = Rect.fromLTWH(
      rect.left + rect.width * .48,
      rect.top,
      rect.width * .52,
      rect.height,
    );
    canvas.save();
    canvas.clipRect(rect);
    canvas.drawOval(
      washRect,
      Paint()..color = colors.inkGray.withValues(alpha: .055),
    );
    for (var i = 0; i < 7; i++) {
      final y = rect.top + rect.height * (.12 + i * .105);
      final start = rect.left + rect.width * (.59 + .015 * math.sin(i * 1.7));
      final line = Path()
        ..moveTo(start, y)
        ..lineTo(rect.right - rect.width * .08, y + math.sin(i * 2.3) * .8);
      _stroke(canvas, line, colors.ink.withValues(alpha: .028), .55);
    }
    final accent = Path()
      ..moveTo(rect.left + 12, rect.bottom - 3)
      ..cubicTo(
        rect.left + rect.width * .23,
        rect.bottom - 1,
        rect.left + rect.width * .35,
        rect.bottom - 5,
        rect.left + rect.width * .48,
        rect.bottom - 2,
      );
    _stroke(canvas, accent, colors.vermilion.withValues(alpha: .8), 2.2);
    canvas.restore();
  }

  void _paintMinimal(Canvas canvas, Rect rect) {
    final color = switch (variant) {
      SumiSurfaceVariant.minimalJade => colors.jade,
      SumiSurfaceVariant.minimalVermilion => colors.vermilion,
      _ => colors.inkGray,
    };
    final stripe = Path()
      ..moveTo(rect.left + 1, rect.top + 7)
      ..cubicTo(
        rect.left + 3,
        rect.top + rect.height * .34,
        rect.left - 1,
        rect.top + rect.height * .68,
        rect.left + 2,
        rect.bottom - 7,
      );
    _stroke(canvas, stripe, color, 2.6);
    final dry = Path()
      ..moveTo(rect.left + 8, rect.bottom - 2)
      ..lineTo(rect.left + rect.width * .33, rect.bottom - 1)
      ..moveTo(rect.left + rect.width * .42, rect.bottom - 2)
      ..lineTo(rect.left + rect.width * .56, rect.bottom - 2);
    _stroke(canvas, dry, colors.gold.withValues(alpha: .5), .7);
  }

  void _dryFibers(Canvas canvas, Rect rect, Color color) {
    for (var i = 0; i < 5; i++) {
      final y = rect.top + rect.height * (.18 + i * .14);
      final x = rect.left + 2 + (i.isEven ? 1 : 0);
      final path = Path()
        ..moveTo(x, y)
        ..lineTo(x + 5 + i % 2, y + (i.isEven ? 2 : -1));
      _stroke(canvas, path, color.withValues(alpha: .32), .55);
    }
  }

  void _stroke(Canvas canvas, Path path, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      const step = 8.0;
      for (var start = 0.0; start < metric.length; start += step) {
        final end = math.min(start + step + .65, metric.length);
        final pressure = .68 + .32 * math.sin(start * .27 + variant.index);
        paint.strokeWidth = width * pressure;
        paint.color = color.withValues(alpha: (color.a * pressure).clamp(0, 1));
        canvas.drawPath(metric.extractPath(start, end), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SumiSurfacePainter oldDelegate) =>
      variant != oldDelegate.variant ||
      colors != oldDelegate.colors ||
      background != oldDelegate.background ||
      highContrast != oldDelegate.highContrast;
}

/// A restrained dry-brush separator for sections and financial breakdowns.
class SumiBrushDivider extends StatelessWidget {
  const SumiBrushDivider({this.color, this.height = 9, super.key});

  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = SumiThemeColors.maybeOf(context);
    if (palette == null) return Divider(height: height);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SumiDividerPainter(color ?? palette.inkGray),
      ),
    );
  }
}

class _SumiDividerPainter extends CustomPainter {
  const _SumiDividerPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final path = Path()
      ..moveTo(0, y)
      ..cubicTo(
        size.width * .22,
        y - 1.2,
        size.width * .68,
        y + .8,
        size.width,
        y - .2,
      );
    for (final metric in path.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += 13) {
        final end = math.min(start + 11, metric.length);
        final phase = math.sin(start * .11);
        canvas.drawPath(
          metric.extractPath(start, end),
          Paint()
            ..color = color.withValues(alpha: .25 + .28 * phase.abs())
            ..style = PaintingStyle.stroke
            ..strokeWidth = .45 + .6 * phase.abs()
            ..strokeCap = StrokeCap.butt,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SumiDividerPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A sharply edged, intentionally incomplete frame used by ordinary Cards.
class SumiOpenFrameBorder extends OutlinedBorder {
  const SumiOpenFrameBorder({
    super.side = const BorderSide(color: Color(0xFF756F67), width: 1.25),
    this.variation = .2,
  });

  final double variation;

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      SumiOpenFrameBorder(side: side ?? this.side, variation: variation);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final color = side.color;
    final left = Path()
      ..moveTo(rect.left + .5, rect.top + 8)
      ..cubicTo(
        rect.left + 1,
        rect.top + rect.height * .4,
        rect.left - .5,
        rect.top + rect.height * .7,
        rect.left + .5,
        rect.bottom - 8,
      );
    final top = Path()
      ..moveTo(rect.left + 9, rect.top + .5)
      ..lineTo(rect.left + rect.width * .7, rect.top + .5);
    final bottom = Path()
      ..moveTo(rect.left + rect.width * .57, rect.bottom - .5)
      ..lineTo(rect.right - 9, rect.bottom - .5);
    for (final (path, baseWidth) in [
      (left, side.width * 2.0),
      (top, side.width * .55),
      (bottom, side.width * .9),
    ]) {
      for (final metric in path.computeMetrics()) {
        for (var start = 0.0; start < metric.length; start += 8) {
          final end = math.min(start + 8.5, metric.length);
          final pressure = 1 + variation * math.sin(start * .23);
          canvas.drawPath(
            metric.extractPath(start, end),
            Paint()
              ..color = color.withValues(alpha: .62 + .3 * pressure.clamp(0, 1))
              ..style = PaintingStyle.stroke
              ..strokeWidth = baseWidth * pressure
              ..strokeCap = StrokeCap.butt,
          );
        }
      }
    }
    final corner = Path()
      ..moveTo(rect.right - 1, rect.top + 2)
      ..lineTo(rect.right - 1, rect.top + 15)
      ..moveTo(rect.right - 13, rect.top + .5)
      ..lineTo(rect.right - 1, rect.top + .5);
    canvas.drawPath(
      corner,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width * 1.4
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width * 1.6);

  @override
  ShapeBorder scale(double t) =>
      SumiOpenFrameBorder(side: side.scale(t), variation: variation);
}

/// Dark, squared navigation lacquer with a custom calligraphic active stroke.
class SumiNavigationPainter extends CustomPainter {
  const SumiNavigationPainter({
    required this.colors,
    required this.activeIndex,
    required this.itemCount,
  });

  final SumiThemeColors colors;
  final double activeIndex;
  final int itemCount;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = colors.deepInk);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * .36),
      Paint()..color = colors.ink.withValues(alpha: .72),
    );
    final upper = Path()
      ..moveTo(0, 1)
      ..lineTo(size.width * .64, 1);
    canvas.drawPath(
      upper,
      Paint()
        ..color = colors.gold.withValues(alpha: .75)
        ..strokeWidth = .8
        ..strokeCap = StrokeCap.butt,
    );
    final leftEdge = Path()
      ..moveTo(.5, 7)
      ..lineTo(.5, size.height - 7);
    canvas.drawPath(
      leftEdge,
      Paint()
        ..color = colors.paper.withValues(alpha: .45)
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.butt,
    );

    if (itemCount <= 0) return;
    final itemWidth = size.width / itemCount;
    final activeX = (activeIndex + .5) * itemWidth;
    final washRadius = itemWidth < 46 ? itemWidth * .7 : 32.0;
    final washCenter = Offset(activeX, size.height * .66);
    canvas.drawCircle(
      washCenter,
      washRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colors.ink.withValues(alpha: .2),
            colors.ink.withValues(alpha: .08),
            Colors.transparent,
          ],
          stops: const [0, .48, 1],
        ).createShader(Rect.fromCircle(center: washCenter, radius: washRadius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );

    final strokeHalfWidth = itemWidth < 54 ? itemWidth * .3 : 16.0;
    final stroke = Path()
      ..moveTo(activeX - strokeHalfWidth, size.height - 15)
      ..quadraticBezierTo(
        activeX,
        size.height - 21,
        activeX + strokeHalfWidth,
        size.height - 15,
      );
    canvas.drawPath(
      stroke,
      Paint()
        ..color = colors.gold.withValues(alpha: .96)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    final seal = Rect.fromCenter(
      center: Offset(size.width - 14, 7),
      width: 10,
      height: 10,
    );
    canvas.drawRect(
      seal,
      Paint()..color = colors.vermilion.withValues(alpha: .9),
    );
    canvas.drawRect(
      seal.deflate(3),
      Paint()..color = colors.paper.withValues(alpha: .72),
    );
  }

  @override
  bool shouldRepaint(covariant SumiNavigationPainter oldDelegate) =>
      colors != oldDelegate.colors ||
      activeIndex != oldDelegate.activeIndex ||
      itemCount != oldDelegate.itemCount;
}
