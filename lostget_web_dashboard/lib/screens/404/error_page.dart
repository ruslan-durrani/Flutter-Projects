import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/global/widgets/title_text.dart';

class PageNotFound extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/error.png", width: 350,),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTitle("Page not found"),
            ],
          )
        ],
      ),
    );
  }
}