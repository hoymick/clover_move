import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

/// The launch animation, shown once before Welcome.
///
/// The source asset is genuinely transparent and tightly cropped around the
/// animated mark. This avoids the visible 16:9 rectangle produced by embedding
/// the original MP4 on a portrait screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const _animationDuration = Duration(milliseconds: 5400);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  VideoPlayerController? _soundtrack;
  bool _moved = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final soundtrack = VideoPlayerController.asset('assets/video/splash.mp4');
    _soundtrack = soundtrack;
    try {
      await soundtrack.initialize();
      await soundtrack.setVolume(1);
      await soundtrack.play();
    } catch (_) {
      // The visual splash must still work if audio is unavailable or the
      // device's media service has not started yet.
    }
    if (!mounted) return;
    setState(() => _started = true);
    _timer = Timer(SplashScreen._animationDuration, _next);
  }

  void _next() {
    if (_moved || !mounted) return;
    _moved = true;
    context.go('/welcome');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _soundtrack?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _next,
        child: Center(
          child: _started
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final size = (constraints.maxWidth * 0.76).clamp(
                      240.0,
                      320.0,
                    );
                    return SizedBox.square(
                      dimension: size,
                      child: Image.asset(
                        'assets/images/splash_transparent.gif',
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.high,
                      ),
                    );
                  },
                )
              : const SizedBox.square(
                  dimension: 132,
                  child: Center(child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }
}
