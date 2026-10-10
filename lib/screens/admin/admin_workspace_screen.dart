import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/admin_backend.dart';
import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// The admin gateway becomes a real email/password sign-in as soon as the
/// Supabase runtime values are supplied to the deployed app.
class AdminAccessScreen extends StatefulWidget {
  const AdminAccessScreen({super.key});

  @override
  State<AdminAccessScreen> createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final allowed = await AdminBackend.signInAdmin(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (allowed) {
        final state = context.read<AppState>();
        await state.loadAdminData();
        if (!mounted) return;
        state.enterAdminPreview();
      } else {
        setState(() => _error = 'This account does not have admin access.');
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'We could not sign you in. Check your details and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backendReady = AdminBackend.isConfigured;
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
                if (backendReady) ...[
                  Text('Staff sign in', style: AppText.section),
                  const Gap(12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'Work email'),
                  ),
                  const Gap(12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  if (_error != null) ...[
                    const Gap(10),
                    Text(
                      _error!,
                      style: AppText.caption.copyWith(color: CloverColors.red),
                    ),
                  ],
                  const Gap(18),
                  PrimaryButton(
                    label: _submitting ? 'Signing in…' : 'Sign in securely',
                    icon: PackIcons.lock,
                    onPressed: _submitting ? null : _signIn,
                  ),
                ] else ...[
                  CloverCard(
                    radius: 20,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const PackIcon(
                              PackIcons.info,
                              size: 19,
                              color: CloverColors.orangeDark,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Admin preview',
                                style: AppText.cardTitle.copyWith(
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Text(
                          'The real staff sign-in and database connection are being configured. This preview uses sample data and does not grant production access.',
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
                    onPressed: () =>
                        context.read<AppState>().enterAdminPreview(),
                  ),
                  const Gap(14),
                  Text(
                    'The preview will be replaced by secure staff sign-in once the Supabase project is connected.',
                    style: AppText.caption.copyWith(
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
        action: state.isCurrentAdmin(member.id)
            ? null
            : member.suspended
            ? 'Restore access'
            : 'Suspend',
        onAction: () async {
          try {
            await context.read<AppState>().toggleMemberSuspension(member.id);
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Could not change account access. Your own admin account is protected.',
                  ),
                ),
              );
            }
          }
        },
      ),
      const Gap(10),
    ],
  ];

  List<Widget> _content(BuildContext context, AppState state) => [
    _Summary(
      title: 'Moderation history',
      body:
          'Every approval decision is kept in the secured staff audit history.',
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
            : () async {
                await context.read<AppState>().confirmPayment(payment.id);
              },
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
