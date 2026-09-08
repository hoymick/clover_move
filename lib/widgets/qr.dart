import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A QR-shaped block: three finder patterns and a deterministic module field.
/// It is a graphic stand-in, not a scannable code — the real ticket code is
/// printed underneath so nothing depends on this being decodable.
class QrBlock extends StatelessWidget {
  const QrBlock({
    super.key,
    this.size = 214,
    this.seed = 88410273,
    this.modules = 25,
  });

  final double size;
  final int seed;
  final int modules;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _QrPainter(seed: seed, modules: modules),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter({required this.seed, required this.modules});

  final int seed;
  final int modules;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / modules;
    final ink = Paint()..color = CloverColors.ink;
    final paper = Paint()..color = CloverColors.white;

    bool inFinder(int x, int y) {
      const span = 7;
      final atLeft = x < span;
      final atRight = x >= modules - span;
      final atTop = y < span;
      final atBottom = y >= modules - span;
      return (atLeft && atTop) || (atRight && atTop) || (atLeft && atBottom);
    }

    // Data modules from a small linear congruential generator, so the pattern
    // is identical on every build.
    var state = seed;
    int next() => state = (state * 1103515245 + 12345) & 0x7FFFFFFF;

    for (var y = 0; y < modules; y++) {
      for (var x = 0; x < modules; x++) {
        if (inFinder(x, y)) continue;
        if (next() % 100 < 46) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x * unit, y * unit, unit * 0.92, unit * 0.92),
              Radius.circular(unit * 0.22),
            ),
            ink,
          );
        }
      }
    }

    // Finder patterns: 7x7 ink square, 5x5 paper, 3x3 ink.
    for (final (cx, cy) in [(0, 0), (modules - 7, 0), (0, modules - 7)]) {
      void square(int inset, Paint paint, double radius) {
        final side = (7 - inset * 2) * unit;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH((cx + inset) * unit, (cy + inset) * unit, side, side),
            Radius.circular(radius),
          ),
          paint,
        );
      }

      square(0, ink, unit * 0.28);
      square(1, paper, unit * 0.2);
      square(2, ink, unit * 0.14);
    }
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.modules != modules;
}

/// A ticket-shaped card with a perforation across it. The notches are painted
/// in [notchColour] so they read as holes punched through to the background.
class PerforatedCard extends StatelessWidget {
  const PerforatedCard({
    super.key,
    required this.top,
    required this.bottom,
    required this.notchColour,
    this.radius = 26,
  });

  final Widget top;
  final Widget bottom;
  final Color notchColour;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: CloverColors.white,
        child: Column(
          children: [
            top,
            Stack(
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: _DashedLine(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Notch(
                      colour: notchColour,
                      alignment: Alignment.centerRight,
                    ),
                    _Notch(
                      colour: notchColour,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ],
            ),
            bottom,
          ],
        ),
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch({required this.colour, required this.alignment});

  final Color colour;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 13,
      height: 26,
      child: OverflowBox(
        maxWidth: 26,
        maxHeight: 26,
        alignment: alignment,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 6.0;
        const gap = 5.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < count; i++)
              Container(width: dash, height: 1.5, color: CloverColors.border),
          ],
        );
      },
    );
  }
}
