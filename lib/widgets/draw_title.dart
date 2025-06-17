import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildTitle extends StatelessWidget {
  final String text;

  const BuildTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 30,
        color: AppColors.primaryYellow,
        fontFamily: 'childFont',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
