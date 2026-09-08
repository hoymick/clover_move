import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/thumb.dart';

/// 29 Bag & Checkout — line items, promo and totals. The member discount is a
/// named line rather than a silently reduced price.
class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

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
              child: BackHeader(title: 'Your bag', subtitle: '3 items'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                16,
                Insets.gutter,
                24,
              ),
              children: [
                const _LineItem(
                  image: '29_bag_checkout_1.jpg',
                  name: 'Smart Jersey Kit',
                  meta: 'Size M · Long sleeve · 3 jerseys',
                  price: '€89.00',
                  quantity: 1,
                ),
                const Gap(12),
                const _LineItem(
                  name: 'Clover Cap',
                  meta: 'One size · Green',
                  price: '€24.00',
                  quantity: 2,
                ),
                const Gap(20),
                CloverField(
                  height: 52,
                  radius: 14,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      const PackIcon(
                        PackIcons.tag,
                        size: 18,
                        color: CloverColors.hint,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add a promo code',
                          style: AppText.cardTitle.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: CloverColors.hint,
                          ),
                        ),
                      ),
                      Text(
                        'Apply',
                        style: AppText.link.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                CloverCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const TotalRow(label: 'Subtotal', value: '€137.00'),
                      const TotalRow(label: 'Delivery', value: '€4.95'),
                      const TotalRow(
                        label: 'Member discount',
                        value: '−€13.70',
                      ),
                      const Gap(14),
                      const Divider(height: 1),
                      const Gap(10),
                      const TotalRow(
                        label: 'Total',
                        value: '€128.25',
                        emphasis: true,
                      ),
                      const Gap(14),
                      Row(
                        children: [
                          const PackIcon(
                            PackIcons.lock,
                            size: 14,
                            color: CloverColors.muted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Secure checkout',
                            style: AppText.caption.copyWith(fontSize: 11.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Checkout · €128.25',
              onPressed: () => context.push('/payment'),
            ),
          ),
        ],
      ),
    );
  }
}

/// A bag line: product image, what was chosen, price and a quantity stepper.
class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.name,
    required this.meta,
    required this.price,
    required this.quantity,
    this.image,
  });

  final String name;
  final String meta;
  final String price;
  final int quantity;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: image == null
                ? const ProductImage(
                    image: '28_store_catalogue_2.jpg',
                    radius: 14,
                  )
                : ProductImage(image: image!, radius: 14),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppText.cardTitle.copyWith(fontSize: 14.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: AppText.rowMeta.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        style: AppText.cardTitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _Quantity(quantity: quantity),
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

class _Quantity extends StatelessWidget {
  const _Quantity({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: CloverColors.surfaceMuted,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CloverColors.border),
      ),
      child: Row(
        children: [
          Container(width: 9, height: 1.8, color: CloverColors.inkSoft),
          SizedBox(
            width: 26,
            child: Center(
              child: Text(
                '$quantity',
                style: AppText.cardTitle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const PackIcon(PackIcons.plus, size: 13, color: CloverColors.inkSoft),
        ],
      ),
    );
  }
}
