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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                lesson.name,
                style: TextStyle(fontSize: 22, fontFamily: 'childFont'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
