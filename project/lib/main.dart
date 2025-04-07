import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Queue App',
      theme: ThemeData(
        fontFamily: 'Kanit',
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
    backgroundColor: Colors.grey.shade200,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          color: Color(0xFFFFE0B2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Image.asset('assets/logo.png', height: 250),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTab('เข้าสู่ระบบ', isLogin, () {
                    setState(() => isLogin = true);
                  }),
                  SizedBox(width: 24),
                  _buildTab('ลงทะเบียน', !isLogin, () {
                    setState(() => isLogin = false);
                  }),
                ],
              ),
              SizedBox(height: 32),
              _buildTextField('อีเมล์', 'โปรดใส่อีเมลของท่าน'),
              SizedBox(height: 16),
              _buildTextField('รหัสผ่าน', 'โปรดใส่รหัสผ่านของท่าน', obscure: true),
              if (!isLogin) ...[
                SizedBox(height: 16),
                _buildTextField('ยืนยันรหัสผ่าน', 'โปรดใส่รหัสผ่านของท่านอีกครั้ง', obscure: true),
              ],
              SizedBox(height: 32),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white, // << เพิ่มบรรทัดนี้!
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      isLogin ? 'เข้าสู่ระบบ' : 'ลงทะเบียน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // ย้ำชัดเจนอีกครั้ง
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildTab(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: selected ? Colors.deepOrange : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (selected)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 60,
              color: Colors.deepOrange,
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
