import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/welcome_constants.dart';

import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../business_logic_layer/Onboard/bloc/onboard_bloc.dart';
import '../../../common/constants/colors.dart';
import '../../../common/constants/constant.dart';
import '../../../common/global.dart';
import '../Authentication/Signin/sign_in_screen.dart';

class OnboardScreen extends StatefulWidget {
  static const routeName = '/onboard';
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final OnboardBloc onboardBloc = OnboardBloc();
  final PageController pageController = PageController(initialPage: 0);

  void handleButton(int index) {
    if (index < 3) {
      pageController.animateToPage(
        index,
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 1000),
      );
    } else {
      onboardBloc.add(GetStartedButtonClickedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardBloc, OnboardState>(
      bloc: onboardBloc,
      listener: (context, state) {
        if (state is GetStartedButtonClickedActionState) {
          Global.storageService
              .setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(alignment: Alignment.center, children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                state.page = index;
                onboardBloc.add(ChangePageDotIndicatorEvent());
              },
              children: WelcomeConstants.welcomeConstants
                  .map(
                    (e) => _onboardPages(
                      e['id'] as int,
                      context,
                      e['imgUrl'] as String,
                      e['title'] as String,
                      e['subtitle'] as String,
                      e['btnName'] as String,
                      handleButton,
                    ),
                  )
                  .toList(),
            ),
            Positioned(
              bottom: 30.h,
              child: AnimatedSmoothIndicator(
                activeIndex: state.page,
                count: 3,
                effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryColor,
                    radius: 20,
                    dotWidth: 10,
                    dotHeight: 10,
                    expansionFactor: 2),
              ),
            )
          ]),
        );
      },
    );
  }
}

Widget _onboardPages(
  int index,
  BuildContext context,
  String imgUrl,
  String title,
  String subtitle,
  String buttonName,
  Function handleButton,
) {
  return Container(
    margin: const EdgeInsets.only(top: 92, left: 18, right: 18),
    child: Column(children: [
      IconButton(
          onPressed: null,
          icon: Image.asset(
            imgUrl,
            height: 280,
            width: 280,
          )),
      SizedBox(
        height: 40.h,
      ),
      Consumer(
        builder: (context, ChangeThemeMode value, child) => Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: value.isDyslexia ? FontWeight.w900 : FontWeight.w700,
            fontSize: 20.sp,
            color: AppColors.headingColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 3.h,
      ),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 25.h,
      ),
      CreateButton(title: buttonName, handleButton: () => handleButton(index)),
    ]),
  );
}
