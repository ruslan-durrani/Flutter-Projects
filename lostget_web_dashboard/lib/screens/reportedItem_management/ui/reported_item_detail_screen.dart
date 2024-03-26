import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../users_management/models/report_item.dart';
import '../../users_management/models/user_profile.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

class ItemDetailScreenWeb extends StatefulWidget {
  static const routeName = "/item_detail_screen";
  final ReportItemModel item;

  ItemDetailScreenWeb({required this.item});

  @override
  State<ItemDetailScreenWeb> createState() => _ItemDetailScreenWebState();
}

class _ItemDetailScreenWebState extends State<ItemDetailScreenWeb> {
  int _currentImageIndex = 0;

  String get formattedDate => widget.item.publishDateTime != null
      ? DateFormat('dd MMM yyyy').format(widget.item.publishDateTime!)
      : 'No date';

  Future<UserProfile?> getUserBasedOnUID(String? uid) async {
    if (uid == null) return null;
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserProfile.fromSnapshot(userDoc);
      }
    } catch (e) {
      print("Error fetching user for UID: $uid, Error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item Detail Page')),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 3.0,
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
                              backgroundColor: primaryColor,
                              child: CachedNetworkImage(
                                imageUrl: item,
                                placeholder: (context, url) => CircularProgressIndicator()
                              )
                          );
                        },);},
                    child: CachedNetworkImage(

                      imageUrl: item,
                      placeholder: (context, url) => CircularProgressIndicator(),
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
                backgroundColor: primaryColor,
              ),
            ),],),
      ),
    );
  }

// Helper methods (getLocation, getSpacer) if needed...
}
