import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/rating.dart';
import '../../widgets/scaffolds.dart';

/// 19 Partner Venue — a Business+ profile. The member offer is called out in
/// orange between the facts and the services, where it can't be scrolled past.
class PartnerVenueScreen extends StatelessWidget {
  const PartnerVenueScreen({super.key});

  static const _services = ['Gym', 'Yoga', 'Pilates', 'Sauna'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DetailHero(height: 272, category: LeafCategory.orange),
                DetailSheet(
                  children: [
                    const Row(
                      children: [
                        StatusBadge(
                          label: 'OFFICIAL PARTNER',
                          fontSize: 10.5,
                          colour: CloverColors.orangeDark,
                          background: CloverColors.orangeTint,
                        ),
                        SizedBox(width: 10),
                        StatusBadge(
                          label: 'BUSINESS+',
                          fontSize: 10.5,
                          colour: CloverColors.white,
                          background: CloverColors.ink,
                        ),
                      ],
                    ),
                    const Gap(22),
                    Text(
                      'Talbot Hotel Stillorgan',
                      style: AppText.title.copyWith(fontSize: 22),
                    ),
                    const Gap(8),
                    Text(
                      'Gym · Hotel · Meet Point · Orange',
                      style: AppText.caption.copyWith(fontSize: 13),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        const StarRating(value: 5, size: 16, spacing: 3),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '4.8  ·  312 reviews',
                            style: AppText.bodyStrong.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    const SpecGrid(
                      rows: [
                        [
                          Spec(PackIcons.pin, 'Address', 'Stillorgan, Dublin'),
                          Spec(PackIcons.document, 'Eircode', 'A94 T2X7'),
                        ],
                        [
                          Spec(PackIcons.clock, 'Open', '06:00 – 22:00'),
                          Spec(PackIcons.people, 'Capacity', '120 people'),
                        ],
                      ],
                    ),
                    const Gap(22),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CloverColors.orangeTint,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StatusBadge(
                            label: 'MEMBER OFFER',
                            fontSize: 9.5,
                            colour: CloverColors.white,
                            background: CloverColors.orange,
                          ),
                          const Gap(16),
                          Text(
                            '20% off day passes for members',
                            style: AppText.cardTitle.copyWith(
                              fontSize: 13,
                              color: CloverColors.orangeDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(26),
                    Text(
                      'Services',
                      style: AppText.section.copyWith(fontSize: 15.5),
                    ),
                    const Gap(14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final service in _services)
                          CloverChip(label: service, height: 32, fontSize: 12),
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
                  child: SecondaryButton(
                    icon: PackIcons.share,
                    label: 'Enquire',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Set as Meet Point',
                    color: CloverColors.orange,
                    onPressed: () => context.push('/meet-point'),
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
