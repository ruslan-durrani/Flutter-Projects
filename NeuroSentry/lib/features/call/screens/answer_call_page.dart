import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/call/creater/webrtc/webrtc_object.dart';
import './call_page.dart';
import '../controller/call_controller.dart';
import '../widgets/custom_loader.dart';

class AnswerCallPage extends StatefulWidget {
  const AnswerCallPage({
    Key? key,
    required this.roomId,
    required this.chatRoomId,
  }) : super(key: key);

  final String? roomId;
  final String chatRoomId;

  @override
  State<AnswerCallPage> createState() => _AnswerCallPageState();
}

class _AnswerCallPageState extends State<AnswerCallPage> {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CallController signaling = WebRTCInstances.getSignalInstance();
  RTCVideoRenderer? localRenderer;
  RTCVideoRenderer? remoteRenderer;
  CustomLoader customLoader = CustomLoader();
  bool isFrontCamera = true;
  bool isMute = false;

  String? callId;
  String? callType;

  @override
  void initState() {

      print(
          'WE ARE HERHEHRHERHEHRERHERHREHRHHEHRHEHRHER TO GET THE INIT RENDERERS');
    initRenderers();

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer?.srcObject = stream;
      setState(() {});
    });

    signaling.onAddLocalStream = ((stream) {
      localRenderer!.srcObject = stream;
      isFrontCamera = !isFrontCamera;
      setState(() {});
    });

    signaling.peerConnection?.onIceConnectionState = (state) {
      print("ICE Connection State has changed to $state");
      setState(() {});
    };

    getCallRoom();

    super.initState();
  }

  Future<void> initRenderers() async {
    localRenderer = WebRTCInstances.getRTCLocalInstance();
    remoteRenderer = WebRTCInstances.getRTCRemoteInstance();
    await localRenderer?.initialize();
    await remoteRenderer?.initialize();
  }

  Future<void> getCallRoom() async {
    try {
      print(
          'WE ARE HERHEHRHERHEHRERHERHREHRHHEHRHEHRHER TO GET THE CALL ROOM ');
      final doc = await firestore
          .collection("chats")
          .doc(widget.chatRoomId)
          .collection("calls")
          .doc(widget.roomId)
          .get();

      if (doc.exists) {
        setState(() {
          callId = widget.roomId;
          callType = "video";
        });

        print('WE ARE HERHEHRHERHEHRERHERHREHRHHEHRHEHRHER');
        print(callId);
        print("The doc exists");
        initializeMedia();
      } else {
        print("No call data found.");
      }
    } catch (e) {
      print("Error fetching call data: $e");
    }
  }

  Future<void> initializeMedia() async {
    if (callType != null) {
      await signaling.openUserMedia(localRenderer, remoteRenderer);
      await signaling.joinRoom(
        widget.roomId!,
        remoteRenderer!,
        widget.chatRoomId,
      );
    }
  }

  @override
  void dispose() {
    WebRTCInstances.dispose();
    super.dispose();
    remoteRenderer?.dispose();
    localRenderer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          videoCallLayout(
            localRenderer!,
            remoteRenderer!,
            "..",
            context,
            "..",
            signaling,
            customLoader,
            widget.roomId!,
            isFrontCamera,
            isMute,
            widget.chatRoomId,
          ),
          renderLocal(localRenderer!),
        ],
      ),
    );
  }

  Widget renderLocal(RTCVideoRenderer renderer) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 100),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: 150,
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: RTCVideoView(
              localRenderer!,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
        ),
      ),
    );
  }

  Widget renderVideo(RTCVideoRenderer renderer) {
    return RTCVideoView(
      renderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }

  Widget renderText() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(), // Or any other loading indicator
      ),
    );
  }

  Future<void> _endCall(BuildContext context) async {
    // Add confirmation dialog here if needed
    await firestore
        .collection("users")
        .doc(currentUserUid)
        .collection("calls")
        .doc(currentUserUid)
        .delete();
    Get.back();
  }
}

Widget videoCallLayout(
  RTCVideoRenderer localRenderer,
  RTCVideoRenderer remoteRenderer,
  String mateName,
  BuildContext context,
  String mateUid,
  CallController signaling,
  CustomLoader customLoader,
  String callRoomId,
  bool isFrontCamera,
  bool isMute,
  String chatRoomId,
) {
  return Stack(
    children: [
      // renderVideoOrText(remoteRenderer, mateName),
      //Local RTCVideoView
      Align(
        alignment: Alignment.topCenter,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Column(
            children: [
              Text(
                "@$mateName",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   "05:46 minutes",
              //   style: GoogleFonts.lato(
              //     color: Colors.white,
              //     fontSize: 13,
              //     fontWeight: FontWeight.normal,
              //   ),
              // ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      renderVideoOrText(remoteRenderer, mateName),
      Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 100),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            height: 150,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RTCVideoView(
                localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
          ),
        ),
      ),

      //Three buttons
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //mute
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    isMute = !isMute;
                    signaling.toggleMicrophone(isMute);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/audioOn.svg",
                    color: Colors.white,
                  ),
                ),
              ),

              //switchCamera
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: () => signaling.switchCamera(
                      localRenderer, isFrontCamera), //TODO
                  icon: const Icon(Icons.switch_camera_rounded,color: Colors.black,),
                ),
              ),
              //End call
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.red,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text("End Call"),
                          content: const Text(
                              "Are you sure you want to end this call?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text(
                                "End Call",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                customLoader.showLoader(context);
                                await signaling.closeCall(localRenderer,
                                    customLoader, callRoomId, chatRoomId);
                                Navigator.pop(context);
                                Get.back();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  // icon: Icon(Icons.call,size: 20,color: Colors.white,)
                  icon: SvgPicture.asset(
                    "assets/icons/endcall.svg",
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
