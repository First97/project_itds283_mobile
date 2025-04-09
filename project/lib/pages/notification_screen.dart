import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'restaurant': 'Mo Mo Paradise โม โม พาราไดซ์',
      'queue': 'B02 @ ถึงคิวของคุณแล้วครับ',
      'branch': 'Terminal21',
      'date': '02 มี.ค. 2567',
      'time': '19:35:22 น.',
      'logo': 'assets/momo.png',
    },
    {
      'restaurant': 'Mo Mo Paradise โม โม พาราไดซ์',
      'queue': 'B02 @ กำลังจะถึงคิวของคุณแล้วครับ',
      'branch': 'Terminal21',
      'date': '02 มี.ค. 2567',
      'time': '19:29:11 น.',
      'logo': 'assets/momo.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'queue': 'B01 @ ถึงคิวของคุณแล้วครับ',
      'branch': 'เซ็นทรัลพระราม2',
      'date': '23 ก.พ. 2567',
      'time': '17:11:39 น.',
      'logo': 'assets/suki.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'queue': 'B01 @ กำลังจะถึงคิวของคุณแล้วครับ',
      'branch': 'เซ็นทรัลพระราม2',
      'date': '23 ก.พ. 2567',
      'time': '17:07:47 น.',
      'logo': 'assets/suki.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'queue': 'B01 @ กำลังจะถึงคิวของคุณแล้วครับ',
      'branch': 'เซ็นทรัลพระราม2',
      'date': '23 ก.พ. 2567',
      'time': '16:58:19 น.',
      'logo': 'assets/suki.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9652B),
        title: Text('การแจ้งเตือน'),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Column(
            children: [
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 12),
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
                      Text(item['queue']!),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
