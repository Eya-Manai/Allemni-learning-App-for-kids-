import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Parenthome extends StatefulWidget {
  const Parenthome({super.key});

  @override
  State<Parenthome> createState() => _ParenthomeState();
}

class _ParenthomeState extends State<Parenthome> {
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Stack(
        alignment: Alignment.center,

        children: [
          Buildbackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/settings.png",
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.addChild);
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.primaryYellow,
                        radius: 15,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                    Text(
                      "الأطفال المشاركين",
                      style: TextStyle(
                        fontFamily: 'childFont',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
