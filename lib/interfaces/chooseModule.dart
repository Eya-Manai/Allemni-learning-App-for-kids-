import 'package:allemni/widgets/childnavbar.dart';
import 'package:flutter/material.dart';

class ChooseModule extends StatefulWidget {
  const ChooseModule({super.key});

  @override
  State<ChooseModule> createState() => _ChooseModuleState();
}

class _ChooseModuleState extends State<ChooseModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChildNavbar(),
      body: const Center(
        child: Text('Module Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
