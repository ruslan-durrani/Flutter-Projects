import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/global_const_variables.dart';

class SharedStorage{
  static late final SharedPreferences _preff;
  init()async{
    _preff = await SharedPreferences.getInstance();
  }
  static setIsLogin(bool value) async {
    await _preff.setBool(USER_LOGGED_IN, value);
  }
  static bool getIsLogin(){
    return _preff.getBool(USER_LOGGED_IN)??false;
  }

  static setUserToken(String string) async {
    await _preff.setString(USER_CUSTOM_TOKEN, string);
  }

  static getUserToken() {
    return _preff.getString(USER_CUSTOM_TOKEN);
  }


}