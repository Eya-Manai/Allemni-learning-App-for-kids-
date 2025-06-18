import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const YellowButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'childFont',
        ),
      ),
    );
  }
}
