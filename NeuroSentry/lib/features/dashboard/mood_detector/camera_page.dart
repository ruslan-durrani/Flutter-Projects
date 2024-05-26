import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_healthapp/shared/constants/colors.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;  // Made nullable to handle initialization
  Future<void>? _initializeControllerFuture;  // Made nullable and not late

  bool isDetecting = false;
  String detectedEmotion = "Initializing...";  // Default text indicating initialization

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCamera();  // Set the future during initState
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        detectedEmotion = "Camera Ready";  // Update emotion status after initialization
      });
      _controller!.startImageStream((CameraImage image) {
        captureAndSend();
      });
    } catch (e) {
      setState(() {
        detectedEmotion = "Error initializing camera: $e";
      });
    }
  }

  Future<void> captureAndSend() async {
    if (_controller != null && _controller!.value.isInitialized && !isDetecting) {
      isDetecting = true;
      try {
        final image = await _controller!.takePicture();
        await sendImageToBackend(await image.readAsBytes());
      } catch (e) {
        print(e);
        isDetecting = false;
      }
    }
  }

  Future<void> sendImageToBackend(Uint8List bytes) async {
    final uri = Uri.parse('http://54.235.3.254:8000/analyze-emotion');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: 'image.jpg'));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        handleResponse(responseData);
      } else {
        print('Failed to send image: ${response.statusCode}');
        print('Response body: $responseData');
      }
    } catch (e) {
      print('HTTP error: $e');
    } finally {
      isDetecting = false;
    }
  }

  void handleResponse(String responseBody) {
    final responseJson = jsonDecode(responseBody);
    if (responseJson['emotions'].isEmpty) {
      setState(() {
        detectedEmotion = "No emotions detected";
      });
    } else {
      setState(() {
        detectedEmotion = responseJson['emotions'][0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        title:  Text('Camera',style: TextStyle(color: Colors.white),),
        backgroundColor: EColors.primaryColor,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Column(
              children: [
                Expanded(child: CameraPreview(_controller!)),  // Camera preview
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    detectedEmotion,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: EColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          } else {
            // Show loading spinner until camera is ready
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mental_healthapp/shared/constants/colors.dart';
//
// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});
//
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   CameraController? _controller;  // Made nullable to handle initialization
//   Future<void>? _initializeControllerFuture;
//   bool isDetecting = false;
//   String detectedEmotion = "Initializing...";  // Default text indicating initialization
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }
//
//   Future<void> initCamera() async {
//     setState(() {
//       detectedEmotion = "Initializing Camera...";  // Update UI to show loading message
//     });
//
//     final cameras = await availableCameras();
//     final frontCam = cameras.firstWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );
//
//     _controller = CameraController(
//       frontCam,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     _initializeControllerFuture = _controller!.initialize().then((_) {
//       setState(() {
//         detectedEmotion = "Camera Ready";  // Update emotion status after initialization
//       });
//       _controller!.startImageStream((CameraImage image) {
//         captureAndSend();
//       });
//     }).catchError((e) {
//       setState(() {
//         detectedEmotion = "Error initializing camera: $e";
//       });
//     });
//   }
//
//   // Send image to backend
//   Future<void> sendImageToBackend(Uint8List bytes) async {
//     final uri = Uri.parse('http://54.235.3.254:8000/analyze-emotion');
//     final request = http.MultipartRequest('POST', uri)
//       ..files.add(
//           http.MultipartFile.fromBytes('file', bytes, filename: 'image.jpg'));
//
//     final response = await request.send();
//     final responseData = await response.stream.bytesToString();
//
//     if (response.statusCode == 200) {
//       print("Response data: $responseData");
//       handleResponse(responseData);
//     } else {
//       print('Failed to send image: ${response.statusCode}');
//       print('Response body: $responseData');
//     }
//
//     isDetecting = false;
//   }
//
//   void handleResponse(String responseBody) {
//     final responseJson = jsonDecode(responseBody);
//
//     // Check if the emotions array is empty
//     if (responseJson['emotions'].isEmpty) {
//       print("No emotions detected.");
//       setState(() {
//         detectedEmotion = "No emotions detected";
//       });
//       // Handle the case where no emotions are detected
//       // For example, update the UI to reflect that no faces were found
//     } else {
//       setState(() {
//         detectedEmotion = responseJson['emotions']
//         [0]; // Safely access the first detected emotion
//         print("Detected emotion: $detectedEmotion");
//       });
//
//       // You can now use 'detectedEmotion' to update your UI or perform other actions
//     }
//   }
//
//   Future<void> captureAndSend() async {
//     if (_controller != null && _controller!.value.isInitialized && !isDetecting) {
//       isDetecting = true;
//       try {
//         final image = await _controller!.takePicture();
//         await sendImageToBackend(await image.readAsBytes());
//       } catch (e) {
//         print(e);
//         isDetecting = false;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera'),
//         backgroundColor: EColors.primaryColor,
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             return Column(
//               children: [
//                 CameraPreview(_controller!),  // Assuming camera is ready
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Text(
//                     detectedEmotion,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // Show loading spinner until camera is ready
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }
