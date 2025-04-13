import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onToggle;

  const RegisterScreen({required this.onToggle});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')));
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกสำเร็จ!')));
      widget.onToggle(); // ไปหน้า login
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'อีเมลนี้ถูกใช้ไปแล้ว';
          break;
        case 'invalid-email':
          message = 'รูปแบบอีเมลไม่ถูกต้อง';
          break;
        case 'weak-password':
          message = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
          break;
        default:
          message = 'เกิดข้อผิดพลาด: ${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ไม่สามารถสมัครสมาชิกได้: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE0B2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              SizedBox(height: 24),
              Image.asset('assets/logo.png', height: 250),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: _buildTab('เข้าสู่ระบบ', false),
                  ),
                  SizedBox(width: 24),
                  _buildTab('ลงทะเบียน', true),
                ],
              ),
              SizedBox(height: 32),
              _buildTextField(
                'อีเมล์',
                'โปรดใส่อีเมลของท่าน',
                controller: emailController,
              ),
              SizedBox(height: 16),
              _buildTextField(
                'รหัสผ่าน',
                'โปรดใส่รหัสผ่านของท่าน',
                controller: passwordController,
                obscure: true,
              ),
              SizedBox(height: 16),
              _buildTextField(
                'ยืนยันรหัสผ่าน',
                'โปรดใส่อีกครั้ง',
                controller: confirmPasswordController,
                obscure: true,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: register,
                  child: Text(
                    'ลงทะเบียน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool selected) => Column(
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
  );

  Widget _buildTextField(
    String label,
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ],
  );
}
