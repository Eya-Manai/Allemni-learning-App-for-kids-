import 'package:flutter/material.dart';

class Buildbackground extends StatelessWidget {
  const Buildbackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset('assets/images/appbackground.jpg', fit: BoxFit.cover),
    );
  }
}
