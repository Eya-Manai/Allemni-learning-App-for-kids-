import 'package:flutter/material.dart';

class Characterselection extends StatefulWidget {
  const Characterselection({super.key});

  @override
  State<Characterselection> createState() => _CharacterSelection();
}

class _CharacterSelection extends State<Characterselection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character Selection')),
      body: Center(child: Text('Select your character')),
    );
  }
}
