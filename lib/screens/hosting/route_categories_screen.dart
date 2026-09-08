import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/detail.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../theme/pack_icons.dart';

/// 35 Route Categories — who the route welcomes. Multi-select, with a standing
/// reminder that any restriction has to answer to a real need.
class RouteCategoriesScreen extends StatefulWidget {
  const RouteCategoriesScreen({super.key});

  @override
  State<RouteCategoriesScreen> createState() => _RouteCategoriesScreenState();
}

class _RouteCategoriesScreenState extends State<RouteCategoriesScreen> {
  static const _groups = [
    'Singles',
    'Couples',
    'Friends',
    'Groups',
    'Families',
    'Dating',
    'Only Route',
    "Men's",
    "Women's",
    'Kids',
    'Children',
    'LGBTQIA+',
    'Pride',
    'Mixed',
  ];

  final _selected = <String>{'Friends', 'Groups', "Women's", 'LGBTQIA+'};

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
              child: BackHeader(
                title: 'Who is this for?',
                subtitle: 'Step 3 of 4',
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
                Text(
                  'Pick every group this route welcomes. Members see these on the '
                  'route card before they request a place.',
                  style: AppText.body.copyWith(fontSize: 13),
                ),
                const Gap(30),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final group in _groups)
                      CloverChip(
                        label: group,
                        selected: _selected.contains(group),
                        height: 42,
                        fontSize: 13.5,
                        onTap: () => setState(() {
                          if (!_selected.remove(group)) _selected.add(group);
                        }),
                      ),
                  ],
                ),
                const Gap(34),
                Callout(
                  title: '${_selected.length} selected',
                  body: _selected.isEmpty
                      ? 'Nothing selected yet — the route will show as open to all.'
                      : _selected.join(' · '),
                  icon: PackIcons.people,
                ),
                const Gap(16),
                const Callout(
                  title: 'Restrictions need a reason',
                  body:
                      'Restricting by gender or age must reflect a genuine safety '
                      'or comfort need.',
                  tint: CloverColors.divider,
                  icon: PackIcons.info,
                  iconColour: CloverColors.inkSoft,
                ),
              ],
            ),
          ),
          StickyBar(
            child: PrimaryButton(
              label: 'Continue',
              onPressed: () => context.push('/host-dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
