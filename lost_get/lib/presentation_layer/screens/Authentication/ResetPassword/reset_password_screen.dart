import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/widgets/authentication_widget.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/controller_validators.dart';
import 'package:lost_get/presentation_layer/widgets/text_field.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = '/reset_password';
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeThemeMode>();
    PreferredSizeWidget? appBar = AppBar(
      iconTheme: IconThemeData(
        color: provider.isDarkMode()
            ? Colors.white
            : Colors.black, //change your color here
      ),
      centerTitle: true,
    );
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: (MediaQuery.sizeOf(context).height -
                      appBar.preferredSize.height) *
                  0.9,
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13.h,
                    ),
                    headingText(context, "Reset Password"),
                    SizedBox(height: 3.h),
                    Text(
                      "Enter your email adddress. The reset link will be mailed to you!",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InputTextField(
                        controller: _emailAddressController,
                        textHint: "Your Email Address",
                        title: "Email",
                        imageUrl: 'assets/icons/mail.svg',
                        validatorFunction: (value) =>
                            ControllerValidator.validateEmailAddress(value)),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CreateButton(
                            handleButton: () {
                              if (_formKey.currentState!.validate()) {
                                FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _emailAddressController.text)
                                    .then((value) {
                                  createToast(
                                      description:
                                          "Reset Link has been mailed!");
                                });
                              }
                            },
                            title: "Reset Password"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
