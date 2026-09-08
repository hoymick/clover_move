import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../widgets/nav_shell.dart';

/// 40 Loading — the feed's skeleton. The blocks mirror screen 04's layout, so
/// nothing shifts when the content lands.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Insets.textGutter,
                  14,
                  Insets.gutter,
                  18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Block(width: 128, height: 14),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _Block(height: 46, radius: 14)),
                        SizedBox(width: 10),
                        _Block(width: 52, height: 46, radius: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Insets.gutter,
                20,
                Insets.gutter,
                24,
              ),
              children: [
                const Row(
                  children: [
                    _Block(width: 70, height: 36, radius: 18),
                    SizedBox(width: 16),
                    _Block(width: 74, height: 36, radius: 18),
                    SizedBox(width: 12),
                    _Block(width: 82, height: 36, radius: 18),
                  ],
                ),
                const SizedBox(height: 30),
                const _Block(width: 140, height: 18, radius: 6),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _CardSkeleton()),
                    SizedBox(width: 10),
                    Expanded(child: _CardSkeleton()),
                  ],
                ),
                const SizedBox(height: 30),
                const _Block(width: 156, height: 18, radius: 6),
                const SizedBox(height: 12),
                const _RowSkeleton(),
                const SizedBox(height: 12),
                const _RowSkeleton(),
              ],
            ),
          ),
          const CloverNavBar(active: NavTab.home),
        ],
      ),
    );
  }
}

/// One grey placeholder. The pack uses a single tone for every skeleton block.
class _Block extends StatelessWidget {
  const _Block({this.width, required this.height, this.radius});

  final double? width;
  final double height;
  final double? radius;

  static const _tone = Color(0xFFE4EDED);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _tone,
        borderRadius: BorderRadius.circular(radius ?? height / 2),
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CloverColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Block(height: 104, radius: 14),
          SizedBox(height: 18),
          _Block(width: 120, height: 14),
          SizedBox(height: 10),
          _Block(width: 92, height: 12),
          SizedBox(height: 18),
          _Block(width: 56, height: 16),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CloverColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CloverColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE4EDED),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Block(width: 170, height: 14),
              SizedBox(height: 8),
              _Block(width: 120, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
