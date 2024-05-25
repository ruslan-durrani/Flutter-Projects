import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/controller/auth_controller.dart';
import 'package:mental_healthapp/features/auth/screens/create_profile.dart';
import 'package:mental_healthapp/features/auth/screens/login_screen.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:mental_healthapp/shared/utils/show_snackbar.dart';

import '../../../shared/utils/circular_progress_indicator.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
  }

  Future signUpUser() async {
    setState(() {
      _isLoading = true; // Enable loading indicator
    });
    if (_confirmPassController.text != _passController.text) {
      showSnackBar(
          context: context,
          content: "Confirm Password and Password don't match");
      return;
    }
    try {
      await ref.read(authControllerProvider).creatingUserWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passController.text.trim(),
          );
      if (mounted) {
        Navigator.pushReplacementNamed(context, CreateProfile.routeName);
      }
    } catch (e) {
      String errorMessage = 'An unexpected error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      showSnackBar(context: context, content: errorMessage,isError: true);
    }
    if (mounted) {
      setState(() {
        _isLoading = false; // Disable loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 10,),
                    Text("Welcome!",style: Theme.of(context).textTheme.bodyMedium,),
                  const SizedBox(
                    height: 20,
                  ),
                  HelperTextField(
                      htxt: 'Email Address',
                      iconData: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress),
                  HelperTextField(
                    htxt: 'Password',
                    iconData: Icons.password,
                    controller: _passController,
                    keyboardType: TextInputType.emailAddress,
                    obscure: true,
                  ),
                  HelperTextField(
                    htxt: 'Confirm Password',
                    iconData: Icons.password,
                    controller: _confirmPassController,
                    keyboardType: TextInputType.emailAddress,
                    obscure: true,
                  ),
                  HelperButton(isPrimary:true,name: "SignUp", onTap: signUpUser),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log In',
                          style:
                          TextStyle(color: EColors.primaryColor, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            circularProgressIndicator()
        ],
      ),
    );
  }
}
