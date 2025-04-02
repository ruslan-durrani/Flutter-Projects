import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();
  ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  SpeechService() {
    _tts.setCompletionHandler(() {
      isSpeaking.value = false; // Notify listeners when speaking stops
    });
  }

  Future<void> speak(String text) async {
    isSpeaking.value = true; // Notify listeners when speaking starts
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  void stopSpeaking() async {
    await _tts.stop();
    isSpeaking.value = false;
  }
}
