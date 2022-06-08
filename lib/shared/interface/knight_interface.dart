import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'bar_life_component.dart';

class KnightInterface extends GameInterface {
  @override
  void onMount() {
    add(BarLifeComponent());
    add(InterfaceComponent(
      spriteUnselected: Sprite.load('blue_button1.png'),
      spriteSelected: Sprite.load('blue_button2.png'),
      size: Vector2(40, 40),
      id: 5,
      position: Vector2(150, 20),
      onTapComponent: (selected) {
        _animateColorFilter();
      },
    ));
    super.onMount();
  }

  void _animateColorFilter() {
    if (gameRef.colorFilter?.config.color == null) {
      gameRef.colorFilter?.animateTo(
        Colors.red.withOpacity(0.5),
      );
    } else {
      gameRef.colorFilter?.animateTo(Colors.transparent, onFinish: () {
        gameRef.colorFilter?.config.color = null;
      });
    }
  }
}
