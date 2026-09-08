import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 44 Admin Review — the checks a route passes before publishing. Passed checks
/// are ticked in green; the one needing a decision is flagged amber, with the
/// host's stated reason underneath so the reviewer can judge it.
class AdminReviewScreen extends StatelessWidget {
  const AdminReviewScreen({super.key});

  static const _checks = [
    ('Meet point is an approved venue', true),
    ('Host has no open complaints', true),
    ('Capacity within venue limit (8 of 120)', true),
    ('Restricted to women aged 25–40', false),
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
              child: BackHeader(
                title: 'Review route',
                subtitle: '1 of 18 pending',
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
                _RouteCard(),
                const Gap(28),
                Text('Checks', style: AppText.section),
                const Gap(12),
                for (final (label, passed) in _checks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _CheckRow(label: label, passed: passed),
                  ),
                const Gap(14),
                const Callout(
                  title: 'Needs a stated reason',
                  body:
                      'Gender and age limits need a stated reason before this '
                      'can be published.',
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.people,
                  iconColour: CloverColors.orangeDark,
                ),
                const Gap(26),
                Text(
                  "Host's reason",
                  style: AppText.cardTitle.copyWith(fontSize: 13.5),
                ),
                const Gap(12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CloverColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CloverColors.border),
                  ),
                  child: Text(
                    "Women-only session requested by the venue's members. Runs "
                    'alongside a mixed class.',
                    style: AppText.bodyStrong.copyWith(
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(label: 'Reject', onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Approve',
                    onPressed: () => context.push('/admin-dashboard'),
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

class _RouteCard extends StatelessWidget {
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
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: ColoredBox(color: CloverColors.orange),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning Route',
                  style: AppText.subtitle.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 7),
                Text(
                  'Niamh L. · verified host · 38 routes',
                  style: AppText.caption.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _Fact(
                        icon: PackIcons.pin,
                        label: 'MEET POINT',
                        value: 'Talbot Hotel',
                      ),
                    ),
                    Expanded(
                      child: _Fact(
                        icon: PackIcons.clock,
                        label: 'TIME',
                        value: '07:00 – 09:00',
                      ),
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

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: PackIcon(icon, size: 18, color: CloverColors.orange),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
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
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: CloverColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: passed ? CloverColors.greenTint : CloverColors.orangeTint,
              shape: BoxShape.circle,
            ),
            child: PackIcon(
              passed ? PackIcons.check : PackIcons.info,
              size: 13,
              color: passed ? CloverColors.green : CloverColors.orangeDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppText.pill.copyWith(
                fontSize: 12.5,
                fontWeight: passed ? FontWeight.w600 : FontWeight.w700,
                color: passed ? CloverColors.ink : CloverColors.orangeDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
