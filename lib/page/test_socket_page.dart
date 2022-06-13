import 'package:flutter/material.dart';
import 'package:rpg_game_2d/utils/socket_utils.dart';
import 'package:web_socket_channel/io.dart';

class TestSocketPage extends StatefulWidget {
  const TestSocketPage({Key? key}) : super(key: key);

  @override
  State<TestSocketPage> createState() => _TestSocketPageState();
}

class _TestSocketPageState extends State<TestSocketPage> {
  @override
  void initState() {
    super.initState();
    debugPrint("----初始化");
    SocketUtils().initSocket();
  }

  @override
  void dispose() {
    super.dispose();
    SocketUtils().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            children: [
              const Text("Socket 测试"),
              MaterialButton(onPressed: () => {

              },child: const Text("开始链接 socket"),),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {}),
    );
  }
}
