import 'package:bonfire/bonfire.dart';

class CommonSpriteSheet {
  static Future<SpriteAnimation> get fireBallRight => SpriteAnimation.load(
        "attack/fireball_right.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  static Future<SpriteAnimation> get fireBallLeft => SpriteAnimation.load(
        "attack/fireball_left.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  static Future<SpriteAnimation> get smokeExplosion => SpriteAnimation.load(
        "enemy/smoke_explosin.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get fireBallBottom => SpriteAnimation.load(
        "attack/fireball_bottom.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  static Future<SpriteAnimation> get fireBallTop => SpriteAnimation.load(
        "attack/fireball_top.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(23, 23),
        ),
      );

  static Future<SpriteAnimation> get explosionAnimation => SpriteAnimation.load(
        "attack/explosion_fire.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  static Future<SpriteAnimation> get blackAttackEffectBottom =>
      SpriteAnimation.load(
        "enemy/atack_effect_bottom.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get blackAttackEffectLeft =>
      SpriteAnimation.load(
        "enemy/atack_effect_left.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get blackAttackEffectRight =>
      SpriteAnimation.load(
        "enemy/atack_effect_right.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get blackAttackEffectTop =>
      SpriteAnimation.load(
        "enemy/atack_effect_top.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get chestAnimated => SpriteAnimation.load(
        "itens/chest_spritesheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get emote => SpriteAnimation.load(
        "player/emote_exclamacao.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  static Future<Sprite> get columnSprite => Sprite.load('itens/column.png');

  static Future<Sprite> get spikesSprite => Sprite.load('itens/spikes.png');

  static Future<Sprite> get potionLifeSprite =>
      Sprite.load('itens/potion_life.png');


}
