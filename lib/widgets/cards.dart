import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/pack_icons.dart';
import '../theme/typography.dart';
import 'pack_icon.dart';

/// White panel with the standard hairline border. Every list card, row and
/// feature block in the product is one of these.
class CloverCard extends StatelessWidget {
  const CloverCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = Radii.card,
    this.color = CloverColors.white,
    this.border = true,
    this.padding = EdgeInsets.zero,
    this.clip = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final Color color;
  final bool border;
  final EdgeInsetsGeometry padding;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: border
          ? const BorderSide(color: CloverColors.border)
          : BorderSide.none,
    );

    return Material(
      color: color,
      shape: shape,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Rounded square holding a small icon or leaf — 68, 28 and 26 variants
/// appear across the mockups.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.child,
    this.size = 28,
    this.color = CloverColors.green,
    this.radius,
  });

  final Widget child;
  final double size;
  final Color color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          radius ?? (size >= 60 ? Radii.iconLarge : Radii.icon),
        ),
      ),
      child: child,
    );
  }
}

/// Section header with an optional trailing link, e.g. "Official Events · See all".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppText.section)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!, style: AppText.link),
          ),
      ],
    );
  }
}

/// The 36-high compact row used for recommendations and search results.
class CompactRow extends StatelessWidget {
  const CompactRow({
    super.key,
    required this.title,
    required this.meta,
    required this.icon,
    this.iconColor = CloverColors.greenTint,
    this.onTap,
  });

  final String title;
  final String meta;
  final Widget icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: Radii.row,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          IconTile(
            size: 26,
            color: iconColor,
            radius: Radii.iconSmall,
            child: icon,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: CloverColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  meta,
                  style: AppText.caption.copyWith(fontSize: 9.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const PackIcon(
            PackIcons.chevronRight,
            size: 17,
            color: CloverColors.hint,
          ),
        ],
      ),
    );
  }
}
