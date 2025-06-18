import 'package:allemni/interfaces/auth.dart';
import 'package:allemni/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    //ignore: avoid_print
    print("✅ Firebase initialized");
  } catch (e, s) {
    //ignore: avoid_print
    print("🔥 Firebase init FAILED: $e\n$s");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      routes: Routes.routes,
    );
  }
}
