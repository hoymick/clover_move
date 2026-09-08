import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/chips.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/rating.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';

/// 15 Community — members in your colour. The visibility switch sits above the
/// list, so it is clear that being listed is a choice before anyone is shown.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _public = true;

  static const _members = [
    ('Aoife K.', 'AK', '29 · Dún Laoghaire', 'Running · Marathons', '2.1 km'),
    ('Marcus O.', 'MO', '34 · Blackrock', 'Hiking · Trail', '3.4 km'),
    ('Síle N.', 'SN', '27 · Stillorgan', 'Walking · Running', '0.8 km'),
  ];

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Community',
                action: HeaderIconAction(
                  icon: PackIcons.sliders,
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
                16,
                Insets.gutter,
                24,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: CloverColors.greenTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CategoryLeaf(category: category, size: 46),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You're in ${category.label}",
                              style: AppText.subtitle.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category.activities.replaceAll('\n', ' · '),
                              style: AppText.caption.copyWith(
                                fontSize: 11.5,
                                color: CloverColors.ink,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                SwitchRow(
                  title: 'Appear publicly',
                  meta: 'Others in ${category.label} can discover you',
                  value: _public,
                  onChanged: (value) => setState(() => _public = value),
                ),
                const Gap(26),
                Row(
                  children: [
                    Expanded(
                      child: Text('Nearby members', style: AppText.section),
                    ),
                    Text('42', style: AppText.link),
                  ],
                ),
                const Gap(12),
                for (final (name, initials, meta, activities, distance)
                    in _members)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MemberCard(
                      name: name,
                      initials: initials,
                      meta: meta,
                      activities: activities,
                      distance: distance,
                      onInvite: () => context.push('/invite'),
                    ),
                  ),
                const Gap(14),
                Text('Same venue as you', style: AppText.section),
                const Gap(12),
                const _VenueCard(),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.profile),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.initials,
    required this.meta,
    required this.activities,
    required this.distance,
    required this.onInvite,
  });

  final String name;
  final String initials;
  final String meta;
  final String activities;
  final String distance;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Avatar(initials: initials, size: 52, ring: true),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppText.cardTitle.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      distance,
                      style: AppText.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  meta,
                  style: AppText.caption.copyWith(fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activities,
                        style: AppText.link.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PillButton(
                      label: 'Invite',
                      height: 30,
                      onPressed: onInvite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard();

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      onTap: () {},
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: AppText.cardTitle.copyWith(fontSize: 14.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '11 members train here',
                  style: AppText.caption.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 12),
                const AvatarStack(
                  initials: ['PR', 'LK', 'DM'],
                  size: 26,
                  colour: CloverColors.orangeTint,
                  textColour: CloverColors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
