import 'package:flutter/material.dart';
import 'package:lost_get/business_logic_layer/Provider/modify_report_provider.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/map_screen.dart';
import 'package:provider/provider.dart';

class LocationField extends StatefulWidget {
  String initialLocation;
  LocationField({super.key, required this.initialLocation});

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  late Map<String, dynamic> locationData;
  late String location;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<ModifyReportProvider>()
          .setInitialLocation(widget.initialLocation);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    location = context.watch<ModifyReportProvider>().initialLocation;
    return InkWell(
      onTap: () async {
        locationData = await Navigator.pushNamed(context, MapScreen.routeName)
            as Map<String, dynamic>;

        // ignore: use_build_context_synchronously
        context.read<ModifyReportProvider>().setInitialLocation(
            "${locationData["address"]}, ${locationData["city"]}, ${locationData["country"]}");
        // ignore: use_build_context_synchronously
        context.read<ModifyReportProvider>().setLocationData(locationData);
        // ignore: use_build_context_synchronously
        location = context.watch<ModifyReportProvider>().initialLocation;
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey))),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: const Text(
            "Location *",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            location,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
