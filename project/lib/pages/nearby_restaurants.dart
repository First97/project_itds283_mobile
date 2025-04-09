import 'package:flutter/material.dart';

class NearbyRestaurants extends StatelessWidget {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Suki Teenoi สุกี้ตี๋น้อย",
      "distance": "8.3 กม.",
      "queue": "47 คิว",
      "location": "พระราม2",
      "logo": "assets/suki.png",
    },
    {
      "name": "So Grill and Shabu โซกริลล์ แอนด์ ชาบู",
      "distance": "3.7 กม.",
      "queue": "2 คิว",
      "location": "ดาวคะนอง",
      "logo": "assets/sogrill.png",
    },
    {
      "name": "Sizzler ซิซซ์เล่อร์",
      "distance": "4.9 กม.",
      "queue": "0 คิว",
      "location": "เซ็นทรัล พระราม2",
      "logo": "assets/sizzler.png",
    },
    {
      "name": "Bar B Q Plaza บาร์บีคิวพลาซ่า",
      "distance": "5.1 กม.",
      "queue": "9 คิว",
      "location": "Terminal 21",
      "logo": "assets/bbq.png",
    },
    {
      "name": "You & I ยู แอนด์ ไอ",
      "distance": "5.4 กม.",
      "queue": "4 คิว",
      "location": "Terminal 21",
      "logo": "assets/youandi.png",
    },
    {
      "name": "Yakiniku ยากินิกุ",
      "distance": "6.4 กม.",
      "queue": "7 คิว",
      "location": "The Mall Tha Phra",
      "logo": "assets/yakiniku.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9652B),
        title: Text('ร้านอาหารใกล้ฉัน', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final item = restaurants[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  item['logo'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.restaurant, size: 50, color: Colors.grey);
                  },
                ),
              ),
              title: Text(
                item['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${item['location']} • ${item['distance']}'),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('รออีก ${item['queue']}'),
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
