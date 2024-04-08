import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/QRScanner/qr_code_scanner_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_page.dart';
import 'package:lost_get/presentation_layer/screens/Home/ViewAllItems/view_all_items.dart';
import 'package:lost_get/presentation_layer/screens/Home/controller/home_screen_reports_controller.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCarousal.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/section_heading.dart';
import 'package:lost_get/utils/api_services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/report_item.dart';
import '../ChatBot/chatbot_screen.dart';
import 'components/quick_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "/usersList";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with SingleTickerProviderStateMixin{
  String _currentFilter = "All"; // The index of the selected filter

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3,initialIndex: 0,vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  // Define a method to handle filter change
  void _handleFilterChange(String filter) {
    setState(() {
      _currentFilter = filter;
    });

  }

  HomeScreenController controller = HomeScreenController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:PreferredSize(

          preferredSize: (_currentFilter == "All")? Size.fromHeight(150.0):Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0.0,
            toolbarHeight: 100,
            flexibleSpace: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/icons/lostget_logo.svg', width: 120),
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                                'assets/icons/search_icon.svg'), // Replace with your SVG file path
                            onPressed: () {
                              Navigator.pushNamed(context, SearchPage.routeName);
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                                'assets/icons/notification_icon.svg'), // Replace with your SVG file path
                            onPressed: () {
                              // Action for notification icon
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                                'assets/icons/scan_qr_icon.svg'), // Replace with your SVG file path
                            onPressed: () {
                              Navigator.pushNamed(context, QRCodeScannerScreen.routeName);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                QuickFilterBar(
                  onFilterSelected: _handleFilterChange,
                  categories: const [
                    'All',
                    "Electronics",
                    "Personal Items",
                    'Travel Documents',
                    'Animal',
                    'Human'
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,

            bottom: (_currentFilter == "All")?TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Recommendations'),
                Tab(text: 'Nearby'),
                // Tab(text: 'Categories'),
                Tab(text: 'Recent Uploads'),
                // Add more tabs as needed
              ],
            ):null,
          ),


        ),
        body: Column(
          children: [
            _buildBodyContent(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   onPressed: () => Navigator.pushNamed(context, ChatBotScreen.routeName),
        //   child: const Image(
        //       height: 40, image: AssetImage("./assets/icons/bot.png")),
        // ),
      ),
    );
  }

  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }

  Widget _buildBodyContent() {
    switch (_currentFilter) {
      case "All":
        return Expanded(
          child: TabBarView(
                controller: _tabController,
                children: [
                _buildTabContent('Recommendations'),
                _buildTabContent('Nearby'),
                // _buildTabContent('Categories'),
                _buildTabContent('Recent Uploads'),
                // Add more tab content as needed
                ],
              ),
        );

      default:
        return getListOfReport("specific-category");
    }
  }

  Widget _buildTabContent(String category) {
    // Dummy FutureBuilder implementation, replace with actual data fetching
    return FutureBuilder(
      future: controller.fetchAllItems(), // Implement this method based on your data fetching logic
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        } else {
          // Assuming snapshot.data is a list of items for the category
          List<ReportItemModel> items = controller.listOfRecommendedItems;
          return SingleChildScrollView(
            child: Column(
              children: [
                for (var item in items)
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReportedItemCard(item: item, onTap: () => onItemTapped(item))),
                // Replace with your widget for displaying each item
              ],
            ),
          );
        }
      },
    );
  }
  Widget getShimmerContainer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Column(
            children: [
              getSectionHeading("Reported Items", context, () {}),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: AppColors.primaryColor.withOpacity(.2),
                    ),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          height: 200,
                          decoration: const BoxDecoration(
                            // color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text("Status",
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.white,
                              ),
                              Chip(
                                label: Text("Date",
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Title",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: '\n',
                                ),
                                TextSpan(
                                  text: "City",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Add more sections as needed
            ],
          ),
        ],
      ),
    );
  }

  Widget getListOfReport(String type) {
    return Expanded(
      child: FutureBuilder<List<ReportItemModel>>(
        future: controller.specificCategory(_currentFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No items found in this category"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ReportItemModel item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReportedItemCard(
                      item: item, onTap: () => onItemTapped(item)),
                );
              },
            );
          }
        },
      ),
    );
  }

  onSectionHeaderTapped(String title,List<ReportItemModel> reportedItems) {
    Navigator.pushNamed(context, ViewAllItems.routeName, arguments: {
      "title":title,
      "reportedItemList": reportedItems
    });
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lost_get/common/constants/colors.dart';
// import 'package:lost_get/presentation_layer/screens/Home/QRScanner/qr_code_scanner_screen.dart';
// import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_page.dart';
// import 'package:lost_get/presentation_layer/screens/Home/ViewAllItems/view_all_items.dart';
// import 'package:lost_get/presentation_layer/screens/Home/controller/home_screen_reports_controller.dart';
// import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
// import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';
// import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCarousal.dart';
// import 'package:lost_get/presentation_layer/screens/Home/widgets/section_heading.dart';
// import 'package:lost_get/utils/api_services.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../models/report_item.dart';
// import '../ChatBot/chatbot_screen.dart';
// import 'components/quick_filter.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//   static String routeName = "/usersList";
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final HomeScreenController controller = HomeScreenController();
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this); // Adjust length based on the number of tabs
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar:PreferredSize(
//           preferredSize: Size.fromHeight(150.0),
//           child: AppBar(
//             toolbarHeight: 100,
//             flexibleSpace: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SvgPicture.asset('assets/icons/lostget_logo.svg', width: 120),
//                       Row(
//                         children: [
//                             IconButton(
//                               icon: SvgPicture.asset(
//                                   'assets/icons/search_icon.svg'), // Replace with your SVG file path
//                               onPressed: () {
//                                 Navigator.pushNamed(context, SearchPage.routeName);
//                               },
//                             ),
//                             IconButton(
//                               icon: SvgPicture.asset(
//                                   'assets/icons/notification_icon.svg'), // Replace with your SVG file path
//                               onPressed: () {
//                                 // Action for notification icon
//                               },
//                             ),
//                             IconButton(
//                               icon: SvgPicture.asset(
//                                   'assets/icons/scan_qr_icon.svg'), // Replace with your SVG file path
//                               onPressed: () {
//                                 Navigator.pushNamed(context, QRCodeScannerScreen.routeName);
//                               },
//                             ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//           QuickFilterBar(
//             onFilterSelected: (s){},
//             // onFilterSelected: _handleFilterChange,
//             categories: const [
//               'All',
//               "Electronics",
//               "Personal Items",
//               'Travel Documents',
//               'Animal',
//               'Human'
//             ],
//           ),
//               ],
//             ),
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//
//             bottom: TabBar(
//               controller: _tabController,
//               indicatorColor: AppColors.primaryColor,
//               tabs: [
//                 Tab(text: 'Recommendations'),
//                 Tab(text: 'Nearby'),
//                 Tab(text: 'Categories'),
//                 Tab(text: 'Recent Uploads'),
//                 // Add more tabs as needed
//               ],
//             ),
//           ),
//
//
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _buildTabContent('Recommendations'),
//             _buildTabContent('Nearby'),
//             _buildTabContent('Categories'),
//             _buildTabContent('Recent Uploads'),
//             // Add more tab content as needed
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(String category) {
//     // Dummy FutureBuilder implementation, replace with actual data fetching
//     return FutureBuilder(
//       future: controller.myRecentUploads(), // Implement this method based on your data fetching logic
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text("Error fetching data"));
//         } else {
//           // Assuming snapshot.data is a list of items for the category
//           List<ReportItemModel> items = controller.listOfRecentUploads;
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 for (var item in items)
//                   ReportedItemCard(item: item, onTap: () => onItemTapped(item)),
//                 // Replace with your widget for displaying each item
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   void onItemTapped(ReportItemModel item) {
//     Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
//   }
// }
