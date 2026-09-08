import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 20 Admin Dashboard — route and business approvals. Every pending item shows
/// Approve, Reject and View together, so nothing is decided without a way in.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const _pending = [
    ('Morning Route', 'Niamh L. · Talbot Hotel · Orange', CloverColors.orange),
    ('Bray Cliff Walk', 'Declan F. · Public · Green', CloverColors.green),
    ('Sunday Spin · Wicklow Gap', 'Cycling Club · White', Color(0xFF8C9A93)),
  ];

  static const _management = [
    ('Users', PackIcons.people),
    ('Businesses', PackIcons.grid),
    ('Routes & events', PackIcons.pin),
    ('Ireland locations', PackIcons.pin),
    ('Smart Jerseys', PackIcons.shieldCheck),
    ('Payments', PackIcons.card),
    ('Media library', PackIcons.video),
    ('Analytics', PackIcons.chart),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: TitleHeader(
                title: 'Admin',
                subtitle: 'Clover Move Ireland',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                18,
                Insets.gutter,
                24,
              ),
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: '18',
                        label: 'Pending',
                        colour: CloverColors.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value: '1,204',
                        label: 'Routes',
                        colour: CloverColors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value: '386',
                        label: 'Partners',
                        colour: Color(0xFF5A6B63),
                      ),
                    ),
                  ],
                ),
                const Gap(28),
                Row(
                  children: [
                    Expanded(
                      child: Text('Awaiting approval', style: AppText.section),
                    ),
                    Text('18', style: AppText.link),
                  ],
                ),
                const Gap(12),
                for (final (title, meta, colour) in _pending)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PendingCard(
                      title: title,
                      meta: meta,
                      colour: colour,
                      onView: () => context.push('/admin-review'),
                    ),
                  ),
                const Gap(12),
                Text('Payment oversight', style: AppText.section),
                const Gap(12),
                const Row(
                  children: [
                    Expanded(
                      child: _PaymentStat(
                        label: 'Processed by Clover Move',
                        value: '€18,420',
                        meta: 'Official items only',
                        colour: CloverColors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _PaymentStat(
                        label: 'Reported paid to hosts',
                        value: '€7,860',
                        meta: 'Not Clover Move revenue',
                        colour: CloverColors.orangeDark,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Text('Management', style: AppText.section),
                const Gap(12),
                for (var i = 0; i < _management.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ManageTile(
                            label: _management[i].$1,
                            icon: _management[i].$2,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ManageTile(
                            label: _management[i + 1].$1,
                            icon: _management[i + 1].$2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStat extends StatelessWidget {
  const _PaymentStat({
    required this.label,
    required this.value,
    required this.meta,
    required this.colour,
  });

  final String label;
  final String value;
  final String meta;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        height: 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.caption.copyWith(fontSize: 10.5)),
            const Spacer(),
            Text(
              value,
              style: AppText.title.copyWith(fontSize: 18, color: colour),
            ),
            const SizedBox(height: 3),
            Text(meta, style: AppText.caption.copyWith(fontSize: 9.5)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.colour});

  final String value;
  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CloverColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppText.title.copyWith(fontSize: 21, color: colour),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppText.caption.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// A route awaiting approval: colour spine, its details, and the three actions.
class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.title,
    required this.meta,
    required this.colour,
    required this.onView,
  });

  final String title;
  final String meta;
  final Color colour;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: CloverColors.border),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: ColoredBox(color: colour),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.cardTitle.copyWith(fontSize: 14.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: AppText.caption.copyWith(fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    PillButton(
                      label: 'Approve',
                      height: 30,
                      fontSize: 12,
                      onPressed: () {},
                    ),
                    PillButton(
                      label: 'Reject',
                      height: 30,
                      fontSize: 12,
                      colour: CloverColors.white,
                      textColour: CloverColors.inkSoft,
                      border: true,
                      onPressed: () {},
                    ),
                    PillButton(
                      label: 'View',
                      height: 30,
                      fontSize: 12,
                      colour: CloverColors.white,
                      textColour: CloverColors.inkSoft,
                      border: true,
                      onPressed: onView,
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

class _ManageTile extends StatelessWidget {
  const _ManageTile({required this.label, required this.icon});

  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      onTap: () {},
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            IconTile(
              size: 32,
              radius: 10,
              color: CloverColors.greenTint,
              child: PackIcon(icon, size: 17, color: CloverColors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppText.rowTitle.copyWith(fontSize: 13.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
