import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/business_logic_layer/MyReports/bloc/my_reports_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/add_report_detail_screen.dart';
import 'package:lost_get/presentation_layer/screens/My%20Reports/ModifyReport/modify_report_screen.dart';
import 'package:lost_get/presentation_layer/widgets/alert_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:lost_get/utils/api_services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  static const routeName = '/my_reports_screen';

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  MyReportsBloc myReportsBloc = MyReportsBloc();

  @override
  void initState() {
    super.initState();
    myReportsBloc.add(MyReportsLoadEvent());
  }

  Future<void> _onRefresh() async {
    myReportsBloc.add(MyReportsLoadEvent());
  }

  Future<bool> requestStoragePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Permission is granted
        havePermission = true;
      } else {
        // Open the app settings if permission is permanently denied
        if (await Permission.manageExternalStorage.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    } else {
      // For Android versions lower than 13
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    return havePermission;
  }

  Future<void> createFlyerPDF(String reportId) async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      createToast(description: "No storage permission");
      return;
    }
    createToast(description: "Please wait. QR Flyer is being generated");
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('reportItems')
        .where("id", isEqualTo: reportId)
        .get();
    var data = documentSnapshot.docs.first;

    if (data.exists) {
      var imageUrl = data['imageUrls'][0];
      var title = data['title'];
      var description = data['description'];
      var image = await networkImage(imageUrl);
      var status = data['status'];
      Timestamp publishedDate = data["publishDateTime"];
      var userId = data["userId"];

      var getPhoneNumber = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      String? phoneNumber = "";

      if (getPhoneNumber.exists) {
        phoneNumber = getPhoneNumber.data()?['phoneNumber'];
      }

      var formattedDate = DateFormat("MMM d").format(publishedDate.toDate());
      var address = "${data["address"]}, ${data["city"]}, ${data["country"]}";

      // Step 4: Create the flyer layout
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
            margin: pw.EdgeInsets.zero,
            build: (
              pw.Context context,
            ) {
              return pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: PdfColors.deepPurple900, width: 5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('STATUS: ${status.toString().toUpperCase()}',
                          style: pw.TextStyle(
                              fontSize: status.toString() == "Lost" ? 78 : 70,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              // Use Expanded if you have issues with space
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.purple900, width: 5),
                                ),
                                child: pw.Image(image,
                                    fit: pw.BoxFit.fill,
                                    height: 400,
                                    width: 275),
                              ), // Ensure 'image' is a correct pw.ImageProvider
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              // Use Expanded for the column if space needs to be divided
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(title.toString().toUpperCase(),
                                      style: pw.TextStyle(
                                          fontSize: 32,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.purple900)),
                                  pw.SizedBox(height: 10),
                                  pw.Text(
                                      "${status.toString().toUpperCase()} SINCE: ${formattedDate.toUpperCase()}",
                                      style: pw.TextStyle(
                                        fontSize: 24,
                                        fontWeight: pw.FontWeight.bold,
                                      )),
                                  pw.SizedBox(height: 10),
                                  pw.Text(
                                    status.toString() == "Lost"
                                        ? "LAST SEEN: $address"
                                        : "FOUND AT: $address",
                                    style: pw.TextStyle(
                                      fontSize: 24,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Text(
                                    "DESCRIPTION: ${description.toString().toUpperCase()}",
                                    style: const pw.TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),

                      pw.SizedBox(height: 20),
                      pw.Text(
                        "FOR MORE INFO, SCAN QR AT LOSTGET",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: reportId,
                        width: 200,
                        height: 200,
                      ),
                      pw.SizedBox(height: 10),
                      phoneNumber!.isNotEmpty
                          ? pw.Text('CALL NOW: $phoneNumber',
                              style: pw.TextStyle(
                                fontSize: 36,
                                fontWeight: pw.FontWeight.bold,
                              ))
                          : pw.Container(),
                      // ... Add more elements as needed
                    ],
                  ));
            }),
      );

      try {
        final downloadsDirectory =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOCUMENTS);
        final String randomFileName =
            DateTime.now().microsecondsSinceEpoch.toString();
        final filePath = '$downloadsDirectory/lost_get_$randomFileName.pdf';
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
        OpenFile.open(filePath);
      } catch (e) {
        createToast(description: "Error saving flyer: $e");
      }
    } else {
      createToast(description: "Error: QR Flyer is not generated.");
    }
  }

  Future<pw.ImageProvider> networkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final image = pw.MemoryImage(response.bodyBytes);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text("My Reports", style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<MyReportsBloc, MyReportsState>(
            bloc: myReportsBloc,
            listenWhen: (previous, current) => current is MyReportsActionState,
            buildWhen: (previous, current) => current is! MyReportsActionState,
            listener: (context, state) {
              if (state is ReportDeactivatedSuccessfully) {
                hideCustomLoadingDialog(context);
                createToast(description: "Report deactivated successfully");
                myReportsBloc.add(MyReportsLoadEvent());
              }

              if (state is ReportDeactivationError) {
                hideCustomLoadingDialog(context);
                createToast(description: "Report deactivated successfully");
              }

              if (state is LoadingState) {
                showCustomLoadingDialog(context, "Please Wait..");
              }

              if (state is ReportMarkedAsRecoveredSuccessfullyState) {
                hideCustomLoadingDialog(context);
                createToast(description: "Report marked as Recovered");
                myReportsBloc.add(MyReportsLoadEvent());
              }
              if (state is ReportMarkedAsRecoveredErrorState) {
                hideCustomLoadingDialog(context);
                createToast(
                    description: "Error: Report is not marked as recovered.");
              }
            },
            builder: (context, state) {
              if (state is MyReportsLoadedState) {
                return ListView.builder(
                  itemCount: state.reportItems.length,
                  itemBuilder: ((context, index) {
                    var currentReport = state.reportItems[index];
                    return Container(

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),

                            blurRadius: 6,
                            offset: const Offset(
                                0, 4), // This offsets the shadow downwards
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      height: 110.h,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            width: 4,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: currentReport.published!
                                  ? Colors.green
                                  : currentReport.flagged!
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.grey.withOpacity(0.1),
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "REPORTED ON: ${DateFormat('dd-MM-yyy').format(currentReport.publishDateTime!)}",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) => handleClick(
                                            value, currentReport.id!),
                                        itemBuilder: (BuildContext context) {
                                          return currentReport.published! &&
                                                  !currentReport.recovered!
                                              ? {
                                                  'Modify',
                                                  'Deactivate',
                                                  "Mark as Recovered"
                                                }.map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(choice),
                                                  );
                                                }).toList()
                                              : {
                                                  'Deactivate',
                                                }.map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(choice),
                                                  );
                                                }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          currentReport.imageUrls![0],
                                          width: 95.w,
                                          height: 40.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200.w,
                                            child: Text(currentReport.title!,
                                                softWrap: true,
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                )),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.add_box_outlined,
                                                size: 22,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(
                                                "Status: ${currentReport.status!}",
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 3,
                                                bottom: 3,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: currentReport.published! &&
                                                      !currentReport.recovered!
                                                  ? Colors.green
                                                  : currentReport.flagged!
                                                      ? Colors.red
                                                      : currentReport.recovered!
                                                          ? AppColors
                                                              .primaryColor
                                                          : Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              currentReport.published! &&
                                                      !currentReport.recovered!
                                                  ? "Active"
                                                  : currentReport.flagged!
                                                      ? "Flagged"
                                                      : currentReport.recovered!
                                                          ? "Recovered"
                                                          : "Processing",
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                  ),
                                  child: Text(
                                    "The report ${currentReport.published! && !currentReport.recovered! ? "is currently live" : currentReport.flagged! ? "contains obscene content" : currentReport.recovered! ? "has been recovered" : "is processing"}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: button(
                                            "QR Flyer",
                                            currentReport.published! &&
                                                    !currentReport.recovered!
                                                ? () => createFlyerPDF(
                                                    currentReport.id!)
                                                : null,
                                            AppColors.primaryColor,
                                            Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: button(
                                            "AI FINDER",
                                            () {},
                                            AppColors.darkPrimaryColor,
                                            Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              } else if (state is MyReportsEmptyState) {
                return Center(
                  child: Text(
                    "There are no reports at the moment!",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              } else if (state is MyReportsLoadingState) {
                return const SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: 50,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void handleClick(String value, String id) {
    switch (value) {
      case 'Modify':
        Navigator.pushNamed(context, ModifyReportScreen.routeName,
            arguments: {'id': id});
        break;
      case 'Deactivate':
        alertDialog(
            context,
            "Are you sure, You want to deactivate this report",
            "Deactivate Report?",
            "No",
            "Deactivate",
            () => Navigator.pop(context), () {
          myReportsBloc.add(DeactivateReportEvent(itemId: id));
          Navigator.pop(context);
        });
        break;

      case 'Mark as Recovered':
        alertDialog(
            context,
            "Are you sure, You want to mark this report as recovered?",
            "Mark as Recovered?",
            "No",
            "Recovered",
            () => Navigator.pop(context), () {
          myReportsBloc.add(MarkAsRecoveredReportEvent(itemId: id));
          Navigator.pop(context);
        });
        break;
    }
  }
}

Widget button(
    String title, VoidCallback? handleButton, Color bgColor, Color fgColor) {
  return Consumer(
    builder: (context, ChangeThemeMode value, child) => ElevatedButton(
      onPressed: handleButton,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.5),
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsets.all(10)),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: value.isDyslexia ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
