import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../utils/speech_service.dart';

class CharacterScreen extends StatelessWidget {
  final SpeechService speechService;

  const CharacterScreen({Key? key, required this.speechService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange.withOpacity(.1),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: speechService.isSpeaking,
        builder: (context, isSpeaking, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 400,
                child: ModelViewer(
                  src: 'assets/images/avatar.glb',
                  cameraControls: true,
                  autoRotate: false, // Disable auto-rotate while speaking
                  backgroundColor: Colors.transparent,
                  animationCrossfadeDuration: 1,
                  arScale: isSpeaking ? ArScale.fixed : ArScale.auto, // Use enum values
                ),
              ),
              if (isSpeaking)
                Positioned(
                  bottom: 20,
                  child: Text(
                    "Talking...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
