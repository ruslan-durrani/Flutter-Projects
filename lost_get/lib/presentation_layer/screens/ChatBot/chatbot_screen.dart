import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatBotScreen extends StatefulWidget {
  static const routeName = "/chatbot_screen";

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  Box? chatBox; // Declare chatBox as nullable
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    openChatBox();
  }

  Future<void> openChatBox() async {
    var box = await Hive.openBox('chatBox');
    setState(() {
      chatBox = box;
    });
    if (box.isEmpty) {
      box.add({"message": "Hi, how can I help you today?", "isUser": false});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // Optionally, close the box when not needed anymore
    chatBox?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: chatBox == null
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
        valueListenable: chatBox!.listenable(),
        builder: (context, Box box, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final message = box.getAt(index) as Map;
                    bool isUser = message["isUser"];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
    final List<String> options = ["Report item", "My lost items progress", "Change application theme"];
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: options.map((option) => ActionChip(
          backgroundColor: Theme.of(context).colorScheme.primary,
          label: Text(option, style: const TextStyle(color: Colors.white)),
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
            icon: const Icon(Icons.send),
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
    // Simulate a bot response
    Future.delayed(const Duration(seconds: 1), () {
      _addMessage("You selected: $selectedOption", false);
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _addMessage(_controller.text, true);
      _controller.clear();
      // Here, you might want to add logic for generating a bot response
    }
  }

  void _addMessage(String message, bool isUser) {
    chatBox?.add({"message": message, "isUser": isUser});
  }
}
