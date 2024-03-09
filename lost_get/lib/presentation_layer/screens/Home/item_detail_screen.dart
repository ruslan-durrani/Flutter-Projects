import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/presentation_layer/screens/Messenger/chat_screen.dart';

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
        // UserProfile userProfile = UserProfile.fromMap(userDoc as Map<String,dynamic>);
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
    bool shouldAutoPlay = widget.item.imageUrls != null && widget.item.imageUrls!.length > 1;

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
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: shouldAutoPlay,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                pageSnapping: widget.item.imageUrls!.length > 1,
              ),
              items: widget.item.imageUrls!.map((item) => Container(
                child: CachedNetworkImage(
                  imageUrl: item,
                  placeholder: (context, url) => const SpinKitFadingCircle(
                    color: AppColors.primaryColor,
                    size: 50.0,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 1000, // This width will ensure high quality image
                ),
              )).toList(),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.item.title ?? 'No title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Category ${widget.item.category ?? 'No category'}', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  SizedBox(height: 16),
                  Text(widget.item.description ?? 'No description', style: Theme.of(context).textTheme.bodySmall!),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.item.status ?? 'No status', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                        backgroundColor: widget.item.status == 'Lost' ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text(formattedDate, style: Theme.of(context).textTheme.bodySmall!),
                    ],
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<UserProfile?>(
                    future: getUserBasedOnUID(widget.item.userId),
                    builder: (context, snapshot) {
                      print("User data ${snapshot.data}");
                      // UserProfile? userProfile = snapshot.data as UserProfile;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
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
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(userProfile.imgUrl ?? 'https://via.placeholder.com/150'),
                              ),
                              title: Text(userProfile.fullName ?? 'No user'),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios_sharp),
                                onPressed: () {

                                },
                              ),
                            ),
                            SizedBox(height: 16),
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

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ChatScreen(userProfile: userProfile,),
                              //   ),
                              // );
                            })
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
