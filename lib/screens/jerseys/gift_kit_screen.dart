import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';

/// 11g Gift a Kit — all three jerseys transfer at once. A kit with a jersey out
/// on loan can't be gifted whole, so that kit is shown disabled with the reason.
class GiftKitScreen extends StatefulWidget {
  const GiftKitScreen({super.key});

  @override
  State<GiftKitScreen> createState() => _GiftKitScreenState();
}

class _GiftKitScreenState extends State<GiftKitScreen> {
  int? _chosen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(title: 'Gift a complete kit'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                16,
                Insets.gutter,
                24,
              ),
              children: [
                Text(
                  'Gifting a whole kit transfers all three jerseys at once. Only '
                  'complete-kit owners can do this.',
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                ),
                const Gap(22),
                const FieldLabel('Select kit'),
                _KitCard(
                  name: 'KIT 01',
                  note: '1 jersey shared',
                  enabled: false,
                  selected: false,
                  onTap: () {},
                ),
                const Gap(12),
                _KitCard(
                  name: 'KIT 02',
                  note: 'Complete',
                  enabled: true,
                  selected: _chosen == 1,
                  onTap: () => setState(() => _chosen = 1),
                ),
                const Gap(18),
                const Callout(
                  title: 'This transfers ownership',
                  body:
                      'All three jerseys move to the recipient. Your permanent '
                      'token stays with you.',
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.shieldCheck,
                  iconColour: CloverColors.orangeDark,
                ),
                const Gap(12),
                const Callout(
                  title: 'The recipient keeps their own token',
                  body:
                      'If they have no token yet, one is created. If they '
                      'do, they keep it.',
                  tint: CloverColors.divider,
                  icon: PackIcons.info,
                  iconColour: CloverColors.inkSoft,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: _chosen == null
                  ? 'Choose a complete kit'
                  : 'Confirm gift · Kit 02',
              onPressed: _chosen == null ? null : () => context.push('/claim'),
            ),
          ),
        ],
      ),
    );
  }
}

/// A kit as a giftable unit: its three leaves shown together.
class _KitCard extends StatelessWidget {
  const _KitCard({
    required this.name,
    required this.note,
    required this.enabled,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String note;
  final bool enabled;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color: selected ? CloverColors.green : CloverColors.border,
        width: selected ? 1.5 : 1,
      ),
    );

    return Semantics(
      selected: selected,
      button: enabled,
      child: Material(
        color: selected ? CloverColors.greenTint : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppText.cardTitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: enabled ? CloverColors.ink : CloverColors.hint,
                        ),
                      ),
                    ),
                    StatusBadge(
                      label: note,
                      fontSize: 10.5,
                      colour: enabled ? CloverColors.green : CloverColors.muted,
                      background: enabled
                          ? CloverColors.greenTint
                          : CloverColors.divider,
                    ),
                  ],
                ),
                const Gap(20),
                Opacity(
                  opacity: enabled ? 1 : 0.4,
                  child: Row(
                    children: [
                      for (final category in LeafCategory.values)
                        Expanded(
                          child: Column(
                            children: [
                              CategoryLeaf(category: category, size: 52),
                              const SizedBox(height: 10),
                              Text(
                                category.label,
                                style: AppText.pill.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: enabled
                                      ? CloverColors.ink
                                      : CloverColors.hint,
                                ),
                              ),
                            ],
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
