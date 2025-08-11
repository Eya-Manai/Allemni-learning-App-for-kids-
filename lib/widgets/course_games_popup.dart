import 'package:allemni/constants/colors.dart';
import 'package:allemni/interfaces/lesson.dart';
import 'package:allemni/models/lesson_model.dart';
import 'package:allemni/widgets/draw_option_box.dart';
import 'package:flutter/material.dart';

class CourseGamesPopUp extends StatefulWidget {
  final String title;
  final bool isGamelocked;
  final LessonModel lesson;
  final String childId;

  const CourseGamesPopUp({
    super.key,
    required this.title,

    this.isGamelocked = true,
    required this.lesson,
    required this.childId,
  });

  @override
  State<CourseGamesPopUp> createState() => CourseGamePopUpState();
}

class CourseGamePopUpState extends State<CourseGamesPopUp> {
  late bool isGamelocked;

  @override
  void initState() {
    super.initState();
    isGamelocked = widget.isGamelocked;
    //ignore:avoid_Print
    print("Popup opened with locked = $isGamelocked");
  }

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
                      widget.title,
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
                    childId: widget.childId,
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
                    childId: widget.childId,
                    ontap: () async {
                      Navigator.pop(context);
                      final unlock = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Lesson(lesson: widget.lesson),
                        ),
                      );
                      if (unlock == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
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
