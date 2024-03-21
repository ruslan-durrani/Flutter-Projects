import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/bloc/navigation_bloc.dart';
import 'package:responsive_admin_dashboard/global/services/cookies.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/global/services/shared_storage.dart';
import 'package:responsive_admin_dashboard/global/widgets/title_text.dart';
import 'package:responsive_admin_dashboard/constants/global_const_variables.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dash_board_screen.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dashboard_pager.dart';

import '../routes_navigation/models/navigation_model.dart';

class LogOutAlert extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: SvgPicture.asset("./assets/icons/Logout.svg", color:primaryColor, height: 60,),
      title: getTitle("Are you sure you want to logout?"),
      buttonPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      actions: [
        GestureDetector(
          onTap: (){
            FirebaseService().logout().then((e){
              CookieStorage().removeCookie(USER_CUSTOM_TOKEN);
              SharedStorage.setIsLogin(false);
              Navigator.of(context).pushNamedAndRemoveUntil("authentication", (route) => false);
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Logout",style: TextStyle(color: Colors.white),),
          ),
        ),
        GestureDetector(
          onTap: (){
            BlocProvider.of<NavigationBloc>(context).add(OnNavigationClickEvent(Navigation.DASHBOARD,DashBoardScreen()));
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1,color: primaryColor)
            ),
            child: Text("Cancel",style: TextStyle(color: primaryColor),),
          ),
        ),
      ],
    );
  }
}
