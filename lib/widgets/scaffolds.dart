import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'leaf.dart';
import 'pack_icon.dart';

/// White panel pinned to the bottom of a screen holding the primary action.
/// The hairline on top separates it from the scrolling content behind.
class StickyBar extends StatelessWidget {
  const StickyBar({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CloverColors.white,
        border: Border(top: BorderSide(color: CloverColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.fromLTRB(Insets.gutter, 14, Insets.gutter, 14),
          child: child,
        ),
      ),
    );
  }
}

/// Vertical gap. Reads more clearly than a bare SizedBox in long screen bodies.
class Gap extends StatelessWidget {
  const Gap(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// Centred illustration, headline and supporting copy — the shape shared by the
/// empty, offline, declined and cancelled screens.
class MessagePanel extends StatelessWidget {
  const MessagePanel({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.tint = CloverColors.greenTint,
    this.iconColour = CloverColors.green,
    this.leaf = false,
  });

  final String title;
  final String body;
  final String? icon;
  final Color tint;
  final Color iconColour;
  final bool leaf;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(26),
          ),
          child: leaf
              ? LeafMark(size: 40, color: iconColour)
              : PackIcon(icon!, size: 38, color: iconColour),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: AppText.title.copyWith(fontSize: 23),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(body, style: AppText.body, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

/// Key-value line used by every totals block — bag, payment, refund.
class TotalRow extends StatelessWidget {
  const TotalRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasis = false,
    this.valueColour,
  });

  final String label;
  final String value;
  final bool emphasis;
  final Color? valueColour;

  @override
  Widget build(BuildContext context) {
    final labelStyle = emphasis
        ? AppText.cardTitle.copyWith(fontSize: 15)
        : AppText.caption.copyWith(fontSize: 13);
    final valueStyle = emphasis
        ? AppText.headline.copyWith(
            fontSize: 18,
            color: valueColour ?? CloverColors.green,
          )
        : AppText.cardTitle.copyWith(
            fontSize: 13,
            color: valueColour ?? CloverColors.ink,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

/// Numbered step indicator — "step 2 of 4" on the host flow.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= total; i++) ...[
          if (i > 1) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: i <= step ? CloverColors.green : CloverColors.divider,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
