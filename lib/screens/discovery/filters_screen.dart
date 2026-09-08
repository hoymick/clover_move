import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/leaf_category.dart';
import '../../models/ireland_locations.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/chips.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/ireland_location_picker.dart';

/// 06 Search Filters — every county in Ireland, plus date, time, distance,
/// colour, price and setting. The result count on the action updates live.
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _prices = ['Any', 'Free', 'Paid'];
  static const _settings = ['Any', 'Indoor', 'Outdoor'];

  int _county = -1;
  int _price = 1;
  int _setting = 2;
  double _distance = 15;
  bool _officialOnly = false;

  void _reset() => setState(() {
    _county = -1;
    _price = 0;
    _setting = 0;
    _distance = 15;
    _officialOnly = false;
  });

  @override
  Widget build(BuildContext context) {
    final category = context.watch<AppState>().activeCategory;

    return Scaffold(
      backgroundColor: CloverColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TitleHeader(title: 'Filters', action: 'Reset', onAction: _reset),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Insets.gutter,
                  14,
                  Insets.gutter,
                  24,
                ),
                children: [
                  const FieldLabel('County', trailing: 'All 26 counties'),
                  const IrelandLocationField(
                    initialCounty: '',
                    initialTown: '',
                    allowAll: true,
                  ),
                  const Gap(12),
                  ChipWrap(
                    labels: IrelandLocations.counties,
                    selectedIndex: _county,
                    height: 36,
                    fontSize: 12.5,
                    onChanged: (value) => setState(() => _county = value),
                  ),
                  const Gap(22),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldLabel('Date'),
                            SelectField(value: '15 Aug 2026', height: 56),
                          ],
                        ),
                      ),
                      const SizedBox(width: 26),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldLabel('Time'),
                            SelectField(value: 'Morning', height: 56),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(22),
                  FieldLabel(
                    'Distance',
                    trailing: 'up to ${_distance.round()} km',
                    trailingColour: CloverColors.green,
                  ),
                  CloverSlider(
                    value: _distance,
                    max: 50,
                    onChanged: (value) => setState(() => _distance = value),
                  ),
                  const Gap(14),
                  const FieldLabel('Colour'),
                  Row(
                    children: [
                      for (final leaf in LeafCategory.values) ...[
                        if (leaf != LeafCategory.values.first)
                          const SizedBox(width: 8),
                        Expanded(
                          child: _ColourOption(
                            category: leaf,
                            selected: leaf == category,
                            onTap: () =>
                                context.read<AppState>().setCategory(leaf),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(22),
                  const FieldLabel('Price'),
                  ChipWrap(
                    labels: _prices,
                    selectedIndex: _price,
                    onChanged: (value) => setState(() => _price = value),
                  ),
                  const Gap(22),
                  const FieldLabel('Setting'),
                  ChipWrap(
                    labels: _settings,
                    selectedIndex: _setting,
                    onChanged: (value) => setState(() => _setting = value),
                  ),
                  const Gap(24),
                  SwitchRow(
                    title: 'Official Events only',
                    meta: 'Hide member-created routes',
                    value: _officialOnly,
                    onChanged: (value) => setState(() => _officialOnly = value),
                  ),
                ],
              ),
            ),
            StickyBar(
              child: PrimaryButton(
                label: 'Show ${_officialOnly ? 46 : 128} results',
                onPressed: () => context.push('/search-results'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 60-high colour swatch button — leaf and label, filled when selected.
class _ColourOption extends StatelessWidget {
  const _ColourOption({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final LeafCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = selected && category != LeafCategory.white;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: filled
          ? BorderSide.none
          : BorderSide(
              color: selected ? CloverColors.ink : CloverColors.border,
              width: selected ? 1.5 : 1,
            ),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: filled ? category.colour : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryLeaf(
                  category: category,
                  size: 26,
                  onColour: filled ? CloverColors.white : null,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    category.label,
                    style: AppText.pill.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: filled ? CloverColors.white : CloverColors.inkSoft,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
