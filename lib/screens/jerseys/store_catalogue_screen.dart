import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/nav_shell.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 28 Store Catalogue — product grid and categories. Each jersey product states
/// whether it activates a token, since that is the thing people get wrong.
class StoreCatalogueScreen extends StatefulWidget {
  const StoreCatalogueScreen({super.key});

  @override
  State<StoreCatalogueScreen> createState() => _StoreCatalogueScreenState();
}

class _StoreCatalogueScreenState extends State<StoreCatalogueScreen> {
  static const _categories = ['All', 'Jerseys', 'Cycling', 'Gym'];

  static const _products = <_Product>[
    _Product(
      name: 'Smart Jersey Kit',
      price: '€89.00',
      badge: 'ACTIVATES',
      image: '28_store_catalogue_1.jpg',
    ),
    _Product(
      name: 'Single Jersey',
      price: '€34.00',
      badge: 'NO TOKEN',
      badgeIsWarning: true,
      image: '28_store_catalogue_2.jpg',
    ),
    _Product(
      name: 'Clover Move Bag',
      price: '€54.00',
      priceColour: CloverColors.ink,
      image: '28_store_catalogue_3.jpg',
    ),
    _Product(
      name: 'Clover Cap',
      price: '€24.00',
      priceColour: CloverColors.orange,
    ),
    _Product(name: 'Water Bottle', price: '€18.00'),
    _Product(
      name: 'Gift Card',
      price: '€25.00',
      priceColour: CloverColors.orange,
      category: LeafCategory.orange,
    ),
  ];

  int _category = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Official Store',
                action: _BagAction(count: 3, onTap: () => context.push('/bag')),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 14),
                ChipRow(
                  labels: _categories,
                  selectedIndex: _category,
                  height: 34,
                  fontSize: 12.5,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: 164 / 190,
                        ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) => _ProductCard(
                      product: _products[index],
                      onTap: () => context.push('/bag'),
                    ),
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

class _Product {
  const _Product({
    required this.name,
    required this.price,
    this.badge,
    this.badgeIsWarning = false,
    this.image,
    this.priceColour = CloverColors.green,
    this.category = LeafCategory.green,
  });

  final String name;
  final String price;
  final String? badge;
  final bool badgeIsWarning;

  /// One of the extracted product photos, when the pack has one.
  final String? image;
  final Color priceColour;
  final LeafCategory category;
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final _Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: switch (product.image) {
                    final image? => ProductImage(image: image, radius: 14),
                    // No photo in the pack for this line — fall back to the
                    // category wash so the grid stays even.
                    null => CloverThumb(
                      category: product.category,
                      radius: 14,
                      leafSize: 34,
                    ),
                  },
                ),
                if (product.badge case final badge?)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: StatusBadge(
                      label: badge,
                      fontSize: 8.5,
                      colour: product.badgeIsWarning
                          ? CloverColors.orangeDark
                          : CloverColors.white,
                      background: product.badgeIsWarning
                          ? CloverColors.orangeTint
                          : CloverColors.green,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: AppText.rowTitle.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.price,
                  style: AppText.price.copyWith(
                    fontSize: 14,
                    color: product.priceColour,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: CloverColors.greenTint,
                  shape: BoxShape.circle,
                ),
                child: const PackIcon(
                  PackIcons.plus,
                  size: 17,
                  color: CloverColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bag icon with the item count as an orange dot.
class _BagAction extends StatelessWidget {
  const _BagAction({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        HeaderIconAction(icon: PackIcons.bag, onTap: onTap),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: CloverColors.orange,
              shape: BoxShape.circle,
            ),
            child: Text('$count', style: AppText.badge.copyWith(fontSize: 9)),
          ),
        ),
      ],
    );
  }
}
