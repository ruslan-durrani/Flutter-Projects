import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/colors.dart';
import '../../../models/user_profile.dart';
import '../../../services/chat_system_services/chat_service.dart';
import 'business_logic/ChatHomeProvider.dart';
import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the context is available here.
      _searchController.addListener(() {
        Provider.of<ChatProvider>(context, listen: false).searchQuery = _searchController.text.trim();
      });
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            onPressed: () {
              _searchController.clear();
              Provider.of<ChatProvider>(context, listen: false).searchQuery = '';
            },
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }




  Widget _buildStreamHomeUser() {
    // Extract the current user's UID safely.
    final currentUserUid = _auth.currentUser?.uid ?? '';
    // Trim the search query from the search controller.
    String searchQuery = _searchController.text.trim();
    // Determine the appropriate user stream based on the search query.
    Stream<List<Map<String, dynamic>>> userStream = searchQuery.isEmpty
        ? _chatService.getUserChatsStream()
        : _chatService.searchUserChats(searchQuery);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        // Error handling.
        if (snapshot.hasError) {
          return Center(child: Text("Error Occurred"));
        }
        // Display loading indicator while waiting for the stream.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
          );
        }
        // Handle empty or null data.
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        }

        // Build a list view of the data.
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final userData = snapshot.data![index];
            final userProfile = UserProfile.fromMap(userData);

            // FutureBuilder to fetch and display chat metadata like unread messages.
            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection("chat_meta").doc(_chatService.getChatRoomKey(userProfile.uid ?? '')).get(),
              builder: (context, chatMetaSnapshot) {
                if (chatMetaSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text(userProfile.fullName ?? "Loading..."));
                }

                String lastMsg = "No message yet";
                var unreadCount = 0;
                if (chatMetaSnapshot.hasData && chatMetaSnapshot.data!.exists) {
                  final chatMeta = chatMetaSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                  final lastMessageMap = chatMeta['lastMsg'] as Map<String, dynamic>? ?? {};
                  final String sender = lastMessageMap['sender'] ?? '';
                  lastMsg = lastMessageMap['message'] ?? '';
                  lastMsg = sender == currentUserUid ? "You: $lastMsg" : "${userProfile.fullName}: $lastMsg";

                  // Extract unread message count.
                  final userMetaData = chatMeta[currentUserUid] as Map<String, dynamic>? ?? {};
                  unreadCount = userMetaData['unreadCount'] ?? 0;
                }

                // Build the list tile with user profile and chat metadata.
                return ListTile(
                  leading: userProfile.imgUrl!.isNotEmpty?CircleAvatar(backgroundImage: NetworkImage("${userProfile.imgUrl}"),):Icon(Icons.person),
                  title: Text(userProfile.fullName ?? "Unknown"),
                  subtitle: unreadCount > 0 ? Text("$unreadCount new messages") : Text(lastMsg),
                  onTap: () => Navigator.pushNamed(
                    context,
                    ChatScreen.routeName,
                    arguments: {'userProfile': userProfile, "reportedItemId": chatMetaSnapshot.data?["reportedItemId"]},
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Messages", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black)),
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildStreamHomeUser()),
        ],
      ),
    );
  }
}
