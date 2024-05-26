import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mental_healthapp/features/auth/controller/auth_controller.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/auth/screens/login_screen.dart';
import 'package:mental_healthapp/features/profile/screens/book_marks_screen.dart';
import 'package:mental_healthapp/features/profile/screens/booking_view.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/utils/get_drawer.dart';
import 'package:mental_healthapp/shared/utils/pick_image.dart';

import '../../chat/screens/message_screen.dart';
import '../../check_in/screens/final_report.dart';
import '../../check_in/screens/mood_tracker.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  Future logout() async {
    await ref.read(authControllerProvider).signOutUser();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future pickImage() async {
    showLoadingDialog();  // Show the loading dialog
    File? file = await pickImageFromGallery(context);
    if (file != null) {
      await ref.read(profileControllerProvider).uploadPicture(file);
      setState(() {});
    }
    Navigator.pop(context);
  }
  Future<void> showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Text("Updating profile..."),
            ],
          ),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: GetDrawer(),
      backgroundColor: EColors.white,
      body: SingleChildScrollView(
        child: Container(
          color: EColors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                decoration:  BoxDecoration(
                  color: EColors.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Profile👋🏻",
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
                                style: GoogleFonts.openSans(
                                    color: Colors.grey[300], fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: EColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const MessageScreen(),
                                      ),
                                    );
                                  },
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
                                    child: Icon(
                                      Icons.message,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: EColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: ref.read(profileRepositoryProvider).profile?.profilePic == null
                        ? const AssetImage('assets/images/default_avatar.png') as ImageProvider
                        : NetworkImage(ref.read(profileRepositoryProvider).profile!.profilePic!),
                    backgroundColor: Colors.transparent,
                  ),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                ref.read(profileControllerProvider).getProfileName(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileStatistic('Following', ref.read(profileRepositoryProvider).profile!.followingCount),
                    ProfileStatistic('Followers', ref.read(profileRepositoryProvider).profile!.followerCount),
                  ],
                ),
              ),
              ProfileTile(
                name: 'My Bookings',
                iconData: FontAwesomeIcons.solidCalendarCheck,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingView())),
              ),
              ProfileTile(
                name: 'Saved Items',
                iconData: FontAwesomeIcons.bookmark,
                onTap: () => Navigator.pushNamed(context, BookMarksScreen.routeName),
              ),
              ProfileTile(
                name: 'Logout',
                iconData: Icons.logout,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Hive.box('mybox').clear();
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileStatistic extends StatelessWidget {
  final String label;
  final int count;
  const ProfileStatistic(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count<0?"0":count.toString(), style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String name;
  final IconData iconData;
  final VoidCallback onTap;

  const ProfileTile({super.key, required this.name, required this.iconData, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: onTap,
        tileColor: Color.fromARGB(255, 230, 242, 250),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(iconData, color: EColors.primaryColor),
        title: Text(name, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:mental_healthapp/features/auth/controller/auth_controller.dart';
// import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
// import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
// import 'package:mental_healthapp/features/auth/screens/login_screen.dart';
// import 'package:mental_healthapp/features/profile/screens/book_marks_screen.dart';
// import 'package:mental_healthapp/features/profile/screens/booking_view.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
// import 'package:mental_healthapp/shared/utils/pick_image.dart';
//
// class ProfileView extends ConsumerStatefulWidget {
//   const ProfileView({super.key});
//
//   @override
//   ConsumerState<ProfileView> createState() => _ProfileViewState();
// }
//
// class _ProfileViewState extends ConsumerState<ProfileView> {
//   Future logout() async {
//     ref.read(authControllerProvider).signOutUser();
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginScreen(),
//       ),
//     );
//   }
//
//   Future pickImage() async {
//     File? file = await pickImageFromGallery(context);
//     if (file != null) {
//       await ref.read(profileControllerProvider).uploadPicture(file);
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: EColors.primaryColor,
//         title: Text(
//           "Profile View",
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Stack(
//             children: [
//               Container(
//                 height: 180,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: ref
//                                 .read(profileRepositoryProvider)
//                                 .profile!
//                                 .profilePic ==
//                             null
//                         ? const AssetImage('assets/images/man.png')
//                         : NetworkImage(ref
//                             .read(profileRepositoryProvider)
//                             .profile!
//                             .profilePic!) as ImageProvider,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 140,
//                 left: size.width * 0.6,
//                 child: GestureDetector(
//                   onTap: pickImage,
//                   child: Container(
//                     height: 50,
//                     decoration: const BoxDecoration(
//                       color: Colors.cyan,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.add),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             ref.read(profileControllerProvider).getProfileName(),
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 'Following: ${ref.read(profileRepositoryProvider).profile!.followingCount}',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               Text(
//                 'Followers: ${ref.read(profileRepositoryProvider).profile!.followerCount}',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ProfileTile(
//             name: 'Bookings',
//             iconData: FontAwesomeIcons.file,
//             ontap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => BookingView()));
//             },
//           ),
//           ProfileTile(
//             name: 'Book Marks',
//             iconData: FontAwesomeIcons.clock,
//             ontap: () =>
//                 Navigator.pushNamed(context, BookMarksScreen.routeName),
//           ),
//           ProfileTile(
//             name: 'Logout',
//             iconData: Icons.logout,
//             ontap: () {
//               Hive.box('mybox').clear();
//               logout();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class ProfileTile extends StatelessWidget {
//   final String name;
//   final IconData iconData;
//   VoidCallback ontap;
//   ProfileTile(
//       {super.key,
//       required this.name,
//       required this.iconData,
//       required this.ontap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: ontap,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Color.fromARGB(255, 200, 242, 244),
//               borderRadius: BorderRadius.circular(10)),
//           child: ListTile(
//             leading: Icon(iconData),
//             title: Text(
//               name,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
