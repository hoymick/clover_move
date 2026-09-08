import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 07 Official Event — leaf badge and join. Price sits beside the action so the
/// cost is never a surprise at the point of tapping.
class OfficialEventScreen extends StatelessWidget {
  const OfficialEventScreen({super.key});

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
                DetailHero(height: 272, category: category, leafTile: true),
                DetailSheet(
                  children: [
                    const StatusBadge(label: 'OFFICIAL EVENT', fontSize: 10.5),
                    const Gap(20),
                    Text(
                      'Howth Cliff Walk',
                      style: AppText.title.copyWith(fontSize: 24),
                    ),
                    const Gap(8),
                    Text(
                      'Guided coastal loop · 8.5 km · Moderate',
                      style: AppText.caption.copyWith(fontSize: 12.5),
                    ),
                    const Gap(16),
                    Text(
                      'A marshalled loop of the cliff path with sea views the '
                      'whole way. Steady pace, regular regrouping.',
                      style: AppText.bodyStrong.copyWith(
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),
                    const Gap(24),
                    const SpecGrid(
                      rows: [
                        [
                          Spec(PackIcons.calendar, 'Date', 'Sat 15 Aug 2026'),
                          Spec(PackIcons.clock, 'Time', '09:00 – 12:00'),
                        ],
                        [
                          Spec(PackIcons.pin, 'Meet point', 'Howth DART Stn'),
                          Spec(PackIcons.document, 'Eircode', 'D13 A2X6'),
                        ],
                      ],
                    ),
                    const Gap(22),
                    HostRow(
                      name: 'Clover Move Ireland',
                      meta: 'Official host · 214 events',
                      initials: 'CM',
                      action: PillButton(
                        label: 'Follow',
                        colour: CloverColors.greenTint,
                        textColour: CloverColors.green,
                        fontSize: 11.5,
                        onPressed: () {},
                      ),
                    ),
                    const Gap(26),
                    Text(
                      'Required equipment',
                      style: AppText.section.copyWith(fontSize: 15),
                    ),
                    const Gap(14),
                    const TickGrid(
                      items: [
                        'Hiking shoes',
                        'Water bottle',
                        'Rain jacket',
                        'Green Smart Jersey',
                      ],
                    ),
                    const Gap(4),
                    CloverField(
                      height: 46,
                      radius: 12,
                      onTap: () {},
                      child: Row(
                        children: [
                          const PackIcon(
                            PackIcons.document,
                            size: 18,
                            color: CloverColors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Event rules & safety',
                              style: AppText.rowTitle.copyWith(fontSize: 12.5),
                            ),
                          ),
                          Text(
                            '4',
                            style: AppText.caption.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const PackIcon(
                            PackIcons.chevronRight,
                            size: 18,
                            color: CloverColors.hint,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '€10.00',
                        style: AppText.title.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'per person',
                        style: AppText.caption.copyWith(fontSize: 11.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 210,
                  child: PrimaryButton(
                    label: 'Join Event',
                    onPressed: () => context.push('/registration'),
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
