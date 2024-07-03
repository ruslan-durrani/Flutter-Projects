import 'package:flutter/material.dart';

import '../../theme/colours.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen(Function() toggleAuth, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sign Up"),
      ),
    );
  }
}
