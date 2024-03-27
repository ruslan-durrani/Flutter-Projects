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

class _HomeScreenState extends State<HomeScreen> {
  String _currentFilter = "All"; // The index of the selected filter

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        title: SvgPicture.asset('assets/icons/lostget_logo.svg', width: 120),
        actions: <Widget>[
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
      ),
      body: Column(
        children: [
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
          _buildBodyContent()
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () => Navigator.pushNamed(context, ChatBotScreen.routeName),
      //   child: const Image(
      //       height: 40, image: AssetImage("./assets/icons/bot.png")),
      // ),
    );
  }

  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }

  Widget _buildBodyContent() {
    switch (_currentFilter) {
      case "All":
        return Expanded(
          // height: MediaQuery.of(context).size.height * .7,
          child: SingleChildScrollView(
            child: Container(
               padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  FutureBuilder(
                    future: controller.fetchAllItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Container());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error fetching data"));
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              controller.listOfRecommendedItems.isNotEmpty
                                  ? getSectionHeading(
                                      "Recommendations", context, ()=>onSectionHeaderTapped("Recommendation",controller.listOfRecommendedItems))
                                  : Container(),
                              controller.listOfRecommendedItems.isNotEmpty
                                  ? ReportedItemsCarousel(
                                      reportedItems:
                                          controller.listOfRecommendedItems,
                                      onTap: onItemTapped)
                                  : Container(),
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
                        return const Center(child: Text("Error fetching data"));
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              getSectionHeading("Nearby", context, ()=>onSectionHeaderTapped("Nearby",controller.listOfRecommendedItems)),
                              ReportedItemsCarousel(
                                  reportedItems: controller.listOfNearbyItems,
                                  onTap: (item) {}),
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
                        return const Center(child: Text("Error fetching data"));
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              getSectionHeading("Categories", context, () {}),
                              ReportedItemsCarousel(
                                  reportedItems:
                                      controller.listOfRecommendedItems,
                                  onTap: (item) => onItemTapped(item)),
                              // Add more sections as needed
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: controller.myRecentUploads(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return getShimmerContainer();
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error fetching data"));
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              getSectionHeading("Recent Uploads", context, ()=>onSectionHeaderTapped("Recent Uploads",controller.listOfRecentUploads)),
                              ReportedItemsCarousel(
                                  reportedItems:
                                      controller.listOfRecentUploads,
                                  onTap: (item) => onItemTapped(item)),
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
          ),
        );

      default:
        return getListOfReport("specific-category");
    }
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
