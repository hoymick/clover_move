import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/bar_chart.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';

/// 23 Partner Dashboard — views, enquiries and promotions. Each figure carries
/// its month-on-month change, so a number never stands without context.
class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  static const _metrics = [
    ('PROFILE VIEWS', '2,480', '18% vs Jul', true),
    ('ENQUIRIES', '64', '9% vs Jul', true),
    ('CHECK-INS', '312', '4% vs Jul', false),
  ];

  static const _promotions = [
    ('20% off day passes', 'Ends 31 Aug · 214 redemptions', true),
    ('Free class for new members', 'Ends 14 Sep · 38 redemptions', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.gutter,
                  14,
                  Insets.gutter,
                  16,
                ),
                child: Row(
                  children: [
                    const CloverThumb(
                      category: LeafCategory.orange,
                      width: 48,
                      height: 48,
                      radius: 15,
                      motif: ThumbMotif.none,
                      leafSize: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Talbot Hotel Stillorgan',
                            style: AppText.subtitle.copyWith(fontSize: 16.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 7),
                          const StatusBadge(
                            label: 'BUSINESS+',
                            fontSize: 9.5,
                            colour: CloverColors.white,
                            background: CloverColors.ink,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                18,
                Insets.gutter,
                24,
              ),
              children: [
                CloverCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      for (final (label, value, change, up) in _metrics)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: AppText.caption.copyWith(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  value,
                                  style: AppText.title.copyWith(fontSize: 22),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${up ? '↑' : '↓'} $change',
                                style: AppText.bodyStrong.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(16),
                CloverCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile views',
                        style: AppText.cardTitle.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Last 6 months',
                        style: AppText.caption.copyWith(fontSize: 11),
                      ),
                      const Gap(20),
                      const MonthBarChart(
                        months: ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
                        values: [1180, 1420, 1650, 1880, 2100, 2480],
                        calloutLabel: '2,480',
                      ),
                    ],
                  ),
                ),
                const Gap(22),
                SectionHeader(
                  title: 'Live promotions',
                  action: 'Manage',
                  onAction: () {},
                ),
                const Gap(12),
                for (final (title, meta, live) in _promotions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CloverCard(
                      radius: 16,
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            size: 32,
                            radius: 10,
                            color: CloverColors.orangeTint,
                            child: const PackIcon(
                              PackIcons.tag,
                              size: 17,
                              color: CloverColors.orange,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppText.rowTitle.copyWith(
                                    fontSize: 13.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  meta,
                                  style: AppText.rowMeta.copyWith(
                                    fontSize: 10.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(
                            label: live ? 'Live' : 'Ended',
                            fontSize: 10.5,
                            colour: live
                                ? CloverColors.green
                                : CloverColors.muted,
                            background: live
                                ? CloverColors.greenTint
                                : CloverColors.divider,
                          ),
                        ],
                      ),
                    ),
                  ),
                const Gap(12),
                PrimaryButtonLink(
                  label: 'View public profile',
                  onPressed: () => context.push('/partner-venue'),
                ),
              ],
            ),
          ),
          const CloverNavBar(
            active: NavTab.profile,
            activeColour: CloverColors.orange,
          ),
        ],
      ),
    );
  }
}

/// Full-width ink action used at the foot of the partner dashboard.
class PrimaryButtonLink extends StatelessWidget {
  const PrimaryButtonLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.ink,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: AppText.button.copyWith(fontSize: 15.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
