import 'dart:js_interop';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/global/services/firestore_service.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/bloc/my_profile_bloc.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/edit_profile_bloc/edit_profile_bloc.dart';
import '../../../constants/constants.dart';
import '../widgets/widgets.dart';
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> fillCurrentUserInfor(MyProfileLoaded state) async {
    if (state.myProfile.gender == "") {
      controllerGender.dropDownValue =
          DropDownValueModel(name: "None", value: "None");
    } else {
      controllerGender.dropDownValue = DropDownValueModel(
          name: state.myProfile.gender!, value: state.myProfile.gender!);
    }
    controllerFullName.text = state.myProfile.fullName!;
    controllerDOB.text = state.myProfile.dateOfBirth!;
    controllerBio.text = state.myProfile.biography!;
    controllerEmail.text = state.myProfile.email!;
    if (state.myProfile.phoneNumber! == "") {
      controllerPhone.text = "PK";
    } else {
      controllerPhone.text =
          getPhoneNumber(state.myProfile.phoneNumber!).toString();
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
  void dispose() {
    controllerEmail.dispose();
    controllerFullName.dispose();
    controllerDOB.dispose();
    controllerGender.dispose();
    controllerBio.dispose();
    controllerPhone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final myProfile = BlocProvider.of<MyProfileBloc>(context);
    final editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    myProfile.add(GetMyProfileDataEvent());
    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 0 : appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocConsumer<MyProfileBloc, MyProfileState>(
        bloc: myProfile,
        listener: (context, state) {
          if (state is MyProfilesLoading) {}
        },
        builder: (context, profileState) {
          if (profileState is MyProfileLoaded) {
            fillCurrentUserInfor(profileState);
            final profileInfo = profileState.myProfile;
            return BlocBuilder<EditProfileBloc, EditProfileStates>(
              bloc: editProfileBloc,
              builder: (context, state) {
                final profileImage = profileInfo.imgUrl;
                final profileGender = (profileInfo.gender==""||profileInfo.gender==null)?"Other":profileInfo.gender;
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
                                backgroundColor: Colors.white,
                                radius: 60,
                                child: profileImage!.isEmpty ||
                                    profileImage == ""
                                    ? Image.asset(
                                  genderImages[profileGender]!,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(profileInfo.imgUrl!),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            state == EditProfileStates.Edit
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      editProfileBloc
                                          .add(EditProfileButtonPressedEvent());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: primaryColor.withOpacity(.1),
                                          border: Border.all(
                                              width: 1, color: primaryColor)),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                              "./assets/icons/edit.svg")
                                        ],
                                      ),
                                    ),
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
                                    // String val = DateFormat('dd/MM/yyyy')
                                    //     .format(value as DateTime);
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
                                              getPhoneIsoCountry(profileState
                                                  .myProfile.phoneNumber!),
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
                                              FireStoreService().myProfileInformationUpdate(
                                                name: controllerFullName.text,
                                                email: controllerFullName.text,
                                                bio: controllerBio.text,
                                                gender: controllerGender.dropDownValue!.value,
                                                dateOfBirth: controllerDOB.text
                                              );
                                              myProfile
                                                  .add(GetMyProfileDataEvent());
                                              editProfileBloc.add(
                                                  CancelEditProfileButtonPressedEvent());
                                            }
                                          },
                                        child: reusableButton(text:"Update",isPrimary:true),
                                      ),
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: () {
                                          fillCurrentUserInfor(profileState);
                                          editProfileBloc.add(
                                              CancelEditProfileButtonPressedEvent());
                                        },
                                        child: reusableButton(text: "Cancel", isPrimary: false),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }



}
