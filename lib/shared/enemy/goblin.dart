import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/shared/sheet/enemy_sheet.dart';

import '../map/dungeon_map.dart';
import '../sheet/common_sprite_sheet.dart';
import '../sheet/player_sheet.dart';
import 'goblin_controller.dart';

class Goblin extends SimpleEnemy
    with
        ObjectCollision,
        AutomaticRandomMovement,
        TapGesture,
        UseStateController<GoblinController> {
  Goblin(Vector2 position)
      : super(
          position: position,
          size: Vector2(24, 24),
          animation: EnemySpriteSheet.simpleDirectionAnimation,
          speed: 10,
          life: 100,
        ) {
    setupCollision(
      CollisionConfig(collisions: [
        CollisionArea.rectangle(size: Vector2(24, 24)),
      ]),
    );
  }

  /// 执行远程攻击
  void execAttackRange(double damage) {
    if (gameRef.player != null && gameRef.player?.isDead == true) return;
    simpleAttackRange(
      animationRight: CommonSpriteSheet.fireBallRight,
      animationLeft: CommonSpriteSheet.fireBallLeft,
      animationUp: CommonSpriteSheet.fireBallTop,
      animationDown: CommonSpriteSheet.fireBallBottom,
      animationDestroy: CommonSpriteSheet.explosionAnimation,
      id: 35,
      size: Vector2.all(width * 0.9),
      damage: damage,
      speed: 35 * 3,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2.all(width / 2),
            align: Vector2(width * 0.25, width * 0.25),
          ),
        ],
      ),
      lightingConfig: LightingConfig(
        radius: width / 2,
        blurBorder: width,
        color: Colors.orange.withOpacity(0.3),
      ),
    );
  }

  ///执行攻击
  void execAttack(double damage) {
    if (gameRef.player != null && gameRef.player?.isDead == true) return;
    simpleAttackMelee(
      damage: damage / 2,
      size: Vector2.all(width),
      interval: 400,
      sizePush: 16,
      animationDown: CommonSpriteSheet.blackAttackEffectBottom,
      animationLeft: CommonSpriteSheet.blackAttackEffectLeft,
      animationRight: CommonSpriteSheet.blackAttackEffectRight,
      animationUp: CommonSpriteSheet.blackAttackEffectTop,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawDefaultLifeBar(
      canvas,
      borderRadius: BorderRadius.circular(5),
      borderWidth: 2,
    );
  }

  @override
  void die() {
    super.die();
    gameRef.add(
      AnimatedObjectOnce(
        animation: CommonSpriteSheet.smokeExplosion,
        position: position,
        size: Vector2.all(DungeonMap.tileSize.toDouble()),
      ),
    );
    removeFromParent();
  }

  @override
  void onTapCancel() {}

  @override
  void onTapDown(int pointer, Vector2 position) {}

  @override
  void onTapUp(int pointer, Vector2 position) {}

  @override
  void onTap() {
    TalkDialog.show(gameRef.context, [
      Say(
        text: [const TextSpan(text: "请问怎么离开这里？")],
        person: SizedBox(
          width: 100,
          height: 100,
          child: PlayerSpriteSheet.idleRight.asWidget(),
        ),
      ),
      Say(
        text: [const TextSpan(text: "哇呜哇哇呜啊!!!")],
        person: SizedBox(
          width: 100,
          height: 100,
          child: EnemySpriteSheet.idleRight.asWidget(),
        ),
      )
    ]);
  }
}
