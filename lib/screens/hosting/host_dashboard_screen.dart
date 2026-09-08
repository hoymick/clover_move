import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 21 Host Dashboard — requests, sessions and the way to create another route.
/// The ink header carries the host's standing; the body is the work to do.
class HostDashboardScreen extends StatelessWidget {
  const HostDashboardScreen({super.key});

  static const _requests = [
    ('Aoife K.', 'AK', 'Morning Route · age 29'),
    ('Síle N.', 'SN', 'Morning Route · age 27'),
  ];

  static const _sessions = [
    ('Morning Route', 'Mon 07:00 · Talbot Hotel · 5 of 8', CloverColors.orange),
    (
      'Sandymount Sunset Run',
      'Wed 19:30 · Public · 14 of 20',
      CloverColors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const _HostHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                24,
                Insets.gutter,
                24,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Join requests', style: AppText.section),
                    ),
                    Text('3', style: AppText.link),
                  ],
                ),
                const Gap(12),
                for (final (name, initials, meta) in _requests)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _RequestCard(
                      name: name,
                      initials: initials,
                      meta: meta,
                    ),
                  ),
                const Gap(20),
                SectionHeader(
                  title: 'Your next sessions',
                  action: 'See all',
                  onAction: () => context.push('/manage-route'),
                ),
                const Gap(12),
                for (final (title, meta, colour) in _sessions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SpineRow(
                      title: title,
                      meta: meta,
                      colour: colour,
                      onTap: () => context.push('/manage-route'),
                    ),
                  ),
                const Gap(12),
                _CreateAction(onTap: () => context.push('/create-route')),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.routes),
        ],
      ),
    );
  }
}

/// Ink header with the host's name, badge and three standing figures.
class _HostHeader extends StatelessWidget {
  const _HostHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CloverColors.ink,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.textGutter,
            18,
            Insets.textGutter,
            22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Host',
                style: AppText.title.copyWith(
                  fontSize: 24,
                  color: CloverColors.white,
                ),
              ),
              const Gap(6),
              Text(
                'Niamh L. · Stillorgan',
                style: AppText.caption.copyWith(
                  fontSize: 12.5,
                  color: const Color(0xFF9FBFC2),
                ),
              ),
              const Gap(12),
              const StatusBadge(
                label: 'VERIFIED HOST',
                colour: CloverColors.white,
                background: CloverColors.green,
              ),
              const Gap(24),
              const Row(
                children: [
                  Expanded(
                    child: _HeaderStat(value: '4', label: 'Live routes'),
                  ),
                  Expanded(
                    child: _HeaderStat(value: '128', label: 'Participants'),
                  ),
                  Expanded(
                    child: _HeaderStat(value: '4.9', label: 'Rating'),
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

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.value, required this.label});

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
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9FBFC2),
          ),
        ),
      ],
    );
  }
}

/// A join request with Approve / Decline sitting directly under the name.
class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.name,
    required this.initials,
    required this.meta,
  });

  final String name;
  final String initials;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            initials: initials,
            size: 36,
            colour: CloverColors.orange,
            ring: true,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.cardTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(meta, style: AppText.rowMeta.copyWith(fontSize: 10.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    PillButton(
                      label: 'Approve',
                      height: 24,
                      fontSize: 11,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    PillButton(
                      label: 'Decline',
                      height: 24,
                      fontSize: 11,
                      colour: CloverColors.white,
                      textColour: CloverColors.inkSoft,
                      border: true,
                      onPressed: () {},
                    ),
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

class _CreateAction extends StatelessWidget {
  const _CreateAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.green,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PackIcon(
                PackIcons.plus,
                size: 20,
                color: CloverColors.white,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Create Route or Event',
                  style: AppText.button.copyWith(fontSize: 15.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
