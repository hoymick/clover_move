import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../theme/pack_icons.dart';
import 'pack_icon.dart';

/// Small caps label above a field group — "COUNTY", "DATE", "PRICE".
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key, this.trailing, this.trailingColour});

  final String label;
  final String? trailing;
  final Color? trailingColour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppText.caption.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (trailing case final trailing?)
            Text(
              trailing,
              style: AppText.caption.copyWith(
                fontSize: 12,
                fontWeight: trailingColour == null
                    ? FontWeight.w500
                    : FontWeight.w700,
                color: trailingColour ?? CloverColors.hint,
              ),
            ),
        ],
      ),
    );
  }
}

/// Bordered box holding a value and a chevron — the pack's picker control.
class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.value,
    this.icon,
    this.onTap,
    this.height = 48,
    this.trailingIcon = PackIcons.chevronDown,
    this.iconColour = CloverColors.green,
  });

  final String value;
  final String? icon;
  final VoidCallback? onTap;
  final double height;
  final String? trailingIcon;
  final Color iconColour;

  @override
  Widget build(BuildContext context) {
    return CloverField(
      height: height,
      onTap: onTap,
      child: Row(
        children: [
          if (icon case final icon?) ...[
            PackIcon(icon, size: 17, color: CloverColors.green),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              value,
              style: AppText.cardTitle.copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailingIcon case final trailingIcon?)
            PackIcon(trailingIcon, size: 20, color: CloverColors.hint),
        ],
      ),
    );
  }
}

/// The bordered container every field in the pack sits in.
class CloverField extends StatelessWidget {
  const CloverField({
    super.key,
    required this.child,
    this.height = 48,
    this.onTap,
    this.radius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final Widget child;
  final double height;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: const BorderSide(color: CloverColors.border),
    );

    return Material(
      color: CloverColors.white,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Container(
          height: height,
          padding: padding,
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}

/// Labelled text input used across the registration and sign-up forms.
class LabelledInput extends StatelessWidget {
  const LabelledInput({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.initialValue,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final String? initialValue;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          cursorColor: CloverColors.green,
          style: AppText.cardTitle.copyWith(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.cardTitle.copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: CloverColors.hint,
            ),
            filled: true,
            fillColor: CloverColors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            enabledBorder: _border(CloverColors.border),
            focusedBorder: _border(CloverColors.green),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color colour) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: colour),
  );
}

/// Row with a title, supporting line and a switch on the trailing edge.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.meta,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String meta;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.cardTitle.copyWith(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(meta, style: AppText.caption),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: CloverColors.green,
          inactiveTrackColor: CloverColors.borderStrong,
          thumbColor: const WidgetStatePropertyAll(CloverColors.white),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ],
    );
  }
}

/// The distance slider — green track to the thumb, divider grey after it.
class CloverSlider extends StatelessWidget {
  const CloverSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 50,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: CloverColors.green,
        inactiveTrackColor: CloverColors.divider,
        thumbColor: CloverColors.white,
        overlayColor: CloverColors.green.withValues(alpha: 0.1),
        thumbShape: const _RingThumb(radius: 13),
        trackShape: const RoundedRectSliderTrackShape(),
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(value: value, min: min, max: max, onChanged: onChanged),
    );
  }
}

/// A single-choice row with a leading radio mark, used by the payment methods
/// and plan pickers.
class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    super.key,
    required this.title,
    required this.meta,
    required this.selected,
    required this.onTap,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? meta;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: selected ? CloverColors.green : CloverColors.border,
        width: selected ? 1.5 : 1,
      ),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? CloverColors.greenTint : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                if (leading case final leading?) ...[
                  leading,
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.cardTitle.copyWith(fontSize: 14.5),
                      ),
                      if (meta case final meta?) ...[
                        const SizedBox(height: 3),
                        Text(meta, style: AppText.caption),
                      ],
                    ],
                  ),
                ),
                if (trailing case final trailing?)
                  trailing
                else
                  _RadioMark(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? CloverColors.green : CloverColors.white,
        border: Border.all(
          color: selected ? CloverColors.green : CloverColors.borderStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? const PackIcon(PackIcons.check, size: 14, color: CloverColors.white)
          : null,
    );
  }
}

/// The pack draws the slider handle as a white disc with a green ring, rather
/// than a plain filled thumb.
class _RingThumb extends SliderComponentShape {
  const _RingThumb({required this.radius});

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(center, radius, Paint()..color = CloverColors.white);
    canvas.drawCircle(
      center,
      radius - 1.1,
      Paint()
        ..color = CloverColors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
  }
}
