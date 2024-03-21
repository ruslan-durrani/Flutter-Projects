import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';
import '../../constants/constants.dart';
import '../users_management/models/userProfile.dart';

class AdministrationInfoDetail extends StatelessWidget {
  final UserProfile info;
  AdministrationInfoDetail({Key? key, required this.info}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              info.imgUrl != ""? info.imgUrl!:
              info.imgUrl == "" && info.gender == ""
                  ? genderImages["Male"]!
                  : genderImages[info.gender]??"",
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.fullName!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Joined at ${info.joinedDateTime!.month}/${info.joinedDateTime!.day}/${info.joinedDateTime!.year}',
                    // "${info.joinedDateTime?.day}/${info.joinedDateTime?.month}/${info.joinedDateTime?.year}",
                    style: TextStyle(
                        color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.more_vert_rounded,color: textColor.withOpacity(0.5),size: 18,)
        ],
      ),
    );
  }
}
