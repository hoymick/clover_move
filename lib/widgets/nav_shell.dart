import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../theme/pack_icons.dart';
import 'pack_icon.dart';

/// Which of the five tabs a screen belongs to.
enum NavTab {
  home('Home', PackIcons.home, 'discovery'),
  map('Map', PackIcons.pin, 'map'),
  // The pack draws the Routes tab active on screen 38, so that is its home.
  routes('Routes', PackIcons.route, 'empty-state'),
  store('Store', PackIcons.bag, 'store-catalogue'),
  profile('Profile', PackIcons.person, 'user-dashboard');

  const NavTab(this.label, this.icon, this.path);

  final String label;

  final String icon;
  final String path;
}

/// Five-tab bottom bar: Home, Map, Routes, Store, Profile. A hairline divider
/// sits above it and inactive labels drop to hint grey.
class CloverNavBar extends StatelessWidget {
  const CloverNavBar({
    super.key,
    required this.active,
    this.activeColour = CloverColors.green,
  });

  final NavTab active;

  /// Partner accounts show their active tab in orange.
  final Color activeColour;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CloverColors.white,
        border: Border(top: BorderSide(color: CloverColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: Insets.navHeight,
          child: Row(
            children: [
              for (final tab in NavTab.values)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    isActive: tab == active,
                    activeColour: activeColour,
                    onTap: tab == active
                        ? null
                        : () => context.push('/${tab.path}'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.activeColour,
    this.onTap,
  });

  final NavTab tab;
  final bool isActive;
  final Color activeColour;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colour = isActive ? activeColour : CloverColors.hint;

    return Semantics(
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PackIcon(tab.icon, size: 22, color: colour),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: AppText.nav.copyWith(
                color: colour,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
