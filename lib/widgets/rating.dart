import 'package:flutter/material.dart';

import '../theme/pack_icons.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'pack_icon.dart';

/// Five stars. The pack scores the overall experience in green and the
/// individual lines in amber; unscored stars drop to the strong border grey.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 28,
    this.spacing = 10,
    this.colour = CloverColors.amber,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final double size;
  final double spacing;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++) ...[
          if (i > 1) SizedBox(width: spacing),
          Semantics(
            button: onChanged != null,
            label: '$i of 5',
            child: GestureDetector(
              onTap: onChanged == null ? null : () => onChanged!(i),
              child: PackIcon(
                PackIcons.star,
                size: size,
                filled: true,
                // The pack keeps a 1.6 stroke on stars, tighter than its icons.
                strokeWidth: 1.6,
                color: i <= value ? colour : CloverColors.borderStrong,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A titled rating line — what is being rated on the left, the stars on the
/// right. Used four times on the review screen.
class RatingRow extends StatelessWidget {
  const RatingRow({
    super.key,
    required this.title,
    required this.meta,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String meta;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.cardTitle.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: AppText.caption.copyWith(fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StarRating(value: value, onChanged: onChanged, size: 20, spacing: 6),
        ],
      ),
    );
  }
}

/// Filled capacity bar — "40 of 40 places taken".
class CapacityBar extends StatelessWidget {
  const CapacityBar({
    super.key,
    required this.filled,
    required this.total,
    this.height = 8,
    this.colour = CloverColors.green,
  });

  final int filled;
  final int total;
  final double height;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : (filled / total).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: CloverColors.divider),
            ),
            FractionallySizedBox(
              widthFactor: fraction,
              child: ColoredBox(color: colour),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlapping avatar stack with a "+N more" tail.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.initials,
    this.moreLabel,
    this.size = 34,
    this.colour = CloverColors.white,
    this.textColour = CloverColors.green,
  });

  final List<String> initials;
  final String? moreLabel;
  final double size;
  final Color colour;
  final Color textColour;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final label in initials)
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.only(right: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.circle,
              border: Border.all(color: textColour.withValues(alpha: 0.35)),
            ),
            child: Text(
              label,
              style: AppText.badge.copyWith(fontSize: 10.5, color: textColour),
            ),
          ),
        if (moreLabel case final moreLabel?) ...[
          const SizedBox(width: 6),
          Text(
            moreLabel,
            style: AppText.caption.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: colour == CloverColors.white
                  ? const Color(0xFFCFEADD)
                  : CloverColors.muted,
            ),
          ),
        ],
      ],
    );
  }
}
