import 'package:flutter/material.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/leaf.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/qr.dart';
import '../../widgets/scaffolds.dart';

/// 32 Invite Friends — QR, link, WhatsApp and SMS. The invite card is drawn on
/// ink so it reads as something to hold up and be scanned.
class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  static const _channels = [
    ('WhatsApp', PackIcons.whatsapp, 'Most used'),
    ('SMS', PackIcons.message, null),
    ('Email', PackIcons.mail, null),
    ('Copy secure link', PackIcons.share, null),
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
              child: BackHeader(title: 'Invite friends'),
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
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: CloverColors.ink,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CloverColors.white,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const CloverLogo(size: 42),
                      ),
                      const Gap(20),
                      Text(
                        'Share Your Route',
                        style: AppText.cardTitle.copyWith(
                          fontSize: 15,
                          color: CloverColors.white,
                        ),
                      ),
                      const Gap(18),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CloverColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const QrBlock(
                          size: 108,
                          modules: 21,
                          seed: 20261,
                        ),
                      ),
                      const Gap(20),
                      Text(
                        'ANDREA-2026',
                        style: AppText.badge.copyWith(
                          fontSize: 15,
                          color: CloverColors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(28),
                Text('Send an invite', style: AppText.section),
                const Gap(12),
                for (final (label, icon, tag) in _channels)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CloverCard(
                      radius: 16,
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            size: 32,
                            radius: 10,
                            color: CloverColors.greenTint,
                            child: PackIcon(
                              icon,
                              size: 17,
                              color: CloverColors.green,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              label,
                              style: AppText.rowTitle.copyWith(fontSize: 13.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tag != null)
                            Text(
                              tag,
                              style: AppText.badge.copyWith(
                                fontSize: 10.5,
                                color: CloverColors.muted,
                              ),
                            )
                          else
                            const PackIcon(
                              PackIcons.chevronRight,
                              size: 18,
                              color: CloverColors.hint,
                            ),
                        ],
                      ),
                    ),
                  ),
                const Gap(16),
                const Callout(
                  title: '8 friends have joined',
                  body: 'They can browse without an account too.',
                  icon: PackIcons.people,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
