import 'package:bonfire/bonfire.dart';
import 'package:rpg_game_2d/shared/enemy/goblin.dart';

class GoblinController extends StateController<Goblin> {
  //
  bool _seePlayerToAttackMelee = false;

  final double attack = 5;

  @override
  void update(double dt, Goblin component) {
    if (!gameRef.sceneBuilderStatus.isRunning) {
      _seePlayerToAttackMelee = false;

      component.seeAndMoveToPlayer(
        closePlayer: (player) {
          component.execAttack(attack);
        },
        observed: () {
          _seePlayerToAttackMelee = true;
        },
        radiusVision: 60,
      );

      if (!_seePlayerToAttackMelee) {
        component.seeAndMoveToAttackRange(
          minDistanceFromPlayer: 150,
          positioned: (p) {
            //执行攻击
            component.execAttackRange(attack);
          },
          radiusVision: 150,
          notObserved: () {
            //随机移动
            component.runRandomMovement(
              dt,
              speed: component.speed,
              maxDistance: 150,
            );
          },
        );
      }
    }
  }
}
