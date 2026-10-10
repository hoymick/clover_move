import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/admin_backend.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdminBackend.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CloverMoveApp(),
    ),
  );
}
