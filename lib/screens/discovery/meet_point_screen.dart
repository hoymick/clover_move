import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/map_canvas.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 30 Meet Point — a public point with its safety and access facts stated up
/// front, and what is meeting there this week.
class MeetPointScreen extends StatelessWidget {
  const MeetPointScreen({super.key});

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
                const DetailHero(
                  height: 252,
                  actions: [],
                  child: MapCanvas(markers: [MapMarker(x: 0.5, y: 0.45)]),
                ),
                DetailSheet(
                  children: [
                    const Row(
                      children: [
                        StatusBadge(
                          label: 'OFFICIAL MEET POINT',
                          fontSize: 10.5,
                        ),
                        SizedBox(width: 10),
                        StatusBadge(
                          label: 'PUBLIC',
                          fontSize: 10.5,
                          colour: CloverColors.inkSoft,
                          background: CloverColors.divider,
                        ),
                      ],
                    ),
                    const Gap(22),
                    Text(
                      'Howth DART Station',
                      style: AppText.title.copyWith(fontSize: 22),
                    ),
                    const Gap(8),
                    Text(
                      'Transport hub · Coastal · Co. Dublin',
                      style: AppText.caption.copyWith(fontSize: 13),
                    ),
                    const Gap(20),
                    const SpecGrid(
                      rows: [
                        [
                          Spec(PackIcons.document, 'Eircode', 'D13 A2X6'),
                          Spec(PackIcons.people, 'Capacity', '60 people'),
                        ],
                        [
                          Spec(PackIcons.clock, 'Staffed', '06:00 – 23:30'),
                          Spec(PackIcons.target, 'Access', 'Step-free'),
                        ],
                      ],
                    ),
                    const Gap(22),
                    const Callout(
                      title: 'Safety information',
                      body:
                          'Sheltered platform, lit at night, staffed ticket office. '
                          'Wait inside the concourse in poor weather.',
                      icon: PackIcons.shieldCheck,
                    ),
                    const Gap(26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Meeting here this week',
                            style: AppText.section,
                          ),
                        ),
                        Text('4', style: AppText.link),
                      ],
                    ),
                    const Gap(12),
                    SpineRow(
                      title: 'Howth Cliff Walk',
                      meta: 'Sat 09:00 · Official · 24 going',
                      onTap: () => context.push('/official-event'),
                    ),
                    const Gap(8),
                    SpineRow(
                      title: 'Sunrise Coastal Run',
                      meta: 'Tue 06:45 · User route · 9 going',
                      onTap: () => context.push('/user-route'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                _ShareAction(onTap: () {}),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Get directions',
                    icon: PackIcons.pin,
                    onPressed: () {},
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

/// Icon-only secondary action, as the pack draws beside "Get directions".
class _ShareAction extends StatelessWidget {
  const _ShareAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.divider,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const SizedBox(
          width: 100,
          height: Insets.buttonHeight,
          child: Center(
            child: PackIcon(
              PackIcons.share,
              size: 21,
              color: CloverColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}
