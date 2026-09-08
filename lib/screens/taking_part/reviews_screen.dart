import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/rating.dart';
import '../../widgets/scaffolds.dart';

/// 16 Reviews — rate host, venue and safety. Safety is scored separately from
/// the experience so a good day out can't bury a safety concern.
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _overall = 5;
  final _scores = {'Host': 5, 'Organisation': 4, 'Venue': 5, 'Safety': 5};
  final _comment = TextEditingController(
    text:
        'Beautiful route and a really welcoming group. The marshals kept '
        'everyone together on the cliff path.',
  );

  static const _detail = {
    'Host': 'Clover Move Ireland',
    'Organisation': 'Timing and communication',
    'Venue': 'Howth DART Station',
    'Safety': 'Briefing and route marshalling',
  };

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.white,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(bottom: false, child: BackHeader(title: 'Review')),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.textGutter,
                18,
                Insets.textGutter,
                24,
              ),
              children: [
                Text('How was it?', style: AppText.title),
                const Gap(10),
                Text(
                  'Howth Cliff Walk · Sat 15 Aug',
                  style: AppText.body.copyWith(fontSize: 13.5),
                ),
                const Gap(24),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: CloverColors.greenTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Overall experience',
                        style: AppText.cardTitle.copyWith(fontSize: 13),
                      ),
                      const Gap(14),
                      StarRating(
                        value: _overall,
                        size: 28,
                        colour: CloverColors.green,
                        onChanged: (value) => setState(() => _overall = value),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                for (final entry in _scores.entries)
                  RatingRow(
                    title: entry.key,
                    meta: _detail[entry.key]!,
                    value: entry.value,
                    onChanged: (value) =>
                        setState(() => _scores[entry.key] = value),
                  ),
                const Gap(16),
                Text(
                  'Add a comment',
                  style: AppText.section.copyWith(fontSize: 15),
                ),
                const Gap(12),
                TextField(
                  controller: _comment,
                  maxLines: 4,
                  maxLength: 500,
                  cursorColor: CloverColors.green,
                  style: AppText.bodyStrong.copyWith(fontSize: 13),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: CloverColors.surfaceMuted,
                    contentPadding: const EdgeInsets.all(18),
                    counterStyle: AppText.caption.copyWith(
                      fontSize: 11,
                      color: CloverColors.hint,
                    ),
                    enabledBorder: _border(CloverColors.border),
                    focusedBorder: _border(CloverColors.green),
                  ),
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Submit review',
              onPressed: () => context.push('/community'),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color colour) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: colour),
  );
}
