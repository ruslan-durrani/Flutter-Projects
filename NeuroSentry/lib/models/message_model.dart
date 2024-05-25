class MessageModel {
  final String message;
  final String senderId;
  final String? userName;
  final DateTime timestamp;
  final bool isCall;
  final String? roomId;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isCall,
    this.roomId,
    this.userName,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        message: map['message'],
        senderId: map['senderId'],
        userName: map['userName'],
        isCall: map['isCall'] ?? false,
        timestamp: DateTime.parse(map['timestamp']),
        roomId: map['roomId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'userName': userName,
      'isCall': isCall,
      'timestamp': timestamp.toIso8601String(),
      'roomId': roomId,
    };
  }
}
