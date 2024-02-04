import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_chat_message.dart'; // Assuming this file defines the ChatMessage class

class ChatBotScreen extends StatefulWidget {
  static const routeName = "/chatbot_screen";
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late Box chatBox; // Removed the generic type <ChatMessage>

  @override
  void initState() {
    super.initState();
    openChatBox();
  }

  void openChatBox() async {
    var box = await Hive.openBox('chatBox'); // Removed the generic type <ChatMessage>
    setState(() {
      chatBox = box;
    });
    if (chatBox.isEmpty) {
      // Preload with the initial data
      // Assuming ChatMessage constructor and properties remain unchanged
      chatBox.add({"message": "Hi username. How can I help you today?", "isUser": false});
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Optionally, close the box when not needed anymore
    // chatBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
      ),
      body: chatBox == null ? CircularProgressIndicator() :
      ValueListenableBuilder(
        valueListenable: chatBox.listenable(),
        builder: (context, Box box, _) { // Removed the generic type <ChatMessage> here as well
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final message = box.getAt(index); // Cast is required now
                    return Align(
                      alignment: message["isUser"] ? Alignment.centerRight : Alignment.centerLeft,
                      child: Chip(
                        label: Text(message["message"]),
                        avatar: message["isUser"] ? null : Icon(Icons.chat_bubble),
                      ),
                    );
                  },
                ),
              ),
              _buildOptions(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOptions() {
    final List<String> options = ["Report item?", "My lost Items Progress", "Change Application Theme"];
    return Wrap(
      spacing: 8.0,
      children: options.map((option) => ActionChip(
        label: Text(option),
        onPressed: () => _handleChipTap(option),
      )).toList(),
    );
  }

  void _handleChipTap(String selectedOption) {
    chatBox.add({"message": selectedOption, "isUser": true}); // Assuming this works as intended without casting
    print(chatBox.get("chatbox"));
    final chatbotResponse = "You selected: $selectedOption";
    chatBox.add({"message": chatbotResponse, "isUser": false});
  }
}
