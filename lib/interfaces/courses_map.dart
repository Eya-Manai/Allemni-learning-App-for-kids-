import 'dart:math';
import 'dart:ui' as ui;
import 'package:allemni/services/course_services.dart';
import 'package:allemni/widgets/course_games_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_course_road.dart';

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
        "name": "خاصيات الهواء",
        "image": "assets/images/air.png",
        "order": 0,
      },
      {
        "id": "6sc2",
        "name": "مكونات الهواء",
        "image": "assets/images/carbon.png",
        "order": 1,
      },
      {
        "id": "6sc3",
        "name": "الاحتراق في الهواء",
        "image": "assets/images/fire.png",
        "order": 2,
      },
      {
        "id": "6sc4",
        "name": "التبادل الغازي في الرئتين",
        "image": "assets/images/lungs.png",
        "order": 3,
      },
      {
        "id": "6sc5",
        "name": "العناصر الناتجة عن الاحتراق",
        "image": "assets/images/candle.png",
        "order": 4,
      },
    ],
  };

  String childId = "";
  String subjectId = "";
  String moduleId = "";
  String gradeId = "";
  late String moduleKey;

  bool _didInit = false;
  late Future<void> _initialise;
  List<Map<String, dynamic>> courses = [];
  List<ui.Image> icons = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      childId = args['childId'] as String? ?? "";
      subjectId = args['subjectId'] as String? ?? "";
      moduleId = args['moduleId'] as String? ?? "";
      gradeId = (args['gradeId'] as String? ?? "").replaceAll(
        RegExp(r'[^0-9]'),
        "",
      );
      moduleKey = "$gradeId-$subjectId-$moduleId";
      //ignore:avoid_print
      print("Module Key: $moduleKey");

      _didInit = true;
      _initialise = _initialiseCoursesAndIcons();
    }
  }

  Future<void> _initialiseCoursesAndIcons() async {
    final defaultList = sampleCourseMap[moduleKey] ?? [];
    await CourseServices.uploadDefaultCourses(
      childId: childId,
      subjectId: subjectId,
      moduleId: moduleId,
      defaultCourses: defaultList,
    );

    List<Map<String, dynamic>> fetched = [];
    int attempts = 0;
    while (fetched.isEmpty && attempts < 5) {
      await Future.delayed(Duration(milliseconds: 300));
      fetched = await CourseServices.fetchCourses(
        childId: childId,
        subjectId: subjectId,
        moduleId: moduleId,
      );

      attempts++;
    }
    if (fetched.isEmpty) {
      throw Exception("Courses not available after upload.");
    }
    courses = fetched;
    //ignore:avoid_print
    print("📘 Loaded courses count: ${courses.length}");

    final images = <ui.Image>[];
    for (var c in courses) {
      try {
        final path = c["image"] as String;

        debugPrint(" Trying to load image asset: '$path'");
        final bytes = await rootBundle.load(path);
        final codec = await ui.instantiateImageCodec(
          bytes.buffer.asUint8List(),
        );
        final frame = await codec.getNextFrame();
        images.add(frame.image);
        debugPrint("✅ Image loaded: $path");
      } catch (e) {
        debugPrint("❌ Failed to load image:\n$e");
      }
    }

    if (!mounted) return;
    setState(() => icons = images);
    //ignore: avoid_print
    print("🖼️ Decoded icons count: ${images.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          FutureBuilder<void>(
            future: _initialise,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Text(
                    " لا توجد دروس متوفرة حاليا",
                    style: TextStyle(fontFamily: 'childFont', fontSize: 20),
                  ),
                );
              }
              return _buildMapView(courses, icons);
            },
          ),
        ],
      ),
    );
  }

  void _handleTaplogic(
    Offset tapPos,
    List<Map<String, dynamic>> courses,
    List<Offset> points,
    BuildContext context,
  ) {
    const double radius = 30;

    for (int i = 0; i < points.length; i++) {
      final circleCenter = points[i];
      final dx = tapPos.dx - circleCenter.dx;
      final dy = tapPos.dy - circleCenter.dy;
      final distance = sqrt(dx * dx + dy * dy);

      if (distance <= radius) {
        final course = courses[i];
        showDialog(
          context: context,
          builder: (_) => CourseGamesPopUp(title: course["name"]),
        );
        break;
      }
    }
  }

  Widget _buildMapView(
    List<Map<String, dynamic>> courses,
    List<ui.Image> icons,
  ) {
    final points = <Offset>[
      Offset(30, 100),
      Offset(250, 200),
      Offset(50, 300),
      Offset(250, 400),
      Offset(50, 520),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          _handleTaplogic(details.localPosition, courses, points, context);
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawCoursePath(points: points, icons: icons),
        ),
      ),
    );
  }
}
