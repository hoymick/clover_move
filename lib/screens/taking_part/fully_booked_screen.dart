import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/rating.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';

/// 46 Fully Booked — the waiting list. The terms are spelled out in the callout
/// so joining the list never feels like a hidden commitment.
class FullyBookedScreen extends StatelessWidget {
  const FullyBookedScreen({super.key});

  static const _alternatives = [
    ('Phoenix Park 10K', 'Sun 16 Aug · 08:30', '12 left'),
    ('Bray Cliff Walk', 'Sat 15 Aug · 10:00', '5 left'),
  ];

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    DetailHero(height: 232, category: category),
                    const Positioned(
                      left: Insets.gutter,
                      bottom: 34,
                      child: StatusBadge(
                        label: 'FULLY BOOKED',
                        fontSize: 10.5,
                        colour: CloverColors.ink,
                        background: CloverColors.white,
                      ),
                    ),
                  ],
                ),
                DetailSheet(
                  children: [
                    Text(
                      'Howth Cliff Walk',
                      style: AppText.title.copyWith(fontSize: 23),
                    ),
                    const Gap(8),
                    Text(
                      'Sat 15 Aug · 09:00 · Howth DART Stn',
                      style: AppText.caption.copyWith(fontSize: 13),
                    ),
                    const Gap(22),
                    const CapacityBar(filled: 40, total: 40),
                    const Gap(14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '40 of 40 places taken',
                            style: AppText.cardTitle.copyWith(fontSize: 13.5),
                          ),
                        ),
                        Text(
                          '6 waiting',
                          style: AppText.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(22),
                    const Callout(
                      title: 'Join the waiting list',
                      body:
                          "If someone drops out we'll notify you and hold the place for "
                          '30 minutes. Nothing is charged until you accept.',
                      icon: PackIcons.bell,
                    ),
                    const Gap(26),
                    Text('Same weekend, places left', style: AppText.section),
                    const Gap(12),
                    for (final (title, schedule, left) in _alternatives)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AlternativeRow(
                          title: title,
                          when: schedule,
                          left: left,
                          onTap: () => context.push('/official-event'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Join waiting list',
              icon: PackIcons.bell,
              onPressed: () => context.push('/notifications'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Spine row with a "places left" badge on the trailing edge.
class _AlternativeRow extends StatelessWidget {
  const _AlternativeRow({
    required this.title,
    required this.when,
    required this.left,
    required this.onTap,
  });

  final String title;
  final String when;
  final String left;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: CloverColors.border),
    );

    return Material(
      color: CloverColors.white,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 62),
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: ColoredBox(color: CloverColors.green),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppText.rowTitle.copyWith(fontSize: 13.5),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            when,
                            style: AppText.rowMeta.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusBadge(label: left, fontSize: 10.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
