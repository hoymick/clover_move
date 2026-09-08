import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/leaf.dart';
import '../../widgets/nav_shell.dart';

/// 38 Empty State — no routes in this area. The way out is offered twice: make
/// one, or widen the search. Switching colour is suggested at the foot.
class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.surfaceMuted,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Routes near you',
                action: HeaderIconAction(
                  icon: PackIcons.sliders,
                  bare: true,
                  onTap: () => context.push('/filters'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.gutter,
              4,
              Insets.gutter,
              0,
            ),
            child: Row(
              children: [
                for (final leaf in LeafCategory.values) ...[
                  if (leaf != LeafCategory.values.first)
                    const SizedBox(width: 8),
                  CloverChip(
                    label: leaf.label,
                    selected: leaf == category,
                    height: 36,
                    fontSize: 13,
                    selectedColour: leaf == LeafCategory.white
                        ? CloverColors.inkSoft
                        : leaf.colour,
                    onTap: () => context.read<AppState>().setCategory(leaf),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 164,
                  height: 164,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CloverColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: const Opacity(
                    opacity: 0.38,
                    child: CloverLogo(size: 96),
                  ),
                ),
                const SizedBox(height: 34),
                Text(
                  'Nothing here yet',
                  style: AppText.title.copyWith(fontSize: 23),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52),
                  child: Text(
                    'No ${category.label} routes within 15 km of Stillorgan this week. '
                    'Be the first to put one on the map.',
                    style: AppText.body.copyWith(fontSize: 13.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Create a route',
                  icon: PackIcons.plus,
                  onPressed: () => context.push('/create-route'),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Search a wider area',
                  onPressed: () => context.push('/filters'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 44),
            child: Divider(height: 1),
          ),
          const SizedBox(height: 20),
          Text(
            'Or switch colour to see cycling and fitness',
            style: AppText.footnote.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 24),
          const CloverNavBar(active: NavTab.routes),
        ],
      ),
    );
  }
}
