import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/chips.dart';
import '../../widgets/headers.dart';
import '../../widgets/scaffolds.dart';
import '../../widgets/segmented_tabs.dart';
import '../../widgets/thumb.dart';
import '../../theme/pack_icons.dart';

/// 22 Manage Route — participants and check-in. Each participant's contact
/// number is partly masked; the host only needs enough to make a call.
class ManageRouteScreen extends StatefulWidget {
  const ManageRouteScreen({super.key});

  @override
  State<ManageRouteScreen> createState() => _ManageRouteScreenState();
}

class _ManageRouteScreenState extends State<ManageRouteScreen> {
  static const _tabs = ['Participants', 'Requests', 'Reports'];

  int _tab = 0;

  final _participants = <_Participant>[
    _Participant('Aoife K.', 'AK', '29 · +353 87 ···· 214', checkedIn: true),
    _Participant('Marcus O.', 'MO', '34 · +353 86 ···· 907', checkedIn: true),
    _Participant('Síle N.', 'SN', '27 · +353 85 ···· 330', checkedIn: true),
    _Participant('Deirdre M.', 'DM', '31 · +353 87 ···· 118'),
    _Participant('Liam K.', 'LK', '38 · +353 83 ···· 642'),
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
                title: 'Morning Route',
                subtitle: 'Host tools',
                action: HeaderIconAction(
                  icon: PackIcons.sliders,
                  bare: true,
                  onTap: () {},
                ),
              ),
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
                CloverCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const StatusBadge(label: 'PUBLISHED'),
                            const Gap(20),
                            Text(
                              'Mon · Wed · Fri  ·  07:00 – 09:00',
                              style: AppText.cardTitle.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '5 / 8',
                            style: AppText.title.copyWith(
                              fontSize: 22,
                              color: CloverColors.orange,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'places filled',
                            style: AppText.caption.copyWith(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                SegmentedTabs(
                  labels: _tabs,
                  selected: _tab,
                  height: 44,
                  fontSize: 12.5,
                  onChanged: (value) => setState(() => _tab = value),
                ),
                const Gap(22),
                if (_tab == 0)
                  for (final participant in _participants)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ParticipantRow(
                        participant: participant,
                        onToggle: () => setState(
                          () => participant.checkedIn = !participant.checkedIn,
                        ),
                      ),
                    )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: MessagePanel(
                      title: 'Nothing in ${_tabs[_tab]}',
                      body:
                          'New ${_tabs[_tab].toLowerCase()} will appear here as '
                          'members send them in.',
                      tint: CloverColors.divider,
                      iconColour: CloverColors.hint,
                      leaf: true,
                    ),
                  ),
              ],
            ),
          ),
          StickyBar(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: SecondaryButton(
                    icon: PackIcons.mail,
                    label: '',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Start check-in',
                    onPressed: () => context.push('/check-in'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Participant {
  _Participant(this.name, this.initials, this.detail, {this.checkedIn = false});

  final String name;
  final String initials;
  final String detail;
  bool checkedIn;
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({required this.participant, required this.onToggle});

  final _Participant participant;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Avatar(
            initials: participant.initials,
            size: 34,
            colour: CloverColors.orange,
            ring: true,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: AppText.rowTitle.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  participant.detail,
                  style: AppText.rowMeta.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (participant.checkedIn)
            StatusBadge(
              label: 'In',
              fontSize: 11,
              icon: PackIcons.check,
              background: CloverColors.greenTint,
            )
          else
            PillButton(
              label: 'Check in',
              height: 26,
              fontSize: 10,
              colour: CloverColors.white,
              textColour: CloverColors.muted,
              border: true,
              onPressed: onToggle,
            ),
        ],
      ),
    );
  }
}
