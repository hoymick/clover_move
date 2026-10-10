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

/// Final check before a physical-store payment. The delivery method is shown
/// again here, so neither an address nor a collection point is hidden at pay.
class StoreCheckoutScreen extends StatelessWidget {
  const StoreCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final delivery = state.storeFulfilment == StoreFulfilment.delivery;
    final total = _money(state.storeOrderTotal);
    final destination = delivery ? state.deliveryAddress : state.pickupPoint;

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Checkout',
                subtitle: 'Review your order',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                20,
                Insets.gutter,
                24,
              ),
              children: [
                Text('How you will receive it', style: AppText.section),
                const Gap(12),
                CloverCard(
                  radius: 20,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTile(
                        size: 40,
                        radius: 12,
                        color: CloverColors.greenTint,
                        child: PackIcon(
                          delivery ? PackIcons.home : PackIcons.pin,
                          size: 20,
                          color: CloverColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              delivery
                                  ? 'Delivery to your address'
                                  : 'Partner Meet Point collection',
                              style: AppText.cardTitle.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              destination,
                              style: AppText.bodyStrong.copyWith(
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              delivery
                                  ? 'Delivery fee: €4.95'
                                  : 'Collection is free. We will notify you when it is ready.',
                              style: AppText.caption.copyWith(fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(26),
                Text('Order summary', style: AppText.section),
                const Gap(12),
                CloverCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const TotalRow(
                        label: 'Smart Jersey Kit + Clover Cap',
                        value: '€137.00',
                      ),
                      TotalRow(
                        label: delivery ? 'Delivery' : 'Meet Point collection',
                        value: delivery ? '€4.95' : 'Free',
                      ),
                      const TotalRow(
                        label: 'Member discount',
                        value: '−€13.70',
                      ),
                      const Gap(12),
                      const Divider(height: 1),
                      const Gap(10),
                      TotalRow(
                        label: 'Amount to pay',
                        value: total,
                        emphasis: true,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                const _PaymentNotice(),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Place order · $total',
              onPressed: () => _placeOrder(context, delivery),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, bool delivery) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order placed'),
        content: Text(
          delivery
              ? 'Your order will be shipped to your saved address. We will send tracking when it is dispatched.'
              : 'Your order will be sent to your selected Partner Meet Point. We will notify you when it is ready to collect.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.go('/orders');
            },
            child: const Text('View orders'),
          ),
        ],
      ),
    );
  }
}

class _PaymentNotice extends StatelessWidget {
  const _PaymentNotice();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CloverColors.orangeTint,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PackIcon(
          PackIcons.lock,
          size: 19,
          color: CloverColors.orangeDark,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Secure store payment. Your fulfilment choice is included with this order.',
            style: AppText.bodyStrong.copyWith(fontSize: 12, height: 1.4),
          ),
        ),
      ],
    ),
  );
}

String _money(int cents) => '€${(cents / 100).toStringAsFixed(2)}';
