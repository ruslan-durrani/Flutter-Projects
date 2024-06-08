import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/Auth/AuthStream.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/models/navigation_model.dart';
import 'package:responsive_admin_dashboard/global/services/global_initializers.dart';
import 'package:responsive_admin_dashboard/screens/add_admin/controller/passwordProvider.dart';
import 'global/theme_data_provider/theme_provider.dart';
import 'screens/reportedItem_management/provider/reported_item_provider.dart';
void main() async{
  await globalInitializers();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
        ChangeNotifierProvider(create: (context)=>PasswordProvider()),
        ChangeNotifierProvider(create: (context)=>ReportedItemsProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getBlocs(),
      child: MaterialApp(
        title: 'LostGet Admin Dashboard',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: AuthStream(),
        onGenerateRoute: Generator.generateRoutes,
      ),
    );
  }
}
