import 'package:lost_get/common/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }

  Future<bool> setString(String key, String value) async {
    print(("In preference id $value"));
    return await _prefs.setString(key, value);
  }

  String? getTokenId() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY);
  }

  Future<bool> removeTokenId() async {
    // ignore: unrelated_type_equality_checks

    bool tokenRemoved =
        await _prefs.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    return tokenRemoved == true ? true : false;
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int? getDarkMode() {
    return _prefs.getInt(AppConstants.DARK_THEME);
  }
}
