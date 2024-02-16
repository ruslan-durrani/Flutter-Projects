import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/routes/app_routes.dart';
import 'package:lost_get/common/bloc_provider/bloc_provider.dart';
import 'package:lost_get/utils/theme.dart';
import 'package:provider/provider.dart';
import 'common/global.dart';

void main() async {
  await Global.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: AppBlocProvider.allBlocProvider,
      child: ScreenUtilInit(
        designSize: const Size(360, 360),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LostGet',
            themeMode: Provider.of<ChangeThemeMode>(context).currentTheme,
            darkTheme: CustomTheme.lightTheme(
                Provider.of<ChangeThemeMode>(context).isDyslexia),
            theme: CustomTheme.darkTheme(
                Provider.of<ChangeThemeMode>(context).isDyslexia),
            onGenerateRoute: AppRouter().onGenerateRoute,
          );
        },
      ),
    );
  }
}
