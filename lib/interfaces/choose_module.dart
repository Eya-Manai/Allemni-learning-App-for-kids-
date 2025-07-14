import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseModule extends StatefulWidget {
  const ChooseModule({super.key});

  @override
  State<ChooseModule> createState() => ChooseModuleState();
}

class ChooseModuleState extends State<ChooseModule> {
  String childId = "";
  String subjectId = "";
  String subjectName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    subjectId = args['subjectId'] ?? "";
    subjectName = args['subjectName'] ?? "";
    loadChildId();
  }

  Future<void> loadChildId() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      setState(() {
        childId = preferences.getString("childId") ?? "";
      });
    } catch (e) {
      throw Exception("Error loading childId from SharedPreferences");
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildTitle("اختر المادة"),
                Expanded(
                  child: ListView.builder(
                    itemCount: 6, // Number of modules
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Module ${index + 1}"),
                        onTap: () {
                          // Handle module selection
                        },
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
