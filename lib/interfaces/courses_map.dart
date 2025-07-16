import 'package:allemni/widgets/childnavbar.dart';
import 'package:flutter/material.dart';

class CoursesMap extends StatefulWidget {
  const CoursesMap({super.key});

  @override
  State<CoursesMap> createState() => _CoursesMapState();
}

class _CoursesMapState extends State<CoursesMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Center(child: Text("محتوى خريطة الدورات")),
    );
  }
}
