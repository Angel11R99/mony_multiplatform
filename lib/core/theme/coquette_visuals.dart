import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mony_tokens.dart';

/// Semantic colors reserved for the Coquette Atelier identity.
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

/// Semantic surface and contrast tokens for the Coquette Atelier variants.
@immutable
class CoquetteSurfaceTokens extends ThemeExtension<CoquetteSurfaceTokens> {
  const CoquetteSurfaceTokens({
    required this.page,
    required this.primarySurface,
    required this.elevatedSurface,
    required this.subtleSurface,
    required this.selectedSurface,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedBorder,
    required this.disabledSurface,
    required this.disabledText,
    required this.incomeAccent,
    required this.expenseAccent,
    required this.warningAccent,
  });

  final Color page;
  final Color primarySurface;
  final Color elevatedSurface;
  final Color subtleSurface;
  final Color selectedSurface;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedBorder;
  final Color disabledSurface;
  final Color disabledText;
  final Color incomeAccent;
  final Color expenseAccent;
  final Color warningAccent;

  static const light = CoquetteSurfaceTokens(
    page: Color(0xFFFFF9F5),
    primarySurface: Color(0xFFFFF3ED),
    elevatedSurface: Color(0xFFFFFCFA),
    subtleSurface: Color(0xFFF9EEF2),
    selectedSurface: Color(0xFFF2B8C6),
    primaryAccent: Color(0xFFA74770),
    secondaryAccent: Color(0xFF8F7188),
    primaryText: Color(0xFF493542),
    secondaryText: Color(0xFF765E72),
    mutedBorder: Color(0xFFE8D4DB),
    disabledSurface: Color(0xFFEBE3E5),
    disabledText: Color(0xFF847A80),
    incomeAccent: Color(0xFF557A68),
    expenseAccent: Color(0xFFA74770),
    warningAccent: Color(0xFF80613C),
  );

  static const dark = CoquetteSurfaceTokens(
    page: Color(0xFF1C1720),
    primarySurface: Color(0xFF302531),
    elevatedSurface: Color(0xFF3B2D3C),
    subtleSurface: Color(0xFF28212D),
    selectedSurface: Color(0xFF57374C),
    primaryAccent: Color(0xFFD987AA),
    secondaryAccent: Color(0xFFBCA4D1),
    primaryText: Color(0xFFF9EDF3),
    secondaryText: Color(0xFFCEBBCB),
    mutedBorder: Color(0xFF806C83),
    disabledSurface: Color(0xFF302A35),
    disabledText: Color(0xFFA899A9),
    incomeAccent: Color(0xFF8FC7A4),
    expenseAccent: Color(0xFFD987AA),
    warningAccent: Color(0xFFE4C78F),
  );

  static CoquetteSurfaceTokens forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static CoquetteSurfaceTokens? maybeOf(BuildContext context) =>
      Theme.of(context).extension<CoquetteSurfaceTokens>();

  @override
  CoquetteSurfaceTokens copyWith({
    Color? page,
    Color? primarySurface,
    Color? elevatedSurface,
    Color? subtleSurface,
    Color? selectedSurface,
    Color? primaryAccent,
    Color? secondaryAccent,
    Color? primaryText,
    Color? secondaryText,
    Color? mutedBorder,
    Color? disabledSurface,
    Color? disabledText,
    Color? incomeAccent,
    Color? expenseAccent,
    Color? warningAccent,
  }) => CoquetteSurfaceTokens(
    page: page ?? this.page,
    primarySurface: primarySurface ?? this.primarySurface,
    elevatedSurface: elevatedSurface ?? this.elevatedSurface,
    subtleSurface: subtleSurface ?? this.subtleSurface,
    selectedSurface: selectedSurface ?? this.selectedSurface,
    primaryAccent: primaryAccent ?? this.primaryAccent,
    secondaryAccent: secondaryAccent ?? this.secondaryAccent,
    primaryText: primaryText ?? this.primaryText,
    secondaryText: secondaryText ?? this.secondaryText,
    mutedBorder: mutedBorder ?? this.mutedBorder,
    disabledSurface: disabledSurface ?? this.disabledSurface,
    disabledText: disabledText ?? this.disabledText,
    incomeAccent: incomeAccent ?? this.incomeAccent,
    expenseAccent: expenseAccent ?? this.expenseAccent,
    warningAccent: warningAccent ?? this.warningAccent,
  );

