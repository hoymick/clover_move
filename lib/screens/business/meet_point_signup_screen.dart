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
import '../../widgets/segmented_tabs.dart';
import '../../widgets/ireland_location_picker.dart';

/// 25 Meet Point Sign-up — free registration for any suitable location. Access
/// is asked first, since public and private points are held to different checks.
class MeetPointSignupScreen extends StatefulWidget {
  const MeetPointSignupScreen({super.key});

  @override
  State<MeetPointSignupScreen> createState() => _MeetPointSignupScreenState();
}

class _MeetPointSignupScreenState extends State<MeetPointSignupScreen> {
  static const _types = [
    'Park',
    'Beach',
    'Forest',
    'Mountain',
    'Castle',
    'Square',
  ];

  int _access = 0;
  int _type = 0;
  bool _stepFree = true;
  bool _lit = true;
  bool _parking = false;

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
                title: 'Register a Meet Point',
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
                16,
                Insets.gutter,
                24,
              ),
              children: [
                const Callout(
                  title: 'Any suitable location may apply',
                  body: 'Approved points appear on the map',
                  icon: PackIcons.pin,
                ),
                const Gap(24),
                const FieldLabel('Access'),
                SegmentedTabs(
                  labels: const ['Public', 'Private'],
                  selected: _access,
                  onChanged: (value) => setState(() => _access = value),
                ),
                const Gap(22),
                const FieldLabel('Type'),
                ChipWrap(
                  labels: _types,
                  selectedIndex: _type,
                  onChanged: (value) => setState(() => _type = value),
                ),
                const Gap(22),
                const FieldLabel(
                  'County & city',
                  trailing: 'Republic of Ireland',
                ),
                const IrelandLocationField(
                  initialCounty: 'Dublin',
                  initialTown: 'Howth',
                ),
                const Gap(20),
                const FieldLabel('Meet point name'),
                const SelectField(
                  value: 'Howth DART Station',
                  icon: PackIcons.pin,
                  trailingIcon: null,
                ),
                const Gap(20),
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Eircode'),
                          SelectField(value: 'D13 A2X6', trailingIcon: null),
                        ],
                      ),
                    ),
                    SizedBox(width: 26),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Capacity'),
                          SelectField(value: '60', trailingIcon: null),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                const FieldLabel('Safety & access'),
                SwitchRow(
                  title: 'Step-free access',
                  meta: 'No steps or steep ground',
                  value: _stepFree,
                  onChanged: (value) => setState(() => _stepFree = value),
                ),
                const Gap(8),
                SwitchRow(
                  title: 'Lit after dark',
                  meta: 'Street or platform lighting',
                  value: _lit,
                  onChanged: (value) => setState(() => _lit = value),
                ),
                const Gap(8),
                SwitchRow(
                  title: 'Parking nearby',
                  meta: 'On-street or a car park',
                  value: _parking,
                  onChanged: (value) => setState(() => _parking = value),
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Submit for approval',
              onPressed: () => context.push('/meet-point'),
            ),
          ),
        ],
      ),
    );
  }
}
