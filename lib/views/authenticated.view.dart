import 'package:flutter/material.dart';

class AuthenticatedView extends StatelessWidget {
  const AuthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("authenticated successfully"),
      ),
    );
  }
}
