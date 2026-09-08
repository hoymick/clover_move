import 'package:flutter/widgets.dart';

/// One entry per screen in the design pack. The registry is the single source
/// of truth: the router builds its routes from it and the gallery lists it, so
/// adding a screen means adding one line here.
class ScreenEntry {
  const ScreenEntry({
    required this.code,
    required this.title,
    required this.blurb,
    required this.path,
    required this.builder,
  });

  /// Number from the design pack, e.g. "11c".
  final String code;
  final String title;

  /// The caption printed under the frame in the design pack.
  final String blurb;

  /// Route path, without a leading slash.
  final String path;
  final WidgetBuilder builder;
}

/// A section of the design pack, in pack order.
class ScreenSection {
  const ScreenSection({required this.title, required this.screens});

  final String title;
  final List<ScreenEntry> screens;
}
