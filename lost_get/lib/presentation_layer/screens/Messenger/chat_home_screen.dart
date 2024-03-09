import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/colors.dart';
import 'business_logic/ChatHomeProvider.dart';
import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  void _onSearchChanged() {
    setState(() {
      // This will trigger the stream builder to use the updated stream
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _searchController.addListener(() {
      chatProvider.searchQuery = _searchController.text.trim();
    });
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 1,
      ),
      body:Consumer<ChatProvider>(
        builder: (context, provider, child) {
          final chatUsers = provider.chatUsers;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                _buildSearchField(),
                Expanded(
                  child: _buildStreamHomeUser(chatUsers),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search",
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() {
              _searchController.clear();
              Provider.of<ChatProvider>(context, listen: false).searchQuery = '';
            }),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) => Provider.of<ChatProvider>(context, listen: false).searchQuery = value.trim(),
      ),
    );
  }


  Widget _buildStreamHomeUser(chatUsers) {
    final currentUserUid = _auth.currentUser!.uid;
    String searchQuery = _searchController.text.trim();
    Stream<List<Map<String, dynamic>>> userStream = chatUsers.isEmpty
        ? _chatService.getUserChatsStream()
        : _chatService.searchUserChats(searchQuery);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error Occurred");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: 50,
        );
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text("No data available",style: Theme.of(context).textTheme.bodyMedium,);
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final userData = snapshot.data![index];
            final userProfile = UserProfile.fromMap(userData);

            // Assuming you have a method to fetch unread message count
            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection("chat_meta").doc(_chatService.getChatRoomKey(userProfile.uid!)).get(),
              builder: (context, chatMetaSnapshot) {
                if (!chatMetaSnapshot.hasData) return SizedBox();
                var unreadCount = 0;
                String lastMsg = "No message yet";
                try{
                  Map<String,dynamic> lastMessageMap = chatMetaSnapshot.data!["lastMsg"];
                  String sender = lastMessageMap["sender"];
                  lastMsg = lastMessageMap["message"];
                  if(sender == userProfile.uid){
                    lastMsg = '${userProfile.fullName}: ${lastMsg}';
                  }
                  else{
                    lastMsg = "You: $lastMsg";
                  }
                }
                catch (e){
                  lastMsg = "";
                }
                if (chatMetaSnapshot.data!.exists) {
                  Map<String, dynamic>? metaData = chatMetaSnapshot.data!.data() as Map<String, dynamic>?;
                  if (metaData != null && metaData.containsKey(currentUserUid) && metaData[currentUserUid] is Map) {
                    Map<String, dynamic> userMetaData = metaData[currentUserUid];
                    unreadCount = userMetaData["unreadCount"] ?? 0;
                    // if(unreadCount>0){
                      // _chatService.notifyUserAboutTheNewMessage(userProfile);
                    // }
                  }
                }

                bool hasUnreadMessages = unreadCount > 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userProfile.imgUrl != null && userProfile.imgUrl!.isNotEmpty
                        ? NetworkImage(userProfile.imgUrl!)
                        : null,
                    child: userProfile.imgUrl == null || userProfile.imgUrl!.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  title: Text(userProfile.fullName!,style: Theme.of(context).textTheme.titleMedium,),
                  subtitle: hasUnreadMessages ? Text("$unreadCount new messages",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),):Text(lastMsg,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(.7)),),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: userProfile,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

}


// Widget _buildStreamHomeUser() {
  //   return StreamBuilder<List<Map<String, dynamic>>>(
  //     stream: _chatService.getUserChatsStream(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text("Error Occurred");
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: const CircularProgressIndicator()); // Better loading indication.
  //       }
  //       if (snapshot.data == null || snapshot.data!.isEmpty) {
  //         return const Text("No data available");
  //       }
  //
  //       final currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //       final filteredData = snapshot.data!.where((data) => data["uid"] != currentUserUid).toList();
  //
  //       return ListView.builder(
  //         itemCount: filteredData.length,
  //         itemBuilder: (context, index) {
  //           final userData = filteredData[index];
  //           final userProfile = UserProfile.fromMap(userData); // Consider implementing a fromMap constructor.
  //
  //           return MyUserCardComponent(
  //             imageUrl: userProfile.imgUrl,
  //             title: userProfile.fullName!,
  //             subTitle: userProfile.email!,
  //             iconData: Icons.message,
  //             uid: userData["uid"],
  //             onReceiverTap: () => Navigator.pushNamed(
  //               context,
  //               ChatScreen.routeName,
  //               arguments: userProfile,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
