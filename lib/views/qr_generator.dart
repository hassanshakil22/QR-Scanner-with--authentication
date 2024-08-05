import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({super.key});

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

String? qrData;

class _QrGeneratorState extends State<QrGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("QR-GENERATOR"),
        centerTitle: true,
        actions: [
          Text("Scan"),
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/scanner');
              },
              icon: const Icon(Icons.qr_code))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2)),
                  hintText: "Enter the data"),
              onSubmitted: (value) {
                setState(() {
                  qrData = value;
                });
              },
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: qrData != null
                  ? PrettyQrView.data(
                      data: qrData!,
                      decoration: PrettyQrDecoration(
                          background: Colors.transparent,
                          image: PrettyQrDecorationImage(
                            image: AssetImage(
                              'assets/flutterLogo.png',
                            ),
                            opacity: .2,
                          )))
                  : const Text("Provide a link"),
            ),
          ],
        ),
      ),
    );
  }
}
