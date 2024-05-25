import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/shared/loading.dart';

import '../../../shared/constants/colors.dart';
import 'ai_consultant_screen.dart';
import 'chat_consultant_screen.dart';
import 'chat_user_screen.dart';

class MessageScreen extends ConsumerStatefulWidget {
  static const routeName = '/message-screen';
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future messageAi() async {
    ChatRoomModel chatRoom = await ref
        .read(chatControllerProvider)
        .createOrGetOneToOneChatRoom("NeuroSentry Bot", true);

    if (mounted) {
      Navigator.pushNamed(
        context,
        ChatAiScreen.routeName,
        arguments: [chatRoom],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        floatingActionButton: FloatingActionButton(
        onPressed: messageAi,
        backgroundColor: Colors.teal,
        child: const Text(
          "AI",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
        appBar: AppBar(
          title: Text("Messages", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
          centerTitle: false,
          backgroundColor: EColors.primaryColor,
          leading: InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.arrow_back,color: Colors.white,),),
          bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.white.withOpacity(.6),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'User'),
              Tab(text: 'Consultant'),
              Tab(text: 'Bot'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatListView(chatType: 'user'),
            ChatListView(chatType: 'consultant'),
            ChatListView(chatType: 'bot'),
          ],
        ),
      ),
    );
  }
}

class ChatListView extends ConsumerWidget {
  final String chatType;

  const ChatListView({Key? key, required this.chatType}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatRoomModel>>(
      stream: ref.read(chatControllerProvider).userChatRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Messages'));
        } else {
          List<ChatRoomModel> filteredChats = snapshot.data!.where((chat) {
            if (chatType == 'user') {
              return !chat.isConsultant && chat.otherMemberName != "NeuroSentry Bot";
            } else if (chatType == 'consultant') {
              return chat.isConsultant && chat.otherMemberName != "NeuroSentry Bot";
            } else {
              return chat.otherMemberName == "NeuroSentry Bot";
            }
          }).toList();
          return ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) {
              return MessageTile(chat: filteredChats[index]);
            },
          );
        }
      },
    );

  }
}

class MessageTile extends StatelessWidget {
  final ChatRoomModel chat;

  const MessageTile({super.key, required this.chat});

  void openChat(BuildContext context) {
    if (chat.isConsultant) {
      if (chat.otherMemberName == "NeuroSentry Bot") {
        Navigator.pushNamed(context, ChatAiScreen.routeName, arguments: [chat]);
      } else {
        Navigator.pushNamed(context, ChatConsultantScreen.routeName, arguments: [chat]);
      }
    } else {
      Navigator.pushNamed(context, ChatUserScreen.routeName, arguments: [chat]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openChat(context),

      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
                blurRadius: 10,  // Blur effect radius
                offset: Offset(5, 5),  // X, Y offset of shadow
              ),
            ]
        ),
        child: ListTile(
          title: Text(
            chat.otherMemberName,
            style: TextStyle(
              color: EColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            chat.lastMessage ?? "New Chat",
            style: GoogleFonts.openSans(
                color: EColors.textPrimary, fontSize: 12),
          ),
          trailing: Icon(Icons.arrow_forward, color: EColors.textPrimary,),
          tileColor: EColors.secondaryColor,

        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
// import 'package:mental_healthapp/features/chat/screens/ai_consultant_screen.dart';
// import 'package:mental_healthapp/features/chat/screens/chat_consultant_screen.dart';
// import 'package:mental_healthapp/features/chat/screens/chat_user_screen.dart';
// import 'package:mental_healthapp/models/chat_room_model.dart';
// import 'package:mental_healthapp/shared/loading.dart';
//
// class MessageScreen extends ConsumerStatefulWidget {
//   static const routeName = '/message-screen';
//   const MessageScreen({super.key});
//
//   @override
//   ConsumerState<MessageScreen> createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends ConsumerState<MessageScreen> {
//   Future messageAi() async {
//     ChatRoomModel chatRoom = await ref
//         .read(chatControllerProvider)
//         .createOrGetOneToOneChatRoom("NeuroSentry Bot", true);
//
//     if (mounted) {
//       Navigator.pushNamed(
//         context,
//         ChatAiScreen.routeName,
//         arguments: [chatRoom],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Text("MESSAGES", style: Theme.of(context).textTheme.headlineMedium),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//       ),
//       body: StreamBuilder<List<ChatRoomModel>>(
//         stream: ref.read(chatControllerProvider).userChatRooms(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const LoadingScreen();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final List<ChatRoomModel> chats = snapshot.data!;
//             if (chats.isEmpty) {
//               return const Center(
//                 child: Text('No Messages'),
//               );
//             }
//             return ListView.builder(
//               itemCount: chats.length,
//               itemBuilder: (context, index) {
//                 return MessageTile(
//                   chat: chats[index],
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: messageAi,
//         backgroundColor: Colors.teal,
//         child: const Text(
//           "AI",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MessageTile extends StatelessWidget {
//   final ChatRoomModel chat;
//
//   const MessageTile({super.key, required this.chat});
//
//   openChat(BuildContext context) {
//     if (chat.isConsultant) {
//       if (chat.otherMemberName == "NeuroSentry Bot") {
//         Navigator.pushNamed(context, ChatAiScreen.routeName, arguments: [chat]);
//       } else {
//         Navigator.pushNamed(context, ChatConsultantScreen.routeName,
//             arguments: [chat]);
//       }
//     } else {
//       Navigator.pushNamed(
//         context,
//         ChatUserScreen.routeName,
//         arguments: [chat],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => openChat(context),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//         child: ListTile(
//           title: Text(
//             chat.otherMemberName,
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Text(
//               chat.lastMessage ?? "New Chat",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//           ),
//           // trailing: const Icon(FontAwesomeIcons.checkDouble),
//         ),
//       ),
//     );
//   }
// }
