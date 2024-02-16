import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'change_phone_number_verified_state.dart';

class ChangePhoneNumberVerifiedCubit
    extends Cubit<ChangePhoneNumberVerifiedState> {
  ChangePhoneNumberVerifiedCubit() : super(ChangePhoneNumberVerifiedInitial());

  void navigateToMainMenu(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
