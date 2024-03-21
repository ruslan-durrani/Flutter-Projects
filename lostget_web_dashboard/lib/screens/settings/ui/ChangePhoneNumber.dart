import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';

class ChangePhoneNumber extends StatefulWidget {
  @override
  _ChangePhoneNumberState createState() =>
      _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  late String _phoneNumber;
  late String _verificationCode;

  FirebaseAuth _auth = FirebaseAuth.instance;
  late UserCredential _userCredential;

  bool _isCodeSent = false;
  var numberController = TextEditingController();
  var numberSMSController = TextEditingController();
  Future<void> _verifyPhoneNumber() async {

    await _auth.verifyPhoneNumber(
      phoneNumber: numberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Success;");
        if(credential.smsCode==_verificationCode){
          print("Confirms");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          toasterFlutter('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isCodeSent = true;
          toasterFlutter("A verification code has been sent to you");
        });
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _verificationCode);
        print(credential.verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      if(numberController.text.isNotEmpty){

      }
      FirebaseAuth auth = FirebaseAuth.instance;
      ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+44 7123 123 456');
    } catch (e) {
      print('Error: $e');
    }
    toasterFlutter("Phone number updated successfully");
    setState(() {
      _isCodeSent = false;
      numberController.clear();
      numberSMSController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            controller: numberController,
            onChanged: (value) {
              setState(() {
                _phoneNumber = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
            ),
          ),
          SizedBox(height: 10),
          if (_isCodeSent)
            TextField(
              controller: numberSMSController,
              keyboardType: TextInputType.number,
              // onChanged: (value) {
              //   setState(() {
              //     _verificationCode = value;
              //   });
              // },
              decoration: InputDecoration(
                hintText: 'Enter the SMS code',
              ),
            ),
          SizedBox(height: 10),
          GestureDetector(onTap: _isCodeSent
              ? () {
            _signInWithPhoneNumber();
          }
              : () {
            _verifyPhoneNumber();
          },
          child: reusableButton(text:_isCodeSent ? 'Update Phone Number' : 'Verify Phone Number', isPrimary: true),
          ),

        ],
      ),
    );
  }
}