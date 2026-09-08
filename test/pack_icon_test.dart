import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clover_move/theme/pack_icons.dart';
import 'package:clover_move/widgets/pack_icon.dart';

void main() {
  testWidgets('every pack icon parses and paints', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final entry in PackIcons.all.entries)
                PackIcon(entry.value, size: 24),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(PackIcon), findsNWidgets(PackIcons.all.length));
  });
}
