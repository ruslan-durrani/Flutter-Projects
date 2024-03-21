import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/data/data.dart';
import 'package:responsive_admin_dashboard/screens/users_management/bloc/user_profiles_bloc.dart';

import '../users_management/ui/data_table.dart';
import '../users_management/ui/sub_screens_ui/user_detail_page.dart';
import 'administration_info_detail.dart';

class Administrations extends StatelessWidget {
  const Administrations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminUser = BlocProvider.of<UserProfilesBloc>(context);
    adminUser.add(FetchUserProfilesEvent());
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: 540,
        padding: EdgeInsets.all(appPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Administrations',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: appPadding,
            ),
            Expanded(child: BlocBuilder<UserProfilesBloc,UserProfilesState>(
              bloc: adminUser,
              builder: (BuildContext context, state) {
                if(state is UserProfilesLoaded){
                  final userProfiles = state.userProfiles.where((element) => element.isAdmin==true);
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (userProfiles.length),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserDetailsPage(userProfiles.elementAt(index),UserManagementOptions.View))),
                      child: AdministrationInfoDetail(info: userProfiles.elementAt(index),

                      ),
                    ),
                  );
                }
                else{
                  return CircularProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
