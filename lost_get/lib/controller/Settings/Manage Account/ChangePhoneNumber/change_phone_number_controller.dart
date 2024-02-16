import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../data_store_layer/repository/users_repository.dart';
import '../../../../models/user_profile.dart';

class ChangePhoneNumberController {
  final UserRepository _userRepo = UserRepository();
  final _auth = FirebaseAuth.instance;
  static String verificationCode = "";

  getPhoneNumber(String phoneNumber) {
    PhoneNumber number =
        PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
    return number.number;
  }

  getUserPhoneNumber() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid != null) {
        UserProfile? userProfile = await _userRepo.getUserDetails(uid);
        String? phoneNumber = userProfile!.phoneNumber;
        return phoneNumber;
      }
    } catch (e) {}
  }

  getPhoneIsoCountry(String phoneNumber) {
    PhoneNumber number =
        PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
    return number.countryISOCode;
  }

  updatePhoneNumber(String newPhoneNumber, String oldPhoneNumber) {
    Map<String, dynamic> newMap = {};
    if (oldPhoneNumber != newPhoneNumber && newPhoneNumber != null) {
      newMap['phoneNumber'] = newPhoneNumber;
    }
  }

  Future<void> phoneNumberVerification(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) async {
        verificationCode = verificationId;
      },
      codeAutoRetrievalTimeout: ((verificationId) {
        verificationCode = verificationId;
      }),
    );
  }

  Future<bool> verifyOtp(String otp) async {
    bool result = false;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otp);
      final currentUser = _auth.currentUser;
      await currentUser!.linkWithCredential(credential).then((value) async {
        if (value.user?.phoneNumber != null) {
          result = await storePhoneNumberInFirestore();
        }
      });
    } catch (e) {}

    return result;
  }

  Future<bool> storePhoneNumberInFirestore() async {
    try {
      User currentUser = _auth.currentUser!;

      if (currentUser.phoneNumber != null) {
        final String phoneNumber = currentUser.phoneNumber!;
        await currentUser.unlink('phone');

        _userRepo.updateUserData(currentUser.uid, {'phoneNumber': phoneNumber});

        return true;
      } else {
        return false;
      }
    } catch (e) {}
    return false;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkPhoneNumberExists(
      String phoneNumber) async {
    Query<Map<String, dynamic>> documents =
        _userRepo.isNumberExists(phoneNumber);
    return await documents.get();
  }
}
