import 'package:flutter/widgets.dart';
import 'package:path_parsing/path_parsing.dart';

import '../theme/pack_icons.dart';
import '../theme/tokens.dart';

/// Draws one of the pack's icons at any size.
///
/// The pack authors icons on a 24 x 24 grid and strokes them at a constant
/// weight — roughly 1.9px whether the icon is drawn at 14 or 28. So the path is
/// scaled first and stroked afterwards, rather than letting the stroke scale
/// with the shape the way an SVG asset would.
class PackIcon extends StatelessWidget {
  const PackIcon(
    this.data, {
    super.key,
    this.size = 20,
    this.color = CloverColors.ink,
    this.strokeWidth = 1.9,
    this.filled = false,
  });

  /// Path data from [PackIcons].
  final String data;
  final double size;
  final Color color;
  final double strokeWidth;

  /// The star is the one icon the pack fills as well as strokes.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _PackIconPainter(
          data: data,
          color: color,
          strokeWidth: strokeWidth,
          filled: filled,
        ),
      ),
    );
  }
}

class _PackIconPainter extends CustomPainter {
  const _PackIconPainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.filled,
  });

  final String data;
  final Color color;
  final double strokeWidth;
  final bool filled;

  /// The grid the pack draws its icons on.
  static const _grid = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _parse(data).transform(
      (Matrix4.identity()
            ..scaleByDouble(size.width / _grid, size.height / _grid, 1, 1))
          .storage,
    );

    if (filled) {
      canvas.drawPath(path, Paint()..color = color);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PackIconPainter old) =>
      old.data != data ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.filled != filled;
}

/// Parsed paths are reused — the same handful of icons is drawn on every screen.
final _cache = <String, Path>{};

Path _parse(String data) => _cache.putIfAbsent(data, () {
  final builder = _PathBuilder();
  writeSvgPathDataToPath(data, builder);
  return builder.path;
});

class _PathBuilder extends PathProxy {
  final Path path = Path();

  @override
  void moveTo(double x, double y) => path.moveTo(x, y);

  @override
  void lineTo(double x, double y) => path.lineTo(x, y);

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) => path.cubicTo(x1, y1, x2, y2, x3, y3);

  @override
  void close() => path.close();
}
