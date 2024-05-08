import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:lost_get/utils/location_utils.dart';

import '../../../../models/police_stations.dart'; // Assuming this import is used elsewhere or can be removed if not needed.


class ReportsPoliceStations extends StatefulWidget {
  final ReportItemModel reportedItem;
  ReportsPoliceStations({super.key, required this.reportedItem});

  static const routeName = '/police_station_reports_screen';

  @override
  State<ReportsPoliceStations> createState() => _ReportsPoliceStationsState();
}

class _ReportsPoliceStationsState extends State<ReportsPoliceStations> {
  void _sendReportToStation(PoliceStation station) async {
    try {
      await FirebaseFirestore.instance.collection('reportedToNeabyStations').add({
        'reportId': widget.reportedItem.id,
        'reportedBy': widget.reportedItem.userId,
        'stationId': station.docId,
      });
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .where("id", isEqualTo: widget.reportedItem.id)
          .get();
      querySnapshot.docs.first.reference.update(
          {
            'hasReportToPoliceStationStarted': true
          }
      );

      Navigator.pop(context);
      createToast(description: "Report sent successfully to ${station.stationName}");
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context); // Close the dialog even if there is an error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending report: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Police Stations Nearby", style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: LocationUtils(10).queryNearbyPoliceStations(widget.reportedItem.coordinates!, 10),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<PoliceStation> stations = snapshot.data!.docs
              .map((doc) => PoliceStation.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
              .toList();
          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, stations[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, PoliceStation station) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.1),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width *.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.stationName, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                    Text(station.address, style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: (){
                  showDialog(context: context, builder: (_){
                    return AlertDialog(
                      icon: Icon(Icons.send_to_mobile),
                      title: Text("Are you sure you want to report?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14),),
                      content: Text("Your report will be send to ${station.stationName}",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14),),
                      actions: [
                        ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancel",style: TextStyle(color: Colors.red),),),
                        ElevatedButton(onPressed: ()=>_sendReportToStation(station), child: Text("Send Report",style: TextStyle(color: Colors.green)),),
                      ],
                    );
                  });
              }, child: Text("Report")),
            ],
          ),
        ],
      ),
    );
  }
}
