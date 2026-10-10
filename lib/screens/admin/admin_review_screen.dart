import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import 'admin_workspace_screen.dart';

/// A live moderation decision. Its action buttons update the shared workspace
/// immediately so reviewers cannot accidentally approve the same item twice.
class AdminReviewScreen extends StatelessWidget {
  const AdminReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.adminPreviewActive) return const AdminAccessScreen();
    final item = state.activeApproval;
    if (item == null || item.status != AdminApprovalStatus.pending) {
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
                  subtitle: 'Moderation queue',
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(Insets.gutter),
                  child: MessagePanel(
                    title: 'Nothing waiting for review',
                    body:
                        'Every current route has a decision. New submissions will appear here.',
                    icon: PackIcons.check,
                  ),
                ),
              ),
            ),
            StickyBar(
              child: PrimaryButton(
                label: 'Back to dashboard',
                onPressed: () => context.go('/admin-dashboard'),
              ),
            ),
          ],
        ),
      );
    }

    final requiresReason = item.restrictionReason.contains('Women-only');
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Review route',
                subtitle: '${state.pendingApprovals.length} awaiting approval',
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
                _RouteCard(item: item),
                const Gap(28),
                Text('Checks', style: AppText.section),
                const Gap(12),
                const _CheckRow(
                  label: 'Meet point is an approved venue',
                  passed: true,
                ),
                const Gap(8),
                const _CheckRow(
                  label: 'Host has no open complaints',
                  passed: true,
                ),
                const Gap(8),
                const _CheckRow(
                  label: 'Capacity is within venue limit',
                  passed: true,
                ),
                const Gap(8),
                _CheckRow(
                  label: requiresReason
                      ? 'Restriction needs a recorded reason'
                      : 'No restricted audience declared',
                  passed: !requiresReason,
                ),
                if (requiresReason) ...[
                  const Gap(14),
                  const Callout(
                    title: 'Reason recorded for review',
                    body:
                        'This route has an audience restriction. Confirm that the host reason is appropriate before publishing.',
                    tint: CloverColors.orangeTint,
                    icon: PackIcons.people,
                    iconColour: CloverColors.orangeDark,
                  ),
                ],
                const Gap(26),
                Text(
                  'Host reason',
                  style: AppText.cardTitle.copyWith(fontSize: 13.5),
                ),
                const Gap(12),
                CloverCard(
                  radius: 16,
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    item.restrictionReason,
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
                  child: SecondaryButton(
                    label: 'Reject',
                    onPressed: () =>
                        _decide(context, item.id, AdminApprovalStatus.rejected),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Approve',
                    onPressed: () =>
                        _decide(context, item.id, AdminApprovalStatus.approved),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _decide(BuildContext context, String id, AdminApprovalStatus status) {
    context.read<AppState>().decideApproval(id, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == AdminApprovalStatus.approved
              ? 'Route approved and published'
              : 'Route rejected and returned to the host',
        ),
      ),
    );
    context.go('/admin-dashboard');
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.item});
  final AdminApproval item;

  @override
  Widget build(BuildContext context) => CloverCard(
    radius: 20,
    clip: true,
    padding: EdgeInsets.zero,
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
              Text(item.title, style: AppText.subtitle.copyWith(fontSize: 17)),
              const SizedBox(height: 7),
              Text(item.host, style: AppText.caption.copyWith(fontSize: 11.5)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _Fact(
                      icon: PackIcons.pin,
                      label: 'MEET POINT',
                      value: item.meetingPoint,
                    ),
                  ),
                  Expanded(
                    child: _Fact(
                      icon: PackIcons.clock,
                      label: 'TIME',
                      value: item.schedule,
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

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});
  final String icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(
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
                letterSpacing: .5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: AppText.cardTitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.passed});
  final String label;
  final bool passed;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 44),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          child: Text(label, style: AppText.bodyStrong.copyWith(fontSize: 12)),
        ),
      ],
    ),
  );
}
