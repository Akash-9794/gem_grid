import 'package:flame/game.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'game/gem_grid_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Portrait only (Android + iOS). Web browsers ignore this.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GemGridApp());
}

class GemGridApp extends StatelessWidget {
  const GemGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gem Grid',
      debugShowCheckedModeBanner: false,
      home: GameWidget(game: GemGridGame()),
    );
  }
}
