import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Code'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          log('---------$capture---------');
          List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          String barcodeValue = barcodes.isNotEmpty
              ? barcodes.first.rawValue ?? "No code found!"
              : "No code found!";

          for (final barcode in barcodes) {
            log('-------------Barcode found!: ${barcode.rawValue}');
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    barcodeValue,
                    style: const TextStyle(fontSize: 14),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: MemoryImage(image),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: barcodeValue));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied to clipboard')),
                              );
                            },
                            icon: const Icon(Icons.copy),
                          ),
                          IconButton(
                            onPressed: () async {},
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
