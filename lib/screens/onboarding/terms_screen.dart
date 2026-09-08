import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 03 Terms of Use — the two documents to review and the point that browsing
/// needs no account.
///
/// Laid out top-down on the pack's grid: the shield tile at 126, the title at
/// 244, the documents at 360 and 464, the callout at 584. Both document rows
/// carry the same green tick — the pack does not differentiate them by icon.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // The pack shows a bare chevron here, with no title beside it.
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: Insets.gutter, top: 8),
                child: HeaderIconAction(
                  icon: PackIcons.chevronLeft,
                  bare: true,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/index'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Insets.textGutter,
                  40,
                  Insets.textGutter,
                  8,
                ),
                children: [
                  // Aligned, not bare: a ListView hands its children a tight
                  // width, which would otherwise stretch the tile.
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: IconTile(
                      size: 68,
                      radius: Radii.iconLarge,
                      color: CloverColors.greenTint,
                      child: PackIcon(
                        PackIcons.shieldCheck,
                        size: 30,
                        color: CloverColors.green,
                      ),
                    ),
                  ),
                  const Gap(24),
                  Text('Before you start', style: AppText.title),
                  const Gap(14),
                  Text(
                    'Please review and accept the following. Clover Move needs '
                    'no account and no password to browse.',
                    style: AppText.body.copyWith(height: 1.55),
                  ),
                  const Gap(32),
                  const _DocumentRow(
                    title: 'Terms of Use',
                    meta: 'Participation and safety rules',
                  ),
                  const Gap(12),
                  const _DocumentRow(
                    title: 'Privacy Policy',
                    meta: 'How your data is stored and shared',
                  ),
                  const Gap(28),
                  const _NoLoginPanel(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
              child: PrimaryButton(
                label: 'Accept & Continue',
                onPressed: () {
                  context.read<AppState>().acceptTerms();
                  context.push('/discovery');
                },
              ),
            ),
            Center(
              child: QuietButton(
                label: 'Decline',
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// 92-high row: green tick, the document's name, and what it covers.
class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.title, required this.meta});

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      onTap: () {},
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 92,
        child: Row(
          children: [
            const IconTile(
              child: PackIcon(
                PackIcons.check,
                size: 15,
                color: CloverColors.white,
                strokeWidth: 2.6,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.cardTitle),
                  const SizedBox(height: 5),
                  Text(meta, style: AppText.caption),
                ],
              ),
            ),
            const PackIcon(
              PackIcons.chevronRight,
              size: 20,
              color: CloverColors.hint,
            ),
          ],
        ),
      ),
    );
  }
}

/// The mint panel making the no-account promise.
class _NoLoginPanel extends StatelessWidget {
  const _NoLoginPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: CloverColors.greenTint,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Row(
        children: [
          const PackIcon(PackIcons.info, size: 22, color: CloverColors.ink),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No login required',
                  style: AppText.cardTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Browse events, routes and venues.',
                  style: AppText.caption.copyWith(color: CloverColors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
