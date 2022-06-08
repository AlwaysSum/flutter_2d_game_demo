import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/shared/player/knight_controller.dart';
import 'package:rpg_game_2d/shared/sheet/common_sprite_sheet.dart';
import 'package:rpg_game_2d/shared/sheet/player_sheet.dart';

import '../interface/bar_life_controller.dart';
import '../map/dungeon_map.dart';

enum PlayerAttackType { AttackMelee, AttackRange }

class Knight extends SimplePlayer
    with ObjectCollision, UseStateController<KnightController> {
  static const double maxSpeed = DungeonMap.tileSize * 3;

  BarLifeController? barLifeController;

  Knight(Vector2 position)
      : super(
          position: position,
          size: Vector2(32, 32),
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
        ) {
    setupCollision(
      CollisionConfig(enable: true, collisions: [
        CollisionArea.rectangle(
          size: Vector2(32, 32),
          align: Vector2(0, 0),
        ),
      ]),
    );
  }

  @override
  void onMount() {
    barLifeController = BonfireInjector().get<BarLifeController>();
    barLifeController?.configure(maxLife: maxLife, maxStamina: 100);
    super.onMount();
  }

  @override
  void update(double dt) {
    barLifeController?.life = life;
    super.update(dt);
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (gameRef.sceneBuilderStatus.isRunning) {
      return;
    }
    if (hasController) {
      controller.handleJoystickAction(event);
    }
    super.joystickAction(event);
  }

  /// 渲染
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawDefaultLifeBar(
      canvas,
      borderRadius: BorderRadius.circular(5),
      borderWidth: 2,
    );
  }

  ///远程攻击
  void execRangeAttack(double radAngleRangeAttack, double damage) {
    simpleAttackRangeByAngle(
      animation: CommonSpriteSheet.fireBallRight,
      animationDestroy: CommonSpriteSheet.explosionAnimation,
      size: size,
      angle: radAngleRangeAttack,
      damage: damage,
      marginFromOrigin: 40,
      attackFrom: AttackFromEnum.PLAYER_OR_ALLY,
      speed: maxSpeed * 2,
      collision: CollisionConfig(collisions: [
        CollisionArea.rectangle(
          size: Vector2(width / 3, width / 3),
          align: Vector2(width / 2, width / 3),
        ),
      ]),
    );
  }
}
