import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

import '../map/dungeon_map.dart';
import '../sheet/common_sprite_sheet.dart';
import 'potion_life.dart';

class Chest extends GameDecoration with TapGesture {
  bool _observedPlayer = false;

  late TextPaint _textConfig;

  Chest.newByMap({required Vector2 position,required Vector2 size})
      : super(
          size: size,
          position: position,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: width / 2,
      ),
    );
  }

  Chest(Vector2 position)
      : super.withAnimation(
          animation: CommonSpriteSheet.chestAnimated,
          size: Vector2.all(DungeonMap.tileSize * 0.6),
          position: position,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: width / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.player != null) {
      seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!_observedPlayer) {
            _observedPlayer = true;
            _showEmote();
          }
        },
        notObserved: () {
          _observedPlayer = false;
        },
        radiusVision: DungeonMap.tileSize.toDouble(),
      );
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_observedPlayer) {
      _textConfig.render(
        canvas,
        'Touch me !!',
        Vector2(x - width / 1.5, center.y - (height + 5)),
      );
    }
  }

  @override
  void onTap() {
    if (_observedPlayer) {
      _addPotions();
      removeFromParent();
    }
  }

  @override
  void onTapCancel() {}

  void _addPotions() {
    gameRef.add(
      PotionLife(
        Vector2(
          position.translate(width * 2, 0).x,
          position.y - height * 2,
        ),
        30,
      ),
    );

    gameRef.add(
      PotionLife(
        Vector2(
          position.translate(width * 2, 0).x,
          position.y + height * 2,
        ),
        30,
      ),
    );

    _addSmokeExplosion(position.translate(width * 2, 0));
    _addSmokeExplosion(position.translate(width * 2, height * 2));
  }

  void _addSmokeExplosion(Vector2 position) {
    gameRef.add(
      AnimatedObjectOnce(
        animation: CommonSpriteSheet.smokeExplosion,
        position: position,
        size: Vector2.all(DungeonMap.tileSize.toDouble()),
      ),
    );
  }

  void _showEmote() {
    gameRef.add(
      AnimatedFollowerObject(
        animation: CommonSpriteSheet.emote,
        target: this,
        size: size,
        positionFromTarget: size / -2,
      ),
    );
  }

  @override
  void onTapDown(int pointer, Vector2 position) {}

  @override
  void onTapUp(int pointer, Vector2 position) {}
}
