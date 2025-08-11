import 'package:flutter/material.dart';

class GameLevels extends StatelessWidget {
  const GameLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Levels")),
      body: Center(child: const Text("Game Levels Content")),
    );
  }
}
