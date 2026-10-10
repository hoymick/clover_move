import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
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

/// 29 Bag & Checkout — physical orders must have a delivery or collection
/// method before the member can pay.
class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDelivery = state.storeFulfilment == StoreFulfilment.delivery;
    final deliveryLabel = isDelivery ? '€4.95' : 'Free';
    final total = _money(state.storeOrderTotal);

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
                _PromoField(),
                const Gap(26),
                Text('Receive your order', style: AppText.section),
                const Gap(6),
                Text(
                  'Choose delivery to your address or collect from a partner Meet Point.',
                  style: AppText.caption.copyWith(fontSize: 11.5),
                ),
                const Gap(12),
                _FulfilmentChoice(
                  title: 'Delivery to my address',
                  body: 'Ships to your address · €4.95',
                  icon: PackIcons.home,
                  selected: isDelivery,
                  onTap: () => context.read<AppState>().setStoreFulfilment(
                    StoreFulfilment.delivery,
                  ),
                ),
                if (isDelivery) ...[
                  const Gap(8),
                  _DetailChoice(
                    label: state.deliveryAddress,
                    action: 'Change address',
                    onTap: () => _editAddress(context, state.deliveryAddress),
                  ),
                ],
                const Gap(10),
                _FulfilmentChoice(
                  title: 'Collect from a Partner Meet Point',
                  body: 'Free collection from a selected partner',
                  icon: PackIcons.pin,
                  selected: !isDelivery,
                  onTap: () => context.read<AppState>().setStoreFulfilment(
                    StoreFulfilment.pickup,
                  ),
                ),
                if (!isDelivery) ...[
                  const Gap(8),
                  _DetailChoice(
                    label: state.pickupPoint,
                    action: 'Choose Meet Point',
                    onTap: () => _choosePickupPoint(context),
                  ),
                ],
                const Gap(20),
                CloverCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const TotalRow(label: 'Subtotal', value: '€137.00'),
                      TotalRow(
                        label: isDelivery
                            ? 'Delivery'
                            : 'Meet Point collection',
                        value: deliveryLabel,
                      ),
                      const TotalRow(
                        label: 'Member discount',
                        value: '−€13.70',
                      ),
                      const Gap(14),
                      const Divider(height: 1),
                      const Gap(10),
                      TotalRow(label: 'Total', value: total, emphasis: true),
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
              label: 'Checkout · $total',
              onPressed: () => context.push('/store-checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editAddress(BuildContext context, String initialAddress) async {
    final controller = TextEditingController(text: initialAddress);
    final saved = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delivery address'),
        content: TextField(
          controller: controller,
          maxLines: 2,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Enter your delivery address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (saved != null && context.mounted) {
      context.read<AppState>().setDeliveryAddress(saved);
    }
  }

  Future<void> _choosePickupPoint(BuildContext context) async {
    const points = [
      'Talbot Hotel · Dublin 1',
      'Bray Seafront Hub · Bray',
      'Cork City Sports Centre · Cork',
    ];
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.gutter,
            18,
            Insets.gutter,
            24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Partner Meet Point',
                style: AppText.subtitle.copyWith(fontSize: 18),
              ),
              const Gap(8),
              Text(
                'Collection is free. We will notify you when your order is ready.',
                style: AppText.caption.copyWith(fontSize: 12),
              ),
              const Gap(12),
              for (final point in points)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const PackIcon(
                    PackIcons.pin,
                    size: 20,
                    color: CloverColors.green,
                  ),
                  title: Text(
                    point,
                    style: AppText.cardTitle.copyWith(fontSize: 14),
                  ),
                  trailing: const PackIcon(
                    PackIcons.chevronRight,
                    size: 18,
                    color: CloverColors.hint,
                  ),
                  onTap: () => Navigator.pop(sheetContext, point),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice != null && context.mounted) {
      context.read<AppState>().setPickupPoint(choice);
    }
  }
}

class _PromoField extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CloverField(
    height: 52,
    radius: 14,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        const PackIcon(PackIcons.tag, size: 18, color: CloverColors.hint),
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
          style: AppText.link.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _FulfilmentChoice extends StatelessWidget {
  const _FulfilmentChoice({
    required this.title,
    required this.body,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String body;
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? CloverColors.greenTint : CloverColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: selected ? CloverColors.green : CloverColors.border,
        width: selected ? 2 : 1,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconTile(
              size: 38,
              radius: 12,
              color: selected ? CloverColors.white : CloverColors.greenTint,
              child: PackIcon(icon, size: 19, color: CloverColors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.cardTitle.copyWith(fontSize: 14.5),
                  ),
                  const SizedBox(height: 3),
                  Text(body, style: AppText.caption.copyWith(fontSize: 11.5)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _RadioMark(selected: selected),
          ],
        ),
      ),
    ),
  );
}

class _DetailChoice extends StatelessWidget {
  const _DetailChoice({
    required this.label,
    required this.action,
    required this.onTap,
  });
  final String label;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => CloverCard(
    radius: 14,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.caption.copyWith(
              fontSize: 11.5,
              color: CloverColors.inkSoft,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Text(action, style: AppText.link.copyWith(fontSize: 11.5)),
        ),
      ],
    ),
  );
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: selected ? CloverColors.green : CloverColors.white,
      border: Border.all(
        color: selected ? CloverColors.green : CloverColors.borderStrong,
        width: 2,
      ),
    ),
    child: selected
        ? const PackIcon(PackIcons.check, size: 14, color: CloverColors.white)
        : null,
  );
}

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
  Widget build(BuildContext context) => CloverCard(
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

class _Quantity extends StatelessWidget {
  const _Quantity({required this.quantity});
  final int quantity;
  @override
  Widget build(BuildContext context) => Container(
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

String _money(int cents) => '€${(cents / 100).toStringAsFixed(2)}';
