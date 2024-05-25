import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../controller/call_controller.dart';

class WebRTCInstances {
  static CallController? instance;
  static RTCVideoRenderer? localRenderer;
  static RTCVideoRenderer? remoteRenderer;

  static CallController getSignalInstance() {
    instance = CallController();
    return instance!;
  }

  static RTCVideoRenderer getRTCLocalInstance() {
    localRenderer = RTCVideoRenderer();
    return localRenderer!;
  }

  static RTCVideoRenderer getRTCRemoteInstance() {
    remoteRenderer = RTCVideoRenderer();
    return remoteRenderer!;
  }

  static void dispose() {
    //
    // instance = null;
    // remoteRenderer = null;
    // localRenderer = null;
  }
}
