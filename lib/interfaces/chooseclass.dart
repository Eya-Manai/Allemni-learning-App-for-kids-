import 'package:allemni/routes/routes.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseClass extends StatefulWidget {
  const ChooseClass({super.key});

  @override
  State<ChooseClass> createState() => _ChooseClassState();
}

class _ChooseClassState extends State<ChooseClass> {
  String displayedText = "اختر قسمك ";
  final List<Map<String, dynamic>> classes = [
    {
      "name": "السنة الأولى ابتدائي",
      "image": "assets/images/class1.png",
      "value": 1,
    },
    {
      "name": "السنة الثانية ابتدائي",
      "image": "assets/images/class2.png",
      "value": 2,
    },
    {
      "name": "السنة الثالثة ابتدائي",
      "image": "assets/images/class3.png",
      "value": 3,
    },
    {
      "name": "السنة الرابعة ابتدائي",
      "image": "assets/images/class4.png",
      "value": 4,
    },

    {
      "name": "السنة الخامسة ابتدائي",
      "image": "assets/images/class5.png",
      "value": 5,
    },
    {
      "name": "السنة السادسة ابتدائي",
      "image": "assets/images/class6.png",
      "value": 6,
    },
  ];

  Future<void> selectclass(Map<String, dynamic> classitem) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt("selectedClass", classitem["value"]);

    setState(() {
      displayedText = classitem["name"];
    });
    if (!mounted) return;
    Navigator.pushNamed(context, Routes.chooseclass);
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
                    child: BuildTitle(displayedText),
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
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classitem = classes[index];
                      return GestureDetector(
                        onTap: () => selectclass(classitem),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(classitem["image"], height: 70),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  classitem["name"],
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
