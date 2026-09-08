import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'pack_icon.dart';

/// Full-width green action — 58 high, 18 radius.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = CloverColors.green,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  /// Optional mark before the label, e.g. the pin on "Get directions".
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: enabled ? color : CloverColors.borderStrong,
        borderRadius: BorderRadius.circular(Radii.tile),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(Radii.tile),
          child: Container(
            height: Insets.buttonHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon case final icon?) ...[
                  PackIcon(icon, size: 20, color: CloverColors.white),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: AppText.button,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

/// Full-width white action with a hairline border.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional mark before the label, as on the gift action.
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: CloverColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.tile),
          side: const BorderSide(color: CloverColors.borderStrong),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(Radii.tile),
          child: Container(
            height: Insets.buttonHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon case final icon?) ...[
                  PackIcon(icon, size: 19, color: CloverColors.inkSoft),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: AppText.buttonAlt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

/// Quiet text action, e.g. "Decline" under the terms.
class QuietButton extends StatelessWidget {
  const QuietButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: CloverColors.muted,
        textStyle: AppText.footnote.copyWith(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(0, 44),
      ),
      child: Text(label),
    );
  }
}
