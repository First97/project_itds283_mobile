import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const BookingPage({super.key, required this.restaurant});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int? selectedSeats;

  final seatOptions = [
    {'label': '1-2 คน', 'value': 2},
    {'label': '3-4 คน', 'value': 4},
    {'label': '5-6 คน', 'value': 6},
    {'label': '7-8 คน', 'value': 8},
  ];

  Future<void> _bookQueue() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final counterRef = FirebaseFirestore.instance
        .collection('counters')
        .doc('queue');
    final counterSnap = await counterRef.get();

    int current = counterSnap.exists ? (counterSnap['current'] ?? 0) : 0;
    current += 1;
    final queueNumber = 'A${current.toString().padLeft(3, '0')}';

    final now = DateTime.now();

    await FirebaseFirestore.instance.collection('queues').add({
      'queueId': queueNumber,
      'uid': user.uid,
      'email': user.email,
      'restaurantName': widget.restaurant['name'],
      'logo': widget.restaurant['logo'],
      'location': widget.restaurant['location'],
      'distance': widget.restaurant['distance'],
      'queue': widget.restaurant['queue'],
      'seats': selectedSeats,
      'timestamp': now.toIso8601String(),
    });

    await counterRef.set({'current': current});

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/myQueue');
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9652B),
        leading: const BackButton(color: Colors.white),
        title: const Text('จองคิว', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      data['logo'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${data['location']} ห่างจากคุณ ${data['distance']}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text('รออีก ${data['queue']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'กรุณาเลือกที่นั่ง',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children:
                    seatOptions.map((Map<String, dynamic> option) {
                      final isSelected = selectedSeats == option['value'];
                      return GestureDetector(
                        onTap:
                            () => setState(
                              () => selectedSeats = option['value'] as int?,
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFFD9652B)
                                      : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_seat,
                                size: 40,
                                color:
                                    isSelected
                                        ? const Color(0xFFD9652B)
                                        : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option['label'],
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? const Color(0xFFD9652B)
                                          : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedSeats == null ? null : _bookQueue,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedSeats == null
                          ? Colors.grey
                          : const Color(0xFFD9652B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('จองคิว', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
