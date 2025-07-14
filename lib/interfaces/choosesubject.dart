import 'package:allemni/constants/colors.dart';
import 'package:allemni/constants/toast.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/child_service.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:flutter/material.dart';

class ChooseSubject extends StatefulWidget {
  const ChooseSubject({super.key});

  @override
  State<ChooseSubject> createState() => _ChooseSubjectState();
}

class _ChooseSubjectState extends State<ChooseSubject> {
  final List<Map<String, dynamic>> subjects = [
    {"name": "الرياضيات", "image": "assets/images/math.png", "value": "math"},
    {
      "name": "الإيقاظ العلمي",
      "image": "assets/images/science.png",
      "value": "science",
    },
    {"name": "العربية", "image": "assets/images/arabic.png", "value": "arabic"},
    {
      "name": "الفرنسية",
      "image": "assets/images/french.png",
      "value": "french",
    },
    {
      "name": "الإنجليزية",
      "image": "assets/images/english.png",
      "value": "english",
    },
    {
      "name": "التربية الإسلامية",
      "image": "assets/images/islamic.png",
      "value": "islamic",
    },
    {
      "name": "المدنية",
      "image": "assets/images/madaneya.png",
      "value": "madaneya",
    },
    {
      "name": "التربية التكنولوجية",
      "image": "assets/images/technology.png",
      "value": "technology",
    },
    {
      "name": " الجغرافيا",
      "image": "assets/images/geography.png",
      "value": "geography",
    },
    {
      'name': 'التاريخ',
      'image': "assets/images/history.png",
      "value": "history",
    },
  ];
  String displayText = "اختر المادة";

  Future<void> selectSubjct(Map<String, dynamic> subjectItem) async {
    try {
      await ChildService.updateSubject(subjectItem);
      setState(() {
        displayText = subjectItem["name"];
        if (!mounted) return;
        Navigator.pushNamed(
          context,
          Routes.chooseModule,
          arguments: {
            "subjectId": subjectItem["value"],
            "subjectName": subjectItem["name"],
          },
        );
      });
    } catch (e) {
      showToast(message: "حدث خطأ أثناء حفظ المادة", color: AppColors.orange);
      throw Exception("Error saving the subject $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subjectItem = subjects[index];
                      return GestureDetector(
                        onTap: () {
                          selectSubjct(subjectItem);
                        },
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(subjectItem["image"], height: 65),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    subjectItem["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'childFont',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
