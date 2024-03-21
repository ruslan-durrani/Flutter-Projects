part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}
class LoginEmailOnChangeEvent extends LoginEvent{
  final String  email;
  LoginEmailOnChangeEvent(this.email);
}
class LoginPasswordOnChangeEvent extends LoginEvent{
  final String  password;
  LoginPasswordOnChangeEvent(this.password);
}
class LoginHiddenOnClickEvent extends LoginEvent{
  final bool  isHidden;
  LoginHiddenOnClickEvent(this.isHidden);
}

class CaptchaOnClickEvent extends LoginEvent{
  final bool  captchaResult;
  CaptchaOnClickEvent(this.captchaResult);
}
