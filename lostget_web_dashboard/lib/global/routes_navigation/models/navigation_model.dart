import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/cookie_vars.dart';
import 'package:responsive_admin_dashboard/controllers/controller_bloc.dart';
import 'package:responsive_admin_dashboard/global/services/cookies.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/screens/add_admin/ui/add_admin_screen.dart';
import 'package:responsive_admin_dashboard/screens/authentication/login/bloc/login_bloc.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dash_board_screen.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dashboard_cubit/dashboard_bloc_cubit.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dashboard_pager.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/userBarChartCubit/user_registered_count_cubit.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/bloc/my_profile_bloc.dart';
import 'package:responsive_admin_dashboard/screens/settings/ui/settings_screen.dart';
import 'package:responsive_admin_dashboard/screens/users_management/ui/user_management.dart';
import '../../../screens/authentication/auth_screen.dart';
import '../../../screens/my_profile/edit_profile_bloc/edit_profile_bloc.dart';
import '../../../screens/my_profile/ui/profile_screen.dart';
import '../../../screens/users_management/bloc/user_profiles_bloc.dart';
import '../../../screens/users_management/data_table_bloc/data_table_bloc.dart';
import '../../services/shared_storage.dart';
import '../../widgets/logout_alert.dart';
import '../bloc/navigation_bloc.dart';

class Navigation {
  static const String DASHBOARD = "Dash Board";
  static const String USER_MANAGEMENT = "User Management";
  static const String ITEM_MANAGEMENT = "Item Management";
  static const String PROFILE = "Profile";
  static const String ADD_ADMIN = "Add Admin";
  static const String SETTINGS = "Settings";
  static const String LOGOUT = "Logout";
}

class NavigationBlocRouteBinder {
  final Map<String, String> navigationItemIcon;
  final BlocProvider blocProvider;
  final Widget routeScreen;

  NavigationBlocRouteBinder(
      this.navigationItemIcon, this.blocProvider, this.routeScreen) {}
}
final List<NavigationBlocRouteBinder> binderList = [
  NavigationBlocRouteBinder(
      {
        "navigationItem": Navigation.DASHBOARD,
        "navigationIcon": "assets/icons/Dashboard.svg"
      },
      BlocProvider<NavigationBloc>(
        create: (BuildContext context) => NavigationBloc(),
        lazy: false,
      ),
        DashBoardScreen(),),
  NavigationBlocRouteBinder(
      {
        "navigationItem": Navigation.USER_MANAGEMENT,
        "navigationIcon": "assets/icons/BlogPost.svg",
      },
      BlocProvider<MyProfileBloc>(
        create: (BuildContext context) => MyProfileBloc(),
        lazy: false,
      ),
      UserManagement()
  ),
  NavigationBlocRouteBinder(
    {
      "navigationItem": Navigation.ITEM_MANAGEMENT,
      "navigationIcon": "assets/icons/Message.svg"
    },
    BlocProvider<NavigationBloc>(
      create: (BuildContext context) => NavigationBloc(),
      lazy: false,
    ),
    Container(
      child: Center(
        child: Text("Item Management"),
      ),
    ),
  ),
  NavigationBlocRouteBinder(
    {
      "navigationItem": Navigation.PROFILE,
      "navigationIcon": "assets/icons/Statistics.svg"
    },
    BlocProvider<UserProfilesBloc>(
      create: (BuildContext context) => UserProfilesBloc(),
      lazy: false,
    ), ProfileScreen()
  ),
  NavigationBlocRouteBinder(
    {
      "navigationItem": Navigation.SETTINGS,
      "navigationIcon": "assets/icons/Setting.svg"
    },
    BlocProvider<NavigationBloc>(
      create: (BuildContext context) => NavigationBloc(),
      lazy: false,
    ),
    Settings()
  ),
  NavigationBlocRouteBinder(
      {
        "navigationItem": Navigation.ADD_ADMIN,
        "navigationIcon": "assets/icons/profile-add.svg"
      },
      BlocProvider<NavigationBloc>(
        create: (BuildContext context) => NavigationBloc(),
        lazy: false,
      ),
      AddAdmin()
  ),
  NavigationBlocRouteBinder(
    {
      "navigationItem": Navigation.LOGOUT,
      "navigationIcon": "assets/icons/Logout.svg"
    },
    BlocProvider<NavigationBloc>(
      create: (BuildContext context) => NavigationBloc(),
      lazy: false,
    ),
    LogOutAlert()
  )
];

List<Map<String, String>> getNavigationItems() {
  List<Map<String, String>> routeList = [];
  binderList.forEach((element) {
    routeList.add(element.navigationItemIcon);
  });
  return routeList;
}

List<BlocProvider> getBlocs() {
  List<BlocProvider> blocList = [];
  binderList.forEach((element) {
    blocList.add(element.blocProvider);
  });
  blocList.addAll([
    // BlocProvider<ControllerBloc>(
    //     create: (BuildContext context) => ControllerBloc()),
    BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
    BlocProvider<EditProfileBloc>(create: (BuildContext context) => EditProfileBloc()),
    BlocProvider<DataTableBloc>(create: (BuildContext context) => DataTableBloc()),
    BlocProvider<DashboardAnalyticsBloc>(create: (BuildContext context) => DashboardAnalyticsBloc()),
    BlocProvider<UserRegisteredCountBloc>(create: (BuildContext context) => UserRegisteredCountBloc()),

  ]);
  return blocList;
}

List<Widget> getWidgets() {
  List<Widget> widgetList = [];
  binderList.map((e) => widgetList.add(e.routeScreen));
  return widgetList;
}

List<String> getRoutesName() {
  List<String> listRoute = [];
  binderList.forEach((element) {
    listRoute.add(element.navigationItemIcon.values.first);
  });
  return listRoute;
}

class Generator {
  static MaterialPageRoute generateRoutes(RouteSettings settings)  {
    try{
      var routeName = settings.name;
      if (routeName != null) {
        String? token = CookieStorage().getTokenFromCookie();
        // print("Fetched Refresh: "+token!);
        if(token != ""){
          return MaterialPageRoute(
              builder: (_) => DashBoardPages(), settings: settings);
        }
        var results = binderList.where(
            (element) => element.navigationItemIcon.values.first == routeName);
        if (results.isNotEmpty) {
          return MaterialPageRoute(
              builder: (_) => results.first.routeScreen, settings: settings);
        }
      }
    }catch(e){
    }
    return MaterialPageRoute(
        builder: (_) => Authentication(), settings: settings);
  }
}
