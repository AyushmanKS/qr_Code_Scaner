import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

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
        onDetect: (capture) async {
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
            final Directory tempDir = await getTemporaryDirectory();
            final String tempPath = tempDir.path;
            final File file = File('$tempPath/scanned_image.png');
            await file.writeAsBytes(image);

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
                                const SnackBar(
                                    content: Text('Copied to clipboard')),
                              );
                            },
                            icon: const Icon(Icons.copy),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Share.shareXFiles([XFile(file.path)],
                                  text: barcodeValue);
                            },
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
