import 'package:flutter/material.dart';

class MyNotqueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8933C),
      body: Column(
        children: [
          // 🔶 Header bar เหลี่ยม (ไม่โค้ง)
          Container(
            height: 70,
            color: Color(0xFFD9652B),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'คิวของฉัน',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48), // ช่องว่างสมดุลกับปุ่ม back
              ],
            ),
          ),
          // 🔶 ข้อความด้านบน
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'ยังไม่มีการจองคิว',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
