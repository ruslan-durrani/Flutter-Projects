import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});
}
