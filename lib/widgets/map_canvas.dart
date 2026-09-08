import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../models/leaf_category.dart';
import 'category_leaf.dart';

/// The stylised map ground: pale green parkland, grey building blocks and a
/// road grid. Deterministic, so the layout never shifts between builds.
class MapCanvas extends StatelessWidget {
  const MapCanvas({super.key, this.markers = const []});

  /// Marker positions given as fractions of the canvas, with a colour each.
  final List<MapMarker> markers;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: const _MapPainter())),
            for (final marker in markers)
              Positioned(
                left: marker.x * size.width - 28,
                top: marker.y * size.height - 52,
                child: _Marker(marker: marker),
              ),
          ],
        );
      },
    );
  }
}

/// A pin on the map. [isUser] draws the blue "you are here" dot instead of a
/// leaf marker.
class MapMarker {
  const MapMarker({
    required this.x,
    required this.y,
    this.category = LeafCategory.green,
    this.isUser = false,
  });

  final double x;
  final double y;

  /// Which leaf the pin carries — the pack uses the category mark as the pin.
  final LeafCategory category;
  final bool isUser;
}

class _Marker extends StatelessWidget {
  const _Marker({required this.marker});

  final MapMarker marker;

  @override
  Widget build(BuildContext context) {
    if (marker.isUser) {
      return SizedBox(
        width: 48,
        height: 52,
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CloverColors.info.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: CloverColors.info,
                shape: BoxShape.circle,
                border: Border.all(color: CloverColors.white, width: 2.5),
              ),
            ),
          ),
        ),
      );
    }

    // The pin *is* the leaf: full size, in the category's colour, with a soft
    // ellipse on the ground beneath it.
    return SizedBox(
      width: 56,
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CategoryLeaf(category: marker.category, size: 52),
          const SizedBox(height: 2),
          Container(
            width: 22,
            height: 6,
            decoration: BoxDecoration(
              color: CloverColors.ink.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  // Fractional rects for parkland, buildings and roads, read off screen 05.
  static const _parkland = [
    (0.05, 0.02, 0.30, 0.19),
    (0.62, 0.00, 0.30, 0.15),
    (0.10, 0.62, 0.30, 0.17),
    (0.50, 0.72, 0.14, 0.09),
  ];
  static const _blocks = [
    (0.24, 0.24, 0.13, 0.09),
    (0.48, 0.27, 0.15, 0.07),
    (0.06, 0.32, 0.10, 0.06),
    (0.72, 0.44, 0.13, 0.09),
    (0.22, 0.46, 0.16, 0.07),
    (0.50, 0.62, 0.14, 0.08),
    (0.78, 0.20, 0.14, 0.06),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFF4F1),
    );

    Rect frac(double x, double y, double w, double h) => Rect.fromLTWH(
      x * size.width,
      y * size.height,
      w * size.width,
      h * size.height,
    );

    final park = Paint()..color = const Color(0xFFD6E9DA);
    for (final (x, y, w, h) in _parkland) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(frac(x, y, w, h), const Radius.circular(12)),
        park,
      );
    }

    // Road grid, drawn under the buildings so junctions look tucked in.
    final road = Paint()
      ..color = CloverColors.white
      ..strokeWidth = math.max(size.width * 0.022, 5)
      ..strokeCap = StrokeCap.round;
    for (final y in [0.22, 0.43, 0.58, 0.86]) {
      canvas.drawLine(
        Offset(0, y * size.height),
        Offset(size.width, y * size.height),
        road,
      );
    }
    for (final x in [0.18, 0.45, 0.68, 0.9]) {
      canvas.drawLine(
        Offset(x * size.width, 0),
        Offset(x * size.width, size.height),
        road,
      );
    }

    final block = Paint()..color = const Color(0xFFDFE6E2);
    for (final (x, y, w, h) in _blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(frac(x, y, w, h), const Radius.circular(6)),
        block,
      );
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => false;
}
