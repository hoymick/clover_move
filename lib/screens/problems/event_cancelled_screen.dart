import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 42 Event Cancelled — refund and reschedule. The refund terms come before the
/// host's explanation, because that is the part that costs money.
class EventCancelledScreen extends StatelessWidget {
  const EventCancelledScreen({super.key});

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
              child: BackHeader(title: 'Your booking'),
            ),
          ),
          Expanded(
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
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CloverColors.orangeTint,
                      shape: BoxShape.circle,
                    ),
                    child: const PackIcon(
                      PackIcons.calendar,
                      size: 46,
                      color: CloverColors.orangeDark,
                    ),
                  ),
                ),
                const Gap(30),
                Center(
                  child: Text(
                    'SAT 15 AUG · 09:00',
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
                    'Event cancelled',
                    style: AppText.title.copyWith(fontSize: 25),
                  ),
                ),
                const Gap(18),
                Text(
                  'The host cancelled Howth Cliff Walk because of a weather '
                  'warning for Saturday morning.',
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                ),
                const Gap(26),
                const Callout(
                  title: '€12.20 refunded in full',
                  body:
                      'Back on the card ending 8842 within 5 working days. '
                      'Your ticket is now void.',
                  icon: PackIcons.card,
                ),
                const Gap(28),
                Text('The host said', style: AppText.section),
                const Gap(12),
                const HostRow(
                  name: 'Clover Move Ireland',
                  meta:
                      'Status Orange wind warning on the cliff path. '
                      'Rescheduling for the 22nd.',
                  initials: 'CM',
                  boxed: true,
                  metaLines: 2,
                ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: SecondaryButton(
                    label: 'Close',
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'See the new date',
                    onPressed: () => context.push('/official-event'),
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
