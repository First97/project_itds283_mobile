import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:project/pages/home_screen.dart';

class MyQueuePage extends StatelessWidget {
  const MyQueuePage({super.key});

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
        title: const Text('คิวของฉัน', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('queues')
                .where('uid', isEqualTo: user.uid)
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีการจองคิว',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final queueDoc = snapshot.data!.docs.first;
          final data = queueDoc.data() as Map<String, dynamic>;

          // ตรวจสอบและสร้างแจ้งเตือน + ประวัติการจองทันทีหากยังไม่เคยบันทึก
          createAutoNotificationAndHistory(data);

          final date = DateTime.parse(data['timestamp']);
          final formattedDate = DateFormat('dd MMM yyyy', 'th_TH').format(date);
          final formattedTime = DateFormat('HH:mm:ss น.', 'th_TH').format(date);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        data['restaurantName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Image.asset(data['logo'], width: 60, height: 60),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'หมายเลขคิวของฉัน',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  data['queueId'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('รออีก ${data['queue']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${data['location']} ห่างจากคุณ ${data['distance']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(width: 4),
                          Text('$formattedDate    $formattedTime'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('จำนวนที่นั่ง ${data['seats']} คน'),
                      const Divider(height: 24, color: Color(0xFFF89733)),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );

                          try {
                            await FirebaseFirestore.instance
                                .collection('queues')
                                .doc(queueDoc.id)
                                .delete();

                            await createNotification(
                              uid: user.uid,
                              restaurant: data['restaurantName'],
                              logo: data['logo'],
                              branch: data['location'],
                              status: 'cancelled',
                              queueId: data['queueId'],
                            );

                            await createHistory(
                              uid: user.uid,
                              restaurant: data['restaurantName'],
                              logo: data['logo'],
                              branch: data['location'],
                              status: 'ยกเลิกคิว',
                            );

                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'ยกเลิกคิว',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> createAutoNotificationAndHistory(
    Map<String, dynamic> data,
  ) async {
    final uid = data['uid'];
    final queueId = data['queueId'];

    final timestamp = data['timestamp'];
    final dateTime = DateTime.parse(timestamp);

    final historyExist =
        await FirebaseFirestore.instance
            .collection('history')
            .where('uid', isEqualTo: uid)
            .where('queueId', isEqualTo: queueId)
            .where('status', isEqualTo: 'จองคิวสำเร็จ')
            .limit(1)
            .get();

    if (historyExist.docs.isEmpty) {
      await createHistory(
        uid: uid,
        restaurant: data['restaurantName'],
        logo: data['logo'],
        branch: data['location'],
        status: 'จองคิวสำเร็จ',
        timestamp: dateTime,
        queueId: queueId,
      );
    }

    final int remainingQueue =
        int.tryParse(data['queue'].toString().replaceAll(RegExp(r'\D'), '')) ??
        999;

    if (remainingQueue > 3) return;
    final status = remainingQueue == 0 ? 'ready' : 'coming';

    final existingNotify =
        await FirebaseFirestore.instance
            .collection('notifications')
            .where('uid', isEqualTo: uid)
            .where('queueId', isEqualTo: queueId)
            .where('status', isEqualTo: status)
            .limit(1)
            .get();

    if (existingNotify.docs.isEmpty) {
      await createNotification(
        uid: uid,
        restaurant: data['restaurantName'],
        logo: data['logo'],
        branch: data['location'],
        status: status,
        queueId: queueId,
      );
    }
  }

  Future<void> createNotification({
    required String uid,
    required String restaurant,
    required String logo,
    required String branch,
    required String status,
    required String queueId,
  }) async {
    final now = DateTime.now();
    await FirebaseFirestore.instance.collection('notifications').add({
      'uid': uid,
      'restaurant': restaurant,
      'logo': logo,
      'branch': branch,
      'status': status,
      'queueId': queueId,
      'timestamp': Timestamp.fromDate(now),
      'date': DateFormat('dd MMM yyyy', 'th_TH').format(now),
      'time': DateFormat('HH:mm:ss น.', 'th_TH').format(now),
    });
  }

  Future<void> createHistory({
    required String uid,
    required String restaurant,
    required String logo,
    required String branch,
    required String status,
    DateTime? timestamp,
    String? queueId,
  }) async {
    final now = timestamp ?? DateTime.now();
    await FirebaseFirestore.instance.collection('history').add({
      'uid': uid,
      'restaurant': restaurant,
      'logo': logo,
      'branch': branch,
      'status': status,
      'queueId': queueId ?? '',
      'timestamp': Timestamp.fromDate(now),
      'date': DateFormat('dd MMM yyyy', 'th_TH').format(now),
      'time': DateFormat('HH:mm:ss น.', 'th_TH').format(now),
    });
  }
}
