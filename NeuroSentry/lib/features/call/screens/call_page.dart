import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/models/message_model.dart';

import '../controller/call_controller.dart';
import '../creater/webrtc/webrtc_object.dart';
import '../widgets/custom_loader.dart';

class CallPage extends ConsumerStatefulWidget {
  const CallPage({
    super.key,
    required this.userName,
    required this.chatRoomId,
  });
  final String userName;
  final String chatRoomId;

  @override
  ConsumerState<CallPage> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  CallController signaling = WebRTCInstances.getSignalInstance();
  RTCVideoRenderer? localRenderer;
  RTCVideoRenderer? remoteRenderer;
  bool isFrontCamera = true;
  bool isMute = false;

  CustomLoader customLoader = CustomLoader();
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  String? mateToken;
  String callRoom = "none";

  void initRenderer() async {
    localRenderer = WebRTCInstances.getRTCLocalInstance();
    remoteRenderer = WebRTCInstances.getRTCRemoteInstance();
    await localRenderer?.initialize();
    await remoteRenderer?.initialize();
    await signaling.openUserMedia(localRenderer, remoteRenderer);

    sendCalMessageInvitationCode();

    initializeCall();
  }

  @override
  void initState() {
    initRenderer();

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer?.srcObject = stream;
      setState(() {});
    });

    signaling.onAddLocalStream = ((stream) {
      localRenderer!.srcObject = stream;
      isFrontCamera = !isFrontCamera;
      setState(() {});
    });

    super.initState();
  }

  void initializeCall() async {
    await signaling.createCallRoom(
      remoteRenderer: remoteRenderer,
      customLoader: customLoader,
      chatUid: widget.chatRoomId,
      roomUid: (roomUid) {
        callRoom = roomUid;
      },
    );
    setState(() {});
  }

  void sendCalMessageInvitationCode() async {
    Future.delayed(const Duration(seconds: 5)).then(
      (value) => {
        ref.read(chatControllerProvider).sendMessage(
              widget.chatRoomId,
              MessageModel(
                senderId: FirebaseAuth.instance.currentUser!.uid,
                message: "Join My Call",
                isCall: true,
                timestamp: DateTime.now(),
                roomId: callRoom,
              ),
              false,
            )
      },
    );
  }

  @override
  void dispose() {
    WebRTCInstances.dispose();
    super.dispose();
    localRenderer?.dispose();
    remoteRenderer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          videoCallLayout(
            localRenderer!,
            remoteRenderer!,
            widget.userName,
            context,
            signaling,
            customLoader,
            callRoom,
            isFrontCamera,
            isMute,
            widget.chatRoomId,
          ),
        ],
      ),
    );
  }
}

Widget renderVideoOrText(RTCVideoRenderer remoteRender, String mateName) {
  if (remoteRender.textureId != null) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: RTCVideoView(
          remoteRender,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
      ),
    );
  } else {
    return Container(
      color: Colors.grey[800],
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          "Calling $mateName ...",
          style: GoogleFonts.lato(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget videoCallLayout(
  RTCVideoRenderer localRenderer,
  RTCVideoRenderer remoteRenderer,
  String mateName,
  BuildContext context,
  CallController signaling,
  CustomLoader customLoader,
  String callRoomId,
  bool isFrontCamera,
  bool isMute,
  String chatRoomId,
) {
  return Stack(
    children: [
      renderVideoOrText(remoteRenderer, mateName),
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
            ],
          ),
          centerTitle: true,
        ),
      ),
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
              //Sound high

              //mute
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey),
                  ),
                  onPressed: () {
                    isMute = !isMute;
                    print('MUTE STATE');
                    print(isMute);
                    signaling.toggleMicrophone(isMute);
                  },
                  icon:Icon(Icons.mic,color: Colors.white,)
                  // icon: SvgPicture.asset(
                  //   "assets/icons/audioOn.svg",
                  //   color: Colors.white,
                  // ),
                ),
              ),

              //Switch Camera
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey),
                  ),
                  onPressed: () => signaling.switchCamera(
                      localRenderer, isFrontCamera), //TODO
                  icon: const Icon(Icons.switch_camera_rounded),
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
                                  color: CupertinoColors.systemRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                customLoader.showLoader(context);
                                await signaling.closeCall(
                                  localRenderer,
                                  customLoader,
                                  callRoomId,
                                  chatRoomId,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.call,color: Colors.white,),
                //   icon: SvgPicture.asset(
                //     "assets/icons/endcall.svg",
                //     color: Colors.white,
                //   ),
                // ),
              ),
                ),]
          ),
        ),
      ),
    ],
  );
}
