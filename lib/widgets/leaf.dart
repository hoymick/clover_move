import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';

/// The leaf pictogram — the client's own vector. One form throughout: the
/// heart, tip down, pictogram upright, matching the map marker.
class LeafMark extends StatelessWidget {
  const LeafMark({super.key, this.size = 24, this.color = CloverColors.green});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/leaf.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

/// The full-colour Clover Move logo.
class CloverLogo extends StatelessWidget {
  const CloverLogo({super.key, this.size = 84});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/svg/logo.svg', width: size, height: size);
  }
}
