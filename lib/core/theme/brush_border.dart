import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A stable, restrained brush treatment that traces the original component
/// geometry. Its variation is positional, so it never changes between builds.
class BrushBorder extends OutlinedBorder {
  const BrushBorder({
    this.radius = 16,
    this.variation = .24,
    super.side = const BorderSide(color: Color(0xFF171717), width: 1.4),
  });

  final double radius;
  final double variation;

  @override
  OutlinedBorder copyWith({BorderSide? side}) => BrushBorder(
    radius: radius,
    variation: variation,
    side: side ?? this.side,
  );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(side.width),
          Radius.circular(math.max(0, radius - side.width)),
        ),
      );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect.deflate(side.width / 2));
    for (final metric in path.computeMetrics()) {
      const step = 7.0;
      for (var start = 0.0; start < metric.length; start += step) {
        final end = math.min(start + step + .8, metric.length);
        final middle = (start + end) / 2;
        final wave =
            math.sin(middle * .17) * .55 + math.sin(middle * .043) * .45;
        final localWidth = side.width * (1 + variation * wave);
        final paint = Paint()
          ..color = side.color.withValues(alpha: .76 + .20 * wave)
          ..style = PaintingStyle.stroke
          ..strokeWidth = localWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawPath(metric.extractPath(start, end), paint);

        // Fine dry-brush fibers: deterministic short marks that follow the
        // tangent, preserving the straight edges and the original silhouette.
        if ((math.sin(middle * .61) + math.sin(middle * .137)) > 1.25) {
          final sample = metric.getTangentForOffset(middle);
          if (sample != null) {
            final normal = Offset(-sample.vector.dy, sample.vector.dx);
            final fiber = Path()
              ..moveTo(
                sample.position.dx + normal.dx * side.width * .7,
                sample.position.dy + normal.dy * side.width * .7,
              )
              ..lineTo(
                sample.position.dx +
                    sample.vector.dx * 5 +
                    normal.dx * side.width,
                sample.position.dy +
                    sample.vector.dy * 5 +
                    normal.dy * side.width,
              );
            canvas.drawPath(
              fiber,
              Paint()
                ..color = side.color.withValues(alpha: .28)
                ..strokeWidth = math.max(.35, side.width * .2)
                ..strokeCap = StrokeCap.square,
            );
          }
        }
      }
    }
  }

  @override
  ShapeBorder scale(double t) => BrushBorder(
    radius: radius * t,
    variation: variation,
    side: side.scale(t),
  );
}

/// An [OutlineInputBorder] with a restrained ink edge that keeps Flutter's
/// floating-label gap, validation geometry, and corner radius intact.
class BrushOutlineInputBorder extends OutlineInputBorder {
  const BrushOutlineInputBorder({
    super.borderSide,
    super.borderRadius,
    super.gapPadding,
    this.variation = .1,
  });

  final double variation;

