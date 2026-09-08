import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/leaf.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 45 Changes Needed — a host's route held back before publishing. One clear
/// ask, then everything that already passed, so the fix is obvious.
class ChangesNeededScreen extends StatelessWidget {
  const ChangesNeededScreen({super.key});

  static const _passed = [
    'Meet point approved',
    'Capacity within limit',
    'Host verified',
  ];

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
              child: BackHeader(title: 'Route status'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                24,
                Insets.gutter,
                24,
              ),
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CloverColors.orangeTint,
                      shape: BoxShape.circle,
                    ),
                    child: const PackIcon(
                      PackIcons.document,
                      size: 54,
                      color: CloverColors.orangeDark,
                    ),
                  ),
                ),
                const Gap(28),
                Center(
                  child: Text(
                    'NOT PUBLISHED',
                    style: AppText.badge.copyWith(
                      fontSize: 12,
                      color: CloverColors.orangeDark,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Gap(14),
                Center(
                  child: Text(
                    'Changes needed',
                    style: AppText.title.copyWith(fontSize: 25),
                  ),
                ),
                const Gap(16),
                Text(
                  "Morning Route wasn't published yet. An admin has asked for one "
                  'change before it can go live.',
                  style: AppText.body.copyWith(fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
                const Gap(34),
                const Callout(
                  title: 'What needs changing',
                  body:
                      'Add a reason for restricting the route to women aged 25–40. '
                      'Venue policy is enough.',
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.info,
                  iconColour: CloverColors.orangeDark,
                ),
                const Gap(30),
                Text('Everything else passed', style: AppText.section),
                const Gap(16),
                for (final item in _passed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        const LeafMark(size: 16),
                        const SizedBox(width: 12),
                        Text(
                          item,
                          style: AppText.bodyStrong.copyWith(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Edit and resubmit',
              color: CloverColors.orange,
              onPressed: () => context.push('/create-route'),
            ),
          ),
        ],
      ),
    );
  }
}
