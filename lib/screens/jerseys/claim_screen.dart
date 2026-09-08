import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/jersey_row.dart';
import '../../widgets/scaffolds.dart';

/// 11d Claim — the recipient already has an account. The code is reported as
/// checked before the action, so claiming isn't a leap of faith.
class ClaimScreen extends StatelessWidget {
  const ClaimScreen({super.key});

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
              child: BackHeader(title: 'Claim a jersey'),
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
                const Center(
                  child: CategoryLeaf(category: LeafCategory.white, size: 96),
                ),
                const Gap(34),
                Center(
                  child: Text(
                    'A jersey for you',
                    style: AppText.title.copyWith(fontSize: 25),
                  ),
                ),
                const Gap(18),
                Text(
                  'Andrea shared a White Jersey from her Clover Move kit. Claim '
                  "it and it's yours.",
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                  textAlign: TextAlign.center,
                ),
                const Gap(28),
                const JerseyRow(
                  category: LeafCategory.white,
                  meta: 'Long sleeve · SJ-WHITE-001',
                  state: JerseyState.available,
                ),
                const Gap(12),
                const HostRow(
                  name: 'From Andrea Ní Bhriain',
                  meta: 'Kit 01 · verified owner',
                  initials: 'AN',
                  boxed: true,
                ),
                const Gap(20),
                const Callout(
                  title: 'Code checked and valid',
                  body: 'It becomes unusable as soon as you claim.',
                  icon: PackIcons.shieldCheck,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Claim Smart Jersey',
              onPressed: () => context.push('/smart-jerseys'),
            ),
          ),
        ],
      ),
    );
  }
}
