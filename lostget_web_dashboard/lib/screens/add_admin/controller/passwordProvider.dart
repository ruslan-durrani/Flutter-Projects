
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PasswordStrength {none, weak, medium, strong }
class PasswordProvider extends ChangeNotifier {
  RegExp number = RegExp(r'.*\d+.*');
  RegExp specialCharacter = RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]');
  RegExp letters = RegExp(r'[a-zA-Z]');
  PasswordStrength _strength = PasswordStrength.none;
  PasswordStrength get strength => _strength;
  resetPasswordStrength(){
    _strength = PasswordStrength.none;
    notifyListeners();
  }
  get getPasswordStrengthColor => strength==PasswordStrength.strong?Colors.green:strength==PasswordStrength.medium?Colors.blue:Colors.red;
  void setStrength(String value) {
    int strength = 0;
    if (value.isNotEmpty) {
      if (number.hasMatch(value)) {
        strength += 1;
      }
      if (specialCharacter.hasMatch(value)) {
        strength += 1;
      }
      if (letters.hasMatch(value)) {
        strength += 1;
      }
    }
    if (strength >= 3) {
      _strength = PasswordStrength.strong;
    } else if (strength >= 2) {
      _strength = PasswordStrength.medium;
    } else {
      _strength = PasswordStrength.weak;
    }
    notifyListeners();
  }
  String generateStrongPassword() {
    final String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    final String numbers = '0123456789';
    final String specialCharacters = '!@#\$%^&*()_+{}[]|:";<>,.?/~';

    final Random random = Random.secure();
    String password = '';

    // Add one character from each category
    password += uppercase[random.nextInt(uppercase.length)];
    password += lowercase[random.nextInt(lowercase.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += specialCharacters[random.nextInt(specialCharacters.length)];

    // Generate remaining characters
    for (int i = 4; i < 15; i++) {
      String allCharacters = uppercase + lowercase + numbers + specialCharacters;
      int randomIndex = random.nextInt(allCharacters.length);
      password += allCharacters[randomIndex];
    }

    // Shuffle the password to make it more secure
    List<String> passwordCharacters = password.split('');
    passwordCharacters.shuffle();
    password = passwordCharacters.join('');

    return password;
  }
}
