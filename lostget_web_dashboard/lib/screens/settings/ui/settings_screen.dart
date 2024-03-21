import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/global/widgets/title_text.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';
import 'package:responsive_admin_dashboard/screens/settings/ui/ChangePhoneNumber.dart';
import 'package:responsive_admin_dashboard/screens/settings/ui/change_password.dart';

import '../../../constants/constants.dart';

enum SettingSelection{NONE,PASSWORD,THEME,PHONE_NUMBER}
class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingSelection selected = SettingSelection.NONE;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(appPadding),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                end: Alignment.centerLeft,
                begin: Alignment.centerRight,
                colors: [
                  green,
                  primaryColor,
                ],
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set Up Your Preferences",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .6,
                    child: Text(
                        "Change your personalize experience for this dashboard, along with your credentials updates",
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: secondaryColor) ,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 60,
                  width: 60,
                  child: Image(
                    image: AssetImage("./assets/icons/preferences.png"),
                  )),
            ],
          ),
        ),
        Responsive.isDesktop(context)?
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 400,
                    margin: EdgeInsets.only(right:10,top:appPadding ),
                    padding: EdgeInsets.all(appPadding),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(appPadding),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              selected = SettingSelection.PASSWORD;
                            });
                          },
                          leading: Icon(Icons.lock_clock_outlined,color: Colors.black,),
                          title: Text("Change Password"),
                          subtitle: Text("Change password strength"),
                          trailing: Icon(Icons.navigate_next_outlined,color: Colors.black,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(appPadding),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              selected = SettingSelection.THEME;
                            });
                          },
                          leading: Icon(Icons.lock_clock_outlined,color: Colors.black,),
                          title: Text("Change Theme"),
                          subtitle: Text("Change theme based on your preference"),
                          trailing: Icon(Icons.navigate_next_outlined,color: Colors.black,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(appPadding),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              selected = SettingSelection.PHONE_NUMBER;
                            });
                          },
                          leading: Icon(Icons.lock_clock_outlined,color: Colors.black,),
                          title: Text("Change Phone number"),
                          subtitle: Text("Change Phone number and let people know you"),
                          trailing: Icon(Icons.navigate_next_outlined,color: Colors.black,),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Expanded(
                    child: Container(
                    height: 400,
                    margin: EdgeInsets.only(left:10,top:appPadding ),
                    padding: EdgeInsets.all(appPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: buildSettingSelectedWidget(selected),
                    ),
                ),
              ],
            )
            :Container()
      ],
    );
  }
  buildSettingSelectedWidget(selected) {
    switch(selected){
      case SettingSelection.NONE:return Center(child: Text("None"),);
      case SettingSelection.PASSWORD:return ChangePassword();
      case SettingSelection.THEME:return Center(child: Text("None"),);
      case SettingSelection.PHONE_NUMBER:return ChangePhoneNumber();
    }
  }
}

