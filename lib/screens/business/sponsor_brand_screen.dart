import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';

/// 26 Sponsor Brand — an official sponsor's profile. The member discount is the
/// reason a member is here, so it sits above the product grid.
class SponsorBrandScreen extends StatelessWidget {
  const SponsorBrandScreen({super.key});

  static const _products = [('Trail shoe', '€139'), ('Shell jacket', '€189')];

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DetailHero(height: 252, category: category),
                DetailSheet(
                  children: [
                    const StatusBadge(
                      label: 'OFFICIAL SPONSOR',
                      fontSize: 10.5,
                    ),
                    const Gap(22),
                    Text(
                      'Salomon Ireland',
                      style: AppText.title.copyWith(fontSize: 23),
                    ),
                    const Gap(8),
                    Text(
                      'Trail running · Outdoor · Nutrition',
                      style: AppText.caption.copyWith(fontSize: 13),
                    ),
                    const Gap(20),
                    const SpecGrid(
                      rows: [
                        [
                          Spec(PackIcons.bag, 'Products', '48 in catalogue'),
                          Spec(PackIcons.people, 'Followers', '3,140'),
                        ],
                      ],
                    ),
                    const Gap(22),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CloverColors.greenTint,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StatusBadge(
                            label: 'MEMBER DISCOUNT',
                            fontSize: 9.5,
                            colour: CloverColors.white,
                            background: CloverColors.green,
                          ),
                          const Gap(16),
                          Text(
                            '15% off for Clover Move members',
                            style: AppText.cardTitle.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Gap(26),
                    SectionHeader(
                      title: 'Recommended for ${category.label}',
                      action: 'See all',
                      onAction: () => context.push('/store-catalogue'),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        for (var i = 0; i < _products.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          Expanded(
                            child: _ProductTile(
                              name: _products[i].$1,
                              price: _products[i].$2,
                              category: category,
                              onTap: () => context.push('/store-catalogue'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: SecondaryButton(label: 'Follow', onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Shop catalogue',
                    onPressed: () => context.push('/store-catalogue'),
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

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.name,
    required this.price,
    required this.category,
    required this.onTap,
  });

  final String name;
  final String price;
  final LeafCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CloverThumb(
            category: category,
            height: 104,
            radius: 14,
            leafSize: 34,
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: AppText.rowTitle.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(price, style: AppText.price.copyWith(fontSize: 12.5)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
