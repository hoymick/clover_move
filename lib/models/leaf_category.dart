import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// The three leaves every activity, route, venue and brand lives under.
/// Order is Green, White, Orange throughout the product — never re-sorted.
enum LeafCategory {
  green(
    label: 'Green',
    activityCount: 12,
    activities: 'Walking · Running · Trail\nHiking · Marathons',
    colour: CloverColors.green,
    pictogram: 'walk',
  ),
  white(
    label: 'White',
    activityCount: 8,
    activities: 'Cycling · Road · Mountain\nLeisure · Family',
    colour: CloverColors.borderStrong,
    pictogram: 'cycle',
  ),
  orange(
    label: 'Orange',
    activityCount: 15,
    activities: 'Gym · Fitness · Yoga\nPilates · Dance · Wellness',
    colour: CloverColors.orange,
    pictogram: 'lift',
  );

  const LeafCategory({
    required this.label,
    required this.activityCount,
    required this.activities,
    required this.colour,
    required this.pictogram,
  });

  final String label;
  final int activityCount;
  final String activities;

  /// Which activity pictogram the leaf carries — the asset name suffix.
  final String pictogram;

  /// The swatch colour. White's swatch is a tint so it stays visible on white.
  final Color colour;

  /// Colour for a leaf pictogram drawn on a light surface.
  Color get leafColour => switch (this) {
    LeafCategory.green => CloverColors.green,
    LeafCategory.white => CloverColors.inkSoft,
    LeafCategory.orange => CloverColors.orange,
  };

  /// Colour the leaf mark itself is drawn in. White's leaf is outlined in
  /// green rather than filled, so it shares Green's ink.
  Color get markColour => switch (this) {
    LeafCategory.green => CloverColors.green,
    LeafCategory.white => CloverColors.green,
    LeafCategory.orange => CloverColors.orange,
  };

  /// Background for a selected pill or filled surface in this category.
  Color get fill => switch (this) {
    LeafCategory.green => CloverColors.green,
    LeafCategory.white => CloverColors.white,
    LeafCategory.orange => CloverColors.orange,
  };

  /// Soft tint used behind icons and callouts.
  Color get tint => switch (this) {
    LeafCategory.green => CloverColors.greenTint,
    LeafCategory.white => CloverColors.surfaceMuted,
    LeafCategory.orange => CloverColors.orangeTint,
  };

  String get activityCountLabel => '$activityCount activity types';
}
