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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<ChatProvider>(context, listen: false).searchQuery = _searchController.text.trim();
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
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        final searchQuery = _searchController.text.trim();
        Stream<List<Map<String, dynamic>>> userStream = searchQuery.isEmpty
            ? _chatService.getUserChatsStream()
            : _chatService.searchUserChats(searchQuery);

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available", style: Theme.of(context).textTheme.bodyMedium));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final userProfile = UserProfile.fromMap(snapshot.data![index]);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userProfile.imgUrl != null && userProfile.imgUrl!.isNotEmpty
                        ? NetworkImage(userProfile.imgUrl!)
                        : null,
                    child: userProfile.imgUrl == null || userProfile.imgUrl!.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  title: Text(userProfile.fullName ?? "Unknown", style: Theme.of(context).textTheme.titleMedium),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: {'userProfile': userProfile},
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
