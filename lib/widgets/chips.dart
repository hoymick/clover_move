import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'pack_icon.dart';

/// Rounded pill used for every filter and segment in the pack. Selected fills
/// with a colour and flips the label to white; unselected keeps a hairline.
class CloverChip extends StatelessWidget {
  const CloverChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.height = 30,
    this.fontSize = 11.5,
    this.selectedColour = CloverColors.green,
    this.icon,
    this.leading,
    this.horizontalPadding,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double height;
  final double fontSize;
  final Color selectedColour;
  final String? icon;

  /// Arbitrary leading content, e.g. the category leaf on the map's filters.
  final Widget? leading;

  /// Defaults to half the height; the pack's leaf-bearing chips are tighter.
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(height / 2),
      side: selected
          ? BorderSide.none
          : const BorderSide(color: CloverColors.border),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? selectedColour : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? height * 0.5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading case final leading?) ...[
                  leading,
                  const SizedBox(width: 8),
                ] else if (icon case final icon?) ...[
                  PackIcon(
                    icon,
                    size: fontSize + 3,
                    color: selected ? CloverColors.white : CloverColors.inkSoft,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppText.pill.copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: selected ? CloverColors.white : CloverColors.inkSoft,
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

/// Horizontally scrolling row of chips with single selection.
class ChipRow extends StatelessWidget {
  const ChipRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 30,
    this.fontSize = 11.5,
    this.padding = const EdgeInsets.symmetric(horizontal: Insets.gutter),
    this.selectedColour = CloverColors.green,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color selectedColour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => CloverChip(
          label: labels[index],
          selected: index == selectedIndex,
          height: height,
          fontSize: fontSize,
          selectedColour: selectedColour,
          onTap: () => onChanged(index),
        ),
      ),
    );
  }
}

/// Chip row that wraps instead of scrolling, for the taller filter groups.
class ChipWrap extends StatelessWidget {
  const ChipWrap({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 34,
    this.fontSize = 12.5,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          CloverChip(
            label: labels[i],
            selected: i == selectedIndex,
            height: height,
            fontSize: fontSize,
            onTap: () => onChanged(i),
          ),
      ],
    );
  }
}

/// Small solid pill action, e.g. the "Join" button on an event card.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.colour = CloverColors.green,
    this.height = 28,
    this.fontSize = 12,
    this.textColour = CloverColors.white,
    this.border = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color colour;
  final double height;
  final double fontSize;
  final Color textColour;

  /// White pills sit on white cards, so they need the hairline to read.
  final bool border;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(height / 2),
      side: border
          ? const BorderSide(color: CloverColors.border)
          : BorderSide.none,
    );

    return Material(
      color: colour,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: height * 0.55),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppText.badge.copyWith(
                fontSize: fontSize,
                color: textColour,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Static label pill — "OFFICIAL", "Business+", "Refunded". Tinted background
/// with the tint's own colour for the text.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.colour = CloverColors.green,
    this.background,
    this.fontSize = 10,
    this.icon,
  });

  final String label;
  final Color colour;
  final Color? background;
  final double fontSize;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fontSize + 12,
      padding: EdgeInsets.symmetric(horizontal: fontSize * 0.7),
      decoration: BoxDecoration(
        color: background ?? colour.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular((fontSize + 12) / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final icon?) ...[
            PackIcon(icon, size: fontSize + 1, color: colour),
            const SizedBox(width: 4),
          ],
          // Flexible so a long label ellipsises inside a constrained row
          // rather than overflowing the badge.
          Flexible(
            child: Text(
              label,
              style: AppText.badge.copyWith(
                fontSize: fontSize,
                color: colour,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
