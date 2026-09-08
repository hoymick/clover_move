import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/segmented_tabs.dart';
import '../../widgets/thumb.dart';

/// 10 Smart Jersey Kit — the kit contents, sleeve and size. The kit activates
/// Smart Jerseys; a single jersey does not, and the pack says so in orange right
/// under the price so it can't be missed.
class JerseyKitScreen extends StatefulWidget {
  const JerseyKitScreen({super.key});

  @override
  State<JerseyKitScreen> createState() => _JerseyKitScreenState();
}

class _JerseyKitScreenState extends State<JerseyKitScreen> {
  static const _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  static const _contents = [
    '3 Smart Jerseys',
    '1 Clover Move bag',
    '3 packaging tubes',
    '1 welcome guide',
  ];

  int _sleeve = 0;
  int _size = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Official Store',
                action: HeaderIconAction(
                  icon: PackIcons.bag,
                  onTap: () => context.push('/bag'),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                8,
                Insets.gutter,
                24,
              ),
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: CloverColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: ProductImage(image: '10_smart_jersey_kit_1.jpg'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ProductImage(image: '10_smart_jersey_kit_2.jpg'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ProductImage(image: '10_smart_jersey_kit_3.jpg'),
                      ),
                    ],
                  ),
                ),
                const Gap(14),
                Center(
                  child: Text(
                    '3 jerseys  ·  1 bag  ·  3 tubes  ·  welcome guide',
                    style: AppText.caption.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(24),
                Text(
                  'Smart Jersey Kit',
                  style: AppText.title.copyWith(fontSize: 25),
                ),
                const Gap(8),
                Text(
                  'Green, White & Orange — the full set',
                  style: AppText.caption.copyWith(fontSize: 13),
                ),
                const Gap(20),
                Row(
                  children: [
                    Text(
                      '€89.00',
                      style: AppText.title.copyWith(
                        fontSize: 26,
                        color: CloverColors.green,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: StatusBadge(
                        label: 'Activates Smart Jerseys',
                        fontSize: 11.5,
                        colour: CloverColors.ink,
                        background: CloverColors.greenTint,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    const PackIcon(
                      PackIcons.arrowRight,
                      size: 16,
                      color: CloverColors.orangeDark,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Single jerseys €34 — no Smart Jerseys',
                        style: AppText.cardTitle.copyWith(
                          fontSize: 12.5,
                          color: CloverColors.orangeDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap(26),
                const FieldLabel('Sleeve'),
                SegmentedTabs(
                  labels: const ['Long sleeve', 'Short sleeve'],
                  selected: _sleeve,
                  onChanged: (value) => setState(() => _sleeve = value),
                ),
                const Gap(22),
                const FieldLabel('Size'),
                Row(
                  children: [
                    for (var i = 0; i < _sizes.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _SizeBox(
                          label: _sizes[i],
                          selected: i == _size,
                          onTap: () => setState(() => _size = i),
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(26),
                Text(
                  "What's in the kit",
                  style: AppText.section.copyWith(fontSize: 15.5),
                ),
                const Gap(14),
                const TickGrid(items: _contents),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Add to Bag  ·  €89.00',
              onPressed: () => context.push('/bag'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeBox extends StatelessWidget {
  const _SizeBox({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: selected
          ? BorderSide.none
          : const BorderSide(color: CloverColors.border),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? CloverColors.green : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                label,
                style: AppText.pill.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? CloverColors.white : CloverColors.inkSoft,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
