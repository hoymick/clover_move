import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/detail.dart';
import '../../widgets/leaf.dart';
import '../../widgets/rating.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 31 Event Check-in — arrived at the Meet Point. Confirmation first, then the
/// facts, then who else has arrived.
class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.green,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -60,
            child: _Disc(size: 380, opacity: 0.07),
          ),
          Positioned(
            bottom: -240,
            left: -140,
            child: _Disc(size: 340, opacity: 0.10, colour: CloverColors.ink),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                30,
                Insets.gutter,
                24,
              ),
              children: [
                Center(
                  child: Container(
                    width: 124,
                    height: 124,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CloverColors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 94,
                      height: 94,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: CloverColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const PackIcon(
                        PackIcons.check,
                        size: 48,
                        color: CloverColors.green,
                      ),
                    ),
                  ),
                ),
                const Gap(34),
                Center(
                  child: Text(
                    "You're checked in",
                    style: AppText.title.copyWith(
                      fontSize: 28,
                      color: CloverColors.white,
                    ),
                  ),
                ),
                const Gap(12),
                Center(
                  child: Text(
                    '09:04 · Howth DART Station',
                    style: AppText.body.copyWith(
                      fontSize: 13.5,
                      color: const Color(0xFFCFEADD),
                    ),
                  ),
                ),
                const Gap(34),
                SpecGrid(
                  bordered: true,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Howth Cliff Walk',
                        style: AppText.subtitle.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Official Clover Move Event',
                        style: AppText.caption.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ),
                  rows: const [
                    [
                      Spec(PackIcons.clock, 'Starts', '09:00'),
                      Spec(PackIcons.people, 'Checked in', '18 of 24'),
                    ],
                  ],
                ),
                const Gap(34),
                Text(
                  'Who else is here',
                  style: AppText.section.copyWith(
                    fontSize: 15.5,
                    color: CloverColors.white,
                  ),
                ),
                const Gap(16),
                const AvatarStack(
                  initials: ['AK', 'MO', 'SN', 'PR', 'DM'],
                  moreLabel: '+13 more',
                ),
                const Gap(34),
                _WhiteButton(
                  label: 'Back to event',
                  onPressed: () => context.push('/official-event'),
                ),
                const Gap(22),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LeafMark(size: 14, color: Color(0xFFBFE2D2)),
                      const SizedBox(width: 8),
                      Text(
                        'Your jersey colour: ${category.label}',
                        style: AppText.caption.copyWith(
                          fontSize: 12,
                          color: const Color(0xFFBFE2D2),
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
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({
    required this.size,
    required this.opacity,
    this.colour = CloverColors.white,
  });

  final double size;
  final double opacity;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colour.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WhiteButton extends StatelessWidget {
  const _WhiteButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppText.button.copyWith(
              color: CloverColors.green,
              fontSize: 15.5,
            ),
          ),
        ),
      ),
    );
  }
}
