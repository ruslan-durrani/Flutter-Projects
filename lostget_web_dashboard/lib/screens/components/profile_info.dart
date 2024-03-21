

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../global/theme_data_provider/theme_provider.dart';
import '../my_profile/bloc/my_profile_bloc.dart';

class ProfileInfo extends StatelessWidget {
   ProfileInfo({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final myProfileInfo = BlocProvider.of<MyProfileBloc>(context);
    myProfileInfo.add(GetMyProfileDataEvent());
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        GestureDetector(
            onTap: ()=>themeProvider.setTheme(AppTheme.dark),
        child: Icon(Icons.sunny,color:Colors.black,)),
        Padding(
          padding: const EdgeInsets.all(appPadding),
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/Bell.svg",
                height: 25,
                color: textColor.withOpacity(0.8),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: appPadding),
          padding: EdgeInsets.symmetric(
            horizontal: appPadding,
            vertical: appPadding / 2,
          ),
          child: BlocBuilder<MyProfileBloc, MyProfileState>(
            bloc: myProfileInfo,
            builder: (context, state) {
              if(state is MyProfileLoaded){
                final userProfile = state.myProfile;
                return Row(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        userProfile.gender=="Female"? "./assets/images/admin_female_profile_image.png":"./assets/images/admin_male_profile_image.png",
                        height: 38,
                        width: 38,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    if(!Responsive.isMobile(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: appPadding /2),
                        child: Container(
                          child: Text(
                            userProfile.fullName as String,maxLines: 1,softWrap: true, style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w800,
                          ),),
                        ),
                      )
                  ],
                );
              }
              else{
                return Container();
              }
            },
          ),
        )
      ],
    );
  }
}
