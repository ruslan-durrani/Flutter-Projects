import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:provider/provider.dart';

import '../nav_screen.dart';

class BookAppointment extends StatefulWidget {
  final String name;
  final String type;

  const BookAppointment({super.key, required this.name, required this.type});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _appDate = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _appDate.dispose();
    _timeController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _appDate.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        title: Text(
            "Book Appointments",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Book Your Appointment with",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color:EColors.black.withOpacity(.8))
                ),
                SizedBox(height: 10,),
                Text(
                    "${widget.name} ",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(color:EColors.textPrimary)
                ),

                Text(
                    "Specialty: ${widget.type}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color:EColors.black.withOpacity(.8))
                ),
                const SizedBox(
                  height: 20,
                ),
                HelperTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    htxt: "Enter Name",
                    iconData: Icons.person,
                    controller: _nameController,
                    keyboardType: TextInputType.name),
                HelperTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                    htxt: 'Enter Age',
                    iconData: Icons.numbers,
                    controller: _ageController,
                    keyboardType: TextInputType.number),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    controller: _appDate,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      hintText: "Select Appointment Date",
                      fillColor: EColors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: () => _selectTime(context),
                    decoration: const InputDecoration(
                      hintText: "Select Appointment Time",
                      fillColor: EColors.white,
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.clock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30),
                HelperButton(
                    name: 'Book Appointment',
                    isPrimary: true,
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        final db = Provider.of<AppointmentsDB>(context, listen: false);
                        db.saveAppointment(
                            name: widget.name,
                            age: _ageController.text,
                            date: _appDate.text,
                            time: _timeController.text);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Booking Confirmed"),
                                actions: [
                                  TextButton(
                                      onPressed: ()=>{
                                      Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => const NavScreen(),
                                      ),
                                      )
                                      },
                                      child: Text("OK")
                                  )
                                ],
                              );
                            });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Please fill all the fields in correct format"),
                            );
                          },
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
// import 'package:mental_healthapp/shared/utils/goals_database.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
// import 'package:provider/provider.dart';
//
// class BookAppointment extends StatefulWidget {
//   final String name;
//   final String type;
//   const BookAppointment({super.key, required this.name, required this.type});
//
//   @override
//   State<BookAppointment> createState() => _BookAppointmentState();
// }
//
// class _BookAppointmentState extends State<BookAppointment> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _ageController = TextEditingController();
//   TextEditingController _appDate = TextEditingController();
//   TextEditingController _time = TextEditingController();
//   GlobalKey<FormState> _key = GlobalKey<FormState>();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _nameController.dispose();
//     _ageController.dispose();
//     _appDate.dispose();
//     _time.dispose();
//   }
//
//   DateTime selectedDate = DateTime.now();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         _appDate.text = "${picked.day}/${picked.month}/${picked.year}";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: EColors.primaryColor,
//         title: Text(
//           "Book Appointments",
//           style: Theme.of(context).textTheme.titleSmall!.copyWith(color:Colors.white)
//         ),
//         leading: InkWell(
//           onTap: ()=>Navigator.pop(context),
//             child: Icon(Icons.arrow_back,color: Colors.white,)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Form(
//           key: _key,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Book Your Appointment with",
//                     style: Theme.of(context).textTheme.bodySmall!.copyWith(color:EColors.black.withOpacity(.8))
//                 ),
//                 SizedBox(height: 10,),
//                 Text(
//                     "${widget.name} ",
//                     style: Theme.of(context).textTheme.titleSmall!.copyWith(color:EColors.textPrimary)
//                 ),
//
//                 Text(
//                   widget.type,
//                     style: Theme.of(context).textTheme.bodySmall!.copyWith(color:EColors.black.withOpacity(.8))
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 HelperTextField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null; // Return null if the input is valid
//                     },
//                     htxt: "Enter Name",
//                     iconData: Icons.person,
//                     controller: _nameController,
//                     keyboardType: TextInputType.name),
//                 HelperTextField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null; // Return null if the input is valid
//                     },
//                     htxt: 'Enter age',
//                     iconData: Icons.numbers,
//                     controller: _ageController,
//                     keyboardType: TextInputType.number),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null; // Return null if the input is valid
//                     },
//                     controller: _appDate,
//                     readOnly: true,
//                     onTap: () {
//                       _selectDate(context);
//                     },
//                     decoration: const InputDecoration(
//                       hintText: "Select Appointment Date",
//                       fillColor: EColors.white,
//                       filled: true,
//                       prefixIcon: Icon(Icons.calendar_month_outlined),
//                     ),
//                   ),
//                 ),
//                 HelperTextField(
//                   htxt: "Enter Time",
//                   iconData: FontAwesomeIcons.clock,
//                   controller: _time,
//                   keyboardType: TextInputType.name,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter time';
//                     }
//                     return null; // Return null if the input is valid
//                   },
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 HelperButton(
//                     name: 'Book Appointment',
//                     isPrimary:true,
//                     onTap: () {
//                       if (_key.currentState!.validate()) {
//                         final db =
//                             Provider.of<AppointmentsDB>(context, listen: false);
//                         db.saveAppointment(
//                             name: widget.name,
//                             age: _ageController.text,
//                             date: _appDate.text,
//                             time: _ageController.text);
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 content: Text("Booking Confirmed"),
//                                 actions: [
//                                   IconButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                         _ageController.clear();
//                                         _appDate.clear();
//                                         _nameController.clear();
//
//                                         _time.clear();
//                                       },
//                                       icon: const Icon(Icons.done))
//                                 ],
//                               );
//                             });
//                       } else {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return const AlertDialog(
//                               content: Text(
//                                   "Please Fill All The Fields In Correct Format"),
//                             );
//                           },
//                         );
//                       }
//                     })
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
