import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:lost_get/presentation_layer/screens/Authentication/Signin/sign_in_screen.dart';

import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

import '../../../../business_logic_layer/Authentication/Verification/bloc/email_verification_bloc.dart';
import '../../../widgets/authentication_widget.dart';

class EmailVerification extends StatefulWidget {
  static const routeName = '/email_verification';
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  int _remainingSeconds = 0;
  late Timer _timer;
  final EmailVerificationBloc _emailVerificationBloc = EmailVerificationBloc();

  final User? _userCredential = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        _emailVerificationBloc.add(EmailVerifiedEvent());
        timer.cancel();
      }
    });

    super.initState();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _emailVerificationBloc.add(CountDownTimerEvent(_remainingSeconds));
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel;
    super.dispose();
  }

  Future<void> handleButton() async {
    _remainingSeconds = 30;
    startCountdown();
    _emailVerificationBloc.add(ResendVerificationEmailClickedEvent());
    await _userCredential!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationBloc, EmailVerificationState>(
      bloc: _emailVerificationBloc,
      listener: (context, state) {
        if (state is ResendVerificationEmailClickedState) {
          createToast(
              description:
                  "Confirmation email has been re-sent. Please check you mail.");
        }
        if (state is EmailVerifiedState) {
          createToast(
              description: "Email has been verified. You can login now");
          Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                child: SvgPicture.asset(
                  'assets/icons/verification.svg',
                  width: 30.w,
                  height: 30.h,
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              headingText(context, 'Check Your Mail'),
              SizedBox(
                height: 9.h,
              ),
              RichText(
                text: TextSpan(
                    text: "We've sent an email confirmation code to ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                          text: "${_userCredential!.email}. ",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text:
                              "Check you email and click on the confirmation link to continue.")
                    ]),
              ),
              SizedBox(
                height: 18.h,
              ),
              Text(
                "Didn't receive verification message?",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
                bloc: _emailVerificationBloc,
                builder: (context, state) {
                  if (state is CountDownTimerState &&
                      state.remainingSeconds > 0) {
                    return CreateButton(
                      title: 'Please Wait ${state.remainingSeconds}',
                      handleButton: null,
                    );
                  }
                  return CreateButton(
                      title: "Resend Verification Email",
                      handleButton: handleButton);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
