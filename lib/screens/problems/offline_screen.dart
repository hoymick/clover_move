import 'package:flutter/material.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 39 Offline / Error — what still works offline. Listing what survives matters
/// more than the error: a ticket held on the phone is the reason to stay calm.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  static const _available = [
    'Your digital tickets',
    'Your Smart Jerseys token',
    'Saved meet point directions',
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
              child: BackHeader(title: 'Connection'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                40,
                Insets.gutter,
                24,
              ),
              children: [
                Center(
                  child: Container(
                    width: 132,
                    height: 132,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CloverColors.orangeTint,
                      shape: BoxShape.circle,
                    ),
                    child: const PackIcon(
                      PackIcons.info,
                      size: 52,
                      color: CloverColors.orangeDark,
                    ),
                  ),
                ),
                const Gap(46),
                Center(
                  child: Text(
                    "You're offline",
                    style: AppText.title.copyWith(fontSize: 25),
                  ),
                ),
                const Gap(18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "We can't reach Clover Move right now. Check your connection "
                    'and try again.',
                    style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(38),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryButton(label: 'Try again', onPressed: () {}),
                ),
                const Gap(34),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CloverColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: CloverColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Still available offline',
                        style: AppText.cardTitle.copyWith(fontSize: 13.5),
                      ),
                      const Gap(14),
                      for (final item in _available)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              const PackIcon(
                                PackIcons.check,
                                size: 15,
                                color: CloverColors.green,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: AppText.bodyStrong.copyWith(
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(34),
                Center(
                  child: Text(
                    'Error CM-503 · 14:32',
                    style: AppText.caption.copyWith(
                      fontSize: 11,
                      color: CloverColors.hint,
                    ),
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
