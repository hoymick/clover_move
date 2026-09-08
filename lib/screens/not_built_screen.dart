import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../widgets/buttons.dart';
import '../widgets/headers.dart';
import '../widgets/scaffolds.dart';

/// Shown when a screen links to a route that isn't in the catalogue yet.
class NotBuiltScreen extends StatelessWidget {
  const NotBuiltScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(title: 'Not drawn yet'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MessagePanel(
                    title: 'Screen not built yet',
                    body:
                        'Nothing in the pack is wired to $path so far. '
                        'Pick another screen from the index.',
                    tint: CloverColors.surfaceMuted,
                    iconColour: CloverColors.hint,
                    leaf: true,
                  ),
                  const Gap(30),
                  PrimaryButton(
                    label: 'Back to the index',
                    onPressed: () => context.go('/index'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
