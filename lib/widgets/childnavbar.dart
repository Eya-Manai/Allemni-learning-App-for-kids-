import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChildNavbar extends StatefulWidget implements PreferredSizeWidget {
  const ChildNavbar({super.key});

  @override
  NavbarState createState() => NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NavbarState extends State<ChildNavbar> {
  String? childName;
  String? childfalmilyName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getChildInfo();
  }

  Future<void> getChildInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("not signed in ");
      }

      final collectionId = 'Children';
      final docRef = FirebaseFirestore.instance
          .collection(collectionId)
          .doc(user.uid);
      debugPrint('Fetching user doc from $collectionId/${user.uid}');

      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception("Nod document");
      }
      final data = doc.data()!;
      debugPrint('Fetched child data: $data');

      final firstname = data["first_name"] as String? ?? "";
      final lastname = data["family_name"] as String? ?? "";
      debugPrint('child name and family name: $firstname $lastname');

      setState(() {
        childName = firstname;
        childfalmilyName = lastname;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("failed loading data :****");
      debugPrint(e.toString());
      setState(() {
        childName = "";
        childfalmilyName = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.logout, color: AppColors.pink),
              iconSize: 30,
              onPressed: () async {
                await FirebaseAuthServices().signOut();
                if (!mounted) return;
                Navigator.of(
                  // ignore: use_build_context_synchronously
                  context,
                ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
              },
            ),
            /*
            isLoading
                ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.pink,
                    ),
                  )
                : Image.asset(
                    parentGender == Gender.female
                        ? 'assets/images/mom.png'
                        : 'assets/images/dad.png',
                    width: 32,
                    height: 32,
                  ),
                  */
            const SizedBox(width: 8),
            if (!isLoading)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    childfalmilyName ?? "",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: 'childFont',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),

                  Text(
                    childName ?? "",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: 'childFont',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          SizedBox(width: 10),
          Image.asset("assets/images/logoapp.png", height: 38),
        ],
      ),
    );
  }
}
