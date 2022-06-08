import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

///钉子
class Wall extends GameDecorationWithCollision {
  Wall({required super.position, required super.size}) {
    setupCollision(
      CollisionConfig(collisions: [
        CollisionArea.rectangle(
          size: size,
        ),
      ]),
    );
  }
}
