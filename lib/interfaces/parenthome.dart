import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Parenthome extends StatefulWidget {
  const Parenthome({super.key});

  @override
  State<Parenthome> createState() => _ParenthomeState();
}

class _ParenthomeState extends State<Parenthome> {
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
          ],
        ),
      ),
    );
  }
}
