import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/controller/Profile%20Settings/edit_profile_controller.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:provider/provider.dart';
import '../../../../business_logic_layer/EditProfile/ChangeProfile/bloc/change_profile_bloc.dart';
import '../../../../business_logic_layer/EditProfile/bloc/edit_profile_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/controller_validators.dart';
import '../../../widgets/please_wait.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit_profile';

  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileBloc editProfileBloc = EditProfileBloc();
  ChangeProfileBloc changeProfileBloc = ChangeProfileBloc();
  final SingleValueDropDownController _genderController =
      SingleValueDropDownController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  // final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  String? _uploadedImageUrl;
  // ignore: unused_field
  String? _oldImageUrl;
  String? _completePhoneNumber;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _datePicker() async {
    await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        _dateOfBirthController.text = DateFormat("dd/MM/yyyy").format(value);
      }
    });
  }

  OverlayEntry? overlayEntry;

  void showCustomLoadingDialog(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned.fill(
          child: Container(
            color: Colors.transparent
                .withOpacity(0.7), // Make the overlay transparent
            child: const Center(
              child: PleaseWaitDialog(description: "Please Wait..."),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void hideCustomLoadingDialog(BuildContext context) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    editProfileBloc.add(EditProfileLoadEvent());
    return Scaffold(
      appBar: createAppBar(context),
      body: SafeArea(
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          bloc: editProfileBloc,
          listenWhen: (previous, current) => current is EditProfileActionState,
          listener: (context, state) {
            if (state is SaveButtonClickedSuccessState) {
              hideCustomLoadingDialog(context);
              createToast(description: "Profile Updated Successfully!");
              editProfileBloc.add(EditProfileLoadEvent());
            }
            if (state is SaveButtonClickedErrorState) {
              hideCustomLoadingDialog(context);
              createToast(description: state.description);
            }
            if (state is SaveButtonClickedLoadingState) {
              showCustomLoadingDialog(context);
            }
          },
          buildWhen: (previous, current) => current is! EditProfileActionState,
          builder: (context, state) {
            if (state is EditProfileLoadingState) {
              return const SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50,
              );
            }
            if (state is EditProfileErrorState) {
              createToast(description: state.errorMsg);
            }

            if (state is EditProfileLoadedState) {
              setControllers(state.userProfile);

              return SingleChildScrollView(
                  child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createTitle(context, "Basic Information"),
                        SizedBox(
                          height: 6.h,
                        ),
                        Row(children: [
                          BlocBuilder<ChangeProfileBloc, ChangeProfileState>(
                            bloc: changeProfileBloc,
                            builder: (context, state) {
                              if (state is ChangeProfileLoadingState) {
                                Container(
                                  width: 110.w,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: const SpinKitFadingCircle(
                                    color: AppColors.primaryColor,
                                    size: 50,
                                  ),
                                );
                              }
                              if (state is ChangeProfileErrorState) {
                                createToast(description: state.errorMsg);
                              }
                              if (state is ChangeProfileLoadedState) {
                                _pickedImage = state.pickedImage;

                                return Stack(children: [
                                  Container(
                                      width: 110.w,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        image: _pickedImage != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                  File(_pickedImage!.path),
                                                ),
                                              )
                                            : const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/lostget-faafe.appspot.com/o/defaultProfileImage.png?alt=media&token=15627898-29b2-47a1-b9cc-95c93a158cd1",
                                                )),
                                      )),
                                  Positioned(
                                      bottom: 0,
                                      left: 80,
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/edit_profile.svg',
                                          width: 13.w,
                                          height: 13.h,
                                        ),
                                        onPressed: () {
                                          changeProfileBloc
                                              .add(ChangeProfile());
                                        },
                                      ))
                                ]);
                              }
                              return Stack(children: [
                                Container(
                                    width: 110.w,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      image: _pickedImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                File(_pickedImage!.path),
                                              ),
                                            )
                                          : _uploadedImageUrl != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      _uploadedImageUrl!),
                                                  fit: BoxFit.cover)
                                              : const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    "https://firebasestorage.googleapis.com/v0/b/lostget-faafe.appspot.com/o/defaultProfileImage.png?alt=media&token=15627898-29b2-47a1-b9cc-95c93a158cd1",
                                                  )),
                                    )),
                                Positioned(
                                    bottom: 0,
                                    left: 80,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/edit_profile.svg',
                                        width: 13.w,
                                        height: 13.h,
                                      ),
                                      onPressed: () {
                                        changeProfileBloc.add(ChangeProfile());
                                      },
                                    ))
                              ]);
                            },
                          ),
                          SizedBox(
                            width: 18.w,
                          ),
                          createBioFields(
                              context, editProfileBloc, _fullNameController),
                        ]),

                        SizedBox(
                          height: 11.h,
                        ),
                        createProfileFields(context, 'Bio', TextInputType.text,
                            _biographyController, (value) {
                          return null;
                        }, true),
                        SizedBox(
                          height: 4.h,
                        ),

                        // DROP DOWN
                        createMediumTitle(context, "Gender"),
                        SizedBox(
                          height: 3.h,
                        ),
                        Consumer(
                          builder: (context, ChangeThemeMode value, child) {
                            return SizedBox(
                              height: 20.h,
                              child: DropDownTextField(
                                  controller: _genderController,
                                  initialValue: null,
                                  dropDownItemCount: 3,
                                  listTextStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  textStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  searchDecoration: const InputDecoration(
                                      hintText: "Select Your Gender"),
                                  dropDownList: const [
                                    DropDownValueModel(
                                        name: 'Male', value: "Male"),
                                    DropDownValueModel(
                                        name: 'Female', value: "Female"),
                                    DropDownValueModel(
                                        name: 'Prefer Not To Say',
                                        value: "Prefer Not To Say"),
                                  ],
                                  dropdownColor: value.isDarkMode()
                                      ? AppColors.darkPrimaryColor
                                      : Colors.white,
                                  textFieldDecoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 12),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  onChanged: (val) {}),
                            );
                          },
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        createMediumTitle(context, "Date Of Birth"),
                        SizedBox(
                          height: 3.h,
                        ),
                        // Date of birth

                        TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: _dateOfBirthController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),

                            // floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onTap: () {
                            _datePicker();
                          },
                        ),

                        SizedBox(
                          height: 11.h,
                        ),
                        createTitle(context, 'Contact Information'),
                        SizedBox(
                          height: 3.h,
                        ),
                        createProfileFields(
                          context,
                          'Email Address',
                          TextInputType.emailAddress,
                          _emailAddressController,
                          (value) =>
                              ControllerValidator.validateEmailAddress(value!),
                          false,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            createMediumTitle(context, "Phone Number"),
                            SizedBox(
                              height: 3.h,
                            ),
                            IntlPhoneField(
                              enabled: false,
                              controller: _phoneNumberController,
                              onChanged: (value) =>
                                  _completePhoneNumber = value.completeNumber,
                              initialCountryCode: getPhoneIsoCountry(
                                  state.userProfile.phoneNumber!),
                              dropdownTextStyle:
                                  Theme.of(context).textTheme.bodySmall,
                              style: Theme.of(context).textTheme.bodySmall,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 12),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CreateButton(
                              title: 'Save',
                              handleButton: () async {
                                if (formKey.currentState!.validate()) {
                                  Map<String, dynamic> newProfileData = {
                                    "fullName": _fullNameController.text,
                                    "biography": _biographyController.text,
                                    "dateOfBirth": _dateOfBirthController.text,
                                    "email": _emailAddressController.text,
                                  };

                                  if (_pickedImage != null) {
                                    newProfileData['imgUrl'] = _pickedImage;
                                    _oldImageUrl = state.userProfile.imgUrl;
                                    _pickedImage = null;
                                  } else if (EditProfileController.oldImgUrl !=
                                      state.userProfile.imgUrl) {
                                    newProfileData['imgUrl'] = _pickedImage;
                                    _oldImageUrl = state.userProfile.imgUrl;
                                    _pickedImage = null;
                                  }

                                  // if (_completePhoneNumber != null) {
                                  //   newProfileData['phoneNumber'] =
                                  //       _completePhoneNumber;
                                  // }

                                  if (_genderController.dropDownValue?.name !=
                                          null &&
                                      _genderController.dropDownValue?.name !=
                                          "") {
                                    newProfileData["gender"] =
                                        _genderController.dropDownValue!.name;
                                  } else {
                                    newProfileData["gender"] = "";
                                  }

                                  editProfileBloc.add(SaveButtonClickedEvent(
                                      context,
                                      newProfileData,
                                      state.userProfile,
                                      changeProfileBloc));
                                }
                              },
                            ),
                          ],
                        ),
                      ]),
                ),
              ));
            }
            return Container();
          },
        ),
      ),
    );
  }

  getPhoneIsoCountry(String phoneNumber) {
    PhoneNumber number =
        PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
    return number.countryISOCode;
  }

  getPhoneCodeCountry(String phoneNumber) {
    PhoneNumber number =
        PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
    return number.countryCode;
  }

  getPhoneNumber(String phoneNumber) {
    PhoneNumber number =
        PhoneNumber.fromCompleteNumber(completeNumber: (phoneNumber));
    return number.number;
  }

  void setControllers(UserProfile userProfile) {
    if (userProfile.fullName != "" && userProfile.dateOfBirth != null) {
      _fullNameController.text = userProfile.fullName!;
    } else {
      _fullNameController.text = "";
    }

    if (userProfile.gender != "" && userProfile.gender != null) {
      _genderController.dropDownValue = DropDownValueModel(
          name: userProfile.gender!, value: userProfile.gender!);
    }

    if (userProfile.biography != "" && userProfile.biography != null) {
      _biographyController.text = userProfile.biography!;
    } else {
      _biographyController.text = '';
    }

    if (userProfile.email != "" && userProfile.email != null) {
      _emailAddressController.text = userProfile.email!;
    } else {
      _emailAddressController.text = '';
    }

    _emailAddressController.text =
        userProfile.email != null ? userProfile.email! : "";

    if (userProfile.dateOfBirth != "" && userProfile.dateOfBirth != null) {
      _dateOfBirthController.text = userProfile.dateOfBirth!;
    } else {
      _dateOfBirthController.text = "DD/MM/YYYY";
    }

    if (userProfile.phoneNumber != "" && userProfile.phoneNumber != null) {
      _phoneNumberController.text = getPhoneNumber(userProfile.phoneNumber!);
    } else {
      _phoneNumberController.text = '';
    }

    if (userProfile.imgUrl != "" && userProfile.imgUrl != null) {
      _uploadedImageUrl = userProfile.imgUrl;
    }
  }

  Widget createEditImage(context, Function handleImagePicker) {
    return Stack(children: [
      _pickedImage == null
          ? const Text('No Image Exists')
          : Image.file(File(_pickedImage!.path)),
      Positioned(
          bottom: 0,
          left: 80,
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/edit_profile.svg',
              width: 13.w,
              height: 13.h,
            ),
            onPressed: () {
              handleImagePicker();
            },
          ))
    ]);
  }
}

