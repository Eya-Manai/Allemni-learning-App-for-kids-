import 'package:allemni/constants/colors.dart';
import 'package:allemni/services/course_services.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:flutter/material.dart';

class CoursesMap extends StatefulWidget {
  const CoursesMap({super.key});

  @override
  State<CoursesMap> createState() => _CoursesMapState();
}

class _CoursesMapState extends State<CoursesMap> {
  String childId = "";
  String subjectId = "";
  String moduleId = "";
  String moduleName = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    childId = args['childId'] ?? "";
    subjectId = args['subjectId'] ?? "";
    moduleName = args['moduleName'] ?? "";
    moduleId = args['moduleId'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: CourseServices.fetchCourses(
              subjectId: subjectId,
              moduleId: moduleId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد دورات متاحة في هذا المحور",
                    style: TextStyle(fontSize: 18, color: AppColors.black),
                  ),
                );
              }
              final courses = snapshot.data!;
              return _buildMapView(courses);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(List<Map<String, dynamic>> courses) {
    return SingleChildScrollView();
  }
}
