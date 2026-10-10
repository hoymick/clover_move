import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// The deliberate local entry point for administration. It makes clear that
/// this build has no server-side identity provider attached yet.
class AdminAccessScreen extends StatelessWidget {
  const AdminAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const IconTile(
                  size: 72,
                  radius: 24,
                  color: CloverColors.greenTint,
                  child: PackIcon(
                    PackIcons.shieldCheck,
                    size: 34,
                    color: CloverColors.green,
                  ),
                ),
                const Gap(22),
                Text(
                  'Admin Workspace',
                  style: AppText.title.copyWith(fontSize: 27),
                ),
                const Gap(8),
                Text(
                  'Approve content, manage members and monitor payment records from one place.',
                  style: AppText.body,
                ),
                const Gap(24),
                CloverCard(
                  radius: 20,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          const PackIcon(
                            PackIcons.info,
                            size: 19,
                            color: CloverColors.orangeDark,
                          ),
                          Text(
                            'Local admin preview',
                            style: AppText.cardTitle.copyWith(fontSize: 14.5),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        'The workspace below uses sample data saved only while this app is open. Connect a secured backend before giving staff real access.',
                        style: AppText.caption.copyWith(
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                PrimaryButton(
                  label: 'Open admin preview',
                  icon: PackIcons.shieldCheck,
                  onPressed: () => context.read<AppState>().enterAdminPreview(),
                ),
                const Gap(14),
                Text(
                  'Production setup: connect Supabase or Firebase Authentication and database rules, then replace this local entry with role-based sign-in.',
                  style: AppText.caption.copyWith(fontSize: 11.5, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AdminManagementSection { members, content, payments, operations }

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key, required this.section});

  final AdminManagementSection section;

  String get _title => switch (section) {
    AdminManagementSection.members => 'Members',
    AdminManagementSection.content => 'Routes & content',
    AdminManagementSection.payments => 'Payments',
    AdminManagementSection.operations => 'Operations',
  };

  String get _subtitle => switch (section) {
    AdminManagementSection.members => 'Member, host and partner access',
    AdminManagementSection.content => 'Publishing and moderation history',
    AdminManagementSection.payments => 'Collection and host payment records',
    AdminManagementSection.operations => 'Locations, jerseys and media',
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(title: _title, subtitle: _subtitle),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                20,
                Insets.gutter,
                30,
              ),
              children: switch (section) {
                AdminManagementSection.members => _members(context, state),
                AdminManagementSection.content => _content(context, state),
                AdminManagementSection.payments => _payments(context, state),
                AdminManagementSection.operations => _operations(context),
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _members(BuildContext context, AppState state) => [
    _Summary(
      title: '${state.members.length} accounts',
      body:
          'Suspend access immediately if a member or business violates the community rules.',
    ),
    const Gap(18),
    for (final member in state.members) ...[
      _RecordCard(
        title: member.name,
        meta: '${member.role} · joined ${member.joined}',
        detail: member.email,
        status: member.suspended ? 'Suspended' : 'Active',
        warning: member.suspended,
        action: member.suspended ? 'Restore access' : 'Suspend',
        onAction: () =>
            context.read<AppState>().toggleMemberSuspension(member.id),
      ),
      const Gap(10),
    ],
  ];

  List<Widget> _content(BuildContext context, AppState state) => [
    _Summary(
      title: 'Moderation history',
      body:
          'Every approval decision is retained in this local workspace for staff review.',
    ),
    const Gap(18),
    for (final item in state.approvals) ...[
      _RecordCard(
        title: item.title,
        meta: '${item.type} · ${item.meetingPoint}',
        detail: 'Submitted ${item.submittedAt}',
        status: switch (item.status) {
          AdminApprovalStatus.pending => 'Pending',
          AdminApprovalStatus.approved => 'Approved',
          AdminApprovalStatus.rejected => 'Rejected',
        },
        warning: item.status == AdminApprovalStatus.rejected,
        action: item.status == AdminApprovalStatus.pending ? 'Review' : null,
        onAction: item.status == AdminApprovalStatus.pending
            ? () {
                context.read<AppState>().selectApproval(item.id);
                context.push('/admin-review');
              }
            : null,
      ),
      const Gap(10),
    ],
  ];

  List<Widget> _payments(BuildContext context, AppState state) => [
    _Summary(
      title: 'Payment audit',
      body:
          'Host direct payments are recorded separately from money collected through Clover Move.',
    ),
    const Gap(18),
    for (final payment in state.payments) ...[
      _RecordCard(
        title: payment.title,
        meta: '${payment.payer} · ${payment.channel}',
        detail: '${_money(payment.amount)} · ${payment.createdAt}',
        status: payment.confirmed ? 'Confirmed' : 'Needs review',
        warning: !payment.confirmed,
        action: payment.confirmed ? null : 'Confirm record',
        onAction: payment.confirmed
            ? null
            : () => context.read<AppState>().confirmPayment(payment.id),
      ),
      const Gap(10),
    ],
  ];

  List<Widget> _operations(BuildContext context) => const [
    _Summary(
      title: 'Operations controls',
      body:
          'These areas are ready for their own backend collections and staff permissions.',
    ),
    Gap(18),
    _OperationTile(
      icon: PackIcons.pin,
      title: 'Ireland locations',
      body: 'Add and maintain approved meet points.',
    ),
    Gap(10),
    _OperationTile(
      icon: PackIcons.jersey,
      title: 'Smart Jerseys',
      body: 'Manage kit codes and fulfilment records.',
    ),
    Gap(10),
    _OperationTile(
      icon: PackIcons.video,
      title: 'Media library',
      body: 'Review uploaded images and video.',
    ),
    Gap(10),
    _OperationTile(
      icon: PackIcons.chart,
      title: 'Analytics',
      body: 'Connect live analytics once server events are configured.',
    ),
  ];
}

class _Summary extends StatelessWidget {
  const _Summary({required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => CloverCard(
    radius: 20,
    color: CloverColors.greenTint,
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.cardTitle.copyWith(fontSize: 16)),
        const Gap(6),
        Text(body, style: AppText.caption.copyWith(fontSize: 12, height: 1.4)),
      ],
    ),
  );
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.title,
    required this.meta,
    required this.detail,
    required this.status,
    required this.warning,
    this.action,
    this.onAction,
  });
  final String title;
  final String meta;
  final String detail;
  final String status;
  final bool warning;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => CloverCard(
    radius: 18,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.cardTitle.copyWith(fontSize: 15),
              ),
            ),
            _StatusPill(label: status, warning: warning),
          ],
        ),
        const Gap(5),
        Text(meta, style: AppText.caption.copyWith(fontSize: 11.5)),
        const Gap(3),
        Text(
          detail,
          style: AppText.caption.copyWith(
            fontSize: 11.5,
            color: CloverColors.inkSoft,
          ),
        ),
        if (action != null) ...[
          const Gap(12),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              foregroundColor: warning
                  ? CloverColors.orangeDark
                  : CloverColors.green,
            ),
            child: Text(action!),
          ),
        ],
      ],
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.warning});
  final String label;
  final bool warning;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: warning ? CloverColors.orangeTint : CloverColors.greenTint,
      borderRadius: BorderRadius.circular(Radii.pill),
    ),
    child: Text(
      label,
      style: AppText.caption.copyWith(
        fontSize: 10.5,
        color: warning ? CloverColors.orangeDark : CloverColors.green,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _OperationTile extends StatelessWidget {
  const _OperationTile({
    required this.icon,
    required this.title,
    required this.body,
  });
  final String icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => CloverCard(
    radius: 18,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        IconTile(
          size: 38,
          radius: 12,
          color: CloverColors.greenTint,
          child: PackIcon(icon, size: 19, color: CloverColors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.cardTitle.copyWith(fontSize: 14.5)),
              const SizedBox(height: 3),
              Text(body, style: AppText.caption.copyWith(fontSize: 11.5)),
            ],
          ),
        ),
      ],
    ),
  );
}

String _money(int cents) => '€${(cents / 100).toStringAsFixed(2)}';
