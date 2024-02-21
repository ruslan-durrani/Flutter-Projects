import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/report_item.dart';


class AllItemsGrid extends StatelessWidget {
  // Create a dummy list of items
  final List<ReportItemModel> items = [
    // Add a few dummy items
    ReportItemModel(
      title: 'Lost Laptop',
      description: 'Black Dell laptop lost near the library.',
      status: 'Lost',
      imageUrls: ['url_to_laptop_image'], // Replace with actual URLs
      userId: 'user1',
      category: 'Electronics',
      subCategory: 'Laptops',
      publishDateTime: DateTime.now().subtract(Duration(days: 7)),
      address: 'Library Comsats University Islamabad',
      city: 'Islamabad',
      country: 'Pakistan',
      coordinates: GeoPoint(33.6844, 73.0479), // Replace with actual coordinates
      flagged: false,
      published: true,
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 0.8, // The ratio of the width to the height of each item
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18.0 / 11.0,
                child: Image.network(
                  item.imageUrls!.isNotEmpty ? item.imageUrls!.first : 'url_to_default_image', // Replace with a placeholder or default image if the item has no image
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title ?? 'No title', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(item.description ?? 'No description', style: TextStyle(fontSize: 14.0)),
                    SizedBox(height: 8.0),
                    Text(item.publishDateTime != null ? 'Published ${item.publishDateTime!.toLocal()}' : 'Date unknown'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
