import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Authentication/Signup/bloc/sign_up_bloc.dart';

import 'package:lost_get/presentation_layer/screens/Authentication/SignUp/email_verification_screen.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/controller_validators.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import '../../../../business_logic_layer/Provider/password_validator_provider.dart';
import '../../../../common/constants/colors.dart';
import '../../../../controller/Authentication/sign_up_controller.dart';
import '../../../widgets/authentication_widget.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpBloc signUpBloc = SignUpBloc();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSignUp(strength) {
    if (formKey.currentState!.validate() && strength >= 2 / 4) {
      print("indies");
      SignUpController().handleSignUp(_fullNameController,
          _emailAddressController, _passwordController, signUpBloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PasswordStrengthProvider>();

    return BlocListener<SignUpBloc, SignUpState>(
      bloc: signUpBloc,
      listener: (context, state) {
        if (state is LoginNowButtonClickedState) {
          provider.resetValues();
          Navigator.of(context).pop();
        }

        if (state is RegisterButtonErrorState) {
          hideCustomLoadingDialog(context);
          createToast(description: state.errorMsg);
        }

        if (state is RegisterButtonClickedLoadingState) {
          showCustomLoadingDialog(context, "Registering....");
        }

        if (state is NavigateToEmailVerificationState) {
          provider.resetValues();
          hideCustomLoadingDialog(context);
          Navigator.popAndPushNamed(
            context,
            EmailVerification.routeName,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            iconSize: 24,
            icon: SvgPicture.asset(
              'assets/icons/onBack.svg',
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText(context, 'Sign Up'),
                      SizedBox(
                        height: 18.h,
                      ),
                      InputTextField(
                        textHint: 'Enter Full Name',
                        title: 'Full Name',
                        imageUrl: 'assets/icons/profile.svg',
                        controller: _fullNameController,
                        validatorFunction: (value) =>
                            ControllerValidator.validateFullNameField(value),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      InputTextField(
                        textHint: 'Enter Email',
                        title: 'E-mail',
                        imageUrl: 'assets/icons/mail.svg',
                        controller: _emailAddressController,
                        validatorFunction: (value) =>
                            ControllerValidator.validateEmailAddress(value),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      PasswordField(
                        textHint: 'Enter Password',
                        title: 'Password',
                        imageUrl: 'assets/icons/lock.svg',
                        isHidden: provider.isHidden,
                        toggleEye: () {
                          provider.setIsHidden();
                        },
                        handleOnChange: (value) =>
                            provider.checkPassword(value),
                        controller: _passwordController,
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      LinearProgressIndicator(
                        value: provider.strength,
                        backgroundColor: Colors.grey[300],
                        color: provider.strength <= 1 / 4
                            ? Colors.red
                            : provider.strength == 2 / 4
                                ? Colors.yellow
                                : provider.strength == 3 / 4
                                    ? Colors.blue
                                    : Colors.green,
                        minHeight: 10,
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Text(
                        provider.displayText,
                        style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            color: provider.strength <= 1 / 4
                                ? Colors.red
                                : provider.strength <= 2 / 4
                                    ? Colors.yellow
                                    : provider.strength <= 3 / 4
                                        ? Colors.blue
                                        : Colors.green),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "By signing up you agree to our ",
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                  text: "Terms & Condition",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  )),
                              TextSpan(
                                  text: " and ",
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                  text: "Privacy Policy.*",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {})
                            ]),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CreateButton(
                          title: 'Register Now',
                          handleButton: () => _handleSignUp(provider.strength)),
                      SizedBox(
                        height: 65.h,
                      ),
                      createRichTextForLoginSignUp(
                          context, 'Already a member? ', 'Login', () {
                        signUpBloc.add(LoginNowButtonClickedEvent());
                      }),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
