import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/qr.dart';
import '../../widgets/scaffolds.dart';

/// 11c Share — QR. A one-time code for one jersey. The warning that it dies on
/// first claim sits directly under the code, not in small print.
class ShareQrScreen extends StatelessWidget {
  const ShareQrScreen({super.key});

  static const _channels = [
    ('WhatsApp', PackIcons.whatsapp),
    ('SMS', PackIcons.message),
    ('Email', PackIcons.mail),
    ('Copy link', PackIcons.share),
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
              child: BackHeader(
                title: 'Share a jersey',
                subtitle: 'Step 2 of 2',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                22,
                Insets.gutter,
                24,
              ),
              children: [
                const Center(
                  child: CategoryLeaf(category: LeafCategory.white, size: 78),
                ),
                const Gap(20),
                Center(
                  child: Text(
                    'White Jersey',
                    style: AppText.title.copyWith(fontSize: 19),
                  ),
                ),
                const Gap(8),
                Center(
                  child: Text(
                    'Long sleeve · SJ-WHITE-001',
                    style: AppText.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CloverColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: CloverColors.border),
                    ),
                    child: const QrBlock(size: 168, modules: 23, seed: 44119),
                  ),
                ),
                const Gap(18),
                const Center(
                  child: StatusBadge(
                    label: 'ONE-TIME CODE',
                    fontSize: 10.5,
                    colour: CloverColors.orangeDark,
                    background: CloverColors.orangeTint,
                  ),
                ),
                const Gap(20),
                const Callout(
                  title: 'Valid once',
                  body:
                      'It stops working the moment someone claims the jersey.',
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.lock,
                  iconColour: CloverColors.orangeDark,
                ),
                const Gap(26),
                Text('Send it', style: AppText.section),
                const Gap(12),
                for (var i = 0; i < _channels.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ChannelTile(
                            label: _channels[i].$1,
                            icon: _channels[i].$2,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ChannelTile(
                            label: _channels[i + 1].$1,
                            icon: _channels[i + 1].$2,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Gap(14),
                Center(
                  child: Text(
                    'Or show this screen to them in person',
                    style: AppText.footnote.copyWith(fontSize: 11.5),
                  ),
                ),
                const Gap(10),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/claim'),
                    child: Text(
                      'Preview what they see',
                      style: AppText.link.copyWith(fontSize: 12.5),
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

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({required this.label, required this.icon});

  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 16,
      onTap: () {},
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        children: [
          IconTile(
            size: 30,
            radius: 10,
            color: CloverColors.greenTint,
            child: PackIcon(icon, size: 16, color: CloverColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppText.rowTitle.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
