import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/404/error_page.dart';
import 'package:responsive_admin_dashboard/screens/users_management/ui/data_table.dart';

import '../../../global/widgets/toastFlutter.dart';
import '../bloc/user_profiles_bloc.dart';
import '../data_table_bloc/data_table_bloc.dart';
import '../models/police_station.dart';

List<String> userManagementHeaderFields = [
  "Avatar",
  "Name",
  "Email",
  "Phone",
  "Posts",
  "Actions",
];

class UserManagement extends StatefulWidget {
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  TextEditingController searchController = TextEditingController();

  Future<void> deleteUserByEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs[0];
        await userDoc.reference.delete();
        toasterFlutter('User with email $userEmail successfully deleted from Firestore.');
      } else {
        toasterFlutter('No user found with the specified email.');
      }
    } catch (error) {
      toasterFlutter('Error deleting user: $error');
    }
  }

  bool isUser = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PoliceStation>> getRegisteredStations() {
    return _firestore
        .collection('registeredPoliceStation')
        .where('isApproved', isEqualTo: false)  // This line adds the condition to filter the documents
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PoliceStation.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }


  void _updateApproval(String docId, bool isApproved) {
    _firestore.collection('registeredPoliceStation').doc(docId).update({
      'isApproved': isApproved
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileBloc = BlocProvider.of<UserProfilesBloc>(context);
    final dataTableSelectBloc = BlocProvider.of<DataTableBloc>(context);
    userProfileBloc.add(FetchUserProfilesEvent());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isUser = !isUser;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: isUser?primaryColor:secondaryColor),
                    width: 120,
                    height: 50,
                    child: Text("Users",style: TextStyle(fontWeight: FontWeight.bold,
                        color: isUser?Colors.white:primaryColor
                    ),),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isUser = !isUser;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: !isUser?primaryColor:secondaryColor),
                    width: 120,
                    height: 50,
                    child: Text("Police Stations",style: TextStyle(fontWeight: FontWeight.bold,
                        color: !isUser?Colors.white:primaryColor
                    ),),
                  ),
                ),
              ],
            )
          ),
          isUser?Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: SearchBar(
                  hintText: "Search for User",
                  leading: Icon(Icons.search),
                  onChanged: (value) {
                    userProfileBloc.add(SearchFilterUsersProfilesEvent(value));
                  },
                  controller: searchController,
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlocBuilder<UserProfilesBloc, UserProfilesState>(
                  bloc: userProfileBloc,
                  builder: (context, state) {
                    if (state is UserProfilesLoading) {
                      return CircularProgressIndicator();
                    } else if (state is UserProfilesLoaded) {
                      final userProfiles = state.userProfiles;
                      return Column(
                        children: [
                          BlocBuilder<DataTableBloc, DataTableState>(
                            bloc: dataTableSelectBloc,
                            builder: (context, state) {
                              dataTableSelectBloc.add(SetMarkedItemsEvent(null));
                              return Container(
                                width: double.infinity,
                                child: PaginatedDataTable(
                                  columns: [
                                    ...userManagementHeaderFields
                                        .map((e) => DataColumn(label: Text(e)))
                                        .toList()
                                  ],
                                  source: MyData(userProfiles, state, context, dataTableSelectBloc),
                                  header: Row(
                                    children: [
                                      Text('All Authorized Users'),
                                      Spacer(),
                                      !(state.userList.isEmpty || state.userList.isEmpty)
                                          ? Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print("Delete Button Pressed for ${state.userList.toList()}");
                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => PageNotFound()));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(.1),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, color: Colors.red, size: 18),
                                                  Text("Delete", style: TextStyle(color: Colors.red, fontSize: 15)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              print("Suspend Button Pressed for ${state.userList.toList()} ");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(.1),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.lock_clock, color: Colors.black, size: 18),
                                                  Text("Suspend", style: TextStyle(color: Colors.black, fontSize: 15)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                  columnSpacing: 60,
                                  horizontalMargin: 50,
                                  rowsPerPage: 10,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else if (state is UserProfilesError) {
                      print(state.error);
                      return AlertDialog(
                        icon: Icon(
                          Icons.dangerous,
                          color: Colors.red,
                        ),
                        content: Text("Error: ${state.error}"),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ):Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height *.7,
            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
            child: StreamBuilder<List<PoliceStation>>(
              stream: getRegisteredStations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      PoliceStation station = snapshot.data![index];
                      return Container(
                        height: 200,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2,color: primaryColor)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Station Name",style: Theme.of(context).textTheme.bodySmall,),
                                Text(station.stationName,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Location",style: Theme.of(context).textTheme.bodySmall,),
                                Text(station.address,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                ElevatedButton(
                                  onPressed: () => _updateApproval(station.docId, true),
                                  child: Text('Approve'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateApproval(station.docId, false),
                                  child: Text('Disapprove'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) ;
                    },
                  );
                }
                return Text("No data found!");
              },
            )
          )
        ],
      ),
    );
  }
}



