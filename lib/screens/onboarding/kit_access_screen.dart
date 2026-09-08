import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/leaf.dart';
import '../../widgets/scaffolds.dart';

/// Entry for people who already own a Smart Jersey Kit.
///
/// Code validation is represented locally in the prototype. Production must
/// verify the code against the kit registry before issuing a session.
class KitAccessScreen extends StatefulWidget {
  const KitAccessScreen({super.key});

  @override
  State<KitAccessScreen> createState() => _KitAccessScreenState();
}

class _KitAccessScreenState extends State<KitAccessScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final code = _controller.text.trim().replaceAll('-', '');
    if (code.length < 8) {
      setState(
        () => _error = 'Enter the code supplied with your Smart Jersey Kit.',
      );
      return;
    }
    setState(() => _error = null);
    context.go('/smart-jerseys');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Smart Jersey access'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Insets.gutter,
                  28,
                  Insets.gutter,
                  24,
                ),
                children: [
                  const Center(child: CloverLogo(size: 118)),
                  const Gap(28),
                  Text(
                    'Already have a Smart Jersey Kit?',
                    style: AppText.title.copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                  Text(
                    'Enter the unique code from your kit to access Smart Jerseys without creating a new account.',
                    style: AppText.body.copyWith(fontSize: 13.5),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(28),
                  TextFormField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Smart Jersey Kit code',
                      hintText: 'CM-XXXX-XXXX',
                      errorText: _error,
                      prefixIcon: const Icon(Icons.qr_code_rounded),
                    ),
                    onFieldSubmitted: (_) => _verify(),
                  ),
                  const Gap(16),
                  const Callout(
                    title: 'Your code is private',
                    body:
                        'Each active kit code can be linked to one owner and checked by the Smart Jersey registry.',
                    icon: PackIcons.shieldCheck,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                8,
                Insets.gutter,
                Insets.gutter,
              ),
              child: Column(
                children: [
                  PrimaryButton(label: 'Verify kit code', onPressed: _verify),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: 'I don’t have a code · Create account',
                    onPressed: () => context.go('/language'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
