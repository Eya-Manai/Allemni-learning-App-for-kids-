import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parenthome extends StatefulWidget {
  const Parenthome({super.key});

  @override
  State<Parenthome> createState() => _ParenthomeState();
}

class _ParenthomeState extends State<Parenthome> {
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final user = FirebaseAuth.instance.currentUser;
  Widget _buildChildCard({
    required String childId,
    required String firstName,
    required String lastName,
    required String avatarPath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(25),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(avatarPath),
                      radius: 30,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                        ),
                        onPressed: () async {
                          final preferences =
                              await SharedPreferences.getInstance();
                          await preferences.setString(
                            "selectedChildId",
                            childId,
                          );

                          final characterkey = "character_$childId";
                          final alreadySelected = preferences.getString(
                            characterkey,
                          );
                          final classkey = "class_$childId";
                          final classalreadychosen = preferences.getString(
                            classkey,
                          );

                          if (!mounted) return;

                          if (alreadySelected == null) {
                            Navigator.pushNamed(
                              context,
                              Routes.characterSelection,
                            );
                            if (classalreadychosen == null) {
                              Navigator.pushNamed(context, Routes.chooseclass);
                            }
                          } else {
                            Navigator.pushNamed(context, Routes.chooseSubject);
                          }
                        },
                        child: const Text(
                          "فتح الحساب",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontFamily: 'childFont',
                          fontSize: 20,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 2,
            left: 5,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, size: 24, color: AppColors.gray),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete_outline_outlined,
                size: 24,
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Stack(
        alignment: Alignment.center,

        children: [
          Buildbackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/settings.png",
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.addChild);
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.primaryYellow,
                        radius: 15,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                    Text(
                      "الأطفال المشاركين",
                      style: TextStyle(
                        fontFamily: 'childFont',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Children')
                        .where('parent_id', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا يوجد أطفال مضافين حاليا',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'childFont',
                              color: AppColors.black,
                            ),
                          ),
                        );
                      }

                      final childDocs = snapshot.data!.docs;
                      //ignore: avoid_print
                      print(" succés");
                      //ignore: avoid_print
                      print(" les informations des enfants : $childDocs");

                      return ListView.builder(
                        itemCount: childDocs.length,
                        itemBuilder: (context, index) {
                          final data =
                              childDocs[index].data() as Map<String, dynamic>;
                          return _buildChildCard(
                            childId: childDocs[index].id,
                            firstName: data['first_name'],
                            lastName: data['last_name'],
                            avatarPath: data['avatar'],
                          );
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
