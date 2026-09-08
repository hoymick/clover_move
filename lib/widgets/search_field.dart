import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../theme/pack_icons.dart';
import '../widgets/pack_icon.dart';

/// 44-high search field with a 13 radius, as used on Discovery and Search.
class CloverSearchField extends StatelessWidget {
  const CloverSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Insets.fieldHeight,
      child: TextField(
        controller: controller,
        onTap: onTap,
        readOnly: readOnly,
        onChanged: onChanged,
        style: AppText.pill.copyWith(
          fontWeight: FontWeight.w500,
          color: CloverColors.ink,
        ),
        cursorColor: CloverColors.green,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppText.pill.copyWith(
            fontWeight: FontWeight.w500,
            color: CloverColors.hint,
          ),
          filled: true,
          fillColor: CloverColors.white,
          isDense: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 14, right: 10),
            child: PackIcon(
              PackIcons.search,
              size: 18,
              color: CloverColors.hint,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: _border(CloverColors.border),
          focusedBorder: _border(CloverColors.green),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Radii.field),
    borderSide: BorderSide(color: color),
  );
}
