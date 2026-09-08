import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/ireland_location_picker.dart';

/// 12 Registration — participant details. The copy at the top states why each
/// field is asked for, and the community options default to what is safest.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _publicProfile = true;
  bool _photo = false;
  bool _invitations = true;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(title: 'Your details'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                8,
                Insets.gutter,
                24,
              ),
              children: [
                Text(
                  'We only ask for what hosts need to run a safe activity.',
                  style: AppText.caption.copyWith(fontSize: 12.5),
                ),
                const Gap(22),
                const LabelledInput(
                  label: 'Full name',
                  hint: 'Your name',
                  initialValue: 'Andrea Ní Bhriain',
                ),
                const Gap(18),
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Gender'),
                          SelectField(value: 'Female'),
                        ],
                      ),
                    ),
                    SizedBox(width: 26),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel('Age'),
                          SelectField(value: '31'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Text(
                  'Female · Male · Non-binary · LGBTQIA+ · Prefer not to say',
                  style: AppText.caption.copyWith(fontSize: 10.5),
                ),
                const Gap(18),
                const FieldLabel(
                  'County & city',
                  trailing: 'Republic of Ireland',
                ),
                const IrelandLocationField(
                  initialCounty: 'Dublin',
                  initialTown: 'Stillorgan',
                ),
                const Gap(18),
                const LabelledInput(
                  label: 'Phone number',
                  hint: '+353',
                  initialValue: '+353 87 000 0000',
                  keyboardType: TextInputType.phone,
                ),
                const Gap(18),
                const LabelledInput(
                  label: 'Email address',
                  hint: 'you@example.ie',
                  initialValue: 'andrea@example.ie',
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(28),
                Text(
                  'Community options',
                  style: AppText.section.copyWith(fontSize: 15.5),
                ),
                const Gap(14),
                SwitchRow(
                  title: 'Create a public profile',
                  meta: 'Others in your colour can find you',
                  value: _publicProfile,
                  onChanged: (value) => setState(() => _publicProfile = value),
                ),
                const Gap(8),
                SwitchRow(
                  title: 'Upload a profile photo',
                  meta: 'Optional',
                  value: _photo,
                  onChanged: (value) => setState(() => _photo = value),
                ),
                const Gap(8),
                SwitchRow(
                  title: 'Receive invitations',
                  meta: 'From hosts and nearby members',
                  value: _invitations,
                  onChanged: (value) => setState(() => _invitations = value),
                ),
                const Gap(8),
                SwitchRow(
                  title: 'Be visible to other users',
                  meta: 'Shown in Community lists',
                  value: _visible,
                  onChanged: (value) => setState(() => _visible = value),
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Continue to payment',
              onPressed: () => context.push('/payment'),
            ),
          ),
        ],
      ),
    );
  }
}
