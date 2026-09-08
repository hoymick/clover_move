import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../theme/pack_icons.dart';
import 'pack_icon.dart';

/// Back chevron, title and optional subtitle — the header on every detail and
/// flow screen. [action] sits on the trailing edge.
class BackHeader extends StatelessWidget {
  const BackHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.titleSize = 19,
    this.showBack = true,
    this.bareBack = true,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final double titleSize;
  final bool showBack;

  /// The pack uses a plain chevron; set false for the circled variant.
  final bool bareBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.gutter, 14, Insets.gutter, 14),
      child: Row(
        children: [
          if (showBack) ...[
            HeaderIconAction(
              icon: PackIcons.chevronLeft,
              bare: bareBack,
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/index'),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.subtitle.copyWith(
                    fontSize: titleSize,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle case final subtitle?) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (action case final action?) ...[const SizedBox(width: 10), action],
        ],
      ),
    );
  }
}

/// Large screen title with no back chevron, e.g. "Filters" or "Notifications".
class TitleHeader extends StatelessWidget {
  const TitleHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.subtitle,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Insets.textGutter,
        22,
        Insets.textGutter,
        6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.title.copyWith(fontSize: 24)),
                if (subtitle case final subtitle?) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppText.caption),
                ],
              ],
            ),
          ),
          if (action case final action?)
            GestureDetector(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(action, style: AppText.link.copyWith(fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Discovery's header — a pin, the current area with a chevron to change it,
/// a notification bell carrying the unread dot, and the member's initials.
class LocationHeader extends StatelessWidget {
  const LocationHeader({
    super.key,
    required this.location,
    required this.initials,
    this.hasAlert = true,
    this.onAvatarTap,
    this.onLocationTap,
    this.onBellTap,
  });

  final String location;
  final String initials;
  final bool hasAlert;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.gutter, 10, Insets.gutter, 8),
      child: Row(
        children: [
          const PackIcon(PackIcons.pin, size: 19, color: CloverColors.green),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: onLocationTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      location,
                      style: AppText.cardTitle.copyWith(fontSize: 14.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const PackIcon(
                    PackIcons.chevronDown,
                    size: 17,
                    color: CloverColors.ink,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // The unread dot sits on the bell, not on the avatar.
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkResponse(
                onTap: onBellTap,
                radius: 22,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: PackIcon(
                    PackIcons.bell,
                    size: 22,
                    color: CloverColors.ink,
                  ),
                ),
              ),
              if (hasAlert)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 4.5,
                    backgroundColor: CloverColors.orange,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CloverColors.greenTint,
                shape: BoxShape.circle,
                border: Border.all(color: CloverColors.green, width: 1.5),
              ),
              child: Text(
                initials,
                style: AppText.badge.copyWith(
                  color: CloverColors.green,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      shape: const CircleBorder(side: BorderSide(color: CloverColors.border)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: PackIcon(icon, size: 18, color: CloverColors.ink),
        ),
      ),
    );
  }
}

/// Trailing circular icon button for a header.
class HeaderIconAction extends StatelessWidget {
  const HeaderIconAction({
    super.key,
    required this.icon,
    this.onTap,
    this.bare = false,
  });

  final String icon;
  final VoidCallback? onTap;

  /// Drops the circle and hairline, leaving just the mark — as the pack draws
  /// the back chevron on the onboarding screens.
  final bool bare;

  @override
  Widget build(BuildContext context) {
    if (!bare) return _CircleAction(icon: icon, onTap: onTap ?? () {});
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: PackIcon(
          icon,
          size: 24,
          color: CloverColors.ink,
          strokeWidth: 2.1,
        ),
      ),
    );
  }
}
