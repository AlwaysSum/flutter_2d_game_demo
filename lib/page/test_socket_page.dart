import 'package:flutter/material.dart';

class TestSocketPage extends StatefulWidget {
  const TestSocketPage({Key? key}) : super(key: key);

  @override
  State<TestSocketPage> createState() => _TestSocketPageState();
}

class _TestSocketPageState extends State<TestSocketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            children: const [Text("Socket 测试")],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {

      }),
    );
  }
}