  @override
  CoquetteSurfaceTokens lerp(
    ThemeExtension<CoquetteSurfaceTokens>? other,
    double t,
  ) {
    if (other is! CoquetteSurfaceTokens) return this;
    return CoquetteSurfaceTokens(
      page: Color.lerp(page, other.page, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
      selectedSurface: Color.lerp(selectedSurface, other.selectedSurface, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      mutedBorder: Color.lerp(mutedBorder, other.mutedBorder, t)!,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      incomeAccent: Color.lerp(incomeAccent, other.incomeAccent, t)!,
      expenseAccent: Color.lerp(expenseAccent, other.expenseAccent, t)!,
      warningAccent: Color.lerp(warningAccent, other.warningAccent, t)!,
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

/// Purposeful surface vocabulary used by Coquette Atelier screens.
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
        surfaceTokens: CoquetteSurfaceTokens.maybeOf(context),
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
    this.surfaceTokens,
  });

  final CoquetteThemeColors colors;
  final CoquetteSurfaceVariant variant;
  final bool dark;
  final CoquetteSurfaceTokens? surfaceTokens;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final tokens =
        surfaceTokens ??
        CoquetteSurfaceTokens.forBrightness(
          dark ? Brightness.dark : Brightness.light,
        );
    final path = _coquettePetalPath(rect);
    switch (variant) {
      case CoquetteSurfaceVariant.petal:
        canvas.drawPath(
          path,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      tokens.primarySurface,
                      tokens.primarySurface,
                      tokens.primarySurface,
                    ]
                  : [colors.blush, colors.cream, colors.ivory],
              stops: const [0, .58, 1],
            ).createShader(rect),
        );
        _stroke(
          path,
          dark ? tokens.primaryAccent : colors.dustyRose,
          1.25,
          canvas,
        );
      case CoquetteSurfaceVariant.scalloped:
        final scallopedPath = _coquetteScallopPath(rect);
        canvas.drawPath(
          scallopedPath,
          Paint()..color = dark ? tokens.elevatedSurface : colors.ivory,
        );
        _stroke(
          scallopedPath,
          dark ? tokens.mutedBorder : colors.dustyRose,
          1.05,
          canvas,
        );
      case CoquetteSurfaceVariant.ribbon:
        canvas.drawPath(
          path,
          Paint()..color = dark ? tokens.primarySurface : colors.cream,
        );
        _ribbon(canvas, rect, tokens);
      case CoquetteSurfaceVariant.pearl:
      case CoquetteSurfaceVariant.incomePearl:
      case CoquetteSurfaceVariant.expensePearl:
        final fill = switch (variant) {
          CoquetteSurfaceVariant.incomePearl ||
          CoquetteSurfaceVariant.expensePearl =>
            dark ? tokens.elevatedSurface : colors.ivory,
          _ => dark ? tokens.subtleSurface : colors.ivory,
        };
        canvas.drawPath(path, Paint()..color = fill);
        final outline = variant == CoquetteSurfaceVariant.incomePearl
            ? (dark ? tokens.incomeAccent : colors.income)
            : variant == CoquetteSurfaceVariant.expensePearl
            ? (dark ? tokens.expenseAccent : colors.expense)
            : (dark ? tokens.mutedBorder : colors.mauve);
        _stroke(path, outline, 1.0, canvas);
      case CoquetteSurfaceVariant.floating:
        canvas.drawPath(
          path,
          Paint()..color = dark ? tokens.elevatedSurface : colors.cream,
        );
        _stroke(path, dark ? tokens.mutedBorder : colors.rose, .9, canvas);
      case CoquetteSurfaceVariant.editorial:
        if (dark) {
          canvas.drawPath(path, Paint()..color = tokens.subtleSurface);
          _stroke(path, tokens.mutedBorder, .9, canvas);
        }
        _ribbon(canvas, rect, tokens, subtle: true);
    }
  }

  void _ribbon(
    Canvas canvas,
    Rect rect,
    CoquetteSurfaceTokens tokens, {
    bool subtle = false,
  }) {
    final width = subtle ? 1.4 : 2.4;
    final inset = width / 2 + 1;
    final cap = math.min(14.0, rect.height * .22);
    final ribbon = Path()
      ..moveTo(rect.left + inset, rect.top + cap)
      ..cubicTo(
        rect.left + inset + 1.2,
        rect.top + cap + 7,
        rect.left + inset - .2,
        rect.center.dy - 5,
        rect.left + inset + .8,
        rect.center.dy,
      )
      ..cubicTo(
        rect.left + inset - .2,
        rect.center.dy + 5,
        rect.left + inset + 1.2,
        rect.bottom - cap - 7,
        rect.left + inset,
        rect.bottom - cap,
      );
    _stroke(
      ribbon,
      subtle
          ? tokens.primaryAccent.withValues(alpha: .72)
          : tokens.primaryAccent,
      width,
      canvas,
    );
    if (!subtle) {
      final stitch = Path()
        ..moveTo(rect.left + inset + 4, rect.top + cap + 2)
        ..lineTo(rect.left + inset + 4, rect.bottom - cap - 2);
      _stroke(
        stitch,
        (dark ? tokens.secondaryAccent : colors.champagne).withValues(
          alpha: .78,
        ),
        .8,
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
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CoquetteSurfacePainter oldDelegate) =>
      colors != oldDelegate.colors ||
      variant != oldDelegate.variant ||
      dark != oldDelegate.dark ||
      surfaceTokens != oldDelegate.surfaceTokens;
}

Path _coquettePetalPath(Rect rect) {
  final bounds = rect.deflate(1.2);
  final corner = math.min(
    12.0,
    math.min(bounds.height * .24, bounds.width * .2),
  );
  final waist = math.min(4.5, math.min(bounds.height * .1, bounds.width * .07));
  final middle = bounds.center.dy;
  return Path()
    ..moveTo(bounds.left + corner, bounds.top)
    ..quadraticBezierTo(
      bounds.left,
      bounds.top,
      bounds.left,
      bounds.top + corner,
    )
    ..lineTo(bounds.left, middle - waist * 2)
    ..quadraticBezierTo(
      bounds.left + waist,
      middle,
      bounds.left,
      middle + waist * 2,
    )
    ..lineTo(bounds.left, bounds.bottom - corner)
    ..quadraticBezierTo(
      bounds.left,
      bounds.bottom,
      bounds.left + corner,
      bounds.bottom,
    )
    ..lineTo(bounds.right - corner, bounds.bottom)
    ..quadraticBezierTo(
      bounds.right,
      bounds.bottom,
      bounds.right,
      bounds.bottom - corner,
    )
    ..lineTo(bounds.right, middle + waist * 2)
    ..quadraticBezierTo(
      bounds.right - waist,
      middle,
      bounds.right,
      middle - waist * 2,
    )
    ..lineTo(bounds.right, bounds.top + corner)
    ..quadraticBezierTo(
      bounds.right,
      bounds.top,
      bounds.right - corner,
      bounds.top,
    )
    ..lineTo(bounds.left + corner, bounds.top)
    ..close();
}

Path _coquetteScallopPath(Rect rect) {
  final bounds = rect.deflate(1.4);
  final scallopCount = (bounds.width / 22).floor().clamp(5, 24);
  final span = (bounds.width - 20) / scallopCount;
  final top = bounds.top + 3;
  final path = Path()..moveTo(bounds.left + 10, top);
  for (var index = 0; index < scallopCount; index++) {
    final x = bounds.left + 10 + span * index;
    path.quadraticBezierTo(x + span / 2, bounds.top + .5, x + span, top);
  }
  return path
    ..lineTo(bounds.right - 2, bounds.bottom - 13)
    ..quadraticBezierTo(
      bounds.right - 2,
      bounds.bottom - 2,
      bounds.right - 13,
      bounds.bottom - 2,
    )
    ..lineTo(bounds.left + 13, bounds.bottom - 2)
    ..quadraticBezierTo(
      bounds.left + 2,
      bounds.bottom - 2,
      bounds.left + 2,
      bounds.bottom - 13,
    )
    ..lineTo(bounds.left + 2, top + 11)
    ..quadraticBezierTo(bounds.left + 2, top, bounds.left + 10, top)
    ..close();
}

/// Soft asymmetric card silhouette for Material components.
class CoquettePetalBorder extends OutlinedBorder {
  const CoquettePetalBorder({
    super.side = const BorderSide(color: Color(0xFFC87996), width: 1),
  });

  Path _path(Rect rect) => _coquettePetalPath(rect);

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      CoquettePetalBorder(side: side ?? this.side);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _path(rect.deflate(side.width / 2));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _path(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
      getOuterPath(rect),
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
    final edgeInset = borderSide.width / 2;
    canvas.drawCircle(
      Offset(rect.right - 20, rect.top + edgeInset),
      1.25,
      pearlPaint,
    );
    canvas.drawCircle(
      Offset(rect.left + 20, rect.bottom - edgeInset),
      1.25,
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
    final tokens =
        CoquetteSurfaceTokens.maybeOf(context) ??
        CoquetteSurfaceTokens.forBrightness(Theme.of(context).brightness);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CoquetteDividerPainter(colors, tokens)),
    );
  }
}

