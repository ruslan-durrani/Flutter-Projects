import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_get/business_logic_layer/AddReport/bloc/add_report_detail_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/add_report_constant.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/map_screen.dart';
import 'package:lost_get/presentation_layer/widgets/alert_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/controller_validators.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddReportDetailScreen extends StatefulWidget {
  static const routeName = '/add_report_detail_screen';
  final int categoryId;
  final String subCategoryName;
  const AddReportDetailScreen(
      {super.key, required this.categoryId, required this.subCategoryName});

  factory AddReportDetailScreen.fromArguments(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'];
    final subCategoryName = args['subCategoryName'];

    return AddReportDetailScreen(
        categoryId: categoryId, subCategoryName: subCategoryName);
  }
  @override
  State<AddReportDetailScreen> createState() => _AddReportDetailScreenState();
}

class _AddReportDetailScreenState extends State<AddReportDetailScreen> {
  AddReportDetailBloc addReportDetailBloc = AddReportDetailBloc();
  final List<XFile> _images = [];
  late Map<String, dynamic> locationData;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final categoryData = AddReportConstant().getCategoryList();
  String location = "Choose";
  // List<bool> statusIsSelected = [true, false];
  String currentStatus = "Lost";
  List<Map<String, dynamic>> statusList = [
    {
      "status":"Lost",
      "isActive":true,
    },
    {
      "status":"Found",
      "isActive":false,
    },
    {
      "status":"Stolen",
      "isActive":false,
    },
    {
      "status":"Robbed",
      "isActive":false,
    },
  ];

