import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';

import '../../../common/constants/colors.dart';
import '../../../models/report_item.dart';

class ItemDetailScreen extends StatelessWidget {
  static const routeName = "/item_detail_screen";
  // Dummy data for the example instance of ReportItemModel
  final ReportItemModel item = ReportItemModel(
    title: 'Lost Drone',
    description: 'A black and white drone with 4 propellers. Last seen near Fairy Meadows.',
    status: 'Lost',
    imageUrls: [
      'https://via.placeholder.com/350x150',
      'https://via.placeholder.com/350x150',
      'https://via.placeholder.com/350x150',
    ],
    userId: 'user123',
    category: 'Technology',
    subCategory: 'Drones',
    publishDateTime: DateTime(2023, 2, 29),
    address: '123 Main St',
    city: 'Gadgetzan',
    country: 'Azeroth',
    coordinates: GeoPoint(40.7128, -74.0060),
    flagged: false,
    published: true,
  );

  String get formattedDate {
    if (item.publishDateTime == null) return 'No date';
    return DateFormat('dd MMM yyyy').format(item.publishDateTime!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Detail Page',
        style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: item.imageUrls!.map((item) => Container(
                child: CachedNetworkImage(
                  imageUrl: item,
                  placeholder: (context, url) =>  const SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: 50,
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
                  Text(item.title ?? 'No title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Category ${item.category ?? 'No category'}', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  SizedBox(height: 16),
                  Text(item.description ?? 'No description', style: Theme.of(context).textTheme.bodySmall!),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        label: Text(item.status ?? 'No status', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                        backgroundColor: item.status == 'Lost' ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 10,),
                      Text(formattedDate, style: Theme.of(context).textTheme.bodySmall!),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    title: Text('User ${item.userId ?? 'No user'}'),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_sharp),
                      onPressed: () {
                        // Implement messaging functionality
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  CreateButton(title: "Send message", handleButton: (){})
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

}