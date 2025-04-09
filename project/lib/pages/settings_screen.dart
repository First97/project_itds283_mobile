import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9652B),
        title: Text('ตั้งค่า', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'บัญชีของฉัน',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 30, thickness: 1),
            _settingRow('อีเมลล์', 'c*****t@gmail.com'),
            Divider(thickness: 1),
            _settingRow('วัน/เดือน/ปี', '01 มี.ค. 2000'),
            Divider(thickness: 1),
            _settingRow('หมายเลขโทรศัพท์', '099-999-9999'),
            Divider(thickness: 1),
            ListTile(
              title: Text('ออกจากระบบ'),
              onTap: () {
                // เพิ่ม logic ออกจากระบบที่นี่ เช่น pop หลายหน้าหรือเปลี่ยน route
                Navigator.pop(context);
              },
            ),
            Divider(thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget _settingRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
