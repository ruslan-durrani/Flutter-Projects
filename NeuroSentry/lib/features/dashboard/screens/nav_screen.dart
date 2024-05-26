import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/dashboard/screens/goals/goals_home.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/social_media_home.dart';
import 'package:mental_healthapp/features/profile/screens/profile.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/features/dashboard/screens/consultant/consultants_screen.dart';
import 'package:mental_healthapp/features/dashboard/screens/home.dart';
import 'package:mental_healthapp/shared/loading.dart';
import 'package:mental_healthapp/shared/notification_helper.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:provider/provider.dart' as provider;

class NavScreen extends ConsumerStatefulWidget {
  const NavScreen({super.key});

  @override
  ConsumerState<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends ConsumerState<NavScreen> {
  int _currIndex = 0;
  bool loading = true;

  final tabs = [
    const HomeScreen(),
    const ConsultScreen(),
    const SocialHome(),
    GoalHomeScreen(),
    const ProfileView(),
  ];
  @override
  void initState() {
    ref
        .read(profileControllerProvider)
        .downloadUserProfile()
        .then((value) => setState(() {
              loading = false;
            }));

    final db = provider.Provider.of<GoalDataBase>(context, listen: false);
    db.getGoalsFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingScreen()
        : Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: EColors.primaryColor,
                currentIndex: _currIndex,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedItemColor: EColors.dark.withOpacity(.3),
                iconSize: 26,
                // selectedFontSize: 16,
                // unselectedFontSize: 14,
                onTap: (value) {
                  setState(() {
                    _currIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,

                      ),
                      activeIcon: Icon(
                        Icons.home,
                        color: EColors.primaryColor,
                      ),
                      label: 'Home',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FontAwesomeIcons.userMd,
                        // Icons.extension_outlined,
                      ),
                      activeIcon: Icon(
                        FontAwesomeIcons.userMd,
                        color: EColors.primaryColor,
                      ),

                      label: 'Doctors'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.perm_media,
                      ),
                      activeIcon: Icon(
                        Icons.perm_media,
                        color: EColors.primaryColor,
                      ),
                      label: 'SocialMedia'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FontAwesomeIcons.award
                        // Icons.email_outlined,
                      ),
                      activeIcon: Icon(
                        FontAwesomeIcons.award
                        // color: EColors.primaryColor,
                      ),
                      label: 'Goals'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_2,
                      ),
                      activeIcon: Icon(
                        Icons.person_2,
                        color: EColors.primaryColor,
                      ),
                      label: 'Profile')
                ]),
            body: tabs[_currIndex],
          );
  }
}
