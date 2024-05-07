import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/QRScanner/qr_code_scanner_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_detail_page.dart';
import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_page.dart';
import 'package:lost_get/presentation_layer/screens/Home/ViewAllItems/view_all_items.dart';
import 'package:lost_get/presentation_layer/screens/Home/controller/home_screen_reports_controller.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCarousal.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/section_heading.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:lost_get/utils/api_services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/report_item.dart';
import '../Add Report/map_screen.dart';
import '../ChatBot/chatbot_screen.dart';
import 'components/quick_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "/usersList";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _currentFilter = "All"; // The index of the selected filter

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
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
        appBar: PreferredSize(
          preferredSize: (_currentFilter == "All")
              ? const Size.fromHeight(150.0)
              : const Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0.0,
            toolbarHeight: 100,
            flexibleSpace: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/icons/lostget_logo.svg',
                          width: 120),
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                                'assets/icons/search_icon.svg'), // Replace with your SVG file path
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, SearchPage.routeName);
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
                              Navigator.pushNamed(
                                  context, QRCodeScannerScreen.routeName);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                QuickFilterBar(
                  setLocationData: setLocationData,
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
            bottom: (_currentFilter == "All")
                ? TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primaryColor,
                    tabs: const [
                      Tab(text: 'Recommendations',),
                      Tab(text: 'Nearby'),
                      Tab(text: 'Recent Uploads'),
                    ],
                  )
                : null,
          ),
        ),
        body: Column(
          children: [
            _buildBodyContent(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>Navigator.pushNamed(context, ChatBotScreen.routeName),
          child:Image(image: AssetImage("./assets/icons/bot.png")),
        ),
      ),
    );
  }

  setLocationData() async {
    var locationData = await Navigator.pushNamed(context, MapScreen.routeName)
        as Map<String, dynamic>;
    print(locationData);
    String city = locationData["city"];
    String country = locationData["country"];
    String address = locationData["address"];
    List<ReportItemModel> reportedItemsInACity =
        await controller.fetchReportedItemBasedOnCity(address, city, country);
    if (reportedItemsInACity.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, SearchDetailPage.routeName, arguments: {
        "searchedText": "$address $city",
        "reportedItems": reportedItemsInACity
      });
    } else {
      createToast(description: "No reported items at this place ✅📍");
    }
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
              _buildTabContent('Recent Uploads'),
            ],
          ),
        );
      default:
        return getListOfReport("specific-category");
    }
  }

  Widget _buildTabContent(String category) {
    return FutureBuilder(
      future: controller.fetchAllItems(),
      // future: controller.fetchNearbyItems(), // Implement this method based on your data fetching logic
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching data"));
        } else {
          List<ReportItemModel> items ;
          String itemIfEmpty = "";
          switch (category) {
            case "Recommendations":
              items = controller.listOfRecommendedItems;
              itemIfEmpty = items.isEmpty?"No Recommendations Right Now":"";
              break;
            case "Nearby":
              items = controller.listOfNearbyItems;
              itemIfEmpty = items.isEmpty?"No Nearby item Right Now":"";
              break;
            case "Recent Uploads":
              items = controller.listOfRecentUploads;
              itemIfEmpty = items.isEmpty?"No Recent Uploads":"";
              break;
            default:
              items = controller.listOfNearbyItems;
              break;

          };
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            if(itemIfEmpty!="")Container(height: 200,alignment:Alignment.center,child: Text(itemIfEmpty),),
                for (var item in items)
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReportedItemCard(
                          item: item, onTap: () => onItemTapped(item))),
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

  onSectionHeaderTapped(String title, List<ReportItemModel> reportedItems) {
    Navigator.pushNamed(context, ViewAllItems.routeName,
        arguments: {"title": title, "reportedItemList": reportedItems});
  }
}
