import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'category_leaf.dart';
import 'thumb.dart';
import '../theme/pack_icons.dart';
import 'pack_icon.dart';

/// Full-bleed hero at the top of a detail screen, with circular back and share
/// actions floating over it. The body sheet is expected to overlap its base.
class DetailHero extends StatelessWidget {
  const DetailHero({
    super.key,
    required this.height,
    this.category = LeafCategory.green,
    this.actions = const [PackIcons.heart],
    this.child,
    this.motif = ThumbMotif.hills,
    this.leafTile = false,
  });

  final double height;
  final LeafCategory category;
  final List<String> actions;

  /// Supply a custom ground, e.g. the map canvas on a Meet Point.
  final Widget? child;
  final ThumbMotif motif;

  /// Draws the category's leaf on a white tile at the hero's lower-left, where
  /// the pack overlaps it with the sheet below.
  final bool leafTile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (child case final child?)
            child
          else
            CloverThumb(category: category, radius: 0, motif: motif),
          if (leafTile)
            Positioned(
              left: Insets.gutter,
              bottom: 12,
              child: Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CloverColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CategoryLeaf(category: category, size: 46),
              ),
            ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Insets.gutter,
                vertical: 6,
              ),
              child: Row(
                children: [
                  _HeroAction(
                    icon: PackIcons.chevronLeft,
                    onTap: () =>
                        context.canPop() ? context.pop() : context.go('/index'),
                  ),
                  const Spacer(),
                  for (final icon in actions) ...[
                    const SizedBox(width: 10),
                    _HeroAction(icon: icon, onTap: () {}),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: CloverColors.ink.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: PackIcon(icon, size: 18, color: CloverColors.ink),
        ),
      ),
    );
  }
}

/// The white sheet that overlaps the hero, rounded on its top corners.
class DetailSheet extends StatelessWidget {
  const DetailSheet({super.key, required this.children, this.overlap = 24});

  final List<Widget> children;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -overlap),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: CloverColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(
          Insets.gutter,
          24,
          Insets.gutter,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

/// One fact in a [SpecGrid]: its icon, label and value.
class Spec {
  const Spec(this.icon, this.label, this.value);

  final String icon;
  final String label;
  final String value;
}

/// Two-column grid of facts. The pack draws these without a card — each cell is
/// an icon beside a small-caps label with the value beneath — so [bordered] is
/// off by default and only switched on where a panel is drawn.
class SpecGrid extends StatelessWidget {
  const SpecGrid({
    super.key,
    required this.rows,
    this.header,
    this.bordered = false,
    this.iconColour = CloverColors.green,
  });

  final List<List<Spec>> rows;

  /// Optional block above the grid, e.g. the venue a route runs from.
  final Widget? header;
  final bool bordered;
  final Color iconColour;

  @override
  Widget build(BuildContext context) {
    final grid = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header case final header?) ...[
          header,
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),
        ],
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final spec in rows[i])
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: PackIcon(spec.icon, size: 19, color: iconColour),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spec.label.toUpperCase(),
                              style: AppText.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              spec.value,
                              style: AppText.cardTitle.copyWith(
                                fontSize: 14,
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
            ],
          ),
        ],
      ],
    );

    if (!bordered) return grid;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CloverColors.border),
      ),
      child: grid,
    );
  }
}

/// Host or venue line: avatar, name, credentials and a trailing action.
class HostRow extends StatelessWidget {
  const HostRow({
    super.key,
    required this.name,
    required this.meta,
    required this.initials,
    this.colour = CloverColors.green,
    this.action,
    this.boxed = false,
    this.metaLines = 1,
    this.showStar = false,
  });

  final String name;
  final String meta;
  final String initials;
  final Color colour;
  final Widget? action;
  final bool boxed;

  /// The cancellation note runs to two lines; most host lines are one.
  final int metaLines;

  /// Prefixes the meta with a filled star, as on a member-hosted route.
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Avatar(initials: initials, size: 42, colour: colour, ring: true),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppText.cardTitle.copyWith(fontSize: 14.5)),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (showStar) ...[
                    const PackIcon(
                      PackIcons.star,
                      size: 15,
                      filled: true,
                      strokeWidth: 1.6,
                      color: CloverColors.amber,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      meta,
                      style: AppText.caption.copyWith(
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                      maxLines: metaLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (action case final action?) action,
      ],
    );

    if (!boxed) return row;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CloverColors.border),
      ),
      child: row,
    );
  }
}

/// Two-column list of ticked requirements, e.g. required equipment.
class TickGrid extends StatelessWidget {
  const TickGrid({super.key, required this.items, this.columns = 2});

  final List<String> items;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = <List<String>>[];
    for (var i = 0; i < items.length; i += columns) {
      rows.add(items.sublist(i, (i + columns).clamp(0, items.length)));
    }

    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                for (var i = 0; i < columns; i++)
                  Expanded(
                    child: i < row.length
                        ? Row(
                            children: [
                              const PackIcon(
                                PackIcons.check,
                                size: 16,
                                color: CloverColors.green,
                                strokeWidth: 2.4,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  row[i],
                                  style: AppText.bodyStrong.copyWith(
                                    fontSize: 12.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Tinted callout with a heading and body — safety notes, refund terms, the
/// "no login required" panel.
class Callout extends StatelessWidget {
  const Callout({
    super.key,
    required this.title,
    required this.body,
    this.tint = CloverColors.greenTint,
    this.icon,
    this.iconColour = CloverColors.green,
  });

  final String title;
  final String body;
  final Color tint;
  final String? icon;
  final Color iconColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PackIcon(icon ?? PackIcons.info, size: 19, color: iconColour),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppText.cardTitle.copyWith(fontSize: 13.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: AppText.caption.copyWith(
              fontSize: 11.5,
              color: CloverColors.ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact list row with a coloured spine on its leading edge — the "meeting
/// here this week" list on a Meet Point.
class SpineRow extends StatelessWidget {
  const SpineRow({
    super.key,
    required this.title,
    required this.meta,
    this.colour = CloverColors.green,
    this.onTap,
  });

  final String title;
  final String meta;
  final Color colour;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: CloverColors.border),
    );

    return Material(
      color: CloverColors.white,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 48,
            minWidth: double.infinity,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: ColoredBox(color: colour),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.rowTitle.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        meta,
                        style: AppText.rowMeta.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
