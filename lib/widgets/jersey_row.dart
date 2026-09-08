import 'package:flutter/material.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'category_leaf.dart';
import 'chips.dart';

/// How a jersey stands in relation to its owner.
enum JerseyState {
  yours('Yours', CloverColors.green, CloverColors.greenTint),
  shared('Shared', CloverColors.orangeDark, CloverColors.orangeTint),
  available('Available', CloverColors.muted, CloverColors.divider);

  const JerseyState(this.label, this.colour, this.tint);

  final String label;
  final Color colour;
  final Color tint;
}

/// One jersey in a list: its leaf, name, code, and standing. Selectable rows are
/// used by the share and gift flows; plain rows just report state.
class JerseyRow extends StatelessWidget {
  const JerseyRow({
    super.key,
    required this.category,
    required this.meta,
    this.state,
    this.selected = false,
    this.enabled = true,
    this.onTap,
    this.leafSize = 40,
  });

  final LeafCategory category;
  final String meta;
  final JerseyState? state;
  final bool selected;

  /// Shared jerseys can't be gifted again, so their rows read as unavailable.
  final bool enabled;
  final VoidCallback? onTap;
  final double leafSize;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: selected ? CloverColors.green : CloverColors.border,
        width: selected ? 1.5 : 1,
      ),
    );
    final titleColour = enabled ? CloverColors.ink : CloverColors.hint;

    return Semantics(
      selected: selected,
      button: onTap != null,
      child: Material(
        color: selected ? CloverColors.greenTint : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Opacity(
                  opacity: enabled ? 1 : 0.4,
                  child: CategoryLeaf(category: category, size: leafSize),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${category.label} Jersey',
                        style: AppText.cardTitle.copyWith(
                          fontSize: 14.5,
                          color: titleColour,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        meta,
                        style: AppText.rowMeta.copyWith(
                          fontSize: 11,
                          color: enabled
                              ? CloverColors.muted
                              : CloverColors.hint,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (state case final state?) ...[
                  const SizedBox(width: 8),
                  StatusBadge(
                    label: state.label,
                    fontSize: 11,
                    colour: state.colour,
                    background: state.tint,
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
