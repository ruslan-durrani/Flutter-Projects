

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/components/reusableButton.dart';
import 'package:lost_get_police_panel/views/auth_view/widgets/getLocation.dart';
import 'package:lost_get_police_panel/views/map_view/map_screen.dart';

import '../../components/buidlTextField.dart';
import '../../global/responsive.dart';
import '../../theme.dart';

class Register extends StatelessWidget {
  final VoidCallback toggleFunc;
  Register({super.key, required this.toggleFunc});

  TextEditingController policeStationName = TextEditingController();
  TextEditingController policeStationEmail = TextEditingController();
  TextEditingController policeStationPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    GeoPoint geoPoint = GeoPoint(0, 0);
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(28),
                      child: Text(
                        "Register Police Station",
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
                        buildTextField(Icon(Icons.quora), "Enter Police Station Name",(value)=>policeStationName.text=value),
                        buildTextField(Icon(Icons.mail), "Enter your email",(value)=>policeStationEmail.text=value),
                        buildTextField(Icon(Icons.lock), "Enter your password",(value)=>policeStationPassword.text=value),
                
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: appPadding * .3, horizontal: appPadding),
                          child: GestureDetector(
                              onTap: () async {
                                await getCurrentLocation().then((value){
                                  geoPoint = GeoPoint(value.coords!.latitude as double,value.coords!.longitude as double);
                                });
                              },
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      final json = Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()));
                                      print(json);
                                    },
                                    child:reusableButton(text: "Fetch Location", isPrimary: false),
                                  ),
                                  geoPoint.longitude != 0?Text("Location Fetch ✅ 🎉 (${geoPoint.latitude},${geoPoint.longitude})",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal, color: Colors.green),):Container(),
                                ],
                              ),
                          ),
                        ),Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: appPadding - 2, horizontal: appPadding),
                          child: GestureDetector(
                              onTap: () async {

                                // Register
                                //TODO check email if it exists already in Users model?
                                //TODO check email if it exists already in Police Station model?
                                //TODO if not exists allow police station to register?

                                // Login
                                //TODO check email if it exists already in Users model?
                                //TODO check email if it exists in Police Station model?
                                //TODO if exists and verified do login.
                                //TODO if exists and not verified do not login.

                              },
                              child: reusableButton(text: "Register", isPrimary: true)
                          ),
                        ),
                
                        InkWell(
                            onTap: toggleFunc,
                            child: Text("Already User? Login",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),))
                      ],
                    )
                    // buildButton("Register", () {}, false),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
