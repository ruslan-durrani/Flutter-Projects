import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class GoalDataBase extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> userGoals = [];

  // void createDefault() {
  //   _myBox.put('GOALLIST', [
  //     ['No Goals Added', false]
  //   ]);
  //   notifyListeners();
  // }

  void loadData() {
    notifyListeners();
  }

  Future getGoalsFromFirebase() async {
    var snapshots =
        await firestore.collection('goals').doc(auth.currentUser!.uid).get();

    var data = snapshots.data();
    if (data == null) {
      return;
    }
    for (var goal in data['goals']) {
      userGoals.add(goal);
    }
  }

  // List<GoalModel> get goals {
  //   var docs = firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('goals')
  //       .get();

  //   for (var doc in docs) {
  //
  //       }
  // }

  List<Map<String, dynamic>> get goals => userGoals;

  Future saveTask(
      TextEditingController controller, BuildContext context) async {
    await firestore.collection('goals').doc(auth.currentUser!.uid).set({
      'goals': FieldValue.arrayUnion(
        [
          {'goal': controller.text, 'bool': false}
        ],
      ),
    }, SetOptions(merge: true));
    userGoals.add({'goal': controller.text, 'bool': false});
    controller.clear();
    notifyListeners();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future deleteTask(String goalString) async {
    Map<String, dynamic> goalToRemove =
        userGoals.firstWhere((element) => element['goal'] == goalString);
    await firestore.collection('goals').doc(auth.currentUser!.uid).update({
      'goals': FieldValue.arrayRemove([goalToRemove])
    });
    userGoals.remove(goalToRemove);
    notifyListeners();
  }

  void checkBox(String goalString) async {
    Map<String, dynamic> goalToCheck =
        userGoals.firstWhere((element) => element['goal'] == goalString);

    if (userGoals.contains(goalToCheck)) {
      int index = userGoals.indexOf(goalToCheck);
      userGoals[index]['bool'] = !userGoals[index]['bool'];
    }

    notifyListeners();
    var snapshot =
        await firestore.collection('goals').doc(auth.currentUser!.uid).get();

    List<dynamic> goals = snapshot.data()!['goals'];

    Map<String, dynamic> goalRemoteToCheck =
        goals.firstWhere((element) => element['goal'] == goalString);

    if (goals.contains(goalRemoteToCheck)) {
      int index = goals.indexOf(goalRemoteToCheck);
      goals[index]['bool'] = !goals[index]['bool'];
    }

    await firestore.collection('goals').doc(auth.currentUser!.uid).update({
      'goals': goals,
    });
  }
}

class Appointment {
  final String name;
  final String time;
  final String age;
  final String date;

  Appointment({
    required this.name,
    required this.time,
    required this.age,
    required this.date,
  });

  factory Appointment.fromMap(Map<dynamic, dynamic> map) {
    return Appointment(
      name: map['name'],
      time: map['time'],
      age: map['time'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'age': age,
      'date': date,
    };
  }
}

class AppointmentsDB extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Appointment> appointmentLists = [];

  // void createDefault() {
  //   myBox.put('AppointmentList', []);
  //   notifyListeners();
  // }

  void loadData() {
    notifyListeners();
  }

  List<Appointment> get appointments {
    return appointmentLists;
    // return (myBox.get('AppointmentList', defaultValue: []) as List<dynamic>)
    //     .map((data) => Appointment(
    //           name: data['name'],
    //           time: data['time'],
    //           age: data['age'],
    //           date: data['date'],
    //         ))
    //     .toList();
  }

  Future loadAppointmentsFromFirebase() async {
    var snapshots = await firestore
        .collection('appointments')
        .doc(auth.currentUser!.uid)
        .get();
    var data = snapshots.data();

    if (data == null) {
      return;
    }
    for (var appointment in data['appointments']) {
      appointmentLists.add(Appointment.fromMap(appointment));
    }
  }

  Future saveAppointment({
    required String name,
    required String time,
    required String age,
    required String date,
  }) async {
    // List<dynamic> updatedAppointments =
    //     List<dynamic>.from(myBox.get('AppointmentList', defaultValue: []));

    // updatedAppointments.add({
    //   'name': name,
    //   'time': time,
    //   'age': age,
    //   'date': date,
    // });
    var appointment = Appointment(name: name, time: time, age: age, date: date);
    appointmentLists.add(appointment);

    await firestore.collection('appointments').doc(auth.currentUser!.uid).set(
      {
        'appointments': [appointment.toMap()],
      },
      SetOptions(merge: true),
    );
    await firestore
        .collection('appointments')
        .doc(auth.currentUser!.uid)
        .update(
      {
        'appointments': FieldValue.arrayUnion(
          [
            appointment.toMap(),
          ],
        ),
      },
    );

    notifyListeners();
  }

  Future deleteAppointment(Appointment appointment) async {
    appointmentLists.removeWhere((item) => appointment == item);

    await firestore
        .collection('appointments')
        .doc(auth.currentUser!.uid)
        .update(
      {
        'appointments': FieldValue.arrayRemove([
          appointment.toMap(),
        ]),
      },
    );

    notifyListeners();
  }
}
