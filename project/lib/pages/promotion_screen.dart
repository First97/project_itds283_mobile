import 'package:flutter/material.dart';

class PromotionScreen extends StatelessWidget {
  final List<Map<String, String>> promotions = [
    {
      'restaurant': 'Mo Mo Paradise โม โม พาราไดซ์',
      'description':
          'โปรโมชั่น มา4จ่าย3 กับบัตรเครดิต KTC\nสาขาที่ร่วม Terminal21, เซ็นทรัลเวิลด์\nตั้งแต่วันนี้ถึงวันที่ 05/03/2567',
      'logo': 'assets/momo.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'description':
          'ฟรีขนมเบี้ยงตลอดเดือนมีนา\nสาขาที่ร่วม โลตัส คลอง4 ธัญบุรี\nตั้งแต่วันนี้ถึงวันที่ 31/03/2567',
      'logo': 'assets/suki.png',
    },
    {
      'restaurant': 'Suki Teenoi สุกี้ตี๋น้อย',
      'description':
          'โปรโมชั่น มา3 ได้รับพอนสียูสุ ฟรี ไข่บด\nสาขาที่ร่วม เซ็นทรัลพระราม2\nตั้งแต่วันนี้ถึงวันที่ 10/03/2567',
      'logo': 'assets/suki.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9652B),
        title: Text('โปรโมชั่น'),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          final item = promotions[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item['logo']!, width: 50, height: 50),
              ),
              title: Text(
                item['restaurant']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item['description']!,
                  style: TextStyle(height: 1.4),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
