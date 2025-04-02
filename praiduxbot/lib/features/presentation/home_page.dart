import 'package:flutter/material.dart';
import 'package:praiduxbot/features/presentation/character_section/character_screen.dart';
import 'package:praiduxbot/features/presentation/chat_section/chat_screen.dart';
import 'package:praiduxbot/features/presentation/header.dart';

import '../../utils/speech_service.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  final SpeechService speechService = SpeechService(); // Create a shared SpeechService instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: HeaderBot()
            ),
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ChatScreen(),
                  ),
                  Expanded(
                    flex: 2,
                    child: CharacterScreen(speechService: speechService)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
