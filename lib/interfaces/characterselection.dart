import 'package:allemni/constants/colors.dart';
import 'package:allemni/widgets/draw_a_button.dart';
import 'package:flutter/material.dart';

class Characterselection extends StatefulWidget {
  const Characterselection({super.key});

  @override
  State<Characterselection> createState() => _CharacterSelection();
}

class _CharacterSelection extends State<Characterselection> {
  List<Map<String, String>> characters = [
    {"name": 'دودي', "avatar": "assets/images/dodo.png"},
    {"name": 'بوبو', "avatar": "assets/images/bobo.png"},
    {"name": 'توتي ', "avatar": "assets/images/toti.png"},
    {"name": 'واكواك', "avatar": "assets/images/wakwak.png"},
  ];
  int stelectedindex = 0;
  void _next() {
    setState(() {
      (stelectedindex + 1) % characters.length;
    });
  }

  void _previous() {
    setState(() {
      (stelectedindex - 1 + characters.length) % characters.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final charachter = characters[stelectedindex];
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.lightBrown, AppColors.brown],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                charachter["name"]!,
                style: TextStyle(
                  fontSize: 64,
                  fontFamily: 'childFont',
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(charachter['avatar']!, width: 180),
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      _previous();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                  ),
                  DrawButtton(
                    text: 'اخترني',
                    width: 250,
                    height: 65,
                    size: 25,
                    color: AppColors.darkbrown,
                    textColor: AppColors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    onPressed: () {
                      _next();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
