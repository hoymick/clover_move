import 'package:flutter/widgets.dart';

/// Colour values taken verbatim from the Clover Move identity. Four brand
/// values plus tints derived from them — nothing else is allowed in the UI.
abstract final class CloverColors {
  // Brand
  static const green = Color(0xFF169B62);
  static const orange = Color(0xFFFF883E);
  static const ink = Color(0xFF02383F);
  static const white = Color(0xFFFFFFFF);

  // Ink ramp
  static const inkSoft = Color(0xFF3B676C);
  static const muted = Color(0xFF6E9296);
  static const hint = Color(0xFFA3BCBE);

  // Surfaces
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4F8F8);
  static const greenTint = Color(0xFFE7F5EF);
  static const orangeTint = Color(0xFFFFF1E8);
  static const orangeDark = Color(0xFFC4571A);

  // Lines
  static const border = Color(0xFFDEE9E9);
  static const borderStrong = Color(0xFFC6D8D9);
  static const divider = Color(0xFFEDF3F3);

  // Status
  static const amber = Color(0xFFFFB020);
  static const red = Color(0xFFDA291C);
  static const info = Color(0xFF2E7DF7);
}

/// Corner radii, read off the mockups. The design uses a distinct radius per
/// component size rather than one global scale.
abstract final class Radii {
  static const card = 20.0; // 342 x 92 rows, list cards
  static const cardLarge = 26.0; // 342 x 176 feature cards
  static const tile = 18.0; // event cards, primary button
  static const field = 13.0; // 44h search field / inputs
  static const row = 11.0; // 36h compact rows
  static const iconLarge = 22.0; // 68 x 68 icon tile
  static const icon = 9.0; // 28 x 28 icon chip
  static const iconSmall = 8.0; // 26 x 26 icon chip
  static const pill = 999.0;
}

/// Layout constants. The mockups are drawn on a 390 x 844 canvas; horizontal
/// gutters are 24 with a 342 content width.
abstract final class Insets {
  static const gutter = 24.0;
  static const gutterWide = 28.0;
  static const textGutter = 26.0;
  static const buttonHeight = 58.0;
  static const fieldHeight = 44.0;
  static const navHeight = 58.0;
  static const designWidth = 390.0;
}
