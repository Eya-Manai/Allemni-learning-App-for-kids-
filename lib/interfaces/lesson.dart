import 'package:allemni/constants/colors.dart';
import 'package:allemni/models/lesson_model.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:flutter/material.dart';

class Lesson extends StatelessWidget {
  final LessonModel lesson;

  const Lesson({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        lesson.name,
                        style: TextStyle(fontSize: 24, fontFamily: 'childFont'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 200,

                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 80,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/lessonbackground.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
