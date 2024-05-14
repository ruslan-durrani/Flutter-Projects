import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

const String recommendationUri = "http://54.89.149.245:5001/recommend-reports/";
const String profaneImagesUri = "http://54.242.56.162:5000/check-images/";
const String profanityChatsUri = "http://52.87.218.91:8000/profanity-check/";
const String reportAiMatchMakerUri =
    "http://54.91.227.25:7000/auto-report-similarity/";

Future<void> checkProfaneImages(
    {required String id, required String uid}) async {
  var baseUrl = Uri.parse(profaneImagesUri);
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
}

Future<List<ReportItemModel>> recommendReports(String uid) async {
  print("working");
  var baseUrl = Uri.parse(recommendationUri);
  // var baseUrl = Uri.parse("http://54.175.58.241:5001/recommend-reports/");
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
  var baseUrl = Uri.parse(profanityChatsUri);
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

Future<void> startAIMatchMaking(
    {required String id, required String uid}) async {
  var baseUrl = Uri.parse(reportAiMatchMakerUri);
  try {
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
    }
  } catch (e) {
    createToast(description: "Error occurred while sending api request");
    // Log the exception or do any other error handling here if needed.
  }
}
