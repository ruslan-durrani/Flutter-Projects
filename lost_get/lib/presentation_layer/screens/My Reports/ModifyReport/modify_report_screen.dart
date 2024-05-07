import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/ModifyReport/bloc/modify_report_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/business_logic_layer/Provider/modify_report_provider.dart';
import 'package:lost_get/common/constants/add_report_constant.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/My%20Reports/ModifyReport/custom_field.dart';
import 'package:lost_get/presentation_layer/widgets/CustomToggleButton.dart';
import 'package:lost_get/presentation_layer/widgets/alert_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/controller_validators.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/location_field.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:provider/provider.dart';

class ModifyReportScreen extends StatefulWidget {
  static const routeName = '/modify_report_screen';
  final String id;
  const ModifyReportScreen({super.key, required this.id});

  factory ModifyReportScreen.fromArguments(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = args['id'];

    return ModifyReportScreen(id: id);
  }
  @override
  State<ModifyReportScreen> createState() => _ModifyReportScreenState();
}

class _ModifyReportScreenState extends State<ModifyReportScreen> {
  late ModifyReportBloc modifyReportBloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final categoryData = AddReportConstant().getCategoryList();
  String location = "Choose";
  List<bool> statusIsSelected = [true, false];
  bool _controllerInitialized = false;
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

  @override
  void initState() {
    super.initState();
    modifyReportBloc = ModifyReportBloc();
    modifyReportBloc.add(ModifyReportLoadingEvent(reportId: widget.id));
  }

  @override
  void dispose() {
    modifyReportBloc.close();
    super.dispose();
  }

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: createAppBar(context, "Report Item"),
      body: SafeArea(
        child: BlocConsumer<ModifyReportBloc, ModifyReportState>(
          bloc: modifyReportBloc,
          listenWhen: (previous, current) => current is ModifyReportActionState,
          listener: (context, state) {
            if (state is ItemReportStatusToggleState) {
              modifyReportBloc.add(ChangesMadeEvent());
            }

            if (state is ReportUpdateLoadingState) {
              showCustomLoadingDialog(context, "Please wait...");
            }
            if (state is ReportNotUpdatedState) {
              hideCustomLoadingDialog(context);
              createToast(
                  description: "Error Occurred: Report Can't be published");
            }
            if (state is ReportUpdatedState) {
              hideCustomLoadingDialog(context);
              createToast(description: "Your Report has been updated.");
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          buildWhen: (previous, current) => current is! ModifyReportActionState,
          builder: (context, state) {
            if (state is ModifyReportLoadingSuccessState) {
              location =
                  "${state.report.address!}, ${state.report.city}, ${state.report.country}";
              if (!_controllerInitialized) {
                initializeControllers(state.report);
                _controllerInitialized = true;
              }

              late final String categoryImage;
              for (var i in categoryData) {
                if (i["title"] == state.report.category) {
                  categoryImage = i["imageUrl"];
                }
              }

              return SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 60.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.withOpacity(0.2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    createTitle(
                                        context, "UPLOAD UPTO 5 IMAGES"),
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
                                child: state.report.imageUrls!.isEmpty
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
                                          itemCount:
                                              state.report.imageUrls!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .darkPrimaryColor,
                                                      width: 1.0)),
                                              child: Image.network(
                                                state.report.imageUrls![index],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              )
                            ],
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
                              child: SvgPicture.asset(categoryImage),
                            ),
                            title: Text(
                              state.report.category!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              state.report.subCategory!,
                              style: GoogleFonts.roboto(
                                  fontSize: 11.sp,
                                  color: const Color.fromARGB(255, 91, 91, 91)),
                            ),
                          ),
                        ),
                        spacer(),
                        LocationField(initialLocation: location),
                        spacer(),
                        createTitle(context, "Title *"),
                        spacer(),
                        CustomField(
                            maxLines: 0,
                            maxLength: 40,
                            controller: _titleController,
                            validatorFunction:
                                ControllerValidator.validateTitle),
                        spacer(),
                        createTitle(context, "Description *"),
                        spacer(),
                        CustomField(
                          maxLines: 4,
                          maxLength: 500,
                          controller: _descriptionController,
                          validatorFunction:
                              ControllerValidator.validateDescription,
                        ),
                        spacer(),
                        CreateButton(
                            title: "Submit Report",
                            handleButton: () {
                              if (location == "Choose") {
                                createToast(description: "Please add location");
                              } else if (formKey.currentState!.validate()) {
                                // final String tempStatus = context
                                //             .read<ModifyReportProvider>()
                                //             .status[0] ==
                                //         true
                                //     ? "Lost"
                                //     : "Found";
                                var locationData = context
                                    .read<ModifyReportProvider>()
                                    .getLocationData;
                                print("Modify");
                                print(currentStatus);
                                modifyReportBloc.add(UpdateReportEvent(
                                    reportId: widget.id,
                                    status: currentStatus,
                                    address: locationData["address"],
                                    city: locationData["city"],
                                    coordinates: GeoPoint(
                                        locationData["latitude"],
                                        locationData["longitude"]),
                                    country: locationData["country"],
                                    description: _descriptionController.text,
                                    title: _titleController.text));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is ModifyReportLoadingState) {
              return const SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  void initializeControllers(ReportItemModel reportItemModel) {
    _titleController.text = reportItemModel.title!;
    _descriptionController.text = reportItemModel.description!;
    statusIsSelected =
        reportItemModel.status == 'Lost' ? [true, false] : [false, true];
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
