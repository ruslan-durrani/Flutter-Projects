import 'dart:html';
import 'dart:js_interop';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_admin_dashboard/global/widgets/title_text.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';
import 'package:responsive_admin_dashboard/screens/users_management/models/userProfile.dart';
import 'package:responsive_admin_dashboard/screens/users_management/ui/data_table.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/responsive.dart';
import '../../../../global/services/firestore_service.dart';
import '../../../../global/widgets/toastFlutter.dart';
import '../../../my_profile/bloc/my_profile_bloc.dart';
import '../../../my_profile/edit_profile_bloc/edit_profile_bloc.dart';
import '../../widgets.dart';

class UserDetailsPage extends StatefulWidget {
  UserProfile userProfile;
  UserManagementOptions option;
  UserDetailsPage(this.userProfile, this.option);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Future<void> fillCurrentUserInfor(UserProfile myProfile) async {
    if (myProfile.gender == "") {
      controllerGender.dropDownValue =
          DropDownValueModel(name: "None", value: "None");
    } else {
      controllerGender.dropDownValue =
          DropDownValueModel(name: myProfile.gender!, value: myProfile.gender!);
    }
    controllerFullName.text = myProfile.fullName!;
    controllerDOB.text = myProfile.dateOfBirth!;
    controllerBio.text = myProfile.biography!;
    controllerEmail.text = myProfile.email!;
    if (myProfile.phoneNumber! == "") {
      controllerPhone.text = "PK";
    } else {
      controllerPhone.text = getPhoneNumber(myProfile.phoneNumber!).toString();
    }
  }

