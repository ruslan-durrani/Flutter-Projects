import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';

  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"isUser": true, "message": message});
    });

    _getBotResponse(message);
    _controller.clear();
  }

  void _getBotResponse(String userMessage) {
    Future.delayed(Duration(milliseconds: 500), () {
      String botResponse = _generateBotResponse(userMessage);

      setState(() {
        _messages.add({"isUser": false, "message": botResponse});
      });

      // Speak the bot response
      _speak(botResponse);
    });
  }


  String _generateBotResponse(String message) {
    late String botResponse ;
    if (message.toLowerCase().contains("hello")) {
      botResponse = "Hello! How can I help you today?";
    } else if (message.toLowerCase().contains("fitness")) {
      botResponse ="I can create a personalized fitness plan for you. Please share your goals.";
    } else {
      botResponse = "I'm here to help! Please provide more details.";
    }
    saveAudio(botResponse, "response_audio.wav");
    return botResponse ;
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
          // Navigator.of(context).pop(); // Close the toast when recording stops
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        Navigator.of(context).pop(); // Close the toast on error
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });

      // Show loading toast while recording
      _showRecordingToast(context);

      _speech.listen(
        onResult: (result) {
          setState(() {
            _voiceInput = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    Navigator.of(context).pop();
    setState(() {
      _isListening = false;
    });

     // Close the toast

    if (_voiceInput.isNotEmpty) {
      _sendMessage(_voiceInput); // Send the recognized voice input as a message
    }
  }

  void _cancelRecording() {
    _speech.stop();
    // Navigator.of(context).pop();
    setState(() {
      _isListening = false;
      _voiceInput = ''; // Clear the input on cancel
    });

    // Navigator.of(context).pop(); // Close the toast
  }

  //

  Future<void> saveAudio(String text, String filePath) async {
    final FlutterTts tts = FlutterTts();
    await tts.setLanguage("en-US");
    // await tts.synthesizeToFile(text, filePath);
  }


  void _showRecordingToast(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(_isSpeaking ? "Speaking..." : "Listening... Speak now"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _cancelRecording, child: Text("Cancel")),
                  ElevatedButton(
                    onPressed: _stopListening,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("Stop", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool get isCharacterSpeaking => _isSpeaking;


  Future<void> _speak(String text) async {
    setState(() {
      _isSpeaking = true;
    });

    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.speak(text);

    _tts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'];

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/images/logo.png"),
                          radius: 18,
                        ),
                      if (!isUser) SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.orange[200] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red : Colors.purple,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type Message..",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepOrange,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

