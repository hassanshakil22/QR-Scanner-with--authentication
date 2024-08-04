import 'package:biometric_authentication/views/authenticated.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final LocalAuthentication
      auth; // the auth will be declared later ut will be of type LocalAuthentication
  bool _supportState =
      false; // bool to check if the device supports the biometric

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication(); // initialziing in init state
    auth.isDeviceSupported().then((bool isSupported) {
      // what we are doing is uth.isdeviceSupported checks is fevice supports,then method initiates what to do after we got the boolean value from is device supported
      setState(() {
        // we get the asnwer in isSupported and we then store it in out global variable _supportState
        _supportState = isSupported;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("HomeView"),
            Text(
                _supportState ? "Device Supports " : "Device Doesnt Supports "),
            ElevatedButton(
                onPressed: _getAvailableBiometrics,
                child: const Text("getAvailableBiometrics")),
            ElevatedButton(
                onPressed: _authenticate,
                child: const Text("Authenticate to go to next Page"))
          ],
        ),
      ),
    );
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    print("list of biometrics ; $biometrics");

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Authenticate to go to next page",
          options: AuthenticationOptions(
            stickyAuth: true,
          ));
      if (authenticated) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AuthenticatedView()));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
