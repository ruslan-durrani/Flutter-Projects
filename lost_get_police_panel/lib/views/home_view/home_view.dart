import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/models/reportedItems.dart';
import 'package:lost_get_police_panel/views/widgets/get_buttons.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

enum filters{All,Lost, Stolen}

class _HomeViewState extends State<HomeView> {
  String activeFilter = filters.All.name;
  List<String> reportedItemsManagementHeaderFields = [
    "Image",
    "Title",
    "Description",
    "Flag",
    "Status",
    "Police Action",
    "Actions",
  ];

  filterActive(String filter){
    setState(() {
      activeFilter = filter;
      getReportsBasedOnFilter(activeFilter);
    });
  }
  getReportsBasedOnFilter(String activeFilter){
    if (activeFilter == filters.Lost.name){
        //TODO fill reported Item
       reportedItems = [
        ReportItemModel(
          id: 'report1',
          title: 'LOST ITEM',
          description: 'I lost my wallet in Central Park near the fountain.',
          status: 'Open',
          imageUrls: [
            'https://example.com/image1.jpg',
            'https://example.com/image2.jpg'
          ],
          userId: 'user123',
          category: 'Personal Items',
          subCategory: 'Wallet',
          publishDateTime: DateTime.now(),
          address: 'Central Park, New York',
          city: 'New York',
          country: 'USA',
          coordinates: GeoPoint(1,1),
          flagged: false,
          published: true,
          recovered: false,
        )
      ];
    }
    else if (activeFilter == filters.Stolen.name){
        //TODO fill reported Item
      reportedItems = [
        ReportItemModel(
          id: 'report1',
          title: 'STOLEN ITEM',
          description: 'I lost my wallet in Central Park near the fountain.',
          status: 'Open',
          imageUrls: [
            'https://example.com/image1.jpg',
            'https://example.com/image2.jpg'
          ],
          userId: 'user123',
          category: 'Personal Items',
          subCategory: 'Wallet',
          publishDateTime: DateTime.now(),
          address: 'Central Park, New York',
          city: 'New York',
          country: 'USA',
          coordinates: GeoPoint(1,1),
          flagged: false,
          published: true,
          recovered: false,
        )
      ];
    }
    else{
        //TODO fill reported Item
      reportedItems = [
        ReportItemModel(
          id: 'report1',
          title: 'REPORTED ALL ITEM',
          description: 'I lost my wallet in Central Park near the fountain.',
          status: 'Open',
          imageUrls: [
            'https://example.com/image1.jpg',
            'https://example.com/image2.jpg'
          ],
          userId: 'user123',
          category: 'Personal Items',
          subCategory: 'Wallet',
          publishDateTime: DateTime.now(),
          address: 'Central Park, New York',
          city: 'New York',
          country: 'USA',
          coordinates: GeoPoint(1,1),
          flagged: false,
          published: true,
          recovered: false,
        )
      ];
    }
  }

