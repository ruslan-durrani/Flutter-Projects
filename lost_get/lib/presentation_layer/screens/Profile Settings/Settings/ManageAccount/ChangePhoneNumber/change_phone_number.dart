import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lost_get/controller/Settings/Manage%20Account/ChangePhoneNumber/change_phone_number_controller.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/ManageAccount/ChangePhoneNumber/ChangePhoneNumberVerification/change_phone_number_verification.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import '../../../../../../business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/bloc/change_phone_number_bloc.dart';
import '../../../../../../business_logic_layer/Provider/change_theme_mode.dart';
import '../../../../../../common/constants/colors.dart';
import '../../../../../widgets/authentication_widget.dart';
import '../../../../../widgets/custom_dialog.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({super.key});
  static const routeName = '/change_phone_number';
  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final ChangePhoneNumberBloc _changePhoneNumberBloc = ChangePhoneNumberBloc();
  final ChangePhoneNumberController _changePhoneNumberController =
      ChangePhoneNumberController();
  final formKey = GlobalKey<FormState>();

  String? _completePhoneNumber;
  String? _oldPhoneNumber;

  @override
  void initState() {
    _changePhoneNumberBloc.add(AcquirePhoneNumberEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeThemeMode>();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: provider.isDarkMode()
                ? Colors.white
                : Colors.black, //change your color here
          ),
          centerTitle: true,
        ),
        body: BlocListener<ChangePhoneNumberBloc, ChangePhoneNumberState>(
          bloc: _changePhoneNumberBloc,
          listenWhen: (previous, current) =>
              current is ChangePhoneNumberActionState,
          listener: (context, state) {
            if (state is ContinueButtonClickedErrorState) {
              hideCustomLoadingDialog(context);
              createToast(description: state.errorMsg);
              _changePhoneNumberBloc.add(ButtonReleasedEvent());
            }

            if (state is ContinueButtonClickedLoadingState) {
              showCustomLoadingDialog(context, "Please Wait...");
            }

            if (state is ContinueButtonClickedState) {
              hideCustomLoadingDialog(context);
              Navigator.pushNamed(
                      context, ChangePhoneNumberVerificationScreen.routeName,
                      arguments: _completePhoneNumber)
                  .then((value) {
                _completePhoneNumber = null;
                _oldPhoneNumber = null;
                _changePhoneNumberBloc.add(AcquirePhoneNumberEvent());
              });
            }
          },
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13.h,
                    ),
                    headingText(context, "Change Phone"),
                    headingText(context, "Number"),
                    SizedBox(height: 3.h),
                    Text(
                      "Enter your phone number. We'll send you a 4 digit verification code.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Text(
                      "Phone Number",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    BlocBuilder<ChangePhoneNumberBloc, ChangePhoneNumberState>(
                      buildWhen: (previous, current) =>
                          current is! ChangePhoneNumberActionState,
                      bloc: _changePhoneNumberBloc,
                      builder: (context, state) {
                        if (state is AcquirePhoneNumberErrorState) {
                          hideCustomLoadingDialog(context);
                          createToast(description: state.errorMsg);
                        }
                        if (state is AcquirePhoneNumberLoadingState) {}

                        if (state is AcquirePhoneNumberSuccessState) {
                          setControllers(state.phoneNumber);
                          _oldPhoneNumber = state.phoneNumber;

                          return IntlPhoneField(
                            controller: _phoneNumberController,
                            onChanged: (value) =>
                                _completePhoneNumber = value.completeNumber,
                            initialCountryCode: state.isoCountryCode,
                            dropdownTextStyle:
                                Theme.of(context).textTheme.bodySmall,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            const SpinKitFadingCircle(
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ],
                        );
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CreateButton(
                          title: 'Continue',
                          handleButton: () {
                            if (formKey.currentState!.validate()) {
                              if (_completePhoneNumber != null &&
                                  _completePhoneNumber != _oldPhoneNumber) {
                                _changePhoneNumberBloc.add(
                                    ContinueButtonClickedEvent(
                                        _completePhoneNumber!));
                              } else {
                                createToast(
                                    description:
                                        "Please Update the fields to make changes.");
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void setControllers(String? phoneNumber) {
    if (phoneNumber != "" && phoneNumber != null) {
      _phoneNumberController.text =
          _changePhoneNumberController.getPhoneNumber(phoneNumber);
    } else {
      _phoneNumberController.text = '';
    }
  }
}
