import 'package:allemni/widgets/childnavbar.dart';
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
      appBar: ChildNavbar(),
      body: Center(
        child: Text(displayedText, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
