import 'package:bonfire/bonfire.dart' hide Timer;
import 'package:flutter/cupertino.dart';

mixin GravityObject on ObjectCollision {
  bool _drop = true;

  // //保护
  // bool _protect = false;

  late num topValue;

  @override
  onMount() {
    super.onMount();
    topValue = y;
    // timerCallBack(timer) {
    //   if (_drop) {
    //     y = y + 2; //下落
    //   } else {
    //     y = topValue.toDouble();
    //   }
    //   checkWallCollisions();
    // }
    //
    // Timer.periodic(const Duration(milliseconds: 30), timerCallBack);
    checkWallCollisions();
  }

  checkWallCollisions() {
    // debugPrint("checkWallCollisions： -- $rectCollision");
    bool isCollision = false;
    for (var component in gameRef.collisions()) {
      // debugPrint(
      //     "距离：${component.rectCollision.top} -- ${rectCollision.bottom}");
      if (component.rectCollision.top >= rectCollision.bottom &&
          rectCollision.left >= component.rectCollision.left &&
          rectCollision.right <= component.rectCollision.right &&
          (component.rectCollision.top - rectCollision.bottom).abs() <= 1) {
        isCollision = true;
        topValue = component.rectCollision.top - height;
        break;
      }
    }
    _drop = !isCollision;

    if (_drop) {
      y = y + 1; //下落
    } else {
      y = topValue.toDouble();
    }
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    // debugPrint("检测碰撞 ${component.top}");
    // if (!_protect) {
    //   _drop = true;
    //   if (component is Wall) {
    //     debugPrint(
    //         "距离：${component.rectCollision.top} -- ${rectCollision.bottom}");
    //     if (component.rectCollision.top >= rectCollision.bottom) {
    //       _drop = false;
    //       y = component.rectCollision.top - 100;
    //       //避免重复检测的时候drop一直为true
    //       _protect = true;
    //       Future.delayed(const Duration(milliseconds: 10), () {
    //         _protect = false;
    //       });
    //     }
    //   }
    // }

    return super.onCollision(component, active);
  }

  @override
  update(dt) {
    // if (_drop) {
    //   y = y + 2; //下落
    // }
    super.update(dt);
    checkWallCollisions();
  }
}
