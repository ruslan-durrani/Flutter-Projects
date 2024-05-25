import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';

import '../widgets/custom_loader.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class CallController {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onAddLocalStream;
  RTCRtpSender? senderVideoId;
  MediaStreamTrack? _originalMicrophoneTrack;
  //Create Call.
  Future<String> createCallRoom({
    RTCVideoRenderer? remoteRenderer,
    required String chatUid,
    required CustomLoader customLoader,
    required Function(String) roomUid,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef =
        db.collection('chats').doc(chatUid).collection('calls').doc();
    // String currentUser = FirebaseAuth.instance.currentUser!.uid;

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) async {
      if (track.kind == 'video') {
        senderVideoId = await peerConnection?.addTrack(track, localStream!);
      } else {
        await peerConnection?.addTrack(track, localStream!);
      }
    });

    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      callerCandidatesCollection.add(candidate.toMap());
    };

    peerConnection?.onTrack = (RTCTrackEvent event) {
      onAddRemoteStream!.call(event.streams.first);
      remoteStream = event.streams.first; //TODO
    };

    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    Map<String, dynamic> roomWithOffer = {
      'offer': offer.toMap(),
    };

    // Further initialization like adding local streams or handling ICE candidates

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    currentRoomText = 'Current room is $roomId - You are the caller!';
    await roomUid(roomId);
    // Send a call invitation to friend chat room.

    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatUid)
        .collection("calls")
        .doc(chatUid)
        .set(
      {
        "calleeUid": currentUserUid,
        "callRoomId": roomId,
        "time": DateTime.now(),
        "callState": "dialing",
      },
    );

    roomRef.snapshots().listen(
      (snapshot) async {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          await peerConnection?.setRemoteDescription(answer);
        }
      },
    );

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
    return roomId;
  }

  Future<void> joinRoom(
      String roomId, RTCVideoRenderer remoteVideo, String chatRoomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef =
        db.collection('chats').doc(chatRoomId).collection('calls').doc(roomId);
    var roomSnapshot = await roomRef.get();
    if (roomSnapshot.exists) {
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) async {
        if (track.kind == 'video') {
          senderVideoId = await peerConnection?.addTrack(track, localStream!);
        } else {
          await peerConnection?.addTrack(track, localStream!);
        }
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          return;
        }
        calleeCandidatesCollection.add(candidate.toMap());
      };

      peerConnection?.onTrack = (RTCTrackEvent event) {
        onAddRemoteStream!.call(event.streams.first);
        remoteStream = event.streams.first;
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
      //remoteVideo.srcObject = peerConnection!.getRemoteStreams()[0];
    }
  }

  switchCamera(
    RTCVideoRenderer? localVideo,
    bool isFront,
  ) async {
    var stream = await navigator.mediaDevices.getUserMedia(
      {
        'video': {
          'facingMode': isFront ? 'environment' : 'user', // Use the back camera
        },
        'audio': true,
      },
    );

    if (peerConnection != null) {
      final transceivers = await peerConnection!.getTransceivers();
      final videoTransceiver = transceivers.firstWhere(
        (transceiver) => transceiver.sender.track?.kind == 'video',
      );

      await videoTransceiver.sender.replaceTrack(stream.getVideoTracks()[0]);
    }

    onAddLocalStream!(stream);
  }

  Future<void> toggleMicrophone(
    bool isMuted,
  ) async {
    if (peerConnection != null) {
      final senders = await peerConnection!.getSenders();
      final audioSender = senders[0];

      if (isMuted) {
        _originalMicrophoneTrack ??= audioSender.track;

        await audioSender.setTrack(null);
      } else {
        await audioSender.setTrack(_originalMicrophoneTrack);
      }
    }
  }

  // Open Media
  Future<void> openUserMedia(
    RTCVideoRenderer? localVideo,
    RTCVideoRenderer? remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices.getUserMedia(
      {
        'video': true,
        'audio': true,
      },
    );

    localVideo?.srcObject = stream;
    localStream = stream;

    remoteVideo?.srcObject = await createLocalMediaStream('key');
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {};

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {};

    peerConnection?.onSignalingState = (RTCSignalingState state) {};

    peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };

    peerConnection!.onRemoveTrack =
        (MediaStream stream, MediaStreamTrack track) {
      stream.removeTrack(track);
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };

    peerConnection!.onRemoveStream = (stream) {};

    peerConnection?.onAddTrack = (stream, track) {
      stream.addTrack(track);
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  // Close call.
  Future<void> closeCall(
    RTCVideoRenderer localVideo,
    CustomLoader customLoader,
    String callRoomId,
    String chatRoomId,
  ) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    var db = FirebaseFirestore.instance;
    var roomRef = db
        .collection('chats')
        .doc(chatRoomId)
        .collection('calls')
        .doc(callRoomId);
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    for (var document in calleeCandidates.docs) {
      document.reference.delete();
    }
    var callerCandidates = await roomRef.collection('callerCandidates').get();
    for (var document in callerCandidates.docs) {
      document.reference.delete();
    }
    await roomRef.delete();
    customLoader.hideLoader();

    localStream!.dispose();
    remoteStream?.dispose();
  }

  // Add call history to all mates.
  Future<void> addCallHistory(
    String callRoomId,
    String mateUid,
    String callerUid,
    CustomLoader customLoader,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String dbRef = "users";

    // Set the call history to current user.
    await firestore
        .collection(dbRef)
        .doc(currentUserUid)
        .collection("calls")
        .doc(callRoomId)
        .set(
      {
        "caller": callerUid,
        "time": DateTime.now().toString(),
      },
    );
    // Set the call history to mateUid.
    await firestore
        .collection(dbRef)
        .doc(mateUid)
        .collection("calls")
        .doc(callRoomId)
        .set(
      {
        "caller": callerUid,
        "time": DateTime.now().toString(),
      },
    );
    // Hide loader
    customLoader.hideLoader();
  }

  // clear history.
  Future<void> clearCallHistory(CustomLoader customLoader) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String dbRef = "users";

    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection(dbRef)
        .doc(currentUserUid)
        .collection("calls");

    QuerySnapshot querySnapshot = await collectionRef.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    customLoader.hideLoader();
  }
}
