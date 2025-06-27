import 'package:allemni/constants/colors.dart';
import 'package:allemni/routes/routes.dart';
import 'package:allemni/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Parenthome extends StatefulWidget {
  const Parenthome({super.key});

  @override
  State<Parenthome> createState() => _ParenthomeState();
}

class _ParenthomeState extends State<Parenthome> {
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parent Home')),
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
