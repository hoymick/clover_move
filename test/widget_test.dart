import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:clover_move/app.dart';
import 'package:clover_move/screens/catalogue.dart';
import 'package:clover_move/screens/gallery_screen.dart';
import 'package:clover_move/screens/splash_screen.dart';
import 'package:clover_move/state/app_state.dart';
import 'package:clover_move/theme/app_theme.dart';

/// Puts the test window on the pack's canvas; the default 800 x 600 is neither
/// a phone nor the size these screens are drawn for.
void _useDesignCanvas(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(390 * 3, 844 * 3)
    ..devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('the app opens on the splash, then hands over to welcome', (
    tester,
  ) async {
    _useDesignCanvas(tester);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const CloverMoveApp(),
      ),
    );
    await tester.pump();

    // The transparent animation stays on screen for one complete play-through,
    // then the timer carries us on to Welcome.
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 8));
    await tester.pump();

    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('I already have Smart Jerseys'), findsOneWidget);
  });

  testWidgets('the index lists the sections it has scrolled to', (
    tester,
  ) async {
    _useDesignCanvas(tester);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: MaterialApp(theme: AppTheme.light, home: const GalleryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Only the sections in view are built, so walk the list and tick each off.
    final remaining = screenSections.map((s) => s.title).toSet();
    for (var i = 0; i < 40 && remaining.isNotEmpty; i++) {
      remaining.removeWhere((title) => find.text(title).evaluate().isNotEmpty);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
    }

    expect(remaining, isEmpty, reason: 'never rendered: $remaining');
  });

  test('screen paths are unique', () {
    final paths = [
      for (final section in screenSections)
        for (final screen in section.screens) screen.path,
    ];
    expect(paths.toSet().length, paths.length);
  });
}
