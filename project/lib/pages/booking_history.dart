import 'package:flutter/material.dart';

class BookingHistory extends StatelessWidget {
  final List<Map<String, String>> historyData = [
    {
      'restaurant': 'Mo Mo Paradise โม โม พาราไดซ์',
      'status': 'จองคิวสำเร็จ',
      'branch': 'Terminal21',
      'date': '05 มี.ค. 2567',
      'time': '19:55:22 น.',
      'logo': 'assets/momo.png',
    },
    {
      'restaurant': 'Mo Mo Paradise โม โม พาราไดซ์',
      'status': 'ยกเลิกคิว',
      'branch': 'Terminal21',
      'date': '05 มี.ค. 2567',
      'time': '19:29:11 น.',
      'logo': 'assets/momo.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'status': 'จองคิวสำเร็จ',
      'branch': 'เซ็นทรัลพระราม2',
      'date': '14 ก.พ. 2567',
      'time': '20:11:39 น.',
      'logo': 'assets/suki.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9652B),
        title: Text('ประวัติการจองคิว'),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Image.asset(item['logo']!, width: 50, height: 50),
              title: Text(
                item['restaurant']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['status']!),
                  Text('สาขา ${item['branch']}'),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 4),
                      Text(item['date']!),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 4),
                      Text(item['time']!),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
