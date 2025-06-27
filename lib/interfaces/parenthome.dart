import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Gender { male, female }

class Parenthome extends StatefulWidget {
  const Parenthome({super.key});

  @override
  State<Parenthome> createState() => _ParenthomeState();
}

class _ParenthomeState extends State<Parenthome> {
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final user = FirebaseAuth.instance.currentUser;
  //final String parentIconasset=parentGender==Gender.male? 'assets/images/dad.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        // leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Image(image: image)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('logged in', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text(
              user?.email ?? 'No user logged in',
              style: TextStyle(fontSize: 18),
            ),
            MaterialButton(
              onPressed: () async {
                await auth.signOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
              color: AppColors.pink,
              textColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
