import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/catalogue.dart';
import 'screens/gallery_screen.dart';
import 'screens/not_built_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tour_screen.dart';
import 'theme/app_theme.dart';

/// Root of the app. Every screen in the design pack is registered in
/// [screenSections] and gets a route generated from its entry, so the gallery
/// and the router can never drift apart.
class CloverMoveApp extends StatelessWidget {
  const CloverMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clover Move',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}

/// Lets a single screen be opened straight away while working on it:
/// `flutter run --dart-define=SCREEN=discovery`.
const _startScreen = String.fromEnvironment('SCREEN');

/// Walks every screen in turn, for reviewing the build:
/// `flutter run --dart-define=TOUR=1`.
const _tour = String.fromEnvironment('TOUR');

final _router = GoRouter(
  // Launch plays the brand animation, then hands over to Welcome. The screen
  // index lives at '/index' for reviewing the pack, and SCREEN= overrides both.
  initialLocation: _tour.isNotEmpty
      ? '/tour'
      : (_startScreen.isEmpty ? '/' : '/$_startScreen'),
  routes: [
    GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/index', builder: (_, _) => const GalleryScreen()),
    GoRoute(path: '/tour', builder: (_, _) => const TourScreen()),
    for (final section in screenSections)
      for (final screen in section.screens)
        GoRoute(
          path: '/${screen.path}',
          name: screen.path,
          builder: (context, _) => screen.builder(context),
        ),
  ],
  // Screens link ahead to parts of the pack that may not be drawn yet. Rather
  // than a red error page, say which screen is missing and offer the index.
  errorBuilder: (context, state) => NotBuiltScreen(path: state.uri.path),
);
