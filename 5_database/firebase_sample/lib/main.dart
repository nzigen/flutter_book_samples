import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample/pages/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore sample',
      home: HomeScreen.withDependencies(),
    );
  }
}
