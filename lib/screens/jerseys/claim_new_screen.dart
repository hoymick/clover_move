import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_leaf.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/jersey_row.dart';
import '../../widgets/scaffolds.dart';

/// 11e Claim — New. The recipient joins to claim. Free and quick are both stated
/// up front, since a stranger is being asked to sign up.
class ClaimNewScreen extends StatefulWidget {
  const ClaimNewScreen({super.key});

  @override
  State<ClaimNewScreen> createState() => _ClaimNewScreenState();
}

class _ClaimNewScreenState extends State<ClaimNewScreen> {
  bool _accepted = false;

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
              child: BackHeader(title: 'Claim a jersey'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                26,
                Insets.gutter,
                24,
              ),
              children: [
                const Center(
                  child: CategoryLeaf(category: LeafCategory.white, size: 84),
                ),
                const Gap(28),
                Center(
                  child: Text(
                    "You've received a",
                    style: AppText.body.copyWith(fontSize: 15),
                  ),
                ),
                const Gap(10),
                Center(
                  child: Text(
                    'Smart Jersey',
                    style: AppText.title.copyWith(fontSize: 27),
                  ),
                ),
                const Gap(26),
                const JerseyRow(
                  category: LeafCategory.white,
                  meta: 'Long sleeve · shared by Andrea',
                ),
                const Gap(22),
                Text(
                  'Create a free Clover Move account to claim it. It takes under '
                  'a minute and no payment is needed.',
                  style: AppText.bodyStrong.copyWith(
                    fontSize: 13.5,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(26),
                const LabelledInput(label: 'Full name', hint: 'Your name'),
                const Gap(18),
                const LabelledInput(
                  label: 'Email address',
                  hint: 'you@example.ie',
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(22),
                _AcceptRow(
                  value: _accepted,
                  onChanged: (value) => setState(() => _accepted = value),
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Create account & claim',
              onPressed: _accepted
                  ? () => context.push('/smart-jerseys')
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Terms tick. Claiming can't proceed until it is checked.
class _AcceptRow extends StatelessWidget {
  const _AcceptRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value ? CloverColors.green : CloverColors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? CloverColors.green : CloverColors.borderStrong,
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: CloverColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'I accept the Terms of Use and Privacy Policy.',
                style: AppText.bodyStrong.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
