import 'package:flutter/material.dart';

class ChooseClass extends StatefulWidget {
  const ChooseClass({super.key});

  @override
  State<ChooseClass> createState() => _ChooseClassState();
}

class _ChooseClassState extends State<ChooseClass> {
  String displayedText = "Show Class";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Class')),
      body: Center(
        child: Text(displayedText, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
