import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/leaf_category.dart';
import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/detail.dart';
import '../../widgets/fields.dart';
import '../../widgets/headers.dart';
import '../../widgets/jersey_row.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// 11f Gift a Jersey — one jersey, transferred for good. A jersey already shared
/// can't be gifted, so its row is disabled rather than hidden.
class GiftJerseyScreen extends StatefulWidget {
  const GiftJerseyScreen({super.key});

  @override
  State<GiftJerseyScreen> createState() => _GiftJerseyScreenState();
}

class _GiftJerseyScreenState extends State<GiftJerseyScreen> {
  LeafCategory? _chosen;
  int _method = 0;

  static const _methods = [
    ('Gift QR code', 'Show or send the code', PackIcons.qr),
    ('Gift link', 'Send by message or email', PackIcons.share),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: Column(
        children: [
          const ColoredBox(
            color: CloverColors.white,
            child: SafeArea(
              bottom: false,
              child: BackHeader(title: 'Gift a jersey'),
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
                Text(
                  'A gift transfers the jersey for good. Only complete-kit owners '
                  'can gift.',
                  style: AppText.body.copyWith(fontSize: 13.5, height: 1.55),
                ),
                const Gap(22),
                const FieldLabel('Select jersey'),
                for (final category in LeafCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: JerseyRow(
                      category: category,
                      meta: 'Kit 01 · SJ-${category.label.toUpperCase()}-001',
                      // The White jersey is out on loan, so it can't be gifted.
                      enabled: category != LeafCategory.white,
                      state: category == LeafCategory.white
                          ? JerseyState.shared
                          : null,
                      selected: category == _chosen,
                      onTap: () => setState(() => _chosen = category),
                    ),
                  ),
                const Gap(14),
                const FieldLabel('Send as'),
                for (var i = 0; i < _methods.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ChoiceRow(
                      title: _methods[i].$1,
                      meta: _methods[i].$2,
                      selected: i == _method,
                      leading: IconTile(
                        size: 32,
                        radius: 10,
                        color: CloverColors.greenTint,
                        child: PackIcon(
                          _methods[i].$3,
                          size: 17,
                          color: CloverColors.green,
                        ),
                      ),
                      onTap: () => setState(() => _method = i),
                    ),
                  ),
                const Gap(14),
                const Callout(
                  title: 'This transfers ownership',
                  body:
                      'The jersey moves to the recipient. Your permanent token '
                      'stays with you.',
                  tint: CloverColors.orangeTint,
                  icon: PackIcons.lock,
                  iconColour: CloverColors.orangeDark,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: _chosen == null
                  ? 'Choose a jersey'
                  : 'Gift ${_chosen!.label} Jersey',
              onPressed: _chosen == null ? null : () => context.push('/claim'),
            ),
          ),
        ],
      ),
    );
  }
}
