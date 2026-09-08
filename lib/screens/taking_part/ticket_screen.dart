import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/leaf.dart';
import '../../widgets/qr.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';
import '../../widgets/pack_icon.dart';

/// 14 Digital Ticket — QR, perforation and directions, on a green ground so the
/// ticket reads as a distinct object rather than another list screen.
class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.green,
      body: Stack(
        children: [
          // Tonal disc bleeding off the top-right corner.
          Positioned(
            top: -100,
            right: -52,
            child: Container(
              width: 392,
              height: 392,
              decoration: BoxDecoration(
                color: CloverColors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(bottom: false, child: _WhiteHeader()),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(26, 6, 26, 20),
                  children: [
                    PerforatedCard(
                      notchColour: CloverColors.green,
                      top: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const IconTile(
                                  size: 44,
                                  radius: 14,
                                  color: CloverColors.greenTint,
                                  child: LeafMark(size: 22),
                                ),
                                const SizedBox(width: 14),
                                const StatusBadge(
                                  label: 'CONFIRMED',
                                  fontSize: 10.5,
                                  colour: CloverColors.ink,
                                  background: CloverColors.greenTint,
                                ),
                              ],
                            ),
                            const Gap(24),
                            Text(
                              'Howth Cliff Walk',
                              style: AppText.title.copyWith(fontSize: 22),
                            ),
                            const Gap(8),
                            Text(
                              'Official Clover Move Event',
                              style: AppText.caption.copyWith(fontSize: 12.5),
                            ),
                            const Gap(22),
                            const Center(child: QrBlock(size: 214)),
                            const Gap(20),
                            Center(
                              child: Text(
                                'Show this code at the Meet Point',
                                style: AppText.caption.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Gap(16),
                          ],
                        ),
                      ),
                      bottom: const Padding(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _TicketFact(
                                    label: 'TICKET No.',
                                    value: 'CM-88410273-A',
                                  ),
                                ),
                                Expanded(
                                  child: _TicketFact(
                                    label: 'DATE & TIME',
                                    value: '15 Aug · 09:00',
                                  ),
                                ),
                              ],
                            ),
                            Gap(20),
                            _TicketFact(
                              label: 'MEET POINT',
                              value: 'Howth DART Station, D13 A2X6',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    _WhiteAction(
                      label: 'Get directions',
                      onPressed: () => context.push('/check-in'),
                    ),
                    const Gap(18),
                    Center(
                      child: Text(
                        'Add to Wallet',
                        style: AppText.cardTitle.copyWith(
                          fontSize: 14,
                          color: const Color(0xFFBFD6C9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The ticket screen's header sits on green, so the chrome inverts to white.
class _WhiteHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.gutter, 14, Insets.gutter, 14),
      child: Row(
        children: [
          Material(
            color: CloverColors.white.withValues(alpha: 0.18),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/index'),
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: PackIcon(
                  PackIcons.chevronLeft,
                  size: 18,
                  color: CloverColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Your ticket',
            style: AppText.subtitle.copyWith(
              fontSize: 19,
              color: CloverColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketFact extends StatelessWidget {
  const _TicketFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.badge.copyWith(
            fontSize: 10,
            color: CloverColors.muted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppText.cardTitle.copyWith(fontSize: 13.5),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// White action on the green ground — the inverse of [PrimaryButton].
class _WhiteAction extends StatelessWidget {
  const _WhiteAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PackIcon(
                PackIcons.arrowRight,
                size: 20,
                color: CloverColors.ink,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppText.button.copyWith(
                  color: CloverColors.ink,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
