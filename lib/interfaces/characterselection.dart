import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/widgets/draw_a_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Characterselection extends StatefulWidget {
  const Characterselection({super.key});

  @override
  State<Characterselection> createState() => _CharacterSelection();
}

class _CharacterSelection extends State<Characterselection> {
  List<Map<String, dynamic>> characters = [
    {
      "name": 'دودي',
      "avatar": "assets/images/dodo.png",
      "gradientStart": AppColors.lightBrown,
      "gradientEnd": AppColors.brown,
      "buttonColor": AppColors.darkbrown,
    },
    {
      "name": 'بوبو',
      "avatar": "assets/images/bobo.png",
      "gradientStart": AppColors.rose,
      "gradientEnd": AppColors.purple,
      "buttonColor": AppColors.purple,
    },
    {
      "name": 'توتي ',
      "avatar": "assets/images/toti.png",
      "gradientStart": AppColors.lightorange,
      "gradientEnd": AppColors.darkorange,
      "buttonColor": AppColors.darkorange,
    },
    {
      "name": 'واكواك',
      "avatar": "assets/images/wakwak.png",
      "gradientStart": AppColors.lightgray,
      "gradientEnd": AppColors.lightblack,
      "buttonColor": AppColors.lightblack,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  int stelectedIndex = 0;

  void _next() {
    setState(() {
      stelectedIndex = (stelectedIndex + 1) % characters.length;
    });
  }

  void _previous() {
    setState(() {
      stelectedIndex =
          (stelectedIndex - 1 + characters.length) % characters.length;
    });
  }

  Future _initPreferences() async {
    final prefrenes = await SharedPreferences.getInstance();
    final chosen = prefrenes.getString('selectedCharacter');
    if (chosen != null) {
      debugPrint("Avatar already selected: $chosen");
    } else {
      debugPrint("a problem happend while selecting avatar");
    }
  }

  void _confirmCharacter() async {
    final prefrenes = await SharedPreferences.getInstance();
    await prefrenes.setString(
      'selectedCharacter',
      characters[stelectedIndex]['name']!,
    );
    if (!mounted) return;
    Navigator.pushNamed(context, Routes.chooseclass);
  }

  @override
  Widget build(BuildContext context) {
    final charachter = characters[stelectedIndex];
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [charachter['gradientStart'], charachter["gradientEnd"]],
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
                    color: charachter['buttonColor'],
                    textColor: AppColors.white,
                    onPressed: () {
                      _confirmCharacter();
                    },
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
