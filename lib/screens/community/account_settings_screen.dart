import 'package:flutter/material.dart';

import '../../theme/pack_icons.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/headers.dart';
import '../../widgets/pack_icon.dart';
import '../../widgets/scaffolds.dart';

/// Profile and account controls available from the member dashboard.
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _contentRemoved = false;
  bool _deletionRequested = false;

  void _showSavedMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmAccountDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This removes your profile and personal content from Clover Move. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: CloverColors.orangeDark,
            ),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _deletionRequested = true);
    }
  }

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
              child: BackHeader(
                title: 'Account settings',
                subtitle: 'Profile, sign-in and privacy controls',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                22,
                Insets.gutter,
                30,
              ),
              children: [
                Text('Edit profile', style: AppText.section),
                const Gap(12),
                const _SettingsCard(
                  child: Column(
                    children: [
                      _SettingsInput(
                        label: 'Full name',
                        initialValue: 'Andrea Ní Bhriain',
                      ),
                      Gap(16),
                      _SettingsInput(
                        label: 'Location',
                        initialValue: 'Dublin, Ireland',
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                PrimaryButton(
                  label: 'Save profile changes',
                  onPressed: () => _showSavedMessage('Profile changes saved'),
                ),
                const Gap(24),
                Text('Sign-in details', style: AppText.section),
                const Gap(12),
                const _SettingsCard(
                  child: Column(
                    children: [
                      _SettingsInput(
                        label: 'Email address',
                        initialValue: 'andrea@example.ie',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Gap(16),
                      _SettingsInput(
                        label: 'New password',
                        initialValue: 'password',
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                SecondaryButton(
                  label: 'Update email or password',
                  onPressed: () => _showSavedMessage('Sign-in details updated'),
                ),
                const Gap(24),
                Text('Your content', style: AppText.section),
                const Gap(12),
                _SettingsCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IconTile(
                        size: 38,
                        radius: 12,
                        color: CloverColors.greenTint,
                        child: PackIcon(
                          PackIcons.document,
                          size: 19,
                          color: CloverColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _contentRemoved
                                  ? 'Personal content removed'
                                  : 'Remove my personal content',
                              style: AppText.cardTitle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _contentRemoved
                                  ? 'No saved drafts remain on this profile.'
                                  : 'Delete your saved drafts and personal uploads.',
                              style: AppText.caption.copyWith(fontSize: 11),
                            ),
                            if (!_contentRemoved) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _contentRemoved = true),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: CloverColors.orangeDark,
                                ),
                                child: const Text('Remove content'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                Text('Danger zone', style: AppText.section),
                const Gap(12),
                if (_deletionRequested)
                  const _DeletionRequestedCard()
                else
                  PrimaryButton(
                    label: 'Delete account',
                    color: CloverColors.orangeDark,
                    onPressed: _confirmAccountDeletion,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CloverCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _SettingsInput extends StatelessWidget {
  const _SettingsInput({
    required this.label,
    required this.initialValue,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: CloverColors.green,
          style: AppText.cardTitle.copyWith(fontSize: 14.5),
          decoration: InputDecoration(
            filled: true,
            fillColor: CloverColors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            enabledBorder: _border(CloverColors.border),
            focusedBorder: _border(CloverColors.green),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color colour) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colour),
  );
}

class _DeletionRequestedCard extends StatelessWidget {
  const _DeletionRequestedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CloverColors.orangeTint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const PackIcon(
            PackIcons.check,
            size: 20,
            color: CloverColors.orangeDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Account deletion requested. We will confirm when it is complete.',
              style: AppText.caption.copyWith(color: CloverColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
