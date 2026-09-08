import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/jersey_row.dart';
import '../../widgets/leaf.dart';
import '../../widgets/qr.dart';
import '../../widgets/scaffolds.dart';

/// 11 Smart Jerseys — one permanent token, the kits under it, and optional
/// sharing. The token is stated as permanent and one-per-account; sharing is
/// stated as optional with no deadline, since that is the pack's promise.
class SmartJerseysScreen extends StatelessWidget {
  const SmartJerseysScreen({super.key});

  static const _kits = [
    (
      'KIT 01',
      'Long sleeve',
      [JerseyState.yours, JerseyState.shared, JerseyState.yours],
    ),
    (
      'KIT 02',
      'Short sleeve',
      [JerseyState.yours, JerseyState.yours, JerseyState.yours],
    ),
  ];

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
              child: BackHeader(title: 'Smart Jerseys'),
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
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CloverColors.ink,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CloverColors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const CloverLogo(size: 34),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Jerseys Token',
                              style: AppText.cardTitle.copyWith(
                                fontSize: 13.5,
                                color: CloverColors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'CM-SJ-7F82-K4P9-X6',
                              style: AppText.cardTitle.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF9FD9BC),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Permanent · one per account',
                              style: AppText.caption.copyWith(
                                fontSize: 10.5,
                                color: const Color(0xFF8FB3B0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CloverColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const QrBlock(size: 44, modules: 15, seed: 7382),
                      ),
                    ],
                  ),
                ),
                const Gap(18),
                const Callout(
                  title: 'Sharing is optional — there is no deadline',
                  body: 'Keep all three, or pass one on whenever you like.',
                  icon: PackIcons.info,
                ),
                const Gap(26),
                Row(
                  children: [
                    Expanded(child: Text('My Kits', style: AppText.section)),
                    Text('2 kits', style: AppText.link),
                  ],
                ),
                const Gap(12),
                for (final (name, sleeve, states) in _kits) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: AppText.cardTitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          sleeve,
                          style: AppText.link.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (var i = 0; i < LeafCategory.values.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: JerseyRow(
                        category: LeafCategory.values[i],
                        meta:
                            '$sleeve · SJ-${LeafCategory.values[i].label.toUpperCase()}-001',
                        state: states[i],
                        leafSize: 34,
                      ),
                    ),
                  const Gap(10),
                ],
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: SecondaryButton(
                    icon: PackIcons.gift,
                    label: 'Gift',
                    onPressed: () => context.push('/gift-jersey'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Share a jersey',
                    onPressed: () => context.push('/share-select'),
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
