import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final bool isReceiver;
  final String message;
  final String photoUrl;

  MessageItem({
    super.key,
    required this.isReceiver,
    required this.message,
    this.photoUrl = ""
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: photoUrl.isEmpty ? EdgeInsets.symmetric(horizontal: 10, vertical: 8) : EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: isReceiver ? Colors.grey[300] : Colors.blue[400],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isReceiver ? Radius.circular(0) : Radius.circular(12),
            bottomRight: isReceiver ? Radius.circular(12) : Radius.circular(0),
          ),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: photoUrl.isEmpty ? _buildTextMessage() : _buildImageMessage(),
      ),
    );
  }

  Widget _buildTextMessage() {
    return Text(
      message,
      style: TextStyle(
          fontSize: 16,
          color: isReceiver ? Colors.black87 : Colors.white
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        photoUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Text('Unable to load image');
        },
      ),
    );
  }
}
