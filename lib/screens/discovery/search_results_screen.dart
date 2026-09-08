import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/chips.dart';
import '../../widgets/event_cards.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/thumb.dart';

/// 36 Search Results — the list view of the map. The sort row carries a Map
/// pill that takes you straight back to screen 05.
class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  static const _results = [
    (
      'Howth Cliff Walk',
      'Official · Sat 09:00 · 4.2 km',
      '€12.20',
      true,
      ThumbMotif.hills,
      '/official-event',
    ),
    (
      'Sandymount Sunset Run',
      'User route · Tue 19:30 · 1.8 km',
      'Free',
      false,
      ThumbMotif.rings,
      '/user-route',
    ),
    (
      'Phoenix Park 10K',
      'Official · Sun 08:30 · 6.4 km',
      'Free',
      true,
      ThumbMotif.hills,
      '/official-event',
    ),
    (
      'Sunrise Coastal Run',
      'User route · Wed 06:45 · 3.1 km',
      'Free',
      false,
      ThumbMotif.stripes,
      '/user-route',
    ),
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
                title: '128 results',
                subtitle: 'Dublin · ${category.label} · within 15 km',
                action: HeaderIconAction(
                  icon: PackIcons.sliders,
                  bare: true,
                  onTap: () => context.push('/filters'),
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
                CloverField(
                  height: 40,
                  radius: 12,
                  padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                  onTap: () => context.push('/filters'),
                  child: Row(
                    children: [
                      const PackIcon(
                        PackIcons.sort,
                        size: 18,
                        color: CloverColors.inkSoft,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sorted by: soonest first',
                          style: AppText.pill.copyWith(fontSize: 12.5),
                        ),
                      ),
                      PillButton(
                        label: 'Map',
                        colour: CloverColors.ink,
                        fontSize: 11.5,
                        onPressed: () => context.push('/map'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                for (final (title, meta, price, official, motif, route)
                    in _results)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: ResultCard(
                      title: title,
                      meta: meta,
                      price: price,
                      official: official,
                      motif: motif,
                      // The pack tints every result in the member's colour,
                      // official or not.
                      category: category,
                      onTap: () => context.push(route),
                      onJoin: () => context.push('/registration'),
                    ),
                  ),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.map),
        ],
      ),
    );
  }
}
