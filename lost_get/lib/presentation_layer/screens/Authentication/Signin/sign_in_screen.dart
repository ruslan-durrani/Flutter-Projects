import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/controller/Authentication/sign_in_controller.dart';
import 'package:lost_get/presentation_layer/screens/Authentication/SignUp/sign_up_screen.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/password_field.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import '../../../../business_logic_layer/Authentication/Signin/bloc/sign_in_bloc.dart';
import '../../../widgets/authentication_widget.dart';
import '../../../widgets/controller_validators.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/text_field.dart';
import '../../Dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SignInBloc signinBloc = SignInBloc();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int loginButtonClickCount = 0;

  void _handleLoginForSocialMedia(String type) {
    SignInController().handleSignIn(context, type, signinBloc,
        _emailAddressController, _passwordController);
  }

  void _handleLoginForEmail() {
    try {
      if (formKey.currentState!.validate()) {
        loginButtonClickCount++;
        SignInController().handleSignIn(context, 'email', signinBloc,
            _emailAddressController, _passwordController);
      }
    } catch (e) {
      signinBloc.add(LoginButtonErrorEvent("Can't Login, Please try again!"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      bloc: signinBloc,
      listener: (context, state) {
        if (state is RegisterButtonClickedState) {
          Navigator.pushNamed(context, SignUp.routeName);
        }

        if (state is LoginButtonLoadingState) {
          showCustomLoadingDialog(context, "Logging In...");
        }
        if (state is LoginButtonSuccessState) {
          hideCustomLoadingDialog(context);
          Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
        }

        if (state is LoginButtonErrorState) {
          hideCustomLoadingDialog(context);
          createToast(description: state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText(context, "Login"),
                      SizedBox(
                        height: 18.h,
                      ),
                      InputTextField(
                          controller: _emailAddressController,
                          textHint: "Your Email Address",
                          title: "Email",
                          imageUrl: 'assets/icons/mail.svg',
                          validatorFunction: (value) =>
                              ControllerValidator.validateEmailAddress(value)),
                      SizedBox(
                        height: 9.h,
                      ),
                      BlocBuilder<SignInBloc, SignInState>(
                        bloc: signinBloc,
                        builder: (context, state) {
                          return PasswordField(
                              textHint: "Enter Password",
                              title: "Password",
                              imageUrl: 'assets/icons/lock.svg',
                              isHidden: state.isHidden,
                              toggleEye: () {
                                signinBloc.add(EyeToggleViewClickedEvent());
                              },
                              controller: _passwordController,
                              handleValidator: (value) => ControllerValidator
                                  .validateLogInPasswordField(value));
                        },
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      createCheckboxNecessaryItems(context),
                      SizedBox(
                        height: 30.h,
                      ),
                      CreateButton(
                        title: 'Login',
                        handleButton: () => _handleLoginForEmail(),
                      ),
                      SizedBox(
                        height: 29.h,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          )),
                          Text(
                            'or continue with',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () =>
                                    _handleLoginForSocialMedia('google'),
                                child: SvgPicture.asset(
                                    'assets/icons/google_logo.svg')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      createRichTextForLoginSignUp(
                          context,
                          'Don\'t have an account? ',
                          'Register Now',
                          () => signinBloc.add(RegisterButtonClickedEvent())),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
