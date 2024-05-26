
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:provider/provider.dart'; // Import Provider
class BookingView extends StatefulWidget {
  const BookingView({Key? key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      var snapshots = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var data = snapshots.data();
      if (data == null) return;

      var appointmentsData = List.from(data['appointments']);
      setState(() {
        appointments = appointmentsData.map((appointment) => Appointment.fromMap(appointment)).toList();
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_backspace_outlined, color: Colors.white)),
        title: Text("My Bookings", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return buildAppointmentItem(context, appointment);
        },
      ),
    );
  }

  Widget buildAppointmentItem(BuildContext context, Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointment.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: EColors.textPrimary),
              ),
              IconButton(
                  onPressed: () => deleteAppointment(appointment),
                  icon: Icon(Icons.delete, color: Colors.red)),
            ],
          ),
          Text("Age ${appointment.age}", style: TextStyle(color: EColors.textPrimary)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.calendar_month, color: Colors.grey),
                  title: Text(appointment.date, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11)),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.timer, color: Colors.grey),
                  title: Text(appointment.time, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'appointments': FieldValue.arrayRemove([appointment.toMap()])
      });
      setState(() {
        appointments.remove(appointment);
      });
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
// import 'package:mental_healthapp/shared/utils/goals_database.dart';
// import 'package:provider/provider.dart'; // Import Provider
// // Import your AppointmentsDB class
//
// class BookingView extends StatefulWidget {
//   const BookingView({Key? key});
//
//   @override
//   State<BookingView> createState() => _BookingViewState();
// }
//
// class _BookingViewState extends State<BookingView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: EColors.primaryColor,
//         leading: InkWell(
//             onTap: ()=>Navigator.pop(context),
//             child: Icon(Icons.keyboard_backspace_outlined,color: Colors.white,)),
//         title: Text("My Bookings",style: TextStyle(color: Colors.white),),
//       ),
//       body: Consumer<AppointmentsDB>(
//         builder: (context, appointmentsDB, child) {
//           // Retrieve list of appointments from AppointmentsDB
//           List<Appointment> appointments = appointmentsDB.appointments;
//           print(appointments.last.name);
//           return ListView.builder(
//             itemCount: appointments.length,
//             itemBuilder: (context, index) {
//               Appointment appointment = appointments[index];
//
//               return Container(
//                 padding: const EdgeInsets.all(13),
//                 margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
//                         blurRadius: 10,  // Blur effect radius
//                         offset: Offset(5, 5),  // X, Y offset of shadow
//                       ),
//                     ]
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           appointment.name,
//                           style: Theme.of(context).textTheme.titleSmall!.copyWith(color: EColors.textPrimary),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               final db = Provider.of<AppointmentsDB>(context,
//                                   listen: false);
//                               db.deleteAppointment(appointment);
//                             },
//                             icon: Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             ))
//                       ],
//                     ),
//                     Text("Age ${appointment.age}",style: TextStyle(color: EColors.textPrimary),),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: ListTile(
//                             leading: Icon(Icons.calendar_month,color: Colors.grey,),
//                             title: Text(appointment.date,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11),),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListTile(
//                             leading: Icon(Icons.timer,color: Colors.grey,),
//                             title: Text(appointment.time,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11),),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
