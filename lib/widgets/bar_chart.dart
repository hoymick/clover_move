import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Six-month column chart from the partner dashboard. The latest month is drawn
/// in full green with its figure called out; earlier months sit back in tint.
class MonthBarChart extends StatelessWidget {
  const MonthBarChart({
    super.key,
    required this.months,
    required this.values,
    this.height = 120,
    this.calloutLabel,
  });

  final List<String> months;
  final List<double> values;
  final double height;

  /// Figure shown above the final column.
  final String? calloutLabel;

  /// Vertical room reserved above the bars for that figure.
  static const _calloutSpace = 22.0;

  @override
  Widget build(BuildContext context) {
    final peak = values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < values.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (i == values.length - 1 && calloutLabel != null)
                          SizedBox(
                            height: _calloutSpace,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                calloutLabel!,
                                style: AppText.badge.copyWith(
                                  fontSize: 12,
                                  color: CloverColors.ink,
                                ),
                              ),
                            ),
                          ),
                        Container(
                          // Every column leaves room for the callout, so bars
                          // stay on one baseline whether or not one is drawn.
                          height: (values[i] / peak) * (height - _calloutSpace),
                          decoration: BoxDecoration(
                            color: i == values.length - 1
                                ? CloverColors.green
                                : CloverColors.greenTint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < months.length; i++)
              Expanded(
                child: Text(
                  months[i],
                  textAlign: TextAlign.center,
                  style: AppText.badge.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: i == months.length - 1
                        ? CloverColors.inkSoft
                        : CloverColors.hint,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
