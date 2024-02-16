part of 'sign_in_bloc.dart';

class SignInState {
  final String email;
  final String password;
  bool isHidden;

  SignInState({this.email = '', this.password = '', this.isHidden = true});

  SignInState copyWith({String? email, String? password, bool? isHidden}) {
    return SignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        isHidden: isHidden ?? this.isHidden);
  }
}

class SignInActionState extends SignInState {}

class RegisterButtonClickedState extends SignInActionState {}

class LoginButtonErrorState extends SignInActionState {
  final String message;

  LoginButtonErrorState(this.message);
}

class LoginButtonLoadingState extends SignInActionState {}

class LoginButtonSuccessState extends SignInActionState {}
