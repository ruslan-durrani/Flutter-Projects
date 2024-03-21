import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_admin_dashboard/screens/users_management/models/userProfile.dart';

import '../../../global/services/firebase_service.dart';
import '../../../global/services/firestore_service.dart';
import '../../../global/widgets/toastFlutter.dart';
import '../../authentication/widgets/showVerificationMessage.dart';

class AdminRegister{
  String? name;
  String? email;
  String? gender;
  String? password;
  AdminRegister(this.gender,{this.name,this.email,this.password});
}
class AdminController{
  static handleRegistration(AdminRegister admin) async {
    try {

      // final adminProfile = UserProfile(fullName: admin.name, email: admin.email, isAdmin: true, joinedDateTime: DateTime.now(), phoneNumber: "", biography: "Admin", preferenceList: {}, imgUrl: "", dateOfBirth: "", gender: admin.gender, password: admin.password);
      UserCredential? credentialObject = await FirebaseService().registerAdmin(admin.email!,admin.password!);
      if (credentialObject != null) {
        final adminProfile = UserProfile(fullName: admin.name, uid: credentialObject.user!.uid, email: admin.email, isAdmin: true, joinedDateTime: DateTime.now(), phoneNumber: "", biography: "", preferenceList: [], imgUrl: "", dateOfBirth: "", gender: admin.gender, userChatsList: []);
        await FireStoreService().createUserProfile(
          credentialObject.user!.uid,
          adminProfile.toMap(),
        );
        toasterFlutter("Admin Registered Successfully");
      }
      return true;
    } catch (e) {
      toasterFlutter("An error has occurred");
      return false;
    }
    }
  }
