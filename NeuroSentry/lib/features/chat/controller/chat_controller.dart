import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/chat/repository/chat_repository.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository);
});

class ChatController {
  ChatController({required this.chatRepository});
  final ChatRepository chatRepository;

  Future<ChatRoomModel> createOrGetOneToOneChatRoom(
      String otherUserName, bool isConsultant) async {
    return chatRepository.createOrGetOneToOneChatRoom(
        otherUserName, isConsultant);
  }

  Future<ChatRoomModel> createOrGetGroupChatRoom(
      String chatRoomId, String groupName) async {
    return chatRepository.createOrGetGroupChatRooms(chatRoomId, groupName);
  }

  Stream<List<ChatRoomModel>> userChatRooms() {
    return chatRepository.getUserChatRooms();
  }

  Stream<List<MessageModel>> getChatMessages(String chatRoomId) {
    return chatRepository.getChatMessages(chatRoomId);
  }

  Future sendMessage(
      String chatRoomId, MessageModel message, bool isConsultant) async {
    await chatRepository.sendMessage(chatRoomId, message, isConsultant);
  }
}
