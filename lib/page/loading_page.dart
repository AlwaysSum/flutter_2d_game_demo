import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/shared/sheet/player_sheet.dart';

/// 加载页
class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PlayerSpriteSheet.runLeft.asWidget(),
              ),
              const Text(
                "加载中...",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
