import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/admin_backend.dart';
import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import 'admin_workspace_screen.dart';

/// 20 Admin Dashboard — route and business approvals. Every pending item shows
/// Approve, Reject and View together, so nothing is decided without a way in.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const _management = [
    ('Users', PackIcons.people, AdminManagementSection.members),
    ('Businesses', PackIcons.grid, AdminManagementSection.members),
    ('Routes & events', PackIcons.pin, AdminManagementSection.content),
    ('Ireland locations', PackIcons.pin, AdminManagementSection.operations),
    ('Smart Jerseys', PackIcons.shieldCheck, AdminManagementSection.operations),
    ('Payments', PackIcons.card, AdminManagementSection.payments),
    ('Media library', PackIcons.video, AdminManagementSection.operations),
    ('Analytics', PackIcons.chart, AdminManagementSection.operations),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.adminPreviewActive) return const AdminAccessScreen();
    final pending = state.pendingApprovals;
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: TitleHeader(
                title: 'Admin',
                subtitle: 'Clover Move Ireland',
                action: 'Sign out',
                onAction: () async {
                  await AdminBackend.signOut();
                  if (context.mounted) {
                    context.read<AppState>().leaveAdminPreview();
                  }
                },
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
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: '${pending.length}',
                        label: 'Pending',
                        colour: CloverColors.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value:
                            '${state.approvals.where((item) => item.status == AdminApprovalStatus.approved).length + 1204}',
                        label: 'Routes',
                        colour: CloverColors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value: '${state.members.length}',
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
                    Text('${pending.length}', style: AppText.link),
                  ],
                ),
                const Gap(12),
                if (pending.isEmpty)
                  const _EmptyApprovals()
                else
                  for (var index = 0; index < pending.length; index++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PendingCard(
                        title: pending[index].title,
                        meta:
                            '${pending[index].host} · ${pending[index].meetingPoint}',
                        colour: index.isEven
                            ? CloverColors.orange
                            : CloverColors.green,
                        onApprove: () =>
                            context.read<AppState>().decideApproval(
                              pending[index].id,
                              AdminApprovalStatus.approved,
                            ),
                        onReject: () => context.read<AppState>().decideApproval(
                          pending[index].id,
                          AdminApprovalStatus.rejected,
                        ),
                        onView: () {
                          context.read<AppState>().selectApproval(
                            pending[index].id,
                          );
                          context.push('/admin-review');
                        },
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
                            onTap: () =>
                                _openManagement(context, _management[i].$3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ManageTile(
                            label: _management[i + 1].$1,
                            icon: _management[i + 1].$2,
                            onTap: () =>
                                _openManagement(context, _management[i + 1].$3),
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

  void _openManagement(BuildContext context, AdminManagementSection section) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AdminManagementScreen(section: section),
      ),
    );
  }
}

class _EmptyApprovals extends StatelessWidget {
  const _EmptyApprovals();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: CloverColors.greenTint,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      'You are all caught up. There are no routes waiting for a decision.',
      style: AppText.bodyStrong.copyWith(fontSize: 13),
    ),
  );
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
    required this.onApprove,
    required this.onReject,
    required this.onView,
  });

  final String title;
  final String meta;
  final Color colour;
  final VoidCallback onApprove;
  final VoidCallback onReject;
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
                      onPressed: onApprove,
                    ),
                    PillButton(
                      label: 'Reject',
                      height: 30,
                      fontSize: 12,
                      colour: CloverColors.white,
                      textColour: CloverColors.inkSoft,
                      border: true,
                      onPressed: onReject,
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
  const _ManageTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      onTap: onTap,
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
