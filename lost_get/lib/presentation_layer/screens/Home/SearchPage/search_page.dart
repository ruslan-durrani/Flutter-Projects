import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_detail_page.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

import '../../Add Report/map_screen.dart';
import '../controller/home_screen_reports_controller.dart';
import '../item_detail_screen.dart';
import '../widgets/reportedItemCard.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search_screen";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final HomeScreenController _homeScreenController = HomeScreenController();
  List<ReportItemModel> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      List<ReportItemModel> results = await _homeScreenController.fetchSearchSuggestions(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController keywords = TextEditingController();
  setLocationData() async{
    var locationData = await Navigator.pushNamed(
        context, MapScreen.routeName)
    as Map<String, dynamic>;
    print(locationData);
    city.text = locationData["city"];
    country.text = locationData["country"];
    address.text = locationData["address"];
    _locationController.text = address.text;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(color: AppColors.lightPurpleColor, borderRadius: BorderRadius.circular(100)),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter keyword, category, or location",
              hintStyle: TextStyle(fontSize: 13),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(105.0)), borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Apply Filter'),
                  content: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextField(
                                controller: _locationController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: city.text.isEmpty?"Enter address":"${_locationController.text}",
                                  hintStyle: TextStyle(fontSize: 13,),
                                  prefixIcon: Icon(Icons.location_city,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ), borderSide: BorderSide.none,),
                                ),
                              ),
                              Text("OR",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11)),
                              IconButton(
                                onPressed: setLocationData,
                                icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Choose location",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11)),
                                    Icon(Icons.location_on,color: AppColors.primaryColor,)
                                  ],
                                ),
                              ),
                              city.text.length!=0? Text("📍 ${city.text}, ${address.text}",style:Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11) ,):Container(),
                              
                            ],
                          ),
                          TextField(
                            controller: keywords,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Item Description keywords",
                              hintStyle: TextStyle(fontSize: 13,),
                              prefixIcon: Icon(Icons.description_outlined,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ), borderSide: BorderSide.none,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child:  Text('Cancel',style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14,color: Colors.red),),
                      onPressed: () {
                        city.text="";
                        country.text="";
                        address.text="";
                        keywords.text="";
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Apply'),
                      onPressed: ()  async {
                        if((city.text.isEmpty||address.text.isEmpty||country.text.isEmpty)&&keywords.text.isEmpty) {
                              createToast(
                                  description:
                                      "Filter need fields to be filled");
                              return;
                            }
                        List<ReportItemModel> customeFilter = await HomeScreenController().fetchReportedItemBasedOnSearchFilter(_locationController.text.length>0?address.text:_locationController.text,city.text,country.text,keywords.text);
                        print(customeFilter);
                        Navigator.pushNamed(context, SearchDetailPage.routeName,arguments: {"searchedText":_locationController.text+" "+keywords.text,"reportedItems":customeFilter}).then((value){
                            city.text="";
                            country.text="";
                            address.text="";
                            keywords.text="";
                            Navigator.of(context).pop();
                        });

                      },
                    ),
                  ],
                );
              },
            );


    }, icon: Icon(Icons.filter_alt_rounded,color: AppColors.primaryColor,))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _isSearching
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _searchResults.length % 7,
            itemBuilder: (context, index) {
              final item = _searchResults[index];
              //ReportedItemCard(item: item, onTap: () => onItemTapped(item)))
              return  Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: ()=>onItemTapped(item),
                    child: Container(
                      width: double.maxFinite,
                        child: Text(item.title!,style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black),)),
                  ));
            },
          ),),
          _searchResults.length>0?Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
              onTap:() => Navigator.pushNamed(context, SearchDetailPage.routeName,arguments: {"searchedText":_searchController.text,"reportedItems":_searchResults}),
                child: Text("View All",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.primaryColor,decoration: TextDecoration.underline),)),
          ):Container()
        ],
      ),
    );
  }

  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }
}
