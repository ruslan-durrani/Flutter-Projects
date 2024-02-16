import 'package:flutter/material.dart';

class PasswordStrengthProvider extends ChangeNotifier {
  String _password = '';
  double _strength = 0;
  String _displayText = '';
  bool _isHidden = true;
  bool _newPasswordHidden = true;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  RegExp specReg = RegExp(r"[^A-Za-z0-9]");
  RegExp upperReg = RegExp(r"[A-Z]");

  void checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      _strength = 0;
      _displayText = 'Password Field Is Empty';
    } else if (_password.length < 5) {
      _strength = 1 / 4;
      _displayText = 'Weak Password';
    } else if (_password.length < 8) {
      _strength = 2 / 4;
      _displayText = 'Acceptable Password';
    } else {
      if (!letterReg.hasMatch(_password) ||
          !numReg.hasMatch(_password) ||
          !specReg.hasMatch(_password) ||
          !upperReg.hasMatch(_password)) {
        _strength = 3 / 4;
        _displayText = 'Strong Password';
      } else {
        _strength = 1;
        _displayText = 'Very Strong Password';
      }
    }
    notifyListeners();
  }

  void setIsHidden() {
    _isHidden = !isHidden;
    notifyListeners();
  }

  void setNewIsHidden() {
    _newPasswordHidden = !_newPasswordHidden;
    notifyListeners();
  }

  void resetValues() {
    _strength = 0;
    _displayText = '';
    _isHidden = true;
    _password = '';
    notifyListeners();
  }

  get strength => _strength;
  get displayText => _displayText;
  get isHidden => _isHidden;
  get newIsHidden => _newPasswordHidden;
}
