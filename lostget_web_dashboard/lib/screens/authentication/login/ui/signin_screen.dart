import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/authentication/auth_controllers/controller.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';
import 'package:slider_captcha/slider_captcha.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/responsive.dart';
import '../../../../global/widgets/title_text.dart';
import '../../../../global/widgets/widgets.dart';
import '../../widgets/common_auth.dart';
import '../bloc/login_bloc.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  bool captchaCheckbox = false;
  SliderController controller = SliderController();
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 10 : 40,
            horizontal: Responsive.isMobile(context) ? 5 : 100),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(),
                  Padding(
                    padding: EdgeInsets.all(appPadding),
                    child: Text(
                      "Login to your Account",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: appPadding, vertical: 5),
                    child: Text("See what is going on with your business"),
                  ),
                  // GoogleSignInOption(),
                  // authOptionText(),
                  SizedBox(height: 10,),
                  BlocBuilder(bloc: loginBloc, builder: (context, state)  {
                    return Column(
                      children: [
                        buildTextField(
                            Icon(Icons.mail), "Enter your email", (value) {
                          loginBloc.add(LoginEmailOnChangeEvent(value));
                        }),
                        buildTextField(
                            Icon(Icons.lock, color: textColor), "Enter your password",
                                (value) {
                              loginBloc.add(LoginPasswordOnChangeEvent(value));
                            },
                            isObscure: loginBloc.state.isHidden,
                            suffixIcon: InkWell(
                              onTap: () {
                                loginBloc.add(LoginHiddenOnClickEvent(
                                    !loginBloc.state.isHidden));
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                                color: textColor,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: appPadding - 2, horizontal: appPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  bool answer = await  FirebaseService().passwordReset(loginBloc.state.email);
                                  if(answer){
                                    showDialog(context: context, builder: (_){
                                      return AlertDialog(
                                          icon: Image.asset("./assets/icons/reset.png",  height: 100,),
                                          title: SizedBox(width:50,child: getTitle("Reset email has been sent to you on ${loginBloc.state.email}")),
                                          buttonPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await FirebaseService().passwordReset(loginBloc.state.email);
                                                  await toasterFlutter("Email Sent");
                                                },
                                                child: reusableButton(text: "Resend Email", isPrimary: true),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: reusableButton(text: "Close", isPrimary: false),
                                              ),
                                            ],
                                          )
                                      );
                                    });
                                  }
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              // Checkbox(value: loginBloc.state.captchaResult, onChanged: (value){
                              //   if(value != null){
                              //     print(value);
                              //     loginBloc.add(CaptchaOnClickEvent((value)));
                              //   }
                              //
                              // }),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  BlocBuilder<LoginBloc, LoginState>(
                      bloc: loginBloc,
                    builder: (context, state) {
                      return buildButton("Sign In", () {
                        AuthController.handleLogin(context);
                      }, true);
                    },
                  ),
                  // buildButton("Register", () {}, false),
                ],
              ),
            ),
            BlocBuilder<LoginBloc,LoginState>(
              bloc: loginBloc,
                builder: (context,state){
              return Container(
                alignment: Alignment.center,
                color: Colors.white70,
                child: state.captchaResult?Dialog(
                  elevation: .2,
                  backgroundColor: Colors.white70,
                  child: Container(
                    width: 500,
                    child: SliderCaptcha(
                      titleStyle: TextStyle(color: Colors.white),
                      controller: controller,
                      imageToBarPadding: 20,
                      captchaSize: 30,
                      image: Container(
                        width: 300,
                        child: Image.asset(
                          './assets/images/recaptcha.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      colorBar: primaryColor,
                      colorCaptChar: Colors.white,
                      onConfirm: (controller) async {
                        if(controller != state.captchaResult){
                          loginBloc.add(CaptchaOnClickEvent(!controller));
                        }
                      },
                    ),
                  ),):Container(),
              );
            })
          ],
        ),
      ),
    );
  }
}
