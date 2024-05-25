import 'package:flutter/material.dart';
import 'package:mental_healthapp/features/auth/screens/get_started.dart';
import 'package:mental_healthapp/features/auth/screens/login_screen.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EColors.primarybg,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'assets/images/a.png',
                  ),
                )),
              ),
            ),
            SizedBox(height: 15,),
            Column(
              children: [
                Text(
                  "Self Care Comes First",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Welcome to NeuroSentry! Protect and monitor your neural activity with cutting-edge technology.",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w100,color: EColors.textSecondary),
                ),
              ],
            ),
            Spacer(),
            HelperButton(
              name: "I'm New here",
              isPrimary: true,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GetStarted(),
                  ),
                );
              },
            ),
            HelperButton(
              name: "I have an account",
              isPrimary: false,
              color: EColors.primaryColor.withOpacity(.0),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
