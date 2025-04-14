import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/auth_screen.dart';
import 'pages/nearby_restaurants.dart';
import 'pages/my_queue_page.dart';
import 'pages/settings_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('th_TH', null);
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

      // ✅ เพิ่มตรงนี้เท่านั้น
      routes: {
        '/home': (context) => NearbyRestaurants(),
        '/myQueue': (context) => const MyQueuePage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
