import 'dart:ui';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/components/buidlTextField.dart';
import 'package:lost_get_police_panel/theme.dart';
import 'package:lost_get_police_panel/views/auth_view/register.dart';
import 'package:lost_get_police_panel/views/home_view/home_view.dart';
import 'package:lottie/lottie.dart';

import '../../components/reusableButton.dart';
import '../../components/toastMessage.dart';
import '../../global/responsive.dart';

class Login extends StatelessWidget {
  final VoidCallback toggleFunc;
  Login({super.key, required this.toggleFunc});

  @override
  Widget build(BuildContext context) {
    final double appPadding = 28;
    return Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(

            image: DecorationImage(
                image: AssetImage("./assets/images/bg.png",),
              fit: BoxFit.fill
            )
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              // alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width *.4,
              margin: EdgeInsets.symmetric(horizontal: 100),
              height: MediaQuery.of(context).size.height *.8,

              decoration: BoxDecoration(
                color: themeData.colorScheme.inversePrimary.withOpacity(.9),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: Responsive.isMobile(context) ? 10 : 40,
                  horizontal: Responsive.isMobile(context) ? 5 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(28),
                    child: Text(
                      "Login to your Account",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: appPadding, vertical: 5),
                    child: Text("See what is going on with your business",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),),
                  ),
                  // GoogleSignInOption(),
                  // authOptionText(),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      buildTextField(Icon(Icons.mail), "Enter your email",(value){}),
                      buildTextField(Icon(Icons.lock), "Enter your password",(value){}),

                      Padding(
                        padding:  EdgeInsets.symmetric(
                            vertical: appPadding - 2, horizontal: appPadding),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeView()));
                          },
                          child: reusableButton(text: "Sign In", isPrimary: true)
                        ),
                      ),

                      InkWell(
                          onTap: toggleFunc,
                          child: Text("Register Police Station",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),))
                    ],
                  )
                  // buildButton("Register", () {}, false),
                ],
              ),
            ),
          ),
        )
    );
  }
}
