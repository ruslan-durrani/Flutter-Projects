
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/screens/users_management/data_table_bloc/data_table_bloc.dart';
import 'package:responsive_admin_dashboard/screens/users_management/ui/sub_screens_ui/user_detail_page.dart';

import '../../../global/widgets/toastFlutter.dart';
import '../../my_profile/widgets/widgets.dart';
import '../models/user_profile.dart';

enum UserManagementOptions{View, Update, Delete}



class MyData extends DataTableSource {
  List<Map<String, dynamic>> data = [];
  List<UserProfile> userLists;
  DataTableBloc? dataTableBloc;
  DataTableState state;
  BuildContext context;
  MyData(this.userLists, this.state,this.context, [this.dataTableBloc]) {
    for (var i = 0; i < userLists.length; i++) {
      data.add({
        'avatar': userLists[i].imgUrl??"",
        'name': userLists[i].fullName??"",
        'email': userLists[i].email??"",
        'phone': userLists[i].phoneNumber??"",
        'posts': 10,
        'actions': {
          'View User Profile': () {
            print('View ${userLists[i].fullName}');
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserDetailsPage(userLists[i],UserManagementOptions.View)));
          },
          'Delete User Profile': ()=>deleteUserByEmail(userLists[i].email!),
          'Update User Profile': () {
            print('Update ${userLists[i].fullName}');
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserDetailsPage(userLists[i],UserManagementOptions.Update)));
          },
        },
      });
    }
  }

  Future<void> deleteUserByEmail(String userEmail) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail) // Directly using document ID for deletion
          .get();

      if (userDoc.exists) {
        await userDoc.reference.delete();
        toasterFlutter('User with email $userEmail successfully deleted from Firestore.');
      } else {
        toasterFlutter('No user found with the specified email.');
      }
    } catch (error) {
      toasterFlutter('Error deleting user: $error');
    }
  }


  // Future<void> deleteUserByEmail(String userEmail) async {
  //   try {
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userEmail) // Directly using document ID for deletion
  //         .get();
  //
  //     if (userDoc.exists) {
  //       await userDoc.reference.delete();
  //       toasterFlutter('User with email $userEmail successfully deleted from Firestore.');
  //     } else {
  //       toasterFlutter('No user found with the specified email.');
  //     }
  //   } catch (error) {
  //     toasterFlutter('Error deleting user: $error');
  //   }
  // }

  @override
  DataRow getRow(int index) {
    return DataRow(selected: state.userList.contains(userLists[index])?true:false,onSelectChanged: (value){
      print("Object ${userLists[index].fullName} Selected");
      if(value == true){
        dataTableBloc?.add(SetMarkedItemsEvent(userLists[index]));
      }
      else{
        dataTableBloc?.add(RemoveMarkedItemsEvent(userLists[index]));
      }

    },cells: [
      DataCell(
          CircleAvatar(
            child: Image.network(
              userLists[index].imgUrl != ""? userLists[index].imgUrl!:
                userLists[index].imgUrl == "" && userLists[index].gender == ""
                ? genderImages["Male"]!
                : genderImages[userLists[index].gender==""?"Male":userLists[index].gender]??""

            ),
          )),
      DataCell(Text("${userLists[index].fullName}")),
      DataCell(Text("${userLists[index].email}")),
      DataCell(Text("${userLists[index].phoneNumber}")),
      DataCell(Row(
        children: [
          const Icon(Icons.star, color: Colors.orangeAccent),
          const SizedBox(width: 5),
          Text("10"),
        ],
      )),

      DataCell(
        MenuAnchor(
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.arrow_drop_down_rounded),
              tooltip: 'Show Actions',
            );
          },
          menuChildren: List<MenuItemButton>.generate(
            3,
                (int i) => MenuItemButton(
              onPressed: data[index]["actions"].values.toList()[i],
              child: Text('${data[index]["actions"].keys.toList()[i]}'),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  List<String> list = <String>['Update User', 'Delete User', 'View User'];
}


