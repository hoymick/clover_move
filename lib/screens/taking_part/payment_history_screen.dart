import 'package:flutter/material.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// Participant-facing record of the payment method and who received the money.
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static const _payments = [
    ('Walking Group', '€10.00', 'Pay on Site', 'Payment Pending'),
    ('Cycling Tour', '€15.00', 'Host', 'Paid to Host'),
    ('Clover Move Experience', '€20.00', 'Clover Move', 'Payment Confirmed'),
  ];

  Color _statusColour(String status) {
    if (status == 'Paid to Host' || status == 'Payment Confirmed') {
      return CloverColors.green;
    }
    return CloverColors.orangeDark;
  }

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
                title: 'Payment history',
                subtitle: 'My events and payments',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                22,
                Insets.gutter,
                28,
              ),
              children: [
                const _TransparencyPanel(),
                const Gap(20),
                Text('My events', style: AppText.section),
                const Gap(12),
                CloverCard(
                  radius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < _payments.length;
                        index++
                      ) ...[
                        _PaymentRow(
                          event: _payments[index].$1,
                          amount: _payments[index].$2,
                          method: _payments[index].$3,
                          status: _payments[index].$4,
                          statusColour: _statusColour(_payments[index].$4),
                        ),
                        if (index < _payments.length - 1)
                          const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
                const Gap(20),
                Text('Payment statuses', style: AppText.section),
                const Gap(12),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CloverChip(label: 'Payment Pending'),
                    CloverChip(label: 'Payment Confirmed'),
                    CloverChip(label: 'Paid to Host'),
                    CloverChip(label: 'Payment Failed'),
                    CloverChip(label: 'Payment Cancelled'),
                    CloverChip(label: 'Payment Refunded'),
                    CloverChip(label: 'Payment Not Confirmed'),
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

class _TransparencyPanel extends StatelessWidget {
  const _TransparencyPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CloverColors.greenTint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            size: 34,
            radius: 11,
            child: PackIcon(
              PackIcons.shieldCheck,
              size: 18,
              color: CloverColors.white,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '“Paid to Host” means the organiser received the payment directly. Clover Move did not process or receive that transaction.',
              style: AppText.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.event,
    required this.amount,
    required this.method,
    required this.status,
    required this.statusColour,
  });

  final String event;
  final String amount;
  final String method;
  final String status;
  final Color statusColour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          IconTile(
            size: 36,
            radius: 12,
            color: CloverColors.greenTint,
            child: const PackIcon(
              PackIcons.calendar,
              size: 18,
              color: CloverColors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event, style: AppText.cardTitle.copyWith(fontSize: 13.5)),
                const SizedBox(height: 3),
                Text(method, style: AppText.caption.copyWith(fontSize: 10.5)),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: AppText.badge.copyWith(
                    color: statusColour,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          Text(amount, style: AppText.cardTitle.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
