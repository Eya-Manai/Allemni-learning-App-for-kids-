import 'package:allemni/constants/colors.dart';
import 'package:allemni/services/course_services.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_course_road.dart';
import 'package:flutter/material.dart';

class CoursesMap extends StatefulWidget {
  const CoursesMap({super.key});

  @override
  State<CoursesMap> createState() => _CoursesMapState();
}

class _CoursesMapState extends State<CoursesMap> {
  final Map<String, List<Map<String, dynamic>>> sampleCourseMap = {
    "6-science-airandbreathing": [
      {
        "id": "6sc1",
        "name": "خاصيات الهواء ",
        "image": "assets/icons/air.png",
        "progress": 0.0,
        "score": 0,
        "order": 0,
        "subjectId": "science",
        "moduleId": "airandbreathing",
        "isFirst": true,
      },
      {
        "id": "6sc2",
        "name": "مكونات الهواء ",
        "image": "assets/icons/carbon.png",
        "progress": 0.0,
        "score": 0,
        "order": 1,
        "moduleId": "airandbreathing",
        "isFirst": false,
      },
      {
        "id": "6sc3",
        "name": "الاحتراق في الهواء ",
        "image": "assets/icons/fire.png",
        "progress": 0.0,
        "score": 0,
        "order": 2,
        "moduleId": "airandbreathing",
        "isFirst": false,
      },
      {
        "id": "6sc4",
        "name": "التبادل الغازي في الرئتين",
        "image": "assets/icons/lungs.png",
        "progress": 0.0,
        "score": 0,
        "order": 3,
        "moduleId": "airandbreathing",
        "isFirst": false,
      },
      {
        "id": "6sc5",
        "name": "العناصر المتدخلة والناتجة عن عملية الاحتراق في الهواء",
        "image": "assets/icons/candle.png",
        "progress": 0.0,
        "score": 0,
        "order": 4,
        "moduleId": "airandbreathing",
        'isFirst': false,
      },
    ],
  };
  String childId = "";
  String subjectId = "";
  String moduleId = "";
  String moduleName = "";
  String gradeId = "";

  late final String moduleKey;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    childId = args['childId'] ?? "";
    subjectId = args['subjectId'] ?? "";
    moduleName = args['moduleName'] ?? "";
    moduleId = args['moduleId'] ?? "";
    gradeId = args['gradeId'] ?? "";
    moduleKey = "$gradeId-$subjectId-$moduleId";
  }

  Future<List<Map<String, dynamic>>> uploadandSeedCourses() async {
    final existingCorses = await CourseServices.fetchCourses(
      subjectId: subjectId,
      moduleId: moduleId,
    );
    if (existingCorses.isNotEmpty) {
      return existingCorses;
    }

    final sampleCourses = sampleCourseMap[moduleKey] ?? [];
    if (sampleCourses.isNotEmpty) {
      await CourseServices.uploadModulestoFirebase(
        subjectId: subjectId,
        moduleId: moduleId,
        courseId: "",
        coursesData: {'courses': sampleCourses},
      );
    }

    return await CourseServices.fetchCourses(
      subjectId: subjectId,
      moduleId: moduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: uploadandSeedCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد دروس متاحة في هذا المحور",
                    style: TextStyle(fontSize: 18, color: AppColors.black),
                  ),
                );
              } else {
                final courses = snapshot.data!;
                return _buildMapView(courses);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(List<Map<String, dynamic>> courses) {
    List<Offset> coursePoints = [
      Offset(100, 100),
      Offset(200, 200),
      Offset(150, 300),
      Offset(250, 400),
      Offset(100, 500),
    ];
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: DrawCoursePath(points: coursePoints)),
        ),
        for (int i = 0; i < courses.length; i++)
          Positioned(
            left: coursePoints[i].dx,
            top: coursePoints[i].dy,
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryYellow,
                child: Image.asset(courses[i]['image'], fit: BoxFit.cover),
              ),
            ),
          ),
      ],
    );
  }
}
