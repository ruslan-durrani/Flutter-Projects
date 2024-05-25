import 'package:flutter/material.dart';
import 'package:mental_healthapp/features/auth/screens/login_screen.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Welcome to',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Neuro Sentry',
              style: TextStyle(color: EColors.primaryColor, fontSize: 24),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  // width: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      'assets/images/a.png',
                    ),
                  )),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "We are so glad to see you here",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            Text(
              textAlign: TextAlign.center,
              "Empower your mind with NeuroSentry. Monitor and secure your neural activity with cutting-edge technology",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            HelperButton(
              isPrimary:true,
              name: 'Get Started',
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
