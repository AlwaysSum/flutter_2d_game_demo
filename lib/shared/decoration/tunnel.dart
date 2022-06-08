import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/extensions/ext.dart';
import 'package:rpg_game_2d/game/demo2.dart';
import 'package:rpg_game_2d/shared/sheet/common_sprite_sheet.dart';
import 'package:rpg_game_2d/shared/sheet/player_sheet.dart';

class Tunnel extends GameDecoration with Sensor {
  Tunnel({required super.position, required super.size}) ;

  bool isSaid = false;
  bool isNext = false;

  @override
  void onContact(GameComponent component) {
    if (isNext) return; //进入下一关
    if (component is Player) {
      if (gameRef.enemies().isNotEmpty) {
        gameRef.stopScene();
        isNext = true;
        debugPrint("下一关");
        //切换页面

        gameRef.context.goToReplacement(const Demo2Game());
      } else if (!isSaid) {
        isSaid = true;
        TalkDialog.show(gameRef.context, [
          Say(
            text: [const TextSpan(text: "需清理完所有的怪物，才可通往下一关")],
            person: SizedBox(
              width: 100,
              height: 100,
              child: CommonSpriteSheet.smokeExplosion.asWidget(),
            ),
          )
        ]);
      }
    }
  }



}
