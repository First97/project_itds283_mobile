import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9652B),
        foregroundColor: Colors.white,
        title: const Text('ประวัติการจองคิว'),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('history')
                .where('uid', isEqualTo: user?.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีประวัติการจอง',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          final historyData = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              final data = historyData[index].data() as Map<String, dynamic>;

              final logo = data['logo'] ?? 'assets/default.png';
              final restaurant = data['restaurant'] ?? 'ไม่ทราบชื่อร้าน';
              final status = data['status'] ?? 'จองคิว';
              final branch = data['branch'] ?? '-';
              final date = data['date'] ?? '-';
              final time = data['time'] ?? '-';

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          logo,
                          width: 50,
                          height: 50,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(status),
                            Text('สาขา $branch'),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(date),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(time),
                              ],
                            ),
                          ],
                        ),
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
