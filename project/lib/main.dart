import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Queue App',
      theme: ThemeData(fontFamily: 'Kanit', primarySwatch: Colors.orange),
      home: AuthScreen(),
    );
  }
}
