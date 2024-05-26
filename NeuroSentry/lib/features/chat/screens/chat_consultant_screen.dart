import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/features/dashboard/screens/consultant/book_appointments.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/message_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:mental_healthapp/shared/loading.dart';

class ChatConsultantScreen extends ConsumerStatefulWidget {
  static const routeName = '/consultant-screen';
  final ChatRoomModel chatRoom;
  const ChatConsultantScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  ConsumerState<ChatConsultantScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatConsultantScreen> {
  final TextEditingController _msgController = TextEditingController();
  String? selectedMessage;

  void selectMessage(String message) {
    selectedMessage = message;
  }

  Future sendMessage() async {
    if (selectedMessage != null) {
      if (selectedMessage == 'Book Appointments') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  BookAppointment(
                name: widget.chatRoom.otherMemberName, type: "Neuropsychologist"),
          ),
        );
      } else {
        final message = MessageModel(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          message: selectedMessage!,
          isCall: false,
          timestamp: DateTime.now(),
        );
        _msgController.clear();
        await ref
            .read(chatControllerProvider)
            .sendMessage(widget.chatRoom.roomId, message, true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _msgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        title: Text(
          widget.chatRoom.otherMemberName,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ref
                  .read(chatControllerProvider)
                  .getChatMessages(widget.chatRoom.roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message
                } else {
                  List<MessageModel> messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No Messages'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        if (message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          return SentMsgTile(msg: message.message);
                        } else {
                          return RecievedMsgTile(msg: message.message);
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
          ChatOptions(
            changeSelected: selectMessage,
            isHelp: widget.chatRoom.otherMemberName == 'help',
          ),
          Row(
            children: [
              Expanded(
                child: HelperTextField(
                    htxt: "Enter Message",
                    iconData: Icons.chat,
                    controller: _msgController,
                    keyboardType: TextInputType.text),
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 204, 17, 4),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChatOptions extends StatefulWidget {
  final Function changeSelected;
  final bool isHelp;
  const ChatOptions({
    super.key,
    required this.changeSelected,
    required this.isHelp,
  });

  @override
  State<ChatOptions> createState() => _ChatOptionsState();
}

class _ChatOptionsState extends State<ChatOptions> {
  String? selectedMessage;

  void selectMessage(String message) {
    widget.changeSelected(message);
    setState(() {
      selectedMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: double.infinity,
      decoration: const BoxDecoration(color: EColors.softGrey),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            // widget.isHelp
                PreMessageTile(
                    msg: 'Book Appointments',
                    isSelected: selectedMessage == 'Book Appointments',
                    onTap: () => selectMessage('Book Appointments'),
                  ),
                // : const SizedBox.shrink(),
            PreMessageTile(
              msg: 'Improve diet',
              isSelected: selectedMessage == 'Improve diet',
              onTap: () => selectMessage('Improve diet'),
            ),
            PreMessageTile(
              msg: 'manage stress',
              isSelected: selectedMessage == 'manage stress',
              onTap: () => selectMessage('manage stress'),
            ),
            PreMessageTile(
              msg: 'sleep better',
              isSelected: selectedMessage == 'sleep better',
              onTap: () => selectMessage('sleep better'),
            ),
            PreMessageTile(
              msg: 'boost my mood',
              isSelected: selectedMessage == 'boost my mood',
              onTap: () => selectMessage('boost my mood'),
            ),
            PreMessageTile(
              msg: 'nutrition affects',
              isSelected: selectedMessage == 'nutrition affects',
              onTap: () => selectMessage('nutrition affects'),
            ),
            PreMessageTile(
              msg: 'signs of stress',
              isSelected: selectedMessage == 'signs of stress',
              onTap: () => selectMessage('signs of stress'),
            ),
            PreMessageTile(
              msg: 'manage negative emotions',
              isSelected: selectedMessage == 'manage negative emotions',
              onTap: () => selectMessage('manage negative emotions'),
            ),
          ],
        ),
      ),
    );
  }
}

class PreMessageTile extends StatelessWidget {
  final String msg;
  final bool isSelected;
  final Function onTap;
  const PreMessageTile({
    super.key,
    required this.msg,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? EColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          msg,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class RecievedMsgTile extends StatelessWidget {
  final String msg;
  String? userName;
  // final bool isCall;
  // final String chatRoomId;
  String? roomId;
  RecievedMsgTile({
    super.key,
    required this.msg,
    this.userName,
    // required this.isCall,
    // required this.chatRoomId,
    this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              // if (isCall) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           // AnswerCallPage(roomId: roomId, chatRoomId: chatRoomId),
              //     ),
              //   );
              // }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: EColors.lightGrey,
                  borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  userName != null
                      ? Text(
                    userName!,
                    style: const TextStyle(fontWeight: FontWeight.normal,color: Colors.white),
                  )
                      : const SizedBox.shrink(),
                  Text(
                    msg,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.black.withOpacity(.7),fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SentMsgTile extends StatelessWidget {
  final String msg;
  const SentMsgTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: EColors.primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              msg,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.white,fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }
}

