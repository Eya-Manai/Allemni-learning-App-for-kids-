import 'package:allemni/widgets/childnavbar.dart';
import 'package:flutter/material.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonPage();
}

class _LessonPage extends State<Lesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: ChildNavbar(), body: Text("hello"));
  }
}
