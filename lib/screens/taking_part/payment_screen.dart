import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/leaf.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/segmented_tabs.dart';

/// Payment preview for the platform's two deliberately separate money flows.
/// Official Clover Move items are processed in-app; independent host payments
/// are arranged between participant and organiser.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _officialMethods = [
    ('Apple Pay', PackIcons.ticketTag),
    ('Google Pay', PackIcons.ticketTag),
    ('Credit / Debit Card', PackIcons.card),
  ];
  static const _hostMethods = [
    ('Pay on site', 'Pay the host at the event', PackIcons.pin),
    ('Arrange with host', 'Contact the organiser directly', PackIcons.people),
    ('I have paid the host', 'Ask the host to confirm', PackIcons.check),
    (
      'External payment',
      'Open the organiser’s payment link',
      PackIcons.arrowRight,
    ),
    ('Free event', 'No payment is required', PackIcons.ticketTag),
  ];

  int _paymentRoute = 1;
  int _method = 0;

  bool get _official => _paymentRoute == 0;

  String get _statusLabel {
    if (_official) return 'Payment Pending';
    return switch (_method) {
      0 => 'Payment Pending',
      1 => 'Payment Arrangement — Pending',
      2 => 'Awaiting Host Confirmation',
      3 => 'Payment Pending',
      _ => 'Booking Confirmed',
    };
  }

  String get _hostGuidanceTitle => switch (_method) {
    0 => '€10 — Pay on Site',
    1 => 'Arrange payment directly',
    2 => 'Host confirmation required',
    3 => 'External payment',
    _ => 'Free event · €0',
  };

  String get _hostGuidanceBody => switch (_method) {
    0 =>
      'Payment will be made directly to the host or organiser at the event. The status stays Payment Pending until the host confirms it.',
    1 =>
      'Use Clover Move Chat, Contact Host, WhatsApp or another contact option. Payment is arranged outside Clover Move.',
    2 =>
      'After you select “I Have Paid the Host”, the organiser can choose Confirm Payment or Payment Not Confirmed.',
    3 =>
      'You will be redirected to the organiser’s payment service. Clover Move does not process the transaction.',
    _ => 'No payment is required. Join the event to confirm your booking.',
  };

  String get _actionLabel {
    if (_official) return 'Pay €20.00 securely';
    return switch (_method) {
      0 => 'Reserve · pay on site',
      1 => 'Contact host',
      2 => 'I Have Paid the Host',
      3 => 'Pay externally',
      _ => 'Join Event',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(bottom: false, child: BackHeader(title: 'Payment')),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                12,
                Insets.gutter,
                24,
              ),
              children: [
                const FieldLabel('Payment route'),
                SegmentedTabs(
                  labels: const ['Official Clover Move', 'Host / organiser'],
                  selected: _paymentRoute,
                  onChanged: (value) => setState(() {
                    _paymentRoute = value;
                    _method = 0;
                  }),
                ),
                const Gap(18),
                Callout(
                  title: _official
                      ? 'Payment processed by Clover Move'
                      : 'Payment handled directly by the organiser',
                  body: _official
                      ? 'Official events, products, memberships, kits and experiences can be paid for inside the app.'
                      : 'Clover Move records the arrangement and status but does not receive or process this payment.',
                  icon: _official ? PackIcons.shieldCheck : PackIcons.people,
                  tint: _official
                      ? CloverColors.greenTint
                      : CloverColors.orangeTint,
                  iconColour: _official
                      ? CloverColors.green
                      : CloverColors.orangeDark,
                ),
                const Gap(18),
                CloverCard(
                  radius: 22,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const IconTile(
                            size: 44,
                            radius: 14,
                            child: LeafMark(
                              size: 22,
                              color: CloverColors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _official
                                      ? 'Official Clover Move Experience'
                                      : 'Howth Cliff Walk',
                                  style: AppText.cardTitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _official
                                      ? 'Sold by Clover Move'
                                      : 'Independent host · Sat 15 Aug · 09:00',
                                  style: AppText.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(18),
                      const Divider(height: 1),
                      const Gap(12),
                      TotalRow(
                        label: _official
                            ? 'Official experience'
                            : 'Price set by the host',
                        value: _official
                            ? '€20.00'
                            : (_method == 4 ? '€0' : '€10.00'),
                      ),
                      const Gap(6),
                      TotalRow(
                        label: 'Status',
                        value: _statusLabel,
                        emphasis: true,
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                Text(
                  _official ? 'Pay with' : 'Payment options',
                  style: AppText.section.copyWith(fontSize: 16.5),
                ),
                const Gap(14),
                if (_official)
                  for (var i = 0; i < _officialMethods.length; i++) ...[
                    if (i > 0) const Gap(10),
                    ChoiceRow(
                      title: _officialMethods[i].$1,
                      meta: null,
                      selected: i == _method,
                      leading: PackIcon(
                        _officialMethods[i].$2,
                        size: 22,
                        color: CloverColors.ink,
                      ),
                      onTap: () => setState(() => _method = i),
                    ),
                  ]
                else
                  for (var i = 0; i < _hostMethods.length; i++) ...[
                    if (i > 0) const Gap(10),
                    ChoiceRow(
                      title: _hostMethods[i].$1,
                      meta: _hostMethods[i].$2,
                      selected: i == _method,
                      leading: PackIcon(
                        _hostMethods[i].$3,
                        size: 22,
                        color: CloverColors.ink,
                      ),
                      onTap: () => setState(() => _method = i),
                    ),
                  ],
                if (!_official) ...[
                  const Gap(18),
                  Callout(
                    title: _hostGuidanceTitle,
                    body: _hostGuidanceBody,
                    icon: _method == 4 ? PackIcons.ticketTag : PackIcons.info,
                    tint: CloverColors.orangeTint,
                    iconColour: CloverColors.orangeDark,
                  ),
                ],
                if (_official && _method == 2) ...[
                  const Gap(22),
                  const FieldLabel('Card number'),
                  const SelectField(
                    value: '4539  ••••  ••••  8842',
                    icon: PackIcons.card,
                    height: 50,
                    trailingIcon: null,
                  ),
                ],
                const Gap(22),
                Text(
                  _official
                      ? 'Encrypted · Clover Move never stores your card details.'
                      : 'Refunds and collection are handled under the organiser’s applicable policy.',
                  style: AppText.caption.copyWith(fontSize: 11.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: _actionLabel,
              onPressed: () => context.push('/ticket'),
            ),
          ),
        ],
      ),
    );
  }
}
