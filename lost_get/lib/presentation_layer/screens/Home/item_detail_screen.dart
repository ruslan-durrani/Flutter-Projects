import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/add_report_detail_screen.dart';
import 'package:lost_get/presentation_layer/screens/Messenger/chat_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/constants/colors.dart';
import '../../../models/report_item.dart';
import '../../../models/user_profile.dart';
import '../../../presentation_layer/widgets/button.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = "/item_detail_screen";
  final ReportItemModel item;

  ItemDetailScreen({required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _currentImageIndex = 0;
  String get formattedDate {
    if (widget.item.publishDateTime == null) return 'No date';
    return DateFormat('dd MMM yyyy').format(widget.item.publishDateTime!);
  }

  Future<UserProfile?> getUserBasedOnUID(String? uid) async {
    if (uid == null) {
      print("NUll gaya");
      return null;
    }
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        print("Han jee aahahai");
        print(userDoc.data());
        UserProfile userProfile = UserProfile(
            fullName: userDoc["fullName"],
            uid: userDoc["uid"],
            email: userDoc["email"],
            isAdmin: userDoc["isAdmin"],
            joinedDateTime: (userDoc["joinedDateTime"] as Timestamp).toDate(),
            phoneNumber: userDoc["phoneNumber"],
            biography: userDoc["biography"],
            preferenceList: userDoc["preferenceList"],
            imgUrl: userDoc["imgUrl"],
            dateOfBirth: userDoc["dateOfBirth"],
            gender: userDoc["gender"],
            userChatsList: userDoc["userChatsList"]);
        return userProfile;
      } else {
        print("No user found for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching user for UID: $uid, Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool shouldAutoPlay = false;
    // bool shouldAutoPlay = widget.item.imageUrls != null && widget.item.imageUrls!.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Detail Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Stack(
        alignment: Alignment.topRight,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: shouldAutoPlay,
                viewportFraction: 1.0,
                enableInfiniteScroll: false, // Disables infinite scrolling
                enlargeCenterPage: true,
                pageSnapping: widget.item.imageUrls!.length > 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index; // Update the index when page is changed
                  });
                },
              ),
              items: widget.item.imageUrls!.map((item) => Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(0), // Ensures the dialog takes full screen space
                          backgroundColor: AppColors.primaryColor,
                            child: CachedNetworkImage(
                            imageUrl: item,
                            placeholder: (context, url) => const SpinKitFadingCircle(
                            color: AppColors.primaryColor,
                            size: 50.0,
                            ),
                        ));
                      },);},
                    child: CachedNetworkImage(

                      imageUrl: item,
                      placeholder: (context, url) => const SpinKitFadingCircle(
                        color: AppColors.primaryColor,
                        size: 50.0,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,

                    ),
                  );
                },
              )).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text(
                  '${_currentImageIndex + 1}/${widget.item.imageUrls!.length}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primaryColor,
              ),
            ),],),



            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(widget.item.status ?? 'No status', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                    backgroundColor: widget.item.status == 'Lost' ? Colors.red : Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(formattedDate, style: Theme.of(context).textTheme.bodySmall!),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.item.title ?? 'No title', style: Theme.of(context).textTheme.bodyMedium,),


                  spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                        Text(widget.item.description ?? 'No description', style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),



                  spacer(),


                  Container(
                    padding: EdgeInsets.all(12),
                    color: AppColors.lightPurpleColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Location",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            SvgPicture.asset('assets/icons/location_icon.svg'),
                          ],
                        ),
                        getSpacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("Country",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                              child: Text(getLocation()["country"],style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("City",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                              child: Text(getLocation()["city"],style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("Address",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                              child: Text(getLocation()["address"],style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),


                  spacer(),



                  Container(
                    padding: EdgeInsets.all(12),
                    color: AppColors.lightPurpleColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Item Specifications",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        getSpacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("Category",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                              child: Text(widget.item.category??"category",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("Sub Category",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                              child: Text(widget.item.subCategory??"sub category",style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),



                  spacer(),



                  FutureBuilder<UserProfile?>(
                    future: getUserBasedOnUID(widget.item.userId),
                    builder: (context, snapshot) {
                      print("User data ${snapshot.data}");
                      // UserProfile? userProfile = snapshot.data as UserProfile;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return getShimmerContainer();
                      } else if (snapshot.hasError) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          ),
                          title: Text('User not found'),
                        );
                      } else if (snapshot.data!=null){
                        UserProfile userProfile = snapshot.data!;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(20),
                              tileColor: AppColors.lightPurpleColor,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                backgroundImage: NetworkImage(userProfile.imgUrl ?? 'https://via.placeholder.com/150'),
                              ),

                              title: Text(userProfile.fullName ?? 'No user',style:  Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                              subtitle: Text(
                                "Joined on ${userProfile.joinedDateTime!.day}-"
                                  "${userProfile.joinedDateTime!.month}-"
                                  "${userProfile.joinedDateTime!.year}",
                                style:  Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios_sharp),
                                onPressed: () {

                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            CreateButton(title: "Send message", handleButton: () async {
                              // This button now correctly navigates to the ChatScreen with the userProfile
                              Navigator.pushNamed(
                                context,
                                ChatScreen.routeName,
                                arguments: {
                                  'userProfile': userProfile,
                                  'reportedItemId': widget.item.id,
                                },
                              );

                            })
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                    },
                  ),
                  spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget getShimmerContainer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.white,
                  ),
                  title: Container(
                    height: 10.0,
                    color: Colors.white,
                  ),
                  subtitle: Container(
                    height: 10.0,
                    color: Colors.white,
                  ),
                  trailing: Container(
                    width: 40.0,
                    height: 20.0,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
          // Additional placeholders for other content
        ],
      ),
    );
  }

  Map<String,dynamic> getLocation() {
    return {
      "country":widget.item.country,
      "city":widget.item.city,
      "address":widget.item.address,
    };
    // if (widget.item.city != null) location +="${widget.item.city!}";
    // if (widget.item.address != null) location +=", ${widget.item.address!}";
    // if (widget.item.country != null)  location +=", ${widget.item.country!}";
    // return Text(location,style: Theme.of(context).textTheme.bodySmall,);
  }

  getSpacer() {
    return SizedBox(
      height: 20,
      child: Divider(
        height: 2,
        color: Colors.grey.withOpacity(.5),
      ),
    );


  }
}
