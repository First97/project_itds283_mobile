import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  String? scannedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "สแกน QR Code",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD9652B),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF89733),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) {
                final barcode = capture.barcodes.first;
                final String? code = barcode.rawValue;

                if (code != null && scannedText != code) {
                  setState(() {
                    scannedText = code;
                  });

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('พบข้อมูล: $code')));
                }
              },
            ),
          ),
          if (scannedText != null)
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'ผลลัพธ์: $scannedText',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
