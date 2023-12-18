import 'package:flutter/material.dart';
import 'package:imruslan/components/get_custom_appbar.dart';
import 'package:imruslan/controllers/responsive_service.dart';
import 'package:imruslan/views/sections/hero_section.dart';

import '../components/get_custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: GetCustomAppbar(context),
      drawer: Responsive(
          mobile: GetCustomDrawer(),
          desktop: Container()
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection()
          ],
        ),
      )
    );
  }
}