Widget createBioFields(context, EditProfileBloc editProfileBloc,
    TextEditingController textEditingController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      createMediumTitle(context, "Your Name"),
      SizedBox(
        height: 3.h,
      ),
      SizedBox(
        width: 200.w,
        child: TextFormField(
          validator: (value) =>
              ControllerValidator.validateFullNameField(value!),
          controller: textEditingController,
          textAlign: TextAlign.start,
          onChanged: (fullName) {
            // editProfileBloc.add(FullNameOnChangedEvent(fullName));
          },
          style: Theme.of(context).textTheme.bodySmall,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),

            // floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      )
    ],
  );
}

Widget createProfileFields(
    context,
    String title,
    TextInputType textInputType,
    TextEditingController textEditingController,
    Function(String?) validatorFunction,
    bool enable) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      SizedBox(
        height: 3.h,
      ),
      TextFormField(
        enabled: enable,
        controller: textEditingController,
        validator: (value) {
          return validatorFunction(value);
        },
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodySmall,
        keyboardType: textInputType,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),

          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),

          // floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    ],
  );
}

Widget createTitle(context, String title) {
  return Text(
    title,
    style: Theme.of(context).textTheme.bodyMedium,
  );
}

Widget createMediumTitle(context, String title) {
  return Text(
    title,
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

PreferredSizeWidget? createAppBar(context) {
  return AppBar(
    title: Text(
      "Profile",
      style: Theme.of(context).textTheme.bodyMedium,
    ),
    centerTitle: true,
    leading: Consumer(
      builder: (context, ChangeThemeMode value, child) {
        ColorFilter? colorFilter = value.isDarkMode()
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : null;
        return IconButton(
          onPressed: () => alertDialog(
            context,
            "You have unsaved changes. Are you sure that you want to close?",
            "Unsaved Changes",
            "No",
            "Yes",
            () {
              Navigator.pop(context);
            },
            () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          icon: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            width: 24,
            height: 24,
            colorFilter: colorFilter,
          ),
        );
      },
    ),
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
