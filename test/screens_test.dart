import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:clover_move/screens/catalogue.dart';
import 'package:clover_move/state/app_state.dart';
import 'package:clover_move/theme/app_theme.dart';

/// Every screen is drawn once on the 390 x 844 design canvas. Overflows and
/// build errors surface as test failures, so a broken screen can't slip into
/// the gallery unnoticed.
void main() {
  final screens = [
    for (final section in screenSections)
      for (final screen in section.screens) screen,
  ];

  for (final screen in screens) {
    testWidgets('${screen.code} ${screen.title} renders', (tester) async {
      tester.view
        ..physicalSize = const Size(390 * 3, 844 * 3)
        ..devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppState(),
          child: MaterialApp(
            theme: AppTheme.light,
            home: Builder(builder: screen.builder),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
    });
  }
}
