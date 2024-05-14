import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/Dashboard/bloc/dashboard_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/add_report_screen.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  const NavBar({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
        ),
      ]),
      child: Consumer(
        builder: (context, ChangeThemeMode changeThemeMode, child) {
          final bool isDyslexia = changeThemeMode.isDyslexia;
          ColorFilter? colorFilter = changeThemeMode.isDarkMode()
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null;
          return BottomNavigationBar(
            onTap: (value) {
              if (value == 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AddReportScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                dashboardBloc.add(TriggerAppEvent(value));
              }
            },
            currentIndex: dashboardBloc.state.index,
            unselectedFontSize: 10,
            selectedFontSize: 10,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home_inactive.svg',
                    colorFilter: colorFilter),
                activeIcon: SvgPicture.asset('assets/icons/home_active.svg',
                    colorFilter: colorFilter),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/chat_inactive.svg',
                    colorFilter: colorFilter),
                activeIcon: SvgPicture.asset('assets/icons/chat_active.svg',
                    colorFilter: colorFilter),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/add_report_inactive.svg',
                      colorFilter: colorFilter),
                  activeIcon: SvgPicture.asset(
                    changeThemeMode.isDarkMode()
                        ? 'assets/icons/dark_add_report_active.svg'
                        : 'assets/icons/add_report_active.svg',
                  ),
                  label: "Add"),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/my_reports_inactive.svg',
                    colorFilter: colorFilter),
                activeIcon: SvgPicture.asset(
                  changeThemeMode.isDarkMode()
                      ? 'assets/icons/dark_my_reports_active.svg'
                      : 'assets/icons/my_reports_active.svg',
                ),
                label: 'My Report',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/cpu-charge_light.svg',
                    width: 28, height: 28, colorFilter: colorFilter),
                activeIcon: SvgPicture.asset(
                  'assets/icons/cpu-charge_bold.svg',
                  width: 28,
                  height: 28,
                ),
                label: 'AI Report',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/icons/profile_settings_inactive.svg',
                    colorFilter: colorFilter),
                activeIcon: SvgPicture.asset(
                    'assets/icons/profile_settings_active.svg',
                    colorFilter: colorFilter),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
