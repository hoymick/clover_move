import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';
import 'leaf.dart';

/// The staggered leaf field behind the onboarding screens. Read off the pack:
/// leaves sit on an 82 x 104 grid, every other row shifted half a step, drawn
/// in brand green at a few percent so it reads as texture rather than pattern.
class LeafWatermark extends StatelessWidget {
  const LeafWatermark({
    super.key,
    this.opacity = 0.045,
    this.colour = CloverColors.green,
  });

  final double opacity;
  final Color colour;

  /// Grid metrics from the source drawing.
  static const _stepX = 82.0;
  static const _stepY = 104.0;
  static const _leafWidth = 37.7;
  static const _originX = -40.0;
  static const _originY = -40.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final rows =
                ((constraints.maxHeight - _originY) / _stepY).ceil() + 1;
            final columns =
                ((constraints.maxWidth - _originX) / _stepX).ceil() + 1;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                for (var row = 0; row < rows; row++)
                  for (var column = 0; column < columns; column++)
                    Positioned(
                      // Odd rows are offset half a step, giving the brick lay.
                      left:
                          _originX +
                          column * _stepX +
                          (row.isOdd ? _stepX / 2 : 0),
                      top: _originY + row * _stepY,
                      child: LeafMark(size: _leafWidth, color: colour),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// One of the oversized brand discs that bleed off the corners of the welcome
/// screen. They are tinted, not solid — 6% in the pack.
class BrandDisc extends StatelessWidget {
  const BrandDisc({
    super.key,
    required this.radius,
    required this.colour,
    this.opacity = 0.06,
  });

  final double radius;
  final Color colour;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: colour.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
