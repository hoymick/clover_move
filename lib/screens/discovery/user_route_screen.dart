import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 08 User Route — a member-created route at a partner venue. This one is an
/// Orange route, so the screen takes the orange accent throughout: the venue
/// leaf, the fact icons, the equipment marks and the action.
///
/// The audience chips state plainly who the route welcomes before anyone asks
/// to join.
class UserRouteScreen extends StatelessWidget {
  const UserRouteScreen({super.key});

  static const _category = LeafCategory.orange;

  static const _audience = [
    'Only Women',
    'Age 25–40',
    'Max 8',
    'Groups',
    'Friends',
    'Mixed level',
  ];

  static const _equipment = [
    ('Gym bag', PackIcons.bag),
    ('Training shoes', PackIcons.walk),
    ('Water bottle', PackIcons.ticketTag),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.surfaceMuted,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Morning Route',
                action: HeaderIconAction(
                  icon: PackIcons.share,
                  bare: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                12,
                Insets.gutter,
                24,
              ),
              children: [
                // Aligned: a ListView child is given a tight width, which
                // would otherwise stretch the pill across the screen.
                const Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(
                    label: 'USER ROUTE · APPROVED',
                    fontSize: 10.5,
                    colour: CloverColors.orangeDark,
                    background: CloverColors.orangeTint,
                  ),
                ),
                const Gap(18),
                SpecGrid(
                  bordered: true,
                  iconColour: CloverColors.orange,
                  header: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _category.tint,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const CategoryLeaf(
                          category: _category,
                          size: 44,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Talbot Hotel Stillorgan',
                              style: AppText.subtitle.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Gym · Private venue · Partner',
                              style: AppText.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  rows: const [
                    [
                      Spec(PackIcons.clock, 'Time', '07:00 – 09:00'),
                      Spec(PackIcons.calendar, 'Repeats', 'Mon Wed Fri'),
                    ],
                  ],
                ),
                const Gap(26),
                Text(
                  'Who this route is for',
                  style: AppText.section.copyWith(fontSize: 15.5),
                ),
                const Gap(14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final label in _audience)
                      CloverChip(label: label, height: 40, fontSize: 12.5),
                  ],
                ),
                const Gap(26),
                Text(
                  'Required equipment',
                  style: AppText.section.copyWith(fontSize: 15.5),
                ),
                const Gap(12),
                for (final (item, icon) in _equipment)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _EquipmentRow(label: item, icon: icon),
                  ),
                const Gap(16),
                Text('Host', style: AppText.section.copyWith(fontSize: 15.5)),
                const Gap(12),
                const HostRow(
                  name: 'Niamh L.',
                  meta: '4.9 · Verified host · 38 routes',
                  initials: 'NL',
                  colour: CloverColors.orange,
                  boxed: true,
                  showStar: true,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Request to Join · 3 spots left',
              color: CloverColors.orange,
              onPressed: () => context.push('/registration'),
            ),
          ),
        ],
      ),
    );
  }
}

/// One kit item: an orange mark and the item's name, on a bordered row.
class _EquipmentRow extends StatelessWidget {
  const _EquipmentRow({required this.label, required this.icon});

  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CloverColors.border),
      ),
      child: Row(
        children: [
          PackIcon(icon, size: 20, color: CloverColors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppText.cardTitle.copyWith(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
