import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/404/error_page.dart';
import 'package:responsive_admin_dashboard/screens/reportedItem_management/ui/reported_item_detail_screen.dart';
import '../../../constants/constants.dart';
import '../../users_management/models/report_item.dart';
import '../provider/reported_item_provider.dart';

List<String> reportedItemsManagementHeaderFields = [
  "Image",
  "Title",
  "Description",
  "Flag",
  "Status",
  "Actions",
];
class ReportedItemManagement extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'title';
  Future<void> deleteUserByEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one user with the specified email
        var userDoc = querySnapshot.docs[0];

        await userDoc.reference.delete();

        toasterFlutter('User with email $userEmail successfully deleted from Firestore.');
      } else {
        toasterFlutter('No user found with the specified email.');
      }
    } catch (error) {
      toasterFlutter('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportedItemsProvider>(context, listen: false).fetchReportedItems();
    });

    final reportedItemsProvider = Provider.of<ReportedItemsProvider>(context);
    List<ReportItemModel> reportedItems = Provider.of<ReportedItemsProvider>(context).reportedItems;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: searchController,
                    hintText: "Search for Item",
                    leading: Padding(
                      padding: EdgeInsets.all(10), child: Icon(Icons.search),),
                    onChanged: (value) {
                      reportedItemsProvider.setSearchQuery(value);
                    },
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (newValue) {
                    selectedFilter = newValue!;
                    reportedItemsProvider.setFilterType(newValue);
                  },
                  items: <String>['title', 'description', 'location']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // children: [
        //   DropdownButton<String>(
        //     value: selectedFilter,
        //     items: <String>['title', 'description', 'location'].map((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value),
        //       );
        //     }).toList(),
        //     onChanged: (newValue) {
        //       selectedFilter = newValue!;
        //       // You might need to adjust your state management here
        //     },
        //   ),
        //   Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.all(28.0),
        //         child: SearchBar(
        //           hintText: "Search for Item",
        //           leading: Padding(
        //             padding: EdgeInsets.all(10), child: Icon(Icons.search),),
        //           onChanged: (value) {
        //           reportedItemsProvider.setSearchQuery(value);
        //           reportedItemsProvider.setFilterType(selectedFilter);
        //           reportedItemsProvider.fetchReportedItems();
        //           },
        //           controller: searchController,
        //         ),
        //       ),)]),

          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => PageNotFound()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete,color: Colors.red,size: 18,),
                                    Text("Delete",style: TextStyle(color: Colors.red,fontSize: 15),)
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
                                      Icon(Icons.lock_clock,color: Colors.black,size: 18,),
                                      Text("Suspend",style: TextStyle(color: Colors.black,fontSize: 15),),
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
        ],
      ),
    );
  }
}



class ReportedItemsData extends DataTableSource {
  final BuildContext context;
  List<ReportItemModel> reportedItems;
  Set<String> _selectedItems = Set<String>();

  ReportedItemsData(this.reportedItems, this.context);

  Future<void> deleteReportedItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('reportedItems').doc(itemId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reported item successfully deleted from Firestore.')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting reported item: $error')));
    }
  }

  Future<void> markItemFlagged(String itemId, bool flagged) async {
    try {
      // Query documents by itemId
      var querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .where('id', isEqualTo: itemId)
          .get();

      // Loop through the documents and update each one
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({"flagged": flagged});
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item flagged status updated for all matching items.')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating item flagged status: $error')));
    }
  }

  Future<void> changeItemStatus(String itemId, String status) async {
    try {
      // Query documents by itemId
      var querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .where('id', isEqualTo: itemId)
          .get();

      // Loop through the documents and update each one
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({"status": status});
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item status updated for all matching items.')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating item status: $error')));
    }
  }


  void toggleSelection(String itemId, bool? isSelected) {
    if (isSelected == true) {
      _selectedItems.add(itemId);
    } else {
      _selectedItems.remove(itemId);
    }
    // Since ReportedItemsData cannot call notifyListeners(), we use a workaround:
    // Triggering a rebuild from the widget that uses this data source.
    Provider.of<ReportedItemsProvider>(context, listen: false).notifyListeners();
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
      selected: _selectedItems.contains(item.id),
      onSelectChanged: (isSelected) => toggleSelection(item.id!, isSelected),
      color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (item.flagged == true) return Colors.red.withOpacity(0.3); // Mark as red if flagged
        return null; // Use default color for unflagged items
      }),
      cells: [
        DataCell(item.imageUrls != null && item.imageUrls!.isNotEmpty
            ? Image.network(item.imageUrls!.first, width: 50, height: 50, fit: BoxFit.cover)
            : Text('No Image')),
        DataCell(Text(item.title ?? "No title")),
        DataCell(Text(item.description ?? "No description")),
        DataCell(Text(item.flagged! ? "Yes" : "No")),
        DataCell(Text(item.status ?? "No status")),
        DataCell(PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'View Details':
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailScreenWeb(item: item)));
                break;
              case 'Delete Item':
                await deleteReportedItem(item.id!);
                break;
              case 'Mark Flagged':
                await markItemFlagged(item.id!, !(item.flagged ?? false));
                break;
              case 'Change Status':
                String newStatus = item.status == "Lost" ? "Found" : "Lost"; // Example toggle logic
                await changeItemStatus(item.id!, newStatus);
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