import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/leaf_category.dart';
import '../theme/tokens.dart';

/// The mark that stands for a colour: one upright leaf carrying the activity
/// pictogram for that category.
///
/// Green and Orange fill the leaf and set the pictogram in white. White keeps an
/// outlined leaf with a green pictogram, so it stays legible on a white card —
/// that is why the shape has both a filled and a stroked asset.
class CategoryLeaf extends StatelessWidget {
  const CategoryLeaf({
    super.key,
    required this.category,
    this.size = 74,
    this.onColour,
  });

  final LeafCategory category;

  /// Width of the leaf. Height follows the artwork's 1.2 : 1 ratio.
  final double size;

  /// Set when the mark sits on a filled surface and has to invert: the leaf
  /// takes this colour and the pictogram is knocked out in the category's own,
  /// so it stays legible instead of going white-on-white.
  final Color? onColour;

  /// The leaf artwork is wider than it is tall.
  static const _ratio = 1.203;

  bool get _outlined => category == LeafCategory.white;

  @override
  Widget build(BuildContext context) {
    final inverted = onColour != null;
    final leafColour = onColour ?? category.markColour;
    final pictogramColour = inverted
        ? (category == LeafCategory.white
              ? CloverColors.green
              : category.colour)
        : (_outlined ? CloverColors.green : CloverColors.white);

    return SizedBox(
      width: size,
      height: size / _ratio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            _outlined && !inverted
                ? 'assets/svg/leaf_shape_outline.svg'
                : 'assets/svg/leaf_shape.svg',
            width: size,
            colorFilter: ColorFilter.mode(leafColour, BlendMode.srcIn),
          ),
          // The pictogram sits a little above the leaf's centre, as the tip
          // takes up the lower third.
          Align(
            alignment: const Alignment(0, -0.18),
            child: SvgPicture.asset(
              'assets/svg/pictogram_${category.pictogram}.svg',
              height: size * 0.30,
              colorFilter: ColorFilter.mode(pictogramColour, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}
