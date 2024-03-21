part of 'login_bloc.dart';

@immutable
class LoginState {
  final String email;
  final String password;
  final bool isHidden;
  final bool captchaResult;

  LoginState( {this.email="", this.password="", this.isHidden=true,this.captchaResult=false});
  LoginState copyWith({String? email, String? password, bool? isHidden, bool? captchaResult}){
    return LoginState(email:email??this.email, password:password??this.password, isHidden:isHidden??this.isHidden,captchaResult: captchaResult??this.captchaResult);
  }
}

class LoginActionState extends LoginState {}
class LoginEmailOnChangeState extends LoginActionState{}
class LoginPasswordOnChangeState extends LoginActionState{}
class LoginHiddenOnClickState extends LoginActionState{}
