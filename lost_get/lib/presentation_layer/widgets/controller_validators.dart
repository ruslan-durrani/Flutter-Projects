class ControllerValidator {
  static String? validateEmailAddress(String value) {
    if (value.isEmpty) {
      return 'Email field is empty';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return "Email is not correct";
    }
    return null;
  }

  static String? validateLogInPasswordField(String value) {
    if (value.isEmpty) {
      return 'Password field is empty';
    }
    return null;
  }

  static String? validateFullNameField(String value) {
    bool hasThreeOrMoreLowercase = RegExp(r'[a-zA-Z]{3,}').hasMatch(value);
    bool hasNumbers = RegExp(r'[0-9]').hasMatch(value);

    if (hasNumbers) {
      return 'Name can\'t contain numbers';
    } else if (!hasThreeOrMoreLowercase) {
      return 'Name must contain 3 characters';
    }
    return null;
  }
}
