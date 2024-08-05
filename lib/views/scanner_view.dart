import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final MobileScannerController _controller;
  bool _isScanning = false;

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cannot launch URL")));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
        autoStart: false,
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: true,
        cameraResolution: const Size(720, 1280));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text("QR SCANNER"),
          centerTitle: true,
          actions: [
            Text("Generate"),
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/generate');
                },
                icon: const Icon(Icons.qr_code_2_sharp))
          ],
        ),
        body: !_isScanning
            ? Center(
                child: ElevatedButton(
                  onPressed: _startScanning,
                  child: Text("Start Scan"),
                ),
              )
            : MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  //to get a barcode in the list of barcodes >> logically there has to be only one but since its the list we will have to iterate
                  // for (var barcode in barcodes) {
                  //   print("barcode found : ${barcode.rawValue}");
                  // }
                  final Uint8List? image = capture.image;
                  if (image != null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          String barcodeValue = barcodes.first.rawValue ??
                              "barcode does'nt aquire any value";
                          return AlertDialog(
                            title: Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.close), // Close button
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    setState(() {
                                      _isScanning = false;
                                      _controller.stop();
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _launchUrl(barcodeValue);
                                  },
                                  child: Text(barcodeValue)),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: barcodeValue));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Copied to Clipboard"),
                                        Icon(Icons.check_circle)
                                      ],
                                    )));
                                  },
                                  icon: Icon(Icons.copy)),
                            ],
                            content: Image(image: MemoryImage(image)),
                          );
                        });
                  }
                },
              ));
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
    });
    await _controller.start();
  }
}
