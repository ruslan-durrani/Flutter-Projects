import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/my_user_component.dart';
import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        title: Text(
          "Messages",
          style: TextStyle(color: colorScheme.inversePrimary),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            MyTextField(
              hintText: "Search",
              trailingIcon: Icons.search,
              isObscure: false, // Search field should not be obscure.
              controller: _searchController,
            ),
            Expanded(
              child: _buildStreamHomeUser(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamHomeUser() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error Occurred");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator()); // Better loading indication.
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text("No data available");
        }

        final currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
        final filteredData = snapshot.data!.where((data) => data["uid"] != currentUserUid).toList();

        return ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final userData = filteredData[index];
            final userProfile = UserProfile.fromMap(userData); // Consider implementing a fromMap constructor.

            return MyUserCardComponent(
              imageUrl: userProfile.imgUrl,
              title: userProfile.fullName!,
              subTitle: userProfile.email!,
              iconData: Icons.message,
              uid: userData["uid"],
              onReceiverTap: () => Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: userProfile,
              ),
            );
          },
        );
      },
    );
  }
}

/*
Widget _buildStreamHomeUser() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error Occurred");
        if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

        final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text("No data available");
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
                var unreadCount = chatMetaSnapshot.data!.get("${userProfile.uid}.unreadCount") ?? 0;
                bool hasUnreadMessages = unreadCount > 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userProfile.imgUrl!),
                  ),
                  title: Text(userProfile.fullName!),
                  subtitle: Text(hasUnreadMessages ? "$unreadCount new messages" : "All caught up!"),
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
 */