import 'package:flutter/material.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 37 Notifications — today and this week. Unread entries carry a green dot and
/// a heavier title; read ones keep the same shape so the list stays even.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _today = [
    _Note(
      'Your place is confirmed',
      'Morning Route · Mon 07:00',
      '2h',
      PackIcons.check,
      true,
      false,
    ),
    _Note(
      'Aoife K. wants to join',
      'Your route · Morning Route',
      '5h',
      PackIcons.people,
      true,
      false,
    ),
    _Note(
      '20% off at Talbot Hotel',
      'Members only · ends 31 Aug',
      '9h',
      PackIcons.tag,
      false,
      true,
    ),
  ];

  static const _thisWeek = [
    _Note(
      'New event near you',
      'Howth Cliff Walk · Sat 09:00',
      '2d',
      PackIcons.pin,
      false,
      false,
    ),
    _Note(
      'How was Phoenix Park 10K?',
      'Leave a review for the host',
      '4d',
      PackIcons.star,
      false,
      true,
    ),
    _Note(
      'Route approved',
      'Sunrise Coastal Run is now live',
      '6d',
      PackIcons.shieldCheck,
      false,
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(
                title: 'Notifications',
                action: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Mark all read',
                    style: AppText.link.copyWith(fontSize: 12.5),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                18,
                Insets.gutter,
                24,
              ),
              children: [
                const _GroupLabel('TODAY'),
                for (final note in _today)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NoteCard(note: note),
                  ),
                const Gap(18),
                const _GroupLabel('THIS WEEK'),
                for (final note in _thisWeek)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NoteCard(note: note),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Note {
  const _Note(
    this.title,
    this.meta,
    this.age,
    this.icon,
    this.unread,
    this.promo,
  );

  final String title;
  final String meta;
  final String age;
  final String icon;
  final bool unread;

  /// Offers and review prompts use the orange tint rather than green.
  final bool promo;
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 12),
      child: Text(
        label,
        style: AppText.badge.copyWith(
          fontSize: 11,
          color: CloverColors.muted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final _Note note;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      onTap: () {},
      padding: const EdgeInsets.fromLTRB(12, 18, 18, 18),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: note.unread
                ? const Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: CloverColors.green,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          IconTile(
            size: 34,
            radius: 11,
            color: note.promo
                ? CloverColors.orangeTint
                : CloverColors.greenTint,
            child: PackIcon(
              note.icon,
              size: 17,
              color: note.promo ? CloverColors.orange : CloverColors.green,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: AppText.cardTitle.copyWith(
                          fontSize: 13.5,
                          fontWeight: note.unread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      note.age,
                      style: AppText.caption.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: CloverColors.hint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  note.meta,
                  style: AppText.caption.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
