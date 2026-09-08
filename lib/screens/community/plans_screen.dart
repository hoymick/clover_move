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

/// 18 Plans & Pricing — Member, Host and Partner. Host is priced per route
/// rather than monthly, and partner registration is free; both are stated on the
/// card itself so the difference can't be missed.
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _audience = 0;

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
                  selected: _audience,
                  onChanged: (value) {
                    setState(() => _audience = value);
                    if (value == 1) context.push('/plans-business');
                  },
                ),
                const Gap(22),
                _PlanCard(
                  title: 'Clover Move Member',
                  meta: 'For everyone joining activities',
                  price: '€3.60',
                  priceUnit: '/ month',
                  priceColour: CloverColors.green,
                  tint: CloverColors.greenTint,
                  icon: PackIcons.person,
                  highlighted: true,
                  badge: 'MOST POPULAR',
                  features: const [
                    'Unlimited activities',
                    'Official events',
                    'Community routes',
                    'Public profile',
                    'Member discounts',
                    'Digital Member ID',
                  ],
                  onChoose: () => context.push('/registration'),
                ),
                const Gap(16),
                _PlanCard(
                  title: 'Clover Move Host',
                  meta: 'Organise routes and events',
                  price: '€12.20',
                  priceUnit: 'per route or event',
                  priceColour: CloverColors.orange,
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.plus,
                  features: const [
                    'Walking, cycling & fitness routes',
                    'Participant limits, age & gender',
                    'Equipment, rules & statistics',
                  ],
                  singleColumn: true,
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CloverColors.greenTint,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusBadge(
                        label: 'FREE',
                        colour: CloverColors.white,
                        background: CloverColors.green,
                      ),
                      const Gap(20),
                      Text(
                        'Official Partner Registration',
                        style: AppText.subtitle.copyWith(fontSize: 16),
                      ),
                      const Gap(12),
                      Text(
                        'Gyms, hotels, cafés, clubs and studios can list a full '
                        'business profile at no cost.',
                        style: AppText.caption.copyWith(
                          fontSize: 12,
                          color: CloverColors.ink,
                          height: 1.5,
                        ),
                      ),
                    ],
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

/// One plan: icon, name, price, and what it includes. The recommended plan gets
/// a green border and a badge rather than a different shape.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.meta,
    required this.price,
    required this.priceUnit,
    required this.priceColour,
    required this.tint,
    required this.icon,
    required this.features,
    this.highlighted = false,
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
  final bool highlighted;
  final String? badge;
  final VoidCallback? onChoose;

  /// The Host plan lists its features in one column, as the lines are longer.
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlighted ? CloverColors.green : CloverColors.border,
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
                      style: AppText.subtitle.copyWith(fontSize: 17),
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
                    fontSize: highlighted ? 32 : 28,
                    color: priceColour,
                    height: 1.0,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
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
                  height: 44,
                  fontSize: 14.5,
                  onPressed: onChoose,
                ),
            ],
          ),
          const Gap(20),
          for (var i = 0; i < features.length; i += singleColumn ? 1 : 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(child: _Feature(features[i])),
                  if (!singleColumn && i + 1 < features.length)
                    Expanded(child: _Feature(features[i + 1])),
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
            background: CloverColors.green,
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PackIcon(PackIcons.check, size: 14, color: CloverColors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppText.bodyStrong.copyWith(fontSize: 12.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
