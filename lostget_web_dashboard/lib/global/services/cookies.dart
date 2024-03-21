
import 'dart:html' as html;

import 'package:responsive_admin_dashboard/constants/global_const_variables.dart';
class CookieStorage{

  void storeTokenInCookie(String token) {
    final expireDate = DateTime.now().add(Duration(days: 30));
    // Create the cookie string
    final cookieString = "$USER_CUSTOM_TOKEN=$token; expires=${expireDate.toUtc()}";
    // Store the cookie
    html.document.cookie = cookieString;
  }
  void removeCookie(String cookieName) {
    // Set the cookie's expiration date to a past date
    final expiredDate = DateTime.utc(1970);
    // Create a cookie string to expire the cookie
    final cookieString = "$cookieName=; expires=${expiredDate.toUtc()}";
    // Set the cookie with an expired date
    html.document.cookie = cookieString;
  }
  String? getTokenFromCookie() {
    final cookies = html.document.cookie;
    final cookieList = cookies?.split(';');
    for (final cookie in cookieList!) {
      final parts = cookie.split('=');
      if (parts.length == 2) {
        final name = parts[0].trim();
        final value = parts[1].trim();

        if (name == USER_CUSTOM_TOKEN) {
          return value;
        }
      }
    }

    return null; // Token not found in cookies
  }
}

void main() {
  final cookieInstance = CookieStorage();
  cookieInstance.storeTokenInCookie("dasd76a8sdhbasd");
  String? customToken = cookieInstance.getTokenFromCookie();
  if (customToken != null && customToken != "") {
    print("Custom token: $customToken");
  } else {
    print("Custom token not found in cookies.");
  }
  cookieInstance.removeCookie("custom_token");
}