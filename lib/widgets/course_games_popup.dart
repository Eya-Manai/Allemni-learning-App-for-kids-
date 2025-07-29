import 'package:allemni/constants/colors.dart';
import 'package:flutter/material.dart';

class CourseGamesPopUp extends StatelessWidget {
  final String title;
  const CourseGamesPopUp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.black,
                fontFamily: 'childFont',
              ),
            ),
            IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.close, color: AppColors.lightYellow),
            ),
          ],
        ),
      ),
    );
  }
}
