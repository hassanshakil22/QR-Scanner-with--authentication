import 'package:biometric_authentication/views/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _supportState =
      false; // bool to check if the device supports the biometric

  @override
  void initState() {
    super.initState();
    LocalAuthentication auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      // what we are doing is uth.isdeviceSupported checks is fevice supports,then method initiates what to do after we got the boolean value from is device supported
      setState(() {
        // we get the asnwer in isSupported and we then store it in out global variable _supportState
        _supportState = isSupported;
      });
    });

    Future<void> _authenticate() async {
      if (_supportState) {
        try {
          bool authenticated = await auth.authenticate(
              localizedReason: "Authenticate to progress",
              options: AuthenticationOptions(
                  // stickyAuth: false, //when set to true the authentication gets a
                  ));
          if (authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ScannerView()));
          }
        } on PlatformException catch (e) {
          print(e);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "Biometric authentication is not supported by the device")));
        Future.delayed(Duration(seconds: 2), () {
          SystemNavigator.pop();
        });
      }
    }

    Future.delayed(const Duration(seconds: 3), _authenticate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/qrAppLogo.png"),
      ),
    );
  }
}
