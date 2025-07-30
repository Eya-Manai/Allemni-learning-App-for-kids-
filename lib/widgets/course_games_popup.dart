import 'package:allemni/constants/colors.dart';
import 'package:allemni/models/lesson_model.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/widgets/draw_option_box.dart';
import 'package:flutter/material.dart';

class CourseGamesPopUp extends StatelessWidget {
  final String title;
  final bool isGamelocked;
  final LessonModel lesson;
  const CourseGamesPopUp({
    super.key,
    required this.title,

    this.isGamelocked = true,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      child: SizedBox(
        width: 350,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                        fontFamily: 'childFont',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.lightbrown,
                      child: IconButton(
                        //lIcon button 3ando default padding
                        padding: EdgeInsets.zero,
                        onPressed: () => {Navigator.pop(context)},
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BildOptionBox(
                    color: AppColors.lightgray,
                    image: "assets/images/quiz.png",
                    locked: isGamelocked,
                    label: "الالعاب",
                    ontap: isGamelocked
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                  BildOptionBox(
                    color: AppColors.primaryYellow,
                    image: "assets/images/lesson.png",
                    locked: false,
                    label: "الدرس",
                    ontap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        Routes.lesson,
                        arguments: lesson,
                      );
                    },
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
