import 'dart:async';

import 'package:allemni/constants/colors.dart';
import 'package:allemni/models/chracters_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameStart extends StatefulWidget {
  final String childId;
  const GameStart({super.key, required this.childId});

  @override
  State<GameStart> createState() => _GameStarState();
}

class _GameStarState extends State<GameStart> {
  double progress = 00;
  bool isLoadingComplete = false;
  ChractersModel? chractersModel;

  Future<void> loadCharacters() async {
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final childDoc = await FirebaseFirestore.instance
          .collection("Children")
          .doc(widget.childId)
          .get();

      if (childDoc.exists) {
        final data = childDoc.data();
        if (data != null && data.containsKey("character")) {
          final Map<String, dynamic> characterData = Map<String, dynamic>.from(
            data['character'],
          );
          final loadcharac = ChractersModel.fromFirestore(characterData);
          setState(() {
            chractersModel = loadcharac;
          });
        }
      }
    } catch (e) {
      throw Exception("can't loading current child id $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadCharacters();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          isLoadingComplete = true;
        });

        Future.delayed(Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushNamed(context, '/gameLevels');
        });
      } else if (progress >= 0.95) {
        setState(() {
          progress = 1.0;
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
    if (chractersModel == null) {
      return Scaffold(
        backgroundColor: AppColors.primaryYellow,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "تعذر تحميل الشخصية",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: AppColors.green),
            ],
          ),
        ),
      );
    }

    final String emojiPath = isLoadingComplete
        ? chractersModel!.heartedeyed
        : chractersModel!.smiling;
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
              'تحميل البيانات ${((progress * 100).clamp(0, 100)).toInt()} %',
              style: TextStyle(
                fontSize: 17,
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
