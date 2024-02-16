part of 'sign_up_bloc.dart';

class SignUpState {}

class SignUpActionState extends SignUpState {}

class LoginNowButtonClickedState extends SignUpActionState {}

class NavigateToEmailVerificationState extends SignUpActionState {
  final UserCredential userCredential;

  NavigateToEmailVerificationState(this.userCredential);
}

class RegisterButtonClickedLoadingState extends SignUpActionState {}

class RegisterButtonErrorState extends SignUpActionState {
  final String errorMsg;

  RegisterButtonErrorState(this.errorMsg);
}
