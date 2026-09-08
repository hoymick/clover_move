import 'package:flutter/material.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'category_leaf.dart';

/// The leaves as the category switch — three 92-high tiles, Green, White,
/// Orange. The selected tile fills with its colour and the leaf inverts.
class CategorySwitch extends StatelessWidget {
  const CategorySwitch({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final LeafCategory selected;
  final ValueChanged<LeafCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final category in LeafCategory.values) ...[
          if (category != LeafCategory.values.first) const SizedBox(width: 8),
          Expanded(
            child: _CategoryTile(
              category: category,
              isSelected: category == selected,
              onTap: () => onChanged(category),
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final LeafCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Selected tiles fill with the category colour, except White, which keeps a
    // white face and gains a strong border so it stays legible.
    final filled = isSelected && category != LeafCategory.white;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.card),
      side: filled
          ? BorderSide.none
          : BorderSide(
              color: isSelected ? CloverColors.ink : CloverColors.border,
              width: isSelected ? 1.5 : 1,
            ),
    );

    return Semantics(
      selected: isSelected,
      button: true,
      label: category.label,
      child: Material(
        color: filled ? category.colour : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: 92,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryLeaf(
                  category: category,
                  size: 56,
                  onColour: filled ? CloverColors.white : null,
                ),
                const SizedBox(height: 8),
                Text(
                  category.label,
                  style: AppText.pill.copyWith(
                    color: filled ? CloverColors.white : CloverColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
