import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rpg_game_2d/shared/player/knight.dart';

import '../sounds/sounds_manager.dart';

/// 骑士的控制器
class KnightController extends StateController<Knight> {
  bool executingRangeAttack = false;
  double radAngleRangeAttack = 0;
  num attack = 50; //远程攻击弧度
  num? life;

  num? maxLife;
  bool isFirst = true;

  @override
  void onReady(Knight component) {
    debugPrint("血量:$life $isFirst");
    if (isFirst) {
      life ??= component.life;
      maxLife ??= component.maxLife;
      isFirst = false;
    } else {
      component.initialLife(maxLife!.toDouble());
      component.life = life!.toDouble();
    }
  }

  @override
  void update(double dt, Knight component) {
    life = component.life;
    maxLife = component.maxLife;
    //间隔检测
    bool executeRangeAttackInterval =
        component.checkInterval("ATTACK_RANGE", 150, dt);
    if (executingRangeAttack && executeRangeAttackInterval) {
      component.execRangeAttack(radAngleRangeAttack, attack / 2);
    }
  }

  void handleJoystickAction(JoystickActionEvent event) {
    if (event.id == PlayerAttackType.AttackRange) {
      //发起攻击
      if (event.event == ActionEvent.MOVE) {
        executingRangeAttack = true;
        radAngleRangeAttack = event.radAngle;
      }
      if (event.event == ActionEvent.UP) {
        executingRangeAttack = false;
      }
    } else if (event.id == LogicalKeyboardKey.keyK.keyId) {
      if (event.event == ActionEvent.DOWN) {
        executingRangeAttack = true;
        if (component != null) {
          radAngleRangeAttack = component!.angle;
        }
      }
      if (event.event == ActionEvent.UP) {
        executingRangeAttack = false;
      }
    }
  }
}
