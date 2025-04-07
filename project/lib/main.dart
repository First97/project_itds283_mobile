import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Queue App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEDAB5),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFFFFF6EF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png', height: 100), // ใช้โลโก้ตาม Figma
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isLogin = true),
                    child: Column(
                      children: [
                        Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isLogin ? FontWeight.bold : FontWeight.normal,
                            color: isLogin ? Colors.deepOrange : Colors.black,
                          ),
                        ),
                        if (isLogin)
                          Container(
                            height: 2,
                            width: 60,
                            color: Colors.deepOrange,
                            margin: EdgeInsets.only(top: 4),
                          )
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = false),
                    child: Column(
                      children: [
                        Text(
                          'ลงทะเบียน',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: !isLogin ? FontWeight.bold : FontWeight.normal,
                            color: !isLogin ? Colors.deepOrange : Colors.black,
                          ),
                        ),
                        if (!isLogin)
                          Container(
                            height: 2,
                            width: 60,
                            color: Colors.deepOrange,
                            margin: EdgeInsets.only(top: 4),
                          )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'อีเมล์',
                  hintText: 'โปรดใส่อีเมลของท่าน',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  hintText: 'โปรดใส่รหัสผ่านของท่าน',
                  border: OutlineInputBorder(),
                ),
              ),
              if (!isLogin) ...[
                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    hintText: 'โปรดใส่รหัสผ่านของท่านอีกครั้ง',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(isLogin ? 'เข้าสู่ระบบ' : 'ลงทะเบียน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
