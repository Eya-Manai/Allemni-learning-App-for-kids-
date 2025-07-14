import 'package:allemni/widgets/childnavbar.dart';
import 'package:allemni/widgets/draw_background.dart';
import 'package:allemni/widgets/draw_title.dart';
import 'package:flutter/material.dart';

class ChooseModule extends StatefulWidget {
  const ChooseModule({super.key});

  @override
  State<ChooseModule> createState() => ChooseModuleState();
}

class ChooseModuleState extends State<ChooseModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: Stack(
        children: [
          Buildbackground(),
          BuildTitle("اختر الوحدة"),
          Center(
            child: Text(
              "هذه الصفحة مخصصة لاختيار الوحدة",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
