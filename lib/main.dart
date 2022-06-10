import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/game/demo1.dart';
import 'package:rpg_game_2d/shared/player/knight_controller.dart';

import 'page/home_page.dart';
import 'shared/enemy/goblin_controller.dart';
import 'shared/interface/bar_life_controller.dart';
import 'shared/sounds/sounds_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SoundsManager.initialize();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  BonfireInjector().put((i) => KnightController());
  BonfireInjector().putFactory((i) => GoblinController());
  BonfireInjector().put((i) => BarLifeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Demo1Game(),
      home: const HomePage(),
    );
  }
}
