import 'package:flutter/material.dart';

abstract final class MonySpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
  static const double x8 = 32;
}

abstract final class MonyRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 24;
}

abstract final class MonyMotion {
  static const Duration quick = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 220);
  static const Duration emphasis = Duration(milliseconds: 320);
  static const Curve standardCurve = Curves.easeInOutCubic;

  static Duration durationFor(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

  static Curve curveFor(BuildContext context, Curve curve) =>
      MediaQuery.disableAnimationsOf(context) ? Curves.linear : curve;
}

abstract final class MonyBreakpoints {
  static const double compact = 600;
  static const double expanded = 840;
  static const double contentMax = 1120;
}

abstract final class MonyPalette {
  static const Color darkBackground = Color(0xFF100E14);
  static const Color darkSurface = Color(0xFF1A1721);
  static const Color darkSurfaceVariant = Color(0xFF24202D);
  static const Color lightBackground = Color(0xFFF7F5FA);
  static const Color lightSurface = Color(0xFFFFFEFF);
  static const Color lightSurfaceVariant = Color(0xFFEDE9F2);
  static const Color lavender = Color(0xFFB99AF4);
  static const Color lavenderDark = Color(0xFF6D46A8);
  static const Color income = Color(0xFF73D9B0);
  static const Color incomeDark = Color(0xFF167553);
  static const Color expense = Color(0xFFF28A9A);
  static const Color expenseDark = Color(0xFFAA3E51);
  static const Color warning = Color(0xFFEFC16D);
  static const Color warningDark = Color(0xFF815C16);
}
