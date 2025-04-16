import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9652B),
        foregroundColor: Colors.white,
        title: const Text('โปรโมชั่น'),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('promotions')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีโปรโมชั่นในขณะนี้',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          final promotions = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final data = promotions[index].data() as Map<String, dynamic>;

              final logo = data['logo'] ?? 'assets/default.png';
              final restaurant = data['restaurant'] ?? 'ไม่ทราบชื่อร้าน';
              final description = data['description'] ?? '-';
              final branch = data['branch'] ?? '-';
              final endDate = data['endDate'] ?? '-';

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          logo,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.store, size: 50),
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
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(description),
                            Text('สาขาที่ร่วม: $branch'),
                            Text('📅 ตั้งแต่วันนี้ถึงวันที่ $endDate'),
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
