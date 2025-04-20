import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/auth_screen.dart';
import 'pages/home_screen.dart';
import 'pages/my_queue_page.dart';
import 'pages/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('th_TH', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Queue App',
      theme: ThemeData(fontFamily: 'Kanit', primarySwatch: Colors.orange),
      home: const AuthScreen(),

      routes: {
        '/home': (context) => const HomeScreen(),
        '/myQueue': (context) => const MyQueuePage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