  @override
  BrushOutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) => BrushOutlineInputBorder(
    borderSide: borderSide ?? this.borderSide,
    borderRadius: borderRadius ?? this.borderRadius,
    gapPadding: gapPadding ?? this.gapPadding,
    variation: variation,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OutlineInputBorder) {
      return copyWith(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t),
        gapPadding: a.gapPadding + (gapPadding - a.gapPadding) * t,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is OutlineInputBorder) {
      return copyWith(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t),
        gapPadding: gapPadding + (b.gapPadding - gapPadding) * t,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection? textDirection,
  }) {
    if (borderSide.style == BorderStyle.none || borderSide.width <= 0) return;
    final radius = borderRadius.resolve(textDirection).topLeft.x;
    final half = borderSide.width / 2;
    final left = rect.left + half;
    final right = rect.right - half;
    final top = rect.top + half;
    final bottom = rect.bottom - half;
    final paths = <(Path, double)>[];

    // Strong left edge and only the upper portion of the right edge.
    paths.add((
      Path()
        ..moveTo(left, top + radius)
        ..cubicTo(
          left - .5,
          rect.center.dy,
          left + .8,
          rect.bottom - radius,
          left,
          bottom - 3,
        ),
      borderSide.width * 1.7,
    ));
    paths.add((
      Path()
        ..moveTo(right, top + radius)
        ..lineTo(right, top + rect.height * .3),
      borderSide.width * .75,
    ));

    final topStart = left + radius + 5;
    final topEnd = right - radius - 7;
    final gap = gapStart;
    final hasGap = gap != null && gapExtent > 0 && gapPercentage > 0;
    if (!hasGap) {
      paths.add((
        Path()
          ..moveTo(topStart, top)
          ..lineTo(topEnd, top),
        borderSide.width * .7,
      ));
    } else {
      final extent = (gapExtent + gapPadding * 2) * gapPercentage;
      final gapLeft = textDirection == TextDirection.rtl
          ? rect.left + gap + gapPadding - extent
          : rect.left + gap - gapPadding;
      final gapRight = gapLeft + extent;
      if (gapLeft > topStart) {
        paths.add((
          Path()
            ..moveTo(topStart, top)
            ..lineTo(math.min(gapLeft, topEnd), top),
          borderSide.width * .7,
        ));
      }
      if (gapRight < topEnd) {
        paths.add((
          Path()
            ..moveTo(math.max(gapRight, topStart), top)
            ..lineTo(topEnd, top),
          borderSide.width * .7,
        ));
      }
    }

    // One dry-brush lower stroke leaves intentional open space on the left.
    paths.add((
      Path()
        ..moveTo(rect.left + rect.width * .58, bottom)
        ..cubicTo(
          rect.left + rect.width * .7,
          bottom - .8,
          right - radius - 12,
          bottom + .5,
          right - radius,
          bottom,
        ),
      borderSide.width * .95,
    ));
    paths.add((
      Path()
        ..moveTo(left, top + 2)
        ..lineTo(left + radius + 3, top + 2)
        ..moveTo(left, top + 2)
        ..lineTo(left, top + radius + 4),
      borderSide.width * 1.35,
    ));

    for (final (path, baseWidth) in paths) {
      for (final metric in path.computeMetrics()) {
        for (var start = 0.0; start < metric.length; start += 6) {
          final end = math.min(start + 6.8, metric.length);
          final pressure = .7 + .3 * math.sin(start * .21 + variation * 8);
          canvas.drawPath(
            metric.extractPath(start, end),
            Paint()
              ..color = borderSide.color.withValues(alpha: .64 + .34 * pressure)
              ..style = PaintingStyle.stroke
              ..strokeWidth = baseWidth * pressure
              ..strokeCap = StrokeCap.butt,
          );
        }
      }
    }
  }
}

/// Ink edged circle for components whose existing geometry is circular.
class BrushCircleBorder extends OutlinedBorder {
  const BrushCircleBorder({
    super.side = const BorderSide(color: Color(0xFF171717), width: 1.4),
    this.variation = .24,
  });

  final double variation;

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      BrushCircleBorder(side: side ?? this.side, variation: variation);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addOval(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addOval(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect.deflate(side.width / 2));
    for (final metric in path.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += 7) {
        final end = math.min(start + 7.8, metric.length);
        final middle = (start + end) / 2;
        final grain = math.sin(middle * .19) * variation;
        canvas.drawPath(
          metric.extractPath(start, end),
          Paint()
            ..color = side.color.withValues(alpha: .76 + grain)
            ..style = PaintingStyle.stroke
            ..strokeWidth = side.width * (1 + grain)
            ..strokeCap = StrokeCap.butt,
        );
      }
    }
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) =>
      BrushCircleBorder(side: side.scale(t), variation: variation);
}

/// Brush-edged sheet border that rounds only the original top corners.
class BrushTopBorder extends OutlinedBorder {
  const BrushTopBorder({
    super.side = const BorderSide(color: Color(0xFF171717), width: 1.4),
    this.radius = 24,
    this.variation = .18,
  });

  final double radius;
  final double variation;

  @override
  OutlinedBorder copyWith({BorderSide? side}) => BrushTopBorder(
    side: side ?? this.side,
    radius: radius,
    variation: variation,
  );

  RRect _rrect(Rect rect) => RRect.fromRectAndCorners(
    rect,
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(_rrect(rect));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(_rrect(rect.deflate(side.width)));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect.deflate(side.width / 2));
    for (final metric in path.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += 7) {
        final end = math.min(start + 7.8, metric.length);
        final middle = (start + end) / 2;
        final grain = math.sin(middle * .19) * variation;
        canvas.drawPath(
          metric.extractPath(start, end),
          Paint()
            ..color = side.color.withValues(alpha: .76 + grain)
            ..style = PaintingStyle.stroke
            ..strokeWidth = side.width * (1 + grain)
            ..strokeCap = StrokeCap.butt,
        );
      }
    }
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => BrushTopBorder(
    side: side.scale(t),
    radius: radius * t,
    variation: variation,
  );
}
