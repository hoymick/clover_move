import 'package:flutter/material.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'cards.dart';
import 'category_leaf.dart';
import 'chips.dart';
import 'thumb.dart';
import '../theme/pack_icons.dart';
import '../widgets/pack_icon.dart';

/// Half-width event tile from the Discovery feed — thumbnail, name, when,
/// price and a Join pill.
class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.title,
    required this.when,
    required this.price,
    this.category = LeafCategory.green,
    this.motif = ThumbMotif.rings,
    this.onTap,
    this.onJoin,
  });

  final String title;
  final String when;
  final String price;
  final LeafCategory category;
  final ThumbMotif motif;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: Radii.tile,
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CloverThumb(
            category: category,
            motif: motif,
            height: 76,
            radius: 12,
            badge: _CategoryBadge(category: category),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppText.rowTitle.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(when, style: AppText.rowMeta.copyWith(fontSize: 10.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text(price, style: AppText.price)),
              PillButton(
                label: 'Join',
                height: 22,
                fontSize: 10.5,
                onPressed: onJoin,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The pack marks an official event with the category's own leaf on a white
/// tile, rather than a generic verified mark.
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final LeafCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(Radii.icon),
      ),
      child: CategoryLeaf(category: category, size: 21),
    );
  }
}

/// Full-width search result — 80 square thumbnail, title, meta, price and Join,
/// with the favourite heart in the card's top-right corner.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.title,
    required this.meta,
    required this.price,
    this.official = false,
    this.category = LeafCategory.green,
    this.motif = ThumbMotif.rings,
    this.onTap,
    this.onJoin,
    this.action = 'Join',
    this.saved = false,
  });

  final String title;
  final String meta;
  final String price;
  final bool official;
  final LeafCategory category;
  final ThumbMotif motif;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final String action;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CloverThumb(
            category: category,
            motif: motif,
            width: 80,
            height: 80,
            badge: official
                ? const StatusBadge(
                    label: 'OFFICIAL',
                    fontSize: 8,
                    background: CloverColors.white,
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppText.cardTitle.copyWith(fontSize: 14.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PackIcon(
                      PackIcons.heart,
                      size: 20,
                      color: saved ? CloverColors.orange : CloverColors.hint,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: AppText.rowMeta.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        style: AppText.price.copyWith(fontSize: 13.5),
                      ),
                    ),
                    PillButton(label: action, height: 34, onPressed: onJoin),
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

/// Map sheet row — a large rounded colour tile, title and meta.
class NearbyRow extends StatelessWidget {
  const NearbyRow({
    super.key,
    required this.title,
    required this.meta,
    this.category = LeafCategory.green,
    this.onTap,
  });

  final String title;
  final String meta;
  final LeafCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: category.tint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CategoryLeaf(category: category, size: 40),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(meta, style: AppText.caption.copyWith(fontSize: 11.5)),
                ],
              ),
            ),
            const PackIcon(PackIcons.chevronRight, color: CloverColors.hint),
          ],
        ),
      ),
    );
  }
}
