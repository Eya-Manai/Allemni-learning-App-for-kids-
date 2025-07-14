import 'package:allemni/constants/colors.dart';
import 'package:allemni/widgets/childnavbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: modulerefs.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index].data() as Map<String, dynamic>;
              final title = module['name'] ?? "";
              final image = module['image'] ?? "";
              return Card(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              );
            },
          );
        },
      ),
    );
  }
}
