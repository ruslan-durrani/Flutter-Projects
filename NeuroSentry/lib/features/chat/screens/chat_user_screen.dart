import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/call/screens/answer_call_page.dart';
import 'package:mental_healthapp/features/call/screens/call_page.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/message_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:mental_healthapp/shared/loading.dart';

class ChatUserScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat-user-screen';
  final ChatRoomModel chatRoom;
  const ChatUserScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  ConsumerState<ChatUserScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatUserScreen> {
  final TextEditingController _msgController = TextEditingController();

  Future sendMessage() async {
    MessageModel message;
    if (widget.chatRoom.isGroup) {
      message = MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        message: _msgController.text,
        isCall: false,
        timestamp: DateTime.now(),
        userName: ref.read(profileRepositoryProvider).profile!.profileName,
      );
    } else {
      message = MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        message: _msgController.text,
        isCall: false,
        timestamp: DateTime.now(),
      );
    }
    _msgController.clear();
    await ref
        .read(chatControllerProvider)
        .sendMessage(widget.chatRoom.roomId, message, false);
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
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),

        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          !widget.chatRoom.isGroup
              ? IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(
                        userName: widget.chatRoom.otherMemberName,
                        chatRoomId: widget.chatRoom.roomId,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
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
                    'Error: ${snapshot.error}',
                  );
                } else {
                  List<MessageModel> messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No Messages'),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return SentMsgTile(msg: message.message);
                      } else {
                        return RecievedMsgTile(
                          msg: message.message,
                          userName: message.userName,
                          isCall: message.isCall,
                          chatRoomId: widget.chatRoom.roomId,
                          roomId: message.roomId,
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: HelperTextField(
                    htxt: "Enter Message",
                    iconData: Icons.chat,
                    controller: _msgController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: EColors.buttonPrimary,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecievedMsgTile extends StatelessWidget {
  final String msg;
  String? userName;
  final bool isCall;
  final String chatRoomId;
  String? roomId;
  RecievedMsgTile({
    super.key,
    required this.msg,
    this.userName,
    required this.isCall,
    required this.chatRoomId,
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
              if (isCall) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnswerCallPage(roomId: roomId, chatRoomId: chatRoomId),
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
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
