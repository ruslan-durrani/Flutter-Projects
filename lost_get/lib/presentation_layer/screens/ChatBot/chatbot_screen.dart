import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/home_screen.dart';

class ChatBotScreen extends StatefulWidget {
  static const routeName = "/chatbot_screen";

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  Box? chatBox;
  final TextEditingController _controller = TextEditingController();

  // Combined options and responses map
  final Map<String, dynamic> optionsAndResponses = {
    "How to report an item?": {
      "text":"Reporting An Item: 👇🏻",
      "func":(){
        return ""
            "1- Select Report From Navbar. You will see a page that asks you - "
            "'What are you reporting'\n"
            "\n2- Select the Category from the list\n"
            "\n3- Then Select sub category from the list\n"
            "\n4- A Screen will show up that asks for the attributes of your reporting item\n"
            "\n5- Add Images\n"
            "\n6- Add Status (Lost - Found - Stolen - Robbed)\n"
            "\n7- Select Location from map\n"
            "\n8- Add Title (Please add perfect title)\n"
            "\n9- Add description (Please add comprehensive description)\n"
            "\n10- Smash Submit Report button (Please be gentle in smashing)";
      },
    },
    "How to change theme to dark/light?": {
      "text":"Change/Toggle between light and dark modes",
      "func":(){
        return ""
            "1- Select Profile From Navbar. You will see a page that shows up your profile and several options\n"
            "\n2- Select the Settings option from the list\n"
            "\n3- Select User Preference option from the list.\n"
            "\n4- Then Select Dark Mode or Light Mode\n"
            "\n5- A Pop up will shows up, Asking you for selection of either dark or light.\n"
            "\n6- Select your preference, and press OK\n"
            "\n7- You will be have your app appearance changed to your desired preference\n";
      },
    },
    "How to chat with users?": {
      "text":"Chat With User",
      "func":(){
        return ""
            "First Way To Chat with Users\n"
            "\n1- Select a report from. Navigate to its detail page\n"
            "\n2- Scroll down to view the reporter of the item.\n"
            "\n3- Click on the profile and you will be redirected to its chat screen.\n"
            "\n\nSecond Way To Chat with Users\n"
            "\n1- Select Chat form the navbar.\n"
            "\n2- You will see a list of users, that you already talked to\n"
            "\n3- Click on the chat item and you will see the detailed chat screen\n";
      },
    },
    "more": {
      "text":"Back to Home",
      "func":(){
        return "";
      },
    },
    "How to change profile information?": {
      "text":"Change Profile Information",
      "func":(){
        return ""
            "1- Select Profile From Navbar. You will see a page that shows up your profile and several options\n"
            "\n2- Select the View and edit option just below your name\n"
            "\n3- Add updated information to your profile\n"
            "\n4- Click on save button.\n";
      },
    },
    "How to add phone number?": {
      "text":"Add Phone Number",
      "func":(){
        return ""
            "1- Select Profile From Navbar. You will see a page that shows up your profile and several options\n"
            "\n2- Select the Settings option from the list\n"
            "\n3- Then Select Manage Account option from the list\n"
            "\n4- Then Select Change Phone number from the list\n"
            "\n5- Then Select Country from the Dialog box. Press OK\n"
            "\n6- Add number to the field\n"
            "\n7- Click on save button.\n"
            "\n8- In few seconds you will receive an SMS. Enter that code into the requested field.\n"
            "\n9- Press OK and your phone number is change. You can verify from the profile information\n";
      },
    },
    //  TODO
    "How to report to nearby police stations?": {
      "text":"Report To Nearby Police Station",
      "func":(){
        return ""
            "1- Select Profile From Navbar. You will see a page that shows up your profile and several options\n"
            "\n2- Select the View and edit option just below your name\n"
            "\n3- Add updated information to your profile\n"
            "\n4- Click on save button.\n";
      },
    },
    //  TODO
    "How to enable ai report match making?": {
      "text":"Enable AI Report Match Making",
      "func":(){
        return ""
            "1- Select Profile From Navbar. You will see a page that shows up your profile and several options\n"
            "\n2- Select the View and edit option just below your name\n"
            "\n3- Add updated information to your profile\n"
            "\n4- Click on save button.\n";
      },
    },
    "How to generate flyers?": {
      "text":"Generate Flyers",
      "func":(){
        return ""
            "1- Select My Reports from bottom navigation\n"
            "\n2- A list of your reported items will shows up\n"
            "\n3- Click on QR Flyer of the reported item you want.\n"
            "\n4- QR Flyer will be generate and you can view the flyer. You can also share that later on.\n";
      },
    },

    "How to contact administrator?": {
      "text":"Please provide the details of the item you want to report lost.",
      "func":(){
        return "Hi";
      },
    },
  };

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
  Future<void> clearChatBox() async {
    var box = await Hive.openBox('chatBox');
    setState(() {
      box.clear();
    });
    if (box.isEmpty) {
      box.add({"message": "Hi, how can I help you today?", "isUser": false});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    chatBox?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot", style: Theme.of(context).textTheme.titleLarge),
        elevation: 1,
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
                            color: isUser ? AppColors.primaryColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message["message"],
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isUser ? Colors.white : Colors.black),
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
    return Container(
      height: 170,
      // width: 500,
      padding: const EdgeInsets.all(8.0),
      child:Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: optionsAndResponses.keys.map((option) => ActionChip(

          backgroundColor: Theme.of(context).colorScheme.background,
          label: Text(option, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.bold)),
          onPressed: () {
            if(option=="more"){
              _showOptionsDialog();
              return;
            }
            // Navigator.of(context).pop(); // Close the dialog before handling the tap
            _handleChipTap(option);
          },
        )).toList(),
      ),
      );
  }

  void _showOptionsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select an Option", style: TextStyle(fontSize: 20.0)),
            content: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: optionsAndResponses.keys.map((option) => ActionChip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(option!="more"?option:"Back to home", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                    onPressed: () {
                      if (option=="more") Navigator.popAndPushNamed(context, HomeScreen.routeName);
                      Navigator.of(context).pop(); // Close the dialog before handling the tap
                      _handleChipTap(option);
                    },
                  )).toList(),
                ),
              ),
            ),
          );
        }
    );
  }


  Widget _buildTextInput() {
    return Container(
      color: Colors.white,
      child: Padding(
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
      ),
    );
  }

  void _handleChipTap(selectedOption) {
    String response = optionsAndResponses[selectedOption]["text"] ?? "Sorry, I didn't understand that. Can you please rephrase?";
    Function? func = optionsAndResponses[selectedOption]["func"];
    if (func != null) {
      String funcResponse = func(); // Execute the function
      if (funcResponse.isNotEmpty) {
        response += "\n$funcResponse";
      }
    }

    _addMessage(selectedOption, true); // Show the user's selected option as a message
    Future.delayed(const Duration(seconds: 1), () {
      _addMessage(response, false); // Provide the corresponding response from the chatbot
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      _addMessage(userMessage, true); // Add user message to the chat
      optionsAndResponses.forEach((key, value) {
        if(key.toLowerCase().contains(_controller.text.toLowerCase())){
          _addMessage(value, false);
          _controller.clear();
          return;
        }
      });
      _controller.clear();
      Future.delayed(const Duration(milliseconds: 500), () {
        String botResponse = "I'm not sure how to respond to that. Could you try asking in a different way?";
        _addMessage(botResponse, false); // Add bot response to the chat
      });
    }
  }

  void _addMessage(String message, bool isUser) {
    chatBox?.add({"message": message, "isUser": isUser});
  }
}
