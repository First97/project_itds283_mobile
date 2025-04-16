import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void toggle() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(onToggle: toggle)
        : RegisterScreen(onToggle: toggle);
  }
}
