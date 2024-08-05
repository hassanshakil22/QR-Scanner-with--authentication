import 'package:biometric_authentication/views/qr_generator.dart';
import 'package:biometric_authentication/views/scanner_view.dart';
import 'package:biometric_authentication/views/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SplashView(),
      routes: {
        '/generate': (context) => QrGenerator(),
        '/scanner': (context) => ScannerView(),
      },
    );
  }
}
