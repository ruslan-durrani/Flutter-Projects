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
  late Box chatBox;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    openChatBox();
  }

  void openChatBox() async {
    var box = await Hive.openBox('chatBox');
    setState(() {
      chatBox = box;
    });
    if (chatBox.isEmpty) {
      chatBox.add({"message": "Hi username. How can I help you today?", "isUser": false});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    // Optionally, close the box when not needed anymore
    // chatBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: chatBox == null ? Center(child: CircularProgressIndicator()) :
      ValueListenableBuilder(
        valueListenable: chatBox.listenable(),
        builder: (context, Box box, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final message = box.getAt(index);
                    bool isUser = message["isUser"];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message["message"],
                            style: TextStyle(color: isUser ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildOptions(),
              _buildTextInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOptions() {
    final List<String> options = ["Report item?", "My lost Items Progress", "Change Application Theme"];
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: options.map((option) => ActionChip(
          backgroundColor: Colors.deepPurple,
          label: Text(option, style: TextStyle(color: Colors.white)),
          onPressed: () => _handleChipTap(option),
        )).toList(),
      ),
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Type your message here...",
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  void _handleChipTap(String selectedOption) {
    _addMessage(selectedOption, true);
    final chatbotResponse = "You selected: $selectedOption";
    _addMessage(chatbotResponse, false);
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _addMessage(_controller.text, true);
      _controller.clear();
      // Here, you might want to add logic for generating a bot response
    }
  }

  void _addMessage(String message, bool isUser) {
    chatBox.add({"message": message, "isUser": isUser});
  }
}
