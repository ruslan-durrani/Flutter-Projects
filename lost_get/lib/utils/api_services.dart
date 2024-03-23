import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

Future<void> checkProfaneImages(
    {required String id, required String uid}) async {
  var baseUrl = Uri.parse("http://3.89.7.44:5000/check-images/");
  final response = await http.post(
    baseUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      'id': id,
      'uid': uid,
    }),
  );

  if (response.statusCode != 200) {
    createToast(description: "Failed to send api request");
    throw Exception('Failed to post data');
  }
  // Optionally handle the response or response body if needed.
}

Future<List<ReportItemModel>> recommendReports(String uid) async {
  print("working");
  var baseUrl = Uri.parse("http://54.175.58.241:5001/recommend-reports/");
  final response = await http.post(
    baseUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      'uid': uid,
    }),
  );

  if (response.statusCode != 200) {
    createToast(description: "Failed to send api request");
    throw Exception('Failed to post data');
  } else {
    List<dynamic> reportData = json.decode(response.body);
    List<ReportItemModel> ids = reportData
        .map<ReportItemModel>((item) => ReportItemModel.fromJson(item))
        .toList();
    print("Items received ${ids}");
    return ids;
  }
}

Future<bool> checkChatProfanity(String message) async {
  var baseUrl = Uri.parse("http://3.88.202.13:8000/profanity-check/");
  final response = await http.post(
    baseUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      'message': message,
    }),
  );

  if (response.statusCode != 200) {
    createToast(description: "Failed to send api request");
    throw Exception('Failed to post data');
  } else if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    // Check if the key 'profanity' is in the response and is set to 1, indicating true.
    return responseJson['profanity'] == 1 ? true : false;
  } else {
    return false;
  }
}
