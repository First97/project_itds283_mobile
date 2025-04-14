import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/auth_screen.dart';
import 'pages/home_screen.dart'; // ✅ เรียกใช้งาน HomeScreen
import 'pages/nearby_restaurants.dart';
import 'pages/my_queue_page.dart';
import 'pages/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('th_TH', null);
  runApp(const MyApp()); // ✅ เพิ่ม const
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ✅ เพิ่ม constructor แบบ const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Queue App',
      theme: ThemeData(fontFamily: 'Kanit', primarySwatch: Colors.orange),
      home: const AuthScreen(), // ✅ เพิ่ม const
      // ✅ เส้นทางนำทางหลัก
      routes: {
        '/home': (context) => const HomeScreen(), // ✅ เพิ่ม const
        '/myQueue': (context) => const MyQueuePage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
