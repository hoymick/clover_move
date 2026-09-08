import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';
import 'leaf.dart';

/// Where the concentric ring motif sits inside a thumbnail. The design pack
/// varies it per card so a grid of thumbs doesn't read as repeated wallpaper.
enum ThumbMotif { rings, dot, hills, stripes, none }

/// The photographic stand-in used for routes, events and venues: a diagonal
/// wash of the category colour with a white ring motif bleeding off one corner.
class CloverThumb extends StatelessWidget {
  const CloverThumb({
    super.key,
    this.category = LeafCategory.green,
    this.radius = 14,
    this.motif = ThumbMotif.rings,
    this.badge,
    this.leafSize,
    this.width,
    this.height,
  });

  final LeafCategory category;
  final double radius;
  final ThumbMotif motif;

  /// Small pill drawn over the top-left corner, e.g. "OFFICIAL".
  final Widget? badge;
  final double? leafSize;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final base = category == LeafCategory.white
        ? CloverColors.inkSoft
        : category.colour;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: const Alignment(0.2, 1),
              colors: [
                base.withValues(alpha: 0.95),
                base.withValues(alpha: 0.55),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (motif != ThumbMotif.none)
                CustomPaint(painter: _MotifPainter(motif: motif)),
              if (leafSize != null)
                Center(
                  child: LeafMark(size: leafSize!, color: CloverColors.white),
                ),
              if (badge case final badge?)
                Positioned(top: 6, left: 6, child: badge),
            ],
          ),
        ),
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  const _MotifPainter({required this.motif});

  final ThumbMotif motif;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = CloverColors.white.withValues(alpha: 0.22)
      ..strokeWidth = 1.4;

    switch (motif) {
      case ThumbMotif.rings:
        // Rings anchored just off the bottom-right corner.
        final centre = Offset(size.width * 0.88, size.height * 0.82);
        final step = math.max(size.width, size.height) * 0.16;
        for (var i = 1; i <= 3; i++) {
          canvas.drawCircle(centre, step * i, paint);
        }
      case ThumbMotif.dot:
        canvas.drawCircle(
          Offset(size.width * 0.72, size.height * 0.28),
          size.width * 0.09,
          Paint()..color = CloverColors.white.withValues(alpha: 0.3),
        );
      case ThumbMotif.hills:
        // Two overlapping peaks along the base, plus a sun off to one side.
        final peaks = Path()
          ..moveTo(size.width * 0.05, size.height)
          ..lineTo(size.width * 0.40, size.height * 0.42)
          ..lineTo(size.width * 0.72, size.height)
          ..close()
          ..moveTo(size.width * 0.48, size.height)
          ..lineTo(size.width * 0.78, size.height * 0.55)
          ..lineTo(size.width * 1.05, size.height)
          ..close();
        canvas.drawPath(
          peaks,
          Paint()..color = CloverColors.white.withValues(alpha: 0.22),
        );
        canvas.drawCircle(
          Offset(size.width * 0.80, size.height * 0.22),
          size.width * 0.055,
          Paint()..color = CloverColors.white.withValues(alpha: 0.38),
        );
      case ThumbMotif.stripes:
        // Slanted bands running corner to corner.
        for (var i = -1; i < 5; i++) {
          final x = size.width * (0.22 * i);
          canvas.drawLine(
            Offset(x, size.height),
            Offset(x + size.width * 0.42, 0),
            paint..strokeWidth = 2.4,
          );
        }
      case ThumbMotif.none:
        break;
    }
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) => oldDelegate.motif != motif;
}

/// Circular member avatar backed by one of the extracted photos, falling back
/// to initials when no image is given.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.image,
    this.initials,
    this.size = 44,
    this.colour = CloverColors.green,
    this.ring = false,
  });

  final String? image;
  final String? initials;
  final double size;
  final Color colour;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colour.withValues(alpha: 0.14),
        border: ring ? Border.all(color: colour, width: 1.5) : null,
      ),
      child: image != null
          ? Image.asset(
              'assets/images/$image',
              fit: BoxFit.cover,
              width: size,
              height: size,
            )
          : Text(
              initials ?? '',
              style: TextStyle(
                fontFamily: 'BalooBhai2',
                fontSize: size * 0.32,
                fontWeight: FontWeight.w700,
                color: colour,
              ),
            ),
    );
  }
}

/// Product / kit photo in a rounded tile, on the store's muted ground.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.image,
    this.radius = 12,
    this.fit = BoxFit.contain,
    this.background = CloverColors.surfaceMuted,
  });

  final String image;
  final double radius;
  final BoxFit fit;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: background,
        child: Image.asset('assets/images/$image', fit: fit),
      ),
    );
  }
}