  TextEditingController controllerDOB = TextEditingController();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerBio = TextEditingController();
  SingleValueDropDownController controllerGender =
      SingleValueDropDownController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final myProfile = BlocProvider.of<MyProfileBloc>(context);
    final editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    final UserProfile userProfile = widget.userProfile;
    final UserManagementOptions userManagementOption = widget.option;
    fillCurrentUserInfor(userProfile);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: secondaryColor,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              getTitle("Dashboard")
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: appPadding * 3),
        child: Container(
          padding:
              EdgeInsets.all(Responsive.isMobile(context) ? 0 : appPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: BlocBuilder<EditProfileBloc, EditProfileStates>(
            bloc: editProfileBloc,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(appPadding),
                      child: Row(
                        children: [

                          Tooltip(
                            message:
                            "You can change your profile in LostGet Application",
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  userProfile.imgUrl != ""? userProfile.imgUrl!:
                                  userProfile.imgUrl == "" && userProfile.gender == ""
                                      ? genderImages["Male"]!
                                      : genderImages[userProfile.gender==""?"Male":userProfile.gender]??""
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          state == EditProfileStates.Edit
                              ? Container()
                              : InkWell(
                            onTap: () {
                              editProfileBloc.add(
                                  EditProfileButtonPressedEvent());
                            },
                            child: callEditButton(), 
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(appPadding),
                    child: Row(
                      children: [
                        Text(
                          "Basic Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Divider(
                                height: 2,
                                color: grey,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(appPadding),
                    child: Form(
                      key: _formKey,
                      child: Wrap(
                        spacing: appPadding * 2.5,
                        runSpacing: appPadding * 1.5,
                        children: [
                          Container(
                            width: 510,
                            child: TextFormField(
                              enabled: state == EditProfileStates.Edit
                                  ? true
                                  : false,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == "") {
                                  return "Your name is required";
                                } else {}
                              },
                              controller: controllerFullName,
                              onChanged: (value) {},
                              decoration: setInputDecoration(
                                  hintText: "Full Name",
                                  labelText: "Enter Your Name"),
                            ),
                          ),
                          Container(
                            width: 510,
                            child: TextFormField(
                              enabled: state == EditProfileStates.Edit
                                  ? true
                                  : false,
                              controller: controllerBio,
                              validator: (value) {},
                              onChanged: (value) {},
                              decoration: setInputDecoration(
                                  hintText: "Enter your bio description",
                                  labelText: "Bio"),
                            ),
                          ),
                          Container(
                            width: 510,
                            child: DropDownTextField(
                              controller: controllerGender,
                              textFieldDecoration: setInputDecoration(
                                labelText: "Gender",
                                hintText: "Gender",
                              ),
                              clearOption: true,
                              searchDecoration: const InputDecoration(
                                  hintText:
                                  "enter your custom hint text here"),
                              validator: (value) {
                                if (value == null) {
                                  return "Required field";
                                } else {
                                  return null;
                                }
                              },
                              dropDownItemCount:
                              state == EditProfileStates.Edit ? 3 : 0,
                              dropDownList: const [
                                DropDownValueModel(
                                    name: 'Male', value: "Male"),
                                DropDownValueModel(
                                  name: 'Female',
                                  value: "Female",
                                ),
                                DropDownValueModel(
                                  name: 'Other',
                                  value: "Other",
                                ),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                          Container(
                            width: 510,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              enabled: state == EditProfileStates.Edit
                                  ? true
                                  : false,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              controller: controllerDOB,
                              onChanged: (value) {
                                controllerDOB.text = value;
                              },
                              validator: (value) {
                                try {
                                  if (value == "")
                                    return "Your accurate DOB is required";
                                } catch (e) {
                                  return "Empty spaces or Wrong Format";
                                }
                              },
                              decoration: setInputDecoration(
                                labelText: "Date of Birth",
                                hintText: "MM/DD/YYYY",
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    DateTime? pickedDate =
                                    await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now());
                                    String formattedDate =
                                    DateFormat('dd/MM/yyyy')
                                        .format(pickedDate!);
                                    controllerDOB.text =
                                        formattedDate.toString();
                                  },
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(appPadding),
                    child: Row(
                      children: [
                        Text(
                          "Contact Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Divider(
                                height: 2,
                                color: grey,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(appPadding),
                    child: Form(
                      child: Wrap(
                        spacing: appPadding * 2.5,
                        runSpacing: appPadding * 1.5,
                        children: [
                          Container(
                            width: 510,
                            child: TextFormField(
                              enabled: false,
                              controller: controllerEmail,
                              onChanged: (value) {},
                              decoration: setInputDecoration(
                                  labelText: "Email",
                                  hintText: "Enter Your Email",
                                  editStatus: false),
                            ),
                          ),
                          controllerPhone.text != ""
                              ? Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 510,
                                child: IntlPhoneField(
                                  enabled: false,
                                  controller: controllerPhone,
                                  decoration: setInputDecoration(
                                    labelText: "Phone",
                                    hintText: "031 1223234",
                                  ),
                                  initialCountryCode:
                                  getPhoneIsoCountry(
                                      userProfile.phoneNumber!),
                                  onChanged: (phone) {},
                                ),
                              ),
                            ],
                          )
                              : Container(),
                          SizedBox(height: appPadding * 2),
                          state == EditProfileStates.Edit
                              ? Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!
                                      .validate()) {
                                    toasterFlutter(
                                        "Processing Data 😇");
                                    final result = await FireStoreService()
                                        .updateUserProfile(
                                        name: controllerFullName
                                            .text,
                                        email:
                                        controllerEmail
                                            .text,
                                        bio: controllerBio.text,
                                        gender: controllerGender
                                            .dropDownValue!
                                            .value,
                                        dateOfBirth:
                                        controllerDOB.text);

                                    if (!result){
                                      fillCurrentUserInfor(userProfile);
                                    }
                                    else if (result){
                                      editProfileBloc.add(CancelEditProfileButtonPressedEvent());
                                    }

                                  }
                                },
                                child: reusableButton(
                                    text: "Update",
                                    isPrimary: true),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  fillCurrentUserInfor(userProfile);
                                  editProfileBloc.add(
                                      CancelEditProfileButtonPressedEvent());
                                },
                                child: reusableButton(
                                    text: "Cancel",
                                    isPrimary: false),
                              ),
                            ],
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
