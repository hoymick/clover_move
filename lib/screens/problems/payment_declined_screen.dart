import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 43 Payment Declined — recovery with the place held. The hold and the "nothing
/// charged" reassurance lead; the fixes follow in the order most likely to work.
class PaymentDeclinedScreen extends StatelessWidget {
  const PaymentDeclinedScreen({super.key});

  static const _fixes = [
    ('Check the card details', 'Number, expiry and CVC', PackIcons.card),
    (
      'Approve it in your banking app',
      'Some banks ask to confirm',
      PackIcons.shieldCheck,
    ),
    (
      'Try a different method',
      'Apple Pay, Google Pay or another card',
      PackIcons.ticketTag,
    ),
  ];

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
                title: 'Payment',
                action: HeaderIconAction(
                  icon: PackIcons.lock,
                  bare: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                14,
                Insets.gutter,
                24,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CloverColors.orangeTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const PackIcon(
                            PackIcons.info,
                            size: 22,
                            color: CloverColors.orangeDark,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Payment declined',
                              style: AppText.subtitle.copyWith(
                                fontSize: 16.5,
                                color: CloverColors.orangeDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Text(
                        'Your bank turned down the payment. Nothing has been '
                        'charged and your place is held for 15 minutes.',
                        style: AppText.caption.copyWith(
                          fontSize: 12.5,
                          color: CloverColors.orangeDark,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(28),
                Text('What usually fixes it', style: AppText.section),
                const Gap(12),
                for (final (title, meta, icon) in _fixes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CloverCard(
                      radius: 16,
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            size: 32,
                            radius: 10,
                            color: CloverColors.divider,
                            child: PackIcon(
                              icon,
                              size: 17,
                              color: CloverColors.inkSoft,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppText.rowTitle.copyWith(
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  meta,
                                  style: AppText.rowMeta.copyWith(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Gap(18),
                CloverCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Howth Cliff Walk',
                              style: AppText.cardTitle.copyWith(fontSize: 14.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sat 15 Aug · 09:00 · 1 place',
                              style: AppText.caption.copyWith(fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '€12.20',
                        style: AppText.title.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const Gap(22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PackIcon(
                      PackIcons.clock,
                      size: 15,
                      color: CloverColors.orangeDark,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Place held for 14:52',
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
              ],
            ),
          ),
          StickyBar(
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Try again',
                  onPressed: () => context.push('/ticket'),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: 'Use another method',
                  onPressed: () => context.push('/payment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
