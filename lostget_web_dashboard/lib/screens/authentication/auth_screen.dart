import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/global/widgets/title_text.dart';
import 'package:responsive_admin_dashboard/screens/authentication/login/ui/signin_screen.dart';
import 'package:responsive_admin_dashboard/screens/authentication/widgets/common_auth.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';

import '../../global/widgets/widgets.dart';

class Authentication extends StatefulWidget {
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !Responsive.isDesktop(context)
            ? Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SignIn(),
                  ),
                ],
              )
            : Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(80),
                        color: primaryColor,
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // PageView(
                                //   children: <Widget>[
                                //     Container(
                                //       alignment: Alignment.center,
                                //       child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(vertical: appPadding),
                                //             child: ListTile(
                                //               title: Text(
                                //                 "Welcome to LostGet!",
                                //                 textAlign: TextAlign.center,
                                //                 style: TextStyle(
                                //                     fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
                                //               ),
                                //               subtitle: Container(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 width: 50,
                                //                 child: Text(
                                //                   "Simplifying lost and found - LostGet, your AI-powered solution.",
                                //                   textAlign: TextAlign.center,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //               height: 230,
                                //               width: 250,
                                //               child: Lottie.network("https://lottie.host/86573f1e-f6dd-4282-af3f-cb34d65724ad/poFwVvYZsf.json")),
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       alignment: Alignment.center,
                                //       child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(vertical: appPadding),
                                //             child: ListTile(
                                //               title: Text(
                                //                 "Welcome to LostGet!",
                                //                 textAlign: TextAlign.center,
                                //                 style: TextStyle(
                                //                     fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
                                //               ),
                                //               subtitle: Container(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 width: 50,
                                //                 child: Text(
                                //                   "Simplifying lost and found - LostGet, your AI-powered solution.",
                                //                   textAlign: TextAlign.center,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //               height: 230,
                                //               width: 250,
                                //               child: Lottie.network("https://lottie.host/2ea0b8c3-5367-4347-ad7f-142e5f6b4a41/jgcNK5oXV4.json")),
                                //         ],
                                //       ),
                                //     ),
                                //     // Add more pages if needed
                                //   ],
                                //   // PageView Properties
                                //   // You can customize these properties as needed
                                //   scrollDirection: Axis.horizontal,
                                //   pageSnapping: true,
                                //   onPageChanged: (int page) {
                                //     // Handle page change if needed
                                //   },
                                // )

                                CarouselSlider(
                                  items: [
                                    Container(
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: appPadding),
                                            child: ListTile(
                                              title: Text(
                                                "Welcome to LostGet!",
                                                textAlign:TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              subtitle: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                width: 50,
                                                child: Text("Simplifying lost and found - LostGet, your AI-powered solution.",textAlign:TextAlign.center,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 230,
                                              width: 250,
                                              child: Image.asset("./images/auth1.png")
                                          )
                                              // child: Lottie.network("https://lottie.host/86573f1e-f6dd-4282-af3f-cb34d65724ad/poFwVvYZsf.json"))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: appPadding),
                                            child: ListTile(
                                              title: Text(
                                                "Getting Started!",
                                                textAlign:TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              subtitle: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                width: 50,
                                                child: Text("Begin your LostGet journey by creating a personalized account, enabling you to report lost items or assist in finding them.",textAlign:TextAlign.center,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 230,
                                              width: 250,
                                          child: Image.asset("./images/auth2.png")
                                          ),
                                          //     child: Lottie.network("https://lottie.host/2ea0b8c3-5367-4347-ad7f-142e5f6b4a41/jgcNK5oXV4.json"))
                                              // child: Lottie.network("https://lottie.host/2ea0b8c3-5367-4347-ad7f-142e5f6b4a41/jgcNK5oXV4.json"))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: appPadding),
                                            child: ListTile(
                                              title: Text(
                                                "How to Use LostGet?",
                                                textAlign:TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              subtitle: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                width: 50,
                                                child: Text("Easily navigate the process of reporting lost belongings with step-by-step guidance and AI assistance, ensuring accurate and efficient submissions.",textAlign:TextAlign.center,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 230,
                                              width: 250,
                                              child: Image.asset("./images/auth3.png")
                                          ),
                                          //     child: Lottie.network("https://lottie.host/2ea0b8c3-5367-4347-ad7f-142e5f6b4a41/jgcNK5oXV4.json"))
                                          // child: Lottie.network("https://lottie.host/2ea0b8c3-5367-4347-ad7f-142e5f6b4a41/jgcNK5oXV4.json"))
                                        ],
                                      ),
                                    ),
                                  ],

                                  //Slider Container properties
                                  options: CarouselOptions(
                                    height: 380.0,
                                    enlargeCenterPage: false,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    viewportFraction: 0.8,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          decoration: BoxDecoration(), child: SignIn()),
                    ),
                  ],
                ),
              ));
  }
}
