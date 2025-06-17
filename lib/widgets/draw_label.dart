import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildLabel extends StatelessWidget {
  final String text;

  const BuildLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildLabel(text);
  }
}

Widget _buildLabel(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 20,
      color: AppColors.black,
      fontFamily: 'childFont',
    ),
    textAlign: TextAlign.right,
  );
}
