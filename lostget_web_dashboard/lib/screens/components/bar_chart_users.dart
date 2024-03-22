import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Add this for date formatting
import 'package:responsive_admin_dashboard/constants/constants.dart';
import '../dashboard/userBarChartCubit/user_registered_count_cubit.dart';

class BarChartUsers extends StatelessWidget {
  const BarChartUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analyticsBloc = BlocProvider.of<UserRegisteredCountBloc>(context);
    analyticsBloc.fetchBarChartUserRegisteredData();

    return BlocBuilder<UserRegisteredCountBloc, UserRegisteredCountState>(
      bloc: analyticsBloc,
      builder: (context, state) {
        if (state is DashboardRegisterationCountLoadedState) {
          final registrationData = state.registrationCounts;
          final barGroups = List<BarChartGroupData>.generate(registrationData.length, (index) {
            final data = registrationData[index];
            final userCount = data["user_count"].toDouble(); // Ensure this is a double
            // Use index as x value or calculate based on date for more accurate positioning
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: userCount,
                  width: 20,
                  colors: [primaryColor],
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            );
          });

          return BarChart(
            BarChartData(
              borderData: FlBorderData(border: Border.all(width: 0)),
              groupsSpace: 15,
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, ) => const TextStyle(
                    color: lightTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  margin: 10,
                  getTitles: (double value) {
                    // Assuming the date is the first element in your data map and formatted as millisecondsSinceEpoch
                    var date = DateTime.fromMillisecondsSinceEpoch(registrationData[value.toInt()]["date_millisecond"]);
                    return DateFormat('MMM d').format(date); // Format date as 'Jan 6', 'Jan 7', etc.
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              barGroups: barGroups,
            ),
          );
        } else if (state is UserRegistrationLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserRegistrationErrorState) {
          return Center(child: Text('Error loading data'));
        } else {
          // Handle initial or unknown state
          return Center(child: Text('Please wait...'));
        }
      },
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:responsive_admin_dashboard/constants/constants.dart';
//
// import '../dashboard/userBarChartCubit/user_registered_count_cubit.dart';
//
// class BarChartUsers extends StatelessWidget {
//   const BarChartUsers({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final analyticsBloc = BlocProvider.of<UserRegisteredCountBloc>(context);
//     analyticsBloc.fetchBarChartUserRegisteredData();
//     return BlocBuilder<UserRegisteredCountBloc, UserRegisteredCountState>(
//       bloc: analyticsBloc,
//   builder: (context, state) {
//     return BarChart(BarChartData(
//         borderData: FlBorderData(border: Border.all(width: 0)),
//         groupsSpace: 15,
//         titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (value) => const TextStyle(
//                   color: lightTextColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//                 margin: appPadding,
//                 getTitles: (double value) {
//                   if (value == 2) {
//                     return 'jan 6';
//                   } if (value == 4) {
//                     return 'jan 8';
//                   }if (value == 6) {
//                     return 'jan 10';
//                   } if (value == 8) {
//                     return 'jan 12';
//                   }if (value == 10) {
//                     return 'jan 14';
//                   }if (value == 12) {
//                     return 'jan 16';
//                   }if (value == 14) {
//                     return 'jan 18';
//                   }else {
//                     return '';
//                   }
//                 }),
//             leftTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (value) => const TextStyle(
//                   color: lightTextColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//                 margin: appPadding,
//                 getTitles: (double value) {
//                   if (value == 2) {
//                     return '1K';
//                   } if (value == 6) {
//                     return '2K';
//                   } if (value == 10) {
//                     return '3K';
//                   }if (value == 14) {
//                     return '4K';
//                   }else {
//                     return '';
//                   }
//                 })
//         ),
//         barGroups: [
//           BarChartGroupData(x: 1, barRods: [
//             BarChartRodData(
//                 y: 10,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 2, barRods: [
//             BarChartRodData(
//                 y: 3,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 3, barRods: [
//             BarChartRodData(
//                 y: 12,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 4, barRods: [
//             BarChartRodData(
//                 y: 8,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 5, barRods: [
//             BarChartRodData(
//                 y: 6,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 6, barRods: [
//             BarChartRodData(
//                 y: 10,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 7, barRods: [
//             BarChartRodData(
//                 y: 16,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 8, barRods: [
//             BarChartRodData(
//                 y: 6,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 9, barRods: [
//             BarChartRodData(
//                 y: 4,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 10, barRods: [
//             BarChartRodData(
//                 y: 9,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 11, barRods: [
//             BarChartRodData(
//                 y: 12,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 12, barRods: [
//             BarChartRodData(
//                 y: 2,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 13, barRods: [
//             BarChartRodData(
//                 y: 13,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//           BarChartGroupData(x: 14, barRods: [
//             BarChartRodData(
//                 y: 15,
//                 width: 20,
//                 colors: [primaryColor],
//                 borderRadius: BorderRadius.circular(5)
//             )
//           ]),
//         ]));
//   },
// );
//   }
// }
//
//
//
