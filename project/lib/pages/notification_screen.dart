// ✅ NotificationScreen แก้ให้แสดงเฉพาะของผู้ใช้ปัจจุบัน และแสดงข้อความสถานะแบบชัดเจน
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String getMessageFromStatus(String status) {
    switch (status) {
      case 'cancelled':
        return '❌ คุณได้ยกเลิกคิวนี้แล้ว';
      case 'ready':
        return '🎉 ถึงคิวของคุณแล้ว กรุณาเตรียมตัว';
      case 'coming':
      default:
        return '⏳ อีกไม่กี่คิวจะถึงคุณแล้ว';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('กรุณาเข้าสู่ระบบ')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9652B),
        foregroundColor: Colors.white,
        title: const Text('การแจ้งเตือน'),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .where('uid', isEqualTo: user.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีการแจ้งเตือน',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data() as Map<String, dynamic>;

              final logo = data['logo'] ?? 'assets/default.png';
              final restaurant = data['restaurant'] ?? 'ร้านอาหาร';
              final status = data['status'] ?? 'coming';
              final branch = data['branch'] ?? '-';
              final date = data['date'] ?? '-';
              final time = data['time'] ?? '-';

              final message = getMessageFromStatus(status);

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.asset(logo, width: 50, height: 50),
                  title: Text(
                    restaurant,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(message),
                      Text('สาขา $branch'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(date),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(time),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
