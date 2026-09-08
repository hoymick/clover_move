import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/segmented_tabs.dart';

/// 27 Plans — Business. Partner listing is free; Business+ and Sponsor are the
/// paid tiers. The free tier states what it excludes, so the upgrade is honest.
class PlansBusinessScreen extends StatelessWidget {
  const PlansBusinessScreen({super.key});

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
              child: BackHeader(title: 'Plans & Pricing'),
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
                SegmentedTabs(
                  labels: const ['Personal', 'Business'],
                  selected: 1,
                  onChanged: (value) {
                    if (value == 0) context.pop();
                  },
                ),
                const Gap(22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CloverColors.greenTint,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const StatusBadge(
                            label: 'FREE',
                            colour: CloverColors.white,
                            background: CloverColors.green,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Official Partner',
                              style: AppText.subtitle.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Gap(18),
                      const _Line('Full profile, photos, video and map pin'),
                      const Gap(8),
                      const _Line(
                        'No advertising or promotion included',
                        included: false,
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                _TierCard(
                  title: 'Clover Move Business+',
                  meta: 'Promote products and services',
                  price: '€17.60',
                  priceUnit: '/ month',
                  priceColour: CloverColors.orange,
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.tag,
                  badge: 'MOST CHOSEN',
                  features: const [
                    'Featured listing',
                    'Push alerts',
                    'Promo banners',
                    'Unlimited offers',
                    'Sponsored events',
                    'Monthly analytics',
                  ],
                  onChoose: () => context.push('/business-signup'),
                ),
                const Gap(16),
                _TierCard(
                  title: 'Official Sponsor Brands',
                  meta: 'National & international brands',
                  price: '€17.60',
                  priceUnit: '/ month · catalogue & analytics',
                  priceColour: CloverColors.green,
                  tint: CloverColors.greenTint,
                  icon: PackIcons.star,
                  features: const [
                    'Brand profile and catalogue',
                    'Member discounts',
                    'Nationwide reach',
                  ],
                  singleColumn: true,
                  onChoose: () => context.push('/sponsor-brand'),
                ),
                const Gap(16),
                _TierCard(
                  title: 'Meet Point+',
                  meta: 'For locations wanting more visitors',
                  price: '€17.60',
                  priceUnit: '/ month · priority search',
                  priceColour: CloverColors.green,
                  tint: CloverColors.greenTint,
                  icon: PackIcons.pin,
                  features: const [
                    'Priority in search and on the map',
                    'Highlighted Meet Point card',
                  ],
                  singleColumn: true,
                  onChoose: () => context.push('/meet-point-signup'),
                ),
                const Gap(22),
                Center(
                  child: Text(
                    'Meet Point registration itself is always free',
                    style: AppText.footnote.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
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

class _Line extends StatelessWidget {
  const _Line(this.label, {this.included = true});

  final String label;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PackIcon(
          included ? PackIcons.check : PackIcons.close,
          size: 14,
          color: included ? CloverColors.green : CloverColors.muted,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppText.caption.copyWith(
              fontSize: 12,
              color: included ? CloverColors.ink : CloverColors.inkSoft,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// A paid business tier. Same shape as the personal plan card, so the two
/// pricing screens read as one system.
class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.title,
    required this.meta,
    required this.price,
    required this.priceUnit,
    required this.priceColour,
    required this.tint,
    required this.icon,
    required this.features,
    this.badge,
    this.onChoose,
    this.singleColumn = false,
  });

  final String title;
  final String meta;
  final String price;
  final String priceUnit;
  final Color priceColour;
  final Color tint;
  final String icon;
  final List<String> features;
  final String? badge;
  final VoidCallback? onChoose;
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: badge != null ? CloverColors.orange : CloverColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                size: 44,
                radius: 13,
                color: tint,
                child: PackIcon(icon, size: 22, color: priceColour),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.subtitle.copyWith(fontSize: 16.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      meta,
                      style: AppText.caption.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  price,
                  style: AppText.title.copyWith(
                    fontSize: 28,
                    color: priceColour,
                    height: 1.0,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    priceUnit,
                    style: AppText.caption.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (onChoose case final onChoose?)
                PillButton(
                  label: 'Choose',
                  height: 40,
                  fontSize: 14,
                  colour: priceColour,
                  onPressed: onChoose,
                ),
            ],
          ),
          const Gap(20),
          for (var i = 0; i < features.length; i += singleColumn ? 1 : 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Expanded(child: _Line(features[i])),
                  if (!singleColumn && i + 1 < features.length)
                    Expanded(child: _Line(features[i + 1])),
                ],
              ),
            ),
        ],
      ),
    );

    if (badge == null) return card;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(padding: const EdgeInsets.only(top: 12), child: card),
        Positioned(
          right: 20,
          top: 0,
          child: StatusBadge(
            label: badge!,
            fontSize: 9.5,
            colour: CloverColors.white,
            background: CloverColors.orange,
          ),
        ),
      ],
    );
  }
}
