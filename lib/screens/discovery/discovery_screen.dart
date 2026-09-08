import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../widgets/cards.dart';
import '../../widgets/category_switch.dart';
import '../../widgets/event_cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/search_field.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 04 Smart Discovery — the leaves are the category switch. Everything below
/// re-reads in the chosen colour: the search hint, the events, the picks.
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final category = state.activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: LocationHeader(
                location: 'Dublin, Leinster',
                initials: 'AN',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Insets.gutter,
                    14,
                    Insets.gutter,
                    0,
                  ),
                  child: CategorySwitch(
                    selected: category,
                    onChanged: context.read<AppState>().setCategory,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Insets.gutter,
                    16,
                    Insets.gutter,
                    0,
                  ),
                  child: CloverSearchField(
                    hint: 'Search ${category.label} routes, events and venues',
                    readOnly: true,
                    onTap: () => context.push('/filters'),
                  ),
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: SectionHeader(
                    title: 'Official Events',
                    action: 'See all',
                    onAction: () => context.push('/search-results'),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: EventTile(
                          title: 'Howth Cliff Walk',
                          when: 'Sat 15 Aug · 09:00',
                          price: '€10.00',
                          category: category,
                          motif: ThumbMotif.hills,
                          onTap: () => context.push('/official-event'),
                          onJoin: () => context.push('/registration'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: EventTile(
                          title: 'Phoenix Park 10K',
                          when: 'Sun 16 Aug · 08:30',
                          price: 'Free',
                          category: category,
                          motif: ThumbMotif.rings,
                          onTap: () => context.push('/official-event'),
                          onJoin: () => context.push('/registration'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: SectionHeader(
                    title: 'Recommended for ${category.label}',
                    action: 'In order',
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: Column(
                    children: [
                      for (final pick in _picks(category))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: CompactRow(
                            title: pick.title,
                            meta: pick.meta,
                            iconColor: pick.tint,
                            icon: PackIcon(
                              pick.icon,
                              size: 15,
                              color: pick.colour,
                            ),
                            onTap: () => context.push(pick.route),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.home),
        ],
      ),
    );
  }

  static List<_Pick> _picks(LeafCategory category) => [
    _Pick(
      'Sandymount Sunset Run',
      'User route · Tue 19:30 · 14 going',
      icon: PackIcons.route,
      route: '/user-route',
    ),
    _Pick(
      'Howth DART Station',
      'Official Meet Point · 4 activities',
      icon: PackIcons.pin,
      route: '/meet-point',
    ),
    _Pick(
      'Talbot Hotel Stillorgan',
      'Partner venue · Business+',
      icon: PackIcons.dumbbell,
      colour: CloverColors.orange,
      route: '/partner-venue',
    ),
    _Pick(
      'Salomon Ireland',
      'Official sponsor · trail & outdoor',
      icon: PackIcons.star,
      route: '/sponsor-brand',
    ),
    _Pick(
      '15% off for members',
      'Salomon · this month',
      icon: PackIcons.tag,
      colour: CloverColors.orange,
      tint: CloverColors.orangeTint,
      route: '/sponsor-brand',
    ),
  ];
}

class _Pick {
  const _Pick(
    this.title,
    this.meta, {
    required this.route,
    required this.icon,
    this.colour = CloverColors.green,
    this.tint = CloverColors.greenTint,
  });

  final String title;
  final String meta;
  final String route;

  final String icon;
  final Color colour;
  final Color tint;
}