class _CoquetteDividerPainter extends CustomPainter {
  const _CoquetteDividerPainter(this.colors, this.tokens);
  final CoquetteThemeColors colors;
  final CoquetteSurfaceTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final ribbon = Path()
      ..moveTo(.8, y)
      ..cubicTo(
        size.width * .28,
        y - math.min(1.2, size.height * .12),
        size.width * .66,
        y + math.min(.9, size.height * .1),
        size.width - .8,
        y,
      );
    canvas.drawPath(
      ribbon,
      Paint()
        ..color = (tokens.primaryAccent).withValues(alpha: .58)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(size.width * .82, y),
      1.6,
      Paint()..color = tokens.secondaryAccent,
    );
  }

  @override
  bool shouldRepaint(covariant _CoquetteDividerPainter oldDelegate) =>
      colors != oldDelegate.colors || tokens != oldDelegate.tokens;
}

class CoquetteNavigationItem {
  const CoquetteNavigationItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Boutique tray navigation with a label-tab selection state.
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tokens =
        CoquetteSurfaceTokens.maybeOf(context) ??
        CoquetteSurfaceTokens.forBrightness(
          dark ? Brightness.dark : Brightness.light,
        );
    return Container(
      height: 74,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: dark ? tokens.primarySurface : colors.ivory,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
          bottom: Radius.circular(20),
        ),
        border: Border.all(color: tokens.mutedBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .24 : .08),
            blurRadius: 18,
            offset: const Offset(0, -4),
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
                                ? tokens.primaryAccent
                                : tokens.secondaryText,
                          ),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: selectedIndex == index ? 30 : 18,
                            height: selectedIndex == index ? 19 : 2,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? (dark
                                        ? tokens.selectedSurface
                                        : colors.blush.withValues(alpha: .72))
                                  : tokens.mutedBorder.withValues(alpha: .58),
                              borderRadius: BorderRadius.circular(12),
                              border: selectedIndex == index
                                  ? Border.all(color: tokens.primaryAccent)
                                  : null,
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
