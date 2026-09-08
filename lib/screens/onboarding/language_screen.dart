import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/app_language.dart';
import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/flag_chip.dart';
import '../../widgets/leaf.dart';
import '../../widgets/pack_icon.dart';

/// 01b Language — five locales, flag chip on the left, region underneath.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: CloverColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const CloverLogo(size: 96),
            const SizedBox(height: 18),
            Text('Clover Move', style: AppText.title.copyWith(fontSize: 30)),
            const SizedBox(height: 4),
            Text(
              'Share your route',
              style: AppText.caption.copyWith(fontSize: 13, letterSpacing: 1.2),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Insets.textGutter,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose your language', style: AppText.subtitle),
                  const SizedBox(height: 4),
                  Text(
                    'You can change this at any time',
                    style: AppText.caption.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              flex: 6,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: AppLanguage.values.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final language = AppLanguage.values[index];
                  return _LanguageRow(
                    language: language,
                    isSelected: language == state.language,
                    onTap: () => context.read<AppState>().setLanguage(language),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                8,
                Insets.gutter,
                Insets.gutter,
              ),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: () => context.push('/colour'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      child: Material(
        color: isSelected ? CloverColors.greenTint : Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.field),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.field),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                FlagChip(
                  countryCode: language.countryCode,
                  width: 28,
                  height: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.name, style: AppText.rowTitle),
                      const SizedBox(height: 2),
                      Text(language.region, style: AppText.rowMeta),
                    ],
                  ),
                ),
                _RadioTick(selected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The pack marks the chosen language with a filled green circle carrying a
/// white tick; the others keep an empty ring.
class _RadioTick extends StatelessWidget {
  const _RadioTick({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? CloverColors.green : Colors.transparent,
        border: Border.all(
          color: selected ? CloverColors.green : CloverColors.borderStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? const PackIcon(
              PackIcons.check,
              size: 13,
              color: CloverColors.white,
              strokeWidth: 2.6,
            )
          : null,
    );
  }
}
