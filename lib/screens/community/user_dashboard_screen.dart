import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/leaf.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/qr.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 17 User Dashboard — the member's standing, their Smart Jerseys token, and
/// everything they own in one list.
class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  static const _sections = [
    ('My Routes', '12 · 1 pending approval', PackIcons.route, '/empty-state'),
    ('My Events', '3 upcoming', PackIcons.calendar, '/official-event'),
    (
      'Payment history',
      'Methods, statuses and organiser payments',
      PackIcons.card,
      '/payment-history',
    ),
    (
      'My Smart Jerseys',
      '2 kits · 5 of 6 yours',
      PackIcons.jersey,
      '/store-catalogue',
    ),
    (
      'My Smart Jersey Kit',
      'Green · White · Orange · Size M',
      PackIcons.grid,
      '/store-catalogue',
    ),
    ('Tickets', '2 valid', PackIcons.ticket, '/ticket'),
    ('Orders', '4 completed', PackIcons.card, '/store-catalogue'),
    (
      'Account settings',
      'Profile, sign-in details and account controls',
      PackIcons.person,
      '/account-settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          _ProfileHeader(memberLabel: '${category.label.toUpperCase()} MEMBER'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                24,
                Insets.gutter,
                24,
              ),
              children: [
                const _TokenCard(),
                const Gap(20),
                for (final (title, meta, icon, route) in _sections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _SectionRow(
                      title: title,
                      meta: meta,
                      icon: icon,
                      onTap: () => context.push(route),
                    ),
                  ),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.profile),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.memberLabel});

  final String memberLabel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CloverColors.ink,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.gutter,
            20,
            Insets.gutter,
            20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Avatar(
                    initials: 'AN',
                    size: 64,
                    colour: CloverColors.white,
                    ring: true,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Andrea Ní Bhriain',
                          style: AppText.subtitle.copyWith(
                            fontSize: 20,
                            color: CloverColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Member since Jan 2026 · Dublin',
                          style: AppText.caption.copyWith(
                            fontSize: 12.5,
                            color: const Color(0xFF8FB3B0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        StatusBadge(
                          label: memberLabel,
                          fontSize: 9.5,
                          colour: CloverColors.white,
                          background: CloverColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(26),
              const Row(
                children: [
                  Expanded(
                    child: _Stat(value: '12', label: 'Routes'),
                  ),
                  Expanded(
                    child: _Stat(value: '31', label: 'Events'),
                  ),
                  Expanded(
                    child: _Stat(value: '284', label: 'km'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppText.title.copyWith(
            fontSize: 22,
            color: CloverColors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppText.caption.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8FB3B0),
          ),
        ),
      ],
    );
  }
}

/// The Smart Jerseys token — one code per member, with its QR alongside.
class _TokenCard extends StatelessWidget {
  const _TokenCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CloverColors.ink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CloverColors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const CloverLogo(size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Jerseys Token',
                  style: AppText.cardTitle.copyWith(
                    fontSize: 14,
                    color: CloverColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'CM-SJ-7F82-K4P9-X6',
                  style: AppText.caption.copyWith(
                    fontSize: 11.5,
                    color: const Color(0xFF9FD9BC),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E4A50),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    '2 kits · 1 shared',
                    style: AppText.badge.copyWith(
                      fontSize: 10,
                      color: const Color(0xFF9FBFAE),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: CloverColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const QrBlock(size: 52, modules: 17, seed: 7382),
          ),
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.title,
    required this.meta,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String meta;

  /// Null uses the leaf pictogram, as the pack does for Smart Jerseys.
  final String? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 15,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconTile(
            size: 32,
            radius: 10,
            color: CloverColors.greenTint,
            child: icon == null
                ? const LeafMark(size: 17)
                : PackIcon(icon!, size: 17, color: CloverColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.cardTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: AppText.caption.copyWith(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const PackIcon(PackIcons.chevronRight, color: CloverColors.hint),
        ],
      ),
    );
  }
}
