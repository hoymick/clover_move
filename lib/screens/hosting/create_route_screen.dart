import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/media_requirements.dart';
import '../../widgets/ireland_location_picker.dart';

/// 09 Create Route — host flow, step 2 of 4. The accent follows the category
/// the host picks, and the platform fee is stated separately from their price.
class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  static const _genders = ['Mixed', 'Women', 'Men', 'LGBTQIA+'];
  static const _paymentOptions = [
    'Free',
    'Pay on Site',
    'Arrange Payment with Host',
    'Confirm Payment with Host',
    'External Payment Link',
  ];

  LeafCategory _category = LeafCategory.orange;
  int _gender = 1;
  int _price = 1;
  int _maxParticipants = 8;
  RangeValues _ages = const RangeValues(25, 40);
  final _selectedPaymentOptions = <String>{'Pay on Site'};
  final _priceController = TextEditingController(text: '10.00');

  Color get _accent =>
      _category == LeafCategory.white ? CloverColors.inkSoft : _category.colour;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Create Route',
                action: HeaderIconAction(
                  icon: PackIcons.close,
                  bare: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                14,
                Insets.gutter,
                24,
              ),
              children: [
                const StepProgress(step: 2, total: 4),
                const Gap(14),
                Text(
                  'Step 2 of 4 · Details & limits',
                  style: AppText.caption.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(20),
                const LabelledInput(
                  label: 'Route title',
                  hint: 'Name your route',
                  initialValue: 'Morning Route',
                ),
                const Gap(20),
                const FieldLabel('Category'),
                Row(
                  children: [
                    for (final leaf in LeafCategory.values) ...[
                      if (leaf != LeafCategory.values.first)
                        const SizedBox(width: 10),
                      Expanded(
                        child: _CategoryOption(
                          category: leaf,
                          selected: leaf == _category,
                          onTap: () => setState(() => _category = leaf),
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(20),
                const FieldLabel('Location', trailing: 'Republic of Ireland'),
                const IrelandLocationField(
                  initialCounty: 'Dublin',
                  initialTown: 'Stillorgan',
                ),
                const Gap(12),
                const FieldLabel('Meet point'),
                const SelectField(
                  value: 'Talbot Hotel Stillorgan',
                  icon: PackIcons.pin,
                  height: 44,
                ),
                const Gap(20),
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Start'),
                          SelectField(
                            value: '07:00',
                            icon: PackIcons.clock,
                            height: 44,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 26),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Finish'),
                          SelectField(
                            value: '09:00',
                            icon: PackIcons.clock,
                            height: 44,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const FieldLabel('Max participants'),
                _Stepper(
                  value: _maxParticipants,
                  accent: _accent,
                  onChanged: (value) =>
                      setState(() => _maxParticipants = value),
                ),
                const Gap(20),
                const FieldLabel('Gender'),
                ChipWrap(
                  labels: _genders,
                  selectedIndex: _gender,
                  height: 32,
                  fontSize: 11.5,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const Gap(20),
                FieldLabel(
                  'Age range',
                  trailing:
                      '${_ages.start.round()} – ${_ages.end.round()} years',
                  trailingColour: _accent,
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 6,
                    activeTrackColor: _accent,
                    inactiveTrackColor: CloverColors.divider,
                    thumbColor: CloverColors.white,
                    overlayColor: _accent.withValues(alpha: 0.1),
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 11,
                      elevation: 2,
                    ),
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: RangeSlider(
                    values: _ages,
                    min: 16,
                    max: 80,
                    onChanged: (value) => setState(() => _ages = value),
                  ),
                ),
                const Gap(12),
                const FieldLabel('Event price'),
                Row(
                  children: [
                    _PriceToggle(
                      label: 'Free',
                      selected: _price == 0,
                      accent: _accent,
                      onTap: () => setState(() => _price = 0),
                    ),
                    const SizedBox(width: 8),
                    _PriceToggle(
                      label: 'Paid',
                      selected: _price == 1,
                      accent: _accent,
                      onTap: () => setState(() => _price = 1),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PriceField(
                        accent: _accent,
                        enabled: _price == 1,
                        controller: _priceController,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  _price == 0
                      ? 'Free events are shown to participants as €0.'
                      : 'You set this price. Participants can view it but cannot edit it.',
                  style: AppText.caption.copyWith(fontSize: 11),
                ),
                const Gap(24),
                const FieldLabel(
                  'Payment method',
                  trailing: 'Choose one or more',
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in _paymentOptions)
                      CloverChip(
                        label: option,
                        selected: _selectedPaymentOptions.contains(option),
                        onTap: () => setState(() {
                          if (!_selectedPaymentOptions.remove(option)) {
                            _selectedPaymentOptions.add(option);
                          }
                        }),
                      ),
                  ],
                ),
                if (_selectedPaymentOptions.contains(
                  'External Payment Link',
                )) ...[
                  const Gap(16),
                  const LabelledInput(
                    label: 'External payment link',
                    hint: 'https://payment.example.com',
                    initialValue: 'https://',
                  ),
                ],
                const Gap(24),
                const FieldLabel('Route or event media'),
                const MediaRequirementsPanel(subject: 'Route or event'),
                const Gap(24),
                const Callout(
                  title: 'Host payments stay separate',
                  body:
                      'Clover Move does not receive the payment, set your price or process the transaction. The host collects payment directly; Clover Move only provides payment-status and reporting tools.',
                  icon: PackIcons.shieldCheck,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Continue',
              color: _accent,
              onPressed: () => context.push('/route-categories'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final LeafCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWhite = category == LeafCategory.white;
    final fill = category.fill;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: selected
          ? BorderSide(
              color: isWhite ? CloverColors.inkSoft : fill,
              width: isWhite ? 1.8 : 0,
            )
          : const BorderSide(color: CloverColors.border),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? fill : CloverColors.white,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                category.label,
                style: AppText.pill.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: selected && !isWhite
                      ? CloverColors.white
                      : CloverColors.inkSoft,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minus / value / plus row for the participant cap.
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  final int value;
  final Color accent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return CloverField(
      height: 46,
      radius: 13,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Round(
            // The pack draws the decrement as a plain bar, not a glyph.
            icon: null,
            colour: CloverColors.divider,
            iconColour: CloverColors.inkSoft,
            onTap: value > 1 ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Center(
              child: Text(
                '$value',
                style: AppText.subtitle.copyWith(fontSize: 17),
              ),
            ),
          ),
          _Round(
            icon: PackIcons.plus,
            colour: accent,
            iconColour: CloverColors.white,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({
    this.icon,
    required this.colour,
    required this.iconColour,
    this.onTap,
  });

  final String? icon;
  final Color colour;
  final Color iconColour;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null ? CloverColors.divider : colour,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(
            child: icon == null
                // The pack draws the decrement as a plain bar, not a glyph.
                ? Container(
                    width: 11,
                    height: 1.9,
                    decoration: BoxDecoration(
                      color: onTap == null ? CloverColors.hint : iconColour,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )
                : PackIcon(
                    icon!,
                    size: 15,
                    color: onTap == null ? CloverColors.hint : iconColour,
                  ),
          ),
        ),
      ),
    );
  }
}

class _PriceToggle extends StatelessWidget {
  const _PriceToggle({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: selected
          ? BorderSide.none
          : const BorderSide(color: CloverColors.border),
    );

    return Material(
      color: selected ? accent : CloverColors.white,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Container(
          width: 76,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppText.pill.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected ? CloverColors.white : CloverColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.accent,
    required this.enabled,
    required this.controller,
  });

  final Color accent;
  final bool enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? accent : CloverColors.border),
      ),
      child: Row(
        children: [
          Text(
            '€',
            style: AppText.cardTitle.copyWith(
              fontSize: 13.5,
              color: CloverColors.muted,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: enabled
                ? TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    style: AppText.cardTitle.copyWith(fontSize: 15),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Text(
                    '0.00',
                    textAlign: TextAlign.right,
                    style: AppText.cardTitle.copyWith(
                      fontSize: 15,
                      color: CloverColors.muted,
                    ),
                  ),
          ),
          Text(
            'per person',
            style: AppText.badge.copyWith(
              fontSize: 10,
              color: CloverColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
