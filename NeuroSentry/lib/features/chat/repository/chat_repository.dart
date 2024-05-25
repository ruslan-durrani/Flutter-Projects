import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/message_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatRepository {
  Future<ChatRoomModel> createOrGetOneToOneChatRoom(
      String otherUserName, bool isConsultant) async {
    String userId1 = FirebaseAuth.instance.currentUser!.uid;
    String chatRoomId = constructChatRoomId(userId1, otherUserName);
    String userId2 = otherUserName;

    if (!isConsultant) {
      otherUserName = await getUserName(otherUserName) ?? otherUserName;
    }

    final chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get();
    if (!chatRoomSnapshot.exists) {
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'members': [userId1, userId2],
        'otherUserName': otherUserName,
        'lastMessage': null,
        'timestamp': DateTime.now().toIso8601String(),
        'isGroup': false,
        'isConsultant': isConsultant,
      });
    }

    return ChatRoomModel(
      roomId: chatRoomId,
      memberIds: [userId1, otherUserName],
      lastMessage: null,
      otherMemberName: otherUserName,
      timestamp: DateTime.now(),
      isGroup: false,
      isConsultant: isConsultant,
    );
  }

  Future joinGroup(String groupUid) async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('chats')
        .doc(groupUid)
        .get();
    var data = document.data()! as Map<String, dynamic>;
    List<dynamic> dataList = data['members'] ?? [];
    List<String> members = dataList.whereType<String>().toList();
    if (!members.contains(FirebaseAuth.instance.currentUser!.uid)) {
      members.add(FirebaseAuth.instance.currentUser!.uid);

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(groupUid)
          .update({
        'members': members,
      });
    }
  }

  Stream<List<ChatRoomModel>> getUserChatRooms() {
    final StreamController<List<ChatRoomModel>> controller =
        StreamController<List<ChatRoomModel>>();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) async {
      List<ChatRoomModel> chatRooms = [];
      for (var doc in event.docs) {
        var e = doc.data();
        String? otherUserName = e['otherUserName'];
        if (!e['isConsultant'] && !e['isGroup']) {
          String otherId;
          if (e['members'][0] == userId) {
            otherId = e['members'][1];
          } else {
            otherId = e['members'][0];
          }

          otherUserName = await getUserName(otherId);
        }
        chatRooms.add(ChatRoomModel(
          roomId: e['chatRoomId'],
          memberIds: e['members'].whereType<String>().toList(),
          lastMessage: e['lastMessage'],
          otherMemberName: otherUserName!,
          timestamp: DateTime.parse(e['timestamp']),
          isGroup: e['isGroup'] ?? false,
          isConsultant: e['isConsultant'],
        ));
      }
      controller.add(chatRooms);
    });
    return controller.stream;
  }

  Future<String?> getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['profileName'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ChatRoomModel> createOrGetGroupChatRooms(
      String chatRoomId, String groupName) async {
    String userId1 = FirebaseAuth.instance.currentUser!.uid;

    final chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get();
    if (!chatRoomSnapshot.exists) {
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'members': [userId1],
        'otherUserName': groupName,
        'lastMessage': null,
        'timestamp': DateTime.now().toIso8601String(),
        'isGroup': true,
        'isConsultant': false,
      });
    }

    return ChatRoomModel(
      roomId: chatRoomId,
      memberIds: [userId1],
      lastMessage: null,
      otherMemberName: groupName,
      timestamp: DateTime.now(),
      isGroup: true,
      isConsultant: false,
    );
  }

  String constructChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<void> sendMessage(
      String chatRoomId, MessageModel message, bool isConsultant) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      if (isConsultant) {
        String answer = await fetchAnswer(message.message);
        if (answer.isNotEmpty) {
          MessageModel answerMessage = MessageModel(
            message: answer,
            senderId: 'system',
            isCall: false,
            timestamp: DateTime.now(),
          );
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatRoomId)
              .collection('messages')
              .add(answerMessage.toMap());
        }
      }

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .update({
        'timestamp': DateTime.now().toIso8601String(),
        'lastMessage': message.message,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessageToAi(String chatRoomId, MessageModel message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      String answer = await fetchAnswerFromAi(message.message);
      if (answer.isNotEmpty) {
        MessageModel answerMessage = MessageModel(
          message: answer,
          senderId: 'system',
          isCall: false,
          timestamp: DateTime.now(),
        );
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .add(answerMessage.toMap());
      }

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .update({
        'timestamp': DateTime.now().toIso8601String(),
        'lastMessage': message.message,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchAnswerFromAi(String questionString) async {
    try {

      const String url = 'http://10.0.2.2:5000/predict';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final Map<String, dynamic> requestBody = {
        'message': questionString,
      };
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['response'];
    } catch (e) {
      return '';
    }
  }

  Future<String> fetchAnswer(String questionString) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('messages')
              .where('question', isEqualTo: questionString)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var answerDoc = querySnapshot.docs.first;

        String answer = answerDoc['answer'];

        return answer;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Stream<List<MessageModel>> getChatMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MessageModel.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }
}
