import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/colors.dart';

class SearchPage extends StatelessWidget {
  static const routeName = "/search_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(color: AppColors.lightPurpleColor,borderRadius: BorderRadius.circular(100)),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter keyword, category, or location",
              hintStyle: TextStyle(
                  fontSize: 13
              ),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(105.0)),
                  borderSide: BorderSide.none
              ),
            ),
            onSubmitted: (value) {
              // Handle search operation here
            },
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("Search for item"),),
      ),
    );
  }
}
