import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/jersey_row.dart';
import '../../widgets/scaffolds.dart';

/// 11b Share — Select. A colour must be chosen before any code exists, so the
/// action stays disabled until one is picked and the copy explains why.
class ShareSelectScreen extends StatefulWidget {
  const ShareSelectScreen({super.key});

  @override
  State<ShareSelectScreen> createState() => _ShareSelectScreenState();
}

class _ShareSelectScreenState extends State<ShareSelectScreen> {
  LeafCategory? _chosen;

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
                subtitle: 'Step 1 of 2',
              ),
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
                Text(
                  'Choose which jersey to share. A QR code is only created once '
                  "you've picked a colour.",
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                ),
                const Gap(24),
                const FieldLabel('From'),
                CloverCard(
                  radius: 16,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Kit 01',
                          style: AppText.cardTitle.copyWith(fontSize: 14.5),
                        ),
                      ),
                      Text(
                        '2 available',
                        style: AppText.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(22),
                const FieldLabel('Select jersey'),
                for (final category in LeafCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: JerseyRow(
                      category: category,
                      meta:
                          'Long sleeve · SJ-${category.label.toUpperCase()}-001',
                      selected: category == _chosen,
                      onTap: () => setState(() => _chosen = category),
                    ),
                  ),
                const Gap(14),
                const Callout(
                  title: 'One jersey only',
                  body:
                      'The code you generate authorises this one jersey only. '
                      'It is not your permanent token.',
                  tint: CloverColors.divider,
                  icon: PackIcons.info,
                  iconColour: CloverColors.inkSoft,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: _chosen == null
                  ? 'Choose a colour first'
                  : 'Create code for ${_chosen!.label}',
              onPressed: _chosen == null
                  ? null
                  : () => context.push('/share-qr'),
            ),
          ),
        ],
      ),
    );
  }
}
