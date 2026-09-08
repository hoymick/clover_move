import 'package:flutter/widgets.dart';

import 'tokens.dart';

const _family = 'BalooBhai2';

/// Named text styles matching the mockups. Sizes are the exact values from the
/// SVG source, so screens never hand-roll a TextStyle.
abstract final class AppText {
  static TextStyle _s(
    double size,
    FontWeight weight, {
    Color color = CloverColors.ink,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: _family,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  /// Welcome wordmark.
  static final hero = _s(42, FontWeight.w800, height: 1.1);

  /// Screen title, e.g. "Choose your colour", "Before you start".
  static final title = _s(27, FontWeight.w800, height: 1.15);

  /// Card heading, e.g. "Green" on the colour picker.
  static final headline = _s(22, FontWeight.w800);

  /// Sheet / step heading.
  static final subtitle = _s(20, FontWeight.w800);

  /// Section header above a list, e.g. "Official Events".
  static final section = _s(17, FontWeight.w700);

  /// Primary button label.
  static final button = _s(16.5, FontWeight.w700, color: CloverColors.white);

  /// Secondary button label.
  static final buttonAlt = _s(15, FontWeight.w700, color: CloverColors.inkSoft);

  /// Row / card title.
  static final cardTitle = _s(15.5, FontWeight.w700);

  /// Body copy, muted.
  static final body = _s(
    14,
    FontWeight.w500,
    color: CloverColors.muted,
    height: 1.55,
  );

  /// Body copy on a tinted panel.
  static final bodyStrong = _s(
    14.5,
    FontWeight.w500,
    color: CloverColors.inkSoft,
    height: 1.65,
  );

  /// Compact list title.
  static final rowTitle = _s(13.5, FontWeight.w700);

  /// Metadata under a row title.
  static final rowMeta = _s(11, FontWeight.w500, color: CloverColors.muted);

  /// Card supporting line.
  static final caption = _s(12, FontWeight.w500, color: CloverColors.muted);

  /// "See all" style link.
  static final link = _s(13, FontWeight.w600, color: CloverColors.green);

  /// Category pill label.
  static final pill = _s(12.5, FontWeight.w700, color: CloverColors.inkSoft);

  /// Price.
  static final price = _s(12.5, FontWeight.w800, color: CloverColors.green);

  /// Small badge / chip label.
  static final badge = _s(10.5, FontWeight.w700, color: CloverColors.white);

  /// Bottom-nav label.
  static final nav = _s(10, FontWeight.w500, color: CloverColors.hint);

  /// Footnote centred at the bottom of a screen.
  static final footnote = _s(12.5, FontWeight.w500, color: CloverColors.muted);
}