  Future<void> pickImages() async {
    late PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
      } else {
        status = await Permission.photos.status;
      }
    }
    if (!status.isGranted) {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      }
    }

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      int remainingSlots = 5 - _images.length;
      if (remainingSlots > 0) {
        final List<XFile> newImages = await picker.pickMultiImage();
        if (newImages.length > remainingSlots) {
          setState(() {
            _images.addAll(newImages.take(remainingSlots));
          });
          // ignore: use_build_context_synchronously
          createToast(description: "You can only add up to 5 images.");
        } else {
          setState(() {
            _images.addAll(newImages);
          });
        }
      } else {
        createToast(description: "You have reached the limit of 5 images.");
      }
    } else {
      createToast(description: "Permission to access photos was denied.");
    }
  }

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: createAppBar(context, "Report Item"),
      body: SafeArea(
          child: BlocConsumer<AddReportDetailBloc, AddReportDetailState>(
        bloc: addReportDetailBloc,
        listener: (context, state) {
          if (state is ItemReportStatusToggleState) {
            addReportDetailBloc.add(ChangesMadeEvent());
          }

          if (state is LoadingState) {
            showCustomLoadingDialog(context, "Please wait...");
          }
          if (state is ErrorState) {
            hideCustomLoadingDialog(context);
            createToast(
                description: "Error Occurred: Report Can't be published");
          }

          if (state is SuccessState) {
            hideCustomLoadingDialog(context);
            createToast(description: "Report is being published.");
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: pickImages,
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.lightPurpleColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  createTitle(context, "UPLOAD UPTO 5 IMAGES"),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20.0,
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1.h,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 40.h,
                              padding: const EdgeInsets.all(5),
                              child: _images.isEmpty
                                  ? SvgPicture.asset(
                                      "assets/icons/upload_icon.svg",
                                      width: 62,
                                      height: 62,
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      height: 30.h,
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              5, // Adjust number of columns
                                        ),
                                        itemCount: _images.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () =>
                                                _showDeleteConfirmationDialog(
                                                    context, index),
                                            child: Container(
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .darkPrimaryColor,
                                                      width: 1.0)),
                                              child: Image.file(
                                                File(_images[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    spacer(),
                    createTitle(context, "Status"),
                    spacer(),
                    Container(
                      width: double.maxFinite,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 8.0, // gap between lines
                        children: List.generate(statusList.length, (index) {
                          // Creating 4 grid items
                          return GestureDetector(
                            onTap: (){
                              statusList.forEach((element) { element["isActive"]=false;});
                              statusList[index]["isActive"] = true;
                              setState(() {
                                statusList;
                                currentStatus = statusList[index]["status"];
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width *.4,
                              decoration: BoxDecoration(
                                color: statusList[index]["isActive"]?AppColors.primaryColor:AppColors.lightPurpleColor.withOpacity(.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "${statusList[index]["status"]}",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: statusList[index]["isActive"]?Colors.white:Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    spacer(),
                    createTitle(context, "Category"),
                    spacer(),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            categoryData[widget.categoryId - 1]["imageUrl"],
                          ),
                        ),
                        title: Text(
                          "${categoryData[widget.categoryId - 1]["title"]}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          widget.subCategoryName,
                          style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              color: const Color.fromARGB(255, 91, 91, 91)),
                        ),
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () async {
                        locationData = await Navigator.pushNamed(
                                context, MapScreen.routeName)
                            as Map<String, dynamic>;

                        setState(() {
                          location =
                              "${locationData["address"]}, ${locationData["city"]}, ${locationData["country"]}";
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey))),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            "Location *",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            location,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    spacer(),
                    createTitle(context, "Title *"),
                    spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _titleController,
                        textAlign: TextAlign.start,
                        validator: (value) {
                          return ControllerValidator.validateTitle(value!);
                        },
                        onChanged: (title) {
                          // editProfileBloc.add(FullNameOnChangedEvent(fullName));
                        },
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),

                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    spacer(),
                    createTitle(context, "Description *"),
                    spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _descriptionController,
                        textAlign: TextAlign.start,
                        onChanged: (title) {
                          // editProfileBloc.add(FullNameOnChangedEvent(fullName));
                        },
                        validator: (value) {
                          return ControllerValidator.validateDescription(
                              value!);
                        },
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),

                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),

                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    spacer(),
                    CreateButton(
                        title: "Submit Report",
                        handleButton: () {
                          if (_images.isEmpty) {
                            createToast(description: "Please add images");
                          } else if (location == "Choose") {
                            createToast(description: "Please add location");
                          } else if (formKey.currentState!.validate()) {
                            final id = const Uuid().v4();
                            ReportItemModel reportItemModel = ReportItemModel(
                              id: id,
                              recovered: false,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              // status: statusIsSelected[0] == true
                              //     ? 'Lost'
                              //     : 'Found',
                              status: currentStatus,
                              userId: FirebaseAuth.instance.currentUser?.uid,
                              category: categoryData[widget.categoryId - 1]
                                  ["title"],
                              subCategory: widget.subCategoryName,
                              publishDateTime: DateTime.now(),
                              address: locationData["address"],
                              city: locationData["city"],
                              country: locationData["country"],
                              coordinates: GeoPoint(locationData["latitude"],
                                  locationData["longitude"]),
                              flagged: false,
                              published: false,
                              hasAIStarted: false,
                              hasReportToPoliceStationStarted: false,
                              reportStatusByPolice: null,
                            );
                            addReportDetailBloc.add(PublishButtonClickedEvent(
                                reportItemModel: reportItemModel,
                                imageFiles: _images));
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) async {
    alertDialog(
      context,
      "Are you sure that you want to remove image?",
      "Remove Image",
      "No",
      "Yes",
      () {
        Navigator.pop(context);
      },
      () {
        Navigator.pop(context);
        setState(() {
          _images.removeAt(index);
        });
      },
    );
  }
}

Widget createTitle(context, String title) {
  return Text(
    title,
    style: TextStyle(
        color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
  );
}

PreferredSizeWidget? createAppBar(context, String text) {
  return AppBar(
    title: Text(
      text,
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          icon: SvgPicture.asset(
            'assets/icons/exit_light.svg',
            width: 20,
            height: 20,
            colorFilter: colorFilter,
          ),
        );
      },
    ),
  );
}

Widget spacer() {
  return SizedBox(
    height: 4.h,
  );
}
