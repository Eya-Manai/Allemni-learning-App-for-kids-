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
        "subjectId": "science",
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
        "subjectId": "science",
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
        "subjectId": "science",
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
        "subjectId": "science",
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
    gradeId = args['gradeId']?.replaceAll(RegExp(r'[^0-9]'), '') ?? "6";

    moduleKey = "$gradeId-$subjectId-$moduleId";
    //ignore: avoid_print
    print("🔑 moduleKey: $moduleKey");
  }

  Future<List<Map<String, dynamic>>> uploadAndSeedCourses() async {
    final existingCourses = await CourseServices.fetchCourses(
      subjectId: subjectId,
      moduleId: moduleId,
    );
    //ignore: avoid_print
    print("📦 Found ${existingCourses.length} existing courses");

    if (existingCourses.isNotEmpty) return existingCourses;

    final sampleCourses = sampleCourseMap[moduleKey] ?? [];
    //ignore: avoid_print
    print("📚 Sample courses found: ${sampleCourses.length}");

    if (sampleCourses.isNotEmpty) {
      await CourseServices.uploadModulestoFirebase(
        subjectId: subjectId,
        moduleId: moduleId,
        courseId: "",
        coursesData: {'courses': sampleCourses},
      );
    } else {
      //ignore: avoid_print
      print("⚠️ No sample courses found for key: $moduleKey");
    }

    final afterUpload = await CourseServices.fetchCourses(
      subjectId: subjectId,
      moduleId: moduleId,
    );
    //ignore: avoid_print
    print("📥 After upload: ${afterUpload.length} courses");

    return afterUpload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          /* FutureBuilder<List<Map<String, dynamic>>>(
            future: uploadAndSeedCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
              }
              */
          // return
          _buildMapView([]),
          //},
          // ),
        ],
      ),
    );
  }

  /*  Widget _buildMapView(List<Map<String, dynamic>> courses) {
    List<Offset> coursePoints = [
      Offset(80, 100),
      Offset(200, 200),
      Offset(100, 300),
      Offset(200, 400),
      Offset(120, 520),
    ];
    List<String> localIcons = [
      "assets/icons/air.png",
      "assets/icons/carbon.png",
      "assets/icons/fire.png",
      "assets/icons/lungs.png",
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
                child: Image.asset(
                  localIcons[i],
                  fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ),
      ],
    );
    */
  Widget _buildMapView(List<Map<String, dynamic>> courses) {
    final List<Offset> points = [
      Offset(30, 100),
      Offset(250, 200),
      Offset(50, 300),
      Offset(250, 400),
      Offset(50, 520),
      Offset(250, 600),
    ];
    return Padding(
      padding: const EdgeInsets.only(
        left: 50.0,
        right: 50.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: DrawCoursePath(points: points),
      ),
    );
  }
}
