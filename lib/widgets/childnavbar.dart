import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/child_service.dart';
import 'package:allemni/services/firebase_auth_services.dart';
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
  String? avatarPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getChildInfo();
  }

  Future<void> getChildInfo() async {
    try {
      final data = await ChildService.getChildData();
      if (data == null) {
        throw Exception("No child data");
      }
      setState(() {
        childName = data["first_name"] as String? ?? "";
        childfalmilyName = data["last_name"] as String? ?? "";
        avatarPath = data["avatar"] as String? ?? "";
        isLoading = false;
      });
    } catch (e) {
      debugPrint("failed loading data :****");
      debugPrint(e.toString());
      setState(() {
        childName = "";
        childfalmilyName = "";
        avatarPath = "";
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

            const SizedBox(width: 8),
            isLoading
                ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.pink,
                    ),
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(avatarPath!),
                  ),
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
