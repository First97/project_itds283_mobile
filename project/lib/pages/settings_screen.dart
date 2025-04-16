import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String email = FirebaseAuth.instance.currentUser?.email ?? 'ไม่มีข้อมูล';
  String dob = '01 ม.ค. 2000';
  String phone = '099-999-9999';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data != null) {
        setState(() {
          dob = data['birthdate'] ?? dob;
          phone = data['phone'] ?? phone;
        });
      }
    }
  }

  Future<void> _saveProfileField(String key, String value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        key: value,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF89733),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9652B),
        title: const Text('ตั้งค่า', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'บัญชีของฉัน',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 30, thickness: 1),

            _settingRow('อีเมลล์', email, onEdit: null),
            const Divider(thickness: 1),
            _settingRow(
              'วัน/เดือน/ปี',
              dob,
              onEdit: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 365 * 18),
                  ),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  // locale: const Locale('th', 'TH'), // 🔸 ลบออกเพื่อป้องกัน crash
                );
                if (picked != null) {
                  final formatted = _formatThaiDate(picked);
                  setState(() => dob = formatted);
                  await _saveProfileField('birthdate', formatted);
                }
              },
            ),
            const Divider(thickness: 1),
            _settingRow(
              'หมายเลขโทรศัพท์',
              phone,
              onEdit: () async {
                final result = await _showEditDialog('เบอร์โทรศัพท์', phone);
                if (result != null) {
                  setState(() => phone = result);
                  await _saveProfileField('phone', result);
                }
              },
            ),
            const Divider(thickness: 1),

            ListTile(
              title: const Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
            const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget _settingRow(String title, String value, {VoidCallback? onEdit}) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 16)),
                if (onEdit != null)
                  const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showEditDialog(String title, String initialValue) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('แก้ไข $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  String _formatThaiDate(DateTime date) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    final d = date.day.toString().padLeft(2, '0');
    final m = months[date.month - 1];
    final y = date.year + 543;
    return '$d $m $y';
  }
}
