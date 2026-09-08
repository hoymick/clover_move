import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';

/// 34 Orders — history and tracking. Status sits beside the order number so the
/// list can be scanned for the one order that hasn't arrived.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _filters = ['All', 'Delivered', 'Processing'];

  static const _orders = [
    ('CM-40218', '6 Aug 2026', 'Smart Jersey Kit + 1', '€128.25', false),
    ('CM-39784', '14 Jul 2026', 'Clover Cap', '€24.00', true),
    ('CM-38610', '2 Jun 2026', 'Water Bottle + 2', '€61.00', true),
  ];

  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final visible = _orders.where((o) {
      if (_filter == 1) return o.$5;
      if (_filter == 2) return !o.$5;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Orders',
                action: HeaderIconAction(
                  icon: PackIcons.search,
                  bare: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 14),
                ChipRow(
                  labels: _filters,
                  selectedIndex: _filter,
                  height: 34,
                  fontSize: 12.5,
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: Column(
                    children: [
                      for (final (ref, date, items, total, delivered)
                          in visible)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _OrderCard(
                            reference: ref,
                            date: date,
                            items: items,
                            total: total,
                            delivered: delivered,
                            onTrack: () => context.push('/store-catalogue'),
                          ),
                        ),
                      const Gap(10),
                      Text(
                        'Orders are kept for 24 months',
                        style: AppText.footnote.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.store),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.reference,
    required this.date,
    required this.items,
    required this.total,
    required this.delivered,
    required this.onTrack,
  });

  final String reference;
  final String date;
  final String items;
  final String total;
  final bool delivered;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reference,
                  style: AppText.cardTitle.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StatusBadge(
                label: delivered ? 'Delivered' : 'Processing',
                fontSize: 10.5,
                colour: delivered
                    ? CloverColors.green
                    : CloverColors.orangeDark,
                background: delivered
                    ? CloverColors.greenTint
                    : CloverColors.orangeTint,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(date, style: AppText.caption.copyWith(fontSize: 11)),
          const Gap(16),
          Row(
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: ProductImage(image: '34_orders_1.jpg', radius: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items,
                      style: AppText.pill.copyWith(
                        fontSize: 12.5,
                        color: CloverColors.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: onTrack,
                      child: Text(
                        'Track order',
                        style: AppText.link.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                total,
                style: AppText.cardTitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
