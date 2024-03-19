import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/presentation_layer/screens/Home/components/all_items.dart';
import 'package:lost_get/presentation_layer/screens/Home/controller/home_screen_reports_controller.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCarousal.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/section_heading.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/report_item.dart';
import '../../widgets/my_user_component.dart';
import '../ChatBot/chatbot_screen.dart';
import '../Messenger/chat_screen.dart';
import 'components/quick_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "/usersList";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _currentFilter = "All"; // The index of the selected filter

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // Define a method to handle filter change
  void _handleFilterChange(String filter) {
    setState(() {
      _currentFilter = filter;
    });
    // You can also fetch data based on the selected filter here
  }
  HomeScreenController controller = HomeScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/icons/lostget_logo.svg'), // Replace with your SVG file path
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset('assets/icons/search_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for search icon
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/notification_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for notification icon
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/scan_qr_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for profile icon
            },
          ),
        ],
      ),
      body: Column(
        children: [
          QuickFilterBar(
            onFilterSelected: _handleFilterChange, categories: ['All',"Electronics" ,"Human",'Mobile', 'Cars', 'Wallet'], // Pass the filter change handler
          ),
      _buildBodyContent()
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed:() => Navigator.pushNamed(context, ChatBotScreen.routeName),
        child: const Image(
            height: 40,
            image: AssetImage("./assets/icons/bot.png")
        ),
      ),
    );
  }

  onItemTapped(item){
    Navigator.pushNamed(context, ItemDetailScreen.routeName,arguments: item);
  }
  Widget _buildBodyContent() {
    // Based on the selected filter index, return different Widgets/content

    switch (_currentFilter) {
      case "All":
        return Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: controller.fetchAllItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching data"));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            getSectionHeading("Recommendations", context, (){}),
                            ReportedItemsCarousel(reportedItems: controller.listOfRecommendedItems, onTap: onItemTapped),
                            // Add more sections as needed
                          ],
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: controller.fetchAllItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return getShimmerContainer();
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching data"));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            getSectionHeading("Nearby", context, (){}),
                            ReportedItemsCarousel(reportedItems: controller.listOfRecommendedItems, onTap: (item) {}),
                            // Add more sections as needed
                          ],
                        ),
                      );
                    }
                  },
                ),

                FutureBuilder(
                  future: controller.fetchAllItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return getShimmerContainer();
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching data"));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            getSectionHeading("Categories", context, (){}),
                            ReportedItemsCarousel(reportedItems: controller.listOfRecommendedItems, onTap: (item)=>onItemTapped(item)),
                            // Add more sections as needed
                          ],
                        ),
                      );
                    }
                  },
                ),

                FutureBuilder(
                  future: controller.fetchAllItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return getShimmerContainer();
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error fetching data"));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            getSectionHeading("Recent Uploads", context, (){}),
                            ReportedItemsCarousel(reportedItems: controller.listOfRecommendedItems, onTap: (item)=>{print("DaNNY")}),
                            // Add more sections as needed
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      //
      // case 1:
      // // Replace with your actual content for 'Mobile'
      //
      //   return ListView(
      //       children:[
      //         Text('Mobile selected'),
      //         ReportedItemsCarousel(reportedItems: controller.listOfRecommendedItems, onTap: (item)=>onItemTapped(item))
      //       ]
      //   );
      // case 2:
      // // Replace with your actual content for 'Cars'
      //   return Center(child: Text('Cars selected'));
      // case 3:
      // // Replace with your actual content for 'Wallet'
      //   return Center(child: Text('Wallet selected'));
      default:
        return Expanded(
          child: FutureBuilder<List<ReportItemModel>>(
            future: controller.specificCategory(_currentFilter),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("An error occurred"));
              } else if (snapshot.data!.isEmpty) {
                return Center(child: Text("No items found in this category"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {

                    final ReportItemModel item = snapshot.data![index];
                    return ReportedItemCard(item: item, onTap: ()=>onItemTapped(item));
                  },
                );
              }
            },
          ),
        );
    }
  }

  Widget getShimmerContainer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Recommendation Header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommendations',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'view all',
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ],
            ),
          ),
          // Example of a shimmer effect on a card
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

}










// floatingActionButton: Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//
//       FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed:() => Navigator.pushNamed(context, ChatBotScreen.routeName),
//         child: const Image(
//             height: 40,
//             image: AssetImage("./assets/icons/bot.png")
//         ),
//       ),
//       FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed:() => Navigator.pushNamed(context, ChatBotScreen.routeName),
//         child: SvgPicture.asset('assets/icons/scan_qr_icon.svg',height: 30,), // Replace with your SVG file path
//       ),
//     ],
//   ),
// )