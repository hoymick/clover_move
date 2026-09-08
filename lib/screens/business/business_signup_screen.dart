import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/media_requirements.dart';
import '../../widgets/ireland_location_picker.dart';

/// 24 Business Sign-up — a free Official Partner listing. The FREE callout leads,
/// because the pack's proposition is that listing costs nothing and only
/// advertising is paid.
class BusinessSignupScreen extends StatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  State<BusinessSignupScreen> createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignupScreen> {
  static const _categories = [
    'Gym',
    'Hotel',
    'Café',
    'Pub',
    'Yoga studio',
    'Bike shop',
    'Club',
  ];

  int _category = 1;

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
                title: 'Register your business',
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
                const StepProgress(step: 1, total: 3),
                const Gap(14),
                const FieldLabel('Step 1 of 3 · Business details'),
                const Gap(10),
                const Callout(
                  title: 'No cost to list your business',
                  body: 'Advertising is optional, on Business+',
                  icon: PackIcons.check,
                ),
                const Gap(24),
                const LabelledInput(
                  label: 'Business name',
                  hint: 'Your business',
                  initialValue: 'Talbot Hotel Stillorgan',
                ),
                const Gap(20),
                const FieldLabel('Category'),
                ChipWrap(
                  labels: _categories,
                  selectedIndex: _category,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const Gap(22),
                const FieldLabel(
                  'County & city',
                  trailing: 'Republic of Ireland',
                ),
                const IrelandLocationField(
                  initialCounty: 'Dublin',
                  initialTown: 'Stillorgan',
                ),
                const Gap(20),
                const FieldLabel('Address'),
                const SelectField(
                  value: 'Stillorgan, Co. Dublin',
                  icon: PackIcons.pin,
                ),
                const Gap(20),
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Eircode'),
                          SelectField(value: 'A94 T2X7', trailingIcon: null),
                        ],
                      ),
                    ),
                    SizedBox(width: 26),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Capacity'),
                          SelectField(value: '120', trailingIcon: null),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(22),
                const FieldLabel('Photos & video'),
                const MediaRequirementsPanel(subject: 'Partner or brand'),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Continue',
              onPressed: () => context.push('/partner-dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
