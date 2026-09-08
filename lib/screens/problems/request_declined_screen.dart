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

/// 41 Request Declined — the host couldn't give a place. The panel says plainly
/// that hosts owe no reason, so a decline doesn't read as a judgement, and
/// alternatives sit directly underneath.
class RequestDeclinedScreen extends StatelessWidget {
  const RequestDeclinedScreen({super.key});

  static const _similar = [
    ('Sunrise Coastal Run', 'Wed 06:45 · 4 places', CloverColors.green),
    ('Stillorgan Strength', 'Mon 07:00 · 6 places', CloverColors.orange),
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
              child: BackHeader(title: 'Your request'),
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
                      color: CloverColors.divider,
                      shape: BoxShape.circle,
                    ),
                    child: const PackIcon(
                      PackIcons.close,
                      size: 46,
                      color: CloverColors.muted,
                    ),
                  ),
                ),
                const Gap(42),
                Center(
                  child: Text(
                    'Request not accepted',
                    style: AppText.title.copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(18),
                Text(
                  "Niamh L. wasn't able to give you a place on Morning Route this "
                  'time. No payment was taken.',
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                ),
                const Gap(26),
                const Callout(
                  title: 'Nothing went wrong',
                  body:
                      "Hosts don't have to give a reason. Places are often "
                      'simply full.',
                  tint: CloverColors.surfaceMuted,
                  icon: PackIcons.info,
                  iconColour: CloverColors.inkSoft,
                ),
                const Gap(28),
                Text('Similar routes near you', style: AppText.section),
                const Gap(12),
                for (final (title, meta, colour) in _similar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SpineRow(
                      title: title,
                      meta: meta,
                      colour: colour,
                      onTap: () => context.push('/user-route'),
                    ),
                  ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Find another route',
              onPressed: () => context.push('/search-results'),
            ),
          ),
        ],
      ),
    );
  }
}
