import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/module_service.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseModule extends StatefulWidget {
  const ChooseModule({super.key});

  @override
  State<ChooseModule> createState() => ChooseModuleState();
}

class ChooseModuleState extends State<ChooseModule> {
  final Map<String, Map<String, List<Map<String, dynamic>>>>
  defaultModulesBySubjectAndGrade = {
    "science": {
      "grade6": [
        {
          "name": "الهواء والتنفس ",
          "image": "assets/images/breath.png",
          "value": "airandbreathing",
          "score": 0,
          "progress": 0.0,
        },
        {
          "name": "جهاز دوران الدم ",
          "image": "assets/images/science.png",
          "value": "circulatorysystem",
          "score": 0,
          "progress": 0.0,
        },
        {
          "name": "التغذية عند الانسان ",
          "image": "assets/images/food.png",
          "value": "nutrition",
          "score": 0,
          "progress": 0.0,
        },
        {
          "name": "الوسط البيئي ",
          "image": "assets/images/land.png",
          "value": "environment",
          "score": 0,
          "progress": 0.0,
        },
      ],
    },
  };
  String childId = "";
  String subjectId = "";
  String gradeId = "";
  String subjectName = "";
  String displayText = "اختر المحور";

  Future<void> loadChildId() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      setState(() {
        childId = preferences.getString("selectedChildId") ?? "";
      });
    } catch (e) {
      throw Exception("Error loading childId from SharedPreferences $e");
    }
  }

  @override
  void didChangeDependencies() {
    loadChildId();
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    subjectId = args['subjectId'] ?? "";
    subjectName = args['subjectName'] ?? "";

    gradeId = "grade${args['gradeId'] ?? ""}";
  }

  @override
  Widget build(BuildContext context) {
    if (childId.isEmpty) {
      return Scaffold(
        appBar: ChildNavbar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final modulerefs = FirebaseFirestore.instance
        .collection("Children")
        .doc(childId)
        .collection("Subjects")
        .doc(subjectId)
        .collection("Modules");

    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 20, right: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BuildTitle(displayText),
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: modulerefs.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      FirebaseFirestore.instance
                          .collection("Children")
                          .doc(childId)
                          .collection("Subjects")
                          .doc(subjectId)
                          .collection("Modules")
                          .get()
                          .then((snapshot) {
                            if (snapshot.docs.isEmpty) {
                              uploadDefaultModulesForSubjectsAndGrades(
                                subjectId: subjectId,
                                gradeId: gradeId,
                              );
                            }
                          });
                      return Center(
                        child: Text(
                          "لا توجد محاور بعد",
                          style: TextStyle(
                            fontFamily: 'childFont',
                            fontSize: 20,
                            color: AppColors.black,
                          ),
                        ),
                      );
                    }

                    final modules = snapshot.data!.docs;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: modules.length,
                          itemBuilder: (context, index) {
                            final module =
                                modules[index].data() as Map<String, dynamic>;
                            final title = module['name'] ?? "";
                            final image = module['image'] ?? "";
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.coursesMap,
                                  arguments: {
                                    'moduleId': modules[index].id,
                                    'moduleName': title,
                                    'subjectId': subjectId,
                                    'childId': childId,
                                    'gradeId': gradeId,
                                  },
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(image, height: 90),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'childFont',
                                          fontSize: 16,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadDefaultModulesForSubjectsAndGrades({
    required String subjectId,
    required String gradeId,
  }) async {
    final subjectData = defaultModulesBySubjectAndGrade[subjectId];
    final modules = subjectData?[gradeId];
    if (modules != null) {
      try {
        await ModuleService.uploadModules(subjectId, modules);
      } catch (e) {
        throw Exception("Error uploading default modules: $e");
      }
    } else {
      throw Exception(
        "No default modules found for subjectId: $subjectId and gradeId: $gradeId",
      );
    }
  }
}