  List<ReportItemModel> reportedItems = [
      ReportItemModel(
        id: 'report1',
        title: 'Lost Wallet',
        description: 'I lost my wallet in Central Park near the fountain.',
        status: 'Open',
        imageUrls: [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg'
        ],
        userId: 'user123',
        category: 'Personal Items',
        subCategory: 'Wallet',
        publishDateTime: DateTime.now(),
        address: 'Central Park, New York',
        city: 'New York',
        country: 'USA',
        coordinates: GeoPoint(1,1),
        flagged: false,
        published: true,
        recovered: false,
        )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.logo_dev_outlined,color: Theme.of(context).colorScheme.primary,size: 70,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Police - i8/1",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                      Text("Location Police - i8/1",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),)
                    ],
                  )
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getButton(filters.All.name,activeFilter, context, filterActive, ),
                getButton(filters.Lost.name,activeFilter, context, filterActive),
                getButton(filters.Stolen.name,activeFilter, context, filterActive),
                ],
            ),


            Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: PaginatedDataTable(
                columns: [
                  ...reportedItemsManagementHeaderFields
                      .map((e) => DataColumn(label: Text(e)))
                      .toList()
                ],
                source: ReportedItemsData(reportedItems, context),
                showCheckboxColumn: true,
                header:  Row(
                  children: [
                    Text('Reported items'),
                    Spacer(),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(.1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_box,color: Colors.green,size: 18,),
                                Text("Reproted",style: TextStyle(color: Colors.green,fontSize: 15),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: (){
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                children: [
                                  Text("24",style: TextStyle(color: Colors.black,fontSize: 15),),
                                  SizedBox(width: 5,),
                                  Icon(Icons.lock_clock,color: Colors.black,size: 18,),
                                  SizedBox(width: 10,),
                                  Text("Not Reported",style: TextStyle(color: Colors.black,fontSize: 15),),
                                ],
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                columnSpacing: 60,
                horizontalMargin: 50,
                rowsPerPage: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}









class ReportedItemsData extends DataTableSource {
  final BuildContext context;
  List<ReportItemModel> reportedItems;
  Set<String> _selectedItems = Set<String>();

  ReportedItemsData(this.reportedItems, this.context);

  // Future<void> deleteReportedItem(String itemId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('reportedItems').doc(itemId).delete();
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reported item successfully deleted from Firestore.')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting reported item: $error')));
  //   }
  // }

  // Future<void> markItemFlagged(String itemId, bool flagged) async {
  //   try {
  //     // Query documents by itemId
  //     var querySnapshot = await FirebaseFirestore.instance
  //         .collection('reportItems')
  //         .where('id', isEqualTo: itemId)
  //         .get();
  //
  //     // Loop through the documents and update each one
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.update({"flagged": flagged});
  //     }
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item flagged status updated for all matching items.')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating item flagged status: $error')));
  //   }
  // }

  // Future<void> changeItemStatus(String itemId, String status) async {
  //   try {
  //     // Query documents by itemId
  //     var querySnapshot = await FirebaseFirestore.instance
  //         .collection('reportItems')
  //         .where('id', isEqualTo: itemId)
  //         .get();
  //
  //     // Loop through the documents and update each one
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.update({"status": status});
  //     }
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item status updated for all matching items.')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating item status: $error')));
  //   }
  // }


  void toggleSelection(String itemId, bool? isSelected) {
    if (isSelected == true) {
      _selectedItems.add(itemId);
    } else {
      _selectedItems.remove(itemId);
    }
    // Provider.of<ReportedItemsProvider>(context, listen: false).notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final item = reportedItems[index];

    return DataRow.byIndex(
      index: index,
      color:  MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        return Theme.of(context).colorScheme.secondary;
      }),
      cells: [
        DataCell(item.imageUrls != null && item.imageUrls!.isNotEmpty
            ? Image.network(item.imageUrls!.first, width: 50, height: 50, fit: BoxFit.cover)
            : Text('No Image')),
        DataCell(Text(item.title ?? "No title")),
        DataCell(Text(item.description ?? "No description")),
        DataCell(Text(item.flagged! ? "Yes" : "No")),
        DataCell(Text(item.status ?? "No status")),
        DataCell(Text(item.status ?? "Waiting")),
        DataCell(PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'View Details':
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailScreenWeb(item: item)));
                break;
              case 'Delete Item':
                // await deleteReportedItem(item.id!);
                break;
              case 'Mark Flagged':
                // await markItemFlagged(item.id!, !(item.flagged ?? false));
                break;
              case 'Change Status':
                String newStatus = item.status == "Lost" ? "Found" : "Lost"; // Example toggle logic
                // await changeItemStatus(item.id!, newStatus);
                break;
              default:
                print("No action selected");
            }
          },
          itemBuilder: (BuildContext context) {
            return {'View Details', 'Delete Item', 'Mark Flagged', 'Change Status'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )),
      ],
    );
  }

  @override
  int get rowCount => reportedItems.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => _selectedItems.length;
}