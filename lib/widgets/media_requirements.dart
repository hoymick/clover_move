import 'package:flutter/material.dart';

import '../theme/pack_icons.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'pack_icon.dart';

/// Required media bundle for routes, events, partners, sponsors and brands.
class MediaRequirementsPanel extends StatelessWidget {
  const MediaRequirementsPanel({
    super.key,
    required this.subject,
    this.onAddVideo,
    this.onAddPhotos,
  });

  final String subject;
  final VoidCallback? onAddVideo;
  final VoidCallback? onAddPhotos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CloverColors.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CloverColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$subject media',
            style: AppText.cardTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            'Add one presentation video up to 90 seconds and up to five photos.',
            style: AppText.caption.copyWith(fontSize: 11.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MediaAction(
                  icon: PackIcons.video,
                  title: 'Video',
                  meta: '0 / 1 · max 90 sec',
                  onTap: onAddVideo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MediaAction(
                  icon: PackIcons.camera,
                  title: 'Photos',
                  meta: '0 / 5',
                  onTap: onAddPhotos,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaAction extends StatelessWidget {
  const _MediaAction({
    required this.icon,
    required this.title,
    required this.meta,
    this.onTap,
  });

  final String icon;
  final String title;
  final String meta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CloverColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PackIcon(icon, size: 21, color: CloverColors.green),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.rowTitle.copyWith(fontSize: 12.5),
                    ),
                    const SizedBox(height: 2),
                    Text(meta, style: AppText.caption.copyWith(fontSize: 9.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
