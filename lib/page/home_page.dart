import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:rpg_game_2d/game/demo1.dart';
import 'package:rpg_game_2d/game/demo3.dart';
import 'package:rpg_game_2d/page/test_socket_page.dart';
import 'package:rpg_game_2d/shared/sheet/player_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/tiled/image_bg.jpeg",fit: BoxFit.fill,),
          //  背景
          Center(
            child: Container(
              width: 400,
              height: 300,
              color: Colors.white10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "布鲁可技术分享",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: PlayerSpriteSheet.idleRight.asWidget(),
                  ),
                  //开始游戏
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Demo1Game();
                      }));
                    },
                    child: const Text("开始游戏-例子1"),
                  ),
                  const Divider(),
                  //开始游戏2
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.green),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const Demo3Game();
                          }));
                    },
                    child: const Text("开始游戏-例子2"),
                  ),
                  const Divider(),
                  //开始游戏2
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.green),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const TestSocketPage();
                          }));
                    },
                    child: const Text("开始游戏-socket测试"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
