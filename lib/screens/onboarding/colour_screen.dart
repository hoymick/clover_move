import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/category_leaf.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 02 Choose Colour — the three leaves as full-width buttons on the muted
/// ground. Each card carries a colour spine on its leading edge, the category's
/// leaf with its activity pictogram, and the activities it covers.
class ColourScreen extends StatelessWidget {
  const ColourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<AppState, LeafCategory?>((s) => s.category);

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.textGutter,
                26,
                Insets.textGutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose your colour', style: AppText.title),
                  const SizedBox(height: 12),
                  Text(
                    'Every activity, route, venue and brand in Clover Move '
                    'lives under one of the three leaves.',
                    style: AppText.body.copyWith(fontSize: 13.5, height: 1.5),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  Insets.gutter,
                  30,
                  Insets.gutter,
                  12,
                ),
                itemCount: LeafCategory.values.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final category = LeafCategory.values[index];
                  return _ColourCard(
                    category: category,
                    isSelected: category == selected,
                    onTap: () {
                      context.read<AppState>().setCategory(category);
                      context.push('/terms');
                    },
                  );
                },
              ),
            ),
            Text('You can switch colour at any time', style: AppText.footnote),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ColourCard extends StatelessWidget {
  const _ColourCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final LeafCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.cardLarge),
      side: BorderSide(
        color: isSelected ? category.markColour : CloverColors.border,
        width: isSelected ? 1.5 : 1,
      ),
    );

    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: CloverColors.white,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            // A minimum rather than a fixed height: the type sets a little
            // taller than the drawing.
            constraints: const BoxConstraints(minHeight: 176),
            child: Stack(
              children: [
                // The 7-wide colour spine on the leading edge.
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 7,
                  child: ColoredBox(color: category.colour),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 26, 20, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CategoryLeaf(category: category, size: 74),
                          const SizedBox(width: 22),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(category.label, style: AppText.headline),
                                const SizedBox(height: 4),
                                Text(
                                  category.activityCountLabel,
                                  style: AppText.caption.copyWith(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PackIcon(
                            PackIcons.chevronRight,
                            size: 26,
                            color: CloverColors.hint,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        category.activities,
                        style: AppText.bodyStrong.copyWith(
                          fontSize: 13.5,
                          height: 1.75,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
