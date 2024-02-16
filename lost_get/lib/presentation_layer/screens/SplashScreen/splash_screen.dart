import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/screens/Dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/colors.dart';
import '../../../common/global.dart';
import '../Authentication/Signin/sign_in_screen.dart';
import '../Onboarding/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _navigateToNextScreen(context);
    });

    super.initState();
  }

  void _navigateToNextScreen(context) async {
    bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
    if (deviceFirstOpen) {
      // Check auto-login status
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, Dashboard.routeName);
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, OnboardScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ChangeThemeMode value, child) => Scaffold(
        backgroundColor: value.isDarkMode()
            ? AppColors.primaryColor
            : AppColors.darkPrimaryColor,
        body: Center(
          child: SvgPicture.asset('assets/icons/splash_logo.svg'),
        ),
      ),
    );
  }
}
