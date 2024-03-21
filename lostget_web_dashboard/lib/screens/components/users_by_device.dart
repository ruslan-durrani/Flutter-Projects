import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/radial_painter.dart';

class UsersByDevice extends StatefulWidget {

  UsersByDevice({Key? key}) : super(key: key);

  @override
  State<UsersByDevice> createState() => _UsersByDeviceState();
}

class _UsersByDeviceState extends State<UsersByDevice> {
  double mobileUsersPercentage = 0;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculatePercentageUsersByDevice();
  }

  calculatePercentageUsersByDevice() async {
    CollectionReference itemsCollection = firebase.collection('users');
    QuerySnapshot itemsSnapshot = await itemsCollection.get();
    int admins = 0;
    int users = 0;
    itemsSnapshot.docs.forEach((itemDoc) {
      bool isAdmin = itemDoc['isAdmin'];
      if (isAdmin) {
        admins += 1;
      } else {
        users +=1;
      }
    });
    double percentageOfAdmins = (admins / (admins+users)) * 100;
    double percentageOfUsers = (users / (admins+users)) * 100;
    setState(() {
      mobileUsersPercentage = percentageOfUsers;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: appPadding),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users by device',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              margin: EdgeInsets.all(appPadding),
              padding: EdgeInsets.all(appPadding),
              height: 230,
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: textColor.withOpacity(0.1),
                  lineColor: primaryColor,
                  percent: mobileUsersPercentage/100,
                  // percent: 0.7,
                  width: 18.0,
                ),
                child: Center(
                  child: Text(
                    '${mobileUsersPercentage}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: primaryColor,
                        size: 10,
                      ),
                      SizedBox(width: appPadding /2,),
                      Text('Mobile',style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: textColor.withOpacity(0.2),
                        size: 10,
                      ),
                      SizedBox(width: appPadding /2,),
                      Text('Desktop (Admins)',style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
