import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../sheet/player_sheet.dart';

///钉子
class Nail extends GameDecoration with Sensor {
  Nail({required super.position, required super.size}) {
    setupSensorArea(intervalCheck: 500); //触发间隔
  }

  @override
  void onContact(GameComponent component) {
    if (component is Player) {
      component.receiveDamage(AttackFromEnum.ENEMY, 10, 1);
    }
  }

}
