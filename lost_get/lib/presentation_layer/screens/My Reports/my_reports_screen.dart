import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/business_logic_layer/MyReports/bloc/my_reports_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:provider/provider.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  static const routeName = '/my_reports_screen';

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  MyReportsBloc myReportsBloc = MyReportsBloc();
  @override
  Widget build(BuildContext context) {
    myReportsBloc.add(MyReportsLoadEvent());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text("My Reports", style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: SafeArea(
        child: BlocConsumer<MyReportsBloc, MyReportsState>(
          bloc: myReportsBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is MyReportsLoadedState) {
              return ListView.builder(
                itemCount: state.reportItems.length,
                itemBuilder: ((context, index) {
                  var currentReport = state.reportItems[index];
                  return Container(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 95.h,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
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
                                        onSelected: handleClick,
                                        itemBuilder: (BuildContext context) {
                                          return {'Modify', 'Deactivate'}
                                              .map((String choice) {
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
                                              color: currentReport.published!
                                                  ? Colors.green
                                                  : currentReport.flagged!
                                                      ? Colors.red
                                                      : Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              currentReport.published!
                                                  ? "Active"
                                                  : currentReport.flagged!
                                                      ? "Flagged"
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
                                    top: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: button(
                                            "QR PAMPHLET",
                                            () {},
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
            } else {
              return const SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50,
              );
            }
          },
        ),
      ),
    );
  }
}

Widget button(
    String title, VoidCallback? handleButton, Color bgColor, Color fgColor) {
  return Consumer(
    builder: (context, ChangeThemeMode value, child) => ElevatedButton(
      onPressed: handleButton,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(15)),
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

// Center(
//         child: Text(
//           "There are no reports at the moment!",
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ),

void handleClick(String value) {
  switch (value) {
    case 'Logout':
      break;
    case 'Settings':
      break;
  }
}
