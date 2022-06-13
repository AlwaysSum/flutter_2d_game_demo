import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/page/loading_page.dart';
import 'package:rpg_game_2d/shared/decoration/chest.dart';
import 'package:rpg_game_2d/shared/decoration/wall.dart';
import 'package:rpg_game_2d/shared/player/knight.dart';

import '../shared/decoration/Tunnel.dart';
import '../shared/decoration/nail.dart';
import '../shared/enemy/goblin.dart';
import '../shared/interface/bar_life_widget.dart';
import '../shared/interface/knight_interface.dart';
import '../shared/sounds/sounds_manager.dart';

class Demo1Game extends StatelessWidget  implements GameListener{
  const Demo1Game({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    //播放音乐
    // SoundsManager.playChopinRevelation();

    return BonfireTiledWidget(

      //控制器
      joystick: Joystick(
        keyboardConfig: KeyboardConfig(
            keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows),
        directional: JoystickDirectional(),
        actions: [
          JoystickAction(
            actionId: PlayerAttackType.AttackRange,
            sprite: Sprite.load('joystick/joystick_atack_range.png'),
            spriteBackgroundDirection: Sprite.load(
              'joystick/joystick_background.png',
            ),
            enableDirection: true,
            size: 50,
            margin: const EdgeInsets.only(bottom: 50, right: 160),
          ),
        ],
      ),
      //地图
      map: TiledWorldMap(
        // 'tiled/mapa1.json',
        'tiled/demo1/demo1.json',
        forceTileSize: const Size(32, 32),
        objectsBuilder: {
          "goblin": (properties) => Goblin(properties.position),
          "nail": (properties) =>
              Nail(position: properties.position, size: properties.size),
          "wall": (properties) =>
              Wall(position: properties.position, size: properties.size),
          "chest": (properties) =>
              // Chest.newByMap(position: properties.position, size: properties.size),
              Chest(properties.position),
          "tunnel": (properties) =>
              Tunnel(position: properties.position, size: properties.size),
        },
      ),
      interface: KnightInterface(),
      overlayBuilderMap: {
        'barLife': (context, game) => const BarLifeWidget(),
        'miniMap': (context, game) => MiniMap(
              game: game,
              margin: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(10),
              size: Vector2.all(150),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
      },
      initialActiveOverlays: const [
        "barLife",
        "miniMap",
      ],
      //玩家角色
      player: Knight(Vector2(160, 160)),
      //敌人
      ///--测试
      //显示碰撞区域
      // showCollisionArea: true,
      //热重载开启
      // constructionMode: true,
      //显示FPS
      showFPS: true,
      //显示加载地图进度
      progress: const LoadingPage(),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {
  }

  @override
  void updateGame() {
  }
}
