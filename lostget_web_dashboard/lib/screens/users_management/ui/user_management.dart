import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/404/error_page.dart';
import '../../../constants/constants.dart';
import '../bloc/user_profiles_bloc.dart';
import '../data_table_bloc/data_table_bloc.dart';
import 'data_table.dart';

List<String> userManagementHeaderFields = [
  "Avatar",
  "Name",
  "Email",
  "Phone",
  "Posts",
  "Actions",
];
class UserManagement extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<void> deleteUserByEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one user with the specified email
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
  @override
  Widget build(BuildContext context) {
    final userProfileBloc = BlocProvider.of<UserProfilesBloc>(context);
    final dataTableSelectBloc = BlocProvider.of<DataTableBloc>(context);
    userProfileBloc.add(FetchUserProfilesEvent());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SearchBar(
                    hintText: "Search for User",
                    leading: Padding(
                        padding: EdgeInsets.all(10), child: Icon(Icons.search),),
                    onChanged: (value) {
                      userProfileBloc.add(SearchFilterUsersProfilesEvent(value));
                    },
                    controller: searchController,
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                BlocBuilder<UserProfilesBloc, UserProfilesState>(
                  bloc: userProfileBloc,
                  builder: (context, state) {
                    if (state is UserProfilesLoading) {
                      return CircularProgressIndicator();
                    } else if (state is UserProfilesLoaded) {
                      print("Fuck youuuuu ${state.userProfiles.first}");
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
                                  source: MyData(userProfiles,state,context,dataTableSelectBloc),
                                  header:  Row(
                                    children: [
                                      Text('All Authorized Users'),
                                      Spacer(),
                                      !(state.userList.isEmpty || state.userList.isEmpty)?
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
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
                                                  Icon(Icons.delete,color: Colors.red,size: 18,),
                                                  Text("Delete",style: TextStyle(color: Colors.red,fontSize: 15),)
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          InkWell(
                                            onTap: (){
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
                                                    Icon(Icons.lock_clock,color: Colors.black,size: 18,),
                                                    Text("Suspend",style: TextStyle(color: Colors.black,fontSize: 15),),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ],
                                      ):Container(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}