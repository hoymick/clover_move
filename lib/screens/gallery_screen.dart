import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/cards.dart';
import '../widgets/leaf.dart';
import 'catalogue.dart';

/// Index of the design pack. Not a product screen — it exists so every screen
/// can be opened directly while the UI is being built out.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = screenSections.fold<int>(
      0,
      (sum, s) => sum + s.screens.length,
    );

    return Scaffold(
      backgroundColor: CloverColors.surfaceMuted,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: CloverColors.white,
            expandedHeight: 150,
            title: const Text('Clover Move'),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                0,
                Insets.gutter,
                18,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clover Move',
                    style: AppText.title.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 2),
                  Text('$total screens · 390 × 844', style: AppText.caption),
                ],
              ),
            ),
          ),
          for (final section in screenSections) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                22,
                Insets.gutter,
                10,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(section.title, style: AppText.section),
                    ),
                    Text('${section.screens.length}', style: AppText.caption),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
              sliver: SliverList.separated(
                itemCount: section.screens.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final screen = section.screens[index];
                  return CloverCard(
                    onTap: () => context.push('/${screen.path}'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 34,
                          child: Text(
                            screen.code,
                            style: AppText.rowMeta.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(screen.title, style: AppText.rowTitle),
                              const SizedBox(height: 2),
                              Text(screen.blurb, style: AppText.rowMeta),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const LeafMark(size: 16, color: CloverColors.hint),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
