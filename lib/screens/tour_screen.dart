import 'dart:async';

import 'package:flutter/material.dart';

import 'catalogue.dart';
import 'registry.dart';

/// Walks the whole pack, one screen at a time, for reviewing the build on a
/// device: `flutter run --dart-define=TOUR=1`.
///
/// Screens are built directly from the catalogue rather than pushed as routes,
/// so there are no transitions to wait on and every screen gets an identical
/// amount of time on screen.
class TourScreen extends StatefulWidget {
  const TourScreen({
    super.key,
    this.dwell = const Duration(milliseconds: 2500),
  });

  /// How long each screen is held before advancing.
  final Duration dwell;

  static List<ScreenEntry> get screens => [
    for (final section in screenSections)
      for (final screen in section.screens) screen,
  ];

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.dwell, (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % TourScreen.screens.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = TourScreen.screens[_index];
    // Keyed so each screen gets fresh state rather than inheriting the last's.
    return KeyedSubtree(
      key: ValueKey(screen.path),
      child: screen.builder(context),
    );
  }
}
