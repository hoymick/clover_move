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
import '../../widgets/event_cards.dart';
import '../../widgets/map_canvas.dart';
import '../../widgets/nav_shell.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 05 Interactive Map — leaf markers as location pins, colour and kind filters
/// floating over the ground, and a nearby sheet pulled up from the bottom.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _kinds = ['Events', 'Routes', 'Meet Points', 'Venues'];
  int _kind = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final category = state.activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: MapCanvas(
                    // Pins start below the filter chips, which float over the
                    // top of the map.
                    markers: [
                      MapMarker(x: 0.25, y: 0.47, category: category),
                      const MapMarker(
                        x: 0.62,
                        y: 0.42,
                        category: LeafCategory.orange,
                      ),
                      const MapMarker(
                        x: 0.43,
                        y: 0.61,
                        category: LeafCategory.white,
                      ),
                      MapMarker(x: 0.80, y: 0.59, category: category),
                      const MapMarker(
                        x: 0.19,
                        y: 0.73,
                        category: LeafCategory.orange,
                      ),
                      const MapMarker(x: 0.51, y: 0.86, isUser: true),
                    ],
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: _SearchThisArea(),
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            for (final leaf in LeafCategory.values) ...[
                              if (leaf != LeafCategory.values.first)
                                const SizedBox(width: 8),
                              CloverChip(
                                label: leaf.label,
                                selected: leaf == category,
                                height: 44,
                                fontSize: 13,
                                selectedColour: leaf.colour,
                                horizontalPadding: 12,
                                // Each colour filter carries its own leaf.
                                leading: CategoryLeaf(
                                  category: leaf,
                                  size: 28,
                                  onColour:
                                      leaf == category &&
                                          leaf != LeafCategory.white
                                      ? CloverColors.white
                                      : null,
                                ),
                                onTap: () =>
                                    context.read<AppState>().setCategory(leaf),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ChipRow(
                        labels: _kinds,
                        selectedIndex: _kind,
                        height: 38,
                        fontSize: 12.5,
                        // The pack selects the kind filter in ink, not green —
                        // it sits above the colour filter in the hierarchy.
                        selectedColour: CloverColors.ink,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onChanged: (value) => setState(() => _kind = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _NearbySheet(category: category),
          const CloverNavBar(active: NavTab.map),
        ],
      ),
    );
  }
}

class _SearchThisArea extends StatelessWidget {
  const _SearchThisArea();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: CloverColors.ink.withValues(alpha: 0.15),
      child: InkWell(
        onTap: () => context.push('/filters'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              const PackIcon(
                PackIcons.search,
                size: 20,
                color: CloverColors.hint,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search this area',
                  style: AppText.bodyStrong.copyWith(fontSize: 14),
                ),
              ),
              // The pack's sliders control, not a sort funnel.
              const PackIcon(
                PackIcons.sliders,
                size: 21,
                color: CloverColors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearbySheet extends StatelessWidget {
  const _NearbySheet({required this.category});

  final LeafCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(Insets.gutter, 12, Insets.gutter, 12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CloverColors.borderStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(
            title: '3 activities nearby',
            action: 'List view',
            onAction: () => context.push('/search-results'),
          ),
          const SizedBox(height: 10),
          NearbyRow(
            title: 'Howth Cliff Walk',
            meta: 'Official · Sat 09:00 · 4.2 km away',
            category: category,
            onTap: () => context.push('/official-event'),
          ),
          NearbyRow(
            title: 'Talbot Hotel Gym',
            meta: 'Partner venue · Open until 22:00',
            category: LeafCategory.orange,
            onTap: () => context.push('/partner-venue'),
          ),
        ],
      ),
    );
  }
}
