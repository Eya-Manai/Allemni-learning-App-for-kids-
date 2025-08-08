import 'dart:async';

import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class GameStart extends StatefulWidget {
  const GameStart({super.key});

  @override
  State<GameStart> createState() => _GameStarState();
}

class _GameStarState extends State<GameStart> {
  double progress = 00;
  bool isLoadingComplete = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          isLoadingComplete = true;
        });
      } else {
        setState(() {
          progress += 0.05;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String emojiPath = isLoadingComplete
        ? "assets/images/hearteyedcat.png"
        : "assets/images/toti.png";
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(emojiPath, height: 120),
            SizedBox(height: 20),
            Text(
              "QUIZZ",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'childFont',
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 15,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200 * progress,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'تحميل البيانات ${((progress * 100).clamp(0, 100)).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
