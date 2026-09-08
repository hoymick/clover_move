import 'package:flutter/widgets.dart';

/// Country flag used by the language picker.
///
/// These are real national flag glyphs rather than colour-band approximations;
/// that matters especially for Brazil and Portugal, whose flags cannot be
/// represented accurately with a simple gradient.
class FlagChip extends StatelessWidget {
  const FlagChip({
    super.key,
    required this.countryCode,
    this.width = 24,
    this.height = 17,
    this.radius = 3,
  });

  final String countryCode;
  final double width;
  final double height;
  final double radius;

  static const _flags = <String, String>{
    'IE': '🇮🇪',
    'BR': '🇧🇷',
    'PT': '🇵🇹',
    'ES': '🇪🇸',
    'FR': '🇫🇷',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          _flags[countryCode] ?? '🏳️',
          style: const TextStyle(height: 1),
        ),
      ),
    );
  }
}
