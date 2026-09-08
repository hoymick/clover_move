import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/app_language.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/flag_chip.dart';
import '../../widgets/leaf.dart';
import '../../widgets/watermark.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 01 Welcome — the logo in full colour on a white ground textured with the
/// leaf field, two tinted brand discs bleeding off opposite corners, and the
/// language pill top right.
///
/// Measurements come from the pack's 390 x 844 drawing: 28 gutters on the
/// actions, 46 on the body copy, 24 on the pill. The three large vertical gaps
/// are flexible so a taller phone spreads the slack the way the pack does,
/// rather than pooling it at the foot.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.select<AppState, AppLanguage>((s) => s.language);

    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: LeafWatermark()),
          // Green disc, centre (358.8, -40) r 190; orange, centre (-40, 884)
          // r 180. Both tinted, not solid.
          const Positioned(
            top: -230,
            right: -158.8,
            child: BrandDisc(radius: 190, colour: CloverColors.green),
          ),
          const Positioned(
            bottom: -220,
            left: -220,
            child: BrandDisc(radius: 180, colour: CloverColors.orange),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.gutter,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _LanguagePill(
                      label: language.name.split(' ').first,
                      countryCode: language.countryCode,
                      onTap: () => context.push('/language'),
                    ),
                  ),
                ),
                const SizedBox(height: 52),
                const CloverLogo(size: 168),
                const Spacer(flex: 40),
                Text(
                  'Clover Move',
                  style: AppText.hero.copyWith(height: 1.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Share your route',
                  style: AppText.body.copyWith(fontSize: 16, height: 1.0),
                ),
                const SizedBox(height: 22),
                const _ColourFlag(),
                const Spacer(flex: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: Text(
                    'Discover walks, rides and workouts across Ireland — and '
                    'the people, places and businesses behind them.',
                    style: AppText.bodyStrong.copyWith(height: 1.655),
                  ),
                ),
                const Spacer(flex: 44),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      PrimaryButton(
                        label: 'Get Started',
                        onPressed: () => context.push('/kit-access'),
                      ),
                      const SizedBox(height: 10),
                      SecondaryButton(
                        label: 'I already have Smart Jerseys',
                        onPressed: () => context.push('/language'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'No account needed  ·  Made to move. Made to share.',
                  style: AppText.footnote.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The three brand values as a flag: 62 x 7 bars, 6 apart. White keeps a
/// hairline so it stays visible on the white ground.
class _ColourFlag extends StatelessWidget {
  const _ColourFlag();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final colour in [
          CloverColors.green,
          CloverColors.white,
          CloverColors.orange,
        ]) ...[
          if (colour != CloverColors.green) const SizedBox(width: 6),
          Container(
            width: 62,
            height: 7,
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(3.5),
              border: colour == CloverColors.white
                  ? Border.all(color: CloverColors.borderStrong)
                  : null,
            ),
          ),
        ],
      ],
    );
  }
}

/// 130 x 40 pill: flag, language, chevron.
class _LanguagePill extends StatelessWidget {
  const _LanguagePill({
    required this.label,
    required this.countryCode,
    required this.onTap,
  });

  final String label;
  final String countryCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: CloverColors.borderStrong),
    );

    return Material(
      color: CloverColors.white,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlagChip(countryCode: countryCode),
              const SizedBox(width: 8),
              Text(label, style: AppText.cardTitle.copyWith(fontSize: 13)),
              const SizedBox(width: 8),
              const PackIcon(
                PackIcons.chevronDown,
                size: 17,
                color: CloverColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
